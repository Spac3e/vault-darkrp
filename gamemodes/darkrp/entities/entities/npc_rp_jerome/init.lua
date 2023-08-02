plib.IncludeCL 'cl_init.lua'
plib.IncludeSH 'shared.lua'
plib.IncludeCL'menu_cl.lua'

util.AddNetworkString('rp.DrugBuyerMenu')

function ENT:Initialize()
	self:SetModel('models/Humans/Group01/male_03.mdl')

	self:SetHullType(HULL_HUMAN)
	self:SetHullSizeNormal()
	self:SetNPCState(NPC_STATE_SCRIPT)
	self:SetSolid(SOLID_BBOX)
	self:CapabilitiesAdd(CAP_ANIMATEDFACE)
	self:SetUseType(SIMPLE_USE)
	self:DropToFloor()
	self:SetCollisionGroup(COLLISION_GROUP_PLAYER)
	self:SetMaxYawSpeed(90)

	self:SetTrigger(true)
end

function ENT:AcceptInput(input, activator, caller)
	if (input == 'Use') and activator:IsPlayer() then
		net.Start('rp.DrugBuyerMenu')
		net.Send(activator)
	end
end

function ENT:StartTouch(ent)
	local owner = ent.DrugOwner
	if IsValid(ent) and IsValid(owner) then
		local info = ent.DrugInfo
		ent:Remove()
		owner:AddMoney(info.BuyPrice)
		rp.Notify(owner, NOTIFY_SUCCESS, 'Вы продали ' .. info.Name .. ' за ' .. rp.FormatMoney(info.BuyPrice))
	end
end

hook.Add('GravGunOnPickedUp', 'rp.drugbuyer.GravGunOnPickedUp', function(pl, ent)
	local tab = rp.Drugs[ent:GetClass()]  or rp.Drugs[ent.weaponclass]
	if tab then
		ent.DrugOwner = pl
		ent.DrugInfo = tab
	end
end)

hook.Add('GravGunOnDropped', 'rp.drugbuyer.GravGunOnDropped', function(pl, ent)
	local tab = rp.Drugs[ent:GetClass()]  or rp.Drugs[ent.weaponclass]
	if tab then
		ent.DrugOwner = nil
		ent.DrugInfo = nil
	end
end)

hook.Add('InitPostEntity', 'rp.drugbuyer.InitPostEntity', function()
 	local npc = ents.Create('npc_rp_jerome')
 	npc:SetPos(rp.cfg.DrugBuyers[game.GetMap()].Pos)
 	npc:SetAngles(rp.cfg.DrugBuyers[game.GetMap()].Ang)
npc:Spawn()
end)