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
  clearly a different shell (e.g., editing a `.zshrc` or a bash script)

---

## software management

software (cli tools, languages, desktop apps) is managed via **Nix** — don't suggest
installing packages via homebrew, apt, pacman, or manual scripts. if something needs to
be installed, it belongs in the Nix config (`~/homelab` for current machines).

this repo is a home-manager flake. when adding new components, add a module under
`modules/` and import it in `modules/nick.nix`.

---

## platform

- **personal + work devbox: Linux (NixOS)** — primary target for all configs
- **work laptop: macOS** — not a dev machine, not a focus
- when suggesting configs or tooling, default to Linux unless context is explicitly macOS
- `hypr`, `waybar`, `wofi`, `kitty` are Wayland/Linux-only — don't suggest them in macOS contexts

---

## editor

**Helix** (`hx`) is the editor of choice. VSCode/neovim/vim references are legacy.
Helix config lives in `modules/helix/`.

---

## what to avoid

- don't suggest VSCode extensions, settings.json, or `.vscode/` anything
- don't assume `git` will always be the VCS (see above)
- don't add dependencies silently - if something needs to be installed, say so explicitly
- don't refactor working configs just to make them "cleaner" without being asked
- don't suggest steps that only work on macOS — personal configs are Linux-first
