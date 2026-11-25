# agents

everyone is doing llms, it's so cool. (may be considered harmful)

current setup:

- agent: `claude`
- harness: `senzu` ([senzu-rs](https://github.com/iamnande/senzu-rs))

## configuration

`src/agents/.config/AGENTS.md`is the one true agents file.

## guardrails

confirmed consent and established boundaries are super hot.

we rock a custom `~/.claude/settings.json#permissions.deny` and `hooks`.

all ssh and git operations require hardware security keys & pins, the below are
additional protective measures around:

- git `push`
- branch `delete`
- modifying remote
- publishing
- forceful worktree removal
- sudo

| layer                | what it does                                        |
| -------------------- | --------------------------------------------------- |
| `claude-guard`       | checks each Bash/Monitor command against deny list  |
| `permissions.deny`   | fallback for hook misfire, denies guardails edits   |
| `autoMode.hard_deny` | comms channel to denial in the auto-mode classifier |

## what is a senzu, even?

well, its a bean. also a stream. oh, and there's phases. memory wipes.

senzu is my process, with configurable profiles that follow work guidance when
needed and personal when not.

```
senzu                      # tui
senzu ls | show <slug>     # one line per stream, or one bean
senzu check                # schema check all beans and rfcs
senzu config               # config source map
```

senzu skill assisted SDLC:

- (1) `/senzu-ground` - creates the new bean. gather and work through open
  questions between now and an `aligned` rfc driving `/senzu-execute`.

- (2) `/senzu-rfc` - document the purpose, constraints - what `MUST` be true
  about the system (and what `MUST NOT`).

- (3) `/senzu-execute` - diff by diff bb. commit. by. commit.

- (4) `/senzu-refine` - ZOOM OUT. or gardening. goes away when debugging broken
  code at 3am does, or we solved security, or like - anything cool.

- (5) `/senzu-pr` - seek approval and validation from others (or CI, we don't
  judge)

- (6) `/senzu-rollout` - changes aren't real if they aren't in prod. inspect
  what you expect. leave the place nicer than you found it.

ultimately, each individual is responsible for their own decisions and how those
decisions impact others.

i own the design, verification, commits, pushes, PRs, merges, and cleanup.

the agent is a workhorse making one reviewable commit-sized change at a time.

consistently shipping quality through orchestrated <100k token sessions.

## phonebook

| who       | what/where                                                      |
| --------- | --------------------------------------------------------------- |
| beans     | `<beans>/<slug>.json`                                           |
| rfc       | `<beans>/<slug>.rfc.md`                                         |
| worktrees | `<worktrees>/<ISSUE>-<slug>` on `<branch_prefix><issue>-<slug>` |
| skills    | `src/agents/.claude/skills/`                                    |
