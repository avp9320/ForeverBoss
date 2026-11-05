# v1.0 acceptance checklist

This is a release gate, not a claim of implementation. README claims and static code inspection do not substitute for live-client evidence. Check a box only after its behavior is verified; record test date/client and evidence in this file.

- [ ] Expand verified mechanics across available Forever encounters without guessed spell IDs
- [ ] Live-test boss unit/target/focus cast events and warnings
- [ ] Cover important non-cast mechanics where client exposes reliable events
- [ ] Verify no generic trash spam, sound off by default and debug diagnostics
- [ ] Verify release packaging and client protected-value safety

## Phase 1 implementation notes

- [x] Removed prohibited `COMBAT_LOG_EVENT_UNFILTERED` subscription and the unreachable `AURA_APPLIED` handler after the player reported a protected-action popup. Even a pcall-protected registration can raise `ADDON_ACTION_FORBIDDEN` on WoW: Forever (commit `1368953`). Previously planned non-cast effects remain **unimplemented** until a permitted API or live observation supports them.
- [x] Fixed invalid five-unit `RegisterUnitEvent` registration by subscribing to permitted cast events and filtering boss1–boss5 locally, while keeping target/focus observers separate (commit `fcc7562`). Live verification remains pending.
- [x] Added `ADDON_ACTION_FORBIDDEN` and `ADDON_ACTION_BLOCKED` diagnostics to record the blocked API where exposed; `/fboss status` shows the most recent result.
- [ ] Implement additional permitted event mechanisms for non-cast effects; do not use restricted combat-log events or guess spell IDs.
- [ ] Live-verify boss1–boss5 and target/focus events; Leech Poison cast detection and alert deduplication.

## Evidence

- Code review: 2026-11-05 reviewed protected-action report and fixed restricted event subscription and invalid five-unit filter; no live verification yet.
- Automated/static tests: Lua 5.1 compile required in GitHub release workflow; new code still needs build and client verification.
- Live WoW: Forever client verification: pending
- Release ZIP and WoWUp installation: pending

## Status

Pre-1.0. Features described in README may be implemented but are not accepted as verified here until tested. Avoid declaring v1.0 solely on version metadata.
