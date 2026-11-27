"""tests for senzu's pre-commit and commit-msg hooks in src/git/.config/git/hooks/senzu.

each hook runs straight from the repo, against a scratch repo and a bare env,
the way git runs it before a commit. nothing here commits. the seeded secret is
built at runtime, so this file never holds one.
"""
import hashlib
import os
import shutil
import subprocess
import tempfile
import unittest

ROOT = os.path.join(os.path.dirname(os.path.abspath(__file__)), "..")
HOOKS = os.path.join(ROOT, "src", "git", ".config", "git", "hooks", "senzu")
HOOK = os.path.join(HOOKS, "pre-commit")
MSG_HOOK = os.path.join(HOOKS, "commit-msg")
SECRET = "ghp_" + hashlib.sha256(b"a seeded secret").hexdigest()[:36]
# a gitleaks config that waves every github token through
ALLOW_ALL = "[extend]\nuseDefault = true\n[allowlist]\nregexes = ['''ghp_''']\n"


def no_gitleaks_path(home):
    """a PATH dir with git and sh, and no gitleaks."""
    bare = os.path.join(home, "bin")
    os.makedirs(bare)
    for tool in ("git", "sh"):
        os.symlink(shutil.which(tool), os.path.join(bare, tool))
    return bare


class PreCommit(unittest.TestCase):
    def setUp(self):
        tmp = tempfile.TemporaryDirectory()
        self.addCleanup(tmp.cleanup)
        self.home = os.path.realpath(tmp.name)
        self.repo = os.path.join(self.home, "repo")
        self.env = {"HOME": self.home, "PATH": os.environ.get("PATH", "/usr/bin:/bin")}
        os.makedirs(self.repo)
        self.git("init", "-q")
        self.write("clean.md", "nothing to see here\n")
        self.write("secret.md", f'token = "{SECRET}"\n')

    def git(self, *args, env=None):
        subprocess.run(["git", *args], cwd=self.repo, env={**self.env, **(env or {})}, check=True, capture_output=True)

    def write(self, name, text):
        with open(os.path.join(self.repo, name), "w") as f:
            f.write(text)

    def hook(self, env=None):
        return subprocess.run([HOOK], cwd=self.repo, env={**self.env, **(env or {})}, capture_output=True, text=True, timeout=60)

    def test_a_staged_secret_blocks(self):
        self.git("add", "secret.md")
        self.assertNotEqual(self.hook().returncode, 0)

    def test_a_secret_in_the_index_git_commit_paths_uses_blocks(self):
        # `git commit -- <file>` builds a temporary index and hands it to the hook
        index = {"GIT_INDEX_FILE": os.path.join(self.home, "commit-index")}
        self.git("update-index", "--add", "secret.md", env=index)
        self.assertNotEqual(self.hook(env=index).returncode, 0)

    def test_clean_staged_files_pass(self):
        os.remove(os.path.join(self.repo, "secret.md"))
        self.git("add", "clean.md")
        p = self.hook()
        self.assertEqual(p.returncode, 0, p.stdout + p.stderr)

    def test_a_secret_only_in_the_worktree_passes(self):
        # the staged copy is clean; the secret is an edit nobody staged
        self.git("add", "clean.md")
        self.write("clean.md", f'token = "{SECRET}"\n')
        self.assertEqual(self.hook().returncode, 0)

    def test_no_gitleaks_blocks(self):
        self.git("add", "clean.md")
        p = self.hook(env={"PATH": no_gitleaks_path(self.home)})
        self.assertNotEqual(p.returncode, 0)
        self.assertIn("gitleaks isn't installed", p.stderr)

    def test_a_found_secret_stays_out_of_the_output(self):
        self.git("add", "secret.md")
        p = self.hook()
        self.assertIn("secret.md", p.stdout + p.stderr)
        self.assertNotIn(SECRET, p.stdout + p.stderr)

    def test_the_hook_is_executable(self):
        # git skips a hook it can't execute, and the commit goes through unscanned
        self.assertTrue(os.access(HOOK, os.X_OK))

    # each of these would wave the secret through an unpinned gitleaks

    def test_an_inline_gitleaks_allow_still_blocks(self):
        self.write("secret.md", f'token = "{SECRET}" # gitleaks:allow\n')
        self.git("add", "secret.md")
        self.assertNotEqual(self.hook().returncode, 0)

    def test_a_gitleaksignore_in_the_repo_blocks(self):
        self.write(".gitleaksignore", "secret.md:github-pat:1\n")
        self.git("add", "secret.md")
        p = self.hook()
        self.assertNotEqual(p.returncode, 0)
        self.assertIn("the owner decides", p.stderr)

    def test_a_gitleaks_toml_in_the_repo_still_blocks(self):
        self.write(".gitleaks.toml", ALLOW_ALL)
        self.git("add", "secret.md")
        self.assertNotEqual(self.hook().returncode, 0)

    def test_a_gitleaks_config_in_the_env_still_blocks(self):
        self.write("allow.toml", ALLOW_ALL)
        self.git("add", "secret.md")
        for env in ({"GITLEAKS_CONFIG": os.path.join(self.repo, "allow.toml")}, {"GITLEAKS_CONFIG_TOML": ALLOW_ALL}):
            with self.subTest(env=list(env)):
                self.assertNotEqual(self.hook(env=env).returncode, 0)


