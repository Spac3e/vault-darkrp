---------------------------------------------------------
-- Shipments
---------------------------------------------------------
local function DropWeapon(pl)
	local ent = pl:GetActiveWeapon()
	if not IsValid(ent) then
		return 
	end

	local canDrop = hook.Call('CanDropWeapon', GAMEMODE, pl, ent)
	if not canDrop then
		rp.Notify(pl, NOTIFY_ERROR, term.Get('CannotDropWeapon'))
		return 
	end

	timer.Simple(1, function()
		if IsValid(pl) and IsValid(ent) and ent:GetModel() then
			pl:DropDRPWeapon(ent)
		end
	end)
end
rp.AddCommand('drop', DropWeapon)

local function SetPrice(pl, args)
	local amount = tonumber(args)

	local tr = util.TraceLine({	
		start = pl:EyePos(),
		endpos = pl:EyePos() + pl:GetAimVector() * 85,
		filter = pl
	})

	if not IsValid(tr.Entity) then rp.Notify(pl, NOTIFY_ERROR, term.Get('LookAtEntity')) return '' end

	if IsValid(tr.Entity) and tr.Entity.MaxPrice and (tr.Entity.ItemOwner == pl) then
		tr.Entity:Setprice(math.Clamp(amount, tr.Entity.MinPrice, tr.Entity.MaxPrice))
	else
		rp.Notify(pl, NOTIFY_ERROR, term.Get('CannotSetPrice'))
	end

	return ''
end
rp.AddCommand('setprice', SetPrice)
:AddParam(cmd.NUMBER)
:AddAlias 'price'

local function BuyPistol(ply, args)
	if ply:IsArrested() then
		rp.Notify(ply, NOTIFY_ERROR, term.Get('CannotPurchaseItem'))
		return ''
	end

	local trace = {}
	trace.start = ply:EyePos()
	trace.endpos = trace.start + ply:GetAimVector() * 85
	trace.filter = ply

	local tr = util.TraceLine(trace)

	local class = nil
	local model = nil

	local shipment
	local price = 0
	for k,v in pairs(rp.shipments) do
		if v.seperate and string.lower(v.name) == string.lower(args) and GAMEMODE:CustomObjFitsMap(v) then
			shipment = v
			class = v.entity
			model = v.model
			price = v.pricesep
			local canbuy = false

			if tblEnt.allowed[ply:Team()] then
				canbuy = true
			end

			if v.customCheck and not v.customCheck(ply) then
				rp.Notify(ply, NOTIFY_ERROR, term.Get(v.CustomCheckFailMsg) or term.Get('CannotPurchaseItem'))
				return ''
			end

			if not canbuy then
				rp.Notify(ply, NOTIFY_ERROR, term.Get('CannotPurchaseItem'))
				return ''
			end
		end
	end

	if not class then
		rp.Notify(ply, NOTIFY_ERROR, term.Get('ItemUnavailable'))
		return ''
	end

	if not ply:CanAfford(price) then
		rp.Notify(ply, NOTIFY_ERROR, term.Get('CannotAfford'))
		return ''
	end

	local weapon = ents.Create('spawned_weapon')
	weapon:SetModel(model)
	weapon.weaponclass = class
	weapon.ShareGravgun = true
	weapon:SetPos(tr.HitPos)
	weapon.ammoadd = weapons.Get(class) and weapons.Get(class).Primary.DefaultClip
	weapon.nodupe = true
	weapon:Spawn()

	if shipment.onBought then
		shipment.onBought(ply, shipment, weapon)
	end
	hook.Call('playerBoughtPistol', nil, ply, shipment, weapon)

	if IsValid( weapon ) then
		ply:AddMoney(-price)
		rp.Notify(ply, NOTIFY_SUCCESS, term.Get('RPItemBought'), args, rp.FormatMoney(price))
	else
		rp.Notify(ply, NOTIFY_ERROR, term.Get('UnableToItem'))
	end

	return ''
end
rp.AddCommand('buy', BuyPistol)
:AddParam(cmd.STRING)

