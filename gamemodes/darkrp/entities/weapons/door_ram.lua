AddCSLuaFile()
SWEP.Base = 'weapon_rp_base'

if CLIENT then
	SWEP.PrintName = 'Таран'
	SWEP.Slot = 3
	SWEP.SlotPos = 1
	SWEP.Instructions = 'Left click to open doors and unfreeze props\nRight click to ready the ram'
	SWEP.Category = "RP"
	SWEP.Spawnable = true
end

SWEP.ViewModel = Model('models/weapons/c_rpg.mdl')
SWEP.WorldModel = Model('models/weapons/w_rocket_launcher.mdl')
SWEP.Primary.Sound = Sound('Canals.d1_canals_01a_wood_box_impact_hard3')
local Ironsights = false

local NewJump = 0
local NewRun = 180

function SWEP:Deploy()
	if not IsValid(self.Owner) then return end
end

function SWEP:Holster()
	self:OnRemove()
	return true
end

function SWEP:PrimaryAttack()
	if not IsValid(self.Owner) or CLIENT then return end
	self:SetNextPrimaryFire(CurTime() + 2.5)
	local tr = self.Owner:GetEyeTrace()
	local ent = tr.Entity
	if not IsValid(ent) or (self.Owner:EyePos():Distance(tr.HitPos) > self.HitDistance) then return end
	if ent:IsDoor() then
		local tar = ent:DoorGetOwner()
		local bool = false

		if tar and tar:IsWarranted() then
			bool = true 
		end 
		if ent:DoorGetCoOwners() then 
			for k, v in pairs(ent:DoorGetCoOwners()) do 
				if v:IsWarranted() then 
					bool = true 
				end 
			end 
		end 
		if ent:DoorGetCoOwners() == nil and GetDoorCategory(ent:GetDoorID()).Hotel  then 
			bool = true 
		end
		if GetDoorCategory(ent:GetDoorID()).AllowedTeams and GetDoorCategory(ent:GetDoorID()).AllowedTeams[TEAM_HOTEL] then 
			bool = true 
		end 
		
		if bool then 
			ent:Fire("unlock","",0)
            ent:Fire("Open","",0)
		else
			rp.Notify(self.Owner, NOTIFY_GENERIC, "Вам нужен ордер на обыск.")
			return
		end

	elseif (ent:GetClass() == 'prop_physics') then
		local tar = ent:CPPIGetOwner()
		
		if tar and tar:IsWarranted() and not ent.Faded and (ent.FadingDoor == true) then
			ent:Fade()
		else
			rp.Notify(self.Owner, NOTIFY_GENERIC, "Вам нужен ордер на обыск.")
			return
		end
	
	else
		return
	end

	self.Owner:SetAnimation(PLAYER_ATTACK1)
	self.Owner:EmitSound(self.Primary.Sound)
	self.Owner:ViewPunch(Angle(-10, math.random(-5, 5), 0))
end


function SWEP:SecondaryAttack()
	if not IsValid(self.Owner) or CLIENT then return end
	self:SetNextSecondaryFire(CurTime() + 2.5)
	local tr = self.Owner:GetEyeTrace()
	local ent = tr.Entity
	if not IsValid(ent) or (self.Owner:EyePos():Distance(tr.HitPos) > self.HitDistance) then return end
	if ent:IsDoor() then
		local tar = ent:DoorGetOwner()
		if tar and tar:IsWarranted() then
			ent:Fire("unlock","",0)
            ent:Fire("Open","",0)
		else
			rp.Notify(self.Owner, NOTIFY_GENERIC, "Вам нужен ордер на обыск.")
			return
		end

	elseif (ent:GetClass() == 'prop_physics') then
		local tar = ent:CPPIGetOwner()
		if tar and tar:IsWarranted() and not ent.Faded and (ent.FadingDoor == true) then
			ent:Fade()
		else
			rp.Notify(self.Owner, NOTIFY_GENERIC, "Вам нужен ордер на обыск.")
			return
		end
	
	else
		return
	end

	self.Owner:SetAnimation(PLAYER_ATTACK1)
	self.Owner:EmitSound(self.Primary.Sound)
	self.Owner:ViewPunch(Angle(-10, math.random(-5, 5), 0))
end