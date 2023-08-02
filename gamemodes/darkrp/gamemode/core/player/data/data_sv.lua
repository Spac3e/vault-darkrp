rp.data = rp.data or {}
local db = rp._Stats

function rp.data.LoadPlayer(pl, cback)
	db:Query('SELECT * FROM player_data WHERE SteamID=' .. pl:SteamID64() .. ';', function(_data)
		local data = _data[1] or {}

		if IsValid(pl) then
			if (#_data <= 0) then
				db:Query('INSERT INTO player_data(SteamID, Name, Money, Karma, Achs, Pocket) VALUES(?, ?, ?, ?, ?, ?);', pl:SteamID64(), pl:SteamName(), rp.cfg.StartMoney, rp.cfg.StartKarma, '{}', '[]')
				pl:SetRPName(rp.names.Random(), true)
			end

			if data.Name and (data.Name ~= pl:SteamName()) then
				pl:SetNetVar('Name', data.Name)
			end

			db:Query('SELECT * FROM player_hats WHERE SteamID=' .. pl:SteamID64() .. ';', function(data)
                nw.WaitForPlayer(pl, function()
                    local HatData = {}
                    local ActiveApparel = {}

                    for k, v in ipairs(data) do
                        local hat = rp.hats.List[v.Model]
                        HatData[v.Model] = v.Donate

                        if (tonumber(v.Active) == 1) then
                            ActiveApparel[hat.type] = hat.UID
                        end
                    end

                    pl:SetNetVar('ActiveApparel', ActiveApparel)
                    pl:SetNetVar('OwnedApparel', HatData)
                end)
            end)

            db:Query('SELECT Org FROM org_player WHERE SteamID = ?', pl:SteamID64(), function(data)
                if #data == 0 then return end 
                db:Query('SELECT Banner FROM orgs WHERE Name = ?',data[1].Org, function(data2)
                    nw.WaitForPlayer(pl, function()
                        pl:SetNetVar('OrgBanner',data2[1].Banner)
                    end)
                end)
            end)

            db:Query('SELECT * FROM wep_skins WHERE steamid=' .. pl:SteamID64() .. ';', function(data)
				nw.WaitForPlayer(pl, function()
					local SkinDate = {}
					
			//		PrintTable(data)
					for k, v in ipairs(data) do
			//			print(data[k].Model)
						SkinDate[data[k].Model] = v.Model
						-- if (tonumber(v.Active) == 1) then
						-- 	pl:SetSkin(v.Model)
						-- end
					end
					pl:SetNetVar('OwnedSkin', SkinDate)
				end)
			end)

			db:Query('SELECT * FROM wep_active WHERE steamid = '..pl:SteamID64(), function(data)
				nw.WaitForPlayer(pl, function()
					local ActiveSkin = {}
                    for _, v in ipairs(data) do 
                        ActiveSkin[v.Weapon] = v.Model
					end
				//	PrintTable(ActiveSkin)
					pl:SetNetVar('ActiveSkin',ActiveSkin)
				end)
			end)

			nw.WaitForPlayer(pl, function()
				pl:SetNetVar('Money', data.Money or rp.cfg.StartMoney)
				pl:SetNetVar('Karma', data.Karma or rp.cfg.StartKarma)
                pl:SetNetVar('Achs', (util.JSONToTable(data.Achs or '[]')) or {} )				
                
                local succ, tbl = pcall(pon.decode, data.Pocket)
				if (not istable(tbl)) then
					rp.inv.Data[pl:SteamID64()] = {}
				else
					rp.inv.Data[pl:SteamID64()] = tbl
				end

				pl:SetVar('lastpayday', CurTime() + 180, false, false)
            --    pl:SendInv()

				pl:SetVar('DataLoaded', true)
				hook.Call('PlayerDataLoaded', GAMEMODE, pl, data)
			end)

			if cback then cback(data) end
		end
	end)
end

function GM:PlayerAuthed(pl)
	rp.data.LoadPlayer(pl)
end

function rp.data.SetName(pl, name, cback)
	db:Query('UPDATE player_data SET Name=? WHERE SteamID=' .. pl:SteamID64() .. ';', name, function(data)
		pl:SetNetVar('Name', name)
		if cback then cback(data) end
	end)
end

function rp.data.GetNameCount(name, cback)
	db:Query('SELECT COUNT(*) as `count` FROM player_data WHERE Name=?;', name, function(data)
		if cback then cback(tonumber(data[1].count) > 0) end
	end)
end

function rp.data.SetMoney(pl, amount, cback)
	db:Query('UPDATE player_data SET Money=? WHERE SteamID=' .. pl:SteamID64() .. ';', amount, cback)
end

function rp.data.PayPlayer(pl1, pl2, amount)
	if not IsValid(pl1) or not IsValid(pl2) then return end
	pl1:TakeMoney(amount)
	pl2:AddMoney(amount)
end

function rp.data.SetKarma(pl, amount, cback)
	if (pl:GetKarma() ~= amount) then
		db:Query('UPDATE player_data SET Karma=? WHERE SteamID=' .. pl:SteamID64() .. ';', amount, cback)
	end
end

function rp.data.SetPocket(steamid64, data, cback)
	db:Query('UPDATE player_data SET Pocket=? WHERE SteamID=' .. steamid64 .. ';', data, cback)
end

function rp.data.SetActiveOff(pl, mdl, cback)
    local steamid64 = pl:SteamID64()

    if (mdl ~= nil) then
        local hat = rp.hats.List[mdl]
        db:Query('REPLACE INTO player_hats(SteamID, Model, Donate, Active) VALUES(?, ?, ?, 0);', steamid64, hat.UID, pl:GetNetVar('OwnedApparel')[hat.UID] == 1 and 1 or 0, cback)
    end
end

function rp.data.SetHat(pl, mdl, cback)
    local steamid = pl:SteamID64()

    if (mdl ~= nil) then
        -- We assume you own it
        db:Query('REPLACE INTO player_hats(SteamID, Model, Donate, Active) VALUES(?, ?, ?, 1);', steamid, mdl.UID, pl:GetNetVar('OwnedApparel')[mdl.UID] == 1 and 1 or 0, function()
            if IsValid(pl) then
                local ActiveApparel = pl:GetApparel()

                if mdl.type == 1 then
                    if ActiveApparel[1] then
                        rp.data.SetActiveOff(pl, ActiveApparel[1])
                        ActiveApparel[1] = nil
                    end

                    if ActiveApparel[2] then
                        rp.data.SetActiveOff(pl, ActiveApparel[2])
                        ActiveApparel[2] = nil
                    end
                elseif mdl.type == 2 then
                    if ActiveApparel[1] then
                        rp.data.SetActiveOff(pl, ActiveApparel[1])
                        ActiveApparel[1] = nil
                    end

                    if ActiveApparel[2] then
                        rp.data.SetActiveOff(pl, ActiveApparel[2])
                        ActiveApparel[2] = nil
                    end

                    if ActiveApparel[3] then
                        rp.data.SetActiveOff(pl, ActiveApparel[3])
                        ActiveApparel[3] = nil
                    end
                elseif mdl.type == 3 then
                    if ActiveApparel[2] then
                        rp.data.SetActiveOff(pl, ActiveApparel[2])
                        ActiveApparel[2] = nil
                    end
                elseif mdl.type == 4 then
                    if ActiveApparel[4] then
                        rp.data.SetActiveOff(pl, ActiveApparel[4])
                        ActiveApparel[4] = nil
                    end
                end

                ActiveApparel[mdl.type] = mdl.UID
                pl:SetNetVar('ActiveApparel', ActiveApparel)
            end

            if cback then
                cback()
            end
        end)
    end
end

function rp.data.RemoveHat(pl, mdl, cback)
    local steamid = pl:SteamID64()

    if (mdl ~= nil) then
        -- We assume you own it		
        db:Query('REPLACE INTO player_hats(SteamID, Model, Donate, Active) VALUES(?, ?, ?, 0);', steamid, mdl.UID, pl:GetNetVar('OwnedApparel')[mdl.UID] == 1 and 1 or 0, function()
            if IsValid(pl) then
                local ActiveApparel = pl:GetApparel()
                ActiveApparel[tonumber(mdl.type)] = nil
                pl:SetNetVar('ActiveApparel', ActiveApparel)
            end

            if cback then
                cback()
            end
        end)
    end
end

function rp.data.UpdateSkin(pl,mdl,weapon)
	local steamid = pl:SteamID64()
	-- if !mdl then return end 
	db:Query('SELECT *  FROM wep_active WHERE steamid = '..steamid..' AND Weapon = "'..weapon..'"',function(b)
		if #b != 0 then  
			db:Query('UPDATE wep_active SET model = '..mdl..' WHERE steamid = '..steamid..' AND Weapon = "'..weapon..'"')
		else 
			db:Query('INSERT INTO wep_active(steamid,Model,Weapon) VALUES (?,?,?)', steamid, mdl, weapon)
		end 
	end)

end

function rp.data.RemoveSkin(pl,mdl,weapon)
	local steamid = pl:SteamID64()
	db:Query('DELETE FROM wep_active WHERE Weapon = "'..weapon..'"')
end 

function rp.data.SetSkinGun(pl, mdl, cback)
    local steamid = pl:SteamID64()

    if (mdl ~= nil) then
        -- We assume you own it
        db:Query('REPLACE INTO wep_skins(SteamID, Model, Donate, Active) VALUES(?, ?, ?, 1);', steamid, mdl.UID, pl:GetNetVar('OwnedSkin')[mdl.UID] == 1 and 1 or 0, function()
            if IsValid(pl) then
                local ActiveApparel = pl:GetApparel()
				
                if mdl.type == 1 then
                    if ActiveApparel[1] then
                        rp.data.SetActiveOff(pl, ActiveApparel[1])
                        ActiveApparel[1] = nil
                    end

                    if ActiveApparel[2] then
                        rp.data.SetActiveOff(pl, ActiveApparel[2])
                        ActiveApparel[2] = nil
                    end
                elseif mdl.type == 2 then
                    if ActiveApparel[1] then
                        rp.data.SetActiveOff(pl, ActiveApparel[1])
                        ActiveApparel[1] = nil
                    end

                    if ActiveApparel[2] then
                        rp.data.SetActiveOff(pl, ActiveApparel[2])
                        ActiveApparel[2] = nil
                    end

                    if ActiveApparel[3] then
                        rp.data.SetActiveOff(pl, ActiveApparel[3])
                        ActiveApparel[3] = nil
                    end
                elseif mdl.type == 3 then
                    if ActiveApparel[2] then
                        rp.data.SetActiveOff(pl, ActiveApparel[2])
                        ActiveApparel[2] = nil
                    end
                elseif mdl.type == 4 then
                    if ActiveApparel[4] then
                        rp.data.SetActiveOff(pl, ActiveApparel[4])
                        ActiveApparel[4] = nil
                    end
                end			
                -- ActiveApparel[mdl.type] = mdl.UID
                -- pl:SetNetVar('ActiveApparel', ActiveApparel)
            end

            if cback then
                cback()
            end
        end)
    end
end 

function rp.data.IsLoaded(pl)
	if IsValid(pl) and (pl:GetVar('DataLoaded') ~= true) then
		file.Append('data_load_err.txt', os.date() .. '\n' .. pl:Name() .. '\n' .. pl:SteamID() .. '\n' .. pl:SteamID64() .. '\n' .. debug.traceback() .. '\n\n')
		rp.Notify(pl, NOTIFY_ERROR,  term.Get('DataNotLoaded'))
		return false
	end
	return true
end

hook('InitPostEntity', 'data.InitPostEntity', function()
	db:Query('UPDATE player_data SET Money=' .. rp.cfg.StartMoney .. ' WHERE Money <' ..  rp.cfg.StartMoney/2)
end)

--
--	Meta
--
local math = math 

function PLAYER:AddMoney(amount)
	if not rp.data.IsLoaded(self) then return end

	local total = self:GetMoney() + math.floor(amount)
	rp.data.SetMoney(self, total)
	self:SetNetVar('Money', total)
end

function PLAYER:TakeMoney(amount)
	self:AddMoney(-math.abs(amount))
end

function PLAYER:AddKarma(amount, cback)
	if not rp.data.IsLoaded(self) then return end

	local total = self:GetKarma() + math.floor(amount)
	rp.data.SetKarma(self, total)
	self:SetNetVar('Karma', total)
end

function PLAYER:TakeKarma(amount)
	self:AddKarma(-math.abs(amount))
end