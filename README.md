# dotfiles

i use `stow` to manage my dotfiles. `Perl` was such a joy.

i use `arch` (`hypr`, `ghostty`, `fish`, `zellij`), btw. nix is coming.

## preflight to launch

1. _"(`:proud-bufo-is-excited:`) houston, roci - i need a guidance package
   before launch. i'm sending credentials for clearance."_

```fish
sudo pacman -Syu stow
```

2. _"(`:bufo-is-a-little-worried-but-still-trying-to-be-supportive:`) houston,
   confirm launch clearance?"_,

```fish
git clone git@github.com:iamnande/dotfiles.git ~/src/iamnande/dotfiles
```

3.  _"(`:bufo-is-exhausted-rooting-for-the-anti-hero:`) uhhhhh, roci this izzzz
    houstonn... i'm gonna need you to **c**hange **d**irectionction to
    `~/src/iamnande/dotfiles`, confirm."_

```fish
cd ~/src/iamnande/dotfiles
```

4. _"(`:bufo-offers-coffee:`) roger, houston. new direction confirmed.
   initiating launch."_

```
make backgrounds fish fisher ghostty git helix ssh zellij
```

## launch codes

| code            | payload                                                |
| --------------- | ------------------------------------------------------ |
| `agents`        | jensen paraphernalia                                   |
| `backgrounds`   | bg rotashe of the day, chefs finest                    |
| `fish`          | steak (jk, its fish)                                   |
| `fisher` (tide) | bobby (where is he? idk, idk; my prompt)               |
| `ghostty`       | one miniature hashi doll plz (terminal)                |
| `git`           | key, what key? oh that key                             |
| `helix`         | i still miss early goland and prime nvim               |
| `hypr`          | desktop controller                                     |
| `mako`          | big notification energy                                |
| `ssh`           | these are not the droids you're looking for            |
| `waybar`        | who put that BAR WAY up there?                         |
| `wofi`          | service pad                                            |
| `zellij`        | there's a surprising amount of tabs and panes in space |
