IGS.sh("utf8.lua")
if SERVER then
	resource.AddWorkshop("2786808725") -- иконки
	return
end

utf8.len = string.utf8len

local FONT_TAB_ACTIVE = "ui.20" -- надпись активной вкладки
local FONT_TAB_INACTIVE = "ui.18" -- надпись неактивной вкладки
local FONT_IGS_CAT = "ui.40" -- 28 -- названия категорий предметов и в профиле
local FONT_ITEM_PURCHASED = "ui.15" -- 10 для stacked предметов появляется после покупки
local FONT_ITEM_NAME = "ui.18" -- название предмета
local FONT_ITEM_PRICE = "ui.18" -- цена предмета
local FONT_INVENTORY_NAME = "ui.22" -- название предмета
local FONT_INVENTORY_TERM = "ui.18" -- срок действия предмета
local FONT_INVENTORY_ACTIVATE = "ui.20" -- кнопка активировать
local FONT_INVENTORY_DROP = "ui.17" -- кнопка выкинуть
local FONT_INVENTORY_NONE = "ui.40" -- нет вещей
local FONT_CHOOSE_ITEM = "ui.20" -- текст выберите предмет
local FONT_ITEM_PRICE_OLD = "ui.15" -- 14
local FONT_ITEM_SUB = "ui.15" -- 14 -- "Подробнее", "Действует"
local FONT_ITEM_DESC_TITLE = "ui.20" -- Тайтл "Описание"
local FONT_ITEM_DESC = "ui.17" -- 16 -- описание предмета
local FONT_BAL = "ui.17" -- 16 -- баланс и "+" рядом
local FONT_TABLE_COLUMN = "ui.17" -- 16 -- название колонок
local FONT_TABLE_ROW = FONT_TABLE_COLUMN -- ячейки в таблице
local FONT_LAST_TOPUP_DATE = "ui.17" -- дата последнего пополнения
local FONT_LAST_TOPUP_SUM = "ui.22" -- сумма последнего пополнения
local FONT_PROFILE_NAME = "ui.18" -- 16 имя профиля
local FONT_PROFILE_SID = "ui.15" -- 16 SteamID профиля
local FONT_TOPUPS_SUM = "ui.15" -- 14 общая сумма пополнений
local FONT_SIDE_BUTTONS = "ui.18" -- кнопки в сайдбаре профиля
local FONT_THANKS = "ui.24" -- Деньги пойдут на помощь проекту..
local FONT_LOG_TEXT = "ui.18" -- Текст лога
local FONT_TOPUP_AMOUNT = FONT_LOG_TEXT -- Поле суммы пополнения
local FONT_TOPUP_BUTTON = "ui.18" -- Кнопка пополнения

local function pX(a)
	return a -- / 1920 * ScrW()
end

-- Главная штучка, чтобы перенести это без лишнего труда с картинки в код.
local function matsmooth(mat)
	return Material(mat, "smooth")
end

local close_mat = matsmooth("hrp/gui/donate/close.png")
local shop_mat = matsmooth("hrp/gui/donate/shop.png")
local shop_unactive_mat = matsmooth("hrp/gui/donate/shop_unactive.png")
local profile_mat = matsmooth("hrp/gui/donate/profile.png")
local profile_unactive_mat = matsmooth("hrp/gui/donate/profile_unactive.png")
local go_mat = matsmooth("hrp/gui/donate/go.png")
local grad_mat = matsmooth("hrp/gui/donate/grad.png")
local buy_mat = matsmooth("hrp/gui/donate/buy.png")
local heart_mat = matsmooth("hrp/gui/donate/heart.png")
local coupon_mat = matsmooth("hrp/gui/donate/coupon.png")
--[[ Полезные функции ]]
NM = {}

NM.Tabs = {
	["shop"] = {
		ID = 1,
		Name = "Услуги",
		Mats = {shop_mat, shop_unactive_mat}
	},
	["profile"] = {
		ID = 2,
		Name = "Профиль",
		Mats = {profile_mat, profile_unactive_mat}
	}
}

-- Тут понятен формат, нужно делать VGUI, с приставкой nm_ (vgui.Register)
if IGS.C.Inv_Enabled then
	NM.Tabs["inventory"] = {
		ID = 3,
		Name = "Инвентарь",
		Mats = {shop_mat, shop_unactive_mat}
	}
end

NM.OpenFirstTab = "shop"

NM.Buttons = {
	["profile_purchases"] = {
		ID = 1,
		Name = "Покупки"
	},
	["profile_donate"] = {
		ID = 2,
		Name = "Пополнить баланс"
	}
}

-- Тут так же само
NM.PathToRefill = {
	[1] = "profile",
	[2] = "profile_donate"
}

-- Легкий путь к пополнению счета (1 - Tab, 2 - Button)
function NM.CreateUI(t, f, p)
	local parent

	if (not isfunction(f)) and (f ~= nil) then
		parent = f
	elseif not isfunction(p) and (p ~= nil) then
		parent = p
	end

	local v = vgui.Create(t, parent)

	if isfunction(f) then
		f(v, parent)
	elseif isfunction(p) then
		p(v, f)
	end

	return v
end

-- Облегчает работу
local tabfr

function NM.OpenTab(tab, frame)
	if IsValid(tabfr) then
		tabfr:Remove()
	end

	tabfr = NM.CreateUI("nm_" .. tab, function(self)
		self:SetSize(pX(978), pX(530) - pX(54))
		self:SetPos(0, pX(54))
	end, frame)
end

local btnfr

function NM.OpenButton(btn, frame)
	if IsValid(btnfr) then
		btnfr:Remove()
	end

	btnfr = NM.CreateUI("nm_" .. btn, function(self)
		self:SetSize(pX(781), pX(530) - pX(54))
		self:SetPos(0, 0)
	end, frame)
end

-- Бля
function NM.GetItems()
	local allcats = {}

	for k, v in pairs(IGS.GetItems()) do
		if k ~= 0 and v.hidden ~= true and not allcats[v.category or "Разное"] then
			allcats[v.category or "Разное"] = true
		end
	end

	return allcats
end

function NM.FancyTerm(item)
	local term = IGS.TermToStr(item)

	if term == "бесконечно" then
		return "Навсегда"
	elseif term == "единоразово" then
		return "Одноразово"
	else
		return "На " .. term
	end
end

--[[ Меню ]]
local fr