local function BuyShipment(ply, args)
	if ply.LastShipmentSpawn and ply.LastShipmentSpawn > (CurTime() - 1) then
		rp.Notify(ply, NOTIFY_ERROR, term.Get('ShipmentCooldown'))
		return ''
	end
	ply.LastShipmentSpawn = CurTime()

	local trace = {}
	trace.start = ply:EyePos()
	trace.endpos = trace.start + ply:GetAimVector() * 85
	trace.filter = ply

	local tr = util.TraceLine(trace)

	if ply:IsArrested() then
		rp.Notify(ply, NOTIFY_ERROR, term.Get('CannotPurchaseItem'))
		return ''
	end

	local found = false
	local foundKey
	for k,v in pairs(rp.shipments) do
		if string.lower(args) == string.lower(v.name) and not v.noship and GAMEMODE:CustomObjFitsMap(v) then
			found = v
			foundKey = k
			local canbecome = false
			for a,b in pairs(v.allowed) do
				if ply:Team() == b then
					canbecome = true
				end
			end

			if v.customCheck and not v.customCheck(ply) then
				rp.Notify(ply, NOTIFY_ERROR, term.Get(v.CustomCheckFailMsg) or term.Get('CannotPurchaseItem'))
				return ''
			end

			if not canbecome then
				rp.Notify(ply, NOTIFY_ERROR, term.Get('IncorrectJob'))
				return ''
			end
		end
	end
 
	if not found then
		rp.Notify(ply, NOTIFY_ERROR, term.Get('ItemUnavailable'))
		return ''
	end

	local cost = found.price

	if not ply:CanAfford(cost) then
		rp.Notify(ply, NOTIFY_ERROR, term.Get('CannotAfford'))
		return ''
	end

	local crate = ents.Create(found.shipmentClass or 'spawned_shipment')
	
	crate:SetPos(Vector(tr.HitPos.x, tr.HitPos.y, tr.HitPos.z))
	crate:Spawn()
	if found.shipmodel then
		crate:SetModel(found.shipmodel)
	end
	crate:SetContents(foundKey, found.amount)

	if rp.shipments[foundKey].onBought then
		rp.shipments[foundKey].onBought(ply, rp.shipments[foundKey], weapon)
	end
	hook.Call('playerBoughtShipment', nil, ply, rp.shipments[foundKey], weapon)

	if IsValid( crate ) then
		ply:AddMoney(-cost)
		rp.Notify(ply, NOTIFY_SUCCESS, term.Get('RPItemBought'), args, rp.FormatMoney(cost))
		
		hook.Call('PlayerBoughtItem', GAMEMODE, ply, rp.shipments[foundKey].name .. ' Shipment', cost, ply:GetMoney())
	else
		rp.Notify(ply, NOTIFY_ERROR, term.Get('UnableToItem'))
	end

	return ''
end
rp.AddCommand('buyshipment', BuyShipment)
:AddParam(cmd.STRING)

local function BuyAmmo(ply, args)
	if ply:IsArrested() then
		rp.Notify(ply, NOTIFY_ERROR, term.Get('CannotPurchaseItem'))
		return ''
	end

	local found
	for k,v in pairs(rp.ammoTypes) do
		if v.ammoType == args then
			found = v
			break
		end
	end

	if not found or (found.customCheck and not found.customCheck(ply)) then
		rp.Notify(ply, NOTIFY_ERROR, found and term.Get(found.CustomCheckFailMsg) or term.Get('ItemUnavailable'))
		return ''
	end

	if not ply:CanAfford(found.price) then
		rp.Notify(ply, NOTIFY_ERROR, term.Get('CannotAfford'))
		return ''
	end

	rp.Notify(ply, NOTIFY_SUCCESS, term.Get('RPItemBought'), found.name, rp.FormatMoney(found.price))
	ply:AddMoney(-found.price)

	ply:GiveAmmo(found.amountGiven, found.ammoType)

	return ''
end
rp.AddCommand('buyammo', BuyAmmo)
:AddParam(cmd.STRING)

---------------------------------------------------------
-- Jobs
---------------------------------------------------------
local function ChangeJob(ply, args)
	if ply:IsArrested() then
		rp.Notify(ply, NOTIFY_ERROR, term.Get('CannotJob'))
		return ''
	end

	if ply.LastJob and 10 - (CurTime() - ply.LastJob) >= 0 then
		rp.Notify(ply, NOTIFY_ERROR, term.Get('NeedToWait'), math.ceil(10 - (CurTime() - ply.LastJob)))
		return ''
	end
	ply.LastJob = CurTime()

	if not ply:Alive() then
		rp.Notify(ply, NOTIFY_ERROR, term.Get('CannotJob'))
		return ''
	end

	local len = string.len(args)

	if len < 3 then
		rp.Notify(ply, NOTIFY_ERROR, term.Get('JobLenShort'), 2)
		return ''
	end

	if len > 25 then
		rp.Notify(ply, NOTIFY_ERROR, term.Get('JobLenLong'), 26)
		return ''
	end

	local canChangeJob, message, replace = hook.Call('canChangeJob', nil, ply, args)
	if canChangeJob == false then
		rp.Notify(ply, NOTIFY_ERROR, term.Get('CannotJob'))
		return ''
	end

	local job = replace or args
	rp.NotifyAll(NOTIFY_GENERIC, term.Get('ChangeJob'), ply, job)

	ply:SetNetVar('job', job) 
	return ''
