-- ForeverBoss curated mechanic database.
--
-- The core can already warn for boss casts that the client explicitly marks
-- interruptible. This file is for mechanics that need a human-readable action
-- such as MOVE, DEFENSIVE, DISPEL, STACK, SPREAD, or STOP.
--
-- Schema:
-- ForeverBossData.spells[spellID] = {
--     action = "MOVE",
--     text = "GET OUT",
--     trigger = "START", -- START, CHANNEL, SUCCESS
--     roles = { TANK = true, HEALER = true, DAMAGER = true }, -- optional
--     sound = true, -- optional per-rule sound flag; global sound is off by default
--     duration = 2.6, -- optional
-- }
--
-- We intentionally do not ship guessed mechanics. Boss entries will be added
-- only after they are verified against Forever data/live testing.

ForeverBossData = {
    encounters = {},
    spells = {},
}
