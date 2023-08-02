AddCSLuaFile('cl_init.lua')
AddCSLuaFile('shared.lua')
include('shared.lua')

function SWEP:SecretPrimaryAttack()
	self.Owner:SetAnimation(ACT_VM_PRIMARYATTACK)

	self:SetNextPrimaryFire(CurTime() + 1)

	local tr = self.Owner:GetEyeTraceNoCursor()

	if (not tr.Entity:IsPlayer()) then return end
	if tr.Entity:InVehicle() then tr.Entity:ExitVehicle() end
	if tr.Entity:InSpawn() then return rp.Notify(self.Owner, NOTIFY_ERROR, 'На спавне запрещено использовать наручники.') end
	if tr.Entity:IsGov() then return rp.Notify(self:GetOwner(), NOTIFY_ERROR, 'Вы не можете надевать наручники на других копов.') end
	if tr.Entity:IsSOD() then return rp.Notify(self.Owner, NOTIFY_ERROR, 'На администратора нельзя надеть наручники.') end

	if (self:GetOwner():EyePos():Distance(tr.Entity:GetPos()) < 150) and (tr.Entity:GetNWBool('isHandcuffed') == false) then

		tr.Entity:SetNWBool('isHandcuffed', true)

		tr.Entity:ManipulateBoneAngles(tr.Entity:LookupBone('ValveBiped.Bip01_L_UpperArm'), Angle(20, 8.8, 0)) -- Left UpperArm
		tr.Entity:ManipulateBoneAngles(tr.Entity:LookupBone('ValveBiped.Bip01_L_Forearm'), Angle(15, 0, 0)) -- Left ForeArm
		tr.Entity:ManipulateBoneAngles(tr.Entity:LookupBone('ValveBiped.Bip01_L_Hand'), Angle(0, 0, 75)) -- Left Hand
		tr.Entity:ManipulateBoneAngles(tr.Entity:LookupBone('ValveBiped.Bip01_R_Forearm'), Angle(-15, 0, 0)) -- Right Forearm
		tr.Entity:ManipulateBoneAngles(tr.Entity:LookupBone('ValveBiped.Bip01_R_Hand'), Angle(0, 0, -75)) -- Right Hand
		tr.Entity:ManipulateBoneAngles(tr.Entity:LookupBone('ValveBiped.Bip01_R_UpperArm'), Angle(-20, 16.6, 0)) -- Right Upperarm

		tr.Entity:SetWalkSpeed(rp.cfg.WalkSpeed/2.5)
		tr.Entity:SetRunSpeed(rp.cfg.RunSpeed/2.5)

		tr.Entity.HandcuffedWeapons = {}
		tr.Entity.HandcuffedWeaponAmmo = {}
		tr.Entity.HandcuffedWeaponAmmoType = {}

		local weps = tr.Entity:GetWeapons()

		for i, v in ipairs(weps) do
			tr.Entity.HandcuffedWeapons[i] = {v:GetClass(),v.donate}
			tr.Entity.HandcuffedWeaponAmmo[v:GetPrimaryAmmoType()] = tr.Entity:GetAmmoCount( v:GetPrimaryAmmoType() )
		end

		tr.Entity:StripWeapons()
	end
end

function SWEP:SecretSecondaryAttack()
	local tr = self.Owner:GetEyeTraceNoCursor()

	if (not tr.Entity:IsPlayer()) then return end
	if tr.Entity:InVehicle() then tr.Entity:ExitVehicle() end

	if (self:GetOwner():EyePos():Distance(tr.Entity:GetPos()) < 250) and (tr.Entity:GetNWBool('isHandcuffed') == true) then

		tr.Entity:SetNWBool('isHandcuffed', false)

		self:GiveHandcuffWeaponsBack(tr.Entity)
		self:GiveHandcuffWeaponAmmoBack(tr.Entity)

		tr.Entity:SwitchToDefaultWeapon()

		tr.Entity:SetWalkSpeed(rp.cfg.WalkSpeed)
		tr.Entity:SetRunSpeed(rp.cfg.RunSpeed)

		tr.Entity:ManipulateBoneAngles(tr.Entity:LookupBone('ValveBiped.Bip01_L_UpperArm'), Angle(0, 0, 0)) -- Left UpperArm
		tr.Entity:ManipulateBoneAngles(tr.Entity:LookupBone('ValveBiped.Bip01_L_Forearm'), Angle(0, 0, 0)) -- Left ForeArm
		tr.Entity:ManipulateBoneAngles(tr.Entity:LookupBone('ValveBiped.Bip01_L_Hand'), Angle(0, 0, 0)) -- Left Hand
		tr.Entity:ManipulateBoneAngles(tr.Entity:LookupBone('ValveBiped.Bip01_R_Forearm'), Angle(0, 0, 0)) -- Right Forearm
		tr.Entity:ManipulateBoneAngles(tr.Entity:LookupBone('ValveBiped.Bip01_R_Hand'), Angle(0, 0, 0)) -- Right Hand
		tr.Entity:ManipulateBoneAngles(tr.Entity:LookupBone('ValveBiped.Bip01_R_UpperArm'), Angle(0, 0, 0)) -- Right Upperarm
	end
end

function SWEP:GiveHandcuffWeaponsBack(pl)
	for i, v in ipairs(pl.HandcuffedWeapons) do
		if v[2] == true then pl:Give(v[1], true).donate=true else pl:Give(v[1], true) end
	end
end

function SWEP:GiveHandcuffWeaponAmmoBack(pl)
	for k, v in pairs(pl.HandcuffedWeaponAmmo) do
		pl:SetAmmo(v, k)
	end
end