term.Add('AdminResetName', '# has reset #\'s RP name.')
term.Add('AdminResetYourName', '# has reset your RP name.')
term.Add('AdminResetJob', '# has reset #\'s custom job name.')
term.Add('AdminResetYourJob', '# has reset your custom job name.')
term.Add('EntityNoOwner', 'This entity has no owner.')
term.Add('CannotUnown', 'You cannot unown this property.')
term.Add('EntityOwnedBy', '# owns this # created # ago.')
term.Add('AdminUnownedYourDoor', '# force unowned your property.')
term.Add('AdminUnownedPlayerDoor', '# force unowned #\'s property.')
term.Add('AdminChangedYourJob', '# has force changed your job to #.')
term.Add('AdminChangedPlayerJob', '# has force changed #\'s job to #.')
term.Add('JobNotFound', 'Job # not found!')
term.Add('AdminUnwantedYou', '# has force unwanted you.')
term.Add('AdminUnwantedPlayer', '# has force unwanted #.')
term.Add('PlayerNotWanted', '# is not wanted!')
term.Add('AdminUnarrestedYou', '# has force unarrested you.')
term.Add('AdminUnarrestedPlayer', '# has force unarrested #.')
term.Add('PlayerNotArrested', '# is not arrested!')
term.Add('AdminArrestedPlayer', '# has force arrested # for #.')
term.Add('PlayerArrested', '# is already arrested!')
term.Add('ArrestTooLong', 'You cannot force arrest someone for longer than #')
term.Add('AdminArrestedYou', '# has force arrested you.')
term.Add('AdminUnwarrantedYou', '# has force unwarranted you.')
term.Add('AdminUnwarrantedPlayer', '# has force unwarranted #.')
term.Add('PlayerNotWarranted', '# is not warranted!')
term.Add('EventInvalid', '# is not a valid event!')
term.Add('AdminStartedEvent', '# has started a # event for #.')
term.Add('AdminExtendedEvent', '# has extended the # event by #.')
term.Add('AdminFrozePlayersProps', '# has frozen #\'s props.')
term.Add('AdminFrozeAllProps', '# has frozen all props.')
term.Add('PlayerVoteInvalid', 'No vote for # exists!')
term.Add('AdminDeniedVote', '# has denied #\'s vote.')
term.Add('AdminDeniedTeamVote', '# has denied the # vote. Campaign fees have been returned')
term.Add('AdminAddedYourMoney', '# has added $# to your wallet.')
term.Add('AdminAddedMoney', 'You have added $# to #\'s wallet.')
term.Add('AdminAddedYourCredits', '# has added # credits to your account.')
term.Add('AdminAddedCredits', 'You have added # credits to #\'s account.')
term.Add('AdminMovedPlayers', 'Moved # players to the other server.')
term.Add('PlayerNotFound', 'Couldn\'t find player #.')
term.Add('AdminSetHealth', '# has set #\'s health to #.')
term.Add('AdminSetYourHealth', '# has set your health to #.')
term.Add('AdminSetArmor', '# has set #\'s armor to #.')
term.Add('AdminSetYourArmor', '# has set your armor to #.')
term.Add('AdminSetSpeed', '# has set #\'s run speed to #.')
term.Add('AdminSetYourSpeed', '# has set your run speed to #.')
term.Add('AdminSetWalkSpeed', '# has set #\'s walk speed to #.')
term.Add('AdminSetYourWalkSpeed', '# has set your walk speed to #.')
term.Add('AdminSetJump', '# has set #\'s jump power to #.')
term.Add('AdminSetYourJump', '# has set your jump power to #.')
term.Add('WepDoesNoDmg', '#\'s weapon does no damage or is invalid.')
term.Add('AdminSetWepDmg', '# has set #\'s # to # damage.')
term.Add('AdminSetYourWepDMG', '# has set your # to # damage.')
term.Add('EventDoorNotSet', 'This map has no event door!')
term.Add('EventDoorActivity', '# has # the event door!')
term.Add('AdminStartedEventVote', '# has begun voting for an event.')
term.Add('AdminToggledNametag', '# has # #\'s nametag.')
term.Add('AdminGhosted', '# has # #.')
term.Add('AdminGhostedYou', '# has # you.')
term.Add('AdminUnGhostedAll', '# has unghosted all players.')
term.Add('NoGhostedPlayers', 'No players are ghosted.')
term.Add('AdminToggledYourNametag', '# has # your nametag.')
term.Add('AdminResetNametags', '# has unhidden all nametags.')
term.Add('NoHiddenNametags', 'No players have hidden nametags.')
term.Add('AdminScaledPlayer', '# has scaled #\'s size to #%.')
term.Add('AdminScaledYou', '# has scaled your size to #%.') -- please kys king, this is cancer.
term.Add('ToggleNPCNoTarget', 'NPC no target is # for #')
term.Add('PlayerIsWatcherBanned', '# is blacklisted from becoming a Sit Watcher.')
term.Add('PlayerIsNotWatcherBanned', '# is not blacklisted from becoming a Sit Watcher.')
term.Add('PlayerIsAlreadyWatcherBanned', '# is already blacklisted from becoming a Sit Watcher.')
term.Add('AdminWatcherBanned', '# has blacklisted # from becoming a Sit Watcher.')
term.Add('AdminWatcherUnbanned', '# has unblacklisted # from becoming a Sit Watcher.')
term.Add('AdminWatcherBannedYou', '# has blacklisted you from becoming a Sit Watcher.')
term.Add('AdminWatcherUnbannedYou', '# has unblacklisted you from becoming a Sit Watcher.')
term.Add('WeaponNotFound', '# is not a valid weapon!')

