---
name: senzu-pr
description: senzu phase 4. hands over a facts outline and submission preview for each PR the user opens, replies to and resolves threads, hands over ready.
argument-hint: "[<slug>]"
disable-model-invocation: true
---

# pr

one PR per branch, steel thread first, then state `repos` order. a stacked PR's base is the branch below it.

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

state: the bean `<slug>`. read it with `senzu show <slug>`; its file is `.path` in `senzu show <slug> --json`. slug from the argument, else the issue id or slug in the current branch name (ignore case), else ask. PRs already in state `prs`: pick up at their current step.

## 1. draft

- before the outline: lint and the repo's tests pass on the branch tip, and refine has exited (or its delta passed). red: stop and report.
- hand the user a facts outline for the title and body: what changed, why (per the bean), tests run with their red lines, links. no prose: the user writes the title and body.
- reference the issue id, never `Closes` (the issue closes in /senzu-rollout).
- don't hard-wrap prose. GitHub renders raw newlines as line breaks.
- suggest screenshots where they help: terminal output, UI state, infra confirmation.
- then one submission preview per PR: repo, branch, base, draft, title, body. the user pushes and opens it; hand them the command, with the body in a file and never inlined: `gh pr create --draft --base <base> --title "$(cat <title-file>)" --body-file <body-file>`.
- record the PR in state `prs` once it's up.

## 2. review

- if the branch has a non-trivial delta since refine exited, run `/senzu-refine delta` first. no delta, no pass.
- a bot reviewer (like copilot) only when the user asks for one on this repo. draft the request; never add it by default.
- no background monitors or poll loops for reviews or CI (token cost). check status when the user asks, then report what's pending.

## 3. respond

- per unresolved thread and failing check: fix it (one diff per logical change, the user commits it), or draft a reply saying why not.
- show all reply drafts together. after approval, post them and resolve the addressed threads (`gh api graphql`: `reviewThreads` to list, `resolveReviewThread` to resolve).
- real bugs found go in the facts outline for the body. no review narrative.

## 4. ready

when threads are resolved and CI is green: run `/senzu-refine delta` again if commits landed since the last pass, hand over outline changes if the body needs them, then hand the user `gh pr ready <n>`.

exit: every PR ready for review; no unresolved threads; CI green.

## handoff

update the state file (phase, next, prs, one `log` entry), then:

**phase complete: pr**
- <2-4 terse bullets>

**next: /senzu-rollout** (<one line>). run `/clear` first.

if state has `thread` and `senzu config` sets `thread_channel`, also draft a one-line reply for that thread: `<phase> done: <outcome>. next: <phase>`, PR links inline. post it only when the user says post.
