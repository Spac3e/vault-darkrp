local PANEL = {}

local material_block = Material('sup/gui/generic/micon.png', 'smooth')
local material_ublock = Material('sup/gui/generic/micoff.png', 'smooth')
function PANEL:Init()
	self:SetTall(30)
	self:SetText ''

	self.Avatar = ui.Create('ui_imagebutton', self)
	self.Avatar:SetTooltip('Open SUP Profile')

	self.Mute = ui.Create('ui_button', self)
	self.Mute:SetMaterial(material_block)
	self.Mute:SetText('')
	self.Mute:SetTooltip('Block/Unblock')
	self.Mute.DoClick = function()
		if (self.Player == LocalPlayer()) then return end

		self.Player:Block(not self.Player:IsMuted())
	end
	self.Mute.Paint = function(s, w, h)
		if (not IsValid(self.Player)) then return end
		surface.SetDrawColor(ui.col.White)
		surface.SetMaterial(self.Player:IsMuted() and material_ublock or material_block)
		surface.DrawTexturedRect(3, 3, 24, 24)
	end

	self.InfoCard = ui.Create('rp_scoreboard_playerinfo', self)
end


function PANEL:PerformLayout(w, h)
	self.Avatar:SetPos(2, 2)
 	self.Avatar:SetSize(26, 26)

	self.Mute:SetPos(self:GetWide() - 30, 0)
	self.Mute:SetSize(30, 30)

	self.InfoCard:SetPos(0, 30)
	self.InfoCard:SetSize(self:GetWide(), self:GetTall() - 30)

	self:Update()
end

function PANEL:DoClick()
	if self.Open then
		self.TargetHeight = 30
		self.Open = nil
	else
		self.TargetHeight = (ui.ButtonHeight * 2) + 45
		self.Open = true
	end
end

function PANEL:Think()
	if (self.TargetHeight and self:GetTall() ~= self.TargetHeight) then
		local tall = self:GetTall()
		local mul = tall > self.TargetHeight and -1 or 1

		tall = tall + FrameTime() * (tall - self.TargetHeight * -mul) * 3 * mul
		if (math.abs(tall - self.TargetHeight) < 1) then
			tall = self.TargetHeight
			if (self.TargetHeight == 135) then
				self.TargetHeight = 135
			else
				self.TargetHeight = nil
			end
		end
		self:SetTall(tall)
		rp.Scoreboard.PlayerList:InvalidateLayout()
	end
end

function PANEL:Update()
	if (not IsValid(self.Player)) then return end

	local w = self:GetWide()

	local job = self.Player:GetJob()
	if self.Job and (self.Job ~= job) then
		self:GetParent():GetParent():PerformLayout()
	end

	self.Job = job

	self.PlayerColor 	= self.Player:GetJobColor():Copy()
	self.PlayerColor.a = 200

	local eTag = self.Player:GetChatTag()
	local chatTag = eTag and ba.chatEmotes[eTag:Trim()]

	local basePath = 'sup/gui/generic/'
	local badgeimg 		= (self.Player:IsSuperAdmin() and (basePath .. 'sa.png')) or (self.Player:IsAdmin() and (basePath .. 'admin.png')) or (self.Player:IsVIP() and (basePath .. 'vip.png')) or (basePath .. 'user.png')
	self.RankMaterial 	= chatTag and chatTag.mat or Material(badgeimg, 'smooth')

	self.PlayerName = (self.Player:GetNickName() and self.Player:GetNickName() ~= '') and (self.Player:Name() .. ' (' .. self.Player:GetNickName() .. ')') or self.Player:Name()

	if (not self.Player:Alive()) and LocalPlayer():IsAdmin() then
		surface.SetFont('ui.17')
		local w, h = surface.GetTextSize(self.PlayerName)
		self.PlayerNameSize = w
		self.DrawName = self.DrawNameDead
	elseif self.Player:IsWanted() then
		self.DrawName = self.DrawNameWanted
	else
		self.DrawName = self.DrawNameNormal
	end

	surface.SetFont('ui.18')

	self.JobName 		= self.Player:GetJobName()
	self.JobNamePos 	= (w * 0.25)

	self.OrgName 		= self.Player:GetOrg()
	self.OrgNamePos 	= (w * 0.5)

	self.TimePlayed 	= ba.str.FormatTime(self.Player:GetPlayTime()) .. ' (' .. self.Player:GetPlayTimeRank() .. ')'
	self.TimePlayedPos 	= (w * 0.75)

	local ping = self.Player:Ping()
	if (ping >= 300) then
		self.DrawPing 	= self.DrawOneBar
	elseif (ping < 300) and (ping >= 125) then
		self.DrawPing = self.DrawTwoBar
	else
		self.DrawPing = self.DrawThreeBar
	end

	self.BarHeight1 = (25 * 0.7)
	self.BarPos1	= (25 * 0.3) - 1
	self.BarHeight2 = (25 * 0.4)
	self.BarPos2	= (25 * 0.6) - 2

	self.InfoCard:Update()
