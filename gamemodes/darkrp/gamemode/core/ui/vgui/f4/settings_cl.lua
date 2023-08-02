local defaultBinds = {
	{
		Key = KEY_H,
		Cmd = '/y Покиньте эту территорию или я убью вас! У вас 10 секунд.',
		Type = 'Чат'
	},
	{
		Key = KEY_O,
		Cmd = 'net_graph 0',
		Type = 'Свой'
	},
	{
		Key = KEY_P,
		Cmd = 'net_graph 1',
		Type = 'Свой'
	}
}

local function getTracePlayerDistanceLimited()
	local tr = LocalPlayer():GetEyeTrace().Entity
	if (!tr or !isplayer(tr)) then return nil, "В данный момент вы не наведены на игрока." end
	if (tr:GetPos():DistToSqr(LocalPlayer():GetPos()) > 90000) then return nil, "Вы находитесь слишком далеко от этого игрока." end -- 300 units
	return tr
end

local bindMacros = {
	["{aimPlayer.Name}"] = {
		GetValue = function()
			local tr, err = getTracePlayerDistanceLimited()
			if (tr == nil) then return nil, err end
			return tr:Name()
		end,
		Description = 'Имя игрока, на которого вы смотрите'
	},
	["{aimPlayer.SteamID}"] = {
		GetValue = function()
			local tr, err = getTracePlayerDistanceLimited()
			if (tr == nil) then return nil, err end
			return tr:SteamID()
		end,
		Description = 'SteamID игрока, на которого вы смотрите'
	},
	['{my.Money}'] = {
		GetValue = function()
			return rp.FormatMoney(LocalPlayer():GetMoney())
		end,
		Description = 'Ваши Деньги'
	},
	['{my.Job}'] = {
		GetValue = function()
			return LocalPlayer():GetJobTable().name
		end,
		Description = 'Ваша Профессия'
	},
}

-- Optional variants
bindMacros["[aimPlayer.Name]"] = {
	GetValue = bindMacros["{aimPlayer.Name}"].GetValue,
	Description = bindMacros["{aimPlayer.Name}"].Description,
	Optional = true
}
bindMacros["[aimPlayer.SteamID]"] = {
	GetValue = bindMacros["{aimPlayer.SteamID}"].GetValue,
	Description = bindMacros["{aimPlayer.SteamID}"].Description,
	Optional = true
}

cvar.Register 'custom_binds'
	:SetDefault {
		Profile = 'Default',
		['Default'] = defaultBinds
	}

local function saveBind(key, cmd, type)
	if (not key) then return end

	local binds = cvar.GetValue 'custom_binds'
	local profile = binds[binds.Profile]

	local index = #profile + 1

	for k, v in ipairs(profile) do
		if (v.Key == key) then
			index = k
			break
		end
	end

	profile[index] = {
		Key 	= key,
		Cmd 	= cmd or '',
		Type 	= type or 'Default'
	}

	cvar.SetValue('custom_binds', binds)
end

local function removeBind(key)
	local binds = cvar.GetValue 'custom_binds'
	local profile = binds[binds.Profile]

	for k, v in ipairs(profile) do
		if (v.Key == key) then
			table.remove(profile, k)
			break
		end
	end

	cvar.SetValue('custom_binds', binds)
end

local PANEL = {}

