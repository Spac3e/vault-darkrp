local CurTime 		= CurTime
local math_abs		= math.abs
local math_clamp	= math.Clamp
local math_max 		= math.max

timer.Create('HungerUpdate', 5, 0, function()
	for k, v in ipairs(player.GetAll()) do
		if IsValid(v) and v:Alive() and (v:GetHunger() <= 0) then
			local shouldHunger = hook.Call('PlayerHasHunger', GAMEMODE, v)
			if (shouldHunger == nil) then shouldHunger = true end
			if (v:Team() == TEAM_ADMIN) then shouldHunger = false end
			if (v:InSpawn()) then shouldHunger = false end
			if (shouldHunger) then
				v:SetHealth(v:Health() - 7.5)
				v:EmitSound(Sound('vo/npc/male01/moan0' .. math.random(1, 5) .. '.wav'))
				if (v:Health() <= 0) then
					v:Kill()
				end
			end
		end
	end
end)

hook('PlayerSpawn', function(pl)
	if pl:GetNetVar('Energy') then
		pl:SetNetVar('Energy', CurTime() + rp.cfg.HungerRate)
	end
end)

hook('PlayerEntityCreated', function(pl)
	pl:SetNetVar('Energy', CurTime() + rp.cfg.HungerRate)
end)

function PLAYER:SetHunger(amount, noclamp)
	if noclamp then
		amount = math_max(0, (amount/100 * rp.cfg.HungerRate))
	else
		amount = math_clamp((amount/100 * rp.cfg.HungerRate), 0, rp.cfg.HungerRate)
	end
	self:SetNetVar('Energy', CurTime() + amount)
end

function PLAYER:AddHunger(amount)
	self:SetHunger(self:GetHunger() + amount)
end

function PLAYER:TakeHunger(amount)
	self:AddHunger(-math_abs(amount))
end

local function BuyFood(pl, args)
	if args == '' then return '' end
	if not rp.Foods[args] then return '' end

	if pl:GetCount('Food') >= 15 then
		pl:Notify(NOTIFY_ERROR, term.Get('FoodLimitReached'))
		return
	end

	local trace = {}
	trace.start = pl:EyePos()
	trace.endpos = trace.start + pl:GetAimVector() * 85
	trace.filter = pl

	local tr = util.TraceLine(trace)

	if pl:Team() != TEAM_COOK and team.NumPlayers(TEAM_COOK) > 0 then
		pl:Notify(NOTIFY_ERROR, term.Get('ThereIsACook'))
		return ''
	end

	if not rp.Foods[args] then return end

	local cost = rp.Foods[args].price
	if pl:CanAfford(cost) then
		pl:AddMoney(-cost)
	else
		pl:Notify(NOTIFY_ERROR, term.Get('CannotAfford'))
		return ''
	end

	rp.Notify(pl, NOTIFY_SUCCESS, term.Get('RPItemBought'), args, rp.FormatMoney(cost))
	
	local SpawnedFood = ents.Create('spawned_food')
	SpawnedFood:SetPos(tr.HitPos)
	SpawnedFood:SetModel(rp.Foods[args].model)
	SpawnedFood.FoodEnergy = rp.Foods[args].energy
	SpawnedFood.ItemOwner = pl
	SpawnedFood:Spawn()

	pl:_AddCount('Food', SpawnedFood)
	return ''
end
rp.AddCommand('buyfood', BuyFood)
:AddParam(cmd.STRING)