---
description: phase status check — summarize where we are, draft what's next, wait for approval before acting
argument-hint: "[phase-name | compact | clear]"
---

## invocation modes

**`/senzu [phase-name]`** — phase checkpoint. summarize the completed phase,
draft the next, and wait for approval. issue context carries forward.

**`/senzu`** (no arg) — where are we / what's next. summarize current state and
draft the next action. **phase state takes precedence over issue context** — if a
phase is in progress (grounding has started, facts are established in the session),
produce a fresh summary regardless of whether an issue is filed. only ask "what are
we working on?" on a true cold start (no phase context at all).

> sessions are started via the `senzu <identifier>` CLI, which fetches ticket
> context and injects it into the system prompt, then fires `/senzu` as the
> opening prompt. on session start, read the ticket context from the system
> prompt and begin grounding.

**`/senzu compact`** — write a session state block to `~/.claude/CLAUDE.local.md`, then
prompt the user to run `/compact`. the new session opens with the block already in
context — no wake prompt needed. first `/senzu` in the new session reads it and
resumes cleanly.

**`/senzu clear`** — remove the session state block from `~/.claude/CLAUDE.local.md`.
use this to clean up after an unplanned session end or any time the stashed state
is stale. also fires automatically at learnings → done.

---

## compact + resume

context pressure is the main reason to compact. the failure mode without this
pattern: resume state lives in conversation context, which compact destroys —
leading to cold-start behavior or lost decisions in the new session.

**`/senzu compact` writes this block to `~/.claude/CLAUDE.local.md`:**

```markdown
<!-- senzu:session:start -->
## current session

- **phase:** <current phase>
- **issue:** <repo#issue or "none">
- **branches:** <branch names per repo, or "n/a">
- **decisions:** <key grounding/planning decisions, 3-5 bullets>
- **completed:** <what's been executed so far>
- **phase-progress:** <checklist items completed within the current phase, if mid-phase>
- **next:** <what was queued up>
<!-- senzu:session:end -->
```

`~/.claude/CLAUDE.local.md` is always auto-loaded — the new session sees this immediately,
no manual wake prompt required.

**`/senzu clear` removes the block.** fires automatically at learnings → done.
also available explicitly for stale state or unplanned session ends.

---

## phase model

phases run in order. each phase iterates until fully cleared — don't advance
until the current phase is done. the spec phase is conditional — assess at the
end of grounding whether it's warranted, then skip or run it before planning.

### grounding

surface open questions, analyze for ambiguities, confirm assumptions, align on
nouns/verbs, research the problem space.

- list all open questions explicitly — don't carry them forward unresolved
- identify ambiguities in requirements, scope, or key terms
- confirm assumptions with the user
- align on nouns and verbs — shared vocabulary prevents drift
- research prior art in the codebase (existing patterns, related work)

*exit: no unresolved open questions; key terms and scope agreed*

### spec *(conditional)*

assess whether a tech spec is warranted. if yes: scope, interfaces, data flows,
unknowns, migration path — use the write-product-spec skill. if no: skip to planning.

warranted when: change is cross-team, cross-service, irreversible, or large enough
to need alignment before execution.

- define scope explicitly (what's in, what's out)
- document interfaces (API contracts, data shapes)
- trace data flows end-to-end
- list unknowns and how they'll be resolved
- include migration path if existing behavior changes

*exit: spec document written and agreed, or skip decision confirmed*

### planning

concrete plan with narrative, diffs/examples, expected outcome — no surprises in
execution. includes defining how each piece will be verified during execution.

- write a step-by-step plan with narrative, not just a task list
- include diffs or pseudocode for non-obvious changes
- define verification steps per piece — how will we know each part worked?
- identify rollback path

*exit: plan reviewed and approved; verification steps defined; rollback path identified*

*if issue in context — at planning → execution:*

1. post a grounding + plan summary comment to the issue:
   - what we confirmed in grounding (assumptions, key facts, decisions made)
   - spec decisions if the spec phase ran (scope, interfaces, key unknowns resolved)
   - the plan: what we're doing and why, tradeoffs accepted
   - terse — decisions and rationale only, not a transcript

2. create a branch in each affected repo:
   ```
   git checkout -b <type>/<issue-number>_<slug>
   git push -u origin <type>/<issue-number>_<slug>
   ```
   - `type` follows conventional commits: `feat`, `fix`, `refactor`, `docs`, `chore`
   - `slug` is kebab-case, 3-5 words
   - examples: `refactor/14_nixos-modules-rename`, `docs/9_vlan-trunk-migration`
   - if type is ambiguous, ask before creating
   - for multi-repo work, create a branch in each affected repo and note them
     in the issue comment

### execution

