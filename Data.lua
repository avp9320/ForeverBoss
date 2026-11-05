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
        [3495] = { name = "Infurnus / Magmatus", instance = "Hall of Thanes", source = "forever-beta" },
        [3496] = { name = "Durgen Dirgehammer", instance = "Hall of Thanes", source = "forever-beta" },
        [3412] = { name = "Bjork", instance = "Ruins of Lordaeron", source = "forever-beta" },
        [3355] = { name = "The Butcher", instance = "Ruins of Lordaeron", source = "forever-beta" },
    },

    -- We do not fabricate spell IDs. Live boss casts are matched by actual
    -- spell name AND exact boss unit name. Rules below are from published
    -- 2026 Forever dungeon guides; a live client may use a different name.
    -- Naming sources: https://www.icy-veins.com/wow-forever/hall-of-thanes-guide/
    -- https://www.wowhead.com/forever/guide/ruins-of-lordaeron-dungeon-overview-location-rewards
    nameRules = {
        ["mind blast"] = {
            { bosses={"Faldrim Anvilmar"}, action="INTERRUPT", text="Mind Blast",
              trigger="START", source="forever-guide" },
        },
        ["combust"] = {
            { bosses={"Magmatus","Infurnus"}, action="DISPEL",
              text="Combust: cleanse magic / heal target", trigger="START", source="forever-guide" },
        },
        ["combustion"] = {
            { bosses={"Magmatus","Infurnus"}, action="DISPEL",
              text="Combust: cleanse magic / heal target", trigger="START", source="forever-guide" },
        },
        ["fire nova"] = {
            { bosses={"Magmatus","Infurnus"}, action="MOVE",
              text="Fire Nova: step out", trigger="START", source="forever-guide" },
        },
        ["knock away"] = {
            { bosses={"Plunder","The Baron","The Butcher"}, action="POSITION",
              text="Knockback: keep clear of other packs", trigger="START", source="forever-guide" },
        },
        ["intimidating shout"] = {
            { bosses={"Durgen Dirgehammer"}, action="DEFENSIVE",
              text="Fear incoming", trigger="START", source="forever-guide" },
        },
        ["rend"] = {
            { bosses={"Durgen Dirgehammer"}, action="DEFENSIVE",
              text="Rend on tank", trigger="SUCCESS", source="forever-guide" },
        },
        ["drain life"] = {
            { bosses={"The Abandoned"}, action="STOP",
              text="Stop Life Drain with a stun", trigger="START", source="forever-guide" },
        },
        ["life drain"] = {
            { bosses={"The Abandoned"}, action="STOP",
              text="Stop Life Drain with a stun", trigger="START", source="forever-guide" },
        },
        ["frost nova"] = {
            { bosses={"The Abandoned"}, action="MOVE",
              text="Stay out of Frost Nova range", trigger="START", source="forever-guide" },
        },
        ["flamestrike"] = {
            { bosses={"Rath'mael","Rath'Mael"}, action="MOVE",
              text="Move out of Flamestrike", trigger="START", source="forever-guide" },
        },
        ["leech poison"] = {
            { bosses={"Witherfang","Viktor the Vile"}, action="DISPEL",
              text="Cleanse Leech Poison", trigger="SUCCESS", source="forever-guide" },
            { bosses={"Witherfang","Viktor the Vile"}, action="DISPEL",
              text="Cleanse Leech Poison", trigger="AURA_APPLIED", source="forever-guide" },
        },
        -- Excavation Site: Wetlands, documented by Icy Veins and Method.
        ["dust storm"] = {
            { bosses={"Saltspine"}, action="MOVE", text="Dust Storm: step out of melee range",
              trigger="START", source="forever-guide" },
        },
        ["tendon rip"] = {
            { bosses={"Saltspine"}, action="DEFENSIVE", text="Tendon Rip on tank",
              trigger="SUCCESS", source="forever-guide" },
        },
        ["terrifying roar"] = {
            { bosses={"Shadetooth"}, action="DEFENSIVE",
              text="Fear: avoid nearby packs", trigger="START", source="forever-guide" },
        },
        ["thunderclap"] = {
            { bosses={"Relic Guardian"}, action="MOVE",
              text="Thunderclap: leave melee range", trigger="START", source="forever-guide" },
        },
        -- City of Dalaran, from the Forever client spell descriptions and
        -- beta boss walkthroughs. Cast names are confirmed, timing is not.
        -- https://daybreakforever.com/discoveries/city-of-dalaran
        ["focal blast"] = {
            { bosses={"Shade of the Archmage","Arcane Anomaly"}, action="MOVE",
              text="Focal Blast: leave the frontal beam", trigger="START", source="forever-client" },
        },
        ["bounding mana"] = {
            { bosses={"Shade of the Archmage"}, action="MOVE",
              text="Bounding Mana: avoid projectile path", trigger="START", source="forever-client" },
        },
        ["fel timbers"] = {
            { bosses={"Fel Ancient"}, action="MOVE",
              text="Fel Timbers: spread and move away", trigger="START", source="forever-client" },
        },
        ["arcane cascade"] = {
            { bosses={"Mana Devourer"}, action="MOVE",
              text="Arcane Cascade: leave the cone", trigger="START", source="forever-client" },
        },
        ["debilitate"] = {
            { bosses={"Mana Devourer"}, action="DEFENSIVE",
              text="Mana drain incoming", trigger="START", source="forever-client" },
        },
        ["malfunction"] = {
            { bosses={"Unstable Sentinel"}, action="MOVE",
              text="Malfunction: get distance", trigger="START", source="forever-guide" },
        },
        ["manamorph"] = {
            { bosses={"Arcanic Enigma","Mana Elemental"}, action="DISPEL",
              text="Dispel Manamorph", trigger="SUCCESS", source="forever-guide" },
        },
        ["mass polymorph"] = {
            { bosses={"Shade of the Archmage"}, action="DEFENSIVE",
              text="Mass Polymorph incoming", trigger="START", source="forever-guide" },
        },
    },

    -- ID-specific rules still override these when supported by live evidence.
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