end
rp.AddCommand('job', ChangeJob)
:AddParam(cmd.STRING)

local function FinishDemote(vote, choice)
	local target = vote.target

	target.IsBeingDemoted = nil
	if choice == 1 then
		target:TeamBan()
		if target:Alive() then
			target:ChangeTeam(rp.DefaultTeam, true)
		else
			target.demotedWhileDead = true
		end

		rp.NotifyAll(NOTIFY_GENERIC, term.Get('PlayerDemoted'), target)
	else
		rp.NotifyAll(NOTIFY_GENERIC, term.Get('PlayerNotDemoted'), target)
	end
end

local function Demote(ply, args)
	local tableargs = string.Explode(' ', args)
	if #tableargs == 1 then
		rp.Notify(ply, NOTIFY_ERROR, term.Get('DemotionReason'))
		return ''
	end
	local reason = ''
	for i = 2, #tableargs, 1 do
		reason = reason .. ' ' .. tableargs[i]
	end
	reason = string.sub(reason, 2)
	if string.len(reason) > 99 then
		rp.Notify(ply, NOTIFY_ERROR, term.Get('DemoteReasonLong'), 100)
		return ''
	end
	local p = player.Find(tableargs[1])
	if p == ply then
		rp.Notify(ply, NOTIFY_ERROR, term.Get('DemoteSelf'))
		return ''
	end

	local canDemote, message = hook.Call('CanDemote', GAMEMODE, ply, p, reason)
	if canDemote == false then
		rp.Notify(ply, NOTIFY_ERROR, term.Get('UnableToDemote'))
		return ''
	end

	if p then
		if ply:GetTable().LastVoteCop and CurTime() - ply:GetTable().LastVoteCop < 80 then
			rp.Notify(ply, NOTIFY_ERROR, term.Get('NeedToWait'),  math.ceil(80 - (CurTime() - ply:GetTable().LastVoteCop)))
			return ''
		end
		if not rp.teams[p:Team()] or rp.teams[p:Team()].candemote == false then
			rp.Notify(ply, NOTIFY_ERROR, term.Get('UnableToDemote'))
		else
			-- rp.Chat(CHAT_NONE, p, colors.Yellow, '[Увольнение] ', ply, 'Я желаю уволить тебя с работы. Причина: ' .. reason)
			
			rp.NotifyAll(NOTIFY_GENERIC, term.Get('DemotionStarted'), ply, p)
			p.IsBeingDemoted = true

			hook.Call('playerDemotePlayer', GAMEMODE, ply, p, reason)
			
			GAMEMODE.vote:create(p:Nick() .. ':\nПричина увольнения:\n'..reason, 'demote', p, 20, FinishDemote,
			{
				[p] = true,
				[ply] = true
			}, function(vote)
				if not IsValid(vote.target) then return end
				vote.target.IsBeingDemoted = nil
			end)
			ply:GetTable().LastVoteCop = CurTime()
		end
		return ''
	else
		rp.Notify(ply, NOTIFY_ERROR, term.Get('CantFindPlayer'), tostring(args))
		return ''
	end
end
rp.AddCommand('demote', Demote)
-- :AddParam(cmd.PLAYER_ENTITY)
:AddParam(cmd.STRING)

---------------------------------------------------------
-- Talking
---------------------------------------------------------
local function PM(pl, targ, message)
	chat.Send('PM', pl, targ, message)
	targ.LastPM = pl
end
rp.AddCommand('pm', PM)
:AddParam(cmd.PLAYER_ENTITY)
:AddParam(cmd.STRING)

rp.AddCommand('re', function(pl, message)
	local targ = pl.LastPM
	if IsValid(targ) then
		chat.Send('PM', pl, targ, message)
		targ.LastPM = pl
	else
		return NOTIFY_ERROR, term.Get('NoPMResponder')
	end
end)
:AddParam(cmd.STRING)

local function Whisper(pl, targ, message)
	chat.Send('Whisper', pl, targ, message)
end
rp.AddCommand('whisper', Whisper)
:AddParam(cmd.STRING)
:AddAlias 'w'

local function Yell(pl, targ, message)
	chat.Send('Yell', pl, targ, message)
end
rp.AddCommand('yell', Yell)
:AddParam(cmd.STRING)
:AddAlias 'y'

local function Me(pl, targ, message)
	chat.Send('Me', pl, targ, message)
end
rp.AddCommand('me', Me)
:AddParam(cmd.STRING)

local function OOC(pl, targ, message)
	chat.Send('OOC', pl, targ, message)
