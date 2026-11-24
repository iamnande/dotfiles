---
name: senzu-rfc
description: senzu phase 1. creates worktrees, writes the rfc (an rfc PR for lasting rules, else beside the bean), gets it a fresh-context review, and closes with the commit layout and pr stack.
argument-hint: "[<slug>]"
disable-model-invocation: true
---

# rfc

no code until the rfc is aligned.

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

state: the bean `<slug>`. read it with `senzu show <slug>`; its file is `.path` in `senzu show <slug> --json`. slug from the argument, else the issue id or slug in the current branch name (ignore case), else ask. read `decisions` and `repos`.

skip: the user confirms an existing rfc already covers this work. log the skip in the bean (which rfc, and why it's current), write the stack (step 5), and hand off to /senzu-execute.

## 1. worktrees

one worktree per affected repo, so streams never share a checkout. `<worktrees>` and `<branch_prefix>` come from `senzu config --json` (no prefix when it's unset). after `git -C <repo> fetch origin`:

`git -C <repo> worktree add -b <branch_prefix><issue>-<slug> <worktrees>/<ISSUE>-<slug> origin/<default-branch>`

- `<ISSUE>` is the issue id as written, `<issue>` is lowercase. no issue: drop the id.
- slug is kebab-case, 3-5 words, e.g. `admin-123-short-slug`.
- second repo in the same stream: append `-<repo>` to the worktree dir.
- record each absolute worktree path and branch in state `repos`. work only in the worktrees from here on.

## 2. where it lands

- the work sets lasting rules, or changes a rule an rfc already covers: an rfc PR in the repo that owns the rules, from that repo's `rfcs/0000-template.md`. one that changes a covered rule updates or obsoletes it.
- anything else: `<slug>.rfc.md` beside the bean's file, from `templates/rfc.md`. never committed. `senzu show` lists it once it exists.
- record which one in `decisions`.

## 3. write it

- keep every template section. mark one that doesn't apply `N/A: <reason>`.
- the specification is behaviors and invariants, not a change list.
- every rule names its check: a test, a lint, an eval, a hook, or by hand. the check lives where the rule is enforced.
- work that touches auth, secrets or trust: the security considerations hold a threat model.
- operational considerations hold verify (each check, plus the repo's lint and test commands) and rollback (how each change comes back out).
- no decisions section: the bean's `decisions` is the one source.
- only the user can settle something: mark it `[qN]` and ask. the user answers, reads it whole, and rewrites what doesn't sound like them.

## 4. adversarial review

before the user aligns it, review it in a fresh context: a subagent, or a new session. hand it only the rfc and the bean. it hunts for holes: a rule with no check, a check that can't fail, a missing failure mode, a gate the work slips past, a term used two ways. sort what comes back into must fix and may fix, fix both, and show the user what changed.

## 5. stack

the rfc closes with the commit layout and the pr stack, in the bean as the draft `stack`:

```markdown
# stack

## <repo> pr 1: <title>

1. `type(scope): subject`: <what lands>. checks: <which>
2. ...

## <repo> pr 2: <title> (based on pr 1)
```

- the first commits are the steel thread: the thinnest end-to-end slice, on main fast.
- each execute step is one commit in this list. a step that doesn't fit is a stack change, made with the user.
- point `next.draft` at `stack`.

## 6. issue comment

if there's an issue, draft a terse comment: confirmed facts and decisions, the rfc and why, tradeoffs accepted, branches per repo. decisions and rationale only, no transcript.

exit: the rfc aligned; every rule has a check; the review's fixes are in; verify and rollback defined; the stack in the bean.

## handoff

update the state file (phase, next, decisions, one `log` entry), then:

**phase complete: rfc**
- <2-4 terse bullets>

**next: /senzu-execute** (<one line>). run `/clear` first.

if state has `thread` and `senzu config` sets `thread_channel`, also draft a one-line reply for that thread: `<phase> done: <outcome>. next: <phase>`, PR links inline. post it only when the user says post.
