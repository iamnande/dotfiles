# dotfiles

personal config files managed as a [home-manager](https://github.com/nix-community/home-manager) flake.

software (tools, languages, apps) is managed separately via Nix. this repo is configs only.

---

## home-manager flake

exposes `homeManagerModules.nick` — consumed by the homelab compute flake:

```nix
# in homelab compute/flake.nix
inputs.dotfiles.url = "github:iamnande/dotfiles";

# in a host config
imports = [ inputs.dotfiles.homeManagerModules.nick ];
```

### components

| module | manages |
|---|---|
| `modules/backgrounds/` | wallpapers (`~/.config/backgrounds/`) |
| `modules/git/` | git identity, signing (1Password SSH), aliases |
| `modules/fish/` | shell config, functions, Tide prompt |
| `modules/helix/` | editor config (everforest dark) |
| `modules/claude/` | global Claude Code context + senzu skill |
| `modules/zellij/` | multiplexer config (everforest dark) |

---

## structure

```
flake.nix       home-manager flake — exposes homeManagerModules.nick
modules/        home-manager components
  nick.nix      thin aggregator (imports all modules below)
  backgrounds/  home.file — wallpapers
  git/          programs.git
  fish/         programs.fish + tide prompt config
  helix/        programs.helix
  claude/       home.file — CLAUDE.md + senzu skill
  zellij/       programs.zellij
```
