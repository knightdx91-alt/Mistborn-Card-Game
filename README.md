# Mistborn Card Game

Reference material and (eventually) an implementation for the Mistborn tabletop
games set in Brandon Sanderson's *Mistborn* world. This repo currently collects
**rules and card data** for three distinct, officially-licensed Mistborn games,
gathered as source material to build against.

> **Workflow policy:** this repo is **main-only** — no branches, no PRs unless
> explicitly authorized. Enforced by a `PreToolUse` hook
> (`.claude/hooks/enforce-main-only.sh`) and MCP deny rules in
> `.claude/settings.json`. See [`CLAUDE.md`](CLAUDE.md).

## The three games (don't confuse them)

| Game | Type | Publisher | Materials |
|------|------|-----------|-----------|
| **The Deckbuilding Game** | Competitive + solo/co-op deckbuilder | Brotherwise Games (2024) | [`docs/deckbuilding/`](docs/deckbuilding/) |
| **House War** | 3–5p negotiation board game | Crafty Games | [`docs/house-war/`](docs/house-war/) |
| **The Adventure Game** | Tabletop RPG | Crafty Games | [`docs/adventure-game/`](docs/adventure-game/) |

## Contents

### `docs/deckbuilding/` — The Deckbuilding Game *(primary focus)*
- **[`RULES.md`](docs/deckbuilding/RULES.md)** — condensed rules reference
  (Burn/Flare/Refresh economy, 8 metal keywords, turn flow, missions, combat,
  solo/co-op vs. the Lord Ruler). Distilled from the official Rulebook V1.
- **[`cards.yaml`](docs/deckbuilding/cards.yaml)** — **derived** card database:
  all 65 unique cards (4 characters, 8 missions, 56 metal cards, 5 neutral
  allies, 4 Atium) + noted Lord Ruler adversaries. See status below.
- **[`zen_coop_guide.txt`](docs/deckbuilding/zen_coop_guide.txt)** — raw source
  (community strategy guide) the card database was reconstructed from.

### `docs/house-war/` — House War
- **[`RULES.md`](docs/house-war/RULES.md)** — full condensed rules reference.
- **`Mistborn_House_War_Rulebook.pdf`** — official source rulebook.

### `docs/adventure-game/` — The Adventure Game (RPG)
- 14 official supporting PDFs: character sheets (printable/fillable/calc),
  scheme & plan-of-action sheets, secrets sheets, villain/extras sheets, and the
  Allomancy dice / NPC detail generator.

## Card-data status (Deckbuilding Game)

**Where the card database stands** — see `cards.yaml` header for full caveats:

| Data | Status |
|------|--------|
| Card **names** (all 65 unique) | ✅ Reliable |
| Metal groupings & keywords | ✅ Reliable |
| Characters (4) & Missions (8) | ✅ Reliable |
| Card **costs** | ⚠️ Partial — ~24 confirmed, rest `null` (guide didn't state them) |
| Card **effects** | ⚠️ Paraphrased summaries, **not** official card text |
| **Lord Ruler deck** (36 cards) | ❌ Only 3 adversaries noted; rest unknown |

**Why it's incomplete:** no official card database is published. The complete
data provably exists in two community artifacts, both behind walls that block
automated retrieval:
- **Tabletop Simulator mod** — full card set in a save JSON, but Steam requires a
  logged-in client to download it. *(This is the ideal source — one file fills
  every gap above.)*
- **TierMaker template** — 65 named market-card images, but Cloudflare's
  JS challenge blocks server-side fetches.

**To finish the database**, the cleanest path is the **TTS mod `.json`** (drop it
in the repo and it can be parsed into `cards.yaml`), or photos/export of the
physical cards / TierMaker set for transcription. *(In progress — sourcing a
browser-side relay to fetch the walled pages.)*

## Layout

```
.
├── CLAUDE.md                       # workflow policy (main-only)
├── README.md                       # this file
├── .claude/                        # enforcement hook + settings
└── docs/
    ├── deckbuilding/               # The Deckbuilding Game
    ├── house-war/                  # House War
    └── adventure-game/             # The Adventure Game (RPG) PDFs
```
