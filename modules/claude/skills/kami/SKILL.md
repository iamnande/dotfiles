---
description: PR review skill — fan out parallel agents, draft conventional comments in nick's voice, gate per comment, stage to a pending review. never auto-posts.
argument-hint: "[<pr> | resume | compact | clear] [--mode review|self] [--gate walk|batch]"
---

## invocation modes

**`/kami <pr>`** — start a review session on a PR. `<pr>` is `<owner>/<repo>#<num>`, a full PR URL, or omitted (skill infers from the current branch's upstream PR).

**`/kami`** (no arg) — where are we / what's next. if a kami session block is present in `~/.claude/CLAUDE.local.md`, resume from it. otherwise, ask which PR.

**`/kami compact`** — write a session state block to `~/.claude/CLAUDE.local.md`, then prompt the user to run `/compact`. mirrors `/senzu compact`.

**`/kami clear`** — remove the session state block. fires automatically at close → done.

**flags:**

* `--mode review` (default) — review someone else's PR; output is a pending review staged via gh api.
* `--mode self` — review your own branch pre-push vs. its base; output is a local markdown punch-list, no pending review.
* `--gate walk` (default) — present each draft for keep/drop/reword/merge.
* `--gate batch` — present all drafts in one scan-and-pick pass. switchable mid-session with the `batch` / `walk` keywords.

---

## compact + resume

session state block written to `~/.claude/CLAUDE.local.md`:

```markdown
<!-- kami:session:start -->
## current kami session

- **pr:** <owner>/<repo>#<num>@<head_sha>
- **mode:** review | self
- **phase:** <current phase>
- **pending_review_id:** <id or "none">
- **findings:** <counts by severity, e.g. "2 blocker, 4 high, 1 nit">
- **gate_mode:** walk | batch
- **drift_log:** <commits observed since anchor>
- **next:** <queued action>
<!-- kami:session:end -->
```

new session reads it, resumes from `phase`, re-validates against current PR head SHA before continuing.

---

## design principles (load-bearing rules)

these are not guidelines. they're the contract.

1. **never post any comment or review without explicit per-comment user approval.** including auto-stage to a pending review. user types `keep` / `drop` / `reword` / `merge` per draft. nothing else triggers a post.
2. **never trust agent-reported file:line.** every draft re-grep's its citation against current HEAD before being presented. if the line no longer exists, the finding is dropped (not silently re-anchored). if it moved within ±3 lines, fuzzy-anchor and flag for review.
3. **fail-loud on state drift.** wrong branch, dirty working tree, moved SHA all halt the session and surface the discrepancy. never silently continue against stale state.
4. **compose, don't reinvent.** reuse senzu's status-check-propose-wait-approve rhythm verbatim. reuse `/senzu compact` envelope for resume.
5. **scope-adaptive agents, not a fixed roster.** pick agents based on what the PR actually touches. always include security + resilience + idiomatic. add crypto / infra / db / observability scopes as PR content warrants.
6. **zero attribution.** no "generated with claude" footers, no co-authored-by trailers, no meta-references to the assistant in any output (PR comments, slack drafts, commit messages, anywhere).

---

## phase model

phases run in order. each phase iterates until cleared. don't advance until current phase is done.

### anchor

establish ground truth before doing anything else.

* `gh pr view <pr> --json headRefOid,headRefName,baseRefName,title,body,state,mergeable`
* capture `head_sha` as the session's pinned SHA
* `git rev-parse HEAD` must equal `head_sha`; if not, offer `gh pr checkout <pr>` and halt until user confirms
* `gh auth status` must return OK
* refuse to start if PR state is `MERGED` (offer retro mode read-only); allow `CLOSED` for retro

*exit: pinned SHA captured, working tree matches, gh auth OK*

### fan-out

derive the agent scope list from the PR diff, then dispatch in parallel.

* `gh pr diff <pr>` for the unified diff
* heuristics on file paths and content:
  * always: `security`, `resilience`, `idiomatic`
  * JWT / crypto / token paths: add `crypto`
  * `*.sql`, `migrations/`, `sqlc.yaml`: add `db-migration`
  * `*.tf`, `helm/`, `k8s/`, charts: add `infra`
  * proto changes: consider adding an api-contract scope
* spawn 3-5 Agent tool calls in a single message (parallel). each agent gets:
  * the PR identifier + head SHA
  * the diff scope it owns
  * an explicit instruction to report findings as `severity / file:line / issue / why / fix`
  * a directive that line numbers must be against the head SHA, and to re-grep before citing
* agent prompts live in `templates/agent-prompts/<scope>.md`

*exit: 3-5 agents back with findings; none failed*

### synthesize

dedupe, drop noise, re-anchor citations.

* **dedupe:** same file:line OR same issue description → merge into one finding, union the suggested fixes
* **drop dependency-testing findings:** heuristic — if a finding asserts library invariants (singleflight coalescing, hashmap thread safety, stdlib semantics) it's testing the dep, not the code. drop with a note
* **re-anchor:** for each surviving finding, `grep -n` the cited pattern against current HEAD. if absent: drop. if moved within ±3 lines: fuzzy-anchor and flag. if moved >3 lines: drop and log under drift
* **severity-tier:** blocker / high / medium / nit
* findings now have verified file:line + agreed severity

*exit: all surviving findings carry a verified citation*

### draft

generate a conventional-comments body per finding.

* load voice rules and conventional-comments format from `templates/comment-formats.md` and memory
* per finding, draft body uses:
  * label: `issue` / `suggestion` / `question` / `nitpick` / `praise` / `thought`
  * decoration: `(blocking)`, `(non-blocking)`, `(if-minor)` as appropriate
  * tone: nick's voice (lowercase, casual, no em dashes, `*` bullets, "could we" / "i'd want" phrasings)
  * length: 1-4 lines per comment, max
* if a finding doesn't anchor to any specific line (cross-cutting), generate a top-level PR comment draft and flag it for the user to confirm placement

*exit: every finding has a draft body*

### gate

present drafts. wait for per-comment user action.

* in `walk` mode: present one draft at a time with `[keep] [drop] [reword] [merge with N]`
* in `batch` mode: dump all remaining drafts in a numbered list, user replies with cuts
* user can switch mid-session: `batch` or `walk` keyword
* every approved draft stays queued in `findings` with `status: approved`; drops and merges are recorded
* user can re-open a previously-resolved draft

*exit: every finding is `approved`, `dropped`, or `merged-into-N`*

### drift loop

before exiting gate to stage: refresh-and-resurface.

* `gh pr view <pr> --json headRefOid` again
* if `headRefOid` matches the session's pinned SHA: skip to stage
* if changed:
  * `git fetch origin <head_branch> && git checkout <head_branch>` to align working tree with the new head
  * for each approved finding, `git diff <old_sha>..<new_sha> -- <finding.file>` to check overlap
  * mark findings whose code changed as `needs-revalidation`; re-grep their citation; drop if gone, fuzzy-anchor if moved
  * scan the diff for *new* lines that fall in scope of any agent; if so, surface a fresh fan-out limited to the delta
  * present the drift summary: `addressed / still-live / new`, gate per-new-finding per usual rules
  * update the session's pinned SHA to the new head

*exit: drift reconciled, pinned SHA bumped, all findings still `approved` or `needs-revalidation-resolved`*

### stage

push each approved finding to the user's pending review on the PR.

* `gh api repos/<owner>/<repo>/pulls/<num>/reviews` — find existing pending review (state `PENDING`, author = current user) or note its absence
* for each approved finding:
  * `gh api repos/<owner>/<repo>/pulls/<num>/comments` with `body`, `commit_id` (pinned SHA), `path`, `line`, `side` — auto-attaches to the pending review (creates one if none exists)
  * for top-level (non-line-anchored) drafts, the user already confirmed placement during gate; post as the pending review's `body` via `gh api .../reviews` with `event=PENDING`
* readback: `gh api repos/<owner>/<repo>/pulls/<num>/reviews/<pending_id>/comments` — confirm every approved finding made it
* **never** post `event=COMMENT` or `event=APPROVE` or `event=REQUEST_CHANGES` — that's the user's manual submit in the GitHub UI

*exit: every approved finding visible in the pending review readback*

### close

summarize and clear state.

* print: `findings shipped`, `dropped (with reasons)`, `deferred to follow-up`
* if a slack thread is attached to this work (e.g. #myspace-nick), offer a brief thread reply with the shipped/dropped counts (user must approve before post)
* clear the session state block from `~/.claude/CLAUDE.local.md`
* remind the user: **submit the pending review in the GitHub UI** when ready — kami won't do that for you

*exit: session state cleared, summary printed*

---

## self-review mode (`--mode self`)

same anchor + fan-out + synthesize + draft phases, but:

* anchor pins the current branch's HEAD, not a PR head
* fan-out runs against `git diff <base>..HEAD` instead of a PR diff
* draft output is a markdown punch-list, not pending-review comments
* no gate (presentation), no drift loop, no stage
* close summary names the file the punch-list was written to (default: `~/kami-selfreview-<branch>-<timestamp>.md`)

---

## behavior

`/kami` is a status check, not a go-ahead. every invocation follows the same pattern:

1. **where are we** — summarize the current phase and what's been completed
2. **what's next** — draft the next action or set of actions
3. **wait** — user reviews, adjusts if needed, then explicitly approves before anything executes

approval triggers action. invocation triggers draft. this applies universally.

**phase progression does not require a /kami invocation.** after an approved action executes cleanly, immediately announce the result and propose the next step. /kami is a status check and explicit checkpoint, not the gate for every transition.

---

## output format

use this structure exactly (lowercase, terse, no filler):

---
**phase complete: <name>**

* <what was accomplished, 2-4 bullets, terse>

**next: <name>** — <one sentence on what this phase covers>
---

then draft the first action for the next phase and wait for approval.

---

## prior art

* `/senzu` — the writing-code counterpart. shares the status-check rhythm, compact/resume primitive, and discipline rules.
* memory: `feedback_no_ai_attribution.md`, `feedback_formatting.md`, `feedback_senzu_workflow.md`.
