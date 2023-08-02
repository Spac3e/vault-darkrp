local function submitPermaWeaponChoices()
	local choices = cvar.GetValue('perma_weapon_choices')

	net.Start('rp.PermaWeaponSettings')
		-- Weps
		net.WriteUInt(table.Count(choices[1]), 8)
		for k, v in pairs(choices[1]) do
			net.WriteUInt(k, 10)
			net.WriteBool(v == true)
		end

		-- Knives, the != 0 shit is backwards compat because I'm retarded
		if (choices[2] != nil and choices[2] != 0) then
			net.WriteBool(true)
			net.WriteUInt(choices[2], 10)
		else
			net.WriteBool(false)
		end

		-- Vapes
		if (choices[3] != nil and choices[3] != 0) then
			net.WriteBool(true)
			net.WriteUInt(choices[3], 10)
		else
			net.WriteBool(false)
		end
	net.SendToServer()
end

cvar.Register 'perma_weapon_choices'
	:SetDefault({{}, nil, nil}, true)
	:SetEncrypted()
	:AddInitCallback(submitPermaWeaponChoices)


local upgradeCats 		= {}
local upgradeCatOrder 	= {}
function rp.shop.AddCategory(name, callback)
	upgradeCats[name] = callback
	upgradeCatOrder[#upgradeCatOrder + 1] = name
end

rp.shop.AddCategory('Основное', function(upgrade, parent)
	local text = string.Wrap('ui.22', upgrade:GetDesc(), parent:GetWide() - 10)

	local y = (parent:GetTall() - (#text * 22)) * 0.5
	for k, v in ipairs(text) do
		ui.Create('DLabel', function(self)
			self:SetText(v)
			self:SizeToContents()
			self:CenterHorizontal()
			self:SetPos(self.x, y)

			y = y + 22
		end, parent)
	end
end)

rp.shop.AddCategory('Ранги', upgradeCats['Основное'])
rp.shop.AddCategory('Наборы Денег', upgradeCats['Основное'])
rp.shop.AddCategory('Наборы Кармы', upgradeCats['Основное'])
rp.shop.AddCategory('Оружие Навсегда', function(upgrade, parent)
	local rad
	if parent.HasPurchased then
		local choices = cvar.GetValue('perma_weapon_choices')
		rad = parent:Add("ui_checkbox")
		rad:SetText('Активировать')
		rad:SetPos(5, 5)
		rad:SizeToContents()

		rad.OnChange = function(self, bool)
			choices[1][upgrade:GetID()] = bool

			cvar.SetValue('perma_weapon_choices', choices)

			submitPermaWeaponChoices()
		end

		if (choices[1][upgrade:GetID()] == nil or choices[1][upgrade:GetID()] == true) then
			rad:SetChecked(true)
		end
	end

		if (not upgrade:GetIcon()) then
			upgradeCats["Основное"](upgrade, parent)
			return
		end

		local mdlpnl = ui.Create("DModelPanel", function(self)
			self:SetSize(parent:GetSize())
			self:Center()

			local nm = upgrade:GetName()

			function self:LayoutEntity(ent)
				if (nm == "Crowbar" or nm == "Stunstick") then
					ent:SetAngles(Angle(45, 0, 0))
				end

				return false
			end

			self:SetModel(upgrade:GetIcon())

			if (nm == '.357 Magnum') then
				self:SetFOV(25)
				self:SetCamPos(Vector(10, -60, 15))
				self:SetLookAt(Vector(0, 45, -8))
			elseif (nm == "Default Knife") then
				self:SetFOV(50)
				self:SetCamPos(Vector(0, 25, 10))
				self:SetLookAt(Vector(0, 0, 9))
			elseif (nm == "Stunstick" or nm == "Crowbar") then
				self:SetFOV(85)
				self:SetCamPos(Vector(0, 25, 10))
				self:SetLookAt(Vector(0, 0, 0))
			else
				self:SetFOV(40)
				self:SetCamPos(Vector(0, 25, 10))
				self:SetLookAt(Vector(0, 0, -2))
			end
		end, parent)

	if rad then
		rad:MoveToFront()
	end
end)
rp.shop.AddCategory('Ножи Навсегда', function(upgrade, parent)
	local rad
	if parent.HasPurchased then
		local choices = cvar.GetValue('perma_weapon_choices')
		rad = parent:Add("ui_checkbox")
		rad:SetText('Активировать')
		rad:SetPos(5, 5)
		rad:SizeToContents()

		rad.OnChange = function(self, bool)
			choices[2] = bool and upgrade:GetID() or nil

			cvar.SetValue('perma_weapon_choices', choices)

			submitPermaWeaponChoices()
		end

		rad:SetChecked(choices[2] and choices[2] == upgrade:GetID())
	end

	if (not upgrade:GetIcon()) then
		upgradeCats["Основное"](upgrade, parent)

		return
	end

	local mdlpnl = ui.Create("DModelPanel", function(self)
		self:SetSize(parent:GetSize())
		self:Center()

		local nm = upgrade:GetName()

		function self:LayoutEntity(ent)
			if (upgrade:GetIcon() == "models/weapons/w_csgo_push.mdl") then
				ent:SetAngles(Angle(-45, 90, 0))
			elseif (upgrade:GetIcon() == "models/weapons/w_csgo_karambit.mdl") then
				ent:SetAngles(Angle(180, 0, 0))
			end

			if (upgrade.Skin) then ent:SetMaterial(upgrade.Skin) end

			return false
		end

		self:SetModel(upgrade:GetIcon())

		if (nm == "Basic Knife") then
			self:SetFOV(50)
			self:SetCamPos(Vector(0, 25, 10))
			self:SetLookAt(Vector(0, 0, 9))
		elseif (upgrade:GetIcon() == "models/weapons/w_csgo_push.mdl") then
			self:SetFOV(25)
			self:SetCamPos(Vector(0, 25, 5))
			self:SetLookAt(Vector(0, 0, -1))
		elseif (upgrade:GetIcon() == "models/weapons/w_csgo_karambit.mdl") then
			self:SetFOV(50)
			self:SetCamPos(Vector(0, 20, 10))
			self:SetLookAt(Vector(-1, 10, 8.5))
		else
			self:SetFOV(40)
			self:SetCamPos(Vector(0, 25, 10))
			self:SetLookAt(Vector(5, -5, 0))
		end
	end, parent)

	if rad then
		rad:MoveToFront()
	end
end)
rp.shop.AddCategory('Плюшки', function(upgrade, parent)
	local rad
	if parent.HasPurchased then
		local choices = cvar.GetValue('perma_weapon_choices')
		rad = parent:Add("ui_checkbox")
		rad:SetText('Enable')
		rad:SetPos(5, 5)
		rad:SizeToContents()

		rad.OnChange = function(self, bool)
			choices[3] = bool and upgrade:GetID() or nil

			cvar.SetValue('perma_weapon_choices', choices)

			submitPermaWeaponChoices()
		end

		rad:SetChecked(choices[3] and choices[3] == upgrade:GetID())
	end

	local mats = {
		Material(Format("particle/smokesprites_00%02d", math.random(7, 16))),
		Material(Format("particle/smokesprites_00%02d", math.random(7, 16))),
		Material(Format("particle/smokesprites_00%02d", math.random(7, 16)))
	}
	local col = upgrade.Color or rp.col.White

	local matShower = ui.Create('Panel', function(self)
		self:Dock(FILL)
		self.Paint = function(self, w, h)
			local x = w * 0.5
			local y = h * 0.5
			local w = w * 0.25
			local h = w

			surface.SetMaterial(mats[1])
			surface.SetDrawColor(isfunction(col) and col() or col)
			surface.DrawTexturedRect(x - w * 0.5 + math.cos(SysTime() / 10 - 2) * 8, y - h * 0.5 + math.sin(SysTime() / 4 + 5) * 4, w, h)

			surface.SetMaterial(mats[2])
			surface.SetDrawColor(isfunction(col) and col() or col)
			surface.DrawTexturedRect(x - w * 0.75 + math.cos(SysTime() / 2) * 8, y - h * 0.75 + math.sin(SysTime() / 4) * 5, w, h)

			surface.SetMaterial(mats[3])
			surface.SetDrawColor(isfunction(col) and col() or col)
			surface.DrawTexturedRect(x - w * 0.2 + math.sin(SysTime() / 2 - 25) * 7, y - h * 0.25 + math.cos(SysTime() / 4) * 10, w, h)

			draw.NoTexture()
		end
	end, parent)

	if rad then
		rad:MoveToFront()
	end
end)
rp.shop.AddCategory('Ивенты', upgradeCats['Основное'])
rp.shop.AddCategory('Приобретённое', function(upgrade, parent)
	upgradeCats[upgrade:GetCat()](upgrade, parent)
end)

local PANEL = {}

local fr
function PANEL:Init()
	fr = self
	self.IsLoaded = false

	net.Ping 'rp.shop.Menu'

	self.List = ui.Create('ui_listview', self)
	self.List:SetSpacing(1)
	self.List.Paint = function() end

	self.Name = ui.Create('ui_button', self)
	self.Name:SetDisabled(true)
	self.Name:SetText('← Выберите предмет')

	self.Price = ui.Create('DLabel', self)
	self.Price:SetTextColor(ui.col.DarkGreen)
	self.Price:Hide()

	self.Error = ui.Create('DLabel', self)
	self.Error:Hide()

	self.Info = ui.Create('DPanel', self)
	self.Info.Paint = function(s, w, h)
		draw.SimpleText('Добро пожаловать в донат магазин VAULTRP!', 'ui.22', w * 0.5, 10, Color(0, 140, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)

		draw.SimpleText('Выберите улучшение для просмотра информации.', 'ui.22', w * 0.5, 30, ui.col.Green, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)

		draw.SimpleText('Мы высоко ценим все ваши вклады!', 'ui.22', w * 0.5, 50, ui.col.Red, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)
	end

	-- TODO: Make earn rewards work

	--self.EarnRewards = ui.Create('ui_reward_panel', self.Info)

	self.Container = ui.Create('DPanel', self)
	self.Container.Paint = function() end

	self.Purchase = ui.Create('ui_button', self)
	self.Purchase:SetText('Купить')
	self.Purchase:Hide()
	self.Purchase.BackgroundColor = ui.col.DarkGreen
	self.Purchase.OutlineColor = ui.col.OffWhite
	self.Purchase.Think = function(s)
		if s.Confirmed and (s.ResetConfirm <= CurTime()) then
			s.Confirmed = nil
			s:SetText('Купить')
		end
	end
	self.Purchase.DoClick = function(s)
		if (not IGS.CanAfford(LocalPlayer(), self.Upgrade.Price)) then
			ui.BoolRequest('Упс', 'У вас недостаточно рублей. Вы желаете пополнить счёт?', function(ans)
				if (ans == true) then
					IGS.WIN.Deposit(self.Upgrade.Price - LocalPlayer():IGSFunds())
				end
			end)
			return
		end

		if (not s.Confirmed) then
			s.ResetConfirm = CurTime() + 3
			s:SetText('Подтвердите')

			s.Confirmed = true
			return
		end

		s.Confirmed = nil
		s:SetText('В процессе...')
		s:SetDisabled(true)
		rp.ToggleF4Menu()

		cmd.Run('buyupgrade', tostring(self.Upgrade:GetID()))
	end
end

function PANEL:ApplySchemeSettings()
	self.Price:SetFont('ui.22')

	self.Error:SetFont('ui.22')
	self.Error:SetTextColor(ui.col.Red)
end

function PANEL:PerformLayout(w, h)
	self.List:SetPos(5, 5)
	self.List:SetSize((w * 0.5) - 7.5, h - 10)

	local leftX, leftW = (w * 0.5) + 2.5, (w * 0.5) - 7.5

	self.Name:SetPos(leftX, 5)
	self.Name:SetSize(leftW, ui.SpacerHeight)

	self.Price:SizeToContents()
	self.Price:SetPos((w * 0.75) - (self.Price:GetWide() * 0.5), ui.SpacerHeight + 5)

	self.Error:SizeToContents()
	self.Error:SetPos((w * 0.75) - (self.Error:GetWide() * 0.5), ui.SpacerHeight + 20 + 5)

	self.Container:SetPos(leftX, ui.SpacerHeight + 5)
	self.Container:SetSize(leftW, h - 90)

	self.Info:SetPos(leftX, ui.SpacerHeight)
	self.Info:SetSize(leftW, h - 80)

	--self.EarnRewards:SetSize(self.Info:GetWide(), (4 * 49) + 2)
	--self.EarnRewards:SetPos(0, 80)

	self.Purchase:SetPos(leftX, h - ui.SpacerHeight - 5)
	self.Purchase:SetSize(leftW, ui.SpacerHeight)


end

function PANEL:PaintOver(w, h)
	if (not self.IsLoaded) then
		local t = SysTime() * 5
		draw.NoTexture()
		surface.SetDrawColor(255, 255, 255)
		surface.DrawArc(w * 0.5, h * 0.5, 41, 46, t * 80, t * 80 + 180, 20)
	end
end

function PANEL:AddControls(f4)
	if IsValid(self.BuyCredits) then
		self.BuyCredits:Show()
	elseif IsValid(f4) then
		self.BuyCredits = ui.Create('ui_button', f4)
		self.BuyCredits:SetText('Пополнить' .. rp.cfg.CreditSale)
		self.BuyCredits.BackgroundColor = ui.col.DarkGreen
		self.BuyCredits:SizeToContents()
		self.BuyCredits:SetSize(self.BuyCredits:GetWide() + 10, f4.btnClose:GetTall())
		self.BuyCredits:SetPos(f4.btnClose.x - self.BuyCredits:GetWide() + 1, 0)
		self.BuyCredits.Corners = {true, true, true, true}
		self.BuyCredits.DoClick = function(s)
			IGS.WIN.Deposit()
		end
	end

	if IsValid(self.CreditsBalance) then
		self.CreditsBalance:Show()
	elseif IsValid(f4) then
		self.CreditsBalance = ui.Create('ui_button', f4)
		self.CreditsBalance:SetDisabled(true)
		self.CreditsBalance.TextColor = rp.col.Yellow
		self.CreditsBalance:SetText(string.Comma(LocalPlayer():IGSFunds()) .. ' Рублей')
		self.CreditsBalance:SizeToContents()
		self.CreditsBalance:SetSize(self.CreditsBalance:GetWide() + 10, f4.btnClose:GetTall())
		self.CreditsBalance:SetPos(self.BuyCredits.x - self.CreditsBalance:GetWide() + 1, 0)
		self.CreditsBalance.Corners = {true, true, true, true}
	end
end

function PANEL:HideControls()
	if IsValid(self.BuyCredits) then
		self.BuyCredits:Hide()
	end

	if IsValid(self.CreditsBalance) then
		self.CreditsBalance:Hide()
	end
end

function PANEL:AddUpgrades(upgrades)
	local sortedUpgrades = {
		Purchased = {}
	}

	for k, v in ipairs(upgradeCatOrder) do
		sortedUpgrades[v] = {}
	end

	for k, v in ipairs(upgrades) do
		local category = v.Upgrade:GetCat()

		if (not upgradeCats[category]) then
			--print('Unsuppored category: ' .. category)
			continue
		end

		if v.HasPurchased then
			table.insert(sortedUpgrades['Приобретённое'], v)
		else
			table.insert(sortedUpgrades[category], v)
		end

		-- TODO: sort more here - canAfford, cannotAfford, purchased
	end

	for id, cat in pairs(upgradeCatOrder) do
		local upgrades = sortedUpgrades[cat] or {}

		local parent = ui.Create('ui_collapsible_section', function(s)
			s:SetText(cat)
			s.OnCollapsing = function()
				self.List:InvalidateLayout()
			end
		end)
		self.List:AddItem(parent)

		local size = (parent:GetWide() / 5) - 3 -- this should be -4, idk where the math is off!

		local i, y = 0, 1
		for k, v in ipairs(upgrades) do
			if (i == 5) then
				i = 0
				y = y + size + 1
			end

			parent:AddItem(ui.Create('rp_creditshop_item', function(s)
				s.CanBuy 		= v.CanBuy
				s.CanBuyReason	= v.CanBuyReason
				s.HasPurchased	= v.HasPurchased
				s.Price 		= v.Price

				s:SetUpgrade(v.Upgrade)

				s:SetSize(size, size)
				s:SetPos((i * size) + i, y)
			end))

			i = i + 1
		end

		parent:SetTall(y + size + 1)
	end
end

function PANEL:DoClick(itemPnl, upgrade)
	self.Upgrade = upgrade
	--PrintTable(self.Upgrade)

	self.Info:Hide()

	self.Price:Show()
	self.Purchase:Show()
	self.Purchase:SetDisabled(false)

	if itemPnl.CanBuyReason then
		self.Error:Show()

		self.Error:SetText(itemPnl.CanBuyReason)
		self.Error:SizeToContents()
		self.Error:SetPos((self:GetWide() * 0.75) - (self.Error:GetWide() * 0.5), 60)

		if (not itemPnl.CanBuyReason:StartWith('Вы не можете себе это позволить!')) then
			self.Purchase:SetDisabled(true)
		end
	else
		self.Error:Hide()
	end

	self.Name:SetText(upgrade:GetName())

	self.Price:SetText(string.Comma(itemPnl.Price) .. ' Рублей')
	self.Price:SizeToContents()
	self.Price:SetPos((self:GetWide() * 0.75) - (self.Price:GetWide() * 0.5), 40)

	for k, v in ipairs(self.Container:GetChildren()) do
		v:Remove()
	end

	self.Container.HasPurchased = itemPnl.HasPurchased
	upgradeCats[upgrade:GetCat()](upgrade, self.Container)
end

vgui.Register('rp_creditshop_panel', PANEL, 'Panel')

local PANEL = {}

function PANEL:Init()
	self:SetText('')
end

function PANEL:DoClick()
	fr:DoClick(self, self.Upgrade)

	fr.Selected = self
end

function PANEL:PerformLayout(w, h)
	if self.SpawnIcon then
		self.SpawnIcon:SetPos(10, 10)
		self.SpawnIcon:SetSize(w - 20, h - 20)
	end

	self.BaseClass.PerformLayout(self, w, h)
end

local color_bar_buyable = ui.col.SUP:Copy()
color_bar_buyable.a = 50

local color_bar_canbuy = ui.col.Red:Copy()
color_bar_canbuy.a = 50

local color_bar_purchased = ui.col.FlatBlack:Copy()
--color_bar_purchased.a = 50

function PANEL:Paint(w, h)

	if (fr.Selected == self) then
		draw.Box(1, 20, w - 2, h - 40, ui.col.Hover)
	end

	if self.Upgrade:GetImage() then
		surface.SetDrawColor(255, 255, 255, 255)
		surface.SetMaterial(self.Upgrade:GetImage())
		surface.DrawTexturedRect(25, 25, w - 50, w - 50)
	end

	local color_bar = color_bar_buyable

	local canAfford = IGS.CanAfford(LocalPlayer(), self.Price)
	if not self.CanBuy then
		color_bar = color_bar_canbuy
	end

	if self.HasPurchased and (not self.Upgrade:IsStackable()) then
		color_bar = color_bar_purchased
	end

	-- TODO: support already purchased/errors here

	draw.RoundedBoxEx(5, 0, 0, w, 20, color_bar, true, true, false, false)
	draw.SimpleText(self.Upgrade:GetName():MaxCharacters(20, true), 'ui.15', w * 0.5, 11, ui.col.White, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER) -- TODO: Better solution for long names

	draw.RoundedBoxEx(5, 0, h - 20, w, 20, color_bar, false, false, true, true)
	draw.SimpleText(string.Comma(self.Price) .. ' Рублей', 'ui.15', w * 0.5, h - 11, ui.col.White, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)

	draw.Box(0, 20, 1, h - 40, color_bar)
	draw.Box(w - 1, 20, 1, h - 40, color_bar)

	if (fr.Selected == self) then
	--	draw.Outline(1, 1, w - 2, h - 2, ui.col.White)
	end
end

function PANEL:SetUpgrade(upgrade)
	self.Upgrade = upgrade

	if upgrade:GetIcon() then
		self.SpawnIcon = ui.Create('SpawnIcon', self)
		self.SpawnIcon:SetSize(self:GetWide() - 30, self:GetTall() - 30)
		self.SpawnIcon:SetModel(upgrade:GetIcon(), upgrade.SkinIndex)
		self.SpawnIcon.DoClick = function() self.DoClick(self) end
		self.SpawnIcon.Paint = function() end
		self.SpawnIcon.PaintOver = function() end
		self.SpawnIcon:SetToolTip(nil)
	end
end

vgui.Register('rp_creditshop_item', PANEL, 'DButton')

net('rp.shop.Menu', function()
	local ret = {}
	for i = 1, net.ReadUInt(9) do
		ret[i] = {}
		ret[i].ID = net.ReadUInt(9)
		ret[i].CanBuy = net.ReadBool()
		if (not ret[i].CanBuy) then
			ret[i].CanBuyReason = net.ReadString()
		end
		ret[i].HasPurchased = net.ReadBool()
		ret[i].Price = net.ReadUInt(32)
		ret[i].Upgrade = rp.shop.GetTable()[ret[i].ID]
	end

	table.sort(ret, function(a, b)
		return a.Price < b.Price
	end)

	if LocalPlayer():IsAdmin() and (upgradeCatOrder[2] == 'Ранги') then
		local ranks = table.remove(upgradeCatOrder, 2)
		table.insert(upgradeCatOrder, 7, ranks)
	end

	if IsValid(fr) then
		fr:AddUpgrades(ret)

		fr.IsLoaded = true
	else
		rp.ToggleF4Menu(true)
	end
end)