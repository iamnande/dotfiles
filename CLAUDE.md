# CLAUDE.md - iamnande/dotfiles

this file tells Claude Code how to work in this repository. read it fully before
making any changes. for an overview of what this repo is and how it's structured,
see [README.md](README.md).

---

## version control

this repo currently uses **git**, but the intent is to migrate to
[jj (Jujutsu)](https://github.com/martinvonz/jj) in the future. when that migration
happens, this file will be updated. for now, use git - but don't write any tooling or
scripts that assume git-specific internals (`.git/` paths, `git` subprocess calls, etc.)
if there's a more portable alternative. think of it as: write for the workflow, not the
tool.

---

## code style

**follow the existing style in whatever file you're editing.** don't impose your own
preferences. specifically:

- match indentation (spaces vs tabs, width) to the file you're in
- match quoting style in shell/fish configs
- match comment style and density - if the file is terse, be terse; if it's documented,
  document your additions
- don't reformat code you didn't write just because you touched the file
- if you're unsure what the style is, read more of the file before writing

---

## shell environment

- **default shell: fish** (`/usr/bin/fish`)
- when suggesting shell snippets, default to **fish syntax** unless the context is
  clearly a different shell (e.g., editing a bash script or a makefile recipe)

---

## software management

software (cli tools, languages, desktop apps) is managed via **pacman** and **yay** (AUR).
dotfiles and configs are managed via **stow**.

structure: `src/<component>/` mirrors the home directory. to add a new component:
1. create `src/<component>/` with the config files in their target paths
2. add a target to `mk/setup.mk`
3. run `make <component>` to stow it

don't suggest nix, home-manager, or nixos - this machine is arch + stow.

---

## platform

- **personal devbox: Arch Linux (Hyprland/Wayland)** - primary target for all configs
- **work laptop: macOS** - not a dev machine, not a focus
- when suggesting configs or tooling, default to Linux unless context is explicitly macOS
- `hypr`, `waybar`, `wofi`, `kitty` are Wayland/Linux-only - don't suggest them in macOS contexts

---

## editor

**Zed** is the editor of choice. Helix/neovim/vim references are legacy.

---

## what to avoid

- don't suggest VSCode extensions, settings.json, or `.vscode/` anything
- don't suggest nix, home-manager, or nixos
- don't assume `git` will always be the VCS (see above)
- don't add dependencies silently - if something needs to be installed, say so explicitly
- don't refactor working configs just to make them "cleaner" without being asked
- don't suggest steps that only work on macOS - personal configs are Linux-first
