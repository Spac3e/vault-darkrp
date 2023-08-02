local PANEL = {}

function PANEL:Init()
	self:SetText('')
end

local color_canafford = ui.col.DarkGreen:Copy()
color_canafford.a = 100
local color_cannotafford = ui.col.Red:Copy()
color_cannotafford.a = 100
local color_maxed = ui.col.SUP:Copy()
color_maxed.a = 100
local color_disabled = ui.col.FlatBlack:Copy()
color_disabled.a = 100

function PANEL:Paint(w, h)
	draw.RoundedBox(5, 0, 0, w, h, ui.col.Background)

--	local totalLevels = #self.Prices
--	local nextLevel = LocalPlayer():GetSkillLevel(self.ID) + 1
--	local nextDesc = (self.Descriptions[nextLevel] and ('Уровень ' .. nextLevel .. '/' .. totalLevels .. ' - ' .. self.Descriptions[nextLevel]) or ('Уровень ' .. totalLevels .. ' - ' .. self.Descriptions[nextLevel - 1]))
	local nextPrice = self.Prices[nextLevel]

	local tTH = 0
	local tW, tH = draw.SimpleText(self.Name .. ' - ' .. self.Description, 'ui.22', w * 0.5, 5, ui.col.White, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)
	tTH = tTH + tH

	tTH = tTH + tH

	local barColor = nextPrice and (LocalPlayer():CanAffordKarma(nextPrice) and color_maxed or color_cannotafford) or color_canafford

	draw.Box(0, 10, 1, h- 20, barColor)
	draw.RoundedBoxEx(5, 0, 0, w, tTH + 10, barColor, true, true, false, false)

	tW, tH = draw.SimpleText(nextPrice and (string.Comma(nextPrice) .. ' Кармы') or 'Скил Вкачан', 'ui.22', w * 0.5, h - 5, ui.col.White, TEXT_ALIGN_CENTER, TEXT_ALIGN_BOTTOM)
	tTH = tTH + tH

	draw.Box(w - 1, 10, 1, h-  20, barColor)
	draw.RoundedBoxEx(5, 0, (h - tH) - 10, w, tH + 10, barColor, false, false, true, true)

	if self.Icon then
		surface.SetDrawColor(255, 255, 255, 255)
		surface.SetMaterial(self.Icon)

		local s = h - 35 - tTH
		surface.DrawTexturedRect((w - s) * 0.5, (h - s) * 0.5 + 10, s, s)
	end
end

function PANEL:PaintOver(w, h)
--	local nextPrice = self.Prices[LocalPlayer():GetSkillLevel(self.ID) + 1]
	if self:IsHovered() then
		draw.RoundedBox(5, 0, 0, w, h, ui.col.Hover)

	--	draw.SimpleText(LocalPlayer():CanAffordKarma(nextPrice) and (self.Confirm and 'Подтвердите' or 'Купить') or 'Недостаточно Средств!', 'ui.22', w * 0.5, h * 0.5, ui.col.White, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)

		draw.SimpleText('Включить Скил', 'ui.22', w * 0.5, h * 0.5, ui.col.White, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)

	end

	if (not self:IsHovered()) and self.Confirm then
		self.Confirm = nil
	end
end

function PANEL:DoClick()
--	if (not self.Prices[LocalPlayer():GetSkillLevel(self.ID) + 1]) then return end

	if self.Confirm then
	//	net.Start 'skill_channel'
	//	net.WriteTable({
	//	   ['method'] = 'buy',
	//		['key'] = k
	//	})
	//	net.SendToServer()
	end

	self.Confirm = (not self.Confirm)
end

function PANEL:SetSkill(skill)
	self.ID = skill.ID
	self.Name = skill.Name
	self.Description = skill.Description
	self.Descriptions = skill.Descriptions
	self.Prices = skill.Prices
	self.Icon = skill.Icon
end

vgui.Register('rp_skillbutton', PANEL, 'DButton')

PANEL = {}

function PANEL:Init()
	self.List = ui.Create('ui_listview', self)
	self.List.Paint = function() end
	self.List:SetSpacing(5)

	self.Buttons = {}

	for k, v in ipairs(rp.karma.Skills) do
		self.Buttons[#self.Buttons + 1] = ui.Create('rp_skillbutton', function(s)
			s:SetSkill(v)
		end, self)
	end

	local cont
	local i = 0
	for k, v in ipairs(self.Buttons) do
		if (i == 0) then
			cont = ui.Create('DPanel', function(s)
				s.Paint = function() end
			end)

			self.List:AddCustomRow(cont)
		end

		v:SetParent(cont)

		i = (i == 2) and 0 or (i + 1)
	end

end

function PANEL:PerformLayout(w, h)
	self.List:SetPos(5, 5)
	self.List:SetSize(w - 10, h - 10)

	for k, v in ipairs(self.List.Rows) do
		v:SetSize(self.List:GetWide(), 225)

		for i, child in ipairs(v:GetChildren()) do
			child:SetSize(v:GetWide() * 0.33 - 5, v:GetTall())
			child:SetPos((i - 1) * (child:GetWide() + 5), 0)
		end
	end
end

vgui.Register('rp_skillslist', PANEL, 'Panel')