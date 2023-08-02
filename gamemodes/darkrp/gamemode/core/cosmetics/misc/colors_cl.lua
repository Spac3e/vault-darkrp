local function makeTab(tabs)
	local tab = ui.Create('ui_panel')
	tab:SetSize(tabs:GetParent():GetWide() - 165, tabs:GetParent():GetTall() - 35)

	ui.Label('Цвет Модели', 'ui.20', 5, 5, tab)

	ui.Create('DColorMixer', function(self, p)
		self:SetAlphaBar(false)
		self:SetSize(p:GetWide()/2 - 7.5, p:GetTall() - 60)
		self:SetPos(5, 25)
		self:SetVector(Vector(GetConVarString('cl_playercolor')))
		self.ValueChanged = function()
			local vec = self:GetVector()
			local vecstr = tostring(vec)
			timer.Create('rp.PlayerColor', 0.25, 1, function()
				RunConsoleCommand('cl_playercolor', vecstr)
				cmd.Run('playercolor', vec.x, vec.y, vec.z)
			end)
		end
	end, tab)

	ui.Label('Цвет Физ-Гана', 'ui.20', tab:GetWide()/2 + 7.5, 5, tab)

	ui.Create('DColorMixer', function(self, p)
		self:SetAlphaBar(false)
		self:SetSize(p:GetWide()/2 - 7.5, p:GetTall() - 60)
		self:SetPos(p:GetWide()/2 + 2.5, 25)
		self:SetVector(Vector(GetConVarString('cl_weaponcolor')))
		self.ValueChanged = function()
			local vec = self:GetVector()
			local vecstr = tostring(vec)
			timer.Create('rp.WeaponnColor', 0.25, 1, function()
				RunConsoleCommand('cl_weaponcolor', vecstr)
				cmd.Run('physcolor', vec.x, vec.y, vec.z)
			end)
		end
	end, tab)

	ui.Create('ui_button', function(self, p)
		self:SetSize(p:GetWide() - 10, 30)
		self:SetPos(5, p:GetTall() - 30)
		self:SetText('Выбери сумасшедший цвет для Физгана')
		self.DoClick = function()
			local min = math.Rand(10,100000000)
			local max = math.Rand(10,100000000)
			local a = math.Rand(-min, max)
			min = math.Rand(10,100000000)
			max = math.Rand(10,100000000)
			local b = math.Rand(-min, max)
			min = math.Rand(10,100000000)
			max = math.Rand(10,100000000)
			local c = math.Rand(-min, max)

			local vec = Vector(a,b,c)
			RunConsoleCommand('cl_weaponcolor', tostring(vec))
			cmd.Run('physcolor', vec.x, vec.y, vec.z)
		end
	end, tab)

	return tab
end

hook('PopulateF4Tabs', function(tabs)
	tabs:AddTab('Цвет', function(self)
		return makeTab(tabs)
	end):SetIcon 'materials/sup/gui/generic/art.png'
end)