function NM.Menu()
	if IsValid(fr) then
		fr:Close()

		return
	end

	local w, h = pX(978), pX(530)

	fr = NM.CreateUI("DFrame", function(self)
		self.lblTitle:SetText("")
		self:SetSize(w, h)
		self:MakePopup()
		self:Center()
		self.btnMaxim:SetVisible(false)
		self.btnMinim:SetVisible(false)

		function self:Paint(w, h)
			draw.RoundedBox(8, 0, 0, w, h, Color(31, 31, 31))
			draw.RoundedBoxEx(8, 0, self:GetTitleHeight(), pX(781), pX(476), Color(47, 47, 47), false, false, true)
			draw.RoundedBoxEx(8, w - pX(85), self:GetTitleHeight() / 2 - pX(11), pX(22), pX(22), Color(35, 108, 0), false, true, false, true)
			draw.SimpleText("+", FONT_BAL, w - pX(74), self:GetTitleHeight() / 2, Color(255, 255, 255), 1, 1)
			draw.RoundedBoxEx(8, w - pX(185), self:GetTitleHeight() / 2 - pX(11), pX(100), pX(22), Color(55, 55, 55), true, false, true, false)
			draw.SimpleText(IGS.SignPrice(LocalPlayer():IGSFunds()), FONT_BAL, w - pX(92), self:GetTitleHeight() / 2 - pX(1), Color(255, 255, 255), TEXT_ALIGN_RIGHT, 1)
			draw.RoundedBox(0, 0, self:GetTitleHeight(), w, 1, Color(47, 47, 47))
		end

		function self:GetTitleHeight()
			return pX(54)
		end

		local cbtn = pX(17)

		function self.btnClose:Paint(w, h)
			surface.SetDrawColor(255, 255, 255, 255)
			surface.SetMaterial(close_mat)
			surface.DrawTexturedRect(0, 0, cbtn, cbtn)
		end

		function self:PerformLayout()
			self.btnClose:SetPos(self:GetWide() - pX(28) - cbtn, self:GetTitleHeight() / 2 - cbtn / 2)
			self.btnClose:SetSize(cbtn, cbtn)
		end

		function self:SwitchTab(tab)
			self.ActiveTab = NM.Tabs[tab]
			self.OpenedTab = NM.OpenTab(tab, self)
		end

		self:SwitchTab(NM.OpenFirstTab)
	end)

	NM.CreateUI("DButton", function(self)
		self:SetText("")
		self:SetSize(pX(22), pX(22))
		self:SetPos(w - pX(85), fr:GetTitleHeight() / 2 - pX(11))

		self.DoClick = function()
			fr:SwitchTab(NM.PathToRefill[1])
			tabfr:SwitchButton(NM.PathToRefill[2])
		end

		self.Paint = function() end
	end, fr)

	local textx, texty, iconx, iconwh, iconwhun = pX(54), fr:GetTitleHeight() / 2, pX(16), pX(26), pX(22)

	for k, v in pairs(NM.Tabs) do
		NM.CreateUI("DButton", function(self)
			self:SetText("")
			self:SetSize(pX(223), fr:GetTitleHeight())
			self:SetPos(pX(29) + pX(237 * (v.ID - 1)), 0)
			self.Tab = k

			self.DoClick = function(self)
				if fr.ActiveTab == NM.Tabs[self.Tab] then return end
				fr:SwitchTab(self.Tab)
			end

			function self:Paint(w, h)
				if fr.ActiveTab == NM.Tabs[self.Tab] then
					draw.RoundedBoxEx(8, 0, 0, w, h, Color(62, 62, 62), true, true)
					draw.SimpleText(v.Name, FONT_TAB_ACTIVE, textx, texty, Color(200, 200, 200), 0, 1)
					surface.SetDrawColor(255, 255, 255)
					surface.SetMaterial(v.Mats[1])
					surface.DrawTexturedRect(iconx, texty - iconwh / 2, iconwh, iconwh)
				else
					draw.RoundedBoxEx(8, 0, h * .17, w, h * .83, Color(55, 55, 55), true, true)
					draw.SimpleText(v.Name, FONT_TAB_INACTIVE, textx - pX(4), texty + h * .085, Color(105, 105, 105), 0, 1)
					surface.SetDrawColor(255, 255, 255)
					surface.SetMaterial(v.Mats[2])
					surface.DrawTexturedRect(iconx, texty - iconwhun / 2 + h * .085, iconwhun, iconwhun)
				end
			end
		end, fr)
	end

	return fr
end

--[[ Тут дальше VGUI ]]
--[[ Для магазина ]]
local PANEL = {}

function PANEL:Init()
	self.parent = self:GetParent()
	self.scrollButton = vgui.Create("Panel", self)

	self.scrollButton.OnMousePressed = function(s, mb)
		if mb == MOUSE_LEFT and not self:GetParent().ShouldHideScrollbar then
			local _, my = s:CursorPos()
			s.scrolling = true
			s.mouseOffset = my
		end
	end

	self.scrollButton.OnMouseReleased = function(s, mb)
		if mb == MOUSE_LEFT then
			s.scrolling = false
			s.mouseOffset = nil
		end
	end

	self.height = 0
end

function PANEL:Think()
	if self.scrollButton.scrolling then
		if not input.IsMouseDown(MOUSE_LEFT) then
			self.scrollButton:OnMouseReleased(MOUSE_LEFT)

			return
		end

		local mx, my = self.scrollButton:CursorPos()
		local diff = my - self.scrollButton.mouseOffset
		local maxOffset = self.parent:GetCanvas():GetTall() - self.parent:GetTall()
		local perc = (self.scrollButton.y + diff) / (self:GetTall() - self.height)
		self.parent.yOffset = math.Clamp(perc * maxOffset, 0, maxOffset)
		self.parent:InvalidateLayout()
	end
end

function PANEL:PerformLayout()
	local maxOffset = self.parent:GetCanvas():GetTall() - self.parent:GetTall()
	self:SetSize(2, self.parent:GetTall())
	self:SetPos(self.parent:GetWide() - self:GetWide(), 0)
	self.heightRatio = self.parent:GetTall() / self.parent:GetCanvas():GetTall()
	self.height = math.Clamp(math.ceil(self.heightRatio * self.parent:GetTall()), 20, math.huge)
	self.scrollButton:SetSize(self:GetWide(), self.height)
	self.scrollButton:SetPos(0, math.Clamp(self.parent.yOffset / maxOffset, 0, 1) * (self:GetTall() - self.height))
end

function PANEL:Paint(w, h)
	if self:GetParent().ShouldHideScrollbar then return end
	derma.SkinHook("Paint", "UIScrollBar", self, w, h)
end

function PANEL:OnMouseWheeled(delta)
	self.parent:OnMouseWheeled(delta)
end

vgui.Register("nm_scrollbar", PANEL, "Panel")
PANEL = {}

function PANEL:Init()
	self.contentContainer = vgui.Create("Panel", self)
	self.scrollBar = vgui.Create("nm_scrollbar", self)
	self.yOffset = 0
	self.ySpeed = 0
	self.scrollSize = 4
	self.SpaceTop = 0
	self.Padding = 0

	function self.contentContainer:OnChildRemoved(child)
		self:GetParent():PerformLayout()
	end
end

function PANEL:Reset()
	self:GetCanvas():Clear(true)
	self.yOffset = 0
	self.ySpeed = 0
	self.scrollSize = 1
	self:PerformLayout()
end

function PANEL:AddItem(child)
	child:SetParent(self:GetCanvas())
	self:PerformLayout()
end

function PANEL:SetSpacing(i)
	self.SpaceTop = i
end

function PANEL:SetPadding(i)
	self.Padding = i
end

function PANEL:GetCanvas()
	return self.contentContainer
end

function PANEL:SetScrollSize(int)
	self.scrollSize = int
end

function PANEL:ScrollTo(y)
	self.yOffset = y
	self:InvalidateLayout()
end

function PANEL:OnMouseWheeled(delta)
	if (delta > 0 and self.ySpeed < 0) or (delta < 0 and self.ySpeed > 0) then
		self.ySpeed = 0
	else
		self.ySpeed = self.ySpeed + (delta * self.scrollSize)
	end

	self:PerformLayout()
