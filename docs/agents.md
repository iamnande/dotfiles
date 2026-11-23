# agents

global agent instructions, claude skills, and the senzu workflow. `make agents` stows `src/agents/` into `~`. the `senzu` cli is [senzu-rs](https://github.com/iamnande/senzu-rs).

## instructions

- edit `src/agents/.config/AGENTS.md`. it's the only real instructions file.
- `src/agents/.claude/CLAUDE.md` just imports it (`@~/.config/AGENTS.md`). keep it. claude code reads AGENTS.md at project level only (cwd and above, and only when the repo has no CLAUDE.md). it never reads `~/.config/AGENTS.md`, so without the import, global instructions disappear.

## guardrails

hard blocks for claude code agents, set in user settings. `make guardrails` stows the hook and merges `guardrails/settings.json` into `~/.claude/settings.json` (it replaces the `permissions.deny` and `hooks` lists with the fragment's).

blocked: every push, branch deletes, remote rewiring, publishing, `git worktree remove --force`, sudo.

| layer | what it does |
|---|---|
| `claude-guard` hook | parses each Bash/Monitor command, exits 2. wins over allow rules. fails closed |
| `permissions.deny` | literal forms, in case the hook doesn't run. also denies agent edits to the guardrail files |
| `autoMode.hard_deny` | tells the auto-mode classifier, which catches forms text checks can't (scripts, subprocesses) |

- change them yourself: agents are denied edits to `~/.claude/settings*.json`, `~/.claude/hooks/`, and `guardrails/`.
- hook source: `src/agents/.claude/hooks/claude-guard`.
- limits: text checks can't see inside a script file, and user settings are editable by anything running as you. the real boundary for either is the sandbox or managed settings.

## senzu

one ticket is one stream. one phase is one session. `/clear` between phases.

```
senzu                      # tui: browse streams. enter opens the agent on the bean's next skill
senzu ls | show <slug>     # one line per stream, or one bean. json when piped
senzu check                # every bean against the schema, plus the plans beside them
senzu config               # each setting and the layer that set it. the skills read it
/senzu-ground <id|topic>   # open questions, terms, prior art. creates the bean (+ slack thread when thread_channel is set)
/senzu-plan                # worktrees, the plan beside the bean, issue comment
/senzu-execute             # one reviewed diff at a time, i commit each
/senzu-refine [fanout]     # idiom, DRY/YAGNI, Rn coverage, security, resilience. fanout: up to 2 subagents
/senzu-pr                  # facts outline + submission preview, i open the PR. threads, then ready
/senzu-rollout             # merges handed over, staged rollout, verify, close-out, worktrees + branch deletes
```

commits, pushes, PRs, merges and branch deletes are mine. the agent makes one commit-sized change, leaves it unstaged, and stops. beans and worktrees it just does, then says so. nothing posts to github, linear, or slack without sign-off on the exact text. each phase ends by updating the bean and naming the next skill. a phase too big for one session: checkpoint, `/clear`, rerun the same skill.

## where things live

| what | where |
|---|---|
| beans | `<beans>/<slug>.json`. the dir comes from `senzu config` (`SENZU_BEANS`, set in `conf.d/senzu.fish`) |
| plan | `<beans>/<slug>.plan.md`, beside the bean. never committed (`senzu check` fails on one git tracks) |
| worktrees | `<worktrees>/<ISSUE>-<slug>` on `<branch_prefix><issue>-<slug>`, both from `senzu config` |
| slack thread | only when `thread_channel` is set. parent `:thread: <ISSUE> / <title>` |
| skills | `src/agents/.claude/skills/` (the plan template is `senzu-plan/templates/plan.md`) |
| CLI | `cargo install --locked --git https://github.com/iamnande/senzu-rs`, into `~/.cargo/bin` |

## editing skills

- edit under `src/agents/.claude/skills/`. the symlinks pick it up. start a new session to load it.
- added a skill dir: rerun `make agents`.
- keep skills lean. each loads in full on every invocation. write rules that change behavior, not things the model already knows.

## gotchas

- stow won't overwrite files it doesn't own. remove the old file first, then `make <component>`.
- home-manager (`~/.config/home-manager`, old pin) still installs kami. `home-manager switch` would collide with the stowed senzu files.
