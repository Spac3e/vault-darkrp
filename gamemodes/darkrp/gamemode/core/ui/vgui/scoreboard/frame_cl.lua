cvar.Register('HasClosedBlockMsg')
	:SetDefault(false, true)

local function newAdBtn(label, material, url, parent)
	local btn = ui.Create('ui_button', parent)
	btn:SetText(label)
	btn:SetImage(material)

	function btn:DoClick()
		if isfunction(url) then
			url(self)
		else
			gui.OpenURL(url)
		end
	end

	return btn
end

local PANEL = {}

local filters = {
	{'Все', function(self, pl) return true end},
	{'Админы', function(self, pl) return pl:IsAdmin() end},
	{'Орга', function(self, pl) return (LocalPlayer():GetOrg() and pl:GetOrg()) and (LocalPlayer():GetOrg() == pl:GetOrg()) end},
	{'Ты', function(self, pl) return (pl == LocalPlayer()) end},
	{'Поиск', function(self, pl)
		local text = self.SearchBar:GetText():lower()
		return (text == '') or pl:SteamID():lower():Contains(text) or (pl:SteamID64() or 'NULL'):Contains(text) or pl:Name():lower():Contains(text)
	end}
}

function PANEL:Init()
	self:SetVisible(false)

	self:SetSize(ScrW() * 0.8, ScrH() * 0.8)

