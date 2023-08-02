/*
	Drugs System
	Coded by KingofBeast
	Inspired by Durgz, but that's a shitty addon
*/
-- пацаны я тут был, и ето тупо отредаченые наркотяки
-- наркотяки вред
AddCSLuaFile()

ENT.Type			= 'anim'
ENT.Base			= 'base_anim'

ENT.Category		= 'RP Drugs'
ENT.PrintName		= 'Drug'
ENT.Author			= 'The D3vine'
ENT.Information		= ''
ENT.Spawnable		= false
ENT.AdminSpawnable	= false

ENT.HighLagRisk = true

ENT.Model			= 'models/props_c17/briefcase001a.mdl'
ENT.ID				= ''

function ENT:Initialize()
	self:SetModel(self.Model)
	
	if (SERVER) then
		self:PhysicsInit(SOLID_VPHYSICS)
		self:SetMoveType(MOVETYPE_VPHYSICS)
		self:SetSolid(SOLID_VPHYSICS)
		self:SetCollisionGroup(COLLISION_GROUP_DEBRIS_TRIGGER)

		self:PhysWake()
		
		self:GetPhysicsObject():SetMass(2)
	end
end

function ENT:OnTakeDamage(dmginfo)
	self:TakePhysicsDamage(dmginfo)
end

function ENT:Use(activator, caller)
	if (self.ID and self.ID != '') then
		activator:AddHigh(self.ID)
	else
		activator:ChatPrint('Этот наркотик не существует!')
	end
    self:Remove()
end