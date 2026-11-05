local ADDON_NAME = ...

local FB = CreateFrame("Frame")
local DATA = ForeverBossData or { encounters = {}, spells = {} }

local DEFAULTS = {
    enabled = true,
    muted = true,
    debug = false,
}

local activeEncounterID
local activeEncounterName
local alertSerial = 0
local recentInterrupts = {}

local function IsSecret(value)
    if value == nil then
        return false
    end

    if type(issecretvalue) == "function" then
        local ok, result = pcall(issecretvalue, value)
        return ok and result or false
    end

    return false
end

local function SafeText(value, fallback)
    if value == nil or IsSecret(value) then
        return fallback
    end

    local ok, text = pcall(tostring, value)
    if not ok then
        return fallback
    end
    return text
end

local function Print(message)
    if DEFAULT_CHAT_FRAME then
        DEFAULT_CHAT_FRAME:AddMessage("[ForeverBoss] " .. SafeText(message, ""))
    end
end

local function CopyDefaults()
    ForeverBossDB = ForeverBossDB or {}
    for key, value in pairs(DEFAULTS) do
        if ForeverBossDB[key] == nil then
            ForeverBossDB[key] = value
        end
    end
end

local function SafeSpellName(spellID)
    if spellID == nil or IsSecret(spellID) then
        return nil
    end

    if C_Spell and type(C_Spell.GetSpellInfo) == "function" then
        local ok, info = pcall(C_Spell.GetSpellInfo, spellID)
        if ok and type(info) == "table" and info.name and not IsSecret(info.name) then
            return SafeText(info.name, nil)
        end
    end

    if type(GetSpellInfo) == "function" then
        local ok, name = pcall(GetSpellInfo, spellID)
        if ok and name and not IsSecret(name) then
            return SafeText(name, nil)
        end
    end

    return nil
end

local function SafeSpellTexture(spellID)
    if spellID == nil or IsSecret(spellID) then
        return nil
    end

    if C_Spell and type(C_Spell.GetSpellTexture) == "function" then
        local ok, texture = pcall(C_Spell.GetSpellTexture, spellID)
        if ok and texture and not IsSecret(texture) then
            return texture
        end
    end

    if type(GetSpellTexture) == "function" then
        local ok, texture = pcall(GetSpellTexture, spellID)
        if ok and texture and not IsSecret(texture) then
            return texture
        end
    end

    return nil
end

local function GetPlayerRole()
    if type(UnitGroupRolesAssigned) ~= "function" then
        return "NONE"
    end

    local ok, role = pcall(UnitGroupRolesAssigned, "player")
    if not ok or not role or IsSecret(role) then
        return "NONE"
    end
    return role
end

local function RoleAllowed(rule)
    if not rule or not rule.roles then
        return true
    end

    local role = GetPlayerRole()
    if role == "NONE" then
        return true
    end

    return rule.roles[role] == true
end

local alertTemplate = BackdropTemplateMixin and "BackdropTemplate" or nil
local Alert = CreateFrame("Frame", "ForeverBossAlert", UIParent, alertTemplate)
Alert:SetSize(430, 46)
Alert:SetPoint("TOP", UIParent, "TOP", 0, -165)
Alert:SetFrameStrata("HIGH")

if Alert.SetBackdrop then
    Alert:SetBackdrop({
        bgFile = "Interface\\Buttons\\WHITE8X8",
        edgeFile = "Interface\\Buttons\\WHITE8X8",
        edgeSize = 1,
    })
    Alert:SetBackdropColor(0.03, 0.03, 0.03, 0.88)
    Alert:SetBackdropBorderColor(0.35, 0.35, 0.35, 0.9)
end

Alert:Hide()

Alert.icon = Alert:CreateTexture(nil, "ARTWORK")
Alert.icon:SetSize(30, 30)
Alert.icon:SetPoint("LEFT", Alert, "LEFT", 8, 0)
Alert.icon:SetTexCoord(0.08, 0.92, 0.08, 0.92)
Alert.icon:Hide()

Alert.text = Alert:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
Alert.text:SetPoint("LEFT", Alert.icon, "RIGHT", 9, 0)
Alert.text:SetPoint("RIGHT", Alert, "RIGHT", -12, 0)
Alert.text:SetJustifyH("CENTER")
Alert.text:SetTextColor(1, 1, 1)

local function PlayAlertSound()
    if not ForeverBossDB or ForeverBossDB.muted then
        return
    end

    if type(PlaySound) == "function" then
        local soundID = SOUNDKIT and (SOUNDKIT.RAID_WARNING or SOUNDKIT.ALARM_CLOCK_WARNING_3)
        if soundID then
            pcall(PlaySound, soundID, "Master")
        end
    end
end

