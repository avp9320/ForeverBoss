-- ForeverBoss visual theme
-- Compact overlays use Blizzard tooltip assets so alerts feel native to the stock UI.

local function ApplyForeverBossTheme()
    local frame = _G.ForeverBossAlert
    if not frame then return false end

    if frame.SetBackdrop then
        frame:SetBackdrop({
            bgFile = "Interface\\Tooltips\\UI-Tooltip-Background",
            edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
            tile = true,
            tileSize = 16,
            edgeSize = 16,
            insets = { left = 4, right = 4, top = 4, bottom = 4 },
        })
        frame:SetBackdropColor(0.02, 0.02, 0.02, 0.94)
        frame:SetBackdropBorderColor(0.72, 0.58, 0.22, 0.95)
    end

    -- Keep the warning compact enough to read instantly without feeling like a
    -- separate overlay UI pasted over the game.
    frame:SetSize(400, 44)

    if frame.icon then
        frame.icon:SetSize(28, 28)
    end

    if frame.text then
        frame.text:SetFontObject(GameFontNormalLarge)
        frame.text:SetTextColor(1.00, 0.82, 0.20)
    end

    frame.ForeverStockTheme = true
    return true
end

ApplyForeverBossTheme()

local themeEvents = CreateFrame("Frame")
themeEvents:RegisterEvent("PLAYER_LOGIN")
themeEvents:SetScript("OnEvent", function()
    if C_Timer and C_Timer.After then
        C_Timer.After(0, ApplyForeverBossTheme)
    else
        ApplyForeverBossTheme()
    end
end)
