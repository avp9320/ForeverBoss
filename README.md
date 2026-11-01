# ForeverBoss

A lightweight boss-warning addon for **WoW: Forever**.

ForeverBoss is built for players who want useful encounter warnings without turning the screen into a cockpit. It stays out of the way until something actually matters, shows one clear warning, then disappears.

## What it does

- Automatically warns for boss casts the client marks as interruptible.
- Supports curated warnings such as **MOVE**, **DEFENSIVE**, **DISPEL**, **STACK**, **SPREAD**, and **STOP**.
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

ForeverBoss is in its first WoW: Forever testing build. The warning engine is ready, but the curated mechanic database will only contain mechanics that have been verified against Forever data or live gameplay. We are intentionally not shipping guessed boss mechanics.

## Installation

Install through WoWUp once releases are available, or download the latest release ZIP and place the `ForeverBoss` folder in your WoW AddOns directory.

GitHub releases are packaged automatically from the version in `ForeverBoss.toc`.

## Philosophy

ForeverBoss should do one job and do it well: tell you what matters during a boss fight without dominating the screen.
