AddCSLuaFile()

SWEP.Base = 'weapon_rp_base'

if CLIENT then
	SWEP.PrintName = "Аптечка"
	SWEP.Slot = 3
	SWEP.Purpose = ""
	SWEP.Instructions = ""
end

SWEP.ViewModel = Model("models/weapons/c_medkit.mdl")
SWEP.WorldModel = Model("models/weapons/w_medkit.mdl")

SWEP.Spawnable = true
SWEP.Category = "RP"

SWEP.Primary.Delay = 0.08
SWEP.Secondary.Delay = 0.08

SWEP.Primary.Sound = Sound('hl1/fvox/boop.wav')

SWEP.HoldType = 'slam'

function SWEP:Initialize()
	self:SetHoldType(self.HoldType)

	self._Reload.Sound = {
		Sound('npc_citizen.health01'),
		Sound('npc_citizen.health02'),
		Sound('npc_citizen.health03'),
		Sound('npc_citizen.health04'),
		Sound('npc_citizen.health05')
	}
end

function SWEP:Think()
	if (self:GetHoldType() ~= self.HoldType) then
		self:SetHoldType(self.HoldType)
	end
end

function SWEP:HealPlayer(ent)
	local health = ent:Health()

	if (health >= 100) then return end

	ent:SetHealth(health + 1)
	self.Owner:EmitSound(self.Primary.Sound, 45, health)

	self:CalcKarma(ent:SteamID64())
end

function SWEP:RevivePlayer(ent)
	local prog = ent:GetHealProgress()

	ent.CurrentDoctor = self.Owner
	ent:SetHealProgress(prog + 1)
	self.Owner:EmitSound(self.Primary.Sound, 45, math.floor((prog / ent.HealPoints) * 100))

	local pl = ent:GetPlayer()
	if IsValid(pl) then
		self:CalcKarma(pl:SteamID64(), ent.HealPoints)
	end
end

function SWEP:CalcKarma(id, threshold)
	self.Owner.MedkitTimeout = self.Owner.MedkitTimeout or {}
	self.Owner.MedkitTimeout[id] = self.Owner.MedkitTimeout[id] or {
		Healed = 0,
		ExpireAt = CurTime() + 15,
		BlockUntil = 0
	}

	local inf = self.Owner.MedkitTimeout[id]

	if (inf.BlockUntil < CurTime()) then -- Only accumulate if not blocked
		if (inf.ExpireAt <= CurTime()) then -- If 15 seconds have passed since last heal, reset progress
			inf.Healed = 0
		end

		inf.Healed = inf.Healed + 1
		inf.ExpireAt = CurTime() + 15

		if (inf.Healed >= (threshold or 20)) then -- Karma reward
			inf.BlockUntil = CurTime() + 300 -- 5 minute cooldown for this player

			rp.Notify(self.Owner, NOTIFY_SUCCESS, term.Get('EarnedKarmaHealing'))
			self.Owner:AddKarma(10)

			rp.achievements.AddProgress(self.Owner, ACHIEVEMENT_HEALER, 1)
		end
	end
end

function SWEP:PrimaryAttack()
	if not IsValid(self.Owner) then return end

	self:SetHoldType('pistol')

	if CLIENT then return end

	self.Owner:LagCompensation(true)
		local ent = self.Owner:GetEyeTrace().Entity
	self.Owner:LagCompensation(false)

	if IsValid(ent) and (self.Owner:GetPos():Distance(ent:GetPos()) <= self.HitDistance) then
		if ent:IsPlayer() then
			self:HealPlayer(ent)
		elseif (ent:GetClass() == 'ent_ragdoll') and (ent:GetCanRevive()) then
			self:RevivePlayer(ent)
		end
	end
end


function SWEP:SecondaryAttack()
	if not IsValid(self.Owner) then return end
	self:SetNextSecondaryFire(CurTime() + self.Secondary.Delay)
	local health = SERVER and self.Owner:Health()
	if CLIENT or health >= 100 then return end
	self.Owner:SetHealth(health + 1)
	self.Owner:EmitSound(self.Primary.Sound, 125, health)
end

function SWEP:Reload()
	if not IsValid(self.Owner) or not self:CanReload() then return end

	self:SetNextReload(CurTime() + self._Reload.Delay)

	if CLIENT then return end

	self.Owner:EmitSound(self._Reload.Sound[math.random(1,5)], 50)
end
