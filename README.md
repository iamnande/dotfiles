# dotfiles

> the dotfiles are in the computer?!

in the computer, it's so simple.

## how do we do it?

these days we're rockin' a superb pairing of
[make](https://www.gnu.org/software/make/manual/make.html#Overview) and
[stow](https://www.gnu.org/software/stow/manual/stow.html#Introduction) to
orchestrate all the bits and bobs.

> [!NOTE] me in ~1 month: "sir, a second nix migration has hit the dotfiles!"

## file structure

```
Makefile          # install mechanics
docs/             # guides, info, DOCS, etc.
mk/               # have i told you about King Make?
src/
  <component>/    # component structures, with $HOME as the assumed root
```

## components

| component              |
| ---------------------- |
| `@apps` (all)          |
| `@app/senzu`           |
| `@bootstrap`           |
| `@dependencies`        |
| `@desktop` (all)       |
| `@desktop/backgrounds` |
| `@desktop/hypr`        |
| `@desktop/mako`        |
| `@desktop/tools`       |
| `@desktop/waybar`      |
| `@desktop/wofi`        |
| `@git`                 |
| `@ide` (all)           |
| `@ide/helix`           |
| `@ide/lazygit`         |
| `@ide/lsp` (all)       |
| `@ide/lsp/go`          |
| `@ide/lsp/rust`        |
| `@shell` (all)         |
| `@shell/fish`          |
| `@shell/fisher`        |
| `@shell/tide`          |
| `@ssh`                 |
| `@ssh/key` (hardware)  |
| `@terminal`            |
| `@terminal/ghostty`    |
| `@terminal/zellij`     |
