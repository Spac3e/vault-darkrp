local PANEL = {}



function PANEL:Init()

	self.BaseClass.Init(self)



	self.Title = ui.Create('DLabel', self)

	self.Title:SetFont('ui.18')

	self.Title:SetTextColor(ui.col.White)

	self.Title:Dock(TOP)

	self.Title:DockMargin(39, 5, 5, 5)

	--self.Title.PaintOver = function(s, w, h) draw.Box(0, 0, w, h, ui.col.Red) end



	self.Label = ui.Create('DLabel', self)

	self.Label:SetWrap(true)

	self.Label:SetAutoStretchVertical(true)

	self.Label:SetFont('ui.16')

	self.Label:SetTextColor(ui.col.White)

	self.Label:Dock(TOP)

	self.Label:DockMargin(5, 5, 5, 5)

	--self.Label.PaintOver = function(s, w, h) draw.Box(0, 0, w, h, ui.col.Red) end



	self:SetSize(ScrW() * .175, 200)

end



function PANEL:FindPos()

	return 5, 44

end



function PANEL:GetString()

	return 'This is some text\nIt is not set for some reason\nThat is not good!\naaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaasssssssssssssssssssssssssssssaaaaaaaaaaa:('

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



	local value = self:GetString()



	if (self.Value == value) then

		return

	end



	local standardWidth = (ScrW() * .175) - 10

	local minWdith

	local wrappedValues = string.Wrap('ui.16', value, standardWidth)

	for k, v in ipairs(wrappedValues) do

		local w, h = surface.GetTextSize(v)

		if (not minWdith) or (w > minWdith) then

			minWdith = w

		end

	end



	self.Label:SetText(value)

	self.Label:SizeToContents()



	local titleW, titleH = self.Title:GetContentSize()

	self:SetSize(math.Clamp(minWdith, titleW + 34, standardWidth) + 10)

	self:SetPos(self:FindPos())



	self.Value = value

end



function PANEL:Think()



	local h = self.Label:GetTall() + 44

	if (self:GetTall() ~= h) then

		self:SetTall(h)

	end

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



vgui.Register('rp_hud_textbox', PANEL, 'rp_hud_base')
