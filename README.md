# dotfiles
[![build](https://img.shields.io/travis/wafture/godap.svg?style=flat)](https://travis-ci.org/wafture/godap)
---

This is LARGELY based off Jess Frazelle (@jfrazelle) and her superb [dotfiles repo](https://github.com/jfrazelle/dotfiles)

**To install:**

```console
$ make
```
This will create symlinks from the checkout to your home folder.

**To customize:**

Save env vars, etc in a `.extra` file, that looks something like
this:

```bash
#
# git
#
GH_USER="nickname"
GIT_AUTHOR_NAME="Your Name"
GIT_AUTHOR_EMAIL="email@you.com"

GIT_COMMITTER_NAME="$GIT_AUTHOR_NAME"
GIT_COMMITTER_EMAIL="$GIT_AUTHOR_EMAIL"

git config --global github.user "$GH_USER"
git config --global user.name "$GIT_AUTHOR_NAME"
git config --global user.email "$GIT_AUTHOR_EMAIL"
```
