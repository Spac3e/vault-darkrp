rp.ArrestedPlayers = rp.ArrestedPlayers or {}

function PLAYER:IsWarranted()
	return (self.HasWarrant == true)
end
-----------------------------------------------------------------------------
-- Warrant
-----------------------------------------------------------------------------
function PLAYER:Warrant(actor, reason)
	self.HasWarrant = true
	timer.Simple(rp.cfg.WarrantTime, function()
		if IsValid(self) then
			self:UnWarrant()
		end
	end)
	rp.FlashNotifyAll('Новости', term.Get('Warranted'), actor, reason, (IsValid(actor) and self or 'Авто-ордер'))
	hook.Call('PlayerWarranted', GAMEMODE, self, actor, reason)
end

function PLAYER:UnWarrant(actor)
	rp.NotifyAll(1, term.Get('WarrantExpired'), self)
	self.HasWarrant = nil
	hook.Call('PlayerUnWarranted', GAMEMODE, self, actor)
end
-----------------------------------------------------------------------------
-- Wanted
-----------------------------------------------------------------------------
function PLAYER:Wanted(actor, reason)
	self.CanEscape = nil
	self:SetNetVar('IsWanted', true)
	self:SetNetVar('WantedReason', reason)
	timer.Create('Wanted' .. self:SteamID64(), rp.cfg.WantedTime, 1, function()
		if IsValid(self) then
			self:UnWanted()
		end
	end)
	rp.FlashNotifyAll('Новости', term.Get('Wanted'), self, reason, (IsValid(actor) and actor or 'Авто-розыск'))
	hook.Call('PlayerWanted', GAMEMODE, self, actor, reason)
end

function PLAYER:UnWanted(actor)
	self:SetNetVar('IsWanted', nil)
	self:SetNetVar('WantedReason', nil)
	timer.Destroy('Wanted' .. self:SteamID64())

	hook.Call('PlayerUnWanted', GAMEMODE, self, actor)
