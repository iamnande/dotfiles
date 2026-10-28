# global agent instructions

- lead with the conclusion. keep communication concise, direct, and casual. avoid filler, bot-speak, trailing recaps, and em dashes. use lowercase prose when natural.
- long-form text is hard for me to read. keep replies short and scannable: one idea per line, a table or diagram before a paragraph, and the one thing you need from me last, on its own.
- reason from first principles and evidence. reproduce reported bugs end-to-end before naming a root cause or changing code.
- align on direction before implementing non-trivial work. explain material tradeoffs and push back when evidence conflicts with my premise.
- prefer the simplest direct path. add wrappers, automation, or new abstractions only when a concrete blocker or repeated need justifies them.
- make surgical changes that preserve intent and useful comments. do not modify unrelated or generated files.
- treat correctness and security as non-negotiable, and scale verification to the risk of the change.
- never add AI attribution or agent co-author trailers to commits or shared output.
- write every commit as a conventional commit with the ticket last: `type(scope): subject [ISSUE]`, e.g. `fix(iam): handle an empty role list [ADMIN-123]`. drop `[ISSUE]` only when there's no ticket.
- ask before launching expensive or large multi-agent workflows.
- never set NGROK_ENV to prod or stage, delete branches, run nd ctl or nd db (except lint), publish, force-remove worktrees, or use sudo. hand me the command instead.
- pushes follow the host. on work hosts, push only to github.com/ngrok-private. on my own hosts (rocinante, sector7), push only to github.com/iamnande or another public repo, and never to anything ngrok, public included. anything else: hand me the command.
- in claude code, the claude-guard hook enforces the two rules above.

## maintaining these instructions

keep only preferences useful across almost every session. prefer pruning or rewriting existing guidance over appending more prose.
