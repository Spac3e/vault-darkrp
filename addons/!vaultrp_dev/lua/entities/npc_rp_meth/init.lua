plib.IncludeCL 'cl_init.lua'
plib.IncludeSH 'shared.lua'

util.AddNetworkString('mth')
util.AddNetworkString('mth_sell')

function ENT:Initialize()
	self:SetModel('models/Humans/Group01/male_06.mdl')

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

function ENT:AcceptInput(name, activator, caller)	
	if (!self.nextUse or CurTime() >= self.nextUse) then
		if (name == "Use" and caller:IsPlayer() and (caller:GetNWInt("player_meth") == 0)) then
			--self:EmitSound("vo/npc/male01/gethellout.wav");			
			caller:SendLua("local tab = {Color(1,241,249,255), [[Брей Кинг Бэд: ]], Color(255,255,255), [["..table.Random(EML_Meth_Salesman_NoMeth).."]] } chat.AddText(unpack(tab))");
			timer.Simple(0.25, function() self:EmitSound(table.Random(EML_Meth_Salesman_NoMeth_Sound), 100, 100) end);
		elseif (name == "Use") and (caller:IsPlayer()) and (caller:GetNWInt("player_meth") > 0) then
			caller:AddMoney(caller:GetNWInt("player_meth"));
			caller:SendLua("local tab = {Color(1,241,249,255), [[Брей Кинг Бэд: ]], Color(255,255,255), [["..table.Random(EML_Meth_Salesman_GotMeth)..", Это твои ]], Color(128, 255, 128), [["..caller:GetNWInt("player_meth").."$.]] } chat.AddText(unpack(tab))");
			caller:SetNWInt("player_meth", 0);
			timer.Simple(0.25, function() self:EmitSound(table.Random(EML_Meth_Salesman_GotMeth_Sound), 100, 100) end);
			timer.Simple(2.5, function() self:EmitSound("vo/npc/male01/moan0"..math.random(1, 5)..".wav") end);
		end;
		self.nextUse = CurTime() + 1;
	end;
end;

hook.Add('InitPostEntity', 'npc_rp_meth_InitPostEntity', function()
	local npc = ents.Create('npc_rp_meth')
	npc:SetPos(rp.cfg.MethBuyers[game.GetMap()].Pos)
	npc:SetAngles(rp.cfg.MethBuyers[game.GetMap()].Ang)
	npc:Spawn()
end)