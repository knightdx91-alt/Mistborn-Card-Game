# Mistborn Card Game

Reference material **and a playable implementation** for the Mistborn tabletop
games set in Brandon Sanderson's *Mistborn* world. This repo collects **rules and
card data** for three distinct, officially-licensed Mistborn games, and ships a
browser implementation of the Deckbuilding Game's solo mode (see
[`game/`](game/)).

> **Workflow policy:** this repo is **main-only** — no branches, no PRs unless
> explicitly authorized. Enforced by a `PreToolUse` hook
> (`.claude/hooks/enforce-main-only.sh`) and MCP deny rules in
> `.claude/settings.json`. See [`CLAUDE.md`](CLAUDE.md).

## ▶ Playable game (`game/`)

A self-contained, no-build browser implementation of **Mistborn: The Deckbuilding
Game — solo mode vs. the Lord Ruler**. Open [`game/index.html`](game/index.html)
in a browser (no server, no dependencies).

- **Files:** `game/index.html` (engine + UI + atmospheric canvas FX) and
  `game/cards.js` (the card database wired for play, derived from
  `docs/deckbuilding/cards.yaml`). See [`game/README.md`](game/README.md).
- **What's modelled:** the 4 characters, 8 missions (3 per game), 56 metal market
  cards + 5 neutral allies + 4 Atium cards, the Burn/Flare/Refresh metal economy,
  the training track, adversary combat, and the Lord Ruler deck (adversaries +
  edicts, Dominance, market purge). Win by zeroing the Lord Ruler, 4 Atium on
  *Confrontation*, or topping all missions.
- **Look:** DOM board (crisp text) with a full-screen canvas behind it for
  drifting mist + metal-colored particle bursts; cards carry their metal's color.
- **UX:** a "How to Play" / Rules screen and History-API back navigation (the
  browser back button steps back one screen at a time).
- **Also bundled into the RetroPlay hub** (the sibling `Pokemon-Game` repo) at
  `mistborn/`, reachable from a card on that hub's home screen.

> **Note on fidelity:** card *effects* in `game/cards.js` are structured numeric
> approximations of the paraphrased summaries in `cards.yaml` — no official card
> database is published. See the card-data status below; the game upgrades to
> exact values the moment the database is completed.

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
data provably exists in community artifacts, but they sit behind walls that block
automated retrieval from this sandbox (egress is scoped to the repos):

- **Tabletop Simulator (TTS) mod — the ideal source.** A *scripted* mod bakes the
  full card set (exact names, costs, verbatim effect text, **and** the Lord Ruler
  deck) into its save JSON — one file fills every gap above. Confirmed **still
  available** (July 2026) with several live Workshop mirrors, e.g. ids
  `3527393524`, `3371240672`, `3523082800` (appid `286160`). Catch: TTS is a
  **paid** Steam app, so downloading a Workshop item needs an account that owns
  it — anonymous SteamCMD won't pull paid-app Workshop content.
- **TierMaker template** — 65 named market-card images (yields names + costs, not
  rules text or the LR deck). Blocked by Cloudflare's **JS challenge**, so plain
  `curl`/`wget` fails; only a real **headless browser** (Playwright/Puppeteer)
  clears it. A datacenter VPS (e.g. Contabo) can run that browser — the VPS
  helps only as "a machine with a browser + open egress," not via `curl`.

**To finish the database** (any of these → parse into `cards.yaml`, then the game
picks up exact values):
1. On a machine that owns TTS, `workshop_download_item 286160 <id>` for a scripted
   mod → drop its `.json` in the repo → parse.
2. Run a headless-browser TierMaker scrape on a VPS → names/costs.
3. Photos/export of the physical cards or a community spreadsheet transcription.

## Layout

```
.
├── CLAUDE.md                       # workflow policy (main-only)
├── README.md                       # this file
├── MISTBORN_CONVERSION_PLAN.md     # older Exiled-Kingdoms → Mistborn roadmap
├── .claude/                        # enforcement hook + settings
├── game/                           # ▶ playable browser deckbuilder (solo vs. Lord Ruler)
│   ├── index.html                  #   engine + UI + canvas FX
│   ├── cards.js                    #   card database wired for play
│   └── README.md                   #   game docs
└── docs/
    ├── deckbuilding/               # The Deckbuilding Game
    ├── house-war/                  # House War
    └── adventure-game/             # The Adventure Game (RPG) PDFs
```