end
rp.AddCommand('ooc', OOC)
:AddParam(cmd.STRING)
:AddAlias '/'

local function PlayerAdvertise(pl, targ, message)
	local cost = rp.cfg.AdvertCost
	if pl:CanAfford(cost) then
		pl:AddMoney(-cost)
		rp.Notify(pl, NOTIFY_SUCCESS, term.Get('RPItemBought'), 'рекламу', rp.FormatMoney(cost))
		chat.Send('Ad', pl, targ, message)
	else
		rp.Notify(pl, NOTIFY_ERROR, term.Get('CannotAfford'))
	end
	
end
rp.AddCommand('advert', PlayerAdvertise)
:AddParam(cmd.STRING)
:AddAlias 'ad'

local function MayorBroadcast(pl, targ, message)
	if not pl:IsMayor() then return end
	chat.Send('Broadcast', pl, targ, message)
end
rp.AddCommand('broadcast', MayorBroadcast)
:AddParam(cmd.STRING)
:AddAlias 'b'

local function GroupMsg(pl, targ, message)
	chat.Send('Group', pl, targ, message)
end
rp.AddCommand('group', GroupMsg)
:AddParam(cmd.STRING)
:AddAlias 'g'

---------------------------------------------------------
-- Money
---------------------------------------------------------
local function GiveMoney(ply, args, text)
	local trace = ply:GetEyeTrace()

	if IsValid(trace.Entity) and trace.Entity:IsPlayer() and trace.Entity:GetPos():DistToSqr(ply:GetPos()) < 22500 then
		local amount = math.floor(tonumber(args))

		if amount < 1 then
			rp.Notify(ply, NOTIFY_ERROR, term.Get('GiveMoneyLimit'))
			return
		end

		if not ply:CanAfford(amount) then
			rp.Notify(ply, NOTIFY_ERROR, term.Get('CannotAfford'))
			return ''
		end
		
		rp.data.PayPlayer(ply, trace.Entity, amount)

		hook.Call('PlayerGaveMoney', GAMEMODE, ply, trace.Entity, amount, ply:GetMoney(), trace.Entity:GetMoney())

		rp.Notify(trace.Entity, NOTIFY_SUCCESS, term.Get('PlayerGaveCash'), ply, rp.FormatMoney(amount))
		rp.Notify(ply, NOTIFY_SUCCESS, term.Get('YouGaveCash'), trace.Entity, rp.FormatMoney(amount))
	else
		rp.Notify(ply, NOTIFY_ERROR, term.Get('MustLookAtPlayer'))
	end
	return ''
end
rp.AddCommand('give', GiveMoney)
:AddParam(cmd.NUMBER)

local function DropMoney(ply, args)
	local amount = math.floor(tonumber(args))

	if amount <= 1 then
		rp.Notify(ply, NOTIFY_ERROR, term.Get('DropMoneyLimit'))
		return ''
	end

	if not ply:CanAfford(amount) then
		rp.Notify(ply, NOTIFY_ERROR, term.Get('CannotAfford'))
		return ''
	end

	ply:AddMoney(-amount)
	
	hook.Call('PlayerDropRPMoney', GAMEMODE, ply, amount, ply:GetMoney())

	local trace = {}
	trace.start = ply:EyePos()
	trace.endpos = trace.start + ply:GetAimVector() * 85
	trace.filter = ply

	local tr = util.TraceLine(trace)
	rp.SpawnMoney(tr.HitPos, amount)

	return ''
end
rp.AddCommand('dropmoney', DropMoney)
:AddParam(cmd.NUMBER)
:AddAlias 'moneydrop'

local function MakeZombieSoundsAsHobo(ply)
	if not ply.nospamtime then
		ply.nospamtime = CurTime() - 2
	end
	if not rp.teams[ply:Team()] or not rp.teams[ply:Team()].hobo or CurTime() < (ply.nospamtime + 1.3) or (IsValid(ply:GetActiveWeapon()) and ply:GetActiveWeapon():GetClass() ~= 'weapon_bugbait') then
		return
	end
	ply.nospamtime = CurTime()
	local ran = math.random(1,3)
	if ran == 1 then
		ply:EmitSound('npc/zombie/zombie_voice_idle'..tostring(math.random(1,14))..'.wav', 100,100)
	elseif ran == 2 then
		ply:EmitSound('npc/zombie/zombie_pain'..tostring(math.random(1,6))..'.wav', 100,100)
	elseif ran == 3 then
		ply:EmitSound('npc/zombie/zombie_alert'..tostring(math.random(1,3))..'.wav', 100,100)
	end
end
concommand.Add('_hobo_emitsound', MakeZombieSoundsAsHobo)