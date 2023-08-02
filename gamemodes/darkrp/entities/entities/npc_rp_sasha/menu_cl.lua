local PANEL = {}

function PANEL:Init()
	self.ItemsLabel = ui.Create('ui_button', self)
	self.ItemsLabel:SetText('Ваши Предметы')
	self.ItemsLabel:SetDisabled(true)
	self.ItemsLabel:Dock(TOP)
	self.ItemsLabel.Corners = {true, true, false, false}

	self.Items = ui.Create('ui_listview', self)
	self.Items:SetSpacing(2)
	self.Items:Dock(TOP)

	self.PricesLabel = ui.Create('ui_button', self)
	self.PricesLabel:SetText('Цены')
	self.PricesLabel:SetDisabled(true)
	self.PricesLabel:Dock(TOP)
	self.PricesLabel:DockMargin(0, 5, 0, 0)
	self.PricesLabel.Corners = {true, true, false, false}

	self.Prices = ui.Create('ui_listview', self)
	self.Prices:SetSpacing(2)
	self.Prices:Dock(TOP)
end

function PANEL:AddChildren()
	local items = {}
	local c = 0
	local cont
	for k, v in ipairs(rp.Weapons) do -- rp.entities.GetAllWeapons()
//		if rp.inv.Data[v.Entity] and (rp.inv.Data[v.Entity] > 0) then
//			items[#items + 1] = v
//		end

		if (c == 0) then
			cont = ui.Create('ui_panel', function(self)
				self.Paint = function() end
				self:SetTall(100)
			end)

			self.Prices:AddItem(cont)
		end

		local btn = ui.Create('rp_modelbutton', cont)
		btn:SetModel(v.Model)
		btn:SetTopText(v.Name)
		btn:SetBottomText(rp.FormatMoney(v.BuyPrice)) -- (rp.FormatMoney(self.NpcEntity:GetBuyPrice(v)))
		btn:SetWide(143)
		btn:Dock(LEFT)
		btn:DockMargin(0, 0, 2, 0)

		c = c == 3 and 0 or (c + 1)
	end

	if (#items == 0) then
		self.Items.PaintOver = function(s, w, h)
			draw.RoundedBoxEx(5, 0, 0, w, h, ui.col.Background, false, false, true, true)
			draw.SimpleText('', 'ui.24', w * 0.5, h * 0.5, ui.col.White, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		end
	else
		local c = 0
		local cont
		for k, v in ipairs(items) do
			if (c == 0) then
				cont = ui.Create('ui_panel', function(self)
					self.Paint = function() end
					self:SetTall(100)
				end)

				self.Items:AddItem(cont)
			end

			local function sellItem(count)
				net.Start 'rp.sasha.SellItem'
					net.WriteString(v.Entity)
					net.WriteUInt(count, 10)
					net.WriteEntity(self.NpcEntity)
				net.SendToServer()

				self:GetParent():Close()
			end

			local btn = ui.Create('rp_modelbutton', cont)
			btn:SetModel(v.Model)
			btn:SetTopText(v.Name)
			btn:SetBottomText(rp.FormatMoney(self.NpcEntity:GetBuyPrice(v)) .. ' - x' .. rp.pocket.Data[v.Entity])
			btn:SetHoverText('Sell')
			btn:SetWide(143)
			btn:Dock(LEFT)
			btn:DockMargin(0, 0, 2, 0)
			btn.DoClick = function(s)
				if (rp.pocket.Data[v.Entity] == 1) then
					sellItem(1)
				else
					local m = ui.DermaMenu(s)

					m:AddOption('Sell All', function()
						sellItem(rp.pocket.Data[v.Entity])
					end)

					m:AddOption('Sell Some', function()
						ui.NumberRequest('Sell ' .. v.Name, 'How many ' .. v.Name .. ' would you like to sell?', 1, 1, rp.pocket.Data[v.Entity], function(count)
							sellItem(count)
						end)
					end)

					m:Open()
				end

			end

			c = c == 3 and 0 or (c + 1)
		end
	end
end

function PANEL:PerformLayout(w, h)
	self.ItemsLabel:SetSize(w, ui.SpacerHeight)

	self.Items:SetSize(w, 100)

	self.PricesLabel:SetSize(w, ui.SpacerHeight)

	self.Prices:SetSize(w, 406)
end

function PANEL:Paint() end

vgui.Register('rp_npc_sasha_panel', PANEL, 'ui_panel')