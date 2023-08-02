plib.IncludeCL 'cl_init.lua'
plib.IncludeSH 'shared.lua'

util.AddNetworkString('rp::KarmaBuy')

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
		net.Start('rp::KarmaBuy')
		net.Send(activator)
	end
end

rp.AddCommand("buykarma", function(ply, args)
	local amount = tonumber(args)
	local num = math.floor(amount / 125)

	if (ply:CanAfford(amount)) then 
		if num <= 0 then 
			ply:ChatPrint('Вы не можете купить меньше 1 кармы.')
		else
			rp.Notify(ply, NOTIFY_SUCCESS, "Вы успешно приобрели "..math.floor(amount / 125).." кармы!")

			ply:AddKarma(math.floor(amount / 125))
			ply:TakeMoney(-amount)
		end
	else
		ply:ChatPrint('Вы не можете себе позволить столько кармы (' .. num .. ')')
	end
end)
:AddParam(cmd.STRING)

/*
net.Receive('rp::KarmaBuy', function(len, ply) 
	local tb = net.ReadTable()
	local amount = tb['amount']
	local num = math.floor(amount / 125)

	if (ply:CanAfford(amount)) then 
		if num == 0 then 
			ply:ChatPrint('Вы не можете купить 0 кармы.')
		elseif num < 0 then
			ply:ChatPrint('Вы не можете купить меньше 0 кармы')
		else
			ply:ChatPrint("Вы купили карму")
			ply:AddKarma(math.floor(amount / 125))
			ply:TakeMoney(-amount)
			for i = 1, math.floor(amount / 125) do
				rp.achievements.AddProgress(ply, ACHIEVEMENT_HOLYMAN, i)
			end
		end
	else
		ply:ChatPrint('Вы не можете себе позволить столько кармы (' .. num .. ')')
	end
end)
*/
