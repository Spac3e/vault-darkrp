-- Перестань ебаться в глаза и хукать сборку, сделай сам или купи у ｓｕｇｒａａｌ. ｌｕｖ ｓｕｐ#8475
local commands = {}
function rp.AddMenuCommand(cat, name, cback, custom)
	if (not commands[cat]) then
		commands[cat] = {}
	end
	table.insert(commands[cat], {
		name = name,
		cback = cback,
		custom = custom or function() return true end
	})
end

cat = 'UI'
rp.AddMenuCommand(cat, 'Открыть редактор цветов', function() ui.OpenColorEditor() end)

local cat = 'Деньги'
rp.AddMenuCommand(cat, 'Передать деньги', function()
	ui.NumberRequest('Кошелёк', 'Сколько денег вы хотите передать?', 2, 2, LocalPlayer():GetMoney(), function(a)
		cmd.Run('give', tostring(a))
	end)
end)
rp.AddMenuCommand(cat, 'Выбросить пачку денег', function()
	ui.NumberRequest('Кошелёк', 'Сколько денег вы хотите бросить на пол?', 2, 2, LocalPlayer():GetMoney(), function(a)
		cmd.Run('dropmoney', tostring(a))
	end)
end)

cat = 'Действия'
rp.AddMenuCommand(cat, 'Продать все двери', 'sellall')
rp.AddMenuCommand(cat, 'Выбросить текущее оружие', 'drop')
rp.AddMenuCommand(cat, 'Заказать убийство', function()
	ui.PlayerRequest(function(v)
		ui.StringRequest('Заказать убийство', 'Укажите цену за убийство (' .. rp.FormatMoney(rp.cfg.HitMinCost) .. ' - ' .. rp.FormatMoney(rp.cfg.HitMaxCost) .. ')?', '', function(a)
			if IsValid(v) then
				cmd.Run('hit', v:SteamID(), a)
			end
		end)
	end)
end)
rp.AddMenuCommand(cat, 'Уволить игрока', function()
	ui.PlayerRequest(function(v)
		ui.StringRequest('Уволить игрока', 'Введите причину', '', function(a)
			if IsValid(v) then
				cmd.Run('demote', v:SteamID(), a)
			end
		end)
	end)
end)
rp.AddMenuCommand(cat, 'Поделится пропами', function()
	rp.pp.SharePropMenu()
end)	

cat = 'Ролеплей'
rp.AddMenuCommand(cat, 'Установить название профессии', function()
	ui.StringRequest('Установить название профессии', 'Введите новое название профессии', '', function(a)
		cmd.Run('job', a)
	end)
end)
rp.AddMenuCommand(cat, 'Сменить ролевое имя', function()
	ui.StringRequest('Сменить ролевое имя', 'Введите новое ролевое имя', '', function(a)
		cmd.Run('name', a)
	end)
end)
rp.AddMenuCommand(cat, 'Получить случайное ролевое имя', 'randomname')
rp.AddMenuCommand(cat, 'Случайное число', 'roll')
rp.AddMenuCommand(cat, 'Бросить кубики', 'dice')
rp.AddMenuCommand(cat, 'Вытащить карту', 'cards')
rp.AddMenuCommand(cat, 'Подбросить монетку', 'coins')


cat = 'Правопорядок'
rp.AddMenuCommand(cat, 'Объявить в розыск', function()
	ui.PlayerRequest(function(v)
		ui.StringRequest('Объявить в розыск', 'Введите причину', '', function(a)
			if IsValid(v) then
				cmd.Run('want', v:SteamID(), a)
			end
		end)
	end)
end)
rp.AddMenuCommand(cat, 'Снять розыск', function()
	local wantedplayers = table.Filter(player.GetAll(), function(v)
		return v:IsWanted()
	end)
	ui.PlayerRequest(wantedplayers, function(v)
		cmd.Run('unwant', v:SteamID())
	end)
end)
rp.AddMenuCommand(cat, 'Запросить ордер на обыск', function()
	ui.PlayerRequest(function(v)
		ui.StringRequest('Запросить ордер на обыск', 'Введите причину', '', function(a)
			if IsValid(v) then
				cmd.Run('warrant', v:SteamID(), a)
			end
		end)
	end)
end)


cat = 'Мэр'
rp.AddMenuCommand(cat, 'Комендантский час', function()
	if nw.GetGlobal('lockdown') then
		cmd.Run('unlockdown')
	end
	 ui.StringRequest('Комендантский час', 'Введите причину', '', function(a)
		cmd.Run('lockdown', tostring(a))
	end)
end)
rp.AddMenuCommand(cat, 'Запустить лотерею', function()
	ui.StringRequest('Запустить лотерею', 'Введите стоимость участия', '', function(a)
		cmd.Run('lottery', tostring(a))
	end)
end)
rp.AddMenuCommand(cat, 'Изменить законы', 'laws')
rp.AddMenuCommand(cat, 'Дать лицензию', 'givelicense')


local PANEL = {}
function PANEL:Init()
	self.ShowEmployees = (not LocalPlayer():GetTeamTable().hirable)

	self.Cats = {}
	self.Rows = {}
	
	self.List1 = ui.Create('ui_listview', self)
	self.List1.Paint = function() end

	if self.ShowEmployees then
		self.List2 = ui.Create('rp_employment_manager', self)
		self.List2.Paint = function() end
	end

	self:AddCat('Деньги', commands['Деньги'])
	self:AddCat('Действия', commands['Действия'])
	self:AddCat('Ролеплей', commands['Ролеплей'])

	if LocalPlayer():IsMayor() then
		self:AddCat('Мэр', commands['Мэр'])
	end
	if LocalPlayer():IsCP() or LocalPlayer():IsMayor() then
		self:AddCat('Правопорядок', commands['Правопорядок'])
	end
	self.Cats['Мэр'] = true
	self.Cats['Правопорядок'] = true

	for k, v in pairs(commands) do
		self:AddCat(k, v)
	end
end

function PANEL:PerformLayout()
	local w = self.ShowEmployees and self:GetWide() * 0.5 - 7.5 or self:GetWide() - 10
	self.List1:SetPos(5, 5)
	self.List1:SetSize(w, self:GetTall() - 10)

	if self.ShowEmployees then
		self.List2:SetPos(self:GetWide() * 0.5 + 2.5, 5)
		self.List2:SetSize(w, self:GetTall() - 10)
	end
end

function PANEL:AddCat(cat, tab)
	tab = table.FilterCopy(tab, function(v) return v.custom() end)
	if (#tab > 0) then
		if (not self.Cats[cat]) then
			local cmdList = self.List1
			cmdList:AddSpacer(cat):SetSize(cmdList:GetWide(), 30)
			for k, v in ipairs(tab) do
				local row = cmdList:AddRow(v.name)
				row:SetSize(cmdList:GetWide(), 30)
				row.DoClick = isstring(v.cback) and function() cmd.Run(v.cback) end or v.cback
				table.insert(self.Rows, row)
			end

			self.Cats[cat] = true
		end
	end
end

vgui.Register('rp_commandlist', PANEL, 'Panel')