function PANEL:Init()
	self:SetTall(65)

	self.Binder = ui.Create('ui_button', self)
	self.Binder:SetText '...'
	self.Binder.DoClick = function(s)
		input.StartKeyTrapping()
		s.Trapping = true
		s:SetText '...'
	end
	self.Binder.Think = function(s)
		if input.IsKeyTrapping() and s.Trapping then
			local key = input.CheckKeyTrapping()
			if key then
				removeBind(self.Key)

				s:SetText(input.GetKeyName(key):upper())
				s.Trapping = false

				self.Key = key
				saveBind(key, self.Cmd, self.Type)
			end
		end
	end

	self.Setting = ui.Create('DComboBox', self)
	self.Setting:AddChoice('Чат')
	self.Setting:AddChoice('Команда')
	self.Setting:AddChoice('Свой')
	self.Setting.OnSelect = function(s, inx, type)
		self.Type = type
		saveBind(self.Key, self.Cmd, self.Type)
	end

	self.Macro = ui.Create('ui_button', self)
	self.Macro:SetText('Добавить Макрос')
	self.Macro.DoClick = function(s)
		local m = ui.DermaMenu()

		for k, v in pairs(bindMacros) do
			m:AddOption((v.Optional and '(Необязательно) ' or '') .. v.Description, function()
				self.Custom:SetText(self.Custom:GetText() .. k)

				self.Custom:OnChange()
			end)
		end
		m:Open()
	end

	self.Custom = ui.Create('DTextEntry', self)
	self.Custom:SetPlaceholderText('Команда...')
	self.Custom.OnChange = function(s)
		self.Cmd = s:GetValue()
		saveBind(self.Key, self.Cmd, self.Type)
	end

	self.Unbind = ui.Create('ui_button', self)
	self.Unbind:SetText ''
	self.Unbind.DoClick = function(s)
		removeBind(self.Key)
		self:Remove()
	end
	self.Unbind.Paint = function(s, w, h)
		derma.SkinHook('Paint', 'WindowCloseButton', s, w, h)
	end
end

function PANEL:PerformLayout()
	self.Binder:SetPos(5, 5)
	self.Binder:SetSize(55, 55)

	self.Custom:SetPos(65, 35)
	self.Custom:SetSize(self:GetWide() - 70, 25)

	self.Unbind:SetSize(25, 25)
	self.Unbind:SetPos(self:GetWide() - 30, 5)

	local settingW = (self:GetWide() - self.Binder:GetWide() - self.Unbind:GetWide()) * 0.5 - 12.5

	self.Setting:SetPos(65, 5)
	self.Setting:SetSize(settingW, 25)


	self.Macro:SetPos(70 + self.Setting:GetWide(), 5)
	self.Macro:SetSize(settingW, 25)
end

function PANEL:SetBind(inf)
	if (not inf.Key) then return self:Remove() end -- broken bind idk

	self.Key = inf.Key
	self.Cmd = inf.Cmd
	self.Type = inf.Type

	self.Binder:SetText((input.GetKeyName(self.Key) or '...'):upper())
	self.Setting:SetText(self.Type)
	self.Custom:SetValue(self.Cmd)
end
vgui.Register('rp_keybinder', PANEL, 'ui_panel')


local PANEL = {}

function PANEL:Init()
	self.Settings = ui.Create('ui_settingspanel', self)


	self.Settings:Populate({'Медиа Проигрыватели', 'Чат', 'HUD', 'Остальное'})

	local binds = cvar.GetValue 'custom_binds'

	self.Profile = ui.Create('DComboBox', self)
	self.Profile.OnSelect = function(s, inx, value)
		local binds = cvar.GetValue 'custom_binds'
		binds.Profile = value
		cvar.SetValue('custom_binds', binds)

		self.KeyBinds:Reset()

		for k, v in ipairs(binds[binds.Profile]) do
			self.KeyBinds:AddItem(ui.Create('rp_keybinder', function(self)
				self:SetBind(v)
			end))
		end
	end


	self.RemoveProfile = ui.Create('ui_button', self)
	self.RemoveProfile:SetFont'ForkAwesome'
	self.RemoveProfile:SetText(utf8.char(0xf1f8))
	self.RemoveProfile.Think = function(s)
		s:SetDisabled(cvar.GetValue('custom_binds').Profile == 'Default')
	end
	self.RemoveProfile.DoClick = function(s)
		ui.BoolRequest('Удалить Профиль', 'Вы уверены, что хотите удалить этот профиль биндов?', function(ans)
			if ans then
				local binds = cvar.GetValue 'custom_binds'
				binds.Profile = 'Default'
				binds[self.Profile:GetValue()] = nil
				cvar.SetValue('custom_binds', binds)

				self.Profile:Clear()

				for k, v in pairs(binds) do
					if istable(v) then
						self.Profile:AddChoice(k)
					end
				end

				self.Profile:ChooseOption('Default')
			end
		end)
	end

	self.AddProfile = ui.Create('ui_button', self)
	self.AddProfile:SetFont'ForkAwesome'
	self.AddProfile:SetText(utf8.char(0xf067))
	self.AddProfile.DoClick = function(s)
		ui.StringRequest('Добавить Профиль', 'Как бы вы хотели назвать этот профиль биндов?', '', function(value)
			local binds = cvar.GetValue 'custom_binds'
			binds.Profile = value
			binds[value] = defaultBinds

			self.Profile:AddChoice(value)
			self.Profile:ChooseOption(value)
		end)
	end

	self.KeyBinds = ui.Create('ui_listview', self)
	self.KeyBinds:SetSpacing(1)


	for k, v in pairs(binds) do
		if istable(v) then
			self.Profile:AddChoice(k)
		end
	end

	self.Profile:ChooseOption(binds.Profile)

	self.AddBinding = ui.Create('ui_button', self)
	self.AddBinding:SetText('Добавить Бинд')

	self.AddBinding.DoClick = function(s)
		self.KeyBinds:AddItem(ui.Create 'rp_keybinder')
	end
