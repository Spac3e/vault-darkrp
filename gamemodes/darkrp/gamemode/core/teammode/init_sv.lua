util.AddNetworkString('TeamModeFrame')

rp.AddCommand('removeplyfromteam', function(pl, slot)
	local TeamData = pl:GetTeamData()
	local plyToRemove = tonumber(slot)

	if not plyToRemove or not TeamData[plyToRemove] then return "" end

	TeamData[plyToRemove] = nil
	pl:SetNetVar('TeamData', TeamData)
	net.Start('TeamModeFrame')
	net.Send(pl)

	-- if not slot or not pl:GetApparel()[tonumber(slot)] then return end	
end)
:AddParam(cmd.STRING)

rp.AddCommand('addplytoteam', function(pl, targ, slot)
	local TeamData = pl:GetTeamData()
	local plyToAdd = targ
	local plyToAddSlot = tonumber(slot)

	if not plyToAddSlot or not plyToAdd or TeamData[plyToAddSlot] then return "" end

	-- if TeamData[plyToRemove] then rp.Notify(pl, NOTIFY_ERROR, 'Этот слот занят') return end
	rp.Notify(pl, NOTIFY_SUCCESS, 'Вы отправили запрос: ' .. plyToAdd:Name())

	GAMEMODE.ques:Create(pl:Name() .. ", хочет добавить вас в \nсвою локальную банду, вы согласны?", "inviteinteam" .. pl:UserID(), plyToAdd, 20, function(answer, ent, initiator, target)
		if tobool(answer) and IsValid(plyToAdd) and IsValid(pl) then 

			TeamData[plyToAddSlot] = plyToAdd
			pl:SetNetVar('TeamData', TeamData)

			net.Start('TeamModeFrame')
			net.Send(pl)

			rp.Notify(pl, NOTIFY_SUCCESS, 'Теперь ' .. plyToAdd:Name() .. ' в вашей локальной банде вы будете видеть его кол-во здоровья.')
			rp.Notify(plyToAdd, NOTIFY_SUCCESS, 'Теперь вы в локальной банде ' .. pl:Name() .. ', он будет видеть ваше кол-во здоровья.')
			return ""
		elseif tobool(answer) == false then
			rp.Notify(pl, NOTIFY_ERROR, plyToAdd:Name() .. ' отказался вступить в вашу локальную банду')			
			return ""
		end
	end)
	-- TeamData[plyToAddSlot] = pl
	-- pl:SetNetVar('TeamData', TeamData)
	-- if not targ or not pl:GetApparel()[tonumber(targ)] then return end	
end)
:AddParam(cmd.PLAYER_ENTITY)
:AddParam(cmd.STRING)