util.AddNetworkString('PlayerDisguise')
util.AddNetworkString('rp.SelectModel')

net.Receive("rp.SelectModel", function(_, p)
    local args = net.ReadString()

    if args then
        p:SetVar('Model', string.lower(args))
    end
end)

function PLAYER:Disguise(t, time)
	if not self:Alive() then return end
	if (rp.teams[t].nodisguise == true) then return end
	self:SetNetVar('DisguiseTeam', t)
	self:SetNetVar('DisguiseTime', CurTime() + time)
	if self:GetNetVar('job') then
		self:SetNetVar('job', nil)
	end
	self:SetModel(team.GetModel(t))
	if (time) then
		rp.Notify(self, NOTIFY_SUCCESS, term.Get('NowDisguisedTime'), math.Round(time/60, 0), rp.teams[t].name)
	else
		rp.Notify(self, NOTIFY_SUCCESS, term.Get('NowDisguised'), rp.teams[t].name)
	end
	hook.Call('playerDisguised', GAMEMODE, self, self:Team(), t)
	if not time then return end
	timer.Create('Disguise_' .. self:UniqueID(), time, 1, function()
		if not IsValid(self) then return end
		self:SetNetVar('DisguiseTeam', nil)
		self:SetNetVar('DisguiseTime', nil)
		if self:GetNetVar('job') then
			self:SetNetVar('job', nil)
		end
		GAMEMODE:PlayerSetModel(self)
		rp.Notify(self, NOTIFY_ERROR, term.Get('DisguiseWorn'))
		hook.Call('PlayerUnDisguised', GAMEMODE, self, t, self:Team())
	end)
end

function PLAYER:UnDisguise()
	timer.Destroy('Disguise_' .. self:UniqueID())

	hook.Call('PlayerUnDisguised', GAMEMODE, self, self:Team(), self:GetNetVar('DisguiseTeam'))
	self:SetNetVar('DisguiseTeam', nil)
	self:SetNetVar('DisguiseTime', nil)
end

function PLAYER:HirePlayer(pl, cost)
	if pl:GetNetVar('job') then
		pl:SetNetVar('job', nil)
	end
	pl:SetNetVar('Employer', self)
	self:SetNetVar('Employee', pl)

	if cost then
		self:TakeMoney(cost)
		pl:AddMoney(cost)
	else
		self:TakeMoney(pl:GetHirePrice())
		pl:AddMoney(pl:GetHirePrice())
	end
	
	hook.Call('PlayerHirePlayer', GAMEMODE, self, pl)
end

hook('OnPlayerChangedTeam', 'Disguise.OnPlayerChangedTeam', function(pl, prevTeam, t)
	if pl:IsDisguised() then
		pl:UnDisguise()
	end
	if (pl:GetNetVar('Employer') ~= nil) then
		rp.Notify(pl:GetNetVar('Employer'), NOTIFY_ERROR, term.Get('EmployeeChangedJob'))
		rp.Notify(pl, NOTIFY_ERROR, term.Get('EmployeeChangedJobYou'))
		
		pl:GetNetVar('Employer'):SetNetVar('Employee', nil)
		pl:SetNetVar('Employer', nil)
		
	end
end)

net('PlayerDisguise', function(len, pl)
	local t = net.ReadInt(8)
	if (rp.teams[pl:Team()].candisguise or pl:IsCP()) and not (rp.teams[t].admin == 1) and not (rp.teams[t].nodisguise == true) then
		if pl:IsDisguised() or pl.NextDisguise and pl.NextDisguise > CurTime() then 
			rp.Notify(pl, NOTIFY_ERROR, term.Get('DisguiseLimit'), math.ceil((pl.NextDisguise - CurTime())/60))
			return 
		end
		pl:Disguise(t, 300)
		pl.NextDisguise = CurTime() + 600
	end
end)

hook('PlayerDeath', 'teams.PlayerDeath', function(pl)
	if pl:IsDisguised() then
		pl:UnDisguise()
	end
	if (pl:GetNetVar('Employer') ~= nil) then
		rp.Notify(pl:GetNetVar('Employer'), NOTIFY_ERROR, term.Get('EmployeeDied'))
		rp.Notify(pl, NOTIFY_ERROR, term.Get('EmployeeDiedYou'))
		
		pl:GetNetVar('Employer'):SetNetVar('Employee', nil)
		pl:SetNetVar('Employer', nil)
		
	elseif (pl:GetNetVar('Employee') ~= nil) then
		rp.Notify(pl:GetNetVar('Employee'), NOTIFY_ERROR, term.Get('EmployerDied'))
		rp.Notify(pl, NOTIFY_ERROR, term.Get('EmployerDiedYou'))
		
		pl:GetNetVar('Employee'):SetNetVar('Employer', nil)
		pl:SetNetVar('Employee', nil)
	end
end)

hook('PlayerDisconnected', 'employees.PlayerDisconnected', function(pl)
	if (pl:GetNetVar('Employer') ~= nil) then
		rp.Notify(pl:GetNetVar('Employer'), NOTIFY_ERROR, term.Get('EmployeeLeft'))
		
		pl:GetNetVar('Employer'):SetNetVar('Employee', nil)
	elseif (pl:GetNetVar('Employee') ~= nil) then
		rp.Notify(pl:GetNetVar('Employee'), NOTIFY_ERROR, term.Get('EmployerLeft'))
		
		pl:GetNetVar('Employee'):SetNetVar('Employer', nil)
	end
end)

