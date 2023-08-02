AddCSLuaFile('cl_init.lua')
AddCSLuaFile('shared.lua')
include('shared.lua')

function ENT:Initialize()
	PrecacheParticleSystem('smoke_gib_01')

	self:SetModel('models/props_vents/vent_medium_grill001.mdl')
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_NONE)
	self:SetSolid(SOLID_NONE)

	ParticleEffectAttach('smoke_gib_01', PATTACH_ABSORIGIN_FOLLOW, self, 0)
end

function ENT:Draw() end