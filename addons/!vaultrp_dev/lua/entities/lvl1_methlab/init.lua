AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

ENT.SeizeReward = 250
ENT.WantReason = 'Сбыт наркотиков'
ENT.RemoveOnJobChange = true

function ENT:Initialize()
	self:SetModel("models/props_wasteland/laundry_washer003.mdl")
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
	self:SetNWInt("curmeth", 0)
	self:GetPhysicsObject():SetMass(250)
	
	timer.Simple(MethProd_Lvl1_CookSpeed /2, function() if self:IsValid() then SetMeth(self) end end)

	-- timer.Simple(1, function()
	-- 	local chance = math.Round(math.Rand(1, MethProd_ExpChance))
	
	-- 	if self:IsValid() then
	-- 		if MethProd_CanExplode == true then
	-- 				if chance == 1 then if self:IsValid() then self:Explode() end
	-- 			end
	-- 		end
	-- 	end
	-- end)
end

SetMeth = function(ent)
	timer.Simple(MethProd_Lvl1_CookSpeed /2, function() if ent:IsValid() then ent:CookMeth() end end)
end

function ENT:CookMeth()
	local chance = math.Round(math.Rand(1, MethProd_ExpChance))
		
	if chance == 1 then 
		if self:IsValid() then 
			self:Explode()
		end
	end

	if not IsValid(self) then return end

	self:SetNWInt("curmeth", self:GetNWInt("curmeth") + MethProd_Lvl1_ps)

	timer.Simple(MethProd_Lvl1_CookSpeed/2, function() if self:IsValid() then SetMeth(self) end end)
end

function ENT:Use(ply, ent)
	if ((self.nextUse or 0) < CurTime()) then
		ply:SetNWInt("methcnt", ply:GetNWInt("methcnt") + self:GetNWInt("curmeth")) 

		rp.Notify(ply, 0, "Вы взяли " .. self:GetNWInt("curmeth") .. " г метамфетамина.")
		rp.Notify(ply, 0, "У вас " .. ply:GetNWInt("methcnt") .. " г метамфетамина")

		self:SetNWInt("curmeth", 0)
		
		self.nextUse = CurTime() + 4
	end
end

function ENT:Explode() 
	local exp = ents.Create('env_explosion')
	exp:SetPos(self:GetPos())
	exp:SetKeyValue("iMagnitude", "55")
	exp:SetKeyValue("iRadiusOverride", 456)
	exp:Spawn()
	exp:Fire("Explode", 55, 0)
		
	local debris = ents.Create("prop_physics")
	debris:SetPos(self:GetPos())
	debris:SetAngles(self:GetAngles())
	debris:SetMaterial("models/props_pipes/GutterMetal01a")
	debris:SetColor(Color(125,125,125))
	debris:SetModel(self:GetModel())
	debris:Spawn()
	debris:SetVelocity( Vector( 0,10000,900) )
	timer.Simple(4, function() 
		debris:Remove()
	end)

	debris:EmitSound("ambient/fire/gascan_ignite1.wav", 90, 100)

	self:Remove()

	rp.Notify(self:Getowning_ent(), 1, "Ваша мет лаборатория была разрушена.")
end

ENT.maxdmg = MethProd_LabHealth

function ENT:OnTakeDamage(dmg)

	self:TakePhysicsDamage(dmg)
 
	if(self.maxdmg <= 0) then return end
 
	self.maxdmg = self.maxdmg - dmg:GetDamage()
 
	if(self.maxdmg <= 0) then 
		self:Explode()
	end
end

function ENT:Think()
	local meth = self:GetNWInt("curmeth")
	if meth > tonumber(MethProd_Lvl1_MaxMeth, 10) then
		self:Explode()
	end
end