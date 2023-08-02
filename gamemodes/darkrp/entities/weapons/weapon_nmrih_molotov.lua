AddCSLuaFile()

sound.Add({name = "Weapon_NMRiH_Molotov.Draw", 			channel = CHAN_ITEM, 	volume = 0.4, 	level = 75, 	pitch = {100,100}, 	sound = {"nmrih/player/weapon_draw_01.ogg","nmrih/player/weapon_draw_02.ogg","nmrih/player/weapon_draw_03.ogg","nmrih/player/weapon_draw_04.ogg","nmrih/player/weapon_draw_05.ogg"}})
sound.Add({name = "Weapon_NMRiH_Molotov.Shove", 		channel = CHAN_WEAPON, 	volume = 0.75, 	level = 100, 	pitch = {97,100}, 	sound = {"nmrih/player/shove_01.ogg","nmrih/player/shove_02.ogg","nmrih/player/shove_03.ogg","nmrih/player/shove_04.ogg","nmrih/player/shove_05.ogg" }})
sound.Add({name = "Weapon_NMRiH_Molotov.Ignite_Rag", 	channel = CHAN_WEAPON, 	volume = 1, 	level = 75, 	pitch = {100,100}, 	sound = "nmrih/weapons/firearms/exp_molotov/molotov_rag_ignite_01.ogg"})
sound.Add({name = "Weapon_NMRiH_Molotov.Rag_Loop", 		channel = CHAN_WEAPON, 	volume = 1, 	level = 75, 	pitch = {100,100}, 	sound = "nmrih/weapons/firearms/exp_molotov/molotov_rag_fire_loop_01.ogg"})
sound.Add({name = "Weapon_NMRiH_Molotov.Explode", 		channel = CHAN_WEAPON, 	volume = 1, 	level = 75, 	pitch = {100,100}, 	sound = "nmrih/weapons/firearms/exp_molotov/molotov_explode_01.ogg"})
sound.Add({name = "Weapon_NMRiH_Molotov.Fire_Loop", 	channel = CHAN_WEAPON, 	volume = 1, 	level = 75, 	pitch = {100,100}, 	sound = "nmrih/weapons/firearms/exp_molotov/molotov_fire_loop_01.ogg"})
sound.Add({name = "Weapon_NMRiH_Zippo.Open", 			channel = CHAN_AUTO, 	volume = 1, 	level = 75, 	pitch = {100,100}, 	sound = {"nmrih/weapons/tools/zippo/zippo_open_01.ogg","nmrih/weapons/tools/zippo/zippo_open_02.ogg" }})
sound.Add({name = "Weapon_NMRiH_Zippo.Close", 			channel = CHAN_AUTO, 	volume = 1, 	level = 75, 	pitch = {100,100}, 	sound = {"nmrih/weapons/tools/zippo/zippo_close_01.ogg", "nmrih/weapons/tools/zippo/zippo_close_02.ogg" }})
sound.Add({name = "Weapon_NMRiH_Zippo.Strike_Fail", 	channel = CHAN_AUTO, 	volume = 1, 	level = 75, 	pitch = {100,100}, 	sound = {"nmrih/weapons/tools/zippo/zippo_strike_fail_01.ogg", "nmrih/weapons/tools/zippo/zippo_strike_fail_02.ogg", "nmrih/weapons/tools/zippo/zippo_strike_fail_03.ogg"}})
sound.Add({name = "Weapon_NMRiH_Zippo.Strike_Success", 	channel = CHAN_AUTO, 	volume = 1, 	level = 75, 	pitch = {100,100}, 	sound = "nmrih/weapons/tools/zippo/zippo_strike_success_01.ogg"})

game.AddParticles("particles/nmrih_explosion_tnt.pcf")
game.AddParticles("particles/nmrih_explosions.pcf")
game.AddParticles("particles/nmrih_gasoline.pcf")

SWEP.Base					= "weapon_base"

SWEP.PrintName				= "Молотов"	
SWEP.ClassName				= "weapon_nmrih_molotov"			
SWEP.Author					= "Anya O'Quinn"
SWEP.Instructions			= "Left click to torch some shit."
SWEP.Category				= "RP"

SWEP.Spawnable				= true
SWEP.AdminOnly				= true

SWEP.Slot					= 3

