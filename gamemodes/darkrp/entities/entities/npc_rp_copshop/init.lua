plib.IncludeCL 'cl_init.lua'
plib.IncludeSH 'shared.lua'

util.AddNetworkString('rp.CopshopMenu')

function ENT:Initialize()
	self:SetModel('models/Barney.mdl')

	self:SetHullType(HULL_HUMAN)
	self:SetHullSizeNormal()
	self:SetNPCState(NPC_STATE_SCRIPT)
	self:SetSolid(SOLID_BBOX)
	self:CapabilitiesAdd(CAP_ANIMATEDFACE)
	self:SetUseType(SIMPLE_USE)
	self:DropToFloor()
	self:SetCollisionGroup( COLLISION_GROUP_PLAYER )
	self:SetMaxYawSpeed(90)

	self:SetTrigger(true)
end

function ENT:AcceptInput(input, activator, caller)
	if (input == 'Use') then		-- and activator:IsPlayer() and (activator:IsCP() or activator:IsMayor()) 
		net.Start('rp.CopshopMenu')
		net.Send(activator)
	end
end

hook.Add('InitPostEntity', function()
	local npc = ents.Create('npc_rp_copshop')
	npc:SetPos(rp.cfg.CopShops[game.GetMap()].Pos)
	npc:SetAngles(rp.cfg.CopShops[game.GetMap()].Ang)
	npc:Spawn()
end)