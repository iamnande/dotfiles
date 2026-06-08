# dotfiles

personal config files managed with [stow](https://www.gnu.org/software/stow/).

software (tools, languages, apps) is managed via pacman/yay. this repo is configs only.

---

## components

| component | manages |
|---|---|
| `src/claude/` | global Claude Code context + skills (senzu, kami) |
| `src/fish/` | shell config + functions |
| `src/git/` | git identity, aliases, per-directory overrides |
| `src/hypr/` | hyprland compositor config |

## activation

on a fresh machine:

```bash
git clone git@github.com:iamnande/dotfiles.git ~/dotfiles
cd ~/dotfiles
make all
```

individual components:

```bash
make claude
make fish
make git
make hypr
```

---

## structure

```
Makefile        entry point — wraps stow commands
mk/
  log.mk        timestamp + colored log helper
  setup.mk      stow targets
src/            stow source — mirrors home directory
  claude/       -> ~/.claude/
  fish/         -> ~/.config/fish/
  git/          -> ~/
  hypr/         -> ~/.config/hypr/
```
