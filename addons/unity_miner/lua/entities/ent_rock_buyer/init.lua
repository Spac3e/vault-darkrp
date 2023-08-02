AddCSLuaFile('cl_init.lua')
AddCSLuaFile('shared.lua')
include('shared.lua')

util.AddNetworkString('open_rude_menu')
util.AddNetworkString('sell_rude')
util.AddNetworkString('msg_chatnotify')

local course = {math.random()*200,math.random()*200,math.random()*200}

timer.Create('CourseChange',60*5,0,function() 
	table.insert( course,math.random() * 200 )
end)

timer.Create('Clean',60*60,0,function() course = {} 
	for i = 1, 4 do 
		table.insert(course,math.random() * 200)
	end
end)

function ENT:Initialize()
	self:SetModel('models/Eli.mdl')
	self:SetHullType(HULL_HUMAN)
	self:SetHullSizeNormal()
	self:SetNPCState(NPC_STATE_SCRIPT)
	self:SetSolid(SOLID_BBOX)
	self:CapabilitiesAdd(CAP_ANIMATEDFACE)
	self:SetUseType(SIMPLE_USE)
	self:DropToFloor()
	self:SetCollisionGroup(COLLISION_GROUP_DEBRIS_TRIGGER)
	self:SetMaxYawSpeed(90)

	self:SetTrigger(true)
end

function ENT:AcceptInput(name,act,call)
	call.lastPrimeSaled = call.lastPrimeSaled or CurTime()
	if name == 'Use' then 
		net.Start('open_rude_menu')
			net.WriteTable(course)
		net.Send(call)
		call.lastPrimeSaled = call.lastPrimeSaled or CurTime()
	end
end

net.Receive('sell_rude',function(l,p) 
	p.lastPrimeSaled = p.lastPrimeSaled or 0
	if CurTime() > p.lastPrimeSaled + 10 then 
		-- if (p:GetEyeTrace().Entity:GetClass() == 'ent_rock_buyer') then 
			p.lastPrimeSaled = CurTime()
			local earned = p:GetNWInt('rudy_tottaly') * math.floor( (math.floor(course[#course]) or 1) * 0.07)
			if (earned > 0) then
				p:SetNWInt('rudy_tottaly',0)
				p:SetNWInt("inventory_rudy",0)
				rp.Notify(p, NOTIFY_SUCCESS, 'Вы получили ' .. rp.FormatMoney(tostring(earned)) .. ' с продажи руды!')
				p:AddMoney(earned)
			else
				rp.Notify(p, NOTIFY_ERROR, 'У вас недостаточно руды! Вскапывайте камни специальной монтировкой и добывайте ее.')
			end
		-- else
			-- rp.Notify(p, NOTIFY_ERROR, 'Вы должны смотреть на Ахиллуя!')
		-- end
	else
		local time = 10 - math.abs( p.lastPrimeSaled - CurTime() )
		local f = string.FormattedTime(time,'%01i:%02i')
		rp.Notify(p, NOTIFY_ERROR, 'Притормозите! Вы сможете продать руду через ' .. tostring(f) .. ' секунд.')
	end
end)

hook.Add('InitPostEntity', 'npc_miner_InitPostEntity', function()
	local npc = ents.Create('ent_rock_buyer')
	npc:SetPos(Vector(5036, 1291, -220))
	npc:SetAngles(Angle(0,-90,0))
	npc:Spawn()
end)