SWEP.ViewModel				= Model("models/nmrih/weapons/exp_molotov/v_exp_molotov.mdl")
SWEP.WorldModel				= Model("models/nmrih/weapons/exp_molotov/w_exp_molotov.mdl")
SWEP.ViewModelFOV			= 50
SWEP.ViewModelFlip			= false
		
SWEP.DrawAmmo				= false
SWEP.DrawCrosshair			= false

SWEP.HoldType				= "grenade"

SWEP.Primary.Delay			= 0.75
SWEP.Primary.ClipSize 		= -1
SWEP.Primary.DefaultClip 	= 0
SWEP.Primary.Automatic 		= false
SWEP.Primary.Ammo 			= ''

SWEP.Secondary.ClipSize 	= -1
SWEP.Secondary.DefaultClip 	= 0
SWEP.Secondary.Automatic 	= false
SWEP.Secondary.Ammo 		= ''

SWEP.Throwing 				= false
SWEP.StartThrow 			= false
SWEP.ResetThrow 			= false
SWEP.ThrowVel 				= 1000
SWEP.NextThrow 				= CurTime()
SWEP.NextAnimation 			= CurTime()

PrecacheParticleSystem("nmrih_molotov_explosion")

function SWEP:Initialize()
	self:SetHoldType(self.HoldType)
end

function SWEP:Deploy()
	self.Idle = true

	self.StartThrow = false
	self.Throwing = false
	self.ResetThrow = false

	if not self.Throwing then

		if IsValid(self.Weapon) and IsValid(self.Owner) then
			self.Weapon:SendWeaponAnim(ACT_VM_DRAW)
			if IsValid(self.Owner:GetViewModel()) then
				self.Weapon:SetNextPrimaryFire(CurTime() + self.Owner:GetViewModel():SequenceDuration())
				self.Weapon:SetNextSecondaryFire(CurTime() + self.Owner:GetViewModel():SequenceDuration())
				self.NextThrow = CurTime() + self.Owner:GetViewModel():SequenceDuration()
				self.StartIdle = CurTime() + self.Owner:GetViewModel():SequenceDuration()
			end	
		end
		
	end
	
	return true		
end

function SWEP:Holster()
	self.StartThrow = false
	self.Throwing = false
	self.ResetThrow = false
	return true
end

function SWEP:CreateGrenade()
	if IsValid(self.Owner) and IsValid(self.Weapon) and SERVER then
		local ent = ents.Create("rj_molotov")
		if not ent then return end
		ent.Owner = self.Owner
		ent.Inflictor = self.Weapon
		ent:SetOwner(self.Owner)		
		local eyeang = self.Owner:GetAimVector():Angle()
		local right = eyeang:Right()
		local up = eyeang:Up()
		ent:SetPos(self.Owner:GetShootPos() + right * 6 + up * -2)
		ent:SetAngles(self.Owner:GetAngles())
		ent:SetPhysicsAttacker(self.Owner)
		ent:Spawn()
		
		local phys = ent:GetPhysicsObject()
		if IsValid(phys) then
			phys:SetVelocity(self.Owner:GetAimVector() * self.ThrowVel + (self.Owner:GetVelocity() * 0.5))
			phys:ApplyForceOffset(ent:GetUp() * math.random(-25,-50), ent:GetPos() + ent:GetRight() * math.random(-5,5))
		end		
	end	
end

local bobtime 	= 10
local bobscale 	= 0.0125
local xoffset 	= 0
local yoffset 	= 0

