# v1.0 acceptance checklist

This is a release gate, not a claim of implementation. README claims and static code inspection do not substitute for live-client evidence. Check a box only after its behavior is verified; record test date/client and evidence in this file.

- [ ] Expand verified mechanics across available Forever encounters without guessed spell IDs
- [ ] Live-test boss unit/target/focus cast events and warnings
- [ ] Cover important non-cast mechanics where client exposes reliable events
- [ ] Verify no generic trash spam, sound off by default and debug diagnostics
- [ ] Verify release packaging and client protected-value safety

## Phase 1 implementation notes

- [x] Added a curated `SPELL_AURA_APPLIED` combat-log path for documented non-cast effects (`Core.lua`, commit `6ae7b05`), with exact boss/source-name matching, secret-value checks and duplicate suppression. Added a Leech Poison aura rule for Witherfang/Viktor (`Data.lua`, commit `5ac972b`). This is code implementation, **not** evidence that the Forever client emits the event or uses the documented names.
- [ ] Expand evidence-backed aura and other non-cast mechanic coverage; capture missing encounters in game without guessing IDs.
- [ ] Live-verify combat-log availability, source attribution, Leech Poison event ordering, and alert deduplication.

## Evidence

- Code review: pending
- Automated/static tests: pending
- Live WoW: Forever client verification: pending
- Release ZIP and WoWUp installation: pending

## Status

Pre-1.0. Features described in README may be implemented but are not accepted as verified here until tested. Avoid declaring v1.0 solely on version metadata.
