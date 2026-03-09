# CLAUDE.md - iamnande/dotfiles

this file tells Claude Code how to work in this repository. read it fully before
making any changes.

---

## what this repo is

a personal dotfiles repository managed with [GNU Stow](https://www.gnu.org/software/stow/).
each top-level directory under `src/` is a stow package - it mirrors the structure of `$HOME`
and gets symlinked there when stowed. the goal is a reproducible, portable setup that works
identically on most variants of Linux operating systems.

---

## how to navigate it

```
src/
  fish/       -> ~/.config/fish/
  helix/      -> ~/.config/helix/
  zellij/     -> ~/.config/zellij/
  ...
Makefile
mk/
  dev.mk      -> dev environment setup targets
  log.mk      -> logging helpers
  qa.mk       -> quality targets
```

when you're looking for a config file, start in `src/<tool>/`. don't assume flat structure —
always check the actual directory layout before suggesting paths.

---

## task runner

**use `make` targets, not raw commands.** the `Makefile` composes targets from `mk/*.mk`.
before running any install, lint, or setup command, check if a make target already exists:

```fish
cat Makefile
cat mk/dev.mk
cat mk/qa.mk
```

if a task doesn't have a make target yet and it's something that will be run repeatedly,
suggest adding one rather than just running the raw command ad-hoc.

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

## future: Nix

Nix is on the radar as a potential path toward fully reproducible environment management,
but there are no current plans or timeline. don't suggest Nix-based solutions for
immediate problems - note it as a future option at most.

---

## editor

**Helix** (`hx`) is the editor of choice. VSCode/neovim references are legacy.
the `vim` alias points to `nvim` currently but that's transitional - don't rely on it.
Helix config lives in `src/helix/.config/helix/`.

---

## what "reproducible" means here

the north star is: clone this repo on a fresh machine, run a bootstrap make target,
and get a working environment. we're not fully there yet, but every change should move
toward that goal, not away from it. concretely:

- prefer declarative config over imperative setup steps
- if you add a dependency, note it somewhere (a make target, a README, a comment)
- don't suggest steps that only work on one OS without flagging it - this needs to work
  on at least Darwin, Arch, and Ubuntu

---

## what to avoid

- don't suggest VSCode extensions, settings.json, or `.vscode/` anything
- don't assume `git` will always be the VCS (see above)
- don't add dependencies silently - if something needs to be installed, say so explicitly
- don't refactor working configs just to make them "cleaner" without being asked
