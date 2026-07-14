# Mistborn — The Deckbuilding Game (solo vs. the Lord Ruler)

A self-contained, no-build browser implementation of the solo mode of *Mistborn:
The Deckbuilding Game* (Brotherwise Games, 2024). Plain HTML/CSS/JS, no
dependencies, no server — just open `index.html`.

## Run it

- **Locally:** open `game/index.html` in any modern browser.
- **On the RetroPlay hub:** the game is also bundled into the sibling
  `Pokemon-Game` repo at `mistborn/` and linked from a card on that hub's home
  screen (GitHub Pages). Works offline once the page is cached.

## Files

| File | Role |
|------|------|
| `index.html` | Everything: styles, the atmospheric canvas FX engine (`MBFX`), the game engine + UI (`MB`), and the Rules screen. |
| `cards.js`   | The card database wired for the engine — `MB_METALS`, `MB_CHARACTERS`, `MB_MISSIONS`, `MB_MARKET`, `MB_ATIUM`, `MB_LORDRULER`. Derived from `../docs/deckbuilding/cards.yaml`. |

## What's modelled

- **Characters (4):** Vin, Kelsier, Shan, Marsh — each with a signature burn.
- **Metals & economy:** the 8 metals + Atium, with **Burn** (uses your per-turn
  burn limit), **Vial** (free coins), **Flare** (burn past the limit; spent until
  **Refreshed**), and **Atium** (wild).
- **Training track:** advances one step per turn — raises the burn limit (1→4),
  grants Atium, unlocks the shared character ability.
- **Market:** 6-card river of 56 metal actions/allies + 5 neutral allies; buy with
  coins, recruit allies that persist.
- **Missions:** 3 of 8 per game, 12 points to top; completion grants permanent
  per-turn rewards.
- **Combat & the Lord Ruler:** deal damage to the Lord Ruler (48 HP) or break his
  adversaries' shields. Each turn he flips a card — an **Adversary** (ongoing
  damage until its shields break) or an **Edict** (Dominance up, LR heals per open
  Mission, 2 Market cards purged).
- **Win:** zero the Lord Ruler, play 4 Atium onto *Confrontation*, or top all 3
  Missions. **Lose:** your health hits 0, or the Lord Ruler's deck empties.

## UX / presentation

- **Hybrid rendering:** the board is DOM (crisp text/buttons); a full-screen
  `<canvas id="fx">` sits *behind* it for drifting Allomantic mist and particle
  bursts — metal-colored embers on Burn/Flare, gold coin sparkles, red damage
  sparks, green heal motes. `pointer-events:none`, so it never blocks input.
- **Card art:** each card carries its metal's color via a `--mc` CSS custom
  property (accent bar + inner glow).
- **Rules screen:** a "How to Play" overlay (`MB.openRules()`), reachable from the
  character-select screen and an in-game toolbar.
- **Back navigation:** each sub-screen pushes a History entry, so the browser/
  device back button steps back one screen at a time (rules → game → character
  select) and only leaves to the hub from character select.

## Fidelity caveat

Card **effects** are structured numeric approximations of the paraphrased
summaries in `cards.yaml` — no official card database is published. When the
database is completed (see the repo README's card-data status; the TTS mod is the
ideal source), `cards.js` can be regenerated with exact costs and effect text.

## Testing

The engine is plain globals and can be smoke-tested headlessly under Node by
stubbing `document`/`window`/`history`/canvas and driving the exported `MB`
methods (`startGame`, `playCard`, `buy`, `spendMission`, `attackLR`, `endTurn`,
…). Screenshots were captured with the preinstalled Chromium via Playwright.
