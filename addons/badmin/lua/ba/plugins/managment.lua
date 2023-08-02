term.Add('AdminFrozePlayer', '# заморозил #.')
term.Add('AdminUnfrozePlayer', '# разморозил #.')
term.Add('AdminUnmutedPlayer', '# снял затычку с #.')
term.Add('AdminUnmutedYou', '# снял с вас затычку.')
term.Add('YouAreUnmuted', 'С вас сняли затычку.')
term.Add('AdminMutedPlayer', '# выдал затычку # на #.')
term.Add('AdminMutedYou', '# выдал вам затычку на #.')
term.Add('MuteMissingTime', 'Ошибка: укажите правильно время.')
term.Add('AdminUnmutedPlayerChat', '# снял затычку чата с #.')
term.Add('AdminUnmutedYouChat', '# снял с вас затычку чата.')
term.Add('YouAreUnmutedChat', 'Вам снова доступен чат.')
term.Add('AdminMutedPlayerChat', '# выдал затычку чата # на #.')
term.Add('AdminMutedYouChat', '# выдал вам затычку чата на #.')
term.Add('AdminUnmutedPlayerVoice', '# снял затычку микрофона с #.')
term.Add('AdminUnmutedYouVoice', '# снял с вас затычку микрофона.')
term.Add('YouAreUnmutedVoice', 'Вам снова доступен микрофон.')
term.Add('AdminMutedPlayerVoice', '# выдал затычку микрофона # на #.')
term.Add('AdminMutedYouVoice', '# выдал вам затычку микрофона на #.')
term.Add('AdminIsSpectating', '# находится в режиме наблюдения!')
term.Add('SpectateTargInvalid', 'Выберите доступного игрока!')

-------------------------------------------------
-- Freeze
-------------------------------------------------
ba.cmd.Create('Freeze', function(pl, args)
	if not args.target:Alive() then
		args.target:Spawn()
	end
		
	if args.target:InVehicle() then
		args.target:ExitVehicle()
	end

	if not args.target:IsFrozen() then
		args.target:Freeze(true)
		ba.notify_staff(term.Get('AdminFrozePlayer'), pl, args.target)
	else
		args.target:Freeze(false)
		ba.notify_staff(term.Get('AdminUnfrozePlayer'), pl, args.target)
	end
end)
:AddParam('player_entity', 'target')
:SetFlag('M')
:SetHelp('Замораживает/Размораживает игрока. Пример: /freeze (ник)')
:SetIcon('icon16/lock.png')

-------------------------------------------------
-- Mute
-------------------------------------------------
ba.cmd.Create('Mute', function(pl, args)
	if (not args.time) and args.target:IsChatMuted() or args.target:IsVoiceMuted() then
		args.target:UnChatMute()
		args.target:UnVoiceMute()
		ba.notify_staff(term.Get('AdminUnmutedPlayer'), pl, args.target)
		ba.notify(args.target, term.Get('AdminUnmutedYou'), pl)
	elseif args.time and (not args.target:IsChatMuted() or not args.target:IsVoiceMuted()) then
		args.target:ChatMute(args.time, function()
			ba.notify(args.target, term.Get('YouAreUnmuted'))
		end)
		args.target:VoiceMute(args.time)
		ba.notify_staff(term.Get('AdminMutedPlayer'), pl, args.target, args.raw.time)
		ba.notify(args.target, term.Get('AdminMutedYou'), pl, args.raw.time)
	else
		ba.notify_err(pl, term.Get('MuteMissingTime'))
	end
end)
:AddParam('player_entity', 'target')
:AddParam('time', 'time', 'optional')
:SetFlag('M')
:SetHelp('Затыкает игроку чат и микрофон. Пример: /mute (ник) (срок)')
:SetIcon('icon16/sound.png')

-------------------------------------------------
-- Mute Chat
-------------------------------------------------
ba.cmd.Create('MuteChat', function(pl, args)
	if (not args.time) and args.target:IsChatMuted() then
		args.target:UnChatMute()
		ba.notify_staff(term.Get('AdminUnmutedPlayerChat'), pl, args.target)
		ba.notify(args.target, term.Get('AdminUnmutedYouChat'), pl)
	elseif args.time and (not args.target:IsChatMuted()) then
		args.target:ChatMute(args.time, function()
			ba.notify(args.target, term.Get('YouAreUnmutedChat'))
		end)
		ba.notify_staff(term.Get('AdminMutedPlayerChat'), pl, args.target, args.raw.time)
		ba.notify(args.target, term.Get('AdminMutedYouChat'), pl, args.raw.time)
	else
		ba.notify_err(pl, term.Get('MuteMissingTime'))
	end
end)
:AddParam('player_entity', 'target')
:AddParam('time', 'time', 'optional')
:SetFlag('M')
:SetHelp('Затыкает игроку чат. Пример: /mutechat (ник) (срок)')
:SetIcon('icon16/sound.png')

-------------------------------------------------
-- Mute Voice
-------------------------------------------------
ba.cmd.Create('MuteVoice', function(pl, args)
	if (not args.time) and args.target:IsVoiceMuted() then
		args.target:UnVoiceMute()
		ba.notify_staff(term.Get('AdminUnmutedPlayerVoice'), pl, args.target)
		ba.notify(args.target, term.Get('AdminUnmutedYouVoice'), pl)
	elseif args.time and (not args.target:IsVoiceMuted()) then
		args.target:VoiceMute(args.time, function()
			ba.notify(args.target, term.Get('YouAreUnmutedVoice'))
		end)
		ba.notify_staff(term.Get('AdminMutedPlayerVoice'), pl, args.target, args.raw.time)
		ba.notify(args.target, term.Get('AdminMutedYouVoice'), pl, args.raw.time)
	else
		ba.notify_err(pl, term.Get('MuteMissingTime'))
	end
end)
:AddParam('player_entity', 'target')
:AddParam('time', 'time', 'optional')
:SetFlag('M')
:SetHelp('Затыкает игроку микрофон. Пример: /mutevoice (ник) (срок)')
:SetIcon('icon16/sound.png')

-------------------------------------------------
-- Spectate
-------------------------------------------------
ba.cmd.Create('Spectate', function(ply, args)
    local target = player.Find(args.target)
      startSpectating1(ply, args.target)
end)
:AddParam('player_entity', 'target', 'optional')
:SetFlag('O')
:SetHelp('Spectates your target/untoggles spectate')
:SetIcon('icon16/eye.png')
:AddAlias('spec')

function startSpectating1(ply, target)
    if !ply:HasAccess('a') then return end
    ply.FSpectatingEnt = target
    ply.FSpectating = true
    ply:ExitVehicle()
    if ( ply.FSpectatingEnt == ply ) then return end
    if ( ply.FSpectatingEnt == nil ) and !ply:IsAdmjob() and !ply:GetBVar('adminmode') and !ply:IsRoot() then ba.notify_err(ply, "Сначала включи админмод или зайди за админпрофу")  return end
    net.Start("FSpectate")
        net.WriteBool(target == nil)
        if IsValid(ply.FSpectatingEnt) then
            net.WriteEntity(ply.FSpectatingEnt)
        end
    net.Send(ply)

    local targetText = IsValid(target) and target:IsPlayer() and (target:Nick() .. " (" .. target:SteamID() .. ")") or IsValid(target) and "an entity" or ""
    ply:ChatPrint("Вы находитесь в спектейте " .. targetText)
end