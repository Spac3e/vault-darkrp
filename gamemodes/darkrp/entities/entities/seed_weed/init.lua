plib.IncludeCL 'cl_init.lua'
plib.IncludeSH 'shared.lua'

ENT.MaxHealth 	= 100

function ENT:Initialize()
	self:SetModel('models/Items/AR2_Grenade.mdl')
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
	self:SetCollisionGroup(COLLISION_GROUP_DEBRIS_TRIGGER)

	self:SetUseType(SIMPLE_USE)

	self:PhysWake()
end