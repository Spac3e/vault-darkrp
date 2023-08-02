local PANEL = {}



function PANEL:Init()

	self.BaseClass.Init(self)



	self.Title = ui.Create('DLabel', self)

	self.Title:SetFont('ui.18')

	self.Title:SetTextColor(ui.col.White)

	self.Title:Dock(TOP)

	self.Title:DockMargin(39, 5, 5, 10)

	--self.Title.PaintOver = function(s, w, h) draw.Box(0, 0, w, h, ui.col.Red) end



	self:SetSize(100, 34)

end



function PANEL:FindPos()

	return 5, 44

end



function PANEL:AddItem(pnl)

	pnl:SetParent(self)

	pnl:Dock(TOP)

	pnl:DockMargin(5, 0, 5, 5)

end



function PANEL:PerformLayout(w, h)

	self.Title:SizeToContentsX()

	self.Title:SetTall(24)

end



function PANEL:SetTitle(title)

	self.Title:SetText(title)

end



function PANEL:Update()

	self.BaseClass.Update(self)



	local contentW = 0

	local children = #table.Filter(self:GetChildren(), function(v)

		local w, h = v:GetContentSize()

		if (w > contentW) then

			contentW = w

		end

		return v:IsVisible()

	end)



	local titleW, titleH = self.Title:GetContentSize()



	local minW = (titleW + 44)

	local w = (children > 1) and math.Clamp(contentW + 10, minW, ScrW() * 0.125) or minW

	local h = (children > 1) and (children * 39) or 34



	h = vgui.CursorVisible() and h or math.min(h, 234) // 5 rows



	if (self:GetWide() ~= w) or (self:GetTall() ~= h) then

		self:SetSize(w, h)

	end



	self:SetPos(self:FindPos())

end



function PANEL:Paint(w, h)

	--draw.Blur(self)



	draw.RoundedBox(5, 0, 0, w, h, ui.col.Background)

	draw.RoundedBox(5, 0, 0, 34, 34, self.ColorPrimary)

	draw.RoundedBox(5, 0, 0, w, 34, self.ColorSecondary)



	surface.SetDrawColor(255, 255, 255)

	surface.SetMaterial(self.Material)

	surface.DrawTexturedRect(5, 5, 24, 24)

end



vgui.Register('rp_hud_box', PANEL, 'rp_hud_base')