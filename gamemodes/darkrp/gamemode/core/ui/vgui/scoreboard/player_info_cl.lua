cvar.Register 'player_nicknames'
	:SetDefault('')

function PLAYER:SetNickName(name)
	local cv = cvar.Get('player_nicknames')
	cv:AddMetadata(self:SteamID(), name)
	cv:Save()
end

function PLAYER:GetNickName()
	return cvar.Get('player_nicknames'):GetMetadata(self:SteamID())
end

local function newAdBtn(material, doClick, parent)
	local btn = ui.Create('ui_button', parent)
	btn:SetImage(material)
	btn.DoClick = doClick

	if (not doClick) then
		btn.BackgroundColor = ui.col.Button
		btn:SetDisabled(true)
	end

	return btn
end

local PANEL = {}

function PANEL:Init()
	self.Achievements = newAdBtn('sup/gui/generic/achievement.png', nil, self)
	self.Achievements:Dock(LEFT)
	self.Achievements:DockMargin(5, 0, 0, 0)
	self.Achievements:SetText('Нет Достижений')

	self.Buttons = {}

	for k, v in ipairs(rp.achievements.SortedList) do
		local btn = newAdBtn(v.Icon, nil, self)
		btn:SetTooltip(v.Name .. '\n' .. v.Description)
		btn:SetText('')
		btn:SetWide(ui.ButtonHeight)
		btn:Dock(LEFT)
		btn:DockMargin(5, 0, 0, 0)
		btn.UID = v.UID

		self.Buttons[#self.Buttons + 1] = btn
	end
end

function PANEL:SetPlayer(pl)
	self.Player = pl
end

function PANEL:Update()
	local hasAchievements = false
	local AchievementsAmount = 0
	for k, v in ipairs(self.Buttons) do
		local visible = self.Player:HasAchievement(v.UID)
		if visible then
			hasAchievements = true
			AchievementsAmount = AchievementsAmount + 1
		end
		v:SetVisible(visible)
	end

	if hasAchievements then 
        self.Achievements:SetText(AchievementsAmount..'/'..#self.Buttons)
    end 
end

vgui.Register('rp_scoreboard_achievements', PANEL, 'Panel')

PANEL = {}


function PANEL:Init()
	self.Rank = newAdBtn('sup/gui/generic/user.png', nil, self)

	self.PlayTime = newAdBtn('sup/gui/generic/clock.png', nil, self)

	self.Nickname = newAdBtn('sup/gui/generic/rank.png', function()
		ui.StringRequest('Ник', 'Каким будет ник для ' .. self.Player:Name() .. '?', '', function(a)
			self.Player:SetNickName(a)
		end)
	end, self)
	self.Nickname:SetText('Установить ник')

	self.Steam = newAdBtn('sup/gui/generic/steam.png', function()
		self.Player:ShowProfile()
	end, self)
	self.Steam:SetText('Просмотреть профиль')

	self.SteamID = newAdBtn('sup/gui/generic/steam.png', function()
		SetClipboardText(self.Player:SteamID())

		self.SteamID:SetText('Скопировано!')

		timer.Simple(2.5, function()
			if IsValid(self) and IsValid(self.SteamID) then
				self.SteamID:SetText('Скопировать SteamID')
			end
		end)
	end, self)
	self.SteamID:SetText('Скопировать SteamID')

	self.SteamID64 = newAdBtn('sup/gui/generic/steam.png', function()
		SetClipboardText(self.Player:SteamID64())

		self.SteamID64:SetText('Скопировано!')

		timer.Simple(2.5, function()
			if IsValid(self) and IsValid(self.SteamID64) then
				self.SteamID64:SetText('Скопировать SteamID64')
			end
		end)
	end, self)
	self.SteamID64:SetText('Скопировать SteamID64')

	self.VoiceVolume = newAdBtn('sup/gui/generic/volume.png', nil, self)
	self.VoiceVolume:SetText('100%')
	self.VoiceVolume.OnMouseWheeled = function(s, delta)
		self.Player:SetVoiceVolumeScale( self.Player:GetVoiceVolumeScale() + ( delta / 100 * 5 ) )
		s.LastTick = CurTime()
		s:SetText(math.ceil(self.Player:GetVoiceVolumeScale() * 100) .. "%")
		return true
	end

	self.Achievements = ui.Create('rp_scoreboard_achievements', self)
end

function PANEL:PerformLayout(w, h)
	local btnW, btnH = (w - (5 * 8)) / 7, ui.ButtonHeight
	local btnX, btnY = 5, 5

	self.Rank:SetPos(btnX, btnY)
	self.Rank:SetSize(btnW, btnH)

	btnX = btnX + btnW + 5
	self.PlayTime:SetPos(btnX, btnY)
	self.PlayTime:SetSize(btnW, btnH)

	btnX = btnX + btnW + 5
	self.Nickname:SetPos(btnX, btnY)
	self.Nickname:SetSize(btnW, btnH)

	btnX = btnX + btnW + 5
	self.Steam:SetPos(btnX, btnY)
	self.Steam:SetSize(btnW, btnH)

	btnX = btnX + btnW + 5
	self.SteamID:SetPos(btnX, btnY)
	self.SteamID:SetSize(btnW, btnH)

	btnX = btnX + btnW + 5
	self.SteamID64:SetPos(btnX, btnY)
	self.SteamID64:SetSize(btnW, btnH)

	btnX = btnX + btnW + 5
	self.VoiceVolume:SetPos(btnX, btnY)
	self.VoiceVolume:SetSize(btnW, btnH)

	btnY = btnY + ui.ButtonHeight + 5
	self.Achievements:SetPos(0, btnY)
	self.Achievements:SetSize(w - 5, ui.ButtonHeight)
	self.Achievements.Achievements:SetWide(btnW)
end

function PANEL:Update()
	if (not IsValid(self.Player)) or (self:GetParent():GetTall() <= 25) then return end

	self.Rank:SetText(self.Player:GetUserGroup())

	self.Rank:SetImage(
	(self.Player:IsRoot() and 'sup/gui/generic/sa2.png') or 
	(self.Player:GetUserGroup() == 'sudoroot' and 'sup/gui/generic/sa2.png') or 
	(self.Player:GetUserGroup() == 'council' and 'sup/gui/generic/sa2.png') or 
	(self.Player:GetUserGroup() == 'superadmin' and 'sup/gui/generic/sa2.png') or 
	(self.Player:GetUserGroup() == 'doubleadmin' and 'sup/gui/generic/adnin.png') or 
	(self.Player:GetUserGroup() == 'contentcreator' and 'sup/gui/generic/adnin.png') or 
	(self.Player:GetUserGroup() == 'admin' and 'sup/gui/generic/adnin2.png') or 
	(self.Player:GetUserGroup() == 'moderator' and 'sup/gui/generic/adnin2.png') or 
	(self.Player:IsVIP() and 'sup/gui/generic/vip.png') or 'sup/gui/generic/rank.png')

	self.PlayTime:SetText(ba.str.FormatTime(self.Player:GetPlayTime()))

	self.Achievements:Update()
end

function PANEL:SetPlayer(pl)
	self.Player = pl
	self.Achievements:SetPlayer(pl)
	self:Update()
end

function PANEL:Paint(w, h)
	draw.RoundedBoxEx(2, 0, 0, w, h, ui.col.FlatBlack, false, false, true, true)
end

vgui.Register('rp_scoreboard_playerinfo', PANEL, 'Panel')