local PANEL = {}

local ammoTypes = {
	pistol 	= true,
	smg1 	= true,
	rifle 	= true,
	buckshot = true
}

function PANEL:Init()
	self.BaseClass.Init(self)

	self.CurrentWeapon = self:Add('rp_hud_iconbox')
	self.CurrentWeapon:SetMaterial('sup/gui/generic/ammo_rifle.png')
	self.CurrentWeapon:SetColor(ui.col.FlatBlack)
	self.CurrentWeapon.ShouldDraw = self.ShouldDraw
	function self.CurrentWeapon:GetString()
		local wep = LocalPlayer():GetActiveWeapon()

		local ammoName = game.GetAmmoName(wep:GetPrimaryAmmoType()):lower()
		if (not self.AmmoName) or (self.AmmoName ~= ammoName) then
			self.AmmoName = ammoName
			self:SetMaterial(ammoTypes[ammoName] and ('sup/gui/generic/ammo_' .. ammoName .. '.png') or 'sup/gui/generic/ammo_rifle.png')
		end

		self.Clip1 = wep:Clip1()
		self.MaxClip1 = wep:GetMaxClip1()

		return self.Clip1 .. '/' .. self.MaxClip1
	end
	function self.CurrentWeapon:GetProgress()
		return self.Clip1 / self.MaxClip1
	end
	function self.CurrentWeapon:PaintOver(w, h)
		local r = ui.col.FlatBlack.r

		if self.Clip1 and self.MaxClip1 and (((self.Clip1/self.MaxClip1) < 0.175) or (self.Clip1 <= 2)) then
			local r = math.Clamp((math.sin(CurTime()) + 1) * 255, ui.col.FlatBlack.r, ui.col.DarkRed.r)
			self.ColorPrimary.r = r
			self.ColorSecondary.r = r
		else
			self.ColorPrimary.r = r
			self.ColorSecondary.r = r
		end
	end

	self.TotalAmmo = self:Add('rp_hud_iconbox')
	self.TotalAmmo:SetMaterial('sup/gui/generic/ammo_box.png')
	self.TotalAmmo:SetColor(ui.col.FlatBlack)
	self.TotalAmmo.ShouldDraw = self.ShouldDraw
	function self.TotalAmmo:GetString()
		local wep = LocalPlayer():GetActiveWeapon()

		return string.Comma(LocalPlayer():GetAmmoCount(wep:GetPrimaryAmmoType()))
	end

	self.FireMode = self:Add('rp_hud_iconbox')
	self.FireMode:SetMaterial('sup/gui/generic/mode.png')
	self.FireMode:SetColor(ui.col.FlatBlack)
	function self.FireMode:GetString()
		local wep = LocalPlayer():GetActiveWeapon()

		return wep.FireModeDisplay
	end
	function self.FireMode:ShouldDraw()
		local wep = LocalPlayer():GetActiveWeapon()

		return (wep.FireModeDisplay ~= nil)
	end


	self:SetSize(100, 78)
end

function PANEL:PerformLayout(w, h)
	self.CurrentWeapon:SetPos(0, 39)
	self.TotalAmmo:SetPos(self.CurrentWeapon.x + 5 + self.CurrentWeapon:GetWide(), 39)
	self.FireMode:SetPos(0, 0)
end

local blacklist = {
	weapon_physcannon = true,
	weapon_bugbait = true
}

function PANEL:ShouldDraw()
	local wep = LocalPlayer():GetActiveWeapon()

	return IsValid(wep) and (not blacklist[wep:GetClass()]) and (wep.DrawAmmo ~= false) and (wep:Clip1() > -1) and game.GetAmmoName(wep:GetPrimaryAmmoType())
end

function PANEL:Update()
	self.BaseClass.Update(self)

	self:SetWide(math.max(self.TotalAmmo:GetWide() + self.CurrentWeapon:GetWide() + 10, self.FireMode:GetWide()))
	self:SetPos(ScrW() - self:GetWide() - 5, ScrH() - self:GetTall() - 5)
end

function PANEL:Paint(w, h)
end

vgui.Register('rp_hud_ammo', PANEL, 'rp_hud_base')