---
description: phase checkpoint — invoking this is the go-ahead signal; summarize completed phase and begin the next
argument-hint: "[<repo>#<issue> | #<issue> | phase-name]"
---

## invocation modes

**`/senzu <repo>#<issue>`** — start a new issue. fetch the issue from github,
set it as the working context for this session, and begin grounding.

**`/senzu #<issue>`** — same, but infer the repo from the current git context.
only valid when the working directory is inside a git repo.

**`/senzu [phase-name]`** — phase checkpoint. identify the completed phase
(from arg or infer from conversation), summarize it, and begin the next.
issue context carries forward from earlier in the session.

**`/senzu`** (no arg, fresh session) — no issue context. ask: "what are we
working on?" before doing anything else.

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

these fire automatically at specific phase transitions when an issue is in context.

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

1. post a completion comment to the issue:
   - what shipped
   - tradeoffs accepted
   - anything surprising or worth carrying forward

2. close the issue

---

## behavior

invoking /senzu is itself the go-ahead — do not ask "ready to proceed?" and do
not wait for separate confirmation.

if the current phase has outstanding items that aren't cleared, surface them and
hold. otherwise, summarize and immediately begin the next phase.

**exception — no-arg /senzu mid-execution:** if /senzu is called with no arg
during a lengthy execution phase, do not auto-advance. instead, re-affirm
current phase status and immediate next steps. advance only when the phase is
fully cleared.

---

## output format

use this structure exactly (lowercase, terse, no filler):

---
**phase complete: <name>**

- <what was accomplished, 2-4 bullets, terse>

**next: <name>** — <one sentence on what this phase covers>
---

then immediately begin that phase.
