# conventional comments + voice rules

every PR comment kami drafts uses **conventional comments** format and **nick's voice**.

---

## conventional comments

format: `<label>(<decoration>): <body>`

**labels:**

| label | meaning | typical decoration |
|---|---|---|
| `praise` | something done well, call out the positive | none |
| `nitpick` | trivial, opt-in fix | `(non-blocking)` |
| `suggestion` | propose a change | `(non-blocking)` or omitted if blocking |
| `issue` | problem that needs addressing | `(blocking)` or omitted |
| `todo` | small, well-defined task | `(non-blocking)` |
| `question` | request for clarification | `(blocking)` if you need an answer to move forward, else `(non-blocking)` |
| `thought` | reflection, not actionable | `(non-blocking)` |
| `chore` | repository / process related | `(non-blocking)` |

**decorations:**

* `(blocking)` — must be resolved before merge
* `(non-blocking)` — not required, opt-in
* `(if-minor)` — fix if the change is small, otherwise punt

**default:** if unsure between blocking and non-blocking, prefer `(non-blocking)` for `suggestion` and `nitpick`; prefer no decoration (= blocking) for `issue`.

---

## nick's voice

* **lowercase everything** except acronyms (URL, RFC, JWT, IAM, etc.) and proper nouns
* **casual, terse** — no corporate jargon, no "stuffy" phrasing
* **no em dashes** — use comma or hyphen
* **`*` for bullets**, not `-`
* prefers soft phrasings: "could we", "maybe we could", "i'd want", "is there a path", "i believe"
* 1-4 lines per comment, max — long explanations belong elsewhere
* never include AI / claude attribution in any output

---

## examples (lifted from real reviews)

```
question: 10 seconds is a _long_ time to wait for a cache-miss. maybe we could warn/emit a metric & signal after `3-5` seconds? if this path is taking more than 500ms - we likely need to look at performance characteristics.
```

```
suggestion(non-blocking): this is quite a few layers of conditional logic - could we reorient the checks to give ourselves a more descriptive or early-exit semantic?
```

```
suggestion: i believe we'd want some level of rate-limiting, either at edge via traffic-policy, or in-app tracking to prevent DDoS attacks via invalid PATs.
```

```
question(non-blocking): now that we have more foundational/shared code in the service/lib (`go/lib/iam`) - is there a potential for us to collapse where we construct JWTs within `iam`/ngrok?
```

---

## anti-patterns to avoid

* starting comments with "the …" or "this …" in a way that sounds like an academic critique
* listing multiple separate concerns in one comment — split into separate comments
* using "we should" / "we must" — prefer "could we" / "maybe we could"
* technical jargon in place of plain phrasing
* trailing summaries or "hope this helps" closers