//	self.ButtonWebsite = newAdBtn('Форум', 'sup/gui/generic/logo.png', 'https://blueservers.ru', self)
	self.ButtonCredits = newAdBtn('Донат', 'sup/gui/generic/credits.png', function() end, self)
	self.ButtonDiscord = newAdBtn('Discord', 'sup/gui/generic/discord.png', rp.cfg.DiscordURL, self)
	self.ButtonSteam = newAdBtn('Правила', 'sup/gui/generic/rules.png', rp.cfg.RulesURL, self)

	self.Filter = 1

	self.ButtonSearch = newAdBtn('Все', 'sup/gui/generic/filter.png', function(s)
		self.Filter = (self.Filter  == #filters) and 1 or (self.Filter  + 1)
		s:SetText(filters[self.Filter ][1])
		self:Update()
	end, self)
	self.ButtonSearch.DoRightClick = function(s)
		self.Filter = (self.Filter  == 1) and #filters or (self.Filter  - 1)
		s:SetText(filters[self.Filter ][1])
		self:Update()
	end

	self.PlayerRows = {}
	self.PlayerList = ui.Create('ui_scrollpanel', self)
	self.PlayerList:HideScrollbar(true)
	self.PlayerList.contentContainer._GetChildren = self.PlayerList.contentContainer.GetChildren
	self.PlayerList.contentContainer.GetChildren = function(s)
		local children = s:_GetChildren()

		local sortedChildren = {}

		local sorted = {}
		for i = 1, #rp.teams do
			sorted[i] = {}
		end

		for k, v in ipairs(children) do
			local pl = v.Player
			if IsValid(pl) and sorted[pl:GetJob()] then
				table.insert(sorted[pl:GetJob()], v)
			end
		end

		for _, t in ipairs(sorted) do
			table.sort(t, function (a, b) return a.Player:Name():lower() < b.Player:Name():lower() end)
			for k, v in ipairs(t) do
				table.insert(sortedChildren, v)
			end
		end
		return sortedChildren
	end

	self.PlayerList.Paint = function(self, w, h) draw.RoundedBox(5, 0, 0, w, h, ui.col.Background) end

	self.LogoButton = ui.Create('ui_button', self)
	self.LogoButton:SetText('')
	self.LogoButton.Paint = function() end
	self.LogoButton.DoClick = function()
		gui.OpenURL(rp.cfg.DiscordURL)
	end

	self.SearchBar = ui.Create('DTextEntry', self)
	self.SearchBar:SetPlaceholderText('Поиск...')
end

function PANEL:PerformLayout(w, h)
	local listW, listH = w - 10, h - 101
	self.PlayerList:SetSize(listW, listH)

	local listX, listY = 5, 85
	self.PlayerList:SetPos(listX, listY )
	self.PlayerList:SetPadding(0)
	self.PlayerList:SetSpacing(1)

	self.LogoButton:SetPos(0, 0)
	self.LogoButton:SetSize(187.5, 75)

	local btnW, btnH = 95, 35
	local btnX, btnY = (w - (btnW * 4)) - 20, 5
	self.SearchBar.x = btnX

//	self.ButtonWebsite:SetPos(btnX, btnY)
//	self.ButtonWebsite:SetSize(btnW, btnH)

	btnX = btnX + btnW + 5
	self.ButtonDiscord:SetPos(btnX, btnY)
	self.ButtonDiscord:SetSize(btnW, btnH)

	btnX = btnX + btnW + 5
	self.ButtonSteam:SetPos(btnX, btnY)
	self.ButtonSteam:SetSize(btnW, btnH)

	btnX = btnX + btnW + 5
	self.ButtonCredits:SetPos(btnX, btnY)
	self.ButtonCredits:SetSize(btnW, btnH)

	btnY = btnY + btnH + 5
	self.SearchBar.y = btnY
	self.SearchBar:SetSize(btnW * 3 + 10, btnH)

	self.ButtonSearch:SetPos(btnX, btnY)
	self.ButtonSearch:SetSize(btnW, btnH)
end

function PANEL:Open()
	self.StartAnim = SysTime()
	self.StartY = self.ActualY or -self:GetTall()
	self.EndY = (ScrH() - self:GetTall()) * 0.5
	self.ActualY = self.StartY
	self.Opening = true

	self:SetVisible(true)
end

function PANEL:Close()
	if (self.Filter == 5) then
		return
	end

	self.StartAnim = SysTime()
	self.StartY = self.ActualY or 0
	self.EndY = -self:GetTall()
	self.ActualY = self.StartY
	self.Opening = false
end

function PANEL:Update()
	local filterFunc = filters[self.Filter][2]

	self.SearchBar:SetVisible(self.Filter == 5)
	self:SetKeyboardInputEnabled(self.Filter == 5)

	local total_players, active_players, total_staff, active_staff = player.GetCount(), 0, 0, 0

	for k, v in ipairs(player.GetAll()) do
		if v:IsAdmin() then
			total_staff = total_staff + 1
		end
		if v:Alive() or (v:Team() ~= 1) then
			active_players = active_players + 1
			if v:IsAdmin() then
				active_staff = active_staff + 1
			end
		end

		if (not self.PlayerRows[v]) and filterFunc(self, v) then
			local row = ui.Create('rp_scoreboard_player')
			row:SetPlayer(v)
			self.PlayerList:AddItem(row)
			self.PlayerRows[v] = row
		end
	end

	for k, v in pairs(self.PlayerRows) do
		if (not IsValid(k)) or (not filterFunc(self, k)) then
			v:Remove()
			self.PlayerRows[k] = nil
		else
			self.PlayerRows[k]:Update()
		end
	end

	local ponline = 'Игроков онлайн: ' ..  total_players
	if (LocalPlayer():IsAdmin()) then
		ponline = ponline .. ' [' .. active_players .. ' Активно] | Администрация онлайн:' .. total_staff .. ' [' .. active_staff .. ' Активно]'
	end

	self.LabelPlayers = ponline

	local hours = math.floor(CurTime() / 3600)
	local minutes = math.floor((CurTime() % 3600) / 60)
	local seconds = math.floor(CurTime() - (hours * 3600) - (minutes * 60))
	if (minutes < 10) then minutes = '0' .. minutes end
	if (seconds < 10) then seconds = '0' .. seconds end
	self.LabelUptime = 'Время работы сервера: ' .. hours .. ':' .. minutes .. ':' .. seconds
end

function PANEL:Think()
	if self:IsVisible() then
		self:MoveToFront()

		if (not self.NextThink) or (self.NextThink < CurTime()) then
			self:Update()
			self.NextThink = CurTime() + 1
		end

		local mul = self.Opening and
			(math.sin(math.Clamp((SysTime() - self.StartAnim) / .5, 0, 1) * (math.pi / 1.42)) * 1.25)
		or
			(1 - math.sin((math.Clamp((SysTime() - self.StartAnim) / .3, 0, 1) - 2.42) * (math.pi / 1.42)) * 1.25)

		self.ActualY = self.StartY + mul * (self.EndY - self.StartY)
		self:SetPos((ScrW() - self:GetWide()) * 0.5, self.ActualY)

		if (!self.Opening and math.Round(mul) == 1) then self:SetVisible(false) end
	end
end

local material_header_logo = Material('sup/gui/generic/header_logo.png')
local background = Material 'sup/gui/generic/logo2.png'
function PANEL:Paint(w, h)
	draw.RoundedBox(5, 0, 0, w, h, ui.col.Background)

	draw.RoundedBox(5, 0, 0, w, 85, ui.col.Background)

	surface.SetDrawColor(255, 255, 255)
	surface.SetMaterial(material_header_logo)
	surface.DrawTexturedRect(10, 5, 187.5, 75)

	draw.SimpleText(self.LabelUptime, 'ui.12', 5, h - 2.5, ui.col.OffWhite, TEXT_ALIGN_LEFT, TEXT_ALIGN_BOTTOM)

	draw.SimpleText(self.LabelPlayers, 'ui.12', w - 5, h - 2.5, ui.col.OffWhite, TEXT_ALIGN_RIGHT, TEXT_ALIGN_BOTTOM)
end

vgui.Register('rp_scoreboard', PANEL, 'EditablePanel')