end

function PANEL:SetOffset(offSet)
	local maxOffset = self:GetCanvas():GetTall() - self:GetTall()

	if maxOffset < 0 then
		maxOffset = 0
	end

	self.yOffset = math.Clamp(offSet, 0, maxOffset)
	self:PerformLayout()
	if self.yOffset == 0 or self.yOffset == maxOffset then return true end
end

function PANEL:Think()
	if self.ySpeed ~= 0 then
		if self:SetOffset(self.yOffset - self.ySpeed) then
			self.ySpeed = 0
		else
			if self.ySpeed < 0 then
				self.ySpeed = math.Clamp(self.ySpeed + (FrameTime() * self.scrollSize * 4), self.ySpeed, 0)
			else
				self.ySpeed = math.Clamp(self.ySpeed - (FrameTime() * self.scrollSize * 4), 0, self.ySpeed)
			end
		end
	end
end

function PANEL:PerformLayout()
	local canvas = self:GetCanvas()

	if canvas:GetWide() ~= self:GetWide() then
		canvas:SetWide(self:GetWide())
	end

	local y = 0
	local lastChild

	for k, v in ipairs(canvas:GetChildren()) do
		local childY = y + self.SpaceTop

		if v.x ~= self.Padding or v.y ~= childY then
			v:SetPos(math.max(0, self.Padding), y + self.SpaceTop)
		end

		if v:GetWide() ~= self:GetWide() - self.Padding * 2 then
			v:SetWide(math.min(self:GetWide(), self:GetWide() - self.Padding * 2))
		end

		y = v.y + v:GetTall() + self.SpaceTop + self.Padding
		lastChild = v
	end

	y = lastChild and lastChild.y + lastChild:GetTall() or y

	if canvas:GetTall() ~= y then
		canvas:SetTall(y)
	end

	if canvas:GetTall() <= self:GetTall() and self.scrollBar:IsVisible() then
		canvas:SetTall(self:GetTall())
		self.scrollBar:SetVisible(false)
	elseif canvas:GetTall() > self:GetTall() and not self.scrollBar:IsVisible() then
		self.scrollBar:SetVisible(true)
	end

	local maxOffset = self:GetCanvas():GetTall() - self:GetTall()

	if self.yOffset > maxOffset then
		self.yOffset = maxOffset
	end

	if self.yOffset < 0 then
		self.yOffset = 0
	end

	if canvas.x ~= 0 or canvas.y ~= -self.yOffset then
		canvas:SetPos(0, -self.yOffset)
		self.scrollBar:InvalidateLayout()
	end
end

function PANEL:IsAtMaxOffset()
	local maxOffset = math.Clamp(self:GetCanvas():GetTall() - self:GetTall(), 0, math.huge)

	return self.yOffset == maxOffset
end

function PANEL:Paint(w, h)
end

function PANEL:HideScrollbar(bool)
	self.ShouldHideScrollbar = bool
end

function PANEL:DockToFrame()
	local p = self:GetParent()
	local x, y = p:GetDockPos()
	self:SetPos(x, y)
	self:SetSize(p:GetWide() - 10, p:GetTall() - (y + 5))
end

vgui.Register("nm_scrollpanel", PANEL, "Panel")
PANEL = {}

function PANEL:Init()
	self.Rows = {}
	self.HideInvisible = true
	self.RowHeight = 25
	self:SetPadding(-1)

	self.scrollBar.Paint = function(s, w, h)
		draw.RoundedBox(0, 0, s.scrollButton.y, w, s.height, Color(255, 255, 255))
	end
end

function PANEL:SetRowHeight(height)
	self.RowHeight = height
end