if SERVER then
	hook('OnEntityCreated', 'ba.darkrp.OnEntityCreated', function(ent)
		ent.GoCmdCreationTime = CurTime()
	end)
end

ba.AddCommand('ResetName', function(pl, args)
	args.target:SetRPName(rp.names.Random())

	ba.notify_staff(term.Get('AdminResetName'), pl, args.target)
	ba.notify(args.target, term.Get('AdminResetYourName'), pl)
end)
:AddParam('player_entity', 'target')
:SetHelp('Resets a players RP name')
:SetFlag 'D'

ba.AddCommand('Reset Job', function(pl, targ)
	targ:SetNetVar('job', nil)

	ba.notify_staff(term.Get('AdminResetJob'), pl, targ)
	ba.notify(targ, term.Get('AdminResetYourJob'), pl)
end)
:AddParam('player_entity', 'target')
:SetHelp('Resets a players custom job name')
:SetFlag 'A'

ba.AddCommand('Go', function(pl)
	local ent = pl:GetEyeTrace().Entity
	local owner = ent:CPPIGetOwner() or ent.ItemOwner
	if IsValid(ent) and IsValid(owner) then
		ba.notify(pl, term.Get('EntityOwnedBy'), owner, (ent.PrintName and (ent.PrintName ~= '')) and ent.PrintName or ent:GetClass(), ent.GoCmdCreationTime and ba.str.FormatTime(CurTime() - ent.GoCmdCreationTime) or 'Unknown')
	else
		ba.notify_err(pl, term.Get('EntityNoOwner'))
	end
end)
:SetHelp 'Shows the owner of a prop'

ba.AddCommand('Unown', function(pl)
	local ent = pl:GetEyeTrace().Entity
	if IsValid(ent) and ent:IsDoor() and ent:IsPropertyOwned() then
		ba.notify(ent:GetPropertyOwner(), term.Get('AdminUnownedYourDoor'), pl)
		ba.notify_staff(term.Get('AdminUnownedPlayerDoor'), pl, ent:GetPropertyOwner())
		ent:GetPropertyOwner():SellProperty(true, false)
	else
		ba.notify_err(pl, term.Get('CannotUnown'))
	end
end)
:SetFlag 'M'
:SetHelp 'Force unowns a property'

local function searchJobs(name)
	name = name:lower()

	local jobs = table.FilterCopy(rp.teams, function(v)
		return string.find(v.name:lower(), name)
	end)

	local job = jobs[1]
	for k, v in ipairs(jobs) do
		if (v.name:lower() == name) then
			job = v
			break
		end
	end

	return job
