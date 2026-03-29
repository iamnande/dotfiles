# CLAUDE.md

hey, i'm nick. senior software engineer (currently at ngrok), homelab
tinkerer, and recovering over-engineer. this file is my global context —
loaded in every claude code session. project-specific CLAUDE.md files
layer on top of this.

---

## how we work

i follow a pretty consistent flow when tackling problems. respect it,
and be explicit about which phase we're in.

**grounding** — before anything, we confirm assumptions and make sure
we're using the right nouns/verbs. research the problem space. don't
start building on a shaky foundation.

**planning** — draft a clear, concrete plan. include the narrative
(the why), code diffs or examples where helpful, and the expected
outcome. no surprises in execution.

**execution** — small iterations. where tests apply, red/green all
the way. conventional commits at each natural checkpoint
(red → commit, green → commit). no big bang drops.

**refinement** — once it works, we make it right. review tests,
idiomatic style, brevity, complexity, modularity, extensibility,
scalability. don't skip this.

**protection** — security and risk assessment before anything ships.
flag it, don't assume it's fine.

**release/deploy** — how does this actually go out? just merge? staged
rollout? if there's an order of operations, spell it out.

**learnings** — after each task, reflect on what worked, what didn't, and
what to carry forward. not just "what did we build" — "how did we build it
and what would we change." capture process improvements, friction points,
and surprises. always improving the flow, not just the implementation.

---

## branching + issue flow

work is issue-driven. use `/senzu <repo>#<issue>` to start a session against
a specific issue, or `/senzu #<issue>` when already inside the relevant repo.

branch naming: `<type>/<issue-number>_<slug>`
- type follows conventional commits: `feat`, `fix`, `refactor`, `docs`, `chore`
- slug is kebab-case, 3-5 words
- example: `refactor/14_nixos-modules-rename`

the `/senzu` skill handles branch creation, issue comments, and PRs at the
right phase transitions. see the skill for full details.

---

## general

- one step at a time. don't race ahead.
- explain tradeoffs before making non-obvious calls — i want to own the decision.
- when i push back or correct course, acknowledge it and explain the adjustment.
  no blind acceptance. first principles, grounded in facts.
- terse. no preamble, no trailing summaries, no filler.
- surgical edits. preserve comments, they're intentional.
- write like a human. no bot speak.