function PANEL:AddCustomRow(row, disabled)
	self:AddItem(row)
	self.Rows[#self.Rows + 1] = row

	return row
end

function PANEL:AddRow(value, disabled)
	local row = NM.CreateUI("DButton", function(s)
		s:SetText("")
		s:SetTall(self.RowHeight)

		if disabled == true then
			s:SetDisabled(true)
		end

		s.Paint = function(s, w, h)
			draw.SimpleText(tostring(value), FONT_IGS_CAT, pX(29), h / 2, Color(255, 255, 255, 255), 0, 1)
		end
	end)

	self:AddItem(row)
	self.Rows[#self.Rows + 1] = row

	row.DoClick = function()
		row.Active = true

		if IsValid(self.Selected) then
			self.Selected.Active = false
		end

		self.Selected = row
	end

	return row
end

function PANEL:AddSpacer(value)
	return self:AddRow(value, true)
end

function PANEL:GetSelected()
	return self.Selected
end

vgui.Register("nm_listview", PANEL, "nm_scrollpanel")
PANEL = {}

function PANEL:Init()
	self:SetText("")
	self.ButtonBuy = NM.CreateUI("DButton", self)
	self.ModelIcon = NM.CreateUI("DModelPanel", self)
end

function PANEL:PerformLayout()
	local btnwh = pX(25)
	self.ButtonBuy:SetPos(self:GetWide() - pX(12) - btnwh, self:GetTall() - btnwh - pX(12))
	self.ButtonBuy:SetSize(btnwh, btnwh)
	self.ButtonBuy:SetText("")

	self.ButtonBuy.Paint = function(s, w, h)
		surface.SetDrawColor(255, 255, 255, 255)
		surface.SetMaterial(buy_mat)
		surface.DrawTexturedRect(0, 0, w, h)
	end

	local iconwh = pX(80)
	self.ModelIcon:SetPos(self:GetWide() / 2 - iconwh / 2, pX(6))
	self.ModelIcon:SetSize(iconwh, iconwh)
end

function PANEL:Paint(w, h)
	draw.RoundedBox(8, 0, 0, w, h, self.MainFrame.ActiveItem == self.Item and Color(223, 223, 223) or Color(68, 68, 68))
	draw.RoundedBox(8, 1, 1, w - 2, h - 2, Color(55, 55, 55))
	local item = IGS.GetItem(self.Item)
	local name = item.name

	if utf8.len(name) > 16 then
		name = utf8.sub(name, 0, 14) .. "..."
	end

	draw.SimpleText(name, FONT_ITEM_NAME, pX(16), h - pX(60), item.highlight or Color(255, 255, 255), 0, 4)
	local tw, th = draw.SimpleText("Подробнее", FONT_ITEM_SUB, pX(16), h - pX(45), Color(105, 105, 105), 0, 4)
	surface.SetDrawColor(255, 255, 255, 255)
	surface.SetMaterial(go_mat)
	surface.DrawTexturedRect(pX(16) + tw + pX(10), h - pX(45) - th / 2 - pX(1), pX(4), pX(6))

	if item.discounted_from then
		tw, th = draw.SimpleText(IGS.SignPrice(item.discounted_from), FONT_ITEM_PRICE_OLD, pX(16), h - pX(30), Color(105, 105, 105), 0, 4)
		local liney = h - pX(34)
		surface.SetDrawColor(255, 255, 255, 255)
		surface.DrawLine(pX(16), liney - th * .5, pX(16) + tw, liney)
	end

	draw.SimpleText(IGS.SignPrice(item.price), FONT_ITEM_PRICE, pX(16), h - pX(16), Color(255, 255, 255), 0, 4)

	if item.icon and not item.icon.isModel then
		surface.SetDrawColor(255, 255, 255, 255)
		surface.SetMaterial(texture.Get(item.uid) or close_mat)
		local iconwh = pX(80)
		surface.DrawTexturedRect(w / 2 - iconwh / 2, pX(6), iconwh, iconwh)
		surface.SetDrawColor(255, 255, 255, 180)
		surface.SetMaterial(grad_mat)
		surface.DrawTexturedRect(pX(1), pX(12), w - pX(2), iconwh)
	end
end

function PANEL:SetInfo(uid, frame)
	self.Item = uid
	self.MainFrame = frame

	self.DoClick = function()
		frame:OpenItem(uid)
	end

	local item = IGS.GetItem(self.Item)

	self.ButtonBuy.DoClick = function()
		IGS.BoolRequest("Подтверждение покупки", "Вы действительно хотите купить " .. item.name .. "?", function(a)
			if a then
				frame:BuyItem(uid)
			end
		end)
	end

	self.ModelIcon.DoClick = function()
		frame:OpenItem(uid)
	end

	if item.icon and not item.icon.isModel then
		texture.Create(item.uid):Download(item.icon.icon)
		self.ModelIcon:SetVisible(false)
	elseif item.icon and item.icon.isModel then
		self.ModelIcon:SetVisible(true)
		self.ModelIcon:SetModel(item.icon.icon)
		local mn, mx = self.ModelIcon.Entity:GetRenderBounds()
		local size = 0
		size = math.max(size, math.abs(mn.x) + math.abs(mx.x))
		size = math.max(size, math.abs(mn.y) + math.abs(mx.y))
		size = math.max(size, math.abs(mn.z) + math.abs(mx.z))
		self.ModelIcon:SetFOV(30)
		self.ModelIcon:SetCamPos(Vector(size, size, size))
		self.ModelIcon:SetLookAt((mn + mx) * 0.5)
	end

	self:SetToolTip(item.name)
end

vgui.Register("nm_shop_button", PANEL, "DButton")
PANEL = {}
local btnwh = pX(168)

function PANEL:PerformLayout()
	local c = 0
	local o = 0

	for k, v in ipairs(self:GetChildren()) do
		v:SetPos(pX(29) + (o * (btnwh + pX(20))), c * (btnwh + pX(20)))
		v:SetSize(btnwh, btnwh)

		if k % 4 == 1 then
			o = 1
		elseif k % 4 == 2 then
			o = 2
		elseif k % 4 == 3 then
			o = 3
		elseif k % 4 == 0 then
			c = c + 1
			o = 0
		end
	end
end

function PANEL:AddItem(uid, frame)
	local btn = NM.CreateUI("nm_shop_button", self)
	btn:SetInfo(uid, frame)
	self:SetTall(math.ceil(#self:GetChildren() * (1 / 4)) * btnwh + math.ceil(#self:GetChildren() * (pX(20) / 4)))
end

vgui.Register("nm_shop_category", PANEL, "Panel")
--[[ Магазин ]]
PANEL = {}

function PANEL:Init()
	self.Paint = function()
		if not IsValid(self.OpenedItem) then
			draw.SimpleText("Выберите предмет!", FONT_CHOOSE_ITEM, pX(877), pX(20), color_white, 1, 1)
		end
	end

	local cat
	self.Cats = {}
	self.List = NM.CreateUI("nm_listview", self)
	self.List.Paint = function() end

	for catitem, _ in pairs(NM.GetItems()) do
		self.List:AddSpacer(catitem):SetTall(pX(72))
		cat = NM.CreateUI("nm_shop_category")

		for k, v in pairs(IGS.GetItems()) do
			v.category = v.category or "Разное"

			if k ~= 0 and v.hidden ~= true and v.category == catitem then
				cat:AddItem(k, self)
			end
		end

		self.List:AddItem(cat)
	end
end

function PANEL:PerformLayout()
	self.List:SetPos(0, 0)
	self.List:SetSize(self:GetWide() - pX(197), self:GetTall())
end

function PANEL:OpenItem(uid)
	if self.ActiveItem == uid then return end
	self.ActiveItem = uid

	if IsValid(self.OpenedItem) then
		self.OpenedItem:Remove()
		self.OpenedItemInfo:Remove()
		self.OpenedItemInfo.Scroll:Remove()
	end

	self.OpenedItem = NM.CreateUI("nm_shop_button", self)
	self.OpenedItem:SetInfo(uid, self)
	self.OpenedItem:SetPos(pX(978) - pX(14) - btnwh, pX(14))
	self.OpenedItem:SetSize(btnwh, btnwh)
	local item = IGS.GetItem(uid)
	self:SetToolTip(item.name)

	self.OpenedItem.Paint = function(s, w, h)
		draw.RoundedBox(8, 0, 0, w, h, Color(68, 68, 68))
		draw.RoundedBox(8, 1, 1, w - 2, h - 2, Color(55, 55, 55))
		local name = item.name

		if utf8.len(name) > 16 then
			name = utf8.sub(name, 0, 14) .. "..."
		end

		if s.Purchased then
			draw.SimpleText("Куплено: " .. s.Purchased, FONT_ITEM_PURCHASED, w / 2, h - pX(160), Color(255, 255, 255), 1, 1)
		end

		draw.SimpleText(name, FONT_ITEM_NAME, pX(16), h - pX(60), item.highlight or Color(255, 255, 255), 0, 4)
		draw.SimpleText(NM.FancyTerm(item:Term()), FONT_ITEM_SUB, pX(16), h - pX(45), Color(105, 105, 105), 0, 4)

		if item.discounted_from then
			tw, th = draw.SimpleText(IGS.SignPrice(item.discounted_from), FONT_ITEM_PRICE_OLD, pX(16), h - pX(30), Color(105, 105, 105), 0, 4)
			local liney = h - pX(34)
			surface.SetDrawColor(255, 255, 255, 255)
			surface.DrawLine(pX(16), liney - th * .5, pX(16) + tw, liney)
		end

		draw.SimpleText(IGS.SignPrice(item.price), FONT_ITEM_PRICE, pX(16), h - pX(16), Color(255, 255, 255), 0, 4)

		if item.icon and not item.icon.isModel then
			surface.SetDrawColor(255, 255, 255, 255)
			surface.SetMaterial(texture.Get(item.uid) or close_mat)
			local iconwh = pX(80)
			surface.DrawTexturedRect(w / 2 - iconwh / 2, pX(6), iconwh, iconwh)
			surface.SetDrawColor(255, 255, 255, 180)
			surface.SetMaterial(grad_mat)
			surface.DrawTexturedRect(pX(1), pX(12), w - pX(2), iconwh)
		end
	end

	self.OpenedItemInfo = NM.CreateUI("DPanel", self)
	self.OpenedItemInfo:SetText("")
	local oifw, oifh = pX(197), pX(280)
	self.OpenedItemInfo:SetPos(pX(978) - oifw, pX(530) - pX(54) - oifh)
	self.OpenedItemInfo:SetSize(oifw, oifh)

	self.OpenedItemInfo.Paint = function(s, w, h)
		draw.RoundedBox(0, 0, 1, w, 1, Color(58, 58, 58))
		draw.SimpleText("Описание", FONT_ITEM_DESC_TITLE, pX(14), pX(14), Color(134, 134, 134))
	end

	self.OpenedItemInfo.Scroll = NM.CreateUI("nm_listview", self)
	self.OpenedItemInfo.Scroll:SetPos(pX(978) - oifw + pX(14), pX(530) - pX(10) - oifh)
	self.OpenedItemInfo.Scroll:SetSize(oifw - pX(28), oifh - pX(60))
	self.OpenedItemInfo.Scroll.Paint = function() end
	local txt = string.Wrap(FONT_ITEM_DESC, item.description, self.OpenedItemInfo.Scroll:GetWide())

	for k, v in ipairs(txt) do
		local lbl = NM.CreateUI("DLabel", function(s, p)
			s:SetText(v)
			s:SetFont(FONT_ITEM_DESC)
			s:SizeToContents()
		end)

		self.OpenedItemInfo.Scroll:AddItem(lbl)
	end

	if item.swep and LocalPlayer():HasPurchase(item:UID()) then
		self.OpenedItemInfo.CheckBox = NM.CreateUI("DCheckBox", self.OpenedItem)
		self.OpenedItemInfo.CheckBox:Dock(TOP)
		self.OpenedItemInfo.CheckBox:DockMargin(0, 5, 0, 0)
		self.OpenedItemInfo.CheckBox:SetTall(pX(20))
		local should_give = LocalPlayer():GetNWBool("igs.gos." .. item:ID())
		self.OpenedItemInfo.CheckBox:SetValue(should_give)
		self.OpenedItemInfo.CheckBox:SetText("")

		self.OpenedItemInfo.CheckBox.OnChange = function(s, give)
			net.Start("IGS.GiveOnSpawnWep")
			net.WriteIGSItem(item)
			net.WriteBool(give)
			net.SendToServer()
		end
	end
end

local function purchase(ITEM, msg)
	IGS.Purchase(ITEM:UID(), function(errMsg, dbID)
		if errMsg then
			IGS.ShowNotify(errMsg, "Ошибка покупки")
			surface.PlaySound("ambient/voices/citizen_beaten1.wav")

			return
		end

		msg.Purchased = msg.Purchased or 0
		msg.Purchased = msg.Purchased + 1

		if not ITEM:IsStackable() then
			if not IGS.C.Inv_Enabled then
				IGS.ShowNotify("Спасибо за покупку. Это было просто, правда? :)", "Успешная покупка")

				return
			end

			IGS.BoolRequest("Успешная покупка", "Спасибо за покупку. Она находится в вашем /donate инвентаре.\n\nАктивировать ее сейчас?", function(yes)
				if not yes then return end
				IGS.ProcessActivate(dbID)
			end)
		end

		surface.PlaySound("ambient/office/coinslot1.wav")
	end)
end

function PANEL:BuyItem(uid)
	if self.ActiveItem ~= uid then
		self:OpenItem(uid)
	end

	purchase(IGS.GetItem(uid), self.OpenedItem)
end

vgui.Register("nm_shop", PANEL, "Panel")
--[[ Профиль ]]
PANEL = {}

function PANEL:Init()
	self.Avatar = NM.CreateUI("AvatarImage", function(s)
		local size = pX(76)
		s:SetSize(size, size)
		s:SetPos(pX(844), pX(28))
		s:SetPlayer(LocalPlayer(), size)
	end, self)

	for k, v in pairs(NM.Buttons) do
		NM.CreateUI("DButton", function(s)
			s:SetText("")
			s:SetSize(pX(167), pX(43))
			s:SetPos(pX(796), pX(215) + pX(53 * (v.ID - 1)))
			s.Button = k

			s.DoClick = function(s)
				if self.ActiveButton == NM.Buttons[s.Button] then return end
				self:SwitchButton(s.Button)
			end

			s.Paint = function(s, w, h)
				if self.ActiveButton == NM.Buttons[s.Button] then
					draw.RoundedBox(8, 0, 0, w, h, Color(255, 255, 255))
					draw.SimpleText(v.Name, FONT_SIDE_BUTTONS, w / 2, h / 2, Color(31, 31, 31), 1, 1)
				else
					draw.RoundedBox(8, 0, 0, w, h, Color(255, 255, 255))
					draw.RoundedBox(8, pX(1), pX(1), w - pX(2), h - pX(2), Color(31, 31, 31))
					draw.SimpleText(v.Name, FONT_SIDE_BUTTONS, w / 2, h / 2, Color(255, 255, 255), 1, 1)
				end
			end
		end, self)
	end

	local tab = next(NM.Buttons)
	self:SwitchButton(tab)
end

local box1, box2 = pX(167), pX(86)

function PANEL:Paint(w, h)
	local box1pos = w - box1 - pX(15)
	draw.RoundedBox(8, box1pos, pX(18), box1, box1, Color(47, 47, 47))
	draw.RoundedBox(8, box1pos + box2 / 2, pX(23), box2, box2, Color(31, 31, 31))
	local lp = LocalPlayer()
	local textx, texty = w - pX(197) / 2, pX(18) + box2
	local name = lp:GetName()

	if utf8.len(name) > 18 then
		name = utf8.sub(name, 1, 14) .. "..."
	end

	draw.SimpleText(name, FONT_PROFILE_NAME, textx, texty + pX(10), Color(255, 255, 255), 1, 3)
	local linew = pX(86)
	draw.RoundedBox(0, textx - linew / 2, texty + pX(28), linew, 1, Color(58, 58, 58))
	draw.SimpleText(lp:SteamID(), FONT_PROFILE_SID, textx, texty + pX(30), Color(131, 131, 131), 1, 3)
	draw.RoundedBox(0, textx - linew / 2, texty + pX(48), linew, 1, Color(58, 58, 58))
	draw.SimpleText("Задоначено: " .. IGS.SignPrice(IGS.TotalTransaction(lp)), FONT_TOPUPS_SUM, textx, texty + pX(56), Color(255, 255, 255), 1, 3)
end

function PANEL:SwitchButton(tab)
	self.ActiveButton = NM.Buttons[tab]
	self.OpenedButton = NM.OpenButton(tab, self, true)
end

vgui.Register("nm_profile", PANEL, "Panel")
--[[ Покупки ]]
PANEL = {}

function PANEL:Init()
	self.List = NM.CreateUI("nm_listview", self)
	self.PanelList = NM.CreateUI("DPanel", self)
	self.LastTransactions = {}

	local drw = function(txt, x, y)
		draw.SimpleText(txt, FONT_TABLE_COLUMN, x, y, Color(105, 105, 105))
	end

	self.PanelList.Paint = function(s, w, h)
		draw.RoundedBoxEx(8, 0, 0, pX(703), pX(34), Color(31, 31, 31), true, true)
		drw("Сервер", pX(30), pX(10))
		drw("Предмет", pX(185), pX(10))
		drw("Куплен", pX(355), pX(10))
		drw("Истечет", pX(455), pX(10))
		drw("Сумма", pX(555), pX(10))
		drw("Баланс", pX(635), pX(10))
		draw.RoundedBoxEx(8, 0, h - pX(17), pX(703), pX(17), Color(31, 31, 31), false, false, true, true)
	end

	self.PanelList:SetMouseInputEnabled(false)

	self.List.Paint = function(s, w, h)
		draw.RoundedBox(8, 0, 0, w, h, Color(31, 31, 31))
	end

	self.List:AddSpacer(""):SetTall(pX(37))

	self.List.scrollBar.Paint = function(s, w, h)
		draw.RoundedBox(0, 0, s.scrollButton.y, 2, s.height, Color(255, 255, 255))
	end

	local mybal = LocalPlayer():IGSFunds()

	IGS.GetMyTransactions(function(dat)
		if not IsValid(self.List) then return end

		for i, v in ipairs(dat) do
			v.note = v.note or "-"

			local function name_or_uid(sUid)
				local ITEM = IGS.GetItemByUID(sUid)

				return ITEM.isnull and sUid or ITEM:Name()
			end

			if i == #dat then
				self.List:AddSpacer(""):SetTall(pX(20))
			end

			if v.note:StartWith("A: ") or v.note:StartWith("C: ") then
				self.LastTransactions[#self.LastTransactions + 1] = v
				continue
			end

			if not v.note:StartWith("P: ") then continue end
			mybal = mybal - v.sum
			local sv_name = IGS.ServerName(v.server)
			local ITEM = IGS.GetItemByUID(name_or_uid(v.note:sub(4)))
			local sName = ITEM.isnull and v.note:sub(4) or ITEM:Name()
			panel = NM.CreateUI("DPanel")
			panel:SetPos(0, pX(22) * i)
			panel:SetSize(pX(725), pX(20))

			local drw = function(txt, x, y)
				draw.SimpleText(txt, FONT_TABLE_ROW, x, y, color_white, 1)
			end

			panel.Paint = function(s, w, h)
				drw(sv_name, pX(52), 0)
				drw(sName, pX(218), 0)
				drw(IGS.TimestampToDate(v.date) or "Никогда", pX(380), 0)
				drw(ITEM.termin ~= 0 and IGS.TimestampToDate(v.date + ITEM.termin * 86400) or "Никогда", pX(480), 0)
				drw(IGS.SignPrice(v.sum), pX(576), 0)
				drw(IGS.SignPrice(mybal), pX(660), 0)
			end

			self.List:AddItem(panel)
		end
	end)
end

function PANEL:PerformLayout()
	self.List:SetSize(pX(725), pX(244))
	self.List:SetPos(pX(28), pX(63))
	self.PanelList:SetSize(pX(725), pX(244))
	self.PanelList:SetPos(pX(28), pX(63))
end

function PANEL:Paint(w, h)
	draw.SimpleText("Последние покупки", FONT_IGS_CAT, pX(29), pX(36), Color(255, 255, 255), 0, 1)
	draw.RoundedBox(0, 0, h - pX(150), w, 1, Color(58, 58, 58))
	draw.SimpleText("Ваши последние пополнения", FONT_IGS_CAT, pX(29), h - pX(125), Color(255, 255, 255), 0, 1)

	if self.LastTransactions[1] then
		for k = 1, #self.LastTransactions do
			local v = self.LastTransactions[k]
			local x = pX(29) + ((k - 1) * pX(188))
			draw.RoundedBox(8, x, h - pX(100), pX(160), pX(70), Color(31, 31, 31))
			draw.RoundedBox(0, x + pX(28), h - pX(64), pX(100), pX(1), Color(49, 49, 49))
			draw.SimpleText(IGS.TimestampToDate(v.date), FONT_LAST_TOPUP_DATE, x + pX(80), h - pX(80), Color(255, 255, 255), 1, 1)
			draw.SimpleText(IGS.SignPrice(v.sum), FONT_LAST_TOPUP_SUM, x + pX(80), h - pX(48), Color(255, 255, 255), 1, 1)
		end
	else
		draw.SimpleText("Вы еще не пополняли счет, или делали это давно!", FONT_IGS_CAT, w / 2, h - pX(70), Color(105, 105, 105), 1, 1)
	end
end

vgui.Register("nm_profile_purchases", PANEL, "Panel")
--[[ Пополнение баланса ]]
PANEL = {}

local function niceSum(i, iFallback)
	return math.Truncate(tonumber(i) or iFallback, 2)
end

function PANEL:Init()
	self.Purchase = NM.CreateUI("DButton", function(s)
		s:SetText("")
		s.Text = "Пополнить баланс на ? руб"
		s:SetDisabled(true)
		s:SetSize(pX(277), pX(43))
		s:SetPos(pX(29), pX(236))

		s.DoClick = function()
			local want_money = niceSum(self.EntrySum:GetValue())

			if not want_money then
				self.LogPanel:AddRecord("Указана некорректная сумма пополнения", false)

				return
			elseif want_money < IGS.GetMinCharge() then
				self.LogPanel:AddRecord("Минимальная сумма пополнения " .. PL_MONEY(IGS.GetMinCharge()), false)

				return
			end

			self.LogPanel:AddRecord("Запрос цифровой подписи запроса от сервера...")

			IGS.GetPaymentURL(want_money, function(url)
				IGS.OpenURL(url, "Процедура пополнения счета")
				if not IsValid(self) then return end
				self.LogPanel:AddRecord("Подпись получена. начинаем процесс оплаты")

				timer.Simple(.7, function()
					self.LogPanel:AddRecord("Счет пополнится моментально или после перезахода")
				end)
			end)
		end

		s.Paint = function(s, w, h)
			draw.RoundedBox(4, 0, 0, w, h, s:GetDisabled() and Color(105, 105, 105) or Color(255, 255, 255))
			draw.SimpleText(s.Text, FONT_TOPUP_BUTTON, w / 2, h / 2, Color(0, 0, 0), 1, 1)
		end
	end, self)

	NM.CreateUI("DButton", function(s)
		s:SetText("")
		s:SetSize(pX(43), pX(43))
		s:SetPos(pX(318), pX(236))

		s.DoClick = function()
			IGS.WIN.ActivateCoupon()
		end

		local matsize = pX(22)

		s.Paint = function(s, w, h)
			draw.RoundedBox(4, 0, 0, w, h, Color(255, 255, 255))
			draw.RoundedBox(4, pX(1), pX(1), w - pX(2), h - pX(2), Color(47, 47, 47))
			surface.SetDrawColor(255, 255, 255, 255)
			surface.SetMaterial(coupon_mat)
			surface.DrawTexturedRect(w / 2 - matsize / 2, h / 2 - matsize / 2, matsize, matsize)
		end
	end, self)

	self.EntrySum = NM.CreateUI("DTextEntry", function(s)
		s:SetSize(pX(332), pX(43))
		s:SetPos(pX(29), pX(185))
		s:SetNumeric(true)

		s.Paint = function(s, w, h)
			draw.RoundedBox(4, 0, 0, w, h, Color(255, 255, 255))
			draw.RoundedBox(4, pX(1), pX(1), w - pX(2), h - pX(2), Color(47, 47, 47))
			draw.SimpleText(s:GetValue() == "" and "Сумма доната" or s:GetValue(), FONT_TOPUP_AMOUNT, pX(20), h / 2, s:GetValue() == "" and Color(140, 140, 140) or Color(255, 255, 255), 0, 1)
		end

		s.Think = function(s)
			local rub = tonumber(s:GetValue())
			self.Purchase.Text = "Пополнить баланс на " .. (rub and PL_MONEY(rub) or "?")
			self.Purchase:SetDisabled(not rub)
		end
	end, self)

	self.LogPanel = NM.CreateUI("nm_listview", function(log)
		log:SetSize(pX(330), pX(138))
		log:SetPos(pX(419), pX(170))
		log.Paint = function(s, w, h) end

		function log:AddRecord(text, pay)
			local col = (pay == true and IGS.col.LOG_SUCCESS) or (pay == false and IGS.col.LOG_ERROR) or IGS.col.LOG_NORMAL
			text = "> " .. os.date("%H:%M:%S") .. "\n" .. text
			local y = pX(2)

			for i, line in ipairs(string.Wrap(FONT_LOG_TEXT, text, log:GetWide())) do
				log:AddItem(NM.CreateUI("DLabel", function(l)
					l:SetPos(0, y)
					l:SetText(line)
					l:SetFont(FONT_LOG_TEXT)
					l:SizeToContents()
					l:SetTextColor(i == 1 and IGS.col.HIGHLIGHTING or col)
					y = y + l:GetTall()
				end, log))
			end

			log:ScrollTo(log:GetCanvas():GetTall())
		end
	end, self)

	local function log(delay, text, status)
		timer.Simple(delay, function()
			if not IsValid(self.LogPanel) then return end
			self.LogPanel:AddRecord(text, status)
		end)
	end

	log(0, "Открыт диалог пополнения счета", nil)
	log(math.random(3), "Соединение установлено!", true)
	log(math.random(20, 40), "Деньги будут зачислены мгновенно и автоматически", nil)
	self.LastTransactions = {}

	IGS.GetMyTransactions(function(dat)
		for i, v in ipairs(dat) do
			v.note = v.note or "-"

			if v.note:StartWith("A: ") or v.note:StartWith("C: ") then
				self.LastTransactions[#self.LastTransactions + 1] = v
				continue
			end
		end
	end)
end

function PANEL:Paint(w, h)
	draw.RoundedBox(8, pX(29), pX(13), w - pX(58), pX(80), Color(31, 31, 31))
	local heartsize = pX(27)
	surface.SetDrawColor(255, 255, 255, 255)
	surface.SetMaterial(heart_mat)
	surface.DrawTexturedRect(pX(36), pX(24), heartsize, heartsize)
	local txt = string.Wrap(FONT_THANKS, "		  На эти средства мы сможем оплатить работу разработчиков и рекламу для дальнейшего развития проекта", w - pX(58) - pX(11))

	for k, v in ipairs(txt) do
		draw.SimpleText(v, FONT_THANKS, pX(58) - pX(22), pX(25) + pX(25 * (k - 1)), Color(255, 255, 255))
	end

	draw.SimpleText("Пополнение баланса", FONT_IGS_CAT, pX(29), pX(145), Color(255, 255, 255), 0, 1)
	draw.RoundedBox(0, w / 2, h / 2 - pX(90), 1, pX(160), Color(58, 58, 58))
	draw.SimpleText("Лог операций", FONT_IGS_CAT, pX(419), pX(145), Color(255, 255, 255), 0, 1)
	draw.RoundedBox(0, 0, h - pX(150), w, 1, Color(58, 58, 58))
	draw.SimpleText("Ваши последние пополнения", FONT_IGS_CAT, pX(29), h - pX(125), Color(255, 255, 255), 0, 1)

	if self.LastTransactions[1] then
		for k = 1, #self.LastTransactions do
			local v = self.LastTransactions[k]
			local x = pX(29) + ((k - 1) * pX(188))
			draw.RoundedBox(8, x, h - pX(100), pX(160), pX(70), Color(31, 31, 31))
			draw.RoundedBox(0, x + pX(28), h - pX(64), pX(100), pX(1), Color(49, 49, 49))
			draw.SimpleText(IGS.TimestampToDate(v.date, true), FONT_LAST_TOPUP_DATE, x + pX(80), h - pX(80), Color(255, 255, 255), 1, 1)
			draw.SimpleText(IGS.SignPrice(v.sum), FONT_LAST_TOPUP_SUM, x + pX(80), h - pX(48), Color(255, 255, 255), 1, 1)
		end
	else
		draw.SimpleText("Вы еще не пополняли счет, или делали это давно!", FONT_IGS_CAT, w / 2, h - pX(70), Color(105, 105, 105), 1, 1)
	end
end

vgui.Register("nm_profile_donate", PANEL, "Panel")
--[[ Инвентарь ]]
PANEL = {}

function PANEL:Init()
	local item = self.Item

	local function clearframe()
		local frame = self.MainFrame

		if IsValid(frame.OpenedItem) then
			frame.OpenedItem:Remove()
			frame.OpenedItemInfo:Remove()
			frame.OpenedItemInfo.Scroll:Remove()
		end
	end

	self:SetText("")
	self.ModelIcon = NM.CreateUI("DModelPanel", self)
	self.ActivationButton = NM.CreateUI("DButton", self)
	self.DropButton = NM.CreateUI("DButton", self)

	self.ActivationButton.DoClick = function(s)
		clearframe()

		IGS.ProcessActivate(self.ItemInv.id, function(ok)
			if not ok then return end
			self:Remove()
		end)
	end

	self.DropButton.DoClick = function(s)
		clearframe()

		IGS.DropItem(self.ItemInv.id, function()
			self:Remove()
		end)
	end
end

function PANEL:PerformLayout()
	local item = IGS.GetItem(self.Item)
	self.ActivationButton:SetPos(pX(600), pX(15))
	self.ActivationButton:SetSize(pX(140), pX(40))
	self.ActivationButton:SetText("")

	self.ActivationButton.Paint = function(s, w, h)
		draw.RoundedBox(8, 0, 0, w, h, self.MainFrame.ActiveItem == self.Item and Color(223, 223, 223) or Color(68, 68, 68))
		draw.RoundedBox(8, 1, 1, w - 2, h - 2, Color(55, 55, 55))
		draw.SimpleText("Активировать", FONT_INVENTORY_ACTIVATE, w / 2, h / 2, color_white, 1, 1)
	end

	self.DropButton:SetPos(pX(600), pX(60))
	self.DropButton:SetSize(pX(140), pX(20))
	self.DropButton:SetText("")

	self.DropButton.Paint = function(s, w, h)
		draw.SimpleText("Бросить на пол", FONT_INVENTORY_DROP, w / 2, h / 2, Color(105, 105, 105), 1, 1)
	end

	local iconwh = pX(70)
	self.ModelIcon:SetPos(pX(20), self:GetTall() / 2 - iconwh / 2)
	self.ModelIcon:SetSize(iconwh, iconwh)
end

function PANEL:Paint(w, h)
	draw.RoundedBox(8, pX(5), pX(5), w - pX(10), h - pX(10), Color(68, 68, 68))
	draw.RoundedBox(8, 1 + pX(5), 1 + pX(5), w - pX(10) - 2, h - pX(10) - 2, Color(55, 55, 55))
	draw.RoundedBox(8, pX(15), h / 2 - pX(40), pX(80), pX(80), Color(47, 47, 47))
	local item = IGS.GetItem(self.Item)
	draw.SimpleText(item.name, FONT_INVENTORY_NAME, pX(110), pX(50), item.highlight or Color(255, 255, 255), 0, 4)
	draw.SimpleText("Действует " .. IGS.TermToStr(item:Term()), FONT_INVENTORY_TERM, pX(110), pX(70), Color(105, 105, 105), 0, 4)

	if item.icon and not item.icon.isModel then
		surface.SetDrawColor(255, 255, 255, 255)
		surface.SetMaterial(texture.Get(item.uid) or close_mat)
		local iconwh = pX(70)
		surface.DrawTexturedRect(pX(20), h / 2 - iconwh / 2, iconwh, iconwh)
	end
end

function PANEL:SetInfo(inv, uid, frame)
	self.Item = uid
	self.ItemInv = inv
	self.MainFrame = frame

	self.DoClick = function()
		frame:OpenItem(uid)
	end

	local item = IGS.GetItem(self.Item)

	self.ModelIcon.DoClick = function()
		frame:OpenItem(uid)
	end

	if item.icon and not item.icon.isModel then
		texture.Create(item.uid):Download(item.icon.icon)
		self.ModelIcon:SetVisible(false)
	elseif item.icon and item.icon.isModel then
		self.ModelIcon:SetVisible(true)
		self.ModelIcon:SetModel(item.icon.icon)
		local mn, mx = self.ModelIcon.Entity:GetRenderBounds()
		local size = 0
		size = math.max(size, math.abs(mn.x) + math.abs(mx.x))
		size = math.max(size, math.abs(mn.y) + math.abs(mx.y))
		size = math.max(size, math.abs(mn.z) + math.abs(mx.z))
		self.ModelIcon:SetFOV(30)
		self.ModelIcon:SetCamPos(Vector(size, size, size))
		self.ModelIcon:SetLookAt((mn + mx) * 0.5)
	end
end

vgui.Register("nm_inventory_button", PANEL, "DButton")
PANEL = {}

function PANEL:Init()
	self.Paint = function()
		if not IsValid(self.OpenedItem) then
			draw.SimpleText("Выберите предмет!", FONT_CHOOSE_ITEM, pX(877), pX(20), color_white, 1, 1)
		end
	end

	local btn
	self.Cats = {}
	self.List = NM.CreateUI("nm_listview", self)
	self.List.Paint = function(s, w, h)
		if not IsValid(self.List:GetCanvas():GetChild(0)) then
			draw.SimpleText("Инвентарь пуст!", FONT_INVENTORY_NONE, w / 2, h / 2, Color(105, 105, 105), 1, 1)
		end
	end

	IGS.GetInventory(function(items)
		for k, v in pairs(items) do
			btn = NM.CreateUI("nm_inventory_button")
			btn:SetSize(0, pX(100))
			btn:SetInfo(v, v.item.uid, self)
			self.List:AddItem(btn)
		end
	end)
end

function PANEL:PerformLayout()
	self.List:SetPos(0, 0)
	self.List:SetSize(self:GetWide() - pX(197), self:GetTall())
end

function PANEL:OpenItem(uid)
	if self.ActiveItem == uid then return end
	self.ActiveItem = uid

	if IsValid(self.OpenedItem) then
		self.OpenedItem:Remove()
		self.OpenedItemInfo:Remove()
		self.OpenedItemInfo.Scroll:Remove()
	end

	self.OpenedItem = NM.CreateUI("nm_shop_button", self)
	self.OpenedItem:SetInfo(uid, self)
	self.OpenedItem:SetPos(pX(978) - pX(14) - btnwh, pX(14))
	self.OpenedItem:SetSize(btnwh, btnwh)
	self.OpenedItem.ButtonBuy:SetVisible(false)
	local item = IGS.GetItem(uid)
	self:SetToolTip(item.name)

	self.OpenedItem.Paint = function(s, w, h)
		draw.RoundedBox(8, 0, 0, w, h, Color(68, 68, 68))
		draw.RoundedBox(8, 1, 1, w - 2, h - 2, Color(55, 55, 55))
		local name = item.name

		if utf8.len(name) > 16 then
			name = utf8.sub(name, 0, 14) .. "..."
		end

		draw.SimpleText(name, FONT_ITEM_NAME, pX(16), h - pX(60), item.highlight or Color(255, 255, 255), 0, 4)
		draw.SimpleText(NM.FancyTerm(item:Term()), FONT_ITEM_SUB, pX(16), h - pX(45), Color(105, 105, 105), 0, 4)

		if item.discounted_from then
			tw, th = draw.SimpleText(IGS.SignPrice(item.discounted_from), FONT_ITEM_PRICE_OLD, pX(16), h - pX(30), Color(105, 105, 105), 0, 4)
			local liney = h - pX(34)
			surface.SetDrawColor(255, 255, 255, 255)
			surface.DrawLine(pX(16), liney - th * .5, pX(16) + tw, liney)
		end

		draw.SimpleText(IGS.SignPrice(item.price), FONT_ITEM_PRICE, pX(16), h - pX(16), Color(255, 255, 255), 0, 4)

		if item.icon and not item.icon.isModel then
			surface.SetDrawColor(255, 255, 255, 255)
			surface.SetMaterial(texture.Get(item.uid) or close_mat)
			local iconwh = pX(80)
			surface.DrawTexturedRect(w / 2 - iconwh / 2, pX(6), iconwh, iconwh)
			surface.SetDrawColor(255, 255, 255, 180)
			surface.SetMaterial(grad_mat)
			surface.DrawTexturedRect(pX(1), pX(12), w - pX(2), iconwh)
		end
	end

	self.OpenedItemInfo = NM.CreateUI("DPanel", self)
	self.OpenedItemInfo:SetText("")
	local oifw, oifh = pX(197), pX(280)
	self.OpenedItemInfo:SetPos(pX(978) - oifw, pX(530) - pX(54) - oifh)
	self.OpenedItemInfo:SetSize(oifw, oifh)

	self.OpenedItemInfo.Paint = function(s, w, h)
		draw.RoundedBox(0, 0, 1, w, 1, Color(58, 58, 58))
		draw.SimpleText("Описание", FONT_ITEM_DESC_TITLE, pX(14), pX(14), Color(134, 134, 134))
	end

	self.OpenedItemInfo.Scroll = NM.CreateUI("nm_listview", self)
	self.OpenedItemInfo.Scroll:SetPos(pX(978) - oifw + pX(14), pX(530) - pX(10) - oifh)
	self.OpenedItemInfo.Scroll:SetSize(oifw - pX(28), oifh - pX(60))
	self.OpenedItemInfo.Scroll.Paint = function() end
	local txt = string.Wrap(FONT_ITEM_DESC, item.description, self.OpenedItemInfo.Scroll:GetWide())

	for k, v in ipairs(txt) do
		local lbl = NM.CreateUI("DLabel", function(s, p)
			s:SetText(v)
			s:SetFont(FONT_ITEM_DESC)
			s:SizeToContents()
		end)

		self.OpenedItemInfo.Scroll:AddItem(lbl)
	end
end

vgui.Register("nm_inventory", PANEL, "Panel")

concommand.Add("donate", function()
	NM.Menu()
end)

concommand.Add("donate1", function()
	IGS.UI()
end)