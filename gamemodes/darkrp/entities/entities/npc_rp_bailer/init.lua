AddCSLuaFile('cl_init.lua')
AddCSLuaFile('shared.lua')

plib.IncludeSH'shared.lua'
plib.IncludeCL'menu_cl.lua'

util.AddNetworkString('rp.OpenBail')

function ENT:Initialize()
	self:SetModel('models/props/cs_office/offcorkboarda.mdl')
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
	self:SetUseType(SIMPLE_USE)
	self:SetCollisionGroup(COLLISION_GROUP_DEBRIS_TRIGGER)
	self:PhysWake()
end

function ENT:Use(pl)
	local tbl = {}
	for k, v in ipairs(player.GetAll()) do 
		if v:IsArrested() then
			tbl[#tbl + 1] = v
		end
	end
	
	net.Start('rp.OpenBail')
		net.WriteUInt(#tbl, 8)
		for k, v in ipairs(tbl) do
			net.WriteEntity(v)
			net.WriteUInt(5000, 16)
		end
	net.Send(pl)
end

rp.AddCommand('bail', function(pl, text, args)
	local exploiter = true
	for k, v in ipairs(ents.FindInSphere(pl:GetPos(), 200)) do
		if IsValid(v) and (v:GetClass() == 'bail_machine') then
			exploiter = false
			break
		end
	end

	if exploiter then return end

	local t = rp.FindPlayer(args[1])
	if (not IsValid(t)) or (not t:IsArrested()) then
		rp.Notify(pl, NOTIFY_ERROR, rp.Term('PlayerNotInJail'), t)
		return
	end

	if (t == pl) then
		pl:ConCommand('rp 911 Hello I\'m trying to escape from jail please come arrest me!')
		rp.Notify(pl, NOTIFY_ERROR, rp.Term('PlayerFuckedBailing'))
		return
	end

	if IsValid(t) then
		local cost = pl:IsMayor() and 0 or 5000
		pl:TakeMoney(cost)
		rp.Notify(pl, NOTIFY_GREEN, rp.Term('PlayerBailedPlayer'), t, rp.FormatMoney(cost))
		t:UnArrest(t)
		t:FlashNotify('Bail', rp.Term('YouWereBailed'), pl)

		hook.Call('PlayerBailPlayer', nil, pl, t, cost)
	end
end)