end


ba.AddCommand('Set Job', function(pl, target, name)
	local job = searchJobs(name)

	if job then
		ba.notify(target, term.Get('AdminChangedYourJob'), pl, job.name)
		ba.notify_staff(term.Get('AdminChangedPlayerJob'), pl, target, job.name)
		if (not target:Alive()) then
			target:Spawn()
		end
		target.JobBeingForced = true
		target:ChangeTeam(job.team, true)
		target:Spawn()
		target.JobBeingForced = nil
		return
	end

	return ba.NOTIFY_ERROR, term.Get('JobNotFound'), name
end)
:AddParam('player_entity', 'target')
:AddParam('string', 'name')
:SetFlag 'A'
:SetHelp 'Forces a players job'


ba.AddCommand('SitWatcher', function(pl, args)
	local sid64 = args.target:SteamID64()

	rp._Cache:Get('WatcherBans:' .. sid64, function(redis, val)
		if (tobool(val)) then
			ba.notify(pl, term.Get('PlayerIsWatcherBanned'), args.target)
			return
		end

		ba.notify(args.target, term.Get('AdminChangedYourJob'), pl, 'Sit Watcher')
		ba.notify_staff(term.Get('AdminChangedPlayerJob'), pl, args.target, 'Sit Watcher')

		if (not args.target:Alive()) then
			args.target:Spawn()
		end

		args.target.JobBeingForced = true
		args.target.CalledFromSitwatcherCommand = true
		args.target:ChangeTeam(TEAM_WATCHER, true)
		args.target:Spawn()
		args.target.CalledFromSitwatcherCommand = nil
		args.target.JobBeingForced = nil
	end)
end)
:AddParam('player_entity', 'target')
:SetFlag 'A'
:SetHelp 'Sets a player to the Sit Watcher role'


ba.AddCommand('Force Unwant', function(pl, target)
	if target:IsWanted() then
		ba.notify(target, term.Get('AdminUnwantedYou'), pl)
		ba.notify_staff(term.Get('AdminUnwantedPlayer'), pl, target)
		target:UnWanted(pl, false)
	else
		return ba.NOTIFY_ERROR, term.Get('PlayerNotWanted'), target
	end
end)
:AddParam('player_entity', 'target')
:SetFlag 'A'
:SetHelp 'Force unwants a player'
:AddAlias 'funwant'


ba.AddCommand('Force Arrest', function(pl, target, time)
	if time and (time > rp.cfg.ArrestTime) then
		return ba.NOTIFY_ERROR, term.Get('ArrestTooLong'), string.FormatTime(rp.cfg.ArrestTime)
	end

	if (not target:IsArrested()) then
		target:Arrest(nil, 'Staff Force Arrest', time)
		ba.notify(target, term.Get('AdminArrestedYou'), pl)
		ba.notify_staff(term.Get('AdminArrestedPlayer'), pl, target, string.FormatTime(time))
	else
		return ba.NOTIFY_ERROR, term.Get('PlayerArrested'), target
	end
end)
:AddParam('player_entity', 'target')
:AddParam(cmd.TIME)
:SetFlag 'M'
:SetHelp 'Force arrests a player'
:AddAlias 'farrest'

ba.AddCommand('Force Unarrest', function(pl, target)
	if target:IsArrested() then
		ba.notify(target, term.Get('AdminUnarrestedYou'), pl)
		ba.notify_staff(term.Get('AdminUnarrestedPlayer'), pl, target)
		target:UnArrest(pl, false)
	else
		return ba.NOTIFY_ERROR, term.Get('PlayerNotArrested'), target
	end
end)
:AddParam('player_entity', 'target')
:SetFlag 'A'
:SetHelp 'Force unarrests a player'
:AddAlias 'funarrest'


ba.AddCommand('Force UnWarrant', function(pl, target)
	if target:IsWarranted() then
		ba.notify(target, term.Get('AdminUnwarrantedYou'), pl)
		ba.notify_staff(term.Get('AdminUnwarrantedPlayer'), pl, target)
		target:UnWarrant(pl)
	else
		return ba.NOTIFY_ERROR, term.Get('PlayerNotWarranted'), target
	end
end)
:AddParam('player_entity', 'target')
:SetFlag 'A'
:SetHelp 'Force unwants a player'
:AddAlias 'funwarrant'


