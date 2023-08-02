AddCSLuaFile()

local BaseClass = baseclass.Get('baton_base')

if CLIENT then
	SWEP.PrintName = 'Разарестовать'
	SWEP.Instructions = 'Left click to unarrest\nRight click to switch to arrest'
	SWEP.Slot = 3
    SWEP.SlotPos = 2
end

SWEP.Spawnable = true
SWEP.Category = "RP"

-- SWEP.Color = Color(0, 255, 0, 255)

function SWEP:GetSwitcherSlot()
	return self.Owner:IsCP() and 3 or 4
end

function SWEP:Initialize()
	self:SetHoldType(self.HoldType)
	self._Reload.Sound = Sound('npc/combine_soldier/vo/coverme.wav')
end

function SWEP:PrimaryAttack()
	if not IsValid(self.Owner) then return end

	BaseClass.PrimaryAttack(self)

	if CLIENT then return end

	self.Owner:LagCompensation(true)
		local ent = self.Owner:GetEyeTrace().Entity
	self.Owner:LagCompensation(false)

	if (not IsValid(ent)) or (not ent:IsPlayer()) or (self.Owner:GetPos():Distance(ent:GetPos()) > self.HitDistance) or (not ent:IsArrested()) then return end
	if ent:InVehicle() then ent:ExitVehicle() end

	ent:UnArrest(self.Owner)
	rp.Notify(ent, NOTIFY_SUCCESS, term.Get('UnarrestBatonTarg'), self.Owner)
	rp.Notify(self.Owner, NOTIFY_SUCCESS, term.Get('UnarrestBatonOwn'), ent)
end