end	

local override_flags = {
	['STEAM_0:1:448435965'] = 'us',
	['STEAM_0:0:27351607'] = 'us',
}
local ccmat = Material 'sup/flags/us.png'
function PANEL:SetPlayer(pl)
	self.Player = pl
	self.Avatar:SetPlayer(pl)
	self.Mute:SetMaterial(pl:IsBlocked() and micoff or micon)
	self.InfoCard:SetPlayer(pl)

	if (pl == LocalPlayer()) then
		self.Mute:SetVisible(false)
	end

	local cc = override_flags[pl:SteamID()] and override_flags[pl:SteamID()] or pl:GetCountry()
	local matname = 'FLAG_' ..  cc

	if texture.Get(matname) then
		self.CountryMaterial = texture.Get(matname)
	else
		self.CountryMaterial =  ccmat
		texture.Create(matname)
			:EnableProxy(false)
			:Download('http://cdn.superiorservers.co/rp/flags/' .. cc .. '.png', function(s, material)
				if IsValid(self) then
					self.CountryMaterial = material
				end
			end)
	end

	self:Update()
end

function PANEL:DrawNameNormal()
	if IsValid(self.Player) and self.Player:IsBlocked() then
		surface.SetTextColor(0, 0, 0, 255)
	else
		surface.SetTextColor(255, 255, 255, 255)
	end

	surface.DrawText(self.PlayerName)
end

function PANEL:DrawNameWanted()
	surface.SetTextColor(255, math.sin(CurTime() * math.pi) * 255, math.sin(CurTime() * math.pi) * 255, 255)
	surface.DrawText(self.PlayerName)
end

function PANEL:DrawNameDead(x)
	surface.SetDrawColor(0, 0, 0, 255)
	surface.DrawRect(x, 15, self.PlayerNameSize, 1)

	surface.SetTextColor(0, 0, 0, 255)
	surface.DrawText(self.PlayerName)
end

function PANEL:DrawOneBar(w, h)
	draw.Box(w - 46, self.BarHeight1, 5, self.BarPos1, ui.col.Red)
end

function PANEL:DrawTwoBar(w, h)
	draw.Box(w - 46, self.BarHeight1, 5, self.BarPos1, ui.col.Orange)
	draw.Box(w - 39, self.BarHeight2, 5, self.BarPos2, ui.col.Orange)
end

function PANEL:DrawThreeBar(w, h)
	draw.Box(w - 46, self.BarHeight1, 5, self.BarPos1, ui.col.Green)
	draw.Box(w - 39, self.BarHeight2, 5, self.BarPos2, ui.col.Green)
	draw.Box(w - 32, 2, 5, h - 4, ui.col.Green)
end

function PANEL:Paint(w, h)
	draw.RoundedBox(5, 0, 0, w, h, self.PlayerColor)

	local iconX, iconY = 32, 1
	local iconS = 28
	surface.SetDrawColor(255, 255, 255, 255)
	if self.CountryMaterial then
		surface.SetMaterial(self.CountryMaterial)
		surface.DrawTexturedRect(iconX, iconY, iconS, iconS)
	end

	iconY = 3
	iconX = iconX + iconS + 4

	iconS = 24
	surface.SetMaterial(self.RankMaterial)
	surface.DrawTexturedRect(iconX, iconY, iconS, iconS)

	iconX = iconX + iconS + 4

	-- Player Info
	surface.SetFont('ui.17')
	surface.SetTextPos(iconX, 7)
	self:DrawName(iconX)

	surface.SetTextColor(255, 255, 255, 255)

	surface.SetTextPos(self.JobNamePos, 7)
	surface.DrawText(self.JobName)

	if self.OrgName then
		surface.SetTextPos(self.OrgNamePos, 7)
		surface.DrawText(self.OrgName)
	end

	surface.SetTextPos(self.TimePlayedPos, 7)
	surface.DrawText(self.TimePlayed)

	self:DrawPing(w, 25)
end

vgui.Register('rp_scoreboard_player', PANEL, 'DButton')