class CommitMsg(unittest.TestCase):
    """commit-msg scans the message file git hands it, from the repo root."""

    def setUp(self):
        tmp = tempfile.TemporaryDirectory()
        self.addCleanup(tmp.cleanup)
        self.home = os.path.realpath(tmp.name)
        self.env = {"HOME": self.home, "PATH": os.environ.get("PATH", "/usr/bin:/bin")}
        self.msg = os.path.join(self.home, "COMMIT_EDITMSG")

    def write(self, name, text):
        with open(os.path.join(self.home, name), "w") as f:
            f.write(text)

    def hook(self, message, env=None):
        self.write("COMMIT_EDITMSG", message)
        return subprocess.run([MSG_HOOK, self.msg], cwd=self.home, env={**self.env, **(env or {})}, capture_output=True, text=True, timeout=60)

    def test_a_secret_in_the_message_blocks(self):
        self.assertNotEqual(self.hook(f"chore(beans): token {SECRET}\n").returncode, 0)

    def test_a_clean_message_passes(self):
        p = self.hook("chore(beans): water the beans\n")
        self.assertEqual(p.returncode, 0, p.stdout + p.stderr)

    def test_no_gitleaks_blocks(self):
        p = self.hook("chore(beans): water the beans\n", env={"PATH": no_gitleaks_path(self.home)})
        self.assertNotEqual(p.returncode, 0)
        self.assertIn("gitleaks isn't installed", p.stderr)

    def test_a_found_secret_stays_out_of_the_output(self):
        p = self.hook(f"chore(beans): token {SECRET}\n")
        self.assertNotIn(SECRET, p.stdout + p.stderr)

    def test_the_hook_is_executable(self):
        self.assertTrue(os.access(MSG_HOOK, os.X_OK))

    # each of these would wave the secret through an unpinned gitleaks

    def test_an_inline_gitleaks_allow_still_blocks(self):
        self.assertNotEqual(self.hook(f"chore(beans): token {SECRET} gitleaks:allow\n").returncode, 0)

    def test_a_gitleaksignore_in_the_repo_blocks(self):
        self.write(".gitleaksignore", ":github-pat:1\n")
        p = self.hook(f"chore(beans): token {SECRET}\n")
        self.assertNotEqual(p.returncode, 0)
        self.assertIn("the owner decides", p.stderr)

    def test_a_gitleaks_toml_in_the_repo_still_blocks(self):
        self.write(".gitleaks.toml", ALLOW_ALL)
        self.assertNotEqual(self.hook(f"chore(beans): token {SECRET}\n").returncode, 0)

    def test_a_gitleaks_config_in_the_env_still_blocks(self):
        self.write("allow.toml", ALLOW_ALL)
        for env in ({"GITLEAKS_CONFIG": os.path.join(self.home, "allow.toml")}, {"GITLEAKS_CONFIG_TOML": ALLOW_ALL}):
            with self.subTest(env=list(env)):
                self.assertNotEqual(self.hook(f"chore(beans): token {SECRET}\n", env=env).returncode, 0)


class Wiring(unittest.TestCase):
    """senzu's gitconfig points git at the hook, and no other repo gets it."""

    def setUp(self):
        tmp = tempfile.TemporaryDirectory()
        self.addCleanup(tmp.cleanup)
        self.home = os.path.realpath(tmp.name)
        self.env = {"HOME": self.home, "PATH": os.environ.get("PATH", "/usr/bin:/bin"), "GIT_CONFIG_NOSYSTEM": "1"}
        for name in (".gitconfig", ".gitconfig-iamnande", ".gitconfig-iamnande-senzu"):
            os.symlink(os.path.join(ROOT, "src", "git", name), os.path.join(self.home, name))
        self.senzu = os.path.join(self.home, "src", "iamnande", "senzu")

    def hooks_path(self, repo):
        os.makedirs(repo, exist_ok=True)
        subprocess.run(["git", "init", "-q", repo], env=self.env, check=True, capture_output=True)
        p = subprocess.run(["git", "-C", repo, "rev-parse", "--git-path", "hooks"], env=self.env, check=True, capture_output=True, text=True)
        return os.path.normpath(os.path.join(repo, p.stdout.strip()))

    def test_senzu_uses_the_hook(self):
        self.assertEqual(self.hooks_path(self.senzu), os.path.join(self.home, ".config", "git", "hooks", "senzu"))

    def test_a_repo_nested_in_senzu_keeps_its_own_hooks(self):
        self.hooks_path(self.senzu)
        nested = os.path.join(self.senzu, "references", "nested")
        self.assertEqual(self.hooks_path(nested), os.path.join(nested, ".git", "hooks"))

    def test_a_sibling_repo_keeps_its_own_hooks(self):
        sibling = os.path.join(self.home, "src", "iamnande", "senzu-rs")
        self.assertEqual(self.hooks_path(sibling), os.path.join(sibling, ".git", "hooks"))


if __name__ == "__main__":
    unittest.main()
