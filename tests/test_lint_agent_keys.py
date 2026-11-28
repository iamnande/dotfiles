"""tests for mk/lint-agent-keys, the signers lint behind `make lint`.

each test copies the git and ssh components into a scratch repo and runs the
lint there, so a seeded key never lands in the real signers files.
"""
import os
import shutil
import subprocess
import tempfile
import unittest

ROOT = os.path.join(os.path.dirname(os.path.abspath(__file__)), "..")
LINT = os.path.join(ROOT, "mk", "lint-agent-keys")
AGENT = os.path.join("src", "git", ".gitconfig-iamnande-senzu")
OWNER = os.path.join("src", "git", ".gitconfig-iamnande")


class Lint(unittest.TestCase):
    def setUp(self):
        tmp = tempfile.TemporaryDirectory()
        self.addCleanup(tmp.cleanup)
        self.repo = os.path.realpath(tmp.name)
        self.env = {"HOME": self.repo, "PATH": os.environ.get("PATH", "/usr/bin:/bin"), "GIT_CONFIG_NOSYSTEM": "1"}
        for component in ("git", "ssh"):
            shutil.copytree(os.path.join(ROOT, "src", component), os.path.join(self.repo, "src", component), symlinks=True)
        self.git("init", "-q")
        self.git("add", ".")
        self.email = self.git("config", "-f", AGENT, "user.email")
        self.own = self.signers(AGENT)
        self.line = next(l for l in self.read(self.own) if l.split()[:1] == [self.email])

    def git(self, *args):
        p = subprocess.run(["git", *args], cwd=self.repo, env=self.env, check=True, capture_output=True, text=True)
        return p.stdout.strip()

    def signers(self, conf):
        # the signers file a gitconfig names, as stow lays out ~/ under src/ssh
        path = self.git("config", "-f", conf, "gpg.ssh.allowedSignersFile")
        return os.path.join("src", "ssh", path.removeprefix("~/"))

    def read(self, path):
        with open(os.path.join(self.repo, path)) as f:
            return f.read().splitlines()

    def write(self, path, lines):
        with open(os.path.join(self.repo, path), "w") as f:
            f.write("".join(l + "\n" for l in lines))

    def lint(self, *confs):
        return subprocess.run([LINT, *confs], cwd=self.repo, env=self.env, capture_output=True, text=True)

    def test_the_real_signers_pass(self):
        p = self.lint(AGENT)
        self.assertEqual(p.returncode, 0, p.stderr)

    def test_the_agent_key_in_the_owners_signers_fails(self):
        owner = self.signers(OWNER)
        self.write(owner, self.read(owner) + [self.line])
        p = self.lint(AGENT)
        self.assertNotEqual(p.returncode, 0)
        self.assertIn(owner, p.stderr)

    def test_the_agent_key_in_an_untracked_file_fails(self):
        self.write(os.path.join("src", "ssh", ".ssh", "authorized_keys"), [self.line.split(None, 2)[2]])
        self.assertNotEqual(self.lint(AGENT).returncode, 0)

    def test_the_agent_key_under_the_owners_email_fails(self):
        # in its own file, but an agent commit would verify as the owner's
        owner = self.git("config", "-f", OWNER, "user.email")
        self.write(self.own, self.read(self.own) + [owner + self.line.removeprefix(self.email)])
        self.assertNotEqual(self.lint(AGENT).returncode, 0)

    def test_no_line_for_the_agent_alone_fails(self):
        shared = self.email + ",x@y.invalid" + self.line.removeprefix(self.email)
        self.write(self.own, [shared if l == self.line else l for l in self.read(self.own)])
        p = self.lint(AGENT)
        self.assertNotEqual(p.returncode, 0)
        self.assertIn("no line for", p.stderr)

    def test_no_gitconfig_fails(self):
        # an empty list in make would otherwise lint nothing and pass
        self.assertNotEqual(self.lint().returncode, 0)


if __name__ == "__main__":
    unittest.main()
