local PANEL = {}

function PANEL:Init()
	self.NextThink = 0
	self.UpdateRate = 0.1

	self.ColorPrimary = ui.col.FlatBlack:Copy()
	self.ColorSecondary = self.ColorPrimary:Copy()
	self.ColorSecondary.a = 65

	hook('Think', self, function() -- We need to think while not visible
		local shouldDraw = (hook.Call('HUDShouldDraw', GAMEMODE, 'SUPHUD') ~= false) and self:ShouldDraw() or false

		local isshit = self:GetClassName() == 'rp_hud_textbox'

		if (self:IsVisible() ~= shouldDraw) then
			self:SetVisible(shouldDraw)
			self:InvalidateParent()
		end

		if shouldDraw and (self.NextThink <= CurTime()) then
			self:Update()

			self.NextThink = CurTime() + self.UpdateRate
		end
	end)

	self:SetMouseInputEnabled(false)
	self:SetKeyboardInputEnabled(false)
end

function PANEL:SetUpdateRate(rate)
	self.UpdateRate = rate
end

function PANEL:SetColor(color)
	self.ColorPrimary.r = color.r
	self.ColorPrimary.g = color.g
	self.ColorPrimary.b = color.b

	self.ColorSecondary.r = color.r
	self.ColorSecondary.g = color.g
	self.ColorSecondary.b = color.b
	self.ColorSecondary.a = 65
end

local materialCache = {}
function PANEL:SetMaterial(material)
	if materialCache[material] then
		self.Material = materialCache[material]
	else
		if isstring(material) then
			self.Material = Material(material, 'smooth')
		else
			self.Material = material
		end

		materialCache[material] = self.Material
	end
end

function PANEL:ShouldDraw()
	return true
end

function PANEL:SetHook(name, callback)
	hook(name, self, function(...)
		callback(...)

		self:Update()
	end)
end

function PANEL:Update()
	self:OnUpdate()
end

function PANEL:OnUpdate()
end

vgui.Register('rp_hud_base', PANEL, 'Panel')