ba.AddCommand('Start Event', function(pl, args)
	args.event = string.lower(args.event)
	if (rp.Events[args.event] == nil) then
		return ba.NOTIFY_ERROR, term.Get('EventInvalid'), args.event
	else
		local tblEvent = rp.Events[args.event]

		if rp.EventIsRunning(tblEvent.NiceName) then
			ba.notify_all(term.Get('AdminExtendedEvent'), pl, args.event, string.FormatTime(args.time))
		else
			ba.notify_all(term.Get( 'AdminStartedEvent'), pl, args.event, string.FormatTime(args.time))
		end

		rp.StartEvent(args.event, args.time)

	end
end)
:AddParam('string', 'event')
:AddParam('time', 'time')
:SetFlag 'G'
:SetHelp 'Starts an event'

ba.AddCommand('Event Door', function(pl, openOrClose)
	if (rp.cfg.EventDoorEnt) then
		openOrClose = openOrClose:lower()
		doOpen = openOrClose[1] == 'o'

		if (rp.cfg.EventDoorEnt:GetClass() == 'prop_dynamic') then
			rp.cfg.EventDoorEnt:Fire('SetAnimation', doOpen and 'open' or 'close')
		else
			rp.cfg.EventDoorEnt:Fire(doOpen and 'Open' or 'Close', 0, 0)
		end

		ba.notify_all(term.Get('EventDoorActivity'), pl, doOpen and 'opened' or 'closed')
	else
		return ba.NOTIFY_ERROR, term.Get('EventDoorNotSet')
	end
end)
:AddParam('string', 'string')
:SetFlag 'D'
:SetHelp 'Opens or closes the event door'

ba.AddCommand('Event Vote', function(pl, job)
	local t
	if job then
		t = searchJobs(job)

		if (not t) then
			return ba.NOTIFY_ERROR, term.Get('JobNotFound'), job
		end
	end

	local pos = pl:GetEyeTrace().HitPos

	rp.question.Create('Do you want to participate in an event?' .. (t and ' WARNING: Your job will be changed.' or ''), 30, 'event', function(pl, answer)
		if (answer) then
			if t and (pl:Team() ~= t.team) then
				pl:ChangeTeam(t.team, true)
			end

			pl:SetPos(util.FindEmptyPos(pos))
		end
	end, nil, table.Filter(player.GetAll(), function(v) return !v:IsArrested() and !v:IsJailed() and v != pl end))

	ba.notify_all(term.Get('AdminStartedEventVote'), pl)
end)
:AddParam(cmd.STRING, cmd.OPT_OPTIONAL)
:SetFlag 'D'
:SetHelp 'Starts an event vote and teleports people that vote \'yes\' to where you were looking. Also sets their jobs if a job name is supplied.'

ba.AddCommand('Freeze Props', function(pl, target)
	if IsValid(target) then
		ba.notify_staff(term.Get('AdminFrozePlayersProps'), pl, target)

		rp.pp.FreezeProps(table.Filter(ents.GetAll(), function(v)
			return (v:CPPIGetOwner() == target) or (v.ItemOwner == target)
		end))
	else
		ba.notify_staff(term.Get('AdminFrozeAllProps'), pl)
		rp.pp.FreezeProps()
	end
end)
:AddParam('player_entity', 'target')
:SetFlag 'A'
:SetHelp 'Freezes all props'

ba.AddCommand('Deny Vote', function(pl, target)
	if (not rp.question.Exists('demote.' .. target:SteamID())) then
		ba.notify_err(pl, term.Get('PlayerVoteInvalid'), target)
	else
		rp.question.Destroy('demote.' .. target:SteamID(), true)
		target.IsBeingDemoted = nil
		ba.notify_staff(term.Get('AdminDeniedVote'), pl, target)
	end
end)
:AddParam('player_entity', 'target')

:SetFlag 'M'
:SetHelp 'Denies a vote for the target'

