-- Перестань ебаться в глаза и хукать сборку, сделай сам или купи у ｓｕｇｒａａｌ. ｌｕｖ ｓｕｐ#8475
local a = {}
local material_vip = Material('sup/gui/generic/vip.png', 'smooth')
local color_vip = ui.col.Gold:Copy()
color_vip.a = 125

function a:Init()
    self.BaseClass.Init(self)
    self:SetHoverText('Купить')
end

function a:PaintOver(b, c)
    if self.Count then
        draw.SimpleText('x' .. self.Count, self.Font, b - 5, c - 10, ui.col.White, TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER)
    end

    if self.LimitName and self.Limit then
        local d = LocalPlayer():GetCount(self.LimitName)
        draw.SimpleText(d .. '/' .. self.Limit, self.Font, b - 5, c - 10, ui.col.White, TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER)

        if d >= self.Limit then
            self:SetColor(ui.col.DarkRed)
            self:DrawHoverText('Limit Reached!', b, c)
            draw.RoundedBox(5, 0, 0, b, c, ui.col.Background)

            return
        end
    end

    if self.Price and not LocalPlayer():CanAfford(self.Price) then
        self:SetColor(ui.col.DarkRed)
        self:DrawHoverText('Cannot Afford!', b, c)
        draw.RoundedBox(5, 0, 0, b, c, ui.col.Background)
    else
        self.BaseClass.PaintOver(self, b, c)
    end
end            


function a:SetTitle(e)
    self:SetTopText(e)
end

function a:SetPrice(f)
    self.Price = f
    self:SetBottomText(rp.FormatMoney(f))
end

function a:SetLimit(g, h)
    self.LimitName = g
    self.Limit = h
end


function a:SetCount(d)
    self.Count = d
end

vgui.Register('rp_shopbutton', a, 'rp_modelbutton')
PANEL = {}

function PANEL:PerformLayout(w, h)
	local w, h = w/6 - 1, 100
	local x, y = 0, 0

	local c = 1
	for k, v in ipairs(self:GetChildren()) do
		if (c > 6) then
			x = 0
			y = y + h + 1
			c = 1
		end

		v:SetPos(x, y)
		v:SetSize(w, h)

		x = x + w + 1
		c = c + 1
	end

	self:SetTall(y + h)
end

function PANEL:AddItem(model, title, price, doClick, vip)
    local btn = ui.Create('rp_modelbutton', self)
    btn:SetModel(model)
    btn:SetTopText(title)
    btn:SetBottomText(rp.FormatMoney(price))
    btn:SetHoverText('Купить')
    if vip and not LocalPlayer():IsVIP() then
        btn:SetColor(ui.col.DarkRed)
        btn.PaintOver = function(s, w, h)
            draw.RoundedBox(5, 0, 0, w, h, ui.col.Background)
            draw.SimpleText('Требуется VIP!', 'ui.18', w * 0.5, h * 0.5, ui.col.Gold, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
        end
    elseif (not LocalPlayer():CanAfford(price)) then
        btn:SetColor(ui.col.DarkRed)
        btn.PaintOver = function(s, w, h)
            draw.RoundedBox(5, 0, 0, w, h, ui.col.Background)
            draw.SimpleText('Недостаточно Средств!', 'ui.18', w * 0.5, h * 0.5, ui.col.White, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
        end
    end
    btn.DoClick = doClick
end

vgui.Register('rp_shopcatagory', PANEL, 'Panel')


PANEL = {}

function PANEL:Init()
	local cat

	self.Cats = {}

	self.List = ui.Create('ui_listview', self)
	self.List:SetSpacing(1)
	self.List.Paint = function() end

	self.List:AddSpacer('Боеприпасы'):SetTall(ui.SpacerHeight)
	cat = ui.Create('rp_shopcatagory')
	local ammos = table.Copy(rp.ammoTypes)
	table.SortByMember(ammos, 'price', true)
	for k, v in ipairs(ammos) do
		cat:AddItem(v.model, v.amountGiven .. 'x ' .. v.name, v.price, function()
			cmd.Run('buyammo', v.ammoType)
		end)
	end
	self.List:AddItem(cat)

	local shipments = table.Copy(rp.shipments)
	table.SortByMember(shipments, 'price', true)
	for k, v in ipairs(shipments) do
		if (v.allowed[LocalPlayer():Team()] == true) then
			if (not self.Cats['Shipments']) then
				self.List:AddSpacer('Коробки оружия'):SetTall(30)
				self.Cats['Shipments'] = true
				cat = ui.Create('rp_shopcatagory')
			end
			cat:AddItem(v.model, v.name, v.price, function()
				cmd.Run('buyshipment', v.name)
			end)
		end
	end
	self.List:AddItem(cat)


	local enities = {}
	local entsSorted = table.Copy(rp.entities)
	table.SortByMember(entsSorted, 'price', true)
	for k, v in ipairs(entsSorted) do
		if (v.allowed[LocalPlayer():Team()] == true) and ((not v.customCheck) or v.customCheck(LocalPlayer())) then
			enities[v.catagory] = enities[v.catagory] or {}
			table.insert(enities[v.catagory], v)
		end
	end

	for name, items in pairs(enities) do
        if (not self.Cats[name]) then
            self.List:AddSpacer(name):SetTall(ui.SpacerHeight)
            self.Cats[name] = true
            cat = ui.Create('rp_shopcatagory')
        end

        for k, v in ipairs(items) do
            cat:AddItem(v.model, v.name, v.pricesep or v.price, function()
                cmd.Run(v.cmd:sub(2))
            end, v.vip)
        end

        self.List:AddItem(cat)
    end

	self.List:AddItem(cat)
end

function PANEL:PerformLayout()
	self.List:SetPos(5,5)
	self.List:SetSize(self:GetWide() - 10, self:GetTall() - 10)
end

vgui.Register('rp_shoplist', PANEL, 'Panel')