local function ShowAlert(action, message, spellID, duration, withSound)
    if not ForeverBossDB or not ForeverBossDB.enabled then
        return
    end

    alertSerial = alertSerial + 1
    local mySerial = alertSerial

    local spellName = SafeSpellName(spellID)
    local body = message or spellName or "BOSS MECHANIC"
    local actionText = action and (action .. " — ") or ""
    Alert.text:SetText(actionText .. body)

    local texture = SafeSpellTexture(spellID)
    if texture then
        Alert.icon:SetTexture(texture)
        Alert.icon:Show()
        Alert.text:ClearAllPoints()
        Alert.text:SetPoint("LEFT", Alert.icon, "RIGHT", 9, 0)
        Alert.text:SetPoint("RIGHT", Alert, "RIGHT", -12, 0)
    else
        Alert.icon:Hide()
        Alert.text:ClearAllPoints()
        Alert.text:SetPoint("LEFT", Alert, "LEFT", 12, 0)
        Alert.text:SetPoint("RIGHT", Alert, "RIGHT", -12, 0)
    end

    Alert:SetAlpha(1)
    Alert:Show()

    if withSound ~= false then
        PlayAlertSound()
    end

    local hideAfter = tonumber(duration) or 2.6
    if C_Timer and type(C_Timer.After) == "function" then
        C_Timer.After(hideAfter, function()
            if mySerial == alertSerial then
                Alert:Hide()
            end
        end)
    end
end

local function Debug(message)
    if ForeverBossDB and ForeverBossDB.debug then
        Print("DEBUG: " .. SafeText(message, "<secret>"))
    end
end

local function DebugCast(event, unit, spellID)
    if not ForeverBossDB or not ForeverBossDB.debug then
        return
    end

    local spellIDText = IsSecret(spellID) and "<secret>" or SafeText(spellID, "?")
    local spellName = SafeSpellName(spellID) or "<unknown/secret>"
    local encounterText = activeEncounterID and SafeText(activeEncounterID, "?") or "none"

    Debug(event .. " | " .. SafeText(unit, "?") .. " | " .. spellName .. " [" .. spellIDText .. "] | encounter " .. encounterText)
end

-- A verified Forever entry always takes precedence over the Classic fallback.
local function GetRule(spellID)
    if spellID == nil or IsSecret(spellID) then return nil end
    local ok, rule = pcall(function()
        return DATA.spells[spellID] or (DATA.classicSpells and DATA.classicSpells[spellID])
    end)
    return ok and rule or nil
end

local function MatchesRuleSource(rule, unit)
    if not rule.npcID then return true end
    if type(UnitGUID) ~= "function" or not unit then return false end
    local ok, guid = pcall(UnitGUID, unit)
    if not ok or type(guid) ~= "string" or IsSecret(guid) then return false end
    local npcID = tonumber(guid:match("%-(%d+)%-[^%-]+$"))
    return npcID == rule.npcID
end

local function NormalizeName(value)
    if type(value) ~= "string" then return "" end
    return value:gsub("’", "'"):lower():gsub("%s+", " "):gsub("^%s+", ""):gsub("%s+$", "")
end

local function GetBossNameRule(spellID, unit)
    local name = SafeSpellName(spellID)
    if not name or not DATA.nameRules or not unit then return end
    local rules = DATA.nameRules[NormalizeName(name)]
    if not rules then return end
    if type(UnitName) ~= "function" then return end
    local ok, bossName = pcall(UnitName, unit)
    if not ok or not bossName or IsSecret(bossName) then return end
    bossName = NormalizeName(bossName)
    for _, candidate in ipairs(rules) do
        for _, allowed in ipairs(candidate.bosses or {}) do
            if bossName == NormalizeName(allowed) then return candidate end
        end
    end
end

local lastCuratedBySpell = {}

local function HandleCurated(trigger, spellID, unit)
    local rule = GetRule(spellID) or GetBossNameRule(spellID, unit)
    if not rule or (rule.trigger or "START") ~= trigger
        or not RoleAllowed(rule) or not MatchesRuleSource(rule, unit) then
        return false
    end

    -- The same boss can be both boss1 and the player's target. Avoid duplicate
    -- alerts without suppressing genuinely new casts.
    local now = GetTime and GetTime() or 0
    local last = lastCuratedBySpell[spellID]
    if last and now - last < 0.75 then return false end
    lastCuratedBySpell[spellID] = now

    ShowAlert(rule.action or "WATCH", rule.text or SafeSpellName(spellID),
        spellID, rule.duration, rule.sound)
    return true
end

local function InterruptKey(unit, spellID)
    if IsSecret(spellID) then
        return SafeText(unit, "boss") .. ":secret"
    end
    return SafeText(unit, "boss") .. ":" .. SafeText(spellID, "unknown")
end

local function HandleInterruptible(unit, spellID)
    if not ForeverBossDB or not ForeverBossDB.enabled then
        return
    end

    local now = GetTime and GetTime() or 0
    local key = InterruptKey(unit, spellID)
    local last = recentInterrupts[key]
    if last and (now - last) < 0.75 then
        return
    end
    recentInterrupts[key] = now

    local spellName = SafeSpellName(spellID)
    ShowAlert("INTERRUPT", spellName or "BOSS CAST", spellID, 2.2, true)
end

local function RegisterUnitEventSafe(event)
    local ok = pcall(FB.RegisterUnitEvent, FB, event, "boss1", "boss2", "boss3", "boss4", "boss5")
    if not ok then
        Debug("Could not register " .. event)
    end
