# dotfiles

**To install:**
You have options!

```console
$ make
mac    => setup mac workstation
centos => setup centos/rhel machine
clean  => clean workspace symlinks
links  => clean workspace symlinks
```

**To customize:**

Save env vars, etc in a `.extras` file, that looks something like
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
