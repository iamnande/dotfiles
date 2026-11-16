# dotfiles

> the dotfiles are in the computer?!

in the computer, it's so simple.

## how do we do it?

> "say the line!"
>
> sr+ swes: "_sigh_ it depends"

so, it depends on the box. this split is accepted "for the love of the game",
and strong security principles are so hot these days.

peep the [homelab] for more info if you're curious.

### profiles

there are 3 primary use-cases served:

1. `workstation` - (usually) a macbook of some kind
2. `desktop` - custom build gaming & dev tower
3. [homelab] - various devices to serve homelabing needs

these distinct needs are called "profiles".

| profile                | boxes             | config            | packages |
| ---------------------- | ----------------- | ----------------- | -------- |
| `@profile/workstation` | workstation       | make + stow       | brew     |
| `@profile/desktop`     | rocinante         | nix via [homelab] | nix      |
| `@profile/managed`     | sector7 & friends | nix via [homelab] | nix      |

the work mac gets a superb pairing of
[make](https://www.gnu.org/software/make/manual/make.html#Overview) and
[stow](https://www.gnu.org/software/stow/manual/stow.html#Introduction)

everything else is nix, where [homelab] pulls in the [dotfiles] as a flake.

[homelab]: https://github.com/iamnande/homelab
[dotfiles]: https://github.com/iamnande/dotfiles

## fresh box?

on workstations:

```
make @bootstrap              # software deps
make @profile/workstation    # link it all up
```

on anything nix: go see [homelab]. this repo just sits there and looks pretty.

## talk is cheap, show me the code

```
Brewfile          # what brew installs on the work mac
Makefile          # install mechanics
docs/             # guides, info, DOCS (duh), etc.
mk/               # have i told you about King Make?
src/
  <category>/
    <package>/    # a stow package, with $HOME as the assumed root
  <package>/      # a package with no category (git, ssh)
```

## how the bits fit

the component name is the path. make drops the `@` and hands the rest to stow:

```
make @shell/fish  ->  cd src/shell && stow fish
make @git         ->  cd src && stow git
make @shell       ->  every @shell/* below it
```

- a folder is a category or a package, never both
- a category target pulls in its kids, nothing more
- a component is either `stow` (a folder) or `script` (a recipe, no folder)
- programs with no config (lazygit, the lsps) aren't components at all, they're
  just a line in the Brewfile (or a nix package)
- make runs a shared prerequisite once, so overlapping groups are fine

fish is the one weirdo. it's stowed with `--no-folding`, so `~/.config/fish` is
a real folder and only the files in here get linked. fisher, tide and fish
itself scribble a bunch of state in there, and none of it belongs in git.

> [!WARNING]
>
> moving a package? unstow it from the old spot first. links into the old folder
> block the new stow with `existing target is not owned by stow`.

## components

`make` only builds the workstation. the nix-only rows still live in `src/`,
homelab just does the linking.

| component              | source                            | make | nix |
| ---------------------- | --------------------------------- | :--: | :-: |
| `@apps` (all)          |                                   |      | ✅  |
| `@apps/claude`         | `src/apps/claude` + guardrails    |      | ✅  |
| `@apps/senzu`          | senzu-rs, after `@apps/claude`    |      | ✅  |
| `@bootstrap`           | script: brew + `brew bundle`      |  ✅  |     |
| `@desktop` (all)       |                                   |      | ✅  |
| `@desktop/backgrounds` | `src/desktop/backgrounds`         |      | ✅  |
| `@desktop/hypr`        | `src/desktop/hypr`                |      | ✅  |
| `@desktop/mako`        | `src/desktop/mako`                |      | ✅  |
| `@desktop/tools`       | `src/desktop/tools` (bop, etc.)   |      | ✅  |
| `@desktop/waybar`      | `src/desktop/waybar`              |      | ✅  |
| `@desktop/wofi`        | `src/desktop/wofi`                |      | ✅  |
| `@git`                 | `src/git`                         |  ✅  | ✅  |
| `@ide` (all)           |                                   |  ✅  | ✅  |
| `@ide/helix`           | `src/ide/helix`                   |  ✅  | ✅  |
| `@shell` (all)         |                                   |  ✅  | ✅  |
| `@shell/fish`          | `src/shell/fish` (`--no-folding`) |  ✅  | ✅  |
| `@shell/fisher`        | script, after `@shell/fish`       |  ✅  |     |
| `@shell/tide`          | script, after `@shell/fisher`     |  ✅  |     |
| `@ssh`                 | `src/ssh`                         |  ✅  | ✅  |
| `@ssh/key` (hardware)  | script                            |  ✅  | ✅  |
| `@terminal` (all)      |                                   |  ✅  | ✅  |
| `@terminal/ghostty`    | `src/terminal/ghostty`            |  ✅  | ✅  |
| `@terminal/zellij`     | `src/terminal/zellij`             |  ✅  | ✅  |
