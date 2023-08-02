-- laws
util.AddNetworkString('rp.SendLaws')

rp.AddCommand('laws', function(pl)
	if not pl:IsMayor() then
		rp.Notify(pl, NOTIFY_ERROR, term.Get('MustBeMayorSetLaws'))
		return
	end

	pl:ConCommand('LawEditor')

	return
end)

function rp.resetLaws(pl)
	if (pl ~= nil) and not pl:IsMayor() then
		rp.Notify(pl, NOTIFY_ERROR, term.Get('MustBeMayorResetLaws'))
		return
	end
	
	nw.SetGlobal('TheLaws', nil)

	hook.Call('mayorResetLaws', GAMEMODE, pl)

	return
end
rp.AddCommand('resetlaws', rp.resetLaws)

net('rp.SendLaws', function(len, pl)
	if not pl:IsMayor() then return end

	local str = net.ReadString()
	if string.len(str) >= 26 * 10 then
		pl:ChatPrint('Текст закона слишком короткий.')
		return
	end

	hook.Call('mayorSetLaws', GAMEMODE, pl)

	nw.SetGlobal('TheLaws', str)
end)


local LotteryPeople = {}
local LotteryON = false
local LotteryAmount = 0
local CanLottery = CurTime()
local lottoStarter
local function EnterLottery(answer, ent, initiator, target, TimeIsUp)
	if tobool(answer) and not table.HasValue(LotteryPeople, target) then
		if not target:CanAfford(LotteryAmount) then
			rp.Notify(target, NOTIFY_ERROR, term.Get('CannotAfford'))
			return
		end
		table.insert(LotteryPeople, target)
		target:AddMoney(-LotteryAmount)
		rp.Notify(target, NOTIFY_SUCCESS, term.Get('InLottery'), rp.FormatMoney(LotteryAmount))
	elseif answer ~= nil and not table.HasValue(LotteryPeople, target) then
		rp.Notify(target, NOTIFY_GENERIC, term.Get('NotInLottery'))
	end

	if TimeIsUp then
		LotteryON = false
		CanLottery = CurTime() + 300
		if table.Count(LotteryPeople) == 0 then
			rp.NotifyAll(NOTIFY_GENERIC, term.Get('NoLotteryAll'))
			return
		end

		if (#LotteryPeople > 1) then
			local chosen 	= LotteryPeople[math.random(1, #LotteryPeople)]
			local amount 	= (#LotteryPeople * LotteryAmount)
			local tax 		= amount * 0.05

			chosen:AddMoney(amount - tax)
			if IsValid(lottoStarter) then
				lottoStarter:AddMoney(tax)
				rp.Notify(lottoStarter, NOTIFY_SUCCESS, term.Get('LotteryTax'), rp.FormatMoney( tax))
			end
			rp.NotifyAll(NOTIFY_SUCCESS, term.Get('LotteryWinner'), chosen, rp.FormatMoney(amount - tax))
		else
			local ret = LotteryPeople[1]
			if IsValid(ret) then
				ret:AddMoney(LotteryAmount)
				rp.Notify(ret, NOTIFY_ERROR, term.Get('NoLottery'))
			end
			if IsValid(lottoStarter) then
				rp.Notify(lottoStarter, NOTIFY_ERROR, term.Get('NoLotteryTax'))
			end
		end
	end
end

local function DoLottery(ply, amount)
	if not ply:IsMayor() then
		rp.Notify(ply, NOTIFY_ERROR, term.Get('IncorrectJob'))
		return
	end

	if #player.GetAll() <= 2 or LotteryON then
		rp.Notify(ply, NOTIFY_ERROR, term.Get('CannotLottery'))
		return
	end

	if CanLottery > CurTime() then
		rp.Notify(ply, NOTIFY_ERROR, term.Get('LottoCooldown'), math.Round(CanLottery - CurTime()))
		return
	end

	amount = tonumber(amount)
	if not amount then
		rp.Notify(ply, NOTIFY_GENERIC, term.Get('LottoCost'), rp.cfg.MinLotto, rp.cfg.MaxLotto)
		return
	end

	lottoStarter = ply
	LotteryAmount = math.Clamp(math.floor(amount), rp.cfg.MinLotto, rp.cfg.MaxLotto)

	hook.Call('lotteryStarted', GAMEMODE, ply)

	rp.NotifyAll(NOTIFY_GENERIC, term.Get('LotteryStarted'))

	LotteryON = true
	LotteryPeople = {}
	table.foreach(player.GetAll(), function(k, v)
		if v ~= ply then
			GAMEMODE.ques:Create('Проводится лотерея!\nУчаствовать за ' .. rp.FormatMoney(LotteryAmount) .. '?', 'lottery'..tostring(k), v, 30, EnterLottery, ply, v)
		end
	end)
	timer.Create('Lottery', 30, 1, function() EnterLottery(nil, nil, nil, nil, true) end)
	return
end
rp.AddCommand('lottery', DoLottery)
:AddParam(cmd.STRING)

local lstat = false
local wait_lockdown = false

local function WaitLock()
	wait_lockdown = false
	lstat = false
	timer.Destroy('spamlock')
end

function GM:LockdownStarted(pl)
	table.foreach(player.GetAll(), function(k, v)
		v:ConCommand('play ' .. rp.cfg.LockdownSounds .. '\n')
	end)
end

function GM:Lockdown(ply, args)
	if lstat then
		rp.Notify(ply, NOTIFY_ERROR, term.Get('CannotLockdown'))
		return
	end
	if ply:IsMayor() then
		lstat = true
		args = type(args) == 'table' and table.concat(args, ' ') or args
		if not args or args:len() < 1 then
				rp.Notify(ply, NOTIFY_ERROR, 'Вы забыли указать причину комендантского часа!')
			return
		end
		nw.SetGlobal('lockdown', true)
		nw.SetGlobal('lockdown_reason', args)
		nw.SetGlobal('mayorGrace', nil)
		rp.NotifyAll(NOTIFY_ERROR, term.Get('LockdownStarted'))
		hook.Call('LockdownStarted', GAMEMODE, ply, args)
		timer.Create('StopLock', rp.cfg.LockdownTime, 1, function()
			GAMEMODE:UnLockdown(team.GetPlayers(TEAM_MAYOR)[1])
		end)
	else
		rp.Notify(ply, NOTIFY_ERROR, term.Get('IncorrectJob'))
	end
	return
end
rp.AddCommand('lockdown', function(ply, args) GAMEMODE:Lockdown(ply, args) end)
:AddParam(cmd.STRING)

function GM:UnLockdown(ply)
	if not lstat or wait_lockdown then
		rp.Notify(ply, NOTIFY_ERROR, term.Get('CannotUnlockdown'))
		return
	end
	if ply:IsMayor() then
		rp.NotifyAll(NOTIFY_SUCCESS, term.Get('LockdownEnded'))
		wait_lockdown = true
		nw.SetGlobal('lockdown', nil)
		nw.SetGlobal('lockdown_reason', nil)
		timer.Create('spamlock', 300, 1, function() WaitLock('') end)
		timer.Destroy('StopLock')
		hook.Call('LockdownEnded', GAMEMODE, ply)
	else
		rp.Notify(ply, NOTIFY_ERROR, term.Get('IncorrectJob'))
	end
	return
end
rp.AddCommand('unlockdown', function(ply) GAMEMODE:UnLockdown(ply) end)

hook('OnPlayerChangedTeam', 'mayorgrace.OnPlayerChangedTeam', function(pl, before, after)
	if (rp.teams[after].mayor == true) then
		nw.SetGlobal('mayorGrace', CurTime() + 300)
		pl:SetNWInt("graceOn",1)
		timer.Simple(60*5,function() pl:SetNWInt("graceOn",0) end)
	elseif (rp.teams[before].mayor == true) then
		nw.SetGlobal('mayorGrace', nil)
		pl:SetNWInt("graceOn",0)
	end
end)

local function GiveLicense(ply)
	if not ply:IsMayor() then
        	rp.Notify(ply, NOTIFY_ERROR, 'Неправильная работа для /givelicense')
        return
    end

    local LookingAt = ply:GetEyeTrace().Entity
    if not IsValid(LookingAt) or not LookingAt:IsPlayer() or LookingAt:GetPos():DistToSqr(ply:GetPos()) > 10000 then
			rp.Notify(ply, NOTIFY_ERROR, 'Вам нужно смотреть на игрока')
        return
    end

	rp.Notify(LookingAt, 0, ply:Nick() .. ' дал ' .. LookingAt:Nick() .. ' лицензию')
	rp.Notify(ply, 0, ply:Nick() .. ' дал ' .. LookingAt:Nick() .. ' лицензию')

    LookingAt:SetNetVar('HasGunlicense', true)

    return
end
rp.AddCommand('givelicense', GiveLicense)

-- Demote classes upon death
hook('PlayerDeath','DemoteOnDeath',function(v, k)
	if (v:Team() == TEAM_MAYOR) then
		GAMEMODE:UnLockdown(v)
		nw.SetGlobal('mayorGrace', nil)
		rp.resetLaws()
		v:ChangeTeam(1, true)
		v:TeamBan(TEAM_MAYOR, 180)
		rp.FlashNotifyAll('Новости', term.Get('MayorHasDied'))
	end
end)