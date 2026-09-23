---
name: iam-plan
description: senzu phase 1. creates branches, writes and commits the PRD and tech spec (rollout, services, ordering), posts the plan to the issue.
argument-hint: "[<slug>]"
disable-model-invocation: true
---

# plan

no code until both docs are committed.

## rules

- draft each action (code change, commit, push, PR change, comment, close) and wait for explicit approval. after an approved action succeeds, report it and propose the next one.
- never post to github, linear, or slack without sign-off on the exact text.
- surface blockers at once. don't work around them.
- phase too big for one session: at a clean checkpoint, update the state file and hand off to the same skill.
- before `git add`, say which files go in which commit and why. before `--amend`, check `git log --oneline` for HEAD.

## start

state: `~/opord/senzu/<slug>.md`. slug from the argument, else the issue id or slug in the current branch name (ignore case), else ask. read `## decisions` and `repos`.

## 1. worktrees

one worktree per affected repo, so streams never share a checkout. after `git -C <repo> fetch origin`:

`git -C <repo> worktree add -b nick/<issue>-<slug> ~/worktrees/<ISSUE>-<slug> origin/<default-branch>`

- `<ISSUE>` is the issue id as written, `<issue>` is lowercase. no issue: drop the id.
- slug is kebab-case, 3-5 words, e.g. `nick/admin-123-short-slug`.
- second repo in the same stream: append `-<repo>` to the worktree dir.
- record each absolute worktree path and branch in state `repos`. work only in the worktrees from here on.

## 2. PRD, then tech spec

for each, in order: fill the template, write to `plan/<YYYY-MM-DD>_<slug>/` in the primary worktree, show the diff, wait for approval, `git add -f` (`plan/` is gitignored), commit. commit the PRD before drafting the tech spec.

- templates: `templates/prd.md`, `templates/tech-spec.md`.
- keep every section. mark an inapplicable one `N/A: <reason>`. never drop one.
- the PRD lists at least one Rn. the tech spec's Requirements Coverage maps every Rn.
- the tech spec's Services & Ordering sets the PR order for /iam-pr and /iam-rollout. its Rollout Plan sets verification and rollback.
- record both paths in state `plan`.

push each branch with `git push -u origin <branch>`.

## 3. issue comment

if there's an issue, draft a terse comment: confirmed facts and decisions, the plan and why, tradeoffs accepted, branches per repo. decisions and rationale only, no transcript.

exit: both docs committed; every Rn defined; verification and rollback path defined; branches pushed.

## handoff

update the state file (phase, next, decisions, one `## log` line), then:

**phase complete: plan**
- <2-4 terse bullets>

**next: /iam-execute** (<one line>). run `/clear` first.

if state has `slack`, also draft a one-line reply for that thread: `<phase> done: <outcome>. next: <phase>`, PR links inline. post it only when the user says post.