ba.AddCommand('Deny Team Vote', function(pl, target)
	if (!rp.teamVote.Votes[target]) then
		ba.notify_err(pl, term.Get('PlayerVoteInvalid'), target)
	else
		rp.teamVote.Votes[target] = nil
		for k, v in ipairs(rp.teams) do
			if (v.name == target) then
				if (v.CurVote) then
					for k, v in ipairs(v.CurVote.Players) do
						if (IsValid(v)) then
							v:AddMoney(rp.cfg.CampaignFee)
						end
					end
					v.CurVote = nil
				end
			end
		end
		ba.notify_staff(term.Get('AdminDeniedTeamVote'), pl, target)
	end
end)
:AddParam('string', 'string')

:SetFlag 'M'
:SetHelp 'Denies a team vote'

ba.AddCommand('Shop')
:RunOnClient(function()
	ba.ui.OpenAuthLink(rp.cfg.CreditsURL)
end)
:SetFlag 'U'
:SetHelp 'Opens our credit shop'
:AddAlias 'donate'


ba.AddCommand('Add Money', function(pl, args)
	args.target:AddMoney(tonumber(args.amount))

	ba.notify(args.target, term.Get('AdminAddedYourMoney'), pl, args.amount)
	ba.notify(pl, term.Get('AdminAddedMoney'), args.amount, args.target)
end)
:AddParam('player_entity', 'target')
:AddParam('string', 'amount')
:SetFlag '*'
:SetHelp 'Gives a player money'

ba.AddCommand('Add Credits', function(pl, args)
	local isValid = IsValid(pl)
	args.note = args.note or ('Given by ' .. (isValid and pl:NameID() or 'Console'))

	if isplayer(args.target) then
		args.target:AddCredits(args.amount, args.note, function()
			ba.notify(args.target, term.Get('AdminAddedYourCredits'), pl, args.amount)
		end)
	else
		rp.data.AddCredits(ba.InfoTo32(args.target), args.amount, args.note)
	end

	if isValid then
		ba.notify(pl, term.Get('AdminAddedCredits'), args.amount, args.target)
	end
end)
:AddParam('player_entity', 'target')
:AddParam('string', 'amount')
:AddParam('string', 'string')
:SetFlag '*'
:SetHelp 'Gives a player credits'


ba.AddCommand('View Pocket', function(pl, args)
	rp.pocket.Inspect(pl, args.target)
end)
:AddParam('player_entity', 'target')
:SetFlag 'A'
:SetHelp 'Displays the target\'s pocket contents on your screen'

local setHealth = ENTITY._SetHealth or ENTITY.SetHealth
ba.AddCommand('SetHealth', function(pl, args)
	setHealth(args.target, args.health)

	ba.notify_staff(term.Get('AdminSetHealth'), pl, args.target, args.health)
	ba.notify(args.target, term.Get('AdminSetYourHealth'), pl, args.health)
end)
:AddParam('player_entity', 'target')
:AddParam('string', 'health')
:SetFlag 'G'
:SetHelp 'Sets a player\'s health'

ba.AddCommand('Set Armor', function(pl, args)
	args.target:SetArmor(args.armor)

	ba.notify_staff(term.Get('AdminSetArmor'), pl, args.target, args.armor)
	ba.notify(args.target, term.Get('AdminSetYourArmor'), pl, args.armor)
end)
:AddParam('player_entity', 'target')
:AddParam('string', 'armor')
:SetFlag 'G'
:SetHelp 'Sets a player\'s health'


ba.AddCommand('Set Run Speed', function(pl, args)
	args.target:SetRunSpeed(args.speed)

	ba.notify_staff(term.Get('AdminSetSpeed'), pl, args.target, args.speed)
	ba.notify(args.target, term.Get('AdminSetYourSpeed'), pl, args.speed)
end)
:AddParam('player_entity', 'target')
:AddParam('string', 'speed')
:SetFlag 'G'
:SetHelp 'Sets a player\'s run speed'