end

function PANEL:PerformLayout(w, h)
	self.Settings:SetPos(5, 5)
	self.Settings:SetSize(self:GetWide() * 0.5 - 7.5, self:GetTall() - 10)

	self.Profile:SetPos((w * 0.5) + 5, 5)
	self.Profile:SetSize((w - (w * 0.5) - 70), 25)

	self.RemoveProfile:SetPos(self.Profile.x + self.Profile:GetWide() + 5, self.Profile.y)
	self.RemoveProfile:SetSize(25, 25)

	self.AddProfile:SetPos(self.RemoveProfile.x + self.RemoveProfile:GetWide() + 5, self.Profile.y)
	self.AddProfile:SetSize(25, 25)

	self.KeyBinds:SetPos((w * 0.5), 35)
	self.KeyBinds:SetSize(w - (w * 0.5) - 5, h - 70)

	self.AddBinding:SetPos(w * 0.5 + 5, h - 30)
	self.AddBinding:SetSize(w - (w * 0.5) - 10, 25)
end
vgui.Register('rp_settings', PANEL, 'Panel')


local ignoreBinds = false
hook('StartChat', 'rp.KeyBinds.StartChat', function()
	ignoreBinds = true
end)

hook('FinishChat', 'rp.KeyBinds.FinishChat', function()
	timer.Simple(0.1, function()
		ignoreBinds = false
	end)
end)

local lastkey = 0
local nextcall = 0
hook('Think', 'rp.KeyBinds.Think', function()
	if chat.IsOpen() or ignoreBinds then return end

	local a, b = gui.MousePos()
	local binds = cvar.GetValue 'custom_binds'

	if (a == 0) and (b == 0) and binds then
		local profile = binds[binds.Profile]
		if profile then
			for k, v in ipairs(profile) do
				if v.Key and v.Cmd and v.Type and input.IsKeyDown(v.Key) then
					if (lastkey ~= v.Key) and (nextcall < CurTime()) then
						local cmd = v.Cmd

						for macro,data in pairs(bindMacros) do
							if (string.find(cmd, macro)) then
								local replace, err = data.GetValue()
								if (replace == nil) then
									if (data.Optional) then
										replace = ""
									else
										rp.Notify(NOTIFY_ERROR, err .. " (Макрос: " .. macro .. ")")
										nextcall = CurTime() + 0.33
										return
									end
								end

								cmd = string.Replace(cmd, macro, replace)
							end
						end

						if (v.Type == 'Чат') then
							LocalPlayer():ConCommand('say ' .. cmd)
						elseif (v.Type == 'Команда') then
							LocalPlayer():ConCommand('rp ' .. cmd)
						elseif (v.Type == 'Свой') then
							LocalPlayer():ConCommand(cmd)
						end
						nextcall = CurTime() + 0.33
						continue
					end
					nextcall = CurTime() + 0.33
				end
			end
		end
	end
end)