end

FB:SetScript("OnEvent", function(self, event, ...)
    if event == "ADDON_LOADED" then
        local loaded = ...
        if loaded ~= ADDON_NAME then
            return
        end

        CopyDefaults()

        RegisterUnitEventSafe("UNIT_SPELLCAST_START")
        RegisterUnitEventSafe("UNIT_SPELLCAST_CHANNEL_START")
        RegisterUnitEventSafe("UNIT_SPELLCAST_SUCCEEDED")
        RegisterUnitEventSafe("UNIT_SPELLCAST_INTERRUPTIBLE")

        Debug("Loaded. Unit cast listeners registered.")
        return
    end

    if event == "ENCOUNTER_START" then
        local encounterID, encounterName = ...
        activeEncounterID = IsSecret(encounterID) and nil or encounterID
        activeEncounterName = IsSecret(encounterName) and nil or encounterName

        if ForeverBossDB and ForeverBossDB.debug then
            Debug("ENCOUNTER_START | " .. SafeText(activeEncounterName, "<secret>") .. " [" .. SafeText(activeEncounterID, "?") .. "]")
        end
        return
    end

    if event == "ENCOUNTER_END" then
        if ForeverBossDB and ForeverBossDB.debug then
            Debug("ENCOUNTER_END | " .. SafeText(activeEncounterName, "<unknown>"))
        end
        activeEncounterID = nil
        activeEncounterName = nil
        Alert:Hide()
        return
    end

    if event == "UNIT_SPELLCAST_INTERRUPTIBLE" then
        local unit, castGUID, spellID = ...
        DebugCast(event, unit, spellID)
        HandleInterruptible(unit, spellID)
        return
    end

    if event == "UNIT_SPELLCAST_START" then
        local unit, castGUID, spellID = ...
        DebugCast(event, unit, spellID)
        HandleCurated("START", spellID, unit)
        return
    end

    if event == "UNIT_SPELLCAST_CHANNEL_START" then
        local unit, castGUID, spellID = ...
        DebugCast(event, unit, spellID)
        HandleCurated("CHANNEL", spellID, unit)
        return
    end

    if event == "UNIT_SPELLCAST_SUCCEEDED" then
        local unit, castGUID, spellID = ...
        DebugCast(event, unit, spellID)
        HandleCurated("SUCCESS", spellID, unit)
        return
    end
end)

-- Classic dungeons do not consistently expose boss1..boss5 unit tokens.
-- Observe only the player's target/focus for curated spell IDs, not every
-- trash cast; the curated NPC guard prevents unrelated cast warnings.
local targetCasts = CreateFrame("Frame")
targetCasts:SetScript("OnEvent", function(_, event, ...)
    local handler = FB:GetScript("OnEvent")
    if handler then handler(FB, event, ...) end
end)
for _, event in ipairs({
    "UNIT_SPELLCAST_START",
    "UNIT_SPELLCAST_CHANNEL_START",
    "UNIT_SPELLCAST_SUCCEEDED",
}) do
    pcall(targetCasts.RegisterUnitEvent, targetCasts, event, "target", "focus")
end

FB:RegisterEvent("ADDON_LOADED")
pcall(FB.RegisterEvent, FB, "ENCOUNTER_START")
pcall(FB.RegisterEvent, FB, "ENCOUNTER_END")

SLASH_FOREVERBOSS1 = "/fboss"
SLASH_FOREVERBOSS2 = "/foreverboss"
SlashCmdList.FOREVERBOSS = function(msg)
    CopyDefaults()
    msg = (msg or ""):lower():match("^%s*(.-)%s*$")

    if msg == "on" then
        ForeverBossDB.enabled = true
        Print("Enabled.")
    elseif msg == "off" then
        ForeverBossDB.enabled = false
        Alert:Hide()
        Print("Disabled.")
    elseif msg == "mute" then
        ForeverBossDB.muted = not ForeverBossDB.muted
        Print(ForeverBossDB.muted and "Sounds muted." or "Sounds enabled.")
    elseif msg == "debug" then
        ForeverBossDB.debug = not ForeverBossDB.debug
        Print(ForeverBossDB.debug and "Debug capture ON. Boss cast events will print to chat." or "Debug capture OFF.")
    elseif msg == "test" then
        ShowAlert("INTERRUPT", "Test Boss Cast", nil, 2.6, true)
    elseif msg == "status" then
        Print("Enabled: " .. tostring(ForeverBossDB.enabled) .. " | Muted: " .. tostring(ForeverBossDB.muted) .. " | Debug: " .. tostring(ForeverBossDB.debug))
    elseif msg == "reset" then
        ForeverBossDB = {}
        CopyDefaults()
        Alert:Hide()
        Print("Settings reset.")
    else
        Print("/fboss test  - show a sample warning")
        Print("/fboss mute  - toggle warning sound")
        Print("/fboss debug - print boss cast IDs for testing")
        Print("/fboss on | off | status | reset")
    end
end