ba.AddCommand('Set Walk Speed', function(pl, args)
	args.target:SetWalkSpeed(args.speed)

	ba.notify_staff(term.Get('AdminSetWalkSpeed'), pl, args.target, args.speed)
	ba.notify(args.target, term.Get('AdminSetYourWalkSpeed'), pl, args.speed)
end)
:AddParam('player_entity', 'target')
:AddParam('string', 'speed')
:SetFlag 'G'
:SetHelp 'Sets a player\'s walk speed'

ba.AddCommand('Set Jump Height', function(pl, args)
	args.target:SetJumpPower(args.height)

	ba.notify_staff(term.Get('AdminSetJump'), pl, args.target, args.height)
	ba.notify(args.target, term.Get('AdminSetYourJump'), pl, args.height)
end)
:AddParam('player_entity', 'target')
:AddParam('string', 'height')
:SetFlag 'G'
:SetHelp 'Sets a player\'s jump power'

ba.AddCommand('Set Weapon Damage', function(pl, target, dmg)
	local wep = target:GetActiveWeapon()

	if IsValid(wep) and isnumber(wep.Damage) then
		wep.Damage = dmg
	elseif IsValid(wep) and wep.Primary and isnumber(wep.Primary.Damage) then
		wep.Primary.Damage = dmg
	else
		ba.notify_err(target, term.Get('WepDoesNoDmg'), target)
		return
	end

	ba.notify_staff(term.Get('AdminSetWepDmg'), pl, target, wep.PrintName or wep:GetClass(), dmg)
	ba.notify(target, term.Get('AdminSetYourWepDMG'), pl, wep.PrintName or wep:GetClass(), dmg)
end)
:AddParam('player_entity', 'target')
:AddParam(cmd.NUMBER)
:SetFlag 'G'
:SetHelp 'Sets a player\'s weapon damage'

if SERVER then
	function PLAYER:SetGhosted(b)
		self.ghosted = b
		self:DrawShadow(not b)
		self:DrawWorldModel(not b)
		self:SetRenderMode(b and RENDERMODE_NONE or RENDERMODE_NORMAL)
		self:SetCollisionGroup(b and COLLISION_GROUP_WORLD or COLLISION_GROUP_PLAYER)
		self:SetNetVar('HideNameTag', b)
	end

	function PLAYER:ToggleGhost()
		self:SetGhosted(not self.ghosted)
	end

	function PLAYER:IsGhosted()
		return (self.ghosted == true)
	end
end

ba.AddCommand('Ghost', function(pl, target)
	target = IsValid(target) and target or pl

	local ghosted = target:IsGhosted() and 'unghosted' or 'ghosted'

	target:ToggleGhost()

	ba.notify_staff(term.Get('AdminGhosted'), pl, ghosted, target)
	ba.notify(target, term.Get('AdminGhostedYou'), pl, ghosted)
end)
:AddParam('player_entity', 'target')
:SetFlag 'G'
:SetHelp 'Makes you invisible'


ba.AddCommand('Reset Ghosts', function(pl)
	local notify = false

	for k, v in ipairs(player.GetAll()) do
		if v:IsGhosted() then
			notify = true
			v:ToggleGhost()
		end
	end

	if (notify) then
		ba.notify_staff(term.Get('AdminUnGhostedAll'), pl)
	else
		return ba.NOTIFY_ERROR, term.Get('NoGhostedPlayers')
	end
end)
:SetFlag 'G'
:SetHelp 'Unhides all players\' nametags'


ba.AddCommand('Toggle Nametag', function(pl, args)
	local hidden = args.target:GetNetVar('HideNameTag')

	if (hidden) then hidden = nil
	else hidden = true end

	args.target:SetNetVar('HideNameTag', hidden)

	ba.notify_staff(term.Get('AdminToggledNametag'), pl, hidden and 'hidden' or 'unhidden', args.target)
	ba.notify(args.target, term.Get('AdminToggledYourNametag'), pl, hidden and 'hidden' or 'unhidden')
end)
:AddParam('player_entity', 'target')
:SetFlag 'G'
:SetHelp 'Toggles a player\'s nametag on or off'
:AddAlias 'togglent'

