local PANEL = {}

function PANEL:Init()
	self:SetModel(LocalPlayer():GetModel())
end

function PANEL:Paint(w, h)
	draw.RoundedBoxEx(5, 0, 0, w, h, ui.col.Background, true, false, true, false)

	if self:IsHovered() then
		draw.RoundedBoxEx(5, 0, 0, w, h, ui.col.Hover, true, false, true, false)
	end
end

function PANEL:PaintOver(w, h)
end

function PANEL:SetModel(model, skin, bodyGroups)
	self.BaseClass.SetModel(self, model, skin, bodyGroups)
	self:SetTooltip(nil)
	self.Model = model
	self.Skin = skin
	self.BodyGroups = bodyGroups
end

function PANEL:SetSize(w, h)
	self.BaseClass.SetSize(self, w, h)

	if (w > 64) and (h > 64) and self.Model then
		self:SetModel(self.Model, self.Skin, self.BodyGroups)
	end
end

vgui.Register('rp_modelicon', PANEL, 'SpawnIcon')