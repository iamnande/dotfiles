# dotfiles

stow-managed configs. software via pacman/yay(for now - we'll figure something
out here soon (probably brew).

## setup

```fish
git clone git@github.com:iamnande/dotfiles.git ~/dotfiles
cd ~/dotfiles
make <component>
```

## structure

```
Makefile
mk/
  log.mk
  setup.mk
src/
  <component>/    mirrors home directory
```

## components

| component     | target                   |
| ------------- | ------------------------ |
| `agents`      | global agent instructions |
| `backgrounds` | `~/.config/backgrounds/` |
| `bin`         | `~/.local/bin/`          |
| `fish`        | `~/.config/fish/`        |
| `fisher`      | fish plugins (fisher, tide, ...) |
| `git`         | `~/`                     |
| `helix`       | `~/.config/helix/`       |
| `hypr`        | `~/.config/hypr/`        |
| `kitty`       | `~/.config/kitty/`       |
| `waybar`      | `~/.config/waybar/`      |
| `wofi`        | `~/.config/wofi/`        |
| `zellij`      | `~/.config/zellij/`      |
