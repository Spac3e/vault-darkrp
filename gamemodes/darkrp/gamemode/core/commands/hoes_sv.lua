local RapistVoices = {
	'vo/npc/female01/moan01.wav',
	'vo/npc/female01/moan02.wav',
	'vo/npc/female01/moan03.wav',
	'vo/npc/female01/moan04.wav',
	'vo/npc/female01/moan05.wav'
}

local TargetVoices = {
	'vo/npc/male01/moan01.wav',
	'vo/npc/male01/moan02.wav',
	'vo/npc/male01/moan03.wav',
	'vo/npc/male01/moan04.wav',
	'vo/npc/male01/moan05.wav'
}

local function IsPimp()
	for k, v in pairs(player.GetAll()) do 
		if rp.teams[v:Team()].Pimp then
			return true
		end
		return false
	end
end

local function PimpsCut()
	for k, v in pairs(player.GetAll()) do 
		if rp.teams[v:Team()].Pimp then
			v:AddMoney(100)
			rp.Notify(v, NOTIFY_SUCCESS, term.Get('HoesProfit'))
		end
	end
end

local function DoFuck(pl, Target)
	if not rp.teams[Target:Team()].Pimp then
		if (not Target:CanAfford(250)) then
			rp.Notify(pl, NOTIFY_ERROR, term.Get('CannotAffordHoe'), Target)
			rp.Notify(Target, NOTIFY_ERROR, term.Get('YouCannotAffordHoe'), pl)
			return ''
		end
		
		pl:AddMoney(150)
		Target:AddMoney(-250)
		PimpsCut()
	end

	if (not pl:IsWanted()) and pl:CloseToCPs() then
		pl:Wanted(nil, 'Проституция')
	end
	
	local FuckTime = math.random(5,10)
	local Chance = math.random(1, 8)

	pl:Freeze(true)
	timer.Create('FuckSounds', 1.5, 0, function()
		pl:EmitSound(table.Random(RapistVoices), 500, 100)
		pl:ViewPunch(Angle(math.random(-1, 1), math.random(-1, 1), math.random(-10, 10)))
	end)

	Target:Freeze(true)
	timer.Create('TargetSounds', 1.5, 0, function()
		Target:EmitSound(table.Random(TargetVoices), 500, 100)
		Target:ViewPunch(Angle(math.random(-1, 1), math.random(-1, 1), math.random(-10, 10)))
	end)

	timer.Create('FuckUnFreeze', FuckTime, 1, function()
		pl:TakeHunger(10)
		Target:EmitSound('bot/hang_on_im_coming.wav')
		pl:Freeze(false)
		Target:TakeHunger(10)
		Target:EmitSound('ambient/voices/m_scream1.wav')
		Target:Freeze(false)

		timer.Destroy('FuckSounds')
		timer.Destroy('TargetSounds')
	end)
end

local function FuckPlayer(pl)
	local Target = pl:GetEyeTrace().Entity

	if not pl:Alive() then
		rp.Notify(pl, NOTIFY_ERROR, term.Get('YouAreDead'))
		return ''
	end

	if (not IsValid(Target)) or (not Target:IsPlayer()) or (pl:EyePos():DistToSqr(Target:GetPos()) > 28900) then
		rp.Notify(pl, NOTIFY_ERROR, term.Get('GetCloser'))
		return
	end

	if not pl:IsSuperAdmin() then
		if not rp.teams[pl:Team()].Hoe then
			rp.Notify(pl, NOTIFY_ERROR, term.Get('NotAHoe'))
			return ''
		end
	end

	if pl:InSpawn() or Target:InSpawn() then
		rp.Notify(pl, NOTIFY_ERROR, 'На спавне запрещено трахаться.')
		return ''
	end

	if Target:IsNPC() then
		rp.Notify(pl, NOTIFY_ERROR, term.Get('NPCsDontFuck'))
		return '' 
	end

	if Target:IsFrozen() then
		rp.Notify(pl, NOTIFY_ERROR, term.Get('TargetFrozen'))
		return '' 
	end

	if (Target:IsCP() or Target:Team() == TEAM_MAYOR) and not pl:IsWanted() then
		pl:Wanted(nil, 'Проституция')
	end

	rp.Notify(pl, NOTIFY_GENERIC, term.Get('WaitingForAnswer'))

	local FuckCost = 250
	if rp.teams[Target:Team()].Pimp then
		FuckCost = 0
	end

	GAMEMODE.ques:Create("Хотите заняться сексом с\n" ..  pl:Name() .. " за $" .. FuckCost .. "?", "fuckyfucky" .. pl:UserID(), Target, 30, function(answer, ent, initiator, target)
		if tobool(answer) == false then 
			rp.Notify(pl, NOTIFY_ERROR, term.Get('TargetWontFuck'))
			return ''
		elseif tobool(answer) && pl:EyePos():DistToSqr(Target:GetPos()) > 19600 or not Target:IsPlayer() then
			rp.Notify(pl, NOTIFY_ERROR, term.Get('TargetTooFar'))
			rp.Notify(Target, NOTIFY_ERROR, term.Get('HoeTooFar'))
			return ''
		elseif tobool(answer) then
			DoFuck(pl, Target)
			if IsPimp() then
				rp.Notify(pl, NOTIFY_SUCCESS, term.Get('+FuckCostPimp'), FuckCost)
			else
				rp.Notify(pl, NOTIFY_SUCCESS, term.Get('+Money'), FuckCost)
				rp.Notify(Target, NOTIFY_ERROR, term.Get('-Money'), FuckCost)
				return ''
			end
			rp.Notify(Target, NOTIFY_ERROR, term.Get('-Money'), FuckCost)
			return ''
		end
	end)
end
rp.AddCommand('sex', FuckPlayer)