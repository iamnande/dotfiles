---
description: phase status check -- summarize where we are, draft what's next, wait for approval before acting
argument-hint: "[phase-name | compact | clear]"
gh-default-org: iamnande
---

## invocation modes

**`/senzu [phase-name]`** -- phase checkpoint. summarize the completed phase,
draft the next, and wait for approval. issue context carries forward.

**`/senzu`** (no arg) -- where are we / what's next. summarize current state
and draft the next action. **phase state takes precedence over issue context**
-- if a phase is in progress (grounding has started, facts are established in
the session), produce a fresh summary regardless of whether an issue is filed.
only ask "what are we working on?" on a true cold start (no phase context at
all).

> sessions are started via the `senzu <identifier>` CLI, which fetches ticket
> context and injects it into the system prompt, then fires `/senzu` as the
> opening prompt. on session start, read the ticket context from the system
> prompt and begin grounding.

**`/senzu compact`** -- write a session state block to
`~/.claude/CLAUDE.local.md`, then prompt the user to run `/compact`. the new
session opens with the block already in context -- no wake prompt needed. first
`/senzu` in the new session reads it and resumes cleanly.

**`/senzu clear`** -- remove the session state block from
`~/.claude/CLAUDE.local.md`. use this to clean up after an unplanned session
end or any time the stashed state is stale. also fires automatically at
learnings -> done.

---

## compact + resume

context pressure is the main reason to compact. the failure mode without this
pattern: resume state lives in conversation context, which compact destroys --
leading to cold-start behavior or lost decisions in the new session.

**`/senzu compact` writes this block to `~/.claude/CLAUDE.local.md`:**

```markdown
<!-- senzu:session:start -->
## current session

- **phase:** <current phase>
- **issue:** <identifier -- repo#N, PROJ-123, or "none">
- **branches:** <branch names per repo, or "n/a">
- **decisions:** <key grounding/planning decisions, 3-5 bullets>
- **completed:** <what's been executed so far>
- **phase-progress:** <checklist items completed within current phase, if mid-phase>
- **next:** <what was queued up>
- **discussion-id:** <D_... node id -- only when issue is a gh discussion>
- **task-thread:** <DC_... comment id of active task -- only when established>
<!-- senzu:session:end -->
```

`~/.claude/CLAUDE.local.md` is always auto-loaded -- the new session sees this
immediately, no manual wake prompt required.

**`/senzu clear` removes the block.** fires automatically at learnings -> done.
also available explicitly for stale state or unplanned session ends.

---

## phase model

phases run in order. each phase iterates until fully cleared -- don't advance
until the current phase is done. the spec phase is conditional -- assess at the
end of grounding whether it's warranted, then skip or run it before planning.

### grounding

know the terrain before moving. surface open questions, analyze for
ambiguities, confirm assumptions, align on nouns/verbs, research the problem
space.

- list all open questions explicitly -- don't carry them forward unresolved
- identify ambiguities in requirements, scope, or key terms
- confirm assumptions with the user
- align on nouns and verbs -- shared vocabulary prevents drift
- research prior art in the codebase (existing patterns, related work)

*exit: no unresolved open questions; key terms and scope agreed*

