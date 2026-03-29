# dotfiles

personal config files. core environment (git, fish, helix, claude) is managed as a
[home-manager](https://github.com/nix-community/home-manager) flake. desktop configs
(Wayland/Hyprland stack) are still managed with [GNU Stow](https://www.gnu.org/software/stow/).

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
| `modules/git/` | git identity, signing (1Password SSH), aliases |
| `modules/fish/` | shell config, functions, Tide prompt |
| `modules/helix/` | editor config (everforest dark) |
| `modules/claude/` | global Claude Code context + senzu skill |

---

## stow (desktop only)

Wayland/desktop configs not yet on home-manager. only relevant on dedicated desktop hardware.

| package | installs to | description |
|---|---|---|
| `backgrounds` | `~/.config/backgrounds/` | wallpapers |
| `hypr` | `~/.config/hypr/` | Hyprland WM, hyprlock, hyprpaper |
| `kitty` | `~/.config/kitty/` | terminal emulator (everforest dark, OpenDyslexic) |
| `waybar` | `~/.config/waybar/` | status bar |
| `wofi` | `~/.config/wofi/` | app launcher |

```fish
make hypr waybar wofi kitty backgrounds  # or any combination
```

### macos (work)

```fish
make macos        # homebrew bootstrap
make gitconfig    # or any other packages as needed
```

---

## structure

```
flake.nix     home-manager flake — exposes homeManagerModules.nick
modules/      home-manager components
  nick.nix    thin aggregator (imports the four below)
  git/        programs.git
  fish/       programs.fish + tide prompt config
  helix/      programs.helix
  claude/     home.file — CLAUDE.md + senzu skill
src/          stow packages — desktop/Wayland only
mk/           makefile modules
```

run `make help` to see available stow targets.
