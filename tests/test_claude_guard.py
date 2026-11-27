"""tests for claude-guard, the PreToolUse hook in src/agents/.claude/hooks.

each test hands the guard one command, the way claude code does, and checks
that it blocks (exit 2, and why) or lets it through (exit 0). the guard and git
run with a scratch HOME and a bare env, so nothing here reads the real config
or touches a real repo, and nothing ever commits.
"""
import json
import os
import shutil
import subprocess
import tempfile
import unittest

GUARD = os.path.join(os.path.dirname(os.path.abspath(__file__)), "..", "src", "agents", ".claude", "hooks", "claude-guard")
AGENT_PATHS = ["beans/", "memory/", "references/"]
OVERRIDE = "0002 §2.7 overrides"
ENV = "GIT_DIR-style env"
OUTSIDE = "outside a state repo"
REWRITE = "writes history in a state repo"
BROKEN = "claude-guard.json is broken"
REFORM = "fix it and retry"
MAKES = "makes commits"


class Guard(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.tmp = tempfile.TemporaryDirectory()
        cls.home = os.path.realpath(cls.tmp.name)
        cls.env = {"HOME": cls.home, "PATH": os.environ.get("PATH", "/usr/bin:/bin")}
        cls.state = os.path.join(cls.home, "src", "state")
        cls.code = os.path.join(cls.home, "src", "code")
        cls.nested = os.path.join(cls.state, "references", "nested")
        for repo in (cls.state, cls.code, cls.nested):
            os.makedirs(repo)
            cls.git(repo, "init", "-q")
        for f in ("beans/a.json", "beans/b.json", "memory/m.md", "README.md", "vault/v.md", "references/nested/n.md"):
            path = os.path.join(cls.state, f)
            os.makedirs(os.path.dirname(path), exist_ok=True)
            open(path, "w").close()
        cls.git(cls.state, "config", "alias.ci", "commit")
        cls.git(cls.state, "config", "alias.fix", "commit --amend")
        cls.git(cls.state, "config", "alias.shci", "!git commit -m x -- beans/a.json")
        cls.git(cls.code, "config", "alias.up", "pull --rebase --autostash")
        cls.config_path = os.path.join(cls.home, ".claude", "hooks", "claude-guard.json")
        os.makedirs(os.path.dirname(cls.config_path))

    @classmethod
    def tearDownClass(cls):
        cls.tmp.cleanup()

    @classmethod
    def git(cls, repo, *args):
        subprocess.run(["git", "-C", repo, *args], env=cls.env, check=True, capture_output=True)

    def setUp(self):
        self.config({"state_repos": [{"path": "~/src/state", "agent_paths": AGENT_PATHS}]})

    def config(self, data):
        """write claude-guard.json: a dict as json, a str as is, None removes it."""
        if data is None:
            os.remove(self.config_path)
            return
        with open(self.config_path, "w") as f:
            f.write(data if isinstance(data, str) else json.dumps(data))

    def agent_paths(self, *paths):
        self.config({"state_repos": [{"path": "~/src/state", "agent_paths": list(paths)}]})

    def guard(self, cmd, cwd=None, env=None):
        hook_input = json.dumps({"tool_input": {"command": cmd}, "cwd": cwd or self.state})
        return subprocess.run([GUARD], input=hook_input, env={**self.env, **(env or {})}, capture_output=True, text=True, timeout=30)

    def allowed(self, cmd, cwd=None, env=None):
        p = self.guard(cmd, cwd, env)
        self.assertEqual(p.returncode, 0, f"{cmd!r} was blocked: {p.stderr}")

    def blocked(self, cmd, says, cwd=None, env=None):
        p = self.guard(cmd, cwd, env)
        self.assertEqual(p.returncode, 2, f"{cmd!r} went through")
        self.assertIn(says, p.stderr)

    # an agent commit in the state repo, in the one shape it may take

    def test_commit_one_agent_file(self):
        self.allowed("git commit -m 'beans: a' -- beans/a.json")

    def test_commit_files_relative_to_a_subdir(self):
        self.allowed("git commit -m x -- a.json ../memory/m.md", cwd=os.path.join(self.state, "beans"))

    def test_commit_with_dash_C(self):
        self.allowed("git -C src/state commit -m x -- beans/a.json", cwd=self.home)

    def test_commit_after_cd_and_add(self):
        self.allowed("cd src/state && git add beans/b.json && git commit -q -m x -- beans/b.json", cwd=self.home)

    def test_commit_message_from_a_file(self):
        self.allowed("git commit -F /tmp/msg -- beans/a.json")

    def test_commit_a_deleted_file(self):
        self.allowed("git commit -m x -- beans/gone.json")

    def test_commit_message_may_name_git_env(self):
        self.allowed("git commit -m 'GIT_AUTHOR_NAME and GIT_DIR stay blocked' -- beans/a.json")

    def test_commit_through_an_alias(self):
        self.allowed("git ci -m x -- beans/a.json")

    def test_nested_repo_under_an_agent_path_isnt_config(self):
        self.allowed("git commit -m x -- beans/a.json")

    # where a commit may happen

    def test_commit_in_a_code_repo(self):
        self.blocked("git commit -m x -- beans/a.json", OUTSIDE, cwd=self.code)

    def test_commit_in_a_repo_nested_in_the_state_repo(self):
        self.blocked("git commit -m x -- n.md", OUTSIDE, cwd=self.nested)

    def test_commit_with_no_config(self):
        self.config(None)
        self.blocked("git commit -m x -- beans/a.json", OUTSIDE)

    def test_commit_in_a_dir_the_guard_cant_resolve(self):
        self.blocked("cd $SOMEWHERE && git commit -m x -- beans/a.json", "can't resolve")

    def test_commit_tree(self):
        self.blocked("git commit-tree HEAD^{tree} -m x", "commit-tree", cwd=self.code)

    # which files it may take

    def test_commit_without_paths(self):
        self.blocked("git commit -m x", "another session's staging")

    def test_commit_without_a_message(self):
        self.blocked("git commit -- beans/a.json", "no -m")

    def test_commit_outside_the_agent_paths(self):
        self.blocked("git commit -m x -- README.md", "isn't under an agent path")

    def test_commit_the_owners_vault(self):
        self.blocked("git commit -m x -- vault/v.md", "isn't under an agent path")

    def test_commit_climbing_out_of_an_agent_path(self):
        self.blocked("git commit -m x -- beans/../README.md", "isn't under an agent path")

    def test_commit_outside_the_repo(self):
        self.blocked("git commit -m x -- ../code/c.md", "outside the state repo")

    def test_commit_a_directory(self):
        self.blocked("git commit -m x -- beans/", "is a directory")

    def test_commit_a_whole_agent_path(self):
        self.blocked("git commit -m x -- beans", "is a directory")

    def test_commit_a_glob(self):
        self.blocked("git commit -m x -- 'beans/*.json'", "no globs")

    def test_commit_pathspec_magic(self):
        self.blocked("git commit -m x -- ':(top)beans/a.json'", "no globs")

    def test_commit_claude_settings_under_an_agent_path(self):
        self.blocked("git commit -m x -- memory/.claude/settings.json", "never an agent path")

    def test_commit_skills_under_an_agent_path(self):
        self.blocked("git commit -m x -- beans/skills/s.md", "never an agent path")

    def test_commit_claude_md_under_an_agent_path(self):
        self.blocked("git commit -m x -- memory/CLAUDE.md", "never an agent path")

    def test_commit_agents_md_under_an_agent_path(self):
        self.blocked("git commit -m x -- beans/AGENTS.md", "never an agent path")

    def test_commit_into_a_git_dir(self):
        self.blocked("git commit -m x -- beans/.git/config", "never an agent path")

    def test_commit_with_an_unknown_flag_can_be_fixed(self):
        self.blocked("git commit -a -m x -- beans/a.json", REFORM)

    # the overrides 0002 §2.7 names, one test each

    def test_override_dash_c(self):
        self.blocked("git -c user.name=x commit -m x -- beans/a.json", OVERRIDE)

    def test_override_config_env(self):
        self.blocked("git --config-env=user.name=NAME commit -m x -- beans/a.json", OVERRIDE)

    def test_override_git_dir_flag(self):
        self.blocked("git --git-dir=.git commit -m x -- beans/a.json", OVERRIDE)

    def test_override_author(self):
        self.blocked("git commit --author='x <x@x>' -m x -- beans/a.json", OVERRIDE)

    def test_override_dash_S(self):
        self.blocked("git commit -S -m x -- beans/a.json", OVERRIDE)

    def test_override_dash_S_with_a_key(self):
        self.blocked("git commit -Sabc123 -m x -- beans/a.json", OVERRIDE)

    def test_override_gpg_sign(self):
        self.blocked("git commit --gpg-sign=abc123 -m x -- beans/a.json", OVERRIDE)

    def test_override_no_gpg_sign(self):
        self.blocked("git commit --no-gpg-sign -m x -- beans/a.json", OVERRIDE)

    def test_override_no_verify(self):
        self.blocked("git commit --no-verify -m x -- beans/a.json", OVERRIDE)

    def test_override_dash_n(self):
        self.blocked("git commit -n -m x -- beans/a.json", OVERRIDE)

    def test_override_amend(self):
        self.blocked("git commit --amend -m x -- beans/a.json", OVERRIDE)

    def test_override_amend_through_an_alias(self):
        self.blocked("git fix -m x -- beans/a.json", OVERRIDE)

    def test_override_shell_alias_under_dash_c(self):
        self.blocked("git -c user.name=x shci", "shell alias")

    def test_override_author_env(self):
        self.blocked("GIT_AUTHOR_NAME=x git commit -m x -- beans/a.json", ENV)

    def test_override_committer_env(self):
        self.blocked("env GIT_COMMITTER_EMAIL=x@x git commit -m x -- beans/a.json", ENV)

    def test_override_config_env_var(self):
        self.blocked("export GIT_CONFIG_GLOBAL=/dev/null && git commit -m x -- beans/a.json", ENV)

    def test_override_env_set_without_an_equals(self):
        self.blocked("read GIT_AUTHOR_NAME <<< x; export GIT_AUTHOR_NAME; git commit -m x -- beans/a.json", ENV)

    def test_override_git_dir_env(self):
        self.blocked("GIT_DIR=../code/.git git commit -m x -- beans/a.json", ENV)

    def test_override_env_the_session_inherited(self):
        self.blocked("git commit -m x -- beans/a.json", ENV, env={"GIT_AUTHOR_EMAIL": "x@x"})

    def test_commit_fed_by_xargs(self):
        self.blocked("echo beans/a.json | xargs git commit -m x --", "fed by xargs")

    def test_override_repo_config(self):
        # a `git config` lasts past its command, so the guard reads the config at commit time
        for key, value in (("core.hooksPath", "/dev/null"), ("user.email", "x@x"), ("user.signingKey", "~/k"),
                           ("commit.gpgSign", "false"), ("gpg.ssh.program", "/bin/true"), ("include.path", "/tmp/x"),
                           ("includeIf.gitdir:/.path", "/tmp/x")):
            with self.subTest(key=key):
                self.git(self.state, "config", key, value)
                try:
                    self.blocked("git commit -m x -- beans/a.json", OVERRIDE)
                finally:
                    self.git(self.state, "config", "--unset", key)

    def test_override_worktree_config(self):
        self.git(self.state, "config", "extensions.worktreeConfig", "true")
        self.addCleanup(self.git, self.state, "config", "--unset", "extensions.worktreeConfig")
        self.git(self.state, "config", "--worktree", "core.hooksPath", "/dev/null")
        self.addCleanup(self.git, self.state, "config", "--worktree", "--unset", "core.hooksPath")
        self.blocked("git commit -m x -- beans/a.json", OVERRIDE)

    # commits made any other way, everywhere (0001 §2.3)

    def test_commit_makers(self):
        for cmd in ("git cherry-pick --no-gpg-sign abc123", "git -c commit.gpgSign=false revert HEAD", "git am x.patch",
                    "git rebase main", "git merge other", "git merge --no-ff -m x other", "git pull", "git pull --rebase",
                    "git fast-import", "git filter-branch --tree-filter true", "git filter-repo --path x",
                    "git subtree add --prefix=x ../state main"):
            with self.subTest(cmd=cmd):
                self.blocked(cmd, MAKES, cwd=self.code)

    def test_commit_makers_through_an_alias(self):
        self.blocked("git up", MAKES, cwd=self.code)

    # history writes in the state repo stay the owner's

    def test_state_rebase(self):
        self.blocked("git rebase main", REWRITE)

    def test_state_reset(self):
        self.blocked("git reset --hard HEAD", REWRITE)

    def test_state_update_ref(self):
        self.blocked("git update-ref refs/heads/main HEAD", REWRITE)

    def test_state_cherry_pick(self):
        self.blocked("git cherry-pick abc123", REWRITE)

    def test_state_revert(self):
        self.blocked("git revert HEAD", REWRITE)

    def test_state_am(self):
        self.blocked("git am x.patch", REWRITE)

    def test_state_filter_branch(self):
        self.blocked("git filter-branch --tree-filter true", REWRITE)

    def test_state_filter_repo(self):
        self.blocked("git filter-repo --path beans", REWRITE)

    def test_state_replace(self):
        self.blocked("git replace abc123 def456", REWRITE)

    def test_state_merge(self):
        self.blocked("git merge other", REWRITE)

    def test_state_pull(self):
        self.blocked("git pull --rebase", REWRITE)

    def test_state_tag(self):
        self.blocked("git tag v1", REWRITE)

    def test_state_tag_delete(self):
        self.blocked("git tag -d v1", REWRITE)

    def test_state_branch_create(self):
        self.blocked("git branch other", REWRITE)

    def test_state_branch_upstream(self):
        self.blocked("git branch --unset-upstream", REWRITE)

    def test_state_checkout_new_branch(self):
        self.blocked("git checkout -b other", REWRITE)

    def test_state_switch_new_branch(self):
        self.blocked("git switch -c other", REWRITE)

    def test_state_stash(self):
        self.blocked("git stash", REWRITE)

    def test_state_stash_pop(self):
        self.blocked("git stash pop", REWRITE)

    def test_state_rewrite_with_git_dir(self):
        self.blocked("git --git-dir=.git reset --hard HEAD", "can't place")

    def test_state_fast_import(self):
        self.blocked("git fast-import", REWRITE)

    def test_state_subtree(self):
        self.blocked("git subtree add --prefix=.claude/skills ../code main", REWRITE)

    def test_state_fetch_into_a_branch(self):
        self.blocked("git fetch . +HEAD~1:refs/heads/main", REWRITE)

    def test_state_pull_into_a_branch(self):
        self.blocked("git pull --ff-only . HEAD~1:refs/heads/main", REWRITE)

    def test_state_worktree_add(self):
        self.blocked("git worktree add ../x", REWRITE)

    def test_state_notes_add(self):
        self.blocked("git notes add -m x HEAD", REWRITE)

    def test_state_symbolic_ref(self):
        self.blocked("git symbolic-ref HEAD refs/heads/other", REWRITE)

    def test_state_reflog_expire(self):
        self.blocked("git reflog expire --expire=now --all", REWRITE)

    def test_state_unlisted_commands(self):
        # a list of reads fails closed on a command nobody listed, builtin or not
        for cmd in ("git gc", "git absorb"):
            with self.subTest(cmd=cmd):
                self.blocked(cmd, REWRITE)

    def test_state_reads(self):
        for cmd in ("git status", "git log --oneline", "git diff", "git tag", "git tag -l 'v*'", "git branch",
                    "git branch --show-current", "git stash list", "git restore --staged beans/a.json",
                    "git checkout -- beans/a.json", "git add beans/a.json", "git rm beans/a.json",
                    "git mv beans/a.json beans/c.json", "git show HEAD", "git rev-parse HEAD", "git fetch",
                    "git fetch origin main", "git ls-remote origin", "git config --get user.name", "git reflog",
                    "git notes list", "git worktree list", "git clone ../code /tmp/x", "git init /tmp/y"):
            with self.subTest(cmd=cmd):
                self.allowed(cmd)

    def test_state_fast_forwards(self):
        self.allowed("git pull --ff-only && git merge --ff-only origin/main")

    def test_code_repo_history_stays_as_it_was(self):
        self.allowed("git reset --hard HEAD && git checkout -b x && git stash && git pull --ff-only", cwd=self.code)

    # the config: broken or unsafe means no agent commits

    def test_config_malformed(self):
        self.config("{")
        self.blocked("git commit -m x -- beans/a.json", BROKEN)

    def test_config_malformed_blocks_state_rewrites(self):
        self.config("{")
        self.blocked("git reset --hard HEAD", BROKEN)

    def test_config_without_state_repos(self):
        self.config({})
        self.blocked("git commit -m x -- beans/a.json", BROKEN)

    def test_config_relative_repo_path(self):
        self.config({"state_repos": [{"path": "src/state", "agent_paths": AGENT_PATHS}]})
        self.blocked("git commit -m x -- beans/a.json", BROKEN)

    def test_config_agent_path_dot_claude(self):
        self.agent_paths("beans/", ".claude/")
        self.blocked("git commit -m x -- beans/a.json", BROKEN)

    def test_config_agent_path_skills(self):
        self.agent_paths("beans/", "skills/")
        self.blocked("git commit -m x -- beans/a.json", BROKEN)

    def test_config_agent_path_hooks(self):
        self.agent_paths("beans/", "hooks")
        self.blocked("git commit -m x -- beans/a.json", BROKEN)

    def test_config_agent_path_settings(self):
        self.agent_paths("beans/", "settings.json")
        self.blocked("git commit -m x -- beans/a.json", BROKEN)

    def test_config_agent_path_repo_root(self):
        self.agent_paths(".")
        self.blocked("git commit -m x -- beans/a.json", BROKEN)

    def test_config_agent_path_absolute(self):
        self.agent_paths("beans/", "/no/such/dir")
        self.blocked("git commit -m x -- beans/a.json", BROKEN)

    def test_config_agent_path_climbing_out(self):
        self.agent_paths("beans/", "../code")
        self.blocked("git commit -m x -- beans/a.json", BROKEN)

    def test_config_agent_path_holding_hooks(self):
        os.makedirs(os.path.join(self.state, "memory", "x", "hooks"))
        self.addCleanup(shutil.rmtree, os.path.join(self.state, "memory", "x"))
        self.blocked("git commit -m x -- beans/a.json", "holds hooks")

    def test_config_nested_repo_files_arent_config(self):
        # a repo cloned under an agent path brings its own AGENTS.md, which this repo can't commit
        path = os.path.join(self.nested, "AGENTS.md")
        open(path, "w").close()
        self.addCleanup(os.remove, path)
        self.allowed("git commit -m x -- beans/a.json")


if __name__ == "__main__":
    unittest.main()