--
-- Commands
--
rp.AddCommand('model', function(pl, args)
	pl:SetVar('Model', string.lower(args))
end)
:AddParam(cmd.STRING)

rp.AddCommand('hire', function(pl, targ, text)	
	if not targ then
		targ = pl:GetEyeTrace().Entity
	end
	
	if not IsValid(targ) or not targ:IsPlayer() then 
		rp.Notify(pl, NOTIFY_ERROR, "Некорректная цель")
		return
	end

	if not targ:IsHirable() then
		rp.Notify(pl, NOTIFY_ERROR, term.Get('PlayerNotHirable'), targ)
		return
	end

	if pl:IsHirable() then
		rp.Notify(pl, NOTIFY_ERROR, term.Get('EmployeeTriedEmploying'))
		return
	end

	if (pl:GetNetVar('Employee') ~= nil) then
		rp.Notify(pl, NOTIFY_ERROR, term.Get('HasEmployee'))
		return
	end

	if (pl:GetNetVar('Employer') ~= nil) then
		rp.Notify(pl, NOTIFY_ERROR, term.Get('AlreadyEmployed'))
		return
	end

	if text and (not pl:CanAfford(text)) or (not pl:CanAfford(targ:GetHirePrice())) then
		rp.Notify(pl, NOTIFY_ERROR, term.Get('CannotAffordEmployee'))
		return
	end
	
	if text and text < 1000 then
		rp.Notify(pl, NOTIFY_ERROR, "Нельзя поставить цену меньше $1.000!")
		return
	end
	
	if text and text > 50000 then
		rp.Notify(pl, NOTIFY_ERROR, "Нельзя поставить цену больше $50.000!")
		return
	end
	
	local moneycost
	if text then
		moneycost = rp.FormatMoney(text)
	else
		moneycost = rp.FormatMoney(targ:GetHirePrice())
	end

	rp.Notify(pl, NOTIFY_GENERIC, term.Get('EmployRequestSent'), targ)
	GAMEMODE.ques:Create('Хотите ли вы работать у ' .. pl:Name() .. ' \nза ' .. moneycost .. '?', "hire" .. pl:UserID(), targ, 30, function(answer)
		if (tobool(answer) == true) and IsValid(pl) and targ:IsHirable() then
			rp.Notify(pl, NOTIFY_SUCCESS, term.Get('YouHired'), targ, moneycost)
			rp.Notify(targ, NOTIFY_SUCCESS, term.Get('YouAreHired'), pl, moneycost)
			if text then
				pl:HirePlayer(targ, text)
			else
				pl:HirePlayer(targ)
			end
		else
			rp.Notify(pl, NOTIFY_ERROR, term.Get('EmployRequestDen'), targ)
		end
	end)
end)
:AddParam(cmd.PLAYER_ENTITY, cmd.OPT_OPTIONAL)
:AddParam(cmd.NUMBER, cmd.OPT_OPTIONAL)

rp.AddCommand('fire', function(pl, targ)
	if not IsValid(targ) or not (targ:GetNetVar('Employer') == pl) then return end

	rp.Notify(pl, NOTIFY_SUCCESS, term.Get('EmployeeFired'), targ)
	rp.Notify(targ, NOTIFY_ERROR, term.Get('EmployeeFiredYou'), pl)

	targ:SetNetVar('Employer', nil)
	pl:SetNetVar('Employee', nil)
end)
:AddParam(cmd.PLAYER_ENTITY)

rp.AddCommand('quitjob', function(pl)
	if not IsValid(pl:GetNetVar('Employer')) then return end

	rp.Notify(pl, NOTIFY_SUCCESS, term.Get('EmployeeQuitYou'), pl:GetNetVar('Employer'))
	rp.Notify(pl:GetNetVar('Employer'), NOTIFY_ERROR, term.Get('EmployeeQuet'), pl)

	pl:GetNetVar('Employer'):SetNetVar('Employee', nil)
	pl:SetNetVar('Employer', nil)
end)

rp.AddCommand('sethireprice', function(pl, num)
	if not tonumber(num) and num then
		rp.Notify(pl, NOTIFY_ERROR, term.Get('InvalidArg'))
		return
	end
	
	if not pl:IsHirable() then
		rp.Notify(pl, NOTIFY_ERROR, "Вы не можете быть наняты!")
		return
	end
	
	if tonumber(num) > 50000 then
		rp.Notify(pl, NOTIFY_ERROR, "Нельзя поставить цену больше $50.000!")
		return
	end
	
	if tonumber(num) < 1000 then
		rp.Notify(pl, NOTIFY_ERROR, "Нельзя поставить цену меньше $1000!")
		return
	end
	
	pl:SetNetVar('EmployeePrice', num)
	rp.Notify(pl, NOTIFY_SUCCESS, "Вы поставили свою цену на: #", rp.FormatMoney(pl:GetHirePrice()))
end)
:AddParam(cmd.NUMBER)