function SWEP:Think()
	if not IsValid(self.Owner) then return end

	if (self.Owner:KeyDown(IN_FORWARD) or self.Owner:KeyDown(IN_BACK) or self.Owner:KeyDown(IN_MOVELEFT) or self.Owner:KeyDown(IN_MOVERIGHT) or self.Owner:KeyDown(IN_BACK)) and not self.Owner:KeyDown(IN_JUMP) and self.Owner:IsOnGround() and not self.StartIdle and not self.StartThrow and not self.Throwing then
		self.Idle = false
		if self.Owner:KeyDown(IN_SPEED) and not self.Owner:KeyDown(IN_DUCK) then
			self.Walk = false
			if not self.Run then
				self.Weapon:SendWeaponAnim(ACT_VM_IDLE_DEPLOYED_1)
				self.Run = true
			end
			bobtime = self.Owner:GetRunSpeed() / 20
		else
			self.Run = false
			if not self.Walk then
				self.Weapon:SendWeaponAnim(ACT_WALK)
				self.Walk = true
			end
			bobtime = self.Owner:GetWalkSpeed() / 15
		end

		if (CLIENT) then
			local xoffset = math.sin(SysTime() * bobtime) * self.Owner:GetVelocity():Length() * bobscale / 100
			local yoffset = math.sin(2 * SysTime() * bobtime) * self.Owner:GetVelocity():Length() * bobscale / 400
			self.Owner:ViewPunch(Angle(xoffset,yoffset,0))
		end
	elseif (not self.Idle or (self.StartIdle and self.StartIdle < CurTime())) and not self.StartThrow and not self.Throwing then
		self.Weapon:SendWeaponAnim(ACT_VM_IDLE)
		self.Run = false
		self.Walk = false
		self.Idle = true
		self.StartIdle = nil	
	end
	
	if not self.StartIdle and not self.Throwing and not self.StartThrow and not self.Owner:KeyDown(IN_SPEED) and self.Owner:KeyDown(IN_ATTACK) then
		self.StartThrow = true
		self.Weapon:SendWeaponAnim(ACT_VM_PULLPIN)
		if IsValid(self.Owner:GetViewModel()) then
			self.NextThrow = CurTime() + self.Owner:GetViewModel():SequenceDuration()
			self.Weapon:SetNextPrimaryFire(CurTime() + self.Owner:GetViewModel():SequenceDuration())
			self.Weapon:SetNextSecondaryFire(CurTime() + self.Owner:GetViewModel():SequenceDuration())
		end
	end
	
	if self.StartThrow and not self.Owner:KeyDown(IN_ATTACK) and not self.Owner:KeyDown(IN_SPEED) and self.NextThrow < CurTime() then
		self.StartThrow = false
		self.Throwing = true
		self.Weapon:SendWeaponAnim(ACT_VM_THROW)
		self.Owner:SetAnimation(PLAYER_ATTACK1)		
		self:CreateGrenade(self.Owner, self.Weapon)
		self.NextAnimation = CurTime() + self.Primary.Delay
		self.ResetThrow = true

		if (SERVER) then
			self.Owner:StripWeapon("weapon_nmrih_molotov")
		end
	end
	
	if self.Throwing and self.ResetThrow and self.NextAnimation < CurTime() then
		self.Weapon:SendWeaponAnim(ACT_VM_DRAW)
		if IsValid(self.Owner:GetViewModel()) then
			self.NextThrow = CurTime() + self.Owner:GetViewModel():SequenceDuration()
			self.StartIdle = CurTime() + self.Owner:GetViewModel():SequenceDuration()
			self.Weapon:SetNextPrimaryFire(CurTime() + self.Owner:GetViewModel():SequenceDuration())
			self.Weapon:SetNextSecondaryFire(CurTime() + self.Owner:GetViewModel():SequenceDuration())
		end

		self.ResetThrow = false
		self.Throwing = false		
	end	
end

function SWEP:CanPrimaryAttack()
	return false
end

function SWEP:PrimaryAttack()
	return false
end

function SWEP:SecondaryAttack()
	return false
end

function SWEP:Reload()
	return false
end

function SWEP:ShouldDropOnDie()
	return false
end

local ENT = {}

ENT.PrintName = "Molotov"
ENT.Type = "anim"  
ENT.Base = "base_anim"

if CLIENT then
	function ENT:Draw()
		self:DrawModel()
	end
end

