---
name: iam-pr
description: senzu phase 4. opens draft PRs with /pr-body, gets copilot review, replies to and resolves threads, marks PRs ready.
argument-hint: "[<slug>]"
disable-model-invocation: true
---

# pr

one PR per branch, in the tech spec's Services & Ordering order. a stacked PR's base is the branch below it.

## rules

- draft each action (code change, commit, push, PR change, comment, close) and wait for explicit approval. after an approved action succeeds, report it and propose the next one.
- never post to github, linear, or slack without sign-off on the exact text.
- surface blockers at once. don't work around them.
- phase too big for one session: at a clean checkpoint, update the state file and hand off to the same skill.
- before `git add`, say which files go in which commit and why. before `--amend`, check `git log --oneline` for HEAD.

## start

state: `~/opord/senzu/<slug>.md`. slug from the argument, else the issue id or slug in the current branch name (ignore case), else ask. PRs already in state `prs`: pick up at their current step.

## 1. draft

- write the title and body with /pr-body.
- reference the issue id, never `Closes` (the issue closes in /iam-rollout).
- don't hard-wrap prose. GitHub renders raw newlines as line breaks.
- suggest screenshots where they help: terminal output, UI state, infra confirmation.
- push, then `gh pr create --draft`. record the PR in state `prs`.

## 2. copilot review

- `gh pr edit <n> --add-reviewer @copilot`, unless the repo requests it automatically.
- wait with a background poll (Monitor), not a sleep loop. watch CI too.

## 3. respond

- per unresolved thread and failing check: fix it (one commit per logical change), or draft a reply saying why not.
- show all reply drafts together. after approval, post them and resolve the addressed threads (`gh api graphql`: `reviewThreads` to list, `resolveReviewThread` to resolve).
- fold real bugs found into the body's `how`, per /pr-body. no review narrative.

## 4. ready

when threads are resolved and CI is green: update the body if needed, then `gh pr ready <n>`.

exit: every PR ready for review; no unresolved threads; CI green.

## handoff

update the state file (phase, next, prs, one `## log` line), then:

**phase complete: pr**
- <2-4 terse bullets>

**next: /iam-rollout** (<one line>). run `/clear` first.

if state has `slack`, also draft a one-line reply for that thread: `<phase> done: <outcome>. next: <phase>`, PR links inline. post it only when the user says post.
