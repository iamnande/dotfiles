# dotfiles

personal config files, managed with [GNU Stow](https://www.gnu.org/software/stow/).

---

## packages

| target | installs to |
|---|---|
| `make backgrounds` | `~/.config/backgrounds/` |
| `make claude` | `~/.claude/` |
| `make fish` | `~/.config/fish/` |
| `make gitconfig` | `~/.gitconfig`, `~/.gitignore` |
| `make helix` | `~/.config/helix/` |
| `make hypr` | `~/.config/hypr/` |
| `make kitty` | `~/.config/kitty/` |
| `make waybar` | `~/.config/waybar/` |
| `make wofi` | `~/.config/wofi/` |
| `make zellij` | `~/.config/zellij/` |

> `hypr`, `waybar`, and `wofi` are Wayland-only. pending NUC hardware.

---

## setup

### linux (personal)

1. install deps: `stow`, `git`
2. clone and enter: `git clone <repo> && cd dotfiles`
3. stow what you need: `make fish helix zellij` (or any combination of the above)

### macos (work)

1. bootstrap: `make macos`
2. stow as needed: `make <package>`

---

## other targets

| target | description |
|---|---|
| `make version` | display current version |
| `make help` | list all available targets |
