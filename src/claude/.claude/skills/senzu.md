---
description: phase checkpoint — summarize the completed phase, name the next, ask for go-ahead
argument-hint: "[optional: name of phase that just completed]"
---

look at the conversation so far and identify the phase that just completed. if an argument was passed, treat it as the completed phase name. if none, infer it.

## phase model

phases run in order. each phase iterates until it's fully cleared — don't advance until the current phase is done.

| phase | covers |
|---|---|
| grounding | confirm assumptions, align on nouns/verbs, research the problem space |
| planning | concrete plan with narrative, diffs/examples, expected outcome — no surprises in execution |
| execution | small iterations, red/green if tests apply, conventional commits at each checkpoint |
| refinement | make it right — tests, idioms, brevity, complexity, modularity |
| protection | security and risk assessment — flag it, don't assume it's fine |
| release/deploy | how does this go out? order of operations, staged rollout if needed |
| learnings | reflect on what worked, what didn't, and what to carry forward — process improvements, friction, surprises |

## output format

use this structure exactly (lowercase, terse, no filler):

---
**phase complete: <name>**

- <what was accomplished, 2-4 bullets, terse>

**next: <name>** — <one sentence on what this phase covers>

ready to proceed?
---

wait for explicit go-ahead before continuing.
