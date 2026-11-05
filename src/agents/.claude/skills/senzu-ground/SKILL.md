---
name: senzu-ground
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
- the state file is json. after each write, `senzu check` prints `ok`.

## start

- ticket context: fetch the issue, if there is one.
- state: `$SENZU_BEANS/<slug>.json`. `<slug>` is the issue id, else kebab-case, 3-5 words. resume it if it exists, else create it in the format below.
- slack: search #myspace-nick for a parent message with the issue id. found: read its thread for context. none: draft the parent `:thread: <ISSUE> / <title>` (no issue: `:thread: <title>`) and post it when the user says post. record the permalink and ts in state `thread`.

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
  "schema": 1,
  "slug": "<slug>",
  "title": "<title>",
  "phase": "ground | plan | execute | refine | pr | rollout | done",
  "priority": "urgent | high | medium | low | none",
  "priority_note": null,
  "issue": null,
  "thread": null,
  "repos": [{ "path": "<absolute>", "repo": "<name>", "branch": null, "base": null, "note": null }],
  "plan": { "prd": null, "spec": null, "page": null, "note": null },
  "prs": ["<pr url> (draft | ready | merged)"],
  "next": { "text": "/senzu-<phase> <slug>: <first action>", "draft": null },
  "context": [{ "text": "<fact>", "source": "<who said it>", "date": "YYYY-MM-DD" }],
  "decisions": [{ "text": "<decision, with why>", "by": "<who decided>", "date": "YYYY-MM-DD" }],
  "open": [{ "text": "<question or blocker>", "blocks": false, "draft": null }],
  "drafts": [{ "id": "<kebab-id>", "title": "<title>", "date": "YYYY-MM-DD", "body": "<markdown>" }],
  "log": [{ "date": "YYYY-MM-DD", "phase": "<phase>", "text": "<one-line outcome>" }]
}
```

- every key is present. unknown is `null` or `[]`. paths are absolute.
- `priority` is the issue's, else ask. `none` is the triage queue.
- `source` and `by` name a person, or `agent` for a finding of your own.
- work product (an email, a calc, a map) is a draft. `open` and `next` point at it by `draft` id.
- `blocks` is true when the item stops `next`.

## handoff

update the state file (phase, next, decisions, one `log` entry), then:

**phase complete: ground**
- <2-4 terse bullets>

**next: /senzu-plan** (<one line>). run `/clear` first.

if state has `thread`, also draft a one-line reply for that thread: `<phase> done: <outcome>. next: <phase>`, PR links inline. post it only when the user says post.
