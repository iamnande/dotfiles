# rfc 0001: house rules

|           |            |
| --------- | ---------- |
| status    | aligned    |
| updates   | none       |
| obsoletes | none       |
| date      | 2026-11-22 |
| author    | @iamnande  |

## abstract

house rules establish how work moves from an idea to a realized change. one base
workflow ships everywhere by default, and each distinct ecosystem adds its own
ruleset on top to supplement. this rfc sets the base expectations that hold true
throughout all ecosystems - its phases and gates, and how a ruleset may extend
the house rules, but not override them.

## terminology

the keywords `MUST`, `MUST NOT`, `SHOULD`, `SHOULD NOT` and `MAY` are to be read
as described in [bcp 14](https://www.rfc-editor.org/info/bcp14) when, and only
when, they appear in capitals.

_owner_ the person orchestrating the work. they hold all responsibility.

_agent_ any model-driven tool doing work for the owner, in any tool.

_base_ the rules in this rfc. the default everywhere.

_ecosystem_ a set of repos and machines under one owner's policy (e.g. MHQ, an
employer).

_ruleset_ an ecosystem's additions to the base.

_bean_ the state for one stream of work: context, decisions, open questions,
next step, log.

_green diff_ one commit-sized change with its lint and tests passing and its red
line named, or the bean saying why none applies.

_red line_ the change to the code that makes a new test fail, proving the test
guards something.

## 1. motivation

i've had a sense that i've been circling around the rfc format for a while now.
research around testing, evals and formal verification, and the i/o associated
with each has only solidified the approach further for me.

the idea that i've been missing items has also been quite prevalent, including
in the workflow/senzu(-rs) itself. attributes of my sdlc that have been
undocumented and are effectively best-effort (a.k.a. when i remember).

senzu-rs (cli/tui) and the new delta in agent constraints between work and
personal, have led me to asking the question "wtf is my line, even?". having a
formal definition of what my line is, so that i can build it into my workflows
that run at both work and home means i can set my minimum bar once and it's held
everywhere and can (`MUST`) only ever increase.

## 2. specification

### 2.1 layers

- the base `MUST` apply in every ecosystem.
- a ruleset `MAY` add rules or tighten base rules. it `MUST NOT` loosen or drop
  a base rule. a ruleset `MUST NOT` redefine a base term. on conflict, the base
  wins.
- the base `MUST NOT` name people, paths, hosts or tools. those go in a ruleset.
- base rules `MUST` say what a phase produces, not which tool produces it.
- review bots, ticket formats and pr conventions `MUST` come from a ruleset. the
  base names none.

### 2.2 phases

work `MUST` move through these phases in order. a phase `MAY` be skipped when
its condition doesn't hold, or when the owner confirms its output is current.
the bean `MUST` log each skip.

- ground: `MUST` produce a bean with the open questions, the terms and the
  prior art, aligned with the owner.
- rfc: `MUST` produce an rfc, aligned with the owner. it `MUST` land as an rfc
  PR when the work sets lasting rules or changes a rule an rfc covers, and
  `MUST` live in the bean otherwise.
  - it `MUST` get an adversarial review in a fresh context before the owner
    aligns it.
  - each rule `MUST` have a check (test, lint, eval, hook, or by hand). the
    check lives where the rule is enforced.
  - its security considerations `MUST` hold a threat model when the work
    touches auth, secrets or trust.
  - it `MUST` close with the commit layout and the pr stack.
- execute: each step `MUST` be one green diff, then stop. the next diff
  `MUST NOT` start until the owner has committed the last.
- refine: findings `MUST` be sorted into must fix, may fix, out of branch and
  falls away. both fix buckets `MUST` be fixed, then one delta pass over the
  fixes. each refine fix `MUST` fold into the commit that added the code.
- refine: the change's risk `MUST` pick the review depth: one pass for low and
  medium, plus a second scope (security, deploy) for high and critical.
- pr: `MUST` produce a facts outline and a submission preview. the owner opens
  the PR.
- rollout: `MUST` verify the change where it runs, record what was learned, and
  close the bean.

### 2.3 gates

- agents `MUST NOT` commit, push, open or merge PRs, delete branches, or change
  where a remote points.
- agents `MUST NOT` publish, force-remove worktrees, or run as root.
- an agent `MUST NOT` send the owner's code, secrets or private content to a
  service the ruleset doesn't allow without sign-off on the exact text.
- an agent `MUST NOT` echo, log or commit secrets.
- an agent `MUST NOT` change live agent config, hooks or permissions. it `MAY`
  draft the change.
- with the owner away, an agent `MUST` stop at one green diff.
- shared output `MUST NOT` carry AI attribution or agent co-author trailers.
- an agent `MUST NOT` create, close or focus anything in the owner's live
  terminal session, unless asked for a new tab.

### 2.4 state

- sequence and status `MUST` live in the bean. rules `MUST` live in an rfc.
- the tool that stores beans `MUST` own their paths. beans and skills `MUST NOT`
  hardcode them.

### 2.5 words

- agent instructions and skills `MUST` use bcp 14 keywords.
- commit messages and pr text `MUST` be the owner's. an agent `MAY` draft them.
  the owner `MUST` review and sign every commit message and pr text an agent
  drafts.
- an rfc `MAY` be drafted by an agent after a grill, with `[qN]` marks for what
  only the owner can settle. the owner answers, reads it whole, and rewrites
  what doesn't sound like them.

## 3. security considerations

- the gates hold even when the owner is away: nothing private leaves the machine
  and nothing lands without them.
- where the tool supports it, a hook `MUST` enforce the gates and fail closed.
  text checks can't see inside a script, so the gates are rules first and hooks
  second.
- a machine an ecosystem forbids agent config on (e.g. an employer's managed
  laptop) gets none. that ecosystem's ruleset covers it with its own approved
  tools.

## 4. operational considerations

- adding an ecosystem: write its ruleset, then point its repos' AGENTS.md at the
  base.
- changing a base rule: a new rfc that updates or obsoletes this one.
- status: an rfc starts `aligned`, and its PR holds the line. it goes
  `executing` once the skills start following it, `completed` when every rule
  has a live check, `abandoned` if it's dropped before then, and `obsolete` once
  a later rfc replaces it.

## 5. references

- [bcp 14](https://www.rfc-editor.org/info/bcp14): rfc 2119 and rfc 8174
- [homelab rfc 0001](https://github.com/iamnande/homelab/blob/main/rfcs/0001-root-identity-and-trust.md):
  root identity and trust, where the commit-signing touch comes from
