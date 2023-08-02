AddCSLuaFile('cl_init.lua')
AddCSLuaFile('shared.lua')
include('shared.lua')

function ENT:Initialize()	
	self:SetModel('models/props_debris/barricade_short01a.mdl')

	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_NONE)
	self:SetSolid(SOLID_VPHYSICS)
end

hook.Add('InitPostEntity', 'SpawnRocks', function()
	for k,v in pairs(rpRocks[game.GetMap()] or {}) do
		local rocks = ents.Create('ent_rock')
		rocks:SetPos(v[1])
		rocks:SetAngles(v[2])
		rocks:Spawn()
	end
end)