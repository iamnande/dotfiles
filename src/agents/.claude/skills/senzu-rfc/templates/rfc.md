# rfc: <slug>

|        |                                                |
| ------ | ---------------------------------------------- |
| status | aligned \| executing \| completed \| abandoned |
| bean   | <slug>                                         |
| date   | YYYY-MM-DD                                     |

## abstract

3-5 lines. what this decides, and for what.

not doing:

- <non-goal>

## terminology

the key words MUST, MUST NOT, SHOULD, SHOULD NOT and MAY are to be read as
described in [bcp 14](https://www.rfc-editor.org/info/bcp14) when, and only
when, they appear in all capitals.

terms this rfc defines.

## 1. motivation

why this needs deciding.

## 2. specification

### R1. <a behavior or invariant, not a change>

- <the rule, in MUST / SHOULD / MAY language>
- check: <test | lint | eval | hook | by hand>: <which, and where it lives>

## 3. security considerations

required. what this protects, what it doesn't, and what fails if a rule is
broken. a threat model when the work touches auth, secrets or trust.

## 4. operational considerations

verify:

- each check above
- <the repo's lint and test commands>

rollback:

- <how each change comes back out>

close-out:

- <what moves into the repo's real docs before this file is deleted>

## 5. references