small iterations, conventional commits at each checkpoint. run the verification
steps defined in planning — don't defer correctness checks to the live deploy.

- one logical change per commit, conventional commit message
- run defined verification steps at each checkpoint
- surface blockers immediately — don't work around them silently

*exit: all verification steps passed; no outstanding blockers*

### refinement

make it right — don't just review what was built.

*idiomatic patterns*
- more natural ways to express this in the language/framework?
- follows existing codebase conventions?

*completeness*
- unhappy paths handled?
- edge cases covered?
- error handling present at the right boundaries?

*DRY* *(Pragmatic Programmer)*
- duplicated patterns that should be extracted?
- shared logic centralized or scattered?

*YAGNI / overengineering* *(XP principles)*
- abstraction serving no current requirement?
- solution more complex than the problem warrants?
- dead code paths or unused parameters?

*exit: all sub-sections checked; tradeoffs surfaced and accepted*

### protection

flag it, don't assume it's fine.

*security* *(OWASP Top 10 2021)*
- A01 broken access control — authz gaps, privilege escalation, missing ownership checks
- A02 cryptographic failures — secrets in logs, unencrypted storage, weak algorithms
- A03 injection — SQL, command, template; XSS if rendering user input
- A04 insecure design — missing rate limiting, insecure direct object references
- A05 security misconfiguration — insecure defaults, verbose error responses, unnecessary features enabled
- A06 vulnerable and outdated components — dependency audit, known CVEs
- A07 identification and authentication failures — session management, credential handling, token expiry
- A08 software and data integrity failures — deserialization of untrusted data, CI/CD pipeline integrity
- A09 security logging and monitoring failures — are security events logged and alertable?
- A10 SSRF — if making outbound requests: is the target URL user-controlled?

*resiliency* *(AWS Well-Architected Reliability + SRE)*
- SPOF — what breaks if this component goes down?
- retry behavior — idempotent? backoff with jitter?
- timeout handling — all external calls bounded?
- circuit breaker — protection against cascading failures?
- error propagation — does failure surface correctly or get swallowed?
- graceful degradation — system degrades gracefully under partial failure?
- stateless design — instances replaceable without state loss?
- dependency resilience — behavior if a backing service is unavailable?
- observability — logging, metrics, alerting sufficient to detect and diagnose failures?

*exit: all items assessed; flagged risks acknowledged and accepted or mitigated*

### release/deploy

PR, validation, staged rollout if needed.

- staged rollout if the change has broad blast radius
- run the verification steps from planning against the deployed change
- confirm merge before closing the issue

*if issue in context:*

create a PR for each branch → main:

```
## why
<what problem this solves, what issue it addresses>

## how
<what changed and the key decisions made>

## validation
<how to verify it works — commands, expected output, screenshots>
```

- suggest screenshots where relevant: terminal output, ui state, infra confirmation
- reference the issue (`<repo>#<issue>`) but do NOT use `Closes` — the issue
  is closed manually after learnings
- prefer rebase merge

*exit: PR merged; validation complete*

### learnings

reflect on what worked, what didn't, what to carry forward.

- what went well that should be repeated?
- what went wrong or took longer than expected?
- anything surprising worth carrying forward?

*exit: learnings captured; session closed*

*if issue in context — at learnings → done:*

1. draft a completion comment:
   - what shipped
   - tradeoffs accepted
   - anything surprising or worth carrying forward
   present the draft to the user. they may add, edit, or cut. post only after
   explicit sign-off — never auto-post.

2. close the issue only after the PR is merged. confirm merge before closing.

3. delete each feature branch after merge:
   ```
   git push origin --delete <branch>
   git branch -d <branch>
   ```

4. run `/senzu clear` to remove the session state block from `~/.claude/CLAUDE.local.md`.

---

## behavior

`/senzu` is a status check, not a go-ahead. every invocation follows the same
pattern:

1. **where are we** — summarize the current phase and what's been completed
2. **what's next** — draft the next action or set of actions
3. **wait** — user reviews, adjusts if needed, then explicitly approves before
   anything executes

the user's approval is what triggers action. the /senzu invocation is what
triggers the draft.

this applies universally — code changes, commits, branch creation, github
comments, issue closes. if it's an action, it gets drafted and reviewed first.

if the current phase has outstanding items, surface them and hold. don't advance
until they're cleared.

---

## output format

use this structure exactly (lowercase, terse, no filler):

---
**phase complete: <name>**

- <what was accomplished, 2-4 bullets, terse>

**next: <name>** — <one sentence on what this phase covers>
---

for a skipped conditional phase, inline the skip rather than announcing a phase:

---
**phase complete: grounding**

- <bullets>

**spec: skipping** — <one-line reason> → **next: planning** — <one sentence>
---

then draft the first action for the next phase and wait for approval.
