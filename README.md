# dotfiles

stow-managed configs. software via pacman/yay (for now - we'll figure something out here soon).

## setup

```fish
git clone git@github.com:iamnande/dotfiles.git ~/dotfiles
cd ~/dotfiles
make all          # all components
make <component>  # single component
```

## components

| component | target |
|---|---|
| `backgrounds` | `~/.config/backgrounds/` |
| `fish` | `~/.config/fish/` |
| `git` | `~/` |
| `hypr` | `~/.config/hypr/` |
| `kitty` | `~/.config/kitty/` |
| `nvim` | `~/.config/nvim/` |
| `waybar` | `~/.config/waybar/` |
| `wofi` | `~/.config/wofi/` |
| `zed` | `~/.config/zed/` |
| `zellij` | `~/.config/zellij/` |

## structure

```
Makefile
mk/
  log.mk
  setup.mk
src/
  <component>/    mirrors home directory
```
