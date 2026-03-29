# dotfiles

personal config files, managed with [GNU Stow](https://www.gnu.org/software/stow/). each
directory under `src/` mirrors `$HOME` and gets symlinked there when stowed. the goal is a
reproducible setup — clone, stow, done.

software (tools, languages, apps) is managed separately via Nix. this repo is configs only.

---

## packages

| package | installs to | description |
|---|---|---|
| `backgrounds` | `~/.config/backgrounds/` | wallpapers |
| `claude` | `~/.claude/` | global Claude Code context |
| `fish` | `~/.config/fish/` | shell config, aliases, functions (Tide prompt) |
| `gitconfig` | `~/.gitconfig`, `~/.gitignore` | git identity, signing, aliases |
| `helix` | `~/.config/helix/` | editor config (everforest dark) |
| `hypr` | `~/.config/hypr/` | Hyprland WM, hyprlock, hyprpaper — Wayland only, NUC-pending |
| `kitty` | `~/.config/kitty/` | terminal emulator (everforest dark, OpenDyslexic) |
| `waybar` | `~/.config/waybar/` | status bar — Wayland only, NUC-pending |
| `wofi` | `~/.config/wofi/` | app launcher — Wayland only, NUC-pending |
| `zellij` | `~/.config/zellij/` | terminal multiplexer |

---

## setup

### linux (personal, NixOS)

```fish
git clone <repo> && cd dotfiles
make fish helix zellij gitconfig claude  # or any combination
```

### macos (work)

```fish
make macos        # homebrew bootstrap
make gitconfig    # or any other packages as needed
```

---

## structure

```
src/          stow packages — one per tool, mirrors $HOME
mk/           makefile modules
  log.mk      logging helpers
  setup.mk    stow install targets
  macos.mk    macOS bootstrap (work only)
```

run `make help` to see all available targets.

---

## future

NixOS on personal hardware (NUC incoming) is the near-term direction — graphical setup with
Hyprland, waybar, and wofi. the `hypr`, `waybar`, and `wofi` packages are staged and ready.

stow is being replaced by home-manager iteratively — this repo will evolve into a standalone
home-manager flake, becoming the source of truth for nick's environment on any unix machine.
configs migrate one component at a time.
