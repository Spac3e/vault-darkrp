local db = rp._Credits

util.AddNetworkString("rp.shop.Menu")
util.AddNetworkString("rp.PermaWeaponSettings")

function PLAYER:AddCredits(amount, note, cback)
	rp.data.AddCredits(self:SteamID(), amount, note, function()
		self:SetNetVar('Credits', self:GetCredits() + amount)
		if (cback) then cback() end
	end)
end

function PLAYER:TakeCredits(amount, note, cback)
	rp.data.AddCredits(self:SteamID(), -amount, note, function()
		self:SetNetVar('Credits', self:GetCredits() - amount)
		if (cback) then cback() end
	end)
end

function PLAYER:GetUpgradeCount(uid)
	return (self:GetVar('Upgrades', {})[uid] or 0)
end

function PLAYER:GetPermaWeapons()
	return self:GetVar('PermaWeapons', {})
end

net.Receive("rp.shop.Menu", function(len, ply)
    local tbl = rp.shop.Stored

    db:Query('SELECT * FROM kshop_purchases WHERE SteamID = ?', ply:SteamID(), function(data)
        net.Start("rp.shop.Menu")
			net.WriteUInt(#tbl, 9)

			for i = 1, #tbl do
				net.WriteUInt(tbl[i].ID, 9)
				local can = true
				local err

				for k = 1, #data do
					if ply:IGSFunds() < tbl[i].Price then
						err = 'Нужно больше кредитов'
						can = false
					elseif data[k].Upgrade == tbl[i].UID and not tbl[i].Stackable then
						err = 'У вас куплен этот предмет'
						can = false
					end
				end

				net.WriteBool(can)

				if not can then
					net.WriteString(err)
				end

				local has = false

				for k = 1, #data do
					if tbl[i].Stackable then continue end

					if data[k].Upgrade == tbl[i].UID then
						has = true
						break
					end
				end

				net.WriteBool(has)
				net.WriteUInt(tbl[i].Price, 32)
			end
        net.Send(ply)
    end)
end)

-- Data
function rp.data.AddCredits(steamid, amount, note, cback)
	db:Query('INSERT INTO `kshop_credits_transactions` (`Time`, `SteamID`, `Change`, `Note`) VALUES(?, ?, ?, ?);', os.time(), steamid, amount, (note or ''), cback)
end

function rp.data.LoadCredits(pl, cback)
	db:Query('SELECT COALESCE(SUM(`Change`), 0) AS `Credits` FROM `kshop_credits_transactions` WHERE `SteamID`="' .. pl:SteamID() .. '";', function(data)
		if IsValid(pl) then
			pl:SetNetVar('Credits', tonumber(data[1]['Credits']))
			if cback then cback(data) end
		end
	end)
end

function rp.data.AddUpgrade(pl, id)
	local upg_obj = rp.shop.Get(id)
	local canbuy, reason = upg_obj:CanBuy(pl)

	if (not canbuy) then
		pl:Notify(NOTIFY_ERROR, term.Get('CantPurchaseUpgrade'), reason)
	else
		local cost = upg_obj:GetPrice(pl)
		pl:AddIGSFunds(-cost, 'Покупка: ' .. upg_obj:GetUID(), function()
			db:Query("INSERT INTO `kshop_purchases` VALUES('" .. os.time() .. "', '" .. pl:SteamID() .. "', '" .. upg_obj:GetUID() .. "');", function(dat)
				for k, v in ipairs(player.GetAll()) do 
					v:SendMessageFD(ui.col.SUP, '| ', pl:GetJobColor(), pl:Name(), ui.col.White, " купил ", Color(13, 196, 241), upg_obj:GetName(), ui.col.White, " за " .. upg_obj:GetPrice(pl) .. " руб!")
				end
				
				local upgrades = pl:GetVar('Upgrades')
				upgrades[upg_obj:GetUID()] = upgrades[upg_obj:GetUID()] and (upgrades[upg_obj:GetUID()] + 1) or 1
				pl:SetVar('Upgrades', upgrades)

				upg_obj:OnBuy(pl)
			end)
		end)
	end
end

hook('PlayerAuthed', 'rp.shop.LoadCredits', function(pl)
	rp.data.LoadCredits(pl, function()
		if IsValid(pl) then
		end
	end)
	db:Query('SELECT `Upgrade` FROM `kshop_purchases` WHERE `SteamID`="' .. pl:SteamID() .. '";', function(data)
		if IsValid(pl) then
			local upgrades 	= {}
			local weps 		= {}
			local networked = {}
			for k, v in ipairs(data) do
				local uid = v.Upgrade
				local obj = rp.shop.GetByUID(uid)
				local wep = rp.shop.Weapons[uid]
				upgrades[uid] = upgrades[uid] and (upgrades[uid] + 1) or 1
				if (wep ~= nil) then
					pl:Give(wep)
					weps[#weps + 1] = wep
				end
				if (obj ~= nil) and obj:IsNetworked() then
					networked[#networked + 1] = obj:GetID()
				end
			end
			pl:SetVar('Upgrades', upgrades)
			pl:SetVar('PermaWeapons', weps)
			if (#networked > 0) then
				pl:SetNetVar('Upgrades', networked)
			end
			hook.Call('PlayerUpgradesLoaded', nil, pl)
		end
	end)
end)

hook('PlayerLoadout', 'rp.shop.PlayerLoadout', function(pl)
	for k, v in ipairs(pl:GetPermaWeapons()) do
		pl:Give(v).donate = true
		
	end
end)

rp.AddCommand('buyupgrade', function(pl, args, text)
	if (not args) or (not rp.shop.Get(tonumber(args))) then return end
	rp.data.AddUpgrade(pl, tonumber(args))
end)
:AddParam(cmd.STRING)