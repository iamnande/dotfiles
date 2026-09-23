---
name: iam-ground
description: senzu phase 0. grounds a ticket or topic (open questions, ambiguities, shared terms, prior art) and creates the senzu state file.
argument-hint: "<issue-id | topic>"
disable-model-invocation: true
---

# ground

understand the problem before planning it.

## rules

- draft each action (code change, commit, push, PR change, comment, close) and wait for explicit approval. after an approved action succeeds, report it and propose the next one.
- never post to github, linear, or slack without sign-off on the exact text.
- surface blockers at once. don't work around them.
- phase too big for one session: at a clean checkpoint, update the state file and hand off to the same skill.

## start

- ticket context: use the system prompt (from `senzu <id>`) if present, else fetch the issue.
- state: `~/opord/senzu/<slug>.md`. `<slug>` is the issue id, else kebab-case, 3-5 words. resume it if it exists, else create it in the format below.
- slack: search #myspace-nick for a parent message with the issue id. found: read its thread for context. none: draft the parent `:thread: <ISSUE> / <title>` (no issue: `:thread: <title>`) and post it when the user says post. record the permalink and ts in state `slack`.

## work

- list every open question in `## open`. resolve each with the user or by research. carry none forward silently.
- name ambiguities in requirements, scope, and key terms.
- confirm assumptions with the user.
- agree on nouns and verbs. record them in `## decisions`.
- research prior art in the codebase: existing patterns, related work. record affected repos in `repos`.

exit: `## open` is empty; scope and terms agreed.

## state format

```markdown
# <slug>: <title>

- phase: ground | plan | execute | refine | pr | rollout | done
- issue: <id or none>
- slack: <#myspace-nick thread permalink> (ts <ts>)
- repos: (one per repo; absolute worktree path, set in plan)
  - <path> (<branch>)
- plan: <prd.md and tech-spec.md paths, once written>
- prs: <repo#n (draft | ready | merged)>
- next: <skill: first action>

## decisions
- <decision or confirmed fact, with why>

## open
- <unresolved question or blocker>

## log
- <YYYY-MM-DD> <phase>: <one-line outcome>
```

## handoff

update the state file (phase, next, decisions, one `## log` line), then:

**phase complete: ground**
- <2-4 terse bullets>

**next: /iam-plan** (<one line>). run `/clear` first.

if state has `slack`, also draft a one-line reply for that thread: `<phase> done: <outcome>. next: <phase>`, PR links inline. post it only when the user says post.
