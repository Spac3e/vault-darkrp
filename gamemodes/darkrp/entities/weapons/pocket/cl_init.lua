include("pocket_controls.lua")
include("pocket_vgui.lua")
include("shared.lua")
SWEP.PrintName = "Инвентарь"
SWEP.Slot = 2
SWEP.SlotPos = 1
SWEP.DrawAmmo = false
SWEP.DrawCrosshair = false
SWEP.FrameVisible = false

function SWEP:PrimaryAttack()
	return
end

function SWEP:SecondaryAttack()
	rp.inv.EnableMenu();

	return
end

function SWEP:DrawHUD()
	if (IsValid(rp.inv.UI)) then return end

	surface.SetDrawColor(0, 0, 0, 255)
	surface.DrawRect(ScrW()/2, ScrH()/2 -3, 2, 8)
	surface.DrawRect(ScrW()/2 - 3, ScrH()/2, 8, 2)
end