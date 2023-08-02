plib.IncludeCL 'cl_init.lua'
plib.IncludeCL 'menu_cl.lua'
plib.IncludeSH 'shared.lua'

util.AddNetworkString('rp.GunBuyerMenu')

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
		net.Start('rp.GunBuyerMenu')
		net.Send(activator)
	end
end

function ENT:StartTouch(ent)
	local owner = ent.GunOwner
	if IsValid(ent) and IsValid(owner) then

	if (not owner:HasLicense()) then return end

		local info = ent.GunInfo
		ent:Remove()
		owner:AddMoney(info.BuyPrice)
		rp.Notify(owner, NOTIFY_SUCCESS, 'Вы продали ' .. info.Name .. ' за ' .. rp.FormatMoney(info.BuyPrice))
	end
end

hook.Add('GravGunOnPickedUp', 'rp.gunbuyer.GravGunOnPickedUp', function(pl, ent)
	local tab = rp.WeaponsMap[ent:GetClass()] or rp.WeaponsMap[ent.weaponclass]
	if tab then
		ent.GunOwner = pl
		ent.GunInfo = tab
	end
end)

hook.Add('GravGunOnDropped', 'rp.gunbuyer.GravGunOnDropped', function(pl, ent)
	local tab = rp.WeaponsMap[ent:GetClass()] or rp.WeaponsMap[ent.weaponclass]
	if tab then
		ent.GunOwner = nil
		ent.GunInfo = nil
	end
end)

hook.Add('InitPostEntity', 'rp.gun.spawning', function()
	local npc = ents.Create('npc_rp_sasha')
	npc:SetPos(rp.cfg.GunBuyers[game.GetMap()].Pos)
	npc:SetAngles(rp.cfg.GunBuyers[game.GetMap()].Ang)
	npc:Spawn()
end)