# ForeverBoss

A lightweight boss-warning addon for **WoW: Forever**.

ForeverBoss is built for players who want useful encounter warnings without turning the screen into a cockpit. It stays out of the way until something actually matters, shows one clear warning, then disappears.

## What it does

- Automatically warns for boss casts the client marks as interruptible, using boss unit cast events and a target/focus cast-info fallback for recognized bosses or active encounters when boss unit tokens are missing; generic trash casts are excluded.
- Supports source-grounded MOVE, INTERRUPT, DEFENSIVE, DISPEL, POSITION, and STOP warnings for known dungeon bosses. Matches actual in-game boss and spell names, not guessed spell IDs.
- Uses a single compact warning near the top-center of the screen.
- No permanent boss window.
- No giant timer stack.
- No automatic chat spam.
- Sound is **off by default**.
- Includes a debug mode for capturing spell IDs and encounter IDs during live testing.

## Commands

- `/fboss test` — show a sample warning.
- `/fboss mute` — toggle warning sounds.
- `/fboss debug` — toggle debug capture for boss casts.
- `/fboss on` — enable the addon.
- `/fboss off` — disable the addon.
- `/fboss status` — show current settings.
- `/fboss reset` — reset settings to defaults.

## Current status

v0.2.5 ships boss-specific cast-name rules for Hall of Thanes, Ruins of Lordaeron, Excavation Site, and City of Dalaran based on published WoW Forever boss guides and client ability descriptions. Examples: Faldrim's Mind Blast, Magmatus/Infurnus Fire Nova and Combust, Plunder's Knock Away, Durgen's Fear/Rend, The Abandoned's Drain Life, Rath'mael's Flamestrike, and Witherfang/Viktor Leech Poison.

The client must report the boss name and spell cast for these alerts to trigger. **WoW: Forever restricts third-party COMBAT_LOG_EVENT_UNFILTERED registration, so this addon does not subscribe to it.** The prior experimental combat-log aura alert was removed to prevent protected-action popups; instant and aura-only mechanics without permitted cast events remain an explicit coverage gap. Leech Poison can still warn when the boss's permitted UNIT_SPELLCAST_SUCCEEDED event is delivered. This does not imply every mechanic is covered, and we do not assign fabricated spell IDs. Use /fboss debug to capture missing casts.

### Protected-action popup troubleshooting

If WoW says ForeverBoss was blocked from a Blizzard-only action, update to v0.2.5 or newer and reload. The previous combat-log subscription was forbidden on the Forever client, even when guarded by pcall. If a popup persists, type `/fboss status` and send us the chat output plus what action caused the warning. The addon now listens for ADDON_ACTION_FORBIDDEN/BLOCKED diagnostics so the exact rejected function can be identified where the client exposes it. The popup does not by itself prove which Lua call tainted Blizzard's UI.

## Installation

Install through WoWUp once releases are available, or download the latest release ZIP and place the `ForeverBoss` folder in your WoW AddOns directory.

GitHub releases are packaged automatically from the version in `ForeverBoss.toc`.

## Philosophy

ForeverBoss should do one job and do it well: tell you what matters during a boss fight without dominating the screen.
