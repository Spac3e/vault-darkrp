term.Add('AdminGoneTo', '# телепортировался к #.')
term.Add('AdminRoomUnset', 'База Админов не назначена!')
term.Add('AdminGoneToAdminRoom', '# отправился на Базу Админов.')
term.Add('AdminRoomSet', 'База Админов обозначена.')
term.Add('AdminReturnedSelf', '# вернул себя в последнюю локацию.')
term.Add('NoKnownPosition', 'У вас нет последней локации.')
term.Add('NoKnownPositionPlayer', 'У # нет последней локации!')

-------------------------------------------------
-- Tele
-------------------------------------------------
ba.cmd.Create('Tele', function(pl, args)
	for k, v in ipairs(args.targets) do
		if (not v:Alive()) then
			v:Spawn()
		end

		if v:InVehicle() then
			v:ExitVehicle()
		end

		v:SetBVar('ReturnPos', v:GetPos())

		v:SetPos(util.FindEmptyPos(pl:GetEyeTrace().HitPos))

	end

	ba.notify_staff('# телепортировал к себе ' .. ('# '):rep(#args.targets) .. '.', pl, unpack(args.targets))
end)
:AddParam('player_entity_multi', 'targets')
:SetFlag('M')
:SetHelp('Телепортирует к себе игрока. Пример: /tp (ник)')
:SetIcon('icon16/arrow_up.png')
:AddAlias('tp')

-------------------------------------------------
-- Goto
-------------------------------------------------
ba.cmd.Create('Goto', function(pl, args)
	if not pl:Alive() then
		pl:Spawn()
	end
		
	if pl:InVehicle() then
		pl:ExitVehicle()
	end

	pl:SetBVar('ReturnPos', pl:GetPos())

	local pos = util.FindEmptyPos(args.target:GetPos()) 

	pl:SetPos(pos)

	ba.notify_staff(term.Get('AdminGoneTo'), pl, args.target)
end)
:AddParam('player_entity', 'target')
:SetFlag('M')
:SetHelp('Телепортирует вас к игроку. Пример: /goto (ник)')
:SetIcon('icon16/arrow_down.png')

-------------------------------------------------
-- Sit
-------------------------------------------------
if (SERVER) then
	ba.adminRoom = ba.svar.Get('adminroom') and pon.decode(ba.svar.Get('adminroom'))[1]
	ba.svar.Create('adminroom', nil, false, function(svar, old_value, new_value)
		ba.adminRoom = pon.decode(new_value)[1]
	end)
end

ba.cmd.Create('Sit', function(pl, args)
	if not ba.svar.Get('adminroom') then
		ba.notify_err(pl, term.Get('AdminRoomUnset'))
		return
	end
		
	if not pl:Alive() then
		pl:Spawn()
	end

	pl:SetBVar('ReturnPos', pl:GetPos())

	local pos = util.FindEmptyPos(ba.adminRoom)

	pl:SetPos(pos)

	ba.notify_staff(term.Get('AdminGoneToAdminRoom'), pl)
end)
:SetFlag('M')
:SetHelp('Телепортирует вас в админ-базу.')

-------------------------------------------------
-- Set Admin Room
-------------------------------------------------
ba.cmd.Create('SetAdminRoom', function(pl, args)
	ba.svar.Set('adminroom', pon.encode({pl:GetPos()}))
	ba.notify(pl, term.Get('AdminRoomSet'))
end)
:SetFlag('*')
:SetHelp('Создает точку телепортации для админ-базы.')

-------------------------------------------------
-- Return
-------------------------------------------------
ba.cmd.Create('Return', function(pl, args)
	if (args.targets == nil) then
		if (pl:GetBVar('ReturnPos') ~= nil) then
			if not pl:Alive() then
				pl:Spawn()
			end
			
			local pos = util.FindEmptyPos(pl:GetBVar('ReturnPos'))
			pl:SetPos(pos)

			pl:SetBVar('ReturnPos', nil)

			ba.notify_staff(term.Get('AdminReturnedSelf'), pl)
		else
			ba.notify_err(pl, term.Get('NoKnownPosition'))
		end
		return
	end

	for k, v in ipairs(args.targets) do
		if (v:GetBVar('ReturnPos') == nil) then
			ba.notify_err(pl, term.Get('NoKnownPositionPlayer'), v)
			return
		end

		if not v:Alive() then
			v:Spawn()
		end
			
		if v:InVehicle() then
			v:ExitVehicle()
		end

		local pos = util.FindEmptyPos(v:GetBVar('ReturnPos'))

		v:SetPos(pos)
		v:SetBVar('ReturnPos', nil)
	end

	ba.notify_staff('# вернул ' .. ('# '):rep(#args.targets) .. ' в последнюю локацию.', pl, unpack(args.targets))
end)
:AddParam('player_entity_multi', 'targets', 'optional')
:SetFlag('M')
:SetHelp('Возращает игрока в последнюю локацию. Пример: /return (ник)')
:SetIcon('icon16/arrow_down.png')


ba.cmd.Create('spawn', function(pl, args)
 local map = game.GetMap()
 local test 	= rp.cfg.SpawnPos[map]
 pos = test[math.random(1, #test)]
	if (args.targets == nil) then
		
			if not pl:Alive() then
				pl:Spawn()
			end
			
			if pl:IsJailed() or pl:IsArrested() or pl:IsBanned() then ba.notify_err(pl, "Недоступно.") return end
			
			pl:SetPos(pos)

			pl:SetBVar('ReturnPos', nil)

			ba.notify_staff(term.Get('AdminReturnedSelf'), pl)

			hook.Call("AdmSpawnSelf", GAMEMODE, pl) --1
		
		return
	end

	for k, v in ipairs(args.targets) do
	
	if v:IsJailed() or v:IsArrested() or  v:IsBanned() then ba.notify_err(pl, "Недоступно.") return end	

		if not v:Alive() then
			v:Spawn()
		end
			
		if v:InVehicle() then
			v:ExitVehicle()
		end

		--print(pos)
		v:SetPos(pos)
		--v:SetBVar('ReturnPos', nil)
		hook.Call("AdmSpawnPlayer", GAMEMODE, v, pl) --1
	end

	ba.notify_staff('# вернул ' .. ('# '):rep(#args.targets) .. 'на спавн.', pl, unpack(args.targets))
end)
:AddParam('player_entity_multi', 'targets', 'optional')
:SetFlag 'M'
:SetIcon('icon16/arrow_rotate_anticlockwise.png')
:SetHelp 'Вернуть игрока на spawn.'



-------------------------------------------------
-- Player physgun
-------------------------------------------------
if (SERVER) then
	hook.Add('PhysgunPickup', 'ba.PhysgunPickup.PlayerPhysgun', function(pl, ent)
		if ((isplayer(ent) and pl:HasAccess('m') and ba.ranks.CanTarget(pl, ent) and ba.canAdmin(pl)) or false) then
			ent:SetMoveType(MOVETYPE_NOCLIP)
			ent:SetBVar('PrePhysFrozen', ent:IsFrozen())
			ent:Freeze(true)
			
			pl:SetBVar('HoldingPlayer', ent)
			return true
		end
	end)

	hook.Add('PhysgunDrop', 'ba.PhysgunDrop.PlayerPhysgun', function(pl, ent)
		if isplayer(ent) then
			ent:Freeze(ent:GetBVar('PrePhysFrozen'))
			ent:GetBVar('PrePhysFrozen', nil)
			ent:SetMoveType(MOVETYPE_WALK) 
			
			timer.Simple(0.2, function()
				if (!pl:IsValid()) then return end
				
				pl:SetBVar('HoldingPlayer', nil)
			end)
		end
	end)

	hook.Add('KeyRelease', 'ba.KeyRelease.PlayerPhysgun', function(pl, key)
		if IsValid(pl:GetBVar('HoldingPlayer')) and (key == IN_ATTACK2) then
			pl:ConCommand('ba freeze ' ..  pl:GetBVar('HoldingPlayer'):SteamID())
		end
	end)
end

-------------------------------------------------
-- Noclip
-------------------------------------------------
hook.Add('PlayerNoClip', 'ba.PlayerNoClip', function(pl)
    if (SERVER) and pl:HasAccess('M') and pl:HasAccess('m') and pl:HasAccess("G") and pl:HasAccess("z") and pl:HasAccess("A") or pl:GetUserGroup() == "sponsor" or pl:GetUserGroup() == "globaladmin" or pl:GetUserGroup() == "admin" or pl:GetUserGroup() == "moderator" or pl:GetUserGroup() == "helper" or pl:Team() == TEAM_ADMIN then
        return pl:GetBVar('adminmode')
    elseif (CLIENT) then
        return false
    end
end)

----------------------------------------------------------------------
-- Cloak
----------------------------------------------------------------------
ba.cmd.Create('Cloak', function(pl)
	if pl:GetNoDraw() then
		pl:SetNWBool('InvisibleBA', false)
		pl:SetNoDraw(false)
	else
		pl:SetNWBool('InvisibleBA', true)
		pl:SetNoDraw(true)
	end
end)
:SetFlag('J')
:SetHelp('Делает тебя невидимым')