ba.AddCommand('Reset Nametags', function(pl)
	local notify = false

	for k, v in ipairs(player.GetAll()) do
		if v:GetNetVar('HideNameTag') and (not v:IsGhosted()) then
			notify = true

			v:SetNetVar('HideNameTag', nil)
		end
	end

	if (notify) then
		ba.notify_staff(term.Get('AdminResetNametags'), pl)
	else
		return ba.NOTIFY_ERROR, term.Get('NoHiddenNametags')
	end
end)
:SetFlag 'G'
:SetHelp 'Unhides all players\' nametags'

ba.AddCommand('Scale Player', function(pl, args)
	size = math.Clamp(args.size, 0.01, 30)
	args.target:SetModelScale(args.size, 1)
	size = Vector(args.size, args.size, args.size)

	local bones = {
		args.target:LookupBone('ValveBiped.Bip01_Head1'),
		args.target:LookupBone('ValveBiped.Bip01_Spine'),
		args.target:LookupBone('ValveBiped.Bip01_R_Thigh'),
		args.target:LookupBone('ValveBiped.Bip01_R_Calf'),
		args.target:LookupBone('ValveBiped.Bip01_L_Thigh'),
		args.target:LookupBone('ValveBiped.Bip01_L_Calf'),
		args.target:LookupBone('ValveBiped.Bip01_R_Foot'),
		args.target:LookupBone('ValveBiped.Bip01_L_Foot'),
		args.target:LookupBone('ValveBiped.Bip01_R_Hand'),
		args.target:LookupBone('ValveBiped.Bip01_L_Hand'),
		args.target:LookupBone('ValveBiped.Bip01_R_Forearm'),
		args.target:LookupBone('ValveBiped.Bip01_L_Forearm')
	}

	for k, v in pairs(bones) do
		args.target:ManipulateBoneScale(v, size)
	end

	ba.notify_staff(term.Get('AdminScaledPlayer'), pl, args.target, size.x * 100)
	ba.notify(args.target, term.Get('AdminScaledYou'), pl, size.x * 100)
end)
:AddParam('player_entity', 'target')
:AddParam('string', 'size')
:SetFlag 'G'
:SetHelp 'Sets a player\'s scale (1 is default)'

ba.AddCommand('notarget', function(pl, args)
	if (not IsValid(args.target)) then
		return
	end

	local notarget = not args.target:IsFlagSet(FL_NOTARGET)
	args.target:SetNoTarget(notarget)

	ba.notify(pl, term.Get('ToggleNPCNoTarget'), notarget and 'enabled' or 'disabled', args.target)
end)
:AddParam('player_entity', 'target')
:SetHelp('Toggles no target. This means NPCs cannot interact/attack the target you specify.')
:SetFlag 'G'

local color_event = Color(5, 252, 252)
local color_event_text = Color(245, 245, 200)
chat.Register 'EventMessage'
	:Write(function(self, msg)
		net.WriteString(msg)
	end)
	:Read(function()
		local msg = net.ReadString()
		CHATBOX.DoEmotes = true
		return color_event, ':information_source: [Event Message] ', color_event_text, msg
	end)

ba.AddCommand('eventmessage', function(pl, args)
	chat.Send('EventMessage', args.text)
end)
:AddParam('string', 'text')
:AddAlias('em')
:SetHelp('Sends an event message to all players in chat')
:SetFlag 'D'

local UpdateEntityStats, SetEntityStats, ResetEntityStats
if SERVER then

	function UpdateEntityStats(pl, ent)
		local overrides = pl.spawnstats and pl.spawnstats[ent:GetClass()] or {}

		if overrides.health then
			ent:SetHealth(overrides.health)
		end

		ent.statdamagescaled = overrides.damage
	end
	hook('PlayerSpawnedNPC', 'rp.npctools.PlayerSpawnedNPC', UpdateEntityStats)

	hook('EntityTakeDamage', 'rp.npctools.EntityTakeDamage', function(pl, dmg)
		local attacker = dmg:GetAttacker()

		if IsValid(attacker) and attacker.statdamagescaled then
			local dmgnum = dmg:GetDamage()
			dmg:SetDamage(dmgnum * (attacker.statdamagescaled or 1))
		end
	end)

	function SetEntityStats(pl, class, key, value, setNow)
		pl.spawnstats = pl.spawnstats or {}
		pl.spawnstats[class] = pl.spawnstats[class] or {}
		pl.spawnstats[class][key] = value

		if setNow then
			for _, ent in ipairs(ents.FindByClass(class)) do
				if (ent:CPPIGetOwner() == pl) then
					UpdateEntityStats(pl, ent)
				end
			end
		end
	end

	function ResetEntityStats(pl, class, key)
		if pl.spawnstats[class] then
			pl.spawnstats[class][key] = nil
		end
	end
