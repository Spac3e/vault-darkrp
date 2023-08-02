plib.IncludeCL 'cl_init.lua'
plib.IncludeSH 'shared.lua'

util.AddNetworkString('rp.HitmanMenu')

function ENT:Initialize()
	self:SetModel('models/Humans/Group01/male_03.mdl')

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
	if (input == 'Use') and activator:IsPlayer() then
		net.Start('rp.HitmanMenu')
		net.Send(activator)
	end
end

hook.Add('InitPostEntity', 'rp.hitmanmenu.InitPostEntity', function()
	local npc = ents.Create('npc_rp_volodya')
	npc:SetPos(rp.cfg.HitmanMenu[game.GetMap()].Pos)
	npc:SetAngles(rp.cfg.HitmanMenu[game.GetMap()].Ang)
	npc:Spawn()
end)