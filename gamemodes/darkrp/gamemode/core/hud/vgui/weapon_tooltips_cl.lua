local PANEL = {}

function PANEL:Init()
	self.BaseClass.Init(self)
end

local icons = {
	LeftClick = 'gui/lmb.png',
	RightClick = 'gui/rmb.png',
	Info = 'icon16/information.png'
}

function PANEL:AddTooltip(key, text)
	local tip = self:Add 'rp_hud_iconbox'
	tip:SetMaterial(icons[key] or 'sup/hud/button.png')
	tip:SetColor(ui.col.FlatBlack)
	tip:Dock(TOP)
	tip:DockMargin(0, 0, 0, 5)
	function tip:GetString()
		return isfunction(text) and text() or text
	end
	tip:Update()

	if (not icons[key]) then
		function tip:PaintOver(w, h)
			draw.SimpleText(key, 'ui.19', 17, 17, ui.col.Black, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		end
	end
end

function PANEL:SetWeapon(wep)
	self.Weapon = wep

	-- Explicit ordering
	if wep.Tooltips.LeftClick then
		self:AddTooltip('LeftClick', wep.Tooltips.LeftClick)
	end

	if wep.Tooltips.RightClick then
		self:AddTooltip('RightClick', wep.Tooltips.RightClick)
	end

	if wep.Tooltips.R then
		self:AddTooltip('R', wep.Tooltips.R)
	end

	if wep.Tooltips.Info then
		self:AddTooltip('Info', wep.Tooltips.Info)
	end

	-- Everything else
	for k, v in pairs(wep.Tooltips) do
		if (icons[k] == nil) then
			self:AddTooltip(nil, v)
		end
	end

	local maxW, totalH = 0, 0
	for k, v in ipairs(self:GetChildren()) do
		if (not v:IsMarkedForDeletion()) then
			local w = v:GetWide()
			if (w > maxW) then
				maxW = w
			end

			totalH = totalH + v:GetTall() + 5
		end
	end

	self:SetSize(maxW, totalH)
	self:SetPos(ScrW() - maxW - 5, ScrH() - totalH)
end

function PANEL:Clear()
	self:SetSize(0, 0)

	for k, v in ipairs(self:GetChildren()) do
		v:Remove()
	end

	self.Weapon = nil
end

function PANEL:Update()
	self.BaseClass.Update(self)

	if IsValid(LocalPlayer()) and ((not LocalPlayer():Alive()) or (not IsValid(self.Weapon))) then
		self:Clear()
	end
end


vgui.Register('rp_hud_weapon_tooltips', PANEL, 'rp_hud_base')