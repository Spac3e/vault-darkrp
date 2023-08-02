local discord = Material('sup/gui/generic/discord.png', 'smooth noclamp')
local steam = Material('sup/gui/generic/steam.png', 'smooth noclamp')
local tags = Material('sup/gui/generic/steam.png', 'smooth noclamp')
local nick = PLAYER.SteamName or PLAYER.Name

local PANEL = {}

function PANEL:Init()
    self:SetText''
end

local f = ui.col.White:Copy()
f.a = 150

function PANEL:Paint(g, h)
    if self:IsHovered() and not self.IsClaimed then
        derma.SkinHook('Paint', 'TabButton', self, g, h)
    else
        draw.RoundedBox(5, 0, 0, g, h, ui.col.Background)
        draw.RoundedBox(5, 0, 0, h, h, ui.col.Background)
    end

    surface.SetDrawColor(255, 255, 255, self.IsClaimed and 150 or 255)
    surface.SetMaterial(self.Material)
    surface.DrawTexturedRect(10, 10, h - 20, h - 20)
    local i = g * 0.5
    draw.SimpleText(self.Title, 'ui.22', i, 10, self.IsClaimed and f or ui.col.White, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)

    if self.IsClaimable and not self.IsClaimed then
        draw.SimpleText(self.IsClaimed and 'Успешно' or self.Description, 'ui.16', i, h - 10, self.IsClaimed and f or ui.col.DarkGreen, TEXT_ALIGN_CENTER, TEXT_ALIGN_BOTTOM)
    else
        draw.SimpleText(self.IsClaimed and 'Успешно' or self.Description, 'ui.16', i, h - 10, self.IsClaimed and f or ui.col.DarkGreen, TEXT_ALIGN_CENTER, TEXT_ALIGN_BOTTOM)
    end

    -- if not self.IsClaimable and not self.IsClaimed then
    --     draw.SimpleText('+' .. self.Reward .. ' Рублей' .. (self.Daily and ' в день' or ''), 'ui.16', g - 10, 10, ui.col.DarkGreen, TEXT_ALIGN_RIGHT, TEXT_ALIGN_TOP)
    -- end
end

function PANEL:DoClick()
    if self.IsClaimable and not self.IsClaimed then
        net.Start 'ba.rewards.Claim'
        net.WriteString(self.ClaimType)
        net.SendToServer()
        self.IsClaimed = true
    elseif not self.IsClaimed then
        gui.OpenURL(self.URL)
    end
end

function PANEL:Think()
    self:SetEnabled(self.IsClaimable or not self.IsClaimed)
end

vgui.Register('ba_reward_task', PANEL, 'DButton')

PANEL = {}

function PANEL:Init()
    self.Loading = true
    self.Title = ui.Create('ui_button', self)
    self.Title:SetText'Мы в социальных сетях'
    self.Title:SetEnabled(false)
    self.Title:Dock(TOP)
    self.Discord = ui.Create('ba_reward_task', self)
    self.Discord:Dock(TOP)
    self.Discord:DockMargin(0, 5, 0, 0)
    self.Discord.Title = 'Discord'
    self.Discord.Reward = 250
    self.Discord.Description = 'Вступите в наш Discord'
    self.Discord.Material = discord
    self.Discord.ClaimType = 'award_discord'
    self.Discord.URL = rp.cfg.DiscordURL
   -- self.SteamName = ui.Create('ba_reward_task', self)
  --  self.SteamName:Dock(TOP)
  --  self.SteamName:DockMargin(0, 5, 0, 0)
  --  self.SteamName.Title = 'Никнейм Steam'
  --  self.SteamName.Reward = 5
   -- self.SteamName.Daily = true
   -- self.SteamName.Description = 'Добавьте \'VAULT\' в ваш никнейм Steam'
  --  self.SteamName.Material = tags
  --  self.SteamName.ClaimType = 'award_name'

  --  self.SteamName.Think = function(j)
   --     j.IsClaimable = string.find(nick(LocalPlayer()):lower(), 'VAULT') ~= nil or string.find(nick(LocalPlayer()):lower(), 'VAULT') ~= nil
     --   j:SetEnabled(j.IsClaimable)
   -- end
end

function PANEL:PerformLayout(g, h)
    for k, l in ipairs(self:GetChildren()) do
        l:SetTall(64)
    end

    self.Title:SetTall(ui.SpacerHeight)
end

function PANEL:Paint(g, h)
    if self.Loading then
        draw.RoundedBox(5, 0, 0, g, h, ui.col.Background)
        local m = SysTime() * 5
        draw.NoTexture()
        surface.SetDrawColor(255, 255, 255)
        surface.DrawArc(g * 0.5, h * 0.5, 20, 25, m * 80, m * 80 + 180, 20)
    end
end

-- function PANEL:OnRemove()
--     if not self.SurpressPopup and self.Data and (not self.Data.award_discord or not self.Data.award_discord_claimed or (not self.Data.award_steam or not self.Data.award_steam_claimed) or self.Data.award_name and not self.Data.award_name_claimed) then
--        timer.Simple(30, n)
--     end
-- end

function PANEL:SetData(o)
    self.Loading = false
    self.Data = o
    self.Discord.IsClaimable = o.award_discord
    self.Discord.IsClaimed = o.award_discord_claimed
    --self.SteamName.IsClaimed = o.award_name_claimed
    --self.SteamName.URL = 'https://steamcommunity.com/profiles/' .. LocalPlayer():SteamID64() .. '/edit'
end

function PANEL:FetchData()
    ba.http.FetchJson('rewards/' .. LocalPlayer():SteamID64(), function(o)
        if not IsValid(self) then return end
        self:SetData(o)
    end)
end

vgui.Register('ba_rewards_panel', PANEL, 'Panel')