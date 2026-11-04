-- ForeverBoss data layering (November 2026 launch policy):
--   spells: verified Forever-specific rules, highest priority
--   classicSpells: provisional Classic Era baseline, overridden by spells
-- An empty Forever table does NOT mean an encounter has been proven unchanged.
-- Alert only for actionable mechanics; source spell IDs must be checked against
-- the actual WoW: Forever client before being promoted from Classic baseline.
--
-- Spell ID/reference facts extracted independently from boss-mod metadata;
-- no BigWigs/DBM source code is included.
-- Classic references:
-- https://github.com/BigWigsMods/LittleWigs/tree/master/Classic/Deadmines
-- Forever encounter IDs (metadata only):
-- https://github.com/DeadlyBossMods/DBM-Dungeons/tree/master/DBM-Party-Forever
--
-- rules: action, text, trigger ("START", "CHANNEL", "SUCCESS"),
--        npcID (optional source NPC guard), duration, source, confidence.
-- Future verified Forever rules in spells override Classic entries by spellID.

ForeverBossData = {
    encounters = {
        [3493] = { name = "Faldrim Anvilmar", instance = "Hall of Thanes", source = "forever-beta" },
        [3494] = { name = "Plunder", instance = "Hall of Thanes", source = "forever-beta" },
        [3495] = { name = "Infurnus", instance = "Hall of Thanes", source = "forever-beta" },
        [3496] = { name = "Durgen Dirgehammer", instance = "Hall of Thanes", source = "forever-beta" },
        [3412] = { name = "Bjork", instance = "Ruins of Lordaeron", source = "forever-beta" },
        [3355] = { name = "The Butcher", instance = "Ruins of Lordaeron", source = "forever-beta" },
    },

    -- Confirmed Forever spell rules go here when supported by direct evidence.
    spells = {},

    classicSpells = {
        -- Deadmines / Captain Greenskin: Poisoned Harpoon (cast start).
        -- BigWigs Classic marks this cast as relevant to interrupters.
        [5208] = {
            action = "INTERRUPT",
            text = "Poisoned Harpoon",
            trigger = "START",
            npcID = 647,
            duration = 2.2,
            source = "classic-baseline",
        },

        -- Deadmines / Gilnid: Molten Metal (cast start).
        -- BigWigs Classic marks this cast as relevant to interrupters.
        [5213] = {
            action = "INTERRUPT",
            text = "Molten Metal",
            trigger = "START",
            npcID = 1763,
            duration = 2.2,
            source = "classic-baseline",
        },
    },
}
