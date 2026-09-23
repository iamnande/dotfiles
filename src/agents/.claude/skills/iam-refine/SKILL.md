---
name: iam-refine
description: senzu phase 3. makes the branch right: idiom, completeness, DRY/YAGNI, requirements coverage, security, resilience.
argument-hint: "[<slug>] [fanout]"
disable-model-invocation: true
---

# refine

make it right, don't just review what was built. flag risks; don't assume a path is fine.

## rules

- draft each action (code change, commit, push, PR change, comment, close) and wait for explicit approval. after an approved action succeeds, report it and propose the next one.
- never post to github, linear, or slack without sign-off on the exact text.
- surface blockers at once. don't work around them.
- phase too big for one session: at a clean checkpoint, update the state file and hand off to the same skill.
- before `git add`, say which files go in which commit and why. before `--amend`, check `git log --oneline` for HEAD.

## start

state: `~/opord/senzu/<slug>.md`. slug from the argument, else the issue id or slug in the current branch name (ignore case), else ask. review the branch diff against its base, with the tech spec and the PRD's Rn list.

## check

- idiom: natural for the language and framework? matches codebase conventions?
- completeness: unhappy paths, edge cases, errors handled at the right boundary?
- DRY: duplicated logic that belongs in one place?
- YAGNI: abstractions no requirement needs, dead paths, unused params, more complex than the problem?
- requirements: every Rn implemented, and covered by a test or a manual check. a gap is a blocker.
- security: OWASP top 10 (2021) for what the diff touches.
- resilience: bounded timeouts, idempotent retries with backoff and jitter, errors surfaced not swallowed, behavior when a dependency is down, enough logs and metrics to diagnose a failure.

## how

- review in this session. no subagents by default.
- `fanout` argument, or on request for a high-risk change: at most 2 subagents, one scope each (e.g. security, resilience). give each only the diff and the relevant tech spec sections. each returns at most 10 findings, with file:line and a concrete failure.
- check every finding against the current code before showing it. drop noise.
- show one list, most severe first. user picks fix, accept, or drop per item. record accepted tradeoffs in state `## decisions`.

exit: every finding fixed or accepted; every Rn implemented and covered.

## handoff

update the state file (phase, next, decisions, one `## log` line), then:

**phase complete: refine**
- <2-4 terse bullets>

**next: /iam-pr** (<one line>). run `/clear` first.

if state has `slack`, also draft a one-line reply for that thread: `<phase> done: <outcome>. next: <phase>`, PR links inline. post it only when the user says post.
