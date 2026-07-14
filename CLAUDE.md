# Mistborn Card Game

## Workflow Policy — THIS IS LAW

**We work only on `main`. No branches. No pull requests.** Unless the human
explicitly tells you otherwise in the current conversation:

- **Never** create a branch (`git checkout -b`, `git switch -c`, `git branch <name>`).
- **Never** push to any branch other than `main`.
- **Never** open a pull request.
- Commit directly to `main` and push to `main`.

This is enforced automatically by a `PreToolUse` hook
(`.claude/hooks/enforce-main-only.sh`) and by MCP permission `deny` rules in
`.claude/settings.json`.

### When explicitly authorized to branch/PR

If — and only if — the human explicitly asks for a branch or PR this turn,
bypass the git hook for that one command by prefixing it with `ALLOW_BRANCH=1`:

```
ALLOW_BRANCH=1 git checkout -b some-branch
```

The MCP branch/PR tools are denied in settings; re-enable them only with the
human's explicit say-so.

## Implementation status

A **playable browser game** lives in [`game/`](game/) — the Deckbuilding Game's
solo mode vs. the Lord Ruler (plain HTML/CSS/JS, no build). Engine + UI in
`game/index.html`, card data in `game/cards.js`, docs in `game/README.md`. It is
also bundled into the sibling `Pokemon-Game` RetroPlay hub at `mistborn/` and
linked from a hub card.

Card effects are numeric approximations of `docs/deckbuilding/cards.yaml` (no
official card database exists). The **TTS scripted mod** is the ideal source to
complete exact costs/text + the Lord Ruler deck — see the README's card-data
status. When `cards.yaml` is completed, regenerate `game/cards.js` from it.
