---
name: iam-refine
description: senzu phase 3. makes the branch right: idiom, completeness, DRY/YAGNI, requirements coverage, security, resilience, callers, deploy compatibility.
argument-hint: "[<slug>] [fanout | delta]"
disable-model-invocation: true
---

# refine

make it right, don't just review what was built. assume a model wrote most of this change: it compiles, reads well, its tests pass, and it still hides defects. treat every claim in the PR body, comments, and test names as unverified. try to prove the change wrong.

## rules

- draft each action (code change, commit, push, PR change, comment, close) and wait for explicit approval. after an approved action succeeds, report it and propose the next one.
- never post to github, linear, or slack without sign-off on the exact text.
- surface blockers at once. don't work around them.
- phase too big for one session: at a clean checkpoint, update the state file and hand off to the same skill.
- before `git add`, say which files go in which commit and why. before `--amend`, check `git log --oneline` for HEAD.

## start

state: `~/src/iamnande/senzu/beans/<slug>.md`. slug from the argument, else the issue id or slug in the current branch name (ignore case), else ask. review the branch diff against its base, with the tech spec and the PRD's Rn list.

## check

- idiom: natural for the language and framework? matches codebase conventions?
- completeness: unhappy paths, edge cases, errors handled at the right boundary?
- DRY: duplicated logic that belongs in one place?
- YAGNI: abstractions no requirement needs, dead paths, unused params, more complex than the problem?
- requirements: every Rn implemented, and covered by a test or a manual check. a gap is a blocker.
- security: OWASP top 10 (2021) for what the diff touches. auth and scope checks fail closed.
- resilience: bounded timeouts, idempotent retries with backoff and jitter, errors surfaced not swallowed, behavior when a dependency is down, enough logs and metrics to diagnose a failure.
- callers: every caller of a changed function, rpc, proto field, config key, or query, including other services, cron jobs, consumers, and cli tools. a change correct for the caller the author had in mind can break another. copied precedents count as callers.
- deploy: old and new binaries run side by side. proto changes are additive. migrations work with the code already deployed. reverting code doesn't require reverting data.
- boundaries: nil, empty, zero, max, duplicate, a value from another account, unicode or url-unsafe characters, a list longer than one page, a missing optional field.
- errors: every changed error condition has text that says what to do. user-correctable errors aren't 500s. a changed status code is intended, not a side effect.
- docs: grep docs, protos, and comments for claims the change makes false (end state, defaults, "not supported" lines).
- generated and mirrored files: regenerated or updated in the same change.
- tests: every new test has a named red line (see iam-execute). a test that asserts a constant against its own copy, or that a mock got the value the test passed in, is decoration.

## how

- review in this session. no subagents by default.
- `fanout` argument, or on request for a high-risk change: at most 2 subagents, one scope each (e.g. security, deploy). give each only the diff and the relevant tech spec sections. each returns at most 10 findings, with file:line and a concrete failure.
- a finding needs a trigger (the input, state, or sequence), the wrong behavior, and the test that would go red. no trigger means it's a question, listed apart from findings.
- before showing a finding, try to refute it: look for the guard, the caller-side check, or the test that makes it harmless. check it against the current code. drop noise.
- show one list, most severe first. user picks fix, accept, or drop per item. record accepted tradeoffs in state `## decisions`.
- end with one line naming the categories checked and clean. name any category skipped.

## delta

`/iam-refine delta` runs after refine has exited, on the changes since then.

- the delta is every commit added since the head state recorded when refine exited. a commit that is a pure rebase (same patch-id) isn't a delta.
- trivial deltas skip refine: comments, docs, or generated files only, with no behavior change and no claim moved. a docs change that moves a claim is non-trivial.
- a P/R decision entry that changes behavior, with no code change, gets only the docs grep for the claim it changed.
- same checks, scoped to the delta's hunks and their callers. read the contract (sql, filters, errors) of anything a fix newly calls.
- runs in-session, one pass over the delta. no subagents unless `fanout` is passed.
- run the repo's lint and the targeted tests at each non-trivial delta tip.
- record the new head and the result in state `## log`.

exit: every finding fixed or accepted; every Rn implemented and covered; the delta (if any) passes.

## handoff

update the state file (phase, next, decisions, one `## log` line), then:

**phase complete: refine**
- <2-4 terse bullets>

**next: /iam-pr** (<one line>). run `/clear` first.

if state has `slack`, also draft a one-line reply for that thread: `<phase> done: <outcome>. next: <phase>`, PR links inline. post it only when the user says post.
