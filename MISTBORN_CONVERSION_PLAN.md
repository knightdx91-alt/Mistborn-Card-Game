# Turning Exiled Kingdoms into Mistborn — full conversion plan

Goal: not just a reskin, but *actually Mistborn* — Allomancy mechanics worked into
the engine, on a project that **compiles and runs**. This is the roadmap.

There are two layers: **(A) a buildable project + new code (Allomancy)** and
**(B) content reskin (data/art)**. B is large but straightforward; A is the gate,
because new mechanics require a compilable codebase — which we don't fully have yet.

---

## Reality check first (why this is the hard version)

- Obfuscated/ugly names (`a()`, `k()`) do **not** stop compilation — machines only
  need names to be *consistent*. The shipped APK is obfuscated and runs fine.
- The real blocker for **code changes** is that our code is **decompiled, not
  recompilable**: only **75/370 classes compile** today. New mechanics can't be
  added until that's fixed.
- Copyright: Mistborn is Brandon Sanderson's IP. This is a **personal/fan project** —
  build and play it yourself, but it can't be distributed.

---

## PHASE 0 — Make the project compile (the prerequisite for everything in A)

Source of truth: `deobf/REMAINING_BLOCKERS.md`. Current: 75/370 green.

1. **Stub `MainActivity`** (referenced ~142×). Provide `net.fdgames.ek.android.MainActivity`
   with the ~10 platform methods the game calls (`t/p/l/q/…`) as no-ops / web-equivalents
   (`l()` "isSignedIn" → false). Unblocks the biggest single cascade.
2. **Include R8 synthetic `a`** + stub `zzbi.zzx(int)` (referenced ~257×). Semantics are
   R8-opaque → best-guess (identity), **flag FIXME(verify)**. Do not ship silently.
3. **Member-complete stubs** for the ~77 transitively-referenced gms/android FQNs
   (Quests, GoogleSignIn, Snapshots, android.util.Log, …). Empty stubs aren't enough —
   generate the exact members the game calls (discover via javac "cannot find symbol").
   **Keep** core classes (`NPC`, `GameData`, `Rules`, `Settings`, `FDUtils`,
   `ExiledKingdoms`) — deleting them for 1–4 gms imports cascades to hundreds of errors.
4. **Resolve the cascade** (Phase 4 in the blockers doc) — most core classes compile once
   1–3 are stubbed.
5. **Residual, hand-verified:** ~6 `Vector2` calls (extend method map), ~87 private-access
   (jadx over-restricted — widen), ~70 override / ~9 incompatible-type (per-case).
6. **Run the symbol solver** (`ROUTE1_SYMBOL_SOLVER.md`) to remap obfuscated→real libGDX
   API calls (~193/run) so it compiles against real libGDX.

**Exit criteria:** `net.fdgames.*` + render packages compile green against libGDX
(`tools/rebuild_core.sh`).

**Then pick a build target:**
- **Android APK** (rebuild with Android + libGDX gradle, re-sign) — runs on phone,
  keeps full engine.
- **Browser via libGDX HTML5 (GWT/TeaVM)** — faithful but **heavy** (drags full libGDX +
  Box2D into JS; same iso-render weight that makes EK crawl). See note at bottom.

---

## PHASE 1 — Allomancy mechanics (the code that makes it *Mistborn*)

Map new systems onto EK's existing ones. Specs to read first:
`CHARACTER_STATS_SPEC.md`, `SKILLS_EXEC_SPEC.md`, `COMBAT_SPEC.md`, `ENGINE_SPEC.md`.

1. **Metal reserves** — resource model: 8+ pools (Steel, Iron, Pewter, Tin, Bronze,
   Copper, Zinc, Brass, + Atium) per character. Extend `Character` (stat block) + `Rules`.
   Behaves like mana but multi-pool and drained by *burning*.
2. **Burning = skills that consume a reserve.** Hook into the skill execution VM
   (`SKILLS_EXEC_SPEC`). Each metal = one or more skills.
3. **Steel / Iron (Push / Pull)** — the signature mechanic. EK already ships **Box2D**;
   add force-based Allomantic push/pull on metal targets (coins, enemies, anchors,
   the player). New skill type + a metal-target targeting system. *Prototype this first —
   it proves the whole pipeline.*
4. **Pewter** — physical buff: speed / strength / damage-reduction / HP-regen while burning.
5. **Tin** — enhanced senses: vision radius, reveal hidden, remove fog while burning.
6. **Bronze / Copper** — detect / hide Allomancy: stealth + detection modifiers.
7. **Zinc / Brass (Riot / Soothe)** — emotional Allomancy: modify NPC AI aggro / morale
   (patch the NPC/monster AI to accept emotional pushes/pulls).
8. **Atium** — precognition: temporary huge evasion / attack buff (short, expensive).
9. **Vials** = consumable items that refill reserves (map to EK's potion/item system).
10. **Misting vs Mistborn** = creation choice: single metal vs all. Extend the creation
    flow (`CREATION_FLOW_SPEC`) + traits/class definitions (`rules/`).
11. **HUD**: metal-reserve gauges + burning indicators (extend `GAMEHUD_LAYOUT_SPEC`).

---

## PHASE 2 — Content reskin (data + art; no code)

All plain files in `assets/data/` — editable without touching code.

- **Maps** (`tmx/`, 343 slots): Luthadel, the great keeps, the Pits of Hathsin, skaa slums.
- **Factions** (`world/`): Great Houses, the Steel Ministry / obligators, skaa, Kelsier's crew.
- **NPCs + dialogue** (`conversations/`, 3,765 slots): Vin, Kelsier, Elend, Sazed, Marsh, …
- **Quests** (`quests/`, 799 slots): the novel's arc.
- **Items** (`rules/`): metal vials, coins (Push ammo), obsidian, atium beads.
- **Bestiary / monsters**: koloss, Steel Inquisitors, mistwraiths, kandra.
- **Sprites / graphics** (`sprites/`, `graphics/`): reskin player/NPC/enemy art; a **mist**
  ambient overlay for night.
- **Rules** (`rules/`): stats, damage tables, class defs → Allomancer classes.

---

## PHASE 3 — Integrate, build, run

1. Wire mechanics to data (skill/item defs reference metals; classes grant metals).
2. Build for the chosen target (APK or HTML5).
3. Test loop: prove one metal end-to-end, then scale.

---

## Recommended sequencing (de-risked)

1. **Phase 0** — get it compiling. Nothing in A works until this is green.
2. **Vertical slice**: one metal (Steelpush) fully working in a test map. Proves the
   metal-reserve + burn + Box2D-force pipeline before investing in the rest.
3. **Scale**: remaining metals + the content reskin (Phase 2) in parallel.

## Effort & risk (honest)

- Phase 0: bounded but real engineering (buildability). Days–weeks.
- Phase 1: the biggest new-code effort (physics push/pull, 8-metal model, emotional AI).
  Weeks.
- Phase 2: a novel's worth of content/writing/art. Ongoing.

## Fallback if Phase 0 proves too costly

The **top-down Phaser rebuild** (`web/`) is the alternative: mechanics are written
**fresh in JavaScript**, so there's **no obfuscation/build wall** — and it's **lighter**,
which fixes the browser-crawl problem. Trade-off: less faithful, built up subsystem by
subsystem. If "runs smooth on my browser" matters more than "exact engine," this path is
better and is already booting/walking. Allomancy would be implemented in JS against the
Phaser engine instead of the obfuscated Java.
