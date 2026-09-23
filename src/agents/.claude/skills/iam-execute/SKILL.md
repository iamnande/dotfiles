---
name: iam-execute
description: senzu phase 2. implements the tech spec in small verified commits.
argument-hint: "[<slug>]"
disable-model-invocation: true
---

# execute

small iterations. one logical change per commit.

## rules

- draft each action (code change, commit, push, PR change, comment, close) and wait for explicit approval. after an approved action succeeds, report it and propose the next one.
- never post to github, linear, or slack without sign-off on the exact text.
- surface blockers at once. don't work around them.
- phase too big for one session: at a clean checkpoint, update the state file and hand off to the same skill.
- before `git add`, say which files go in which commit and why. before `--amend`, check `git log --oneline` for HEAD.

## start

state: `~/opord/senzu/<slug>.md`. slug from the argument, else the issue id or slug in the current branch name (ignore case), else ask. read the tech spec from state `plan`; read the PRD only for Rn detail. work in the worktrees in state `repos`.

## work

- work in the tech spec's Services & Ordering order. if it defines a PR stack, one branch per stack item, each based on the one below; record them in state `repos`.
- commit messages: `type(scope): subject [<ISSUE>]`, with the issue id from state.
- run the tech spec's verification at each checkpoint. don't defer correctness checks to the deploy.

exit: all verification passes; no open blockers.

## handoff

update the state file (phase, next, decisions, one `## log` line with the commits made), then:

**phase complete: execute**
- <2-4 terse bullets>

**next: /iam-refine** (<one line>). run `/clear` first.

if state has `slack`, also draft a one-line reply for that thread: `<phase> done: <outcome>. next: <phase>`, PR links inline. post it only when the user says post.
