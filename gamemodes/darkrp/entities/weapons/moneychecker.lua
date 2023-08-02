AddCSLuaFile()

SWEP.Base = 'weapon_rp_base'

if CLIENT then
	SWEP.PrintName 		= 'Проверка кошелька'
	SWEP.Slot 			= 3
	SWEP.SlotPos 		= 5
	SWEP.Instructions 	= ''
end

SWEP.ViewModel 		= Model('models/weapons/v_hands.mdl')
SWEP.ViewModelFOV 	= 62

SWEP.Spawnable = true
SWEP.Category = 'RP'
SWEP.Primary.Delay = 2

function SWEP:PrimaryAttack()
	self:SetNextPrimaryFire(CurTime() + self.Primary.Delay)

	if CLIENT then return end

	local ent = self.Owner:GetEyeTrace().Entity

	if (not IsValid(ent)) or (not ent:IsPlayer()) or (self.Owner:GetPos():Distance(ent:GetPos()) > self.HitDistance) then return end

	if ent:IsPlayer() then 
		net.Start('MoneyChecker')
		net.WriteUInt(ent:GetMoney(), 32)
		net.Send(self.Owner)
	end 
end

if SERVER then 
	util.AddNetworkString('MoneyChecker')
else
	net.Receive('MoneyChecker', function( len)	
		local Tb = net.ReadUInt(32)
		chat.AddText(rp.col.White, 'В кошельке:'..rp.FormatMoney(Tb))
	end)
end