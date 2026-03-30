---
description: phase status check — summarize where we are, draft what's next, wait for approval before acting
argument-hint: "[<repo>#<issue> | #<issue> | phase-name]"
---

## invocation modes

**`/senzu <repo>#<issue>`** — start a new issue. fetch the issue from github,
set it as the working context, and present a grounding draft for review.

**`/senzu #<issue>`** — same, but infer the repo from the current git context.
only valid when the working directory is inside a git repo.

**`/senzu [phase-name]`** — phase checkpoint. summarize the completed phase,
draft the next, and wait for approval. issue context carries forward.

**`/senzu`** (no arg) — where are we / what's next. summarize current state and
draft the next action. **phase state takes precedence over issue context** — if a
phase is in progress (grounding has started, facts are established in the session),
produce a fresh summary regardless of whether an issue is filed. only ask "what are
we working on?" on a true cold start (no phase context at all).

---

## updating this skill

senzu edits commit directly to dotfiles main (no branch). after committing:

1. `cd ~/homelab && nix flake update dotfiles`
2. `git add flake.lock && git commit -m "chore(flake): update dotfiles input" && git push`
3. `nh os switch ~/homelab/compute`
4. start a fresh claude session — the loaded skill is stale until the switch completes
5. resume with a wake prompt (see compact+resume pattern)

---

## phase model

phases run in order. each phase iterates until fully cleared — don't advance
until the current phase is done.

| phase | covers |
|---|---|
| grounding | confirm assumptions, align on nouns/verbs, research the problem space |
| planning | concrete plan with narrative, diffs/examples, expected outcome — no surprises in execution. includes defining how each piece will be verified during execution |
| execution | small iterations, conventional commits at each checkpoint. run the verification steps defined in planning — don't defer correctness checks to the live deploy |
| refinement | make it right — don't just review what was built. actively ask: (1) are there more idiomatic patterns? (2) what's absent that should be there? (3) what's present that shouldn't be? surface tradeoffs before declaring done |
| protection | security and risk assessment — flag it, don't assume it's fine |
| release/deploy | PR, validation, staged rollout if needed |
| learnings | reflect on what worked, what didn't, what to carry forward |

---

## issue-aware actions

these actions occur at specific phase transitions when an issue is in context.
each is drafted for review before executing — nothing fires automatically.

### planning → execution

1. post a grounding + plan summary comment to the issue:
   - what we confirmed in grounding (assumptions, key facts, decisions made)
   - the plan: what we're doing and why, tradeoffs accepted
   - terse — decisions and rationale only, not a transcript

2. create a branch in each affected repo:
   ```
   git checkout -b <type>/<issue-number>_<slug>
   git push -u origin <type>/<issue-number>_<slug>
   ```
   - `type` follows conventional commits: `feat`, `fix`, `refactor`, `docs`, `chore`
   - `slug` is kebab-case, 3-5 words
   - examples: `refactor/14_nixos-modules-rename`, `docs/9_vlan-trunk-migration`
   - if type is ambiguous, ask before creating
   - for multi-repo work, create a branch in each affected repo and note them
     in the issue comment

### release/deploy

create a PR for each branch → main:

```
## why
<what problem this solves, what issue it addresses>

## how
<what changed and the key decisions made>

## validation
<how to verify it works — commands, expected output, screenshots>
```

- suggest screenshots where relevant: terminal output, ui state, infra confirmation
- reference the issue (`<repo>#<issue>`) but do NOT use `Closes` — the issue
  is closed manually after learnings
- prefer rebase merge

### learnings → done

1. draft a completion comment:
   - what shipped
   - tradeoffs accepted
   - anything surprising or worth carrying forward
   present the draft to the user. they may add, edit, or cut. post only after
   explicit sign-off — never auto-post.

2. close the issue only after the PR is merged. confirm merge before closing.

---

## behavior

`/senzu` is a status check, not a go-ahead. every invocation follows the same
pattern:

1. **where are we** — summarize the current phase and what's been completed
2. **what's next** — draft the next action or set of actions
3. **wait** — user reviews, adjusts if needed, then explicitly approves before
   anything executes

the user's approval is what triggers action. the /senzu invocation is what
triggers the draft.

this applies universally — code changes, commits, branch creation, github
comments, issue closes. if it's an action, it gets drafted and reviewed first.

if the current phase has outstanding items, surface them and hold. don't advance
until they're cleared.

---

## output format

use this structure exactly (lowercase, terse, no filler):

---
**phase complete: <name>**

- <what was accomplished, 2-4 bullets, terse>

**next: <name>** — <one sentence on what this phase covers>
---

then draft the first action for the next phase and wait for approval.
