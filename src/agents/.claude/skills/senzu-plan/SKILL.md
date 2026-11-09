---
name: senzu-plan
description: senzu phase 1. creates worktrees, writes the plan beside the bean (never committed), posts it to the issue.
argument-hint: "[<slug>]"
disable-model-invocation: true
---

# plan

no code until the plan is approved.

## rules

- draft each action (code change, commit, push, PR change, comment, close) and wait for explicit approval. after an approved action succeeds, report it and propose the next one.
- never post to github, linear, or slack without sign-off on the exact text.
- surface blockers at once. don't work around them.
- phase too big for one session: at a clean checkpoint, update the state file and hand off to the same skill.
- the state file is json. after each write, `senzu check` prints `ok`.
- before `git add`, say which files go in which commit and why. before `--amend`, check `git log --oneline` for HEAD.

## start

state: the bean `<slug>`. read it with `senzu show <slug>`; its file is `.uri` in `senzu show <slug> --json`. slug from the argument, else the issue id or slug in the current branch name (ignore case), else ask. read `decisions` and `repos`.

## 1. worktrees

one worktree per affected repo, so streams never share a checkout. after `git -C <repo> fetch origin`:

`git -C <repo> worktree add -b nick/<issue>-<slug> ~/worktrees/<ISSUE>-<slug> origin/<default-branch>`

- `<ISSUE>` is the issue id as written, `<issue>` is lowercase. no issue: drop the id.
- slug is kebab-case, 3-5 words, e.g. `nick/admin-123-short-slug`.
- second repo in the same stream: append `-<repo>` to the worktree dir.
- record each absolute worktree path and branch in state `repos`. work only in the worktrees from here on.

## 2. plan

one file per bean: `<slug>.plan.md`, beside the bean's file. `senzu show` lists it once it exists.

- fill `templates/plan.md`. keep every section.
- never commit it. it lives only while the stream is active.
- requirements are behaviors and invariants, not a change list. each Rn has a proof.
- no decisions section: the bean's `decisions` is the one source.
- soft cap ~80 lines. over it, the stream is probably two beans.
- show it, wait for approval.

## 3. issue comment

if there's an issue, draft a terse comment: confirmed facts and decisions, the plan and why, tradeoffs accepted, branches per repo. decisions and rationale only, no transcript.

exit: the plan approved; every Rn has a proof; verify and rollback defined.

## handoff

update the state file (phase, next, decisions, one `log` entry), then:

**phase complete: plan**
- <2-4 terse bullets>

**next: /senzu-execute** (<one line>). run `/clear` first.

if state has `thread`, also draft a one-line reply for that thread: `<phase> done: <outcome>. next: <phase>`, PR links inline. post it only when the user says post.
