---
name: senzu-execute
description: senzu phase 2. implements the plan one reviewed, commit-sized diff at a time. the user commits.
argument-hint: "[<slug>]"
disable-model-invocation: true
---

# execute

small iterations. one logical change per diff, and the user commits each one before the next.

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

state: the bean `<slug>`. read it with `senzu show <slug>`; its file is `.path` in `senzu show <slug> --json`. slug from the argument, else the issue id or slug in the current branch name (ignore case), else ask. the plan is the `path` of the `plan` attachment in `senzu show <slug> --json`. work in the worktrees in state `repos`.

## work

- land the plan's steel thread first. one branch per repo in state `repos`; a stack, each based on the one below, only when the plan says so.
- commit messages are the user's. suggest one only when asked: `type(scope): subject [<ISSUE>]` with the issue id from state. beans stay uncommitted.
- run the plan's verify (lint and the targeted tests at least) before each diff is handed over. don't defer correctness checks to the deploy.
- every new test names its red line: the one-line change to the implementation that turns it red. put it in the bean's `log` entry, not the commit. if you can't name one, the test is decoration: delete it or make it assert something.
- for tests that guard a bug fix or a contract, apply the named change once, confirm the test goes red, then revert. don't commit the mutation.

exit: all verification passes; every new test has a named red line; no open blockers.

## handoff

update the state file (phase, next, decisions, one `log` entry with the steps done, their commits once the user lands them, and their red lines), then:

**phase complete: execute**
- <2-4 terse bullets>

**next: /senzu-refine** (<one line>). run `/clear` first.

if state has `thread` and `senzu config` sets `thread_channel`, also draft a one-line reply for that thread: `<phase> done: <outcome>. next: <phase>`, PR links inline. post it only when the user says post.