*if issue in context:* post phase start and phase end to task-thread.
see [## discussion log].

### spec *(conditional)*

assess whether a tech spec is warranted. if yes: scope, interfaces, data flows,
unknowns, migration path -- use the write-product-spec skill. if no: skip to
planning.

warranted when: change is cross-team, cross-service, irreversible, or large
enough to need alignment before execution.

- define scope explicitly (what's in, what's out)
- document interfaces (API contracts, data shapes)
- trace data flows end-to-end
- list unknowns and how they'll be resolved
- include migration path if existing behavior changes

*exit: spec document written and agreed, or skip decision confirmed*

*if issue in context:* post phase start and phase end (or skip notification)
to task-thread. see [## discussion log].

### planning

planning runs in two mandatory sub-gates. execution must not begin until both
artifacts are committed to the target repo.

**sub-gate 1 -- PRD:**

fill `templates/prd.md` for the current work. write to
`plan/<YYYY-MM-DD>_<slug>/prd.md` in the target repo. show git diff, wait for
explicit approval, then commit with
`git add -f plan/<YYYY-MM-DD>_<slug>/prd.md` (`plan/` is gitignored). PRD must
be committed before tech spec drafting begins.

- all sections must be present; inapplicable sections marked `N/A -- <reason>`,
  never dropped
- requirements block must enumerate at least one Rn entry
- `<YYYY-MM-DD>` is the session date; `<slug>` is kebab-case, 3-5 words

**sub-gate 2 -- tech spec:**

fill `templates/tech-spec.md` for the current work. write to
`plan/<YYYY-MM-DD>_<slug>/tech-spec.md` in the target repo. show git diff,
wait for explicit approval, then commit with
`git add -f plan/<YYYY-MM-DD>_<slug>/tech-spec.md`. tech spec must be
committed before execution begins.

- all sections must be present; inapplicable sections marked `N/A -- <reason>`,
  never dropped
- Requirements Coverage table must map every Rn from the PRD to at least one
  section

*exit: both artifacts committed; all Rn entries defined; verification steps
and rollback path identified*

*if issue in context -- at planning -> execution:*

1. post phase start and phase end to task-thread. see [## discussion log].

2. create a branch in each affected repo:
   ```
   git checkout -b <type>/<issue-slug>_<slug>
   git push -u origin <type>/<issue-slug>_<slug>
   ```
   - `type` follows conventional commits: `feat`, `fix`, `refactor`, `docs`,
     `chore`
   - `issue-slug`: discussion number (e.g. `13`) or linear ticket id (e.g.
     `ENG-42`) -- linear ids are self-identifying, bare numbers are fine for gh
   - `slug` is kebab-case, 3-5 words
   - examples: `feat/13_zellij-setup`, `fix/ENG-42_auth-timeout`
   - if type is ambiguous, ask before creating
   - for multi-repo work, create a branch in each affected repo

### execution

do the work. one thing, then the next. small iterations, conventional commits
at each checkpoint. run the verification steps defined in planning -- don't
defer correctness checks to the live deploy.

- one logical change per commit, conventional commit message
- run defined verification steps at each checkpoint
- surface blockers immediately -- don't work around them silently
- before any `git add`: explicitly state which changed files belong to which
  commit and why. before any `--amend`: run `git log --oneline` to confirm
  which commit is HEAD.

*exit: all verification steps passed; no outstanding blockers*

*if issue in context:* post phase start and phase end to task-thread. post a
reply at each checkpoint commit (commit message + what it achieves).
see [## discussion log].

### refinement

make it right -- don't just review what was built.

*idiomatic patterns*
- more natural ways to express this in the language/framework?
- follows existing codebase conventions?

*completeness*
- unhappy paths handled?
- edge cases covered?
- error handling present at the right boundaries?

*DRY (Pragmatic Programmer)*
- duplicated patterns that should be extracted?
- shared logic centralized or scattered?

*YAGNI / overengineering (XP principles)*
- abstraction serving no current requirement?
- solution more complex than the problem warrants?
- dead code paths or unused parameters?

*requirements coverage*
- walk each Rn from the PRD -- is it implemented?
- walk each Rn -- is there a test or manual verification step covering it?
- surface any Rn with no implementation or no coverage as a blocker

*exit: all sub-sections checked; all Rn entries confirmed implemented and
covered; tradeoffs surfaced and accepted*

*if issue in context:* post phase start and phase end to task-thread.
see [## discussion log].

### protection

flag it, don't assume it's fine.

**default approach:** spawn 3-5 parallel sub-agents. anchor reviewer
perspectives to the in-scope tech spec sections (core logic, interfaces,
validation, integration tests) -- skip any marked N/A. add security/resilience
as a constant regardless of scope. synthesize findings, separate signal from
noise, and surface only actionable items for resolution. do not wait to be
asked -- parallel agents are the default for this phase on any non-trivial
code change.

*security (OWASP Top 10)*
- A01 broken access control -- authz gaps, privilege escalation, missing
  ownership checks
- A02 cryptographic failures -- secrets in logs, unencrypted storage, weak
  algorithms
- A03 injection -- SQL, command, template; XSS if rendering user input
- A04 insecure design -- missing rate limiting, insecure direct object
  references
- A05 security misconfiguration -- insecure defaults, verbose error responses,
  unnecessary features enabled
- A06 vulnerable and outdated components -- dependency audit, known CVEs
- A07 identification and authentication failures -- session management,
  credential handling, token expiry
- A08 software and data integrity failures -- deserialization of untrusted
  data, CI/CD pipeline integrity
- A09 security logging and monitoring failures -- are security events logged
  and alertable?
- A10 SSRF -- if making outbound requests: is the target URL user-controlled?

*resiliency (AWS Well-Architected Reliability + SRE)*
- SPOF -- what breaks if this component goes down?
- retry behavior -- idempotent? backoff with jitter?
- timeout handling -- all external calls bounded?
- circuit breaker -- protection against cascading failures?
- error propagation -- does failure surface correctly or get swallowed?
- graceful degradation -- system degrades gracefully under partial failure?
- stateless design -- instances replaceable without state loss?
- dependency resilience -- behavior if a backing service is unavailable?
- observability -- logging, metrics, alerting sufficient to detect and diagnose
  failures?

*exit: all items assessed; flagged risks acknowledged and accepted or mitigated*

*if issue in context:* post phase start and phase end to task-thread.
see [## discussion log].

### release/deploy

PR, validation, staged rollout if needed.

- staged rollout if the change has broad blast radius
- direct-to-main is valid for personal/low-blast-radius work -- no PR required
- run the verification steps from planning against the deployed change

*if issue in context:*

for branch-based work, create a PR for each branch -> main:

```
## why
<what problem this solves, what issue it addresses>

## how
<what changed and the key decisions made>

## validation
<how to verify it works -- commands, expected output, screenshots>
```

- suggest screenshots where relevant: terminal output, ui state, infra
  confirmation
- reference the issue but do NOT use `Closes` -- the thread is closed manually
- prefer rebase merge
- prose paragraphs must not be hard-wrapped in PR bodies
- if CI exists: wait ~2 minutes after PR creation, then poll for automated
  review comments. address any open comments before declaring phase complete.

post phase start and phase end to task-thread. see [## discussion log].

*exit: changes merged or pushed; validation complete*

### learnings

carry what matters. discard the rest.

- what went well that should be repeated?
- what went wrong or took longer than expected?
- anything surprising worth carrying forward?

*exit: learnings captured; session closed*

*if issue in context:*

1. draft a final reply on the task-thread:
   - what shipped
   - tradeoffs accepted
   - anything surprising or worth carrying forward
   present the draft to the user. they may add, edit, or cut. post only after
   explicit sign-off -- never auto-post.

2. for linear: close the issue only after the PR is merged. confirm merge
   before closing.
   for gh discussions: no close. the thread stays open as a living log.

3. delete each feature branch after merge:
   ```
   git push origin --delete <branch>
   git branch -d <branch>
   ```

4. run `/senzu clear` to remove the session state block from
   `~/.claude/CLAUDE.local.md`.

---

## discussion log

the record is honest or it is useless. when an issue is in context, every
phase is logged to the task-thread. prefer more detail over less -- this is
the project record.

**cadence:** post at phase start and phase end. for execution, also post at
each checkpoint commit. additional replies for significant findings, decisions,
or blockers are always welcome.

**phase start reply:**
```
phase: <name> -- started
<one sentence on what this phase covers>
```

**phase end reply:**
```
phase: <name> -- complete
<key outcomes, decisions made, what was resolved>
```

**execution checkpoint reply:**
```
checkpoint: <conventional commit message>
<what this achieves; any notable decisions>
```

**learnings / final reply:**
```
done.
shipped: <what went out>
tradeoffs: <what was accepted>
notes: <anything worth carrying forward>
```

keep replies terse and factual. this is a log, not a narrative.

---

## issue routing

the `issue` field in session state determines how posting is handled. detect
the type from the identifier format:

| format | example | route |
|---|---|---|
| `owner/repo#N` | `iamnande/iamnande#13` | github discussions |
| `repo#N` | `iamnande#13` | github discussions (org from `gh-default-org`) |
| `PROJ-NNN` | `ADMIN-3000` | linear |
| `none` | | no posting |

if `repo#N` is used and `gh-default-org` is not set in front matter, error:
`gh-default-org not configured -- use owner/repo#N form instead`

---

## github discussions

**resolve discussion node id** (once per session -- cache as `discussion-id`
in session state):
```bash
gh api graphql -F query='
  query($owner: String!, $repo: String!, $number: Int!) {
    repository(owner: $owner, name: $repo) {
      discussion(number: $number) { id }
    }
  }' -F owner=OWNER -F repo=REPO -F number=NUMBER
```

**post new top-level comment** (new task -- at planning -> execution start):
```bash
gh api graphql -F query='
  mutation($did: ID!, $body: String!) {
    addDiscussionComment(input: {discussionId: $did, body: $body}) {
      comment { id }
    }
  }' -F did='D_...' -F body='...'
```
capture the returned comment `id` -- store as `task-thread` in session state.

**post reply** (all subsequent phase posts):
```bash
gh api graphql -F query='
  mutation($did: ID!, $rid: ID!, $body: String!) {
    addDiscussionComment(input: {discussionId: $did, replyToId: $rid, body: $body}) {
      comment { id }
    }
  }' -F did='D_...' -F rid='DC_...' -F body='...'
```
`rid` is the `task-thread` id from session state.

**session state fields:**
- `discussion-id` -- resolved once, reused for all posts in the session
- `task-thread` -- the active task's top-level comment id; established at
  planning -> execution, restored from compact on resume

---

## behavior

`/senzu` is a status check, not a go-ahead. every invocation follows the same
pattern:

1. **where are we** -- summarize the current phase and what's been completed
2. **what's next** -- draft the next action or set of actions
3. **wait** -- user reviews, adjusts if needed, then explicitly approves
   before anything executes

the user's approval is what triggers action. the /senzu invocation is what
triggers the draft.

this applies universally -- code changes, commits, branch creation, discussion
posts. if it's an action, it gets drafted and reviewed first.

if the current phase has outstanding items, surface them and hold. don't
advance until they're cleared.

**phase progression does not require a /senzu invocation.** after an approved
action executes cleanly, immediately announce the result and propose the next
step. /senzu is a status check and explicit checkpoint -- not the gate for
every transition. waiting silently for the user to prompt the next phase is
the wrong default.

---

## output format

use this structure exactly (lowercase, terse, no filler):

---
**phase complete: <name>**

- <what was accomplished, 2-4 bullets, terse>

**next: <name>** -- <one sentence on what this phase covers>
---

for a skipped conditional phase, inline the skip rather than announcing a
phase:

---
**phase complete: grounding**

- <bullets>

**spec: skipping** -- <one-line reason> -> **next: planning** -- <one sentence>
---

**learnings format:**

---
**phase complete: learnings**

- what went well: <1-2 bullets>
- what didn't: <1-2 bullets>
- carry forward: <1-2 bullets>

**session closed.**
---

then draft the final task-thread reply for user approval before posting.
