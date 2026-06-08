# dotfiles

stow-managed configs. software via pacman/yay.

## activation

```fish
git clone git@github.com:iamnande/dotfiles.git ~/dotfiles
make -C ~/dotfiles all          # all components
make -C ~/dotfiles <component>  # single component
```

## components

| component | target |
|---|---|
| `backgrounds` | `~/.config/backgrounds/` |
| `claude` | `~/.claude/` |
| `fish` | `~/.config/fish/` |
| `git` | `~/` |
| `hypr` | `~/.config/hypr/` |
| `kitty` | `~/.config/kitty/` |
| `waybar` | `~/.config/waybar/` |
| `wofi` | `~/.config/wofi/` |

## structure

```
Makefile
mk/
  log.mk
  setup.mk
src/
  <component>/    mirrors home directory
```

## deploy log

sector7 (gmktec nucbox g10): [iamnande/iamnande#13](https://github.com/iamnande/iamnande/discussions/13)
