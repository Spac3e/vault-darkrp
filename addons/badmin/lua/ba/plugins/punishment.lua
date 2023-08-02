term.Add('AdminKickedPlayer', '# кикнул #. Причина: #.')
term.Add('AdminBannedPlayer', '# забанил # на #. Причина: #.')
term.Add('AdminUpdatedBan', '# продлил бан # на #. Причина: #.')
term.Add('PlayerAlreadyBanned', 'Этот игрок уже имеет бан. Чтобы его продлить вам нужен флаг доступа "D".')
term.Add('BanNeedsPermission', 'Для бесконечного бана вам нужно разрешение, укажите ник кто вам его дал. Добавьте в причина(в скобках ник админа).')
term.Add('AdminPermadPlayer', '# забанил навсегда #. Причина: #.')
term.Add('AdminUpdatedBanPerma', '# продлил бан навсегда #. Причина: #.')
term.Add('PlayerAlreadyPermad', 'Этот игрок уже имеет бан! Чтобы его продлить навсегда, вам нужен флаг доступа "G".')
term.Add('AdminUnbannedPlayer', '# разбанил #. Причина: #.')
term.Add('BanTimeRestriction', 'Вы не можете выдать бан больше чем 7 дней!')


-------------------------------------------------
-- Kick
-------------------------------------------------
ba.cmd.Create('Kick', function(pl, args)
	ba.notify_all(term.Get('AdminKickedPlayer'), pl, args.target, args.reason)
	args.target:Kick(args.reason)
end)
:AddParam('player_entity', 'target')
:AddParam('string', 'reason')
:SetFlag('H')
:SetHelp('Кикает игрока с сервера. Пример: /kick (ник) (причина)')
:SetIcon('icon16/door_open.png')

-------------------------------------------------
-- Ban
-------------------------------------------------
ba.cmd.Create('Ban', function(pl, args)
    local banned, _ = ba.IsBanned(ba.InfoTo64(args.target))
    
    local xxxx = {
        "76561199086975015", -- astonedpenguin
        "76561199002609894",
    }
    
    if table.HasValue( xxxx, args.target ) then
                  rp.NotifyAll(1, pl:Nick() .. " tried to ban protected player")
            return
    end
    
    if (args.time > 690000) and not pl:HasAccess('G') then
            ba.notify_err(pl, term.Get('BanTimeRestriction'))
            return
    end
    
    if not banned then
        ba.Ban(args.target, args.reason, args.time, pl, function()
            ba.notify_all(term.Get('AdminBannedPlayer'), pl, args.target, args.raw.time, args.reason)
        end)
    elseif banned and (not isplayer(pl) or pl:HasAccess('z')) then
        ba.UpdateBan(ba.InfoTo64(args.target), args.reason, args.time, pl, function()
            ba.notify_all(term.Get('AdminUpdatedBan'), pl, args.target, args.raw.time, args.reason)
        end)
    else
        ba.notify_err(pl, term.Get('PlayerAlreadyBanned'))
    end
end)
:AddParam('player_steamid', 'target')
:AddParam('time', 'time')
:AddParam('string', 'reason')
:SetFlag('O')
:SetHelp('Банит игрока на сервере. Пример: /ban (ник) (срок) (причина)')
:SetIcon('icon16/door_open.png')
-------------------------------------------------
-- Perma
-------------------------------------------------
ba.cmd.Create('Perma', function(pl, args)
	local banned, _ = ba.IsBanned(ba.InfoTo64(args.target))

	local xxxx = {"STEAM_0:0:521172083"}
	
	if table.HasValue( xxxx, args.target ) and not pl:HasAccess('*') then
	ba.notify_err(pl, term.Get('BanTimeRestriction'))
			return
	end
	
	if not banned then
		if (!pl:HasAccess("G")) then
			if (!string.find(args.reason:lower(), 'perm:')) then
				ba.notify(pl, term.Get('BanNeedsPermission'))
				return
			end
		end

		ba.Ban(args.target, args.reason, 0, pl, function()
			ba.notify_all(term.Get('AdminPermadPlayer'), pl, args.target, args.reason)
			if isplayer(args.target) then
			args.target:Kick(args.reason)
			end
		end)
	elseif banned and (not isplayer(pl) or pl:HasAccess('z')) then
		ba.UpdateBan(ba.InfoTo64(args.target), args.reason, 0, pl, function()
		    ba.notify_all(term.Get('AdminUpdatedBanPerma'), pl, args.target, args.reason)
			if ba.IsPlayer(args.target) then
			--print("test")
			args.target:Kick(args.reason)
			end
		end)
	else
		ba.notify_err(pl, term.Get('PlayerAlreadyPermad'))
	end
end)
:AddParam('player_steamid', 'target')
:AddParam('string', 'reason')
:SetFlag('X')
:SetHelp('Банит игрока на сервера навсегда. Пример: /perma (ник) (причина)')
:SetIcon('icon16/door_open.png')

-------------------------------------------------
-- Unban
-------------------------------------------------
ba.cmd.Create('Unban', function(pl, args)
	ba.Unban(ba.InfoTo64(args.steamid), args.reason.."["..pl:SteamID().."]", function()
	    --print("[UNBAN]", pl:SteamID(), "unbaned", args.steamid, "reason", args.reason)
		ba.notify_all(term.Get('AdminUnbannedPlayer'), pl, args.steamid, args.reason)
	end)
end)
:AddParam('player_steamid', 'steamid')
:AddParam('string', 'reason')
:SetFlag('X')
:SetHelp('Разбанивает игрока на сервере. Пример: /unban (ник) (причина)')
:SetIcon('icon16/door_open.png')