end

ba.AddCommand('npcresetall', function(pl)
	pl.spawnstats = {}
end)
:SetHelp('Resets all NPC stats to default')
:SetFlag 'G'

ba.AddCommand('setnpchealth', function(pl, class, health)
	SetEntityStats(pl, class, 'health', math.Clamp(health, 1, 15000))
end)
:AddParam(cmd.STRING)
:AddParam(cmd.NUMBER)
:SetHelp('Sets the npc health of a specific class. This works for base classes too. From 1 to 15000.')
:SetFlag 'G'

ba.AddCommand('setnpchealthupdate', function(pl, class, health)
	SetEntityStats(pl, class, 'health', math.Clamp(health, 1, 15000), true)
end)
:AddParam(cmd.STRING)
:AddParam(cmd.NUMBER)
:SetHelp('Sets the npc health of a specific class and all currently spawned npcs of that class. This works for base classes too. From 1 to 15000.')
:SetFlag 'G'

ba.AddCommand('setnpcdamage', function(pl, class, damage)
	SetEntityStats(pl, class, 'damage', math.Clamp(damage, 1, 15000))
end)
:AddParam(cmd.STRING)
:AddParam(cmd.NUMBER)
:SetHelp('Sets the npc damage scale of a specific class. This works for base classes too. From 1 to 15000.')
:SetFlag 'G'

ba.AddCommand('setnpcdamageupdate', function(pl, class, damage)
	SetEntityStats(pl, class, 'damage', math.Clamp(damage, 1, 15000), true)
end)
:AddParam(cmd.STRING)
:AddParam(cmd.NUMBER)
:SetHelp('Sets the npc damage scale of a specific class and all currently spawned npcs of that class. This works for base classes too.')
:SetFlag 'G'

ba.AddCommand('resetnpchealth', function(pl, class)
	ResetEntityStats(pl, class, 'health')
end)
:AddParam(cmd.STRING)
:SetHelp('Resets npc health')
:SetFlag 'G'

ba.AddCommand('resetnpcdamage', function(pl, class)
	ResetEntityStats(pl, class, 'damage')
end)
:AddParam(cmd.STRING)
:SetHelp('Resets npc damage')
:SetFlag 'G'

ba.AddCommand('giveweapon', function(pl, args)
	if (not weapons.GetStored(args.class)) then
		return NOTIFY_ERROR, term.Get('WeaponNotFound'), args.class
	end

	args.target:Give(args.class)
	args.target:SelectWeapon(args.class)
end)
:AddParam('player_entity', 'target')
:AddParam('string', 'class')
:SetHelp('Gives a player a weapon')
:SetFlag 'G'

ba.AddCommand('giveammo', function(pl, args)
	args.targ:GiveAmmos(1000, true)
	args.targ:GiveAmmo(1000, 'AR2AltFire', true)
	args.targ:GiveAmmo(1000, 'SMG1_Grenade', true)
	args.targ:GiveAmmo(1000, 'AR2', true)
	args.targ:GiveAmmo(1000, 'SMG1', true)
end)
:AddParam('player_entity', 'targ')
:SetHelp('Gives a player ammos')
:SetFlag 'G'

ba.AddCommand('setgravity', function(pl, args)
	args.target:SetGravity(math.Clamp(args.gravity, 0.01, 10))
end)
:AddParam('player_entity', 'target')
:AddParam('string', 'gravity')
:SetHelp('Sets a players gravity (0.01-1)')
:SetFlag 'G'



if (CLIENT) then
	hook('HUDShouldDraw', function(name, pl)
		if (name == 'PlayerDisplay') then
			return !pl:GetNetVar('HideNameTag')
		end
	end)
end