end
-----------------------------------------------------------------------------
-- Arrest
-----------------------------------------------------------------------------
local jails = rp.cfg.JailPos[game.GetMap()]
function PLAYER:Arrest(actor, reason)
	local time = rp.cfg.ArrestTime
	timer.Create('Arrested' .. self:SteamID64(), time, 1, function()
		if IsValid(self) then
			self:UnArrest()
		end
	end)

	self:SetNetVar('ArrestedInfo', {Release = CurTime() + time})
	if self:IsWanted() then self:UnWanted() end
		
	rp.ArrestedPlayers[self:SteamID64()] = true
		
	self:StripWeapons()
	self:SetHunger(100)
	self:SetHealth(100)
	self:SetArmor(0)

	rp.FlashNotifyAll('Новости', term.Get('Arrested'), self)
	hook.Call('PlayerArrested', GAMEMODE, self, actor)

	self:Spawn(util.FindEmptyPos(jails[math.random(#jails)]))
	self.CanEscape = true
end

function PLAYER:UnArrest(actor)
	self:SetNetVar('ArrestedInfo', nil)
	timer.Destroy('Arrested' .. self:SteamID64())
	rp.ArrestedPlayers[self:SteamID64()] = nil
	timer.Simple(0.3, function() -- fucks up otherwise
		local _, pos = GAMEMODE:PlayerSelectSpawn(self)
		self:Spawn(pos)
		self:SetHealth(100)
		self:SetNWBool('isHandcuffed', false)
		hook.Call('PlayerLoadout', GAMEMODE, self)
		rp.FlashNotifyAll('Новости', term.Get('UnArrested'), self)
		rp.Notify(pl, NOTIFY_ERROR, 'Вы отсидели свой срок.')
		hook.Call('PlayerUnArrested', GAMEMODE, self, actor)
	end)
end
-----------------------------------------------------------------------------
-- Commands
----------------------------------------------------------------------------

rp.AddCommand('911', function(pl, message)
net.Start("rp.GovernmentRequare")
    net.WriteString(text)
net.SendToServer()
end)
:AddParam(cmd.STRING)

rp.AddCommand('want', function(pl, targ, text)
	if not pl:IsCP() and not pl:IsMayor() then return end
		if targ:IsCP() then
		rp.Notify(pl, NOTIFY_ERROR, 'Вы не можете взять ордер на копа!')
	return end

	if targ:IsWanted() then
		rp.Notify(pl, NOTIFY_ERROR, term.Get('PlayerAlreadyWanted'), targ)
	else
		targ:Wanted(pl, text)
	end
end)
:AddParam(cmd.PLAYER_ENTITY)
:AddParam(cmd.STRING)

rp.AddCommand('unwant', function(pl, targ, text)
	if not pl:IsCP() and not pl:IsMayor() then return end
	if not targ:IsWanted() then
		rp.Notify(pl, NOTIFY_ERROR, term.Get('PlayerNotWanted'), targ)
	else
		targ:UnWanted(pl)
	end
end)
:AddParam(cmd.PLAYER_ENTITY)

rp.AddCommand('warrant', function(pl, targ, text)
	if not pl:IsCP() and not pl:IsMayor() then return end
	if targ:IsCP() then
		rp.Notify(pl, NOTIFY_ERROR, 'Вы не можете взять ордер на копа!')
	return end

	if targ:IsWarranted() then
		rp.Notify(pl, NOTIFY_ERROR, term.Get('PlayerAlreadyWarranted'), targ)
	else
	    if not rp.teams[pl:Team()] or not rp.teams[pl:Team()].mayor then -- No need to search through all the teams if the player is a mayor
	        local mayors = {}

			for k,v in pairs(rp.teams) do
	            if v.mayor then
	                table.Add(mayors, team.GetPlayers(k))
	            end
	        end

			if #mayors > 0 then
				local mayor = table.Random(mayors)
				local question = pl:Name() .. ' запросил ордер на ' .. targ:Name() .. '\nПричина: ' .. text
				GAMEMODE.ques:Create(question, targ:EntIndex() .. 'warrant', mayors[1], 40, function(ret)
					if not tobool(ret) then
						rp.Notify(pl, NOTIFY_ERROR, 'Мэр ' .. mayor:Name() .. ' отклонил ваш запрос на ордер.')
						return
					end
					if IsValid(targ) then
						targ:Warrant(pl, text)
					end
				end, pl, targ, text)
				rp.Notify(pl, NOTIFY_SUCCESS, 'Запрос на ордер отправлен мэру ' .. mayor:Name())
				return ''
			end
		end
		if IsValid(targ) then
			targ:Warrant(pl, text)
		end
			
		return ''
	end
end)
:AddParam(cmd.PLAYER_ENTITY)
:AddParam(cmd.STRING)

rp.AddCommand('unwarrant', function(pl, targ, text)
	if not pl:IsCP() and not pl:IsMayor() then return end
	if not targ:IsWarranted() then
		rp.Notify(pl, NOTIFY_ERROR, term.Get('PlayerNotWarranted'), targ)
	else
		targ:UnWarrant(pl)
	end
end)
:AddParam(cmd.PLAYER_ENTITY)

local bounds = rp.cfg.Jails[game.GetMap()]
if bounds then
	hook('PlayerThink', function(pl)
		if IsValid(pl) and pl:IsArrested() and pl.CanEscape and (not pl:InBox(bounds[1], bounds[2])) then
			rp.ArrestedPlayers[pl:SteamID64()] = nil
			pl:SetNetVar('ArrestedInfo', nil)
			timer.Destroy('Arrested' .. pl:SteamID64())
			pl:SetNWBool('isHandcuffed', false)
			pl:Wanted(nil, 'Побег из тюрьмы')

			hook.Call('PlayerLoadout', GAMEMODE, pl)
		end
	end)
end

hook('PlayerEntityCreated', function(pl)
	if rp.ArrestedPlayers[pl:SteamID64()] then
		pl:Arrest(nil) -- Disconnecting to avoid arrest
	end
end)

hook('PlayerDeath', function(pl, killer, dmginfo)
	if (!killer:IsPlayer()) then return end
	
	if pl:IsWanted() and killer:IsCP() and (pl ~= killer) and (killer ~= game.GetWorld()) then
		pl:UnWanted()
	end
end)




