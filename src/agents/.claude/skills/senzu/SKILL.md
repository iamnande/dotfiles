---
name: senzu
description: senzu SDLC router. reads the session state file, reports the phase, names the next iam-* skill.
argument-hint: "[<slug>]"
disable-model-invocation: true
---

# senzu

router only: report state, name the next skill, stop. do no phase work here.

## phases

one session per phase. run `/clear` between phases.

| skill | covers | exit |
|---|---|---|
| `/iam-ground` | open questions, ambiguities, shared terms, prior art | no open questions; scope agreed |
| `/iam-plan` | branches, PRD, tech spec (rollout, services, ordering), issue comment | both docs committed; branches pushed |
| `/iam-execute` | one commit per checkpoint, verification from the plan | all verification passes |
| `/iam-refine` | idiom, completeness, DRY/YAGNI, Rn coverage, security, resilience | findings fixed or accepted |
| `/iam-pr` | draft PRs, copilot review, replies, resolved threads, ready for review | PRs ready; threads resolved |
| `/iam-rollout` | merge, staged rollout, verification, close-out | verified; issue closed; state `done` |

## state

`~/opord/senzu/<slug>.md`. `<slug>` is the issue id (e.g. `ADMIN-376`), else kebab-case, 3-5 words.

find it: argument, else the issue id or slug in the current branch name (ignore case). no match: list every stream whose phase isn't `done`. none at all: cold start, suggest `/iam-ground <issue | topic>`.

## output

one stream:

**phase: <phase>** (<slug>, [thread](<state slack permalink>))
- <2-4 terse bullets: done so far, open items>

**next: /iam-<x>** (<one line>). worktree: `<path from state repos>`

if `## open` has items that block the next phase, list them and hold.

no match: one table, then ask which stream.

| slug | phase | next | worktree |
|---|---|---|---|