if SERVER then
	function ENT:Initialize()
		self:SetModel("models/nmrih/weapons/exp_molotov/w_exp_molotov.mdl")
		self:PhysicsInit(SOLID_VPHYSICS)
		self:SetMoveType(MOVETYPE_VPHYSICS)
		self:SetSolid(SOLID_VPHYSICS)
		self:SetCollisionGroup(COLLISION_GROUP_PROJECTILE)
		
		local phys = self:GetPhysicsObject()  	
		if IsValid(phys) then 
			phys:Wake()
			phys:EnableDrag(false)
			phys:AddGameFlag(FVPHYSICS_NO_IMPACT_DMG)
			phys:SetBuoyancyRatio(0)
		end

		self.BurnSound = CreateSound(self, "Weapon_NMRiH_Molotov.Rag_Loop")
		self.BurnSound:Play()
		
		self:Fire("kill", 1, 10)
	end
	
	function ENT:Think()
		if self.HitData and not hull then		
			if self.Dud then 
				self:NextThink(CurTime() + 300)
				self:Remove()
				return false
			end
		
			local hull = ents.Create("rj_molotov_hull")
			if not hull then return end
			hull:SetPos(self.HitData.HitPos + self.HitData.HitNormal * 40)
			hull:SetAngles(self.HitData.HitNormal:Angle() + Angle(90,0,0))
			hull:SetOwner(self.Owner)
			hull.Owner = self.Owner
			hull.Inflictor = self.Weapon
			hull:Spawn()

			self:SetCollisionGroup(COLLISION_GROUP_DEBRIS)
			self:SetMoveType(MOVETYPE_NONE)
			self:Remove()
		end
		
		self:NextThink(CurTime())
		
	end
	
	function ENT:OnRemove()
		if self.BurnSound then 
			self.BurnSound:Stop()
		end
	end
	
	function ENT:PhysicsCollide(data, phys)		
		if IsValid(self) and not self.Hit then		
			self:SetNoDraw(true)
			
			local trdata = {}
			trdata.start = data.HitPos
			trdata.endpos = data.HitPos + data.HitNormal
			local tr = util.TraceLine(trdata)
			
			if tr.Hit then		
			
				self.HitData = tr
				self.HitData.Velocity = self:GetVelocity()
				self.Hit = true
				
				if self:WaterLevel() > 0 then 
					self.Dud = true 
					self:EmitSound("physics/glass/glass_bottle_break"..math.random(1,2)..".wav", 90, 100)
					return false 
				end
				
				if IsValid(self.Owner) then
					util.BlastDamage(self, self.Owner, self:GetPos(), 200, 40) 
				else
					util.BlastDamage(self, self, self:GetPos(), 200, 40) 
				end

				for k, v in ipairs(ents.FindInSphere(self:GetPos(), 100)) do
					local phys = v:GetPhysicsObject()
					if (v:IsProp() and IsValid(v:CPPIGetOwner()) and IsValid(phys)) or v:IsPlayer() then
						local dot = tr.HitNormal:Dot(v:GetPos() - trdata.start)
						if (dot > 0 or v == tr.Entity) then
							v:Ignite(10, 0)
						end
					end
				end
				
				ParticleEffect("nmrih_molotov_explosion",tr.HitPos,tr.HitNormal:Angle() + Angle(90,0,0)) 
				
				self:EmitSound("Weapon_NMRiH_Molotov.Explode")				
			end			
		end	
	end	
end
scripted_ents.Register(ENT, "rj_molotov", true)

local HULL = {}

HULL.PrintName = "Molotov Point Hurt"
HULL.Type = "anim"
HULL.Base = "base_anim"

if SERVER then
	function HULL:Initialize()	
		self:SetModel("models/hunter/blocks/cube4x4x2.mdl")
		self:SetMoveType(MOVETYPE_NONE)
		self:SetSolid(SOLID_VPHYSICS)
		self:AddSolidFlags(FSOLID_NOT_SOLID)
		self:SetCollisionGroup(COLLISION_GROUP_NONE)
		self:SetNoDraw(true)
		self:SetTrigger(true)
		
		self.NextHurt = CurTime()

		self.BurnSound = CreateSound(self, "ambient/fire/fire_small_loop1.wav")
		self.BurnSound:PlayEx(1,98)
		self.BurnSound:SetSoundLevel(80)
		
		self:Fire("kill", 1, 20)		
	end
	
	function HULL:Touch(victim)
		if (!isplayer(victim)) then return end

		if self.NextHurt < CurTime() then
	
			local attacker = self:GetOwner() or self.Owner or self
			local inflictor = self.Inflictor or self
			if not IsValid(attacker) then return end
			
			local dmg = DamageInfo()
			dmg:SetDamage(5)
			dmg:SetDamageType(DMG_BURN)
			dmg:SetDamagePosition(self:GetPos())
			dmg:SetDamageForce(Vector(0,0,0))
			dmg:SetAttacker(attacker)
			dmg:SetInflictor(inflictor)
			
			if IsValid(victim) then
				victim:TakeDamageInfo(dmg)
				victim:Ignite(1,10)
			end
			
			self.NextHurt = CurTime() + 0.25		
		end			
	end
	
	function HULL:Think()
		self:NextThink(CurTime() + 0.5)
	end
	
	function HULL:OnRemove()
		if self.BurnSound then 
			self.BurnSound:Stop() 
		end
	end
end
scripted_ents.Register(HULL, "rj_molotov_hull", true)