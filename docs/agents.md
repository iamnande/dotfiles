# agents

global agent instructions, claude skills, and the senzu workflow. `make agents` stows `src/agents/` into `~`. `make bin` stows the `senzu` CLI.

## instructions

- edit `src/agents/.config/AGENTS.md`. it's the only real instructions file.
- `src/agents/.claude/CLAUDE.md` just imports it (`@~/.config/AGENTS.md`). keep it. claude code reads AGENTS.md at project level only (cwd and above, and only when the repo has no CLAUDE.md). it never reads `~/.config/AGENTS.md`, so without the import, global instructions disappear.

## guardrails

hard blocks for claude code agents, set in user settings. `make guardrails` stows the hook and merges `guardrails/settings.json` into `~/.claude/settings.json` (it replaces the `permissions.deny` and `hooks` lists with the fragment's).

blocked: NGROK_ENV set to prod or stage, branch deletes, pushes outside `github.com/ngrok-private`, remote rewiring, `nd ctl`, `nd db` (except `lint`), publishing, `git worktree remove --force`, sudo.

| layer | what it does |
|---|---|
| `env` | `NGROK_ENV=local` for every command claude runs |
| `claude-guard` hook | parses each Bash/Monitor command, resolves real push URLs, exits 2. wins over allow rules. fails closed |
| `permissions.deny` | literal forms, in case the hook doesn't run. also denies agent edits to the guardrail files |
| `autoMode.hard_deny` | tells the auto-mode classifier, which catches forms text checks can't (scripts, subprocesses) |

- change them yourself: agents are denied edits to `~/.claude/settings*.json`, `~/.claude/hooks/`, and `guardrails/`.
- hook source: `src/agents/.claude/hooks/claude-guard`.
- limits: text checks can't see inside a script file, and user settings are editable by anything running as you. the real boundary for either is the sandbox or managed settings.

## senzu

one ticket is one stream. one phase is one session. `/clear` between phases.

```
senzu ADMIN-123          # new: fetch ticket, open /iam-ground. existing: cd to its worktree, open /senzu
/senzu [slug]            # where am i, what's next. no match: table of every active stream
/iam-ground <id|topic>   # open questions, terms, prior art. creates state file + slack thread
/iam-plan                # worktrees, PRD, tech spec, issue comment
/iam-execute             # small verified commits
/iam-refine [fanout]     # idiom, DRY/YAGNI, Rn coverage, security, resilience. fanout: up to 2 subagents
/iam-pr                  # draft PR (/pr-body), copilot review, resolve threads, ready for review
/iam-rollout             # merge, staged rollout, verify, close-out, remove worktrees + branches
senzu ADMIN-123 close    # mark the linear ticket done
```

every phase drafts each action and waits for approval. nothing posts to github, linear, or slack without sign-off on the exact text. each phase ends by updating the state file and naming the next skill. a phase too big for one session: checkpoint, `/clear`, rerun the same skill.

## where things live

| what | where |
|---|---|
| handoff state | `~/opord/senzu/<ISSUE>.md` |
| worktrees | `~/worktrees/<ISSUE>-<slug>` on `nick/<issue>-<slug>` |
| PRD + tech spec | `plan/<date>_<slug>/` in the primary worktree, force-committed |
| slack thread | #myspace-nick, parent `:thread: <ISSUE> / <title>` |
| skills | `src/agents/.claude/skills/` (templates in `iam-plan/templates/`) |
| CLI | `src/bin/.local/bin/senzu`, `senzu-fetch` (need `LINEAR_TOKEN`) |

## editing skills

- edit under `src/agents/.claude/skills/`. the symlinks pick it up. start a new session to load it.
- added a skill dir: rerun `make agents`.
- keep skills lean. each loads in full on every invocation. write rules that change behavior, not things the model already knows.

## gotchas

- stow won't overwrite files it doesn't own. remove the old file first, then `make <component>`.
- home-manager (`~/.config/home-manager`, old pin) still installs kami. `home-manager switch` would collide with the stowed senzu files.
