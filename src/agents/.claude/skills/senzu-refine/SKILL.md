---
name: senzu-refine
description: senzu phase 3. makes the branch right: idiom, completeness, DRY/YAGNI, requirements coverage, security, resilience, callers, deploy compatibility.
argument-hint: "[<slug>] [fanout | delta]"
disable-model-invocation: true
---

# refine

make it right, don't just review what was built. assume a model wrote most of this change: it compiles, reads well, its tests pass, and it still hides defects. treat every claim in the PR body, comments, and test names as unverified. try to prove the change wrong.

## rules

- commits, pushes, PRs, merges and branch deletes are the user's. make one commit-sized change, leave it unstaged, say in a few lines what changed and why and which files go in which commit, then stop.
- draft each outward action (comment, post, close) and wait for explicit approval. after an approved action succeeds, report it and propose the next one.
- beans, worktrees and other reversible non-git steps: do them, then say so.
- never post to github, linear, or slack without sign-off on the exact text.
- surface blockers at once. don't work around them.
- phase too big for one session: at a clean checkpoint, update the state file and hand off to the same skill.
- the state file is json. after each write, `senzu check` prints `ok`.

## start

on a resumed bean, the first reply is a recap, one line each: the goal, where we are, what is next and why. never assume the user remembers the plan.

state: the bean `<slug>`. read it with `senzu show <slug>`; its file is `.path` in `senzu show <slug> --json`. slug from the argument, else the issue id or slug in the current branch name (ignore case), else ask. the rfc is the `path` of the `rfc` attachment in `senzu show <slug> --json`, or the rfc PR named in `decisions`. the commit layout and pr stack are the draft `stack`. review the branch diff against its base, with the rfc's rules and their checks.

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
- tests: every new test has a named red line (see senzu-execute). a test that asserts a constant against its own copy, or that a mock got the value the test passed in, is decoration.

## how

- review in this session. no subagents by default.
- `fanout` argument, or on request for a high-risk change: at most 2 subagents, one scope each (e.g. security, deploy). give each only the diff and the relevant rfc sections. each returns at most 10 findings, with file:line and a concrete failure.
- a finding needs a trigger (the input, state, or sequence), the wrong behavior, and the test that would go red. no trigger means it's a question, listed apart from findings.
- before showing a finding, try to refute it: look for the guard, the caller-side check, or the test that makes it harmless. check it against the current code. drop noise.
- sort each finding into a bucket. no per-item question:
  - must fix: trigger reproduced, and the diff adds it or makes it worse (code, or a docs claim the diff makes false). fix it.
  - may fix: a nit in the diff's own hunks, a few lines, no behavior change. fix it.
  - out of branch: pre-existing, the diff didn't touch it. one line on a bean, never fixed here.
  - falls away: no trigger, or a decision in state already covers it. one line in the `log`.
- a fix that changes behavior or a contract past the finding is the user's call: stop and ask.
- show one list, most severe first, with each bucket and what was done. then one delta pass over the fix hunks: only must-fix counts there, nits drop. a must-fix on that pass is a blocker for the user, never a third round.
- end with one line naming the categories checked and clean. name any category skipped.

## delta

`/senzu-refine delta` runs after refine has exited, on the changes since then.

- the delta is every commit added since the head state recorded when refine exited. a commit that is a pure rebase (same patch-id) isn't a delta.
- trivial deltas skip refine: comments, docs, or generated files only, with no behavior change and no claim moved. a docs change that moves a claim is non-trivial.
- a P/R decision entry that changes behavior, with no code change, gets only the docs grep for the claim it changed.
- same checks, scoped to the delta's hunks and their callers. read the contract (sql, filters, errors) of anything a fix newly calls.
- runs in-session, one pass over the delta. no subagents unless `fanout` is passed.
- run the repo's lint and the targeted tests at each non-trivial delta tip.
- record the new head and the result in state `log`.

exit: every must-fix and may-fix fixed, and the fix pass clean; every Rn implemented and covered; the delta (if any) passes.

## handoff

update the state file (phase, next, decisions, one `log` entry), then:

**phase complete: refine**
- <2-4 terse bullets>

**next: /senzu-pr** (<one line>). run `/clear` first.

if state has `thread` and `senzu config` sets `thread_channel`, also draft a one-line reply for that thread: `<phase> done: <outcome>. next: <phase>`, PR links inline. post it only when the user says post.
