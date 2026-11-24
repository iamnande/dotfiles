---
name: senzu-ground
description: senzu phase 0. grounds a ticket or topic (open questions, ambiguities, shared terms, prior art) and creates the senzu state file.
argument-hint: "<issue-id | topic>"
disable-model-invocation: true
---

# ground

understand the problem before planning it.

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

- ticket context: fetch the issue, if there is one.
- state: the bean `<slug>`. `<slug>` is the issue id, else kebab-case, 3-5 words. `senzu show <slug>` finds it: resume it. none: create `<slug>.json` in the beans dir (`senzu config`) in the format below.
- slack: only when `thread_channel` is set in `senzu config --json`. search that channel for a parent message with the issue id. found: read its thread for context. none: draft the parent `:thread: <ISSUE> / <title>` (no issue: `:thread: <title>`) and post it when the user says post. record the permalink and ts in state `thread`.

## work

- list every open question in `open`. resolve each with the user or by research. carry none forward silently.
- name ambiguities in requirements, scope, and key terms.
- confirm assumptions with the user.
- agree on nouns and verbs. record them in `decisions`.
- research prior art in the codebase: existing patterns, related work. record affected repos in `repos`.

exit: `open` is empty; scope and terms agreed.

## state format

```json
{
  "schema": 2,
  "slug": "<slug>",
  "title": "<title>",
  "phase": "ground | rfc | execute | refine | pr | rollout | done",
  "priority": "urgent | high | medium | low | none",
  "priority_note": null,
  "issue": null,
  "thread": null,
  "repos": [{ "path": "<absolute>", "repo": "<name>", "branch": null, "base": null, "note": null }],
  "attachments": [{ "kind": "artifact | issue | link", "uri": "<absolute, or relative to the bean>" }],
  "prs": ["<pr url> (draft | ready | merged)"],
  "next": { "text": "/senzu-<phase> <slug>: <first action>", "draft": null },
  "context": [{ "text": "<fact>", "source": "<who said it>", "date": "YYYY-MM-DD" }],
  "decisions": [{ "text": "<decision, with why>", "by": "<who decided>", "date": "YYYY-MM-DD" }],
  "open": [{ "text": "<question or blocker>", "blocks": false, "draft": null }],
  "drafts": [{ "id": "<kebab-id>", "title": "<title>", "date": "YYYY-MM-DD", "body": "<markdown>" }],
  "log": [{ "date": "YYYY-MM-DD", "phase": "<phase>", "text": "<one-line outcome>" }]
}
```

- every key is present. unknown is `null` or `[]`. repo paths are absolute.
- the rfc is never stored as an attachment: senzu finds `<slug>.rfc.md` beside the bean. the stack is a draft with id `stack`.
- `priority` is the issue's, else ask. `none` is the triage queue.
- `source` and `by` name a person, or `agent` for a finding of your own.
- work product (an email, a calc, a map) is a draft. `open` and `next` point at it by `draft` id.
- `blocks` is true when the item stops `next`.

## handoff

update the state file (phase, next, decisions, one `log` entry), then:

**phase complete: ground**
- <2-4 terse bullets>

**next: /senzu-rfc** (<one line>). run `/clear` first.

if state has `thread` and `senzu config` sets `thread_channel`, also draft a one-line reply for that thread: `<phase> done: <outcome>. next: <phase>`, PR links inline. post it only when the user says post.
