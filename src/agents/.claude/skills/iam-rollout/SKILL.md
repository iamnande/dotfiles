---
name: iam-rollout
description: senzu phase 5. merges in order, runs the staged rollout with verification, then closes out (learnings, issue comment, close, branch cleanup).
argument-hint: "[<slug>]"
disable-model-invocation: true
---

# rollout

ship it, verify it against the deployed change, close it out.

## rules

- draft each action (code change, commit, push, PR change, comment, close) and wait for explicit approval. after an approved action succeeds, report it and propose the next one.
- never post to github, linear, or slack without sign-off on the exact text.
- surface blockers at once. don't work around them.
- phase too big for one session: at a clean checkpoint, update the state file and hand off to the same skill. a rollout that spans days checkpoints between stages.

## start

state: `~/opord/senzu/<slug>.md`. slug from the argument, else the issue id or slug in the current branch name (ignore case), else ask. read the tech spec's Rollout Plan and Services & Ordering.

## 1. merge

- per PR, in order: confirm approval and green CI, then merge. prefer rebase merge. never `--delete-branch`.
- confirm with `gh pr view <n> --json state,mergedAt`. never infer a merge from titles or ticket text.

## 2. rollout

- follow the Rollout Plan: stages, flags, gates. stage it when the blast radius is broad.
- at each stage, run the plan's verification against the deployed change.
- on a regression: stop, surface it, propose the rollback from the tech spec.

## 3. close-out

- learnings: what went well, what went wrong or took longer, what was surprising. record in state `## decisions`.
- draft the issue completion comment: what shipped, tradeoffs accepted, anything worth carrying forward. user edits or cuts, then post.
- close the issue only after every PR shows merged.
- per merged PR: `git -C <repo> worktree remove <path>`. then hand the user the branch deletes (claude-guard blocks agents from running them): `git push origin --delete <branch>` and `git branch -D <branch>` (rebase merges make `-d` refuse).
- set state phase to `done`.

exit: rollout verified; issue closed; worktrees removed; branch deletes handed off; state `done`.

## handoff

update the state file (phase, one `## log` line), then:

**phase complete: rollout**
- <2-4 terse bullets: what shipped, what's left>

if state has `slack`, also draft a one-line reply for that thread: `<phase> done: <outcome>. next: <phase>`, PR links inline. post it only when the user says post.
