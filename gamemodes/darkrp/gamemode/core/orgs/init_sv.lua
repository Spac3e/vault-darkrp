require('pcolor')

rp.orgs = rp.orgs or {}
rp.orgs.cached = rp.orgs.cached or {}

util.AddNetworkString('rp.OrgsMenu')
util.AddNetworkString('rp.SetOrgMoTD')
util.AddNetworkString('rp.OrgBannerReceived')
util.AddNetworkString('rp.OrgBannerInvalidate')
util.AddNetworkString('rp.SetOrgBanner')
util.AddNetworkString('org.setflag')
util.AddNetworkString('download.banner')
util.AddNetworkString('rp.SetOrgColor')
util.AddNetworkString('rp.AddEditOrgRank')
util.AddNetworkString('rp.QuitOrg')
util.AddNetworkString('rp.OrgKick')
util.AddNetworkString('rp.OrgInvite')
util.AddNetworkString('rp.OrgInviteResponse')
util.AddNetworkString('rp.RemoveOrgRank')
util.AddNetworkString('rp.RenameOrgRank')
util.AddNetworkString('rp.SetOrgName')
util.AddNetworkString('rp.PromoteOrgLeader')
util.AddNetworkString('rp.OrgSetRank')

local db = rp._Stats

local org_player = {}

local invites = {}

local function UpdateInv(id,str)
	invites[id] = invites[id] or {}
	invites[id][#invites[id]+1] = {
		str
	}
end


function UpdateOrgs()
	db:Query('SELECT * FROM org_player ', function(data2)
		org_player = data2
	end)
end

net.Receive('rp.QuitOrg', function(_,pl)
	if !pl:GetOrg() then return end
	local name = pl:GetOrg()
	local own = pl:IsOrgOwner()
	if own then 
		db:Query('DELETE FROM orgs WHERE Name=?;', name, function()
			db:Query('DELETE FROM org_player WHERE Org=?;', name, function()
				db:Query('DELETE FROM org_rank WHERE Org=?;', name, function()
					for k, v in ipairs(rp.orgs.GetOnlineMembers(name)) do
						v:SetOrg(nil, nil)
						v:SetOrgData(nil)
						rp.Notify(v, NOTIFY_ERROR, 'Организация '..name..' была распущена')
					end
					
					rp.orgs.cached[name] = nil
					
					if callback then callback() end
				end)
			end) 
		end)
	else 
		rp.Notify(pl, NOTIFY_GENERIC, 'Вы покинули организацию')
		db:Query('DELETE FROM org_player WHERE SteamID = ?',pl:SteamID64(),function()
			pl:SetOrg(nil, nil)
			pl:SetOrgData(nil)
			for k, v in ipairs(rp.orgs.GetOnlineMembers(name)) do
				if pl:SteamID64() == v:SteamID64() then continue end
				rp.Notify(v, NOTIFY_GENERIC, 'Игрок '..pl:Nick()..' покинул организацию')
			end
		end)
	end
end)

net.Receive('rp.OrgInvite', function(_,pl)
	local tar = net.ReadPlayer()
	-- print(tar)
	pl:TakeMoney(rp.cfg.OrgInviteCost)
	rp.Notify(tar, NOTIFY_GENERIC, 'Вам пришло приглашение в оргу')
	UpdateInv(tar:SteamID(),pl:GetOrg())
end) 

net.Receive('rp.OrgInviteResponse', function(_,pl)
	local name = net.ReadString()
	local targ = pl
	local b =net.ReadBool() 
	if b then  
		local org = name
		db:Query('SELECT * FROM orgs WHERE Name = ?', org, function(orgData)
			db:Query("SELECT * FROM org_rank WHERE Org=? AND Weight=1;", name, function(data)
				rp.orgs.Join(targ:SteamID64(), org, data[1].RankName, function()
					targ:SetOrg(org, pcolor.FromHex(orgData[1].Color))
					local orgdata = {
						Rank = data[1].RankName,
						MoTD = orgData[1].MoTD,
						Perms = {
							Weight = data[1].Weight,
							Owner = (data[1].Weight == 100),
							Invite = data[1].Invite,
							Kick = data[1].Kick,
							Rank = data[1].Rank,
							MoTD = data[1].MoTD
						}
					}
					
					targ:SetOrgData(orgdata)
					
					rp.orgs.cached[pl:GetOrg()].Members[targ:SteamID64()] = {
						SteamID=targ:SteamID64(),
						Org=org,
						Rank=data[1].RankName
					}
					targ:SetNetVar('OrgBanner',orgData[1].Banner)

					rp.Notify(rp.orgs.GetOnlineMembers(targ:GetOrg()), NOTIFY_SUCCESS, '# присоединился к #.', targ, targ:GetOrg())
					invites[targ:SteamID()] = nil
				end)
			end)
		end)
	else 
		invites[targ:SteamID()] = nil
	end 
end)  

net('rp.OrgSetRank', function(_,pl)
	local id = net.ReadString()
	local rank = net.ReadString()
	db:Query('UPDATE org_player SET Rank = ? WHERE Org = ? AND SteamID = ?',rank,pl:GetOrg(), id, function()
		local tar = player.GetBySteamID64(id)
		if tar then 
			db:Query('SELECT * FROM org_rank WHERE Org = ? AND RankName = ?',pl:GetOrg(),rank,function(perms)
				local upd = tar:GetNetVar('OrgData')
				upd.Rank = rank 
				local perm = upd.Perms 
				perm.Weight = perms[1].Weight 
				perm.Invite = perms[1].Invite 
				perm.Kick = perms[1].Kick 
				perm.Rank = perms[1].Rank
				perm.MoTD = perms[1].MoTD
				tar:SetNetVar('OrgData',upd)
			end)
		end
	end)
end)

net.Receive('rp.SetOrgName', function(_,pl)
	local new_name = net.ReadString()
	db:Query('SELECT * FROM orgs WHERE Name = ?',new_name, function(data)
		if #data == 0 then 
			db:Query('UPDATE org_player SET Org = ? WHERE Org = ?',new_name,pl:GetOrg(),function()
				db:Query('UPDATE orgs SET Name = ? WHERE Name = ?',new_name,pl:GetOrg(),function()
					db:Query('UPDATE org_rank SET Org = ? WHERE Org = ?',new_name,pl:GetOrg(),function()
						db:Query('SELECT * FROM org_player WHERE Org = ?',new_name,function(data2)
							for i = 1, #data2 do 
								local id = data2[i].SteamID 
								if player.GetBySteamID64(id) then 
									player.GetBySteamID64(id):SetNetVar('Org',new_name)
								end
							end
						end)
					end)
				end)
			end)
		else
		end
	end)
	
end)

net('rp.PromoteOrgLeader', function(_,pl)
	if !pl:IsOrgOwner() then return end 
	local tar = net.ReadString()
	db:Query('UPDATE org_player SET Rank = "Owner" WHERE SteamID = ?', tar, function()
		db:Query('SELECT * FROM org_rank WHERE Weight = 1 AND Org = ?', pl:GetOrg(), function(rank)
			db:Query('UPDATE org_player SET Rank = ? WHERE SteamID = ? AND Org = ?', rank[1].RankName, pl:SteamID64(), pl:GetOrg(), function()
				if player.GetBySteamID64(tar) then
					local tbl = player.GetBySteamID64(tar):GetNetVar('OrgData')
					tbl['Rank'] = 'Owner'
					tbl['Perms'].Invite = true
					tbl['Perms'].Kick = true 
					tbl['Perms'].MoTD = true
					tbl['Perms'].Owner  = true
					tbl['Perms'].Rank = true
					tbl['Perms'].Weight = 100
					player.GetBySteamID64(tar):SetNetVar('OrgData', tbl)
				end 		
			end)
			local tbll = pl:GetNetVar('OrgData')
			tbll.Rank= rank[1].RankName
			tbll.Perms.Invite = false
			tbll.Perms.Kick = false
			tbll.Perms.MoTD = false
			tbll.Perms.Owner  = false
			tbll.Perms.Rank = false
			tbll.Perms.Weight = 1
			pl:SetNetVar('OrgData',tbll)
		end)
	end)
end)

net.Receive('rp.OrgsMenu', function(_,pl)
	if pl:GetOrg() != nil then 
		UpdateOrgs()
		db:Query('SELECT * FROM org_rank WHERE Org = ?;',pl:GetOrg(), function(data)
			db:Query('SELECT * FROM org_player WHERE Org = ?',pl:GetOrg(), function(dataa)
					db:Query('SELECT org_player.SteamID, org_player.Rank, player_data.Name, ba_users.lastseen FROM org_player LEFT JOIN player_data ON org_player.SteamID = player_data.SteamID LEFT JOIN ba_users ON ba_users.SteamID = org_player.SteamID WHERE org_player.Org = ?;', pl:GetOrg(), function(members)
						net.Start('rp.OrgsMenu')
						net.WriteBool(pl:GetOrg())
						net.WriteTable(data)
						net.WriteTable(members)
						net.Send(pl)
					end)
			end)	
			
		end)
	else 
		net.Start('rp.OrgsMenu') 
		net.WriteBool(pl:GetOrg()) 
		if invites[pl:SteamID()] then 
			net.WriteUInt(#invites[pl:SteamID()],4) 
			for _, v in pairs(invites[pl:SteamID()]) do 
				net.WriteString(v[1])
			end  
		else  
			net.WriteUInt(0,4)
		end
		-- net.WriteString('333')
		net.Send(pl)
	end
	
end) 



net('rp.OrgKick',function(_,pl)
	local id = net.ReadString()
	local tar = player.GetBySteamID64(id)
	db:Query('DELETE FROM org_player WHERE SteamID=?;', id, function()
		if IsValid(tar) then
			rp.Notify(rp.orgs.GetOnlineMembers(pl:GetOrg()), NOTIFY_ERROR, '# кикнут из организации #.', tar, pl:GetOrg())
			rp.Notify(tar, NOTIFY_ERROR, 'Вы были кикнуты из организации #.', tar:GetOrg())
			tar:SetOrg(nil, nil)
			tar:SetOrgData(nil)
		end
		rp.orgs.cached[pl:GetOrg()].Members[id] = nil

		-- if callback then callback() end
	end)
end)

net.Receive('org.setflag', function(_,pl)
	local src = net.ReadString()
	// https://i.imgur.com/U3x8O9j.png
	
	if src:find('https://i.imgur.com') then 
		local src = src:Replace('https://i.imgur.com/','')
		db:Query('UPDATE orgs SET Banner = ? WHERE Name = ?',src,pl:GetOrg())
		-- pl:SetNetVar('OrgBanner',src)
		db:Query('SELECT * FROM org_player', function(data)
			for _, v in ipairs(data) do 
				local id = v.SteamID
				if player.GetBySteamID64(id) then 
					player.GetBySteamID64(id):SetNetVar('OrgBanner',src)
				end
			end
		end)
	end
end)

net.Receive('rp.AddEditOrgRank', function(_,pl)
	local b = net.ReadBool()
	local tbl = net.ReadTable()
	if b then 
		db:Query('INSERT INTO org_rank VALUES(?,?,?,?,?,?,?)',pl:GetOrg(),tbl.Name,tbl.Weight,tbl.Invite,tbl.Kick,tbl.Rank,tbl.MoTD)
	else 
		db:Query('UPDATE org_rank SET '..tbl[1]..' = ? WHERE RankName = ? AND Org = ?',tbl[2],tbl[3], pl:GetOrg(), function()
			local upd = rp.orgs.GetOnlineMembers(pl:GetOrg())
		--	PrintTable(tbl)
			for i = 1 , #upd do 
				if upd[i]:GetOrgRank() == tbl[3] then 
					local perm = upd[i]:GetNetVar('OrgData')
					perm.Perms[tbl[1]] = tbl[2]
					upd[i]:SetNetVar('OrgData',perm)
				end
			end
		end)
	end
end)

net.Receive('rp.RemoveOrgRank', function(_,pl)
	local rank = net.ReadString()
	db:Query('DELETE FROM org_rank WHERE RankName = ? AND Org = ?',rank,pl:GetOrg(), function()
		db:Query('SELECT * FROM org_rank WHERE Weight = 1 AND Org = ?', pl:GetOrg(), function(minrank)
			local tbl = rp.orgs.GetOnlineMembers(pl:GetOrg())
			for i=1, #tbl do 
				if tbl[i]:GetOrgRank() == rank then 
					local tbll = tbl[i]:GetNetVar('OrgData')
					tbll.Rank= minrank[1].RankName
					tbll.Perms.Invite = false
					tbll.Perms.Kick = false
					tbll.Perms.MoTD = false
					tbll.Perms.Owner  = false
					tbll.Perms.Rank = false
					tbll.Perms.Weight = 1
					tbl[i]:SetNetVar('OrgData',tbll)
				--	print('ТАК',minrank[1].RankName, tbl[i]:SteamID64(), pl:GetOrg())
					db:Query('UPDATE org_player SET Rank = ? WHERE SteamID = ? AND Org = ?',minrank[1].RankName, tbl[i]:SteamID64(), pl:GetOrg() , function() end)
				end
			end
			
		end)
	end)
	
end)

net('rp.RenameOrgRank',function(_,pl)
	local name = net.ReadString()
	local new = net.ReadString()
	if name == 'Owner' then rp.Notify(pl, NOTIFY_ERROR, 'Нельзя переименовать ранг Owner') return end
	db:Query('UPDATE org_rank SET RankName = ? WHERE RankName = ? AND Org = ?',new,name,pl:GetOrg())
end)

net.Receive('rp.SetOrgColor', function(_,pl)
	local clr = net.ReadString()
	db:Query('UPDATE orgs SET Color = ? WHERE Name = ?', clr, pl:GetOrg())
	db:Query('SELECT * FROM org_player WHERE Org = ?',pl:GetOrg(), function(data)
		for i = 1, #data do 
			local pl = player.GetBySteamID64(data[i].SteamID)
			
			if pl then 
				pl:SetNetVar('OrgColor',clr)
			end
		end
	end)
end)

-- Creation & Modification
function rp.orgs.Exists(name, cback)
	db:Query('SELECT COUNT("Name") FROM orgs WHERE Name=?;', name, function(count)
		cback(count[1]['COUNT("Name")'] and tonumber(count[1]['COUNT("Name")']) > 0)
	end)
end

function rp.orgs.Create(steamid, name, color, callback)
	db:Query('INSERT INTO orgs(Owner, Name, Color, MoTD, Banner) VALUES(?, ?, ?, ?, ?);', steamid, name, pcolor.ToHex(color), 'Welcome to ' .. name .. '!', 'xUX4mJP.png' , function()
		db:Query('INSERT INTO org_rank(Org, RankName, Weight, Invite, Kick, Rank, MoTD) VALUES(?, ?, ?, ?, ?, ?, ?),(?, ?, ?, ?, ?, ?, ?);', name, 'Owner', 100, 1, 1, 1, 1, name, 'Member', 1, 0, 0, 0, 0, function()
			rp.orgs.cached[name] = {
				Members = {},
				Ranks = {
					Owner = {
						Org=name,
						RankName='Owner',
						Weight=100,
						Invite=true,
						Kick=true,
						Rank=true,
						MoTD=true
					},
					Members = {
						Org=name,
						RankName='Member',
						Weight=1,
						Invite=false,
						Kick=false,
						Rank=false,
						MoTD=false
					}
				}
			}
			-- db:Query('INSERT INTO org_banner VALUES(?,?,?)',name,os.time(),'0')
			rp.orgs.Join(steamid, name, 'Owner', callback)
			
		end)
		
	end)

end


function rp.orgs.Remove(name, callback)
	db:Query('DELETE FROM orgs WHERE Name=?;', name, function()
		db:Query('DELETE FROM org_player WHERE Org=?;', name, function()
			db:Query('DELETE FROM org_rank WHERE Org=?;', name, function()
				db:Query('DELETE FROM org_banner WHERE Org=?;', name, function()
					for k, v in ipairs(rp.orgs.GetOnlineMembers(name)) do
						v:SetOrg(nil, nil)
						v:SetOrgData(nil)
						rp.Notify(v, NOTIFY_ERROR, rp.Term('OrgDisbanded'), name)
					end
					
					rp.orgs.cached[name] = nil
					
					if callback then callback() end
				end)
			end)
		end) 
	end)
end

function rp.orgs.Remove(name, callback)
	db:Query('DELETE FROM orgs WHERE Name=?;', name, function()
		db:Query('DELETE FROM org_player WHERE Org=?;', name, function()
			db:Query('DELETE FROM org_rank WHERE Org=?;', name, function()
				for k, v in ipairs(rp.orgs.GetOnlineMembers(name)) do
					v:SetOrg(nil, nil)
					v:SetOrgData(nil)
					rp.Notify(v, NOTIFY_ERROR, "# был распущен!", name)
				end
				
				rp.orgs.cached[name] = nil
				
				if callback then callback() end
			end)
		end)
	end)
end

function rp.orgs.Quit(steamid, callback)
	db:Query('DELETE FROM org_player WHERE SteamID=?;', steamid, callback)
end

function rp.orgs.SetMoTD(org, motd, callback)
	db:Query('UPDATE orgs SET MoTD=? WHERE Name=?', motd, org, function() -- this line was not playing nice
		for k, v in ipairs(rp.orgs.GetOnlineMembers(org)) do
			local dat = v:GetOrgData()
			dat.MoTD = motd
			v:SetOrgData(dat)
		end
		if callback then callback() end
	end)
end

function rp.orgs.SetColor(org, color, callback)
	db:Query('UPDATE orgs SET Color=? WHERE Name=?', pcolor.ToHex(color), org, function()
		for k, v in ipairs(rp.orgs.GetOnlineMembers(org)) do
			v:SetOrg(org, color)
		end
		if callback then callback() end
	end)
end


-- Members
function PLAYER:SetOrg(name, color)
	self:SetNetVar('Org', name)
	-- print('Задан ORG')
	if color then 
		color = pcolor.ToHex(color)
	else 
		color = nil
	end
	self:SetNetVar('OrgColor', color)
end

function rp.orgs.Join(steamid, org, rank, callback)
	rp.orgs.cached[org] = rp.orgs.cached[org] or {}
	rp.orgs.cached[org].Members = rp.orgs.cached[org].Members or {}
	rp.orgs.cached[org].Members[steamid] = {
		SteamID=steamid,
		Org=org,
		Rank=rank
	}
	
	db:Query('INSERT INTO org_player(SteamID, Org, Rank) VALUES(?, ?, ?);', steamid, org, rank, callback)
end

function rp.orgs.Kick(steamid, callback)
	local pl = rp.FindPlayer(steamid)
	if (pl) then steamid = pl:SteamID64() end
	
	db:Query('DELETE FROM org_player WHERE SteamID=?;', steamid, function()
		if IsValid(pl) then
			rp.Notify(rp.orgs.GetOnlineMembers(pl:GetOrg()), NOTIFY_ERROR, '# кикнут из организации #.', pl, pl:GetOrg())
			rp.Notify(pl, NOTIFY_ERROR, 'Вы были кикнуты из организации #.', pl:GetOrg())
			pl:SetOrg(nil, nil)
			pl:SetOrgData(nil)
		end
		
		if callback then callback() end
	end) 
end

function rp.orgs.GetMembers(org, callback)
	db:Query("SELECT * FROM org_rank WHERE Org=? ORDER BY Weight DESC;", org, function(ranks)
		db:Query('SELECT org_player.SteamID, org_player.Rank, player_data.Name FROM org_player LEFT JOIN player_data ON org_player.SteamID = player_data.SteamID WHERE org_player.Org = ?;', org, function(members)
		
			rp.orgs.cached[org] = {
				Ranks = {},
				Members = {},
				RanksOrdered = ranks
			}
			
			for k, v in ipairs(ranks) do
				rp.orgs.cached[org].Ranks[v.RankName] = v
			end
			
			for k, v in ipairs(members) do
				rp.orgs.cached[org].Members[v.SteamID] = v
			end
			
			if (callback) then callback(members, ranks) end
		end)
	end)
end

function rp.orgs.GetMemberCount(name, cback)
	db:Query('SELECT COUNT("Name") FROM org_player WHERE Org=?;', name, function(count)
		cback(count[1]['COUNT("Name")'] and tonumber(count[1]['COUNT("Name")']) or 0)
	end)
end

-- Ranks
function PLAYER:SetOrgData(d)
	self:SetNetVar('OrgData', d)
end

function rp.orgs.RecalculateWeights(org, ranks)
	table.SortByMember(ranks, 'Weight', true)
	
	local mems = rp.orgs.GetOnlineMembers(org)
	
	for k, v in ipairs(ranks) do
		local newWeight = 1 + math.floor(((k - 1) / (#ranks - 1)) * 99)
		
		if (newWeight != v.Weight) then		
			for _, pl in pairs(mems) do
				local od = pl:GetOrgData()
				if (od.Rank == v.RankName) then
					od.Weight = v.Weight
					pl:SetOrgData(od)
				end
			end
			
			db:Query('UPDATE org_rank SET Weight=? WHERE Org=? AND RankName=?', newWeight, org, v.RankName)
		end
		
		rp.orgs.cached[org].Ranks[v.RankName].Weight = newWeight
	end
end

function rp.orgs.CanTarget(pl, targID)
	if (!pl:GetOrg()) then return false end
	if (pl:SteamID64() == targID) then return false end
	if (#tostring(targID) != 17) then return false end
	
	if (!rp.orgs.cached[pl:GetOrg()]) then rp.orgs.GetMembers(pl:GetOrg()) end
	
	local targrank = rp.orgs.cached[pl:GetOrg()].Ranks[rp.orgs.cached[pl:GetOrg()].Members[targID].Rank] or rp.orgs.cached[pl:GetOrg()].RanksOrdered[#rp.orgs.cached[pl:GetOrg()].RanksOrdered]
	if (pl:GetOrgData().Perms.Weight <= targrank.Weight) then return false end
	
	return true
end

-- Load data
local function SetOrg(pl, d)
	pl:SetOrg(d.Name, pcolor.FromHex(d.Color))
	local r = d.OrgData
	pl:SetOrgData({
		Rank 	= d.Rank or r.Perms.RankName,
		MoTD 	= d.MoTD,
		Perms 	= {
			Weight 	= r.Perms.Weight,
			Owner 	= (r.Perms.Weight == 100),
			Invite 	= r.Perms.Invite,
			Kick 	= r.Perms.Kick,
			Rank 	= r.Perms.Rank,
			MoTD 	= r.Perms.MoTD,
		}
	})
end


hook('PlayerAuthed', 'rp.orgs.PlayerAuthed', function(pl)
--concommand.Add('or', function(pl)
	local steamid = pl:SteamID64()
	db:Query('SELECT * FROM org_player LEFT JOIN orgs ON org_player.Org = orgs.Name WHERE org_player.SteamID=' .. steamid .. ';', function(data)
		local d = data[1]
		if d then
			d.OrgData = {}
			db:Query('SELECT * FROM org_rank WHERE Org = "' .. d.Org .. '" AND RankName = "' .. d.Rank .. '";', function(data)
				local _d = data[1]
				if _d then
					d.OrgData.Perms = _d
					SetOrg(pl, d)
				end
			end)
		end
	end)
end)


-- Commands
rp.AddCommand('createorg', function(pl, text, args)

	// local name = string.Trim(args[1] or '')
	local name = text

	if (pl:GetOrg() ~= nil) then
		rp.Notify(pl, NOTIFY_ERROR, 'Вам нужно покинуть организацию чтобы создать новую.')
		return
	end

	if (string.len(name) < 2) then
		rp.Notify(pl, NOTIFY_ERROR, 'Пожалуйста, сделайте название своей организации длиннее чем 2 буквы.')
		return
	end

	if (string.len(name) > 32) then
		rp.Notify(pl, NOTIFY_ERROR, 'Пожалуйста, сделайте название своей организации короче чем чем 32 буквы.')
		return
	end

	rp.orgs.Exists(name, function(exists)
		if (!IsValid(pl)) then return end
		
		if (exists) then
			rp.Notify(pl, NOTIFY_ERROR, 'Это имя уже занято. Пожалуйста выберите другое!')
			return
		end

		if not pl:CanAfford(rp.cfg.OrgCost) then
			rp.Notify(pl, NOTIFY_ERROR, 'Вы не можете позволить себе создать организацию.')
			return
		end

		local color = Color(255,255,255)
		local start = SysTime() 
		
		rp.orgs.Create(pl:SteamID64(), name, color, function()
			pl:TakeMoney(rp.cfg.OrgCost)
			pl:SetOrg(name, color)
			local orgdata = rp.orgs.BaseData['Owner']
			orgdata.MoTD = 'Welcome to ' .. name .. '!'
			pl:SetNetVar('OrgBanner','xUX4mJP.png')
			pl:SetOrgData(orgdata)
			rp.Notify(pl, NOTIFY_SUCCESS, 'Вы успешно создали свою организацию.')
			
		end)
	end)
end)
:AddParam(cmd.STRING)

net('rp.SetOrgMoTD', function(len, pl)
	if not pl:GetOrg() or not pl:GetOrgData() or not pl:GetOrgData().Perms then return end

	local motd = net.ReadString()
	if #motd >= 1024 then 
		rp.Notify(pl, NOTIFY_ERROR, 'Слишком длинный MoTD')
		return 
	end
	rp.orgs.SetMoTD(pl:GetOrg(), motd, function()
		rp.Notify(pl, NOTIFY_SUCCESS, 'Вы изменили вашу организацию MoTD.')
	end)
end)

concommand.Add('setorgcolor', function(pl, text, args)
	if not pl:GetOrg() or not pl:GetOrgData() or not pl:GetOrgData().Perms or not pl:GetOrgData().Perms.Owner then return end

	local color = Color(tonumber(args[1] or 255), tonumber(args[2] or 255), tonumber(args[3] or 255))

	rp.orgs.SetColor(pl:GetOrg(), color, function()
		rp.Notify(pl, NOTIFY_SUCCESS, 'Вы изменили цвет организации.')
	end)
end)

concommand.Add('orgmenu', function(pl, text, args)
	if not pl:GetOrg() then return end

	rp.orgs.GetMembers(pl:GetOrg(), function(members, ranks)
		net.Start('rp.OrgsMenu')
			local rankref = {}

			net.WriteUInt(#ranks, 4)
			for k, v in ipairs(ranks) do
				net.WriteString(v.RankName)
				net.WriteUInt(v.Weight, 7)
				net.WriteBool(v.Invite)
				net.WriteBool(v.Kick)
				net.WriteBool(v.Rank)
				net.WriteBool(v.MoTD)
				
				rankref[v.RankName] = v.RankName
			end
			
			net.WriteUInt(#members, 8)
			for k, v in ipairs(members) do
				net.WriteString(v.SteamID)
				net.WriteString(v.Name)
				net.WriteString(rankref[v.Rank] or ranks[#ranks].Rank) -- fix for players being a rank that doesnt exist
			end

		net.Send(pl)
	end)
end)

concommand.Add('quitorg', function(pl, text, args)
	if not pl:GetOrg() or not pl:GetOrgData() or not pl:GetOrgData().Perms then return end
	if (!rp.orgs.cached[pl:GetOrg()]) then rp.orgs.GetMembers(pl:GetOrg()) end
	
	if (pl:GetOrgData().Rank == "Stuck") and (not pl:IsRoot()) then
		rp.Notify(pl, NOTIFY_ERROR, 'Вы застряли! >:)')
		return
	end -- EASTER EGGS
	
	if pl:GetOrgData().Perms.Owner then
		rp.orgs.Remove(pl:GetOrg())
	else
		rp.orgs.Quit(pl:SteamID64(), function()
			rp.orgs.cached[pl:GetOrg()].Members[pl:SteamID64()] = nil
		
			rp.Notify(rp.orgs.GetOnlineMembers(pl:GetOrg()), NOTIFY_ERROR, '# вышел из #!', pl, pl:GetOrg())
			pl:SetOrg(nil, nil)
			pl:SetOrgData(nil)
		end)
	end
end)

concommand.Add('orgkick', function(pl, text, args)
	if not args[1] or not pl:GetOrg() or not pl:GetOrgData() or not pl:GetOrgData().Perms or not pl:GetOrgData().Perms.Kick or not rp.orgs.CanTarget(pl, args[1]) then return end
	
	rp.orgs.cached[pl:GetOrg()].Members[args[1]] = nil
	
	rp.orgs.Kick(args[1])
end)

concommand.Add('orginvite', function(pl, text, args)
	if not args[1] or not pl:GetOrg() or not pl:GetOrgData() or not pl:GetOrgData().Perms or not pl:GetOrgData().Perms.Invite then return end
	local targ = rp.FindPlayer(args[1])
	
	if (targ:GetOrg()) then return end
	
	if (!rp.orgs.cached[pl:GetOrg()]) then rp.orgs.GetMembers(pl:GetOrg()) end

	local org = pl:GetOrg()

	rp.orgs.GetMemberCount(org, function(count)
		if (!IsValid(pl)) then return end
		
		local lim = (500)
		if (count >= lim) then
			rp.Notify(pl, NOTIFY_ERROR, 'Вы достигли максимального количество # членов в организации!', lim)
			return
		end

		if not IsValid(targ) then return end
		
		if (targ.OrgInvites and targ.OrgInvites[org]) then return end
		targ.OrgInvites = targ.OrgInvites or {}
		targ.OrgInvites[org] = true
		GAMEMODE.ques:Create("Хотели бы вы присоединиться " .. org, util.CRC(pl:SteamID() .. targ:SteamID()), targ, 300, function(resp)
			if (tobool(resp) == true)  then
				db:Query("SELECT * FROM org_rank WHERE Org=? AND Weight=1;", pl:GetOrg(), function(data)
					rp.orgs.Join(targ:SteamID64(), org, data[1].RankName, function()
						targ:SetOrg(org, pl:GetOrgColor())
						local orgdata = {
							Rank = data[1].RankName,
							MoTD = pl:GetOrgData().MoTD,
							Perms = {
								Weight = data[1].Weight,
								Owner = (data[1].Weight == 100),
								Invite = data[1].Invite,
								Kick = data[1].Kick,
								Rank = data[1].Rank,
								MoTD = data[1].MoTD
							}
						}
						
						targ:SetOrgData(orgdata)
						
						rp.orgs.cached[pl:GetOrg()].Members[targ:SteamID64()] = {
							SteamID=targ:SteamID64(),
							Org=org,
							Rank=data[1].RankName
						}
						
						rp.Notify(rp.orgs.GetOnlineMembers(targ:GetOrg()), NOTIFY_SUCCESS, '# присоединился к #.', targ, targ:GetOrg())
						targ.OrgInvites[org] = nil
					end)
				end)
			end	
		end)
	end)
end)

concommand.Add('orgsetrank', function(pl, text, args)
	if not args[1] or not pl:GetOrg() or not pl:GetOrgData() or not pl:GetOrgData().Perms or not pl:GetOrgData().Perms.Rank or not rp.orgs.CanTarget(pl, args[1]) then return end
	
	local rankName = args[2]
	local cache = rp.orgs.cached[pl:GetOrg()].Ranks
	
	if (!cache[rankName] or pl:GetOrgData().Perms.Weight <= cache[rankName].Weight) then return end
	
	db:Query('SELECT * FROM org_rank WHERE Org=?', pl:GetOrg(), function(ranks)
		for k, v in ipairs(ranks) do
			if (v.RankName == rankName) then
				db:Query("UPDATE org_player SET Rank=? WHERE SteamID=?;", rankName, args[1])
				
				local targ = rp.FindPlayer(args[1])
				if (targ) then
					local od = targ:GetOrgData()
					
					targ:SetOrgData({
						Rank 	= v.RankName,
						MoTD 	= od.MoTD,
						Perms 	= {
							Weight 	= v.Weight,
							Owner 	= (v.Weight == 100),
							Invite 	= v.Invite,
							Kick 	= v.Kick,
							Rank 	= v.Rank,
							MoTD 	= v.MoTD
						}
					})
					
					rp.Notify(targ, NOTIFY_GENERIC, '# установил ваш ранг #.', pl, rankName)
					rp.Notify(pl, NOTIFY_GENERIC, '# добавлен #.', targ, rankName)
				else					
					rp.Notify(pl, NOTIFY_GENERIC, '# добавлен #.', args[1], rankName)
				end
				
				rp.orgs.cached[pl:GetOrg()].Members[args[1]].Rank = rankName
				
				return
			end
		end
		
		rp.Notify(pl, NOTIFY_ERROR, 'неизвестный ранг #.', rankName)
	end)
end)

concommand.Add('orgrank', function(pl, text, args)
	local perms = pl:GetOrg() and pl:GetOrgData() and pl:GetOrgData().Perms
	
	if (!args[1] or !perms or !perms.Owner) then return end

	if (!rp.orgs.cached[pl:GetOrg()]) then rp.orgs.GetMembers(pl:GetOrg()) end
	
	local rankName = args[1]
	local newName
	local weight
	local invite
	local kick
	local rank
	local motd
	
	if (args[6]) then
		weight = tonumber(args[2])
		invite = args[3]
		kick = args[4]
		rank = args[5]
		motd = args[6]
	else
		newName = args[2]
	end
	
	db:Query('SELECT * FROM org_rank WHERE Org=?', pl:GetOrg(), function(ranks)
		for k, v in ipairs(ranks) do
			if (v.RankName == rankName) then
				if (newName) then
					db:Query("UPDATE org_rank SET RankName=? WHERE Org=? AND RankName=?", newName, pl:GetOrg(), rankName, function()
						db:Query("UPDATE org_player SET Rank=? WHERE Org=? AND Rank=?;", newName, pl:GetOrg(), rankName)
						
						rp.Notify(pl, NOTIFY_SUCCESS, 'Ранг # переименован в #.', rankName, newName)
						
						for k, v in ipairs(rp.orgs.GetOnlineMembers(pl:GetOrg())) do
							if (v:GetOrgData().Rank == rankName) then
								local orgData = v:GetOrgData()
								orgData.Rank = newName
								v:SetOrgData(orgData)
							end
						end
						
						for k, v in pairs(rp.orgs.cached[pl:GetOrg()].Members) do
							if (v.Rank == rankName) then
								v.Rank = newName
							end
						end
						
						rp.orgs.cached[pl:GetOrg()].Ranks[newName] = rp.orgs.cached[pl:GetOrg()].Ranks[rankName]
						rp.orgs.cached[pl:GetOrg()].Ranks[newName].RankName = newName
						rp.orgs.cached[pl:GetOrg()].Ranks[rankName] = nil
					end)
					
					return
				end
				
				if (weight != v.Weight) then
					if (v.Weight == 100 or v.Weight == 1) then
						rp.Notify(pl, NOTIFY_ERROR, 'Вы не можете изменить Высший и Низший ранги.')
						return
					end
					
					v.Weight = weight
					rp.orgs.RecalculateWeights(pl:GetOrg(), ranks)
					return
				end
				
				db:Query("UPDATE org_rank SET Invite=?, Kick=?, Rank=?, MoTD=? WHERE Org=? AND RankName=?;", invite, kick, rank, motd, pl:GetOrg(), rankName, function()
					rp.Notify(pl, NOTIFY_SUCCESS, 'Ранг # обновлен.', rankName)
					
					for k, v in ipairs(rp.orgs.GetOnlineMembers(pl:GetOrg())) do
						if (v:GetOrgData().Rank == rankName) then
							v:SetOrgData({
								Rank 	= rankName,
								MoTD 	= v:GetOrgData().MoTD,
								Perms 	= {
									Weight 	= weight,
									Owner 	= (weight == 100),
									Invite 	= tobool(invite),
									Kick 	= tobool(kick),
									Rank 	= tobool(rank),
									MoTD 	= tobool(motd)
								}
							})
						end
					end
					
					local cache = rp.orgs.cached[pl:GetOrg()].Ranks[rankName]
					cache.Invite = tobool(invite)
					cache.Kick = tobool(kick)
					cache.Rank = tobool(rank)
					cache.MoTD = tobool(motd)
				end)
				
				return
			end
		end
		
		-- Insert time!
		if (#ranks >= (5)) then
			rp.Notify(pl, NOTIFY_ERROR, 'Максимальный ранг достигнут.')
			return
		end
		
		db:Query("INSERT INTO org_rank(Org, RankName, Weight, Invite, Kick, Rank, MoTD) VALUES(?, ?, ?, ?, ?, ?, ?);", pl:GetOrg(), rankName, weight, invite, kick, rank, motd, function()
			rp.orgs.cached[pl:GetOrg()].Ranks[rankName] = ranks[table.insert(ranks, {
				Org = pl:GetOrg(),
				RankName = rankName,
				Weight = weight,
				Invite = tobool(invite),
				Kick = tobool(kick),
				Rank = tobool(rank),
				MoTD = tobool(motd)
			})]
			
			rp.orgs.RecalculateWeights(pl:GetOrg(), ranks)
			
			rp.Notify(pl, NOTIFY_SUCCESS, 'Ранг # Создан.', rankName)
		end)
	end)
end)

concommand.Add('orgrankremove', function(pl, text, args)
	local perms = pl:GetOrg() and pl:GetOrgData() and pl:GetOrgData().Perms
	
	if (!args[1] or !perms or !perms.Owner) then return end
	
	if (!rp.orgs.cached[pl:GetOrg()]) then rp.orgs.GetMembers(pl:GetOrg()) end
	
	local rankName = args[1]
	
	db:Query("SELECT * FROM org_rank WHERE Org=? ORDER BY Weight DESC", pl:GetOrg(), function(ranks)
		for k, v in ipairs(ranks) do
			if (v.RankName == rankName) then
				if (k == 1 or k == #ranks) then
					rp.Notify(pl, NOTIFY_ERROR, 'Вы не можете удалить высший и низший ранг.')
					return
				end
				
				local nextRank = ranks[k+1]
				db:Query("UPDATE org_player SET Rank=? WHERE Org=? AND Rank=?", nextRank.RankName, pl:GetOrg(), rankName)
				db:Query("DELETE FROM org_rank WHERE Org=? AND RankName=?", pl:GetOrg(), rankName)
				for _, pl in ipairs(rp.orgs.GetOnlineMembers(pl:GetOrg())) do
					local od = pl:GetOrgData()
					
					if (od.Rank == rankName) then
						od = {
							Rank 	= nextRank.RankName,
							MoTD 	= od.MoTD,
							Perms 	= {
								Weight 	= nextRank.Weight,
								Owner 	= (nextRank.Weight == 100),
								Invite 	= nextRank.Invite,
								Kick 	= nextRank.Kick,
								Rank 	= nextRank.Rank,
								MoTD 	= nextRank.MoTD,
							}
						}
						
						pl:SetOrgData(od)
					end
				end
				
				for _, mem in pairs(rp.orgs.cached[pl:GetOrg()].Members) do
					if (mem.Rank == rankName) then
						mem.Rank = nextRank.Name
					end
				end
				
				rp.orgs.cached[pl:GetOrg()].Ranks[rankName] = nil
				
				rp.Notify(pl, NOTIFY_SUCCESS, 'Ранг # удалён.', rankName)
				
				return
			end
		end
		
		rp.Notify(pl, NOTIFY_ERROR, 'неизвестный ранг #.', rankName)
	end)
end)

local function OrgChat(pl, text, args) 
	if (pl:GetOrg() == nil) then return end 
	rp.Chat(CHAT_ORG, rp.orgs.GetOnlineMembers(pl:GetOrg()), pl:GetOrgColor(), '[ORG] ', pl, table.concat(args, ' ')) 
end 

net('rp.SetOrgBanner', function(len, pl)
	if (!pl:GetOrg() or !pl:GetOrgData().Perms.Owner) then return end
	// if (!pl:HasUpgrade('org_prem')) then return end
	
	local data = {}
	
	local dim = net.ReadUInt(7)
	
	for i=0, dim do
		data[i] = {}
		
		for k=0, dim do
			local size = net.ReadUInt(5)
			local px = net.ReadUInt(size)
			
			data[i][k] = px
		end
	end
	
	net.Start('rp.OrgBannerReceived')
	net.Send(pl)
	
	rp.Notify(pl, NOTIFY_GREEN, rp.Term('OrgBannerUpdated'))
	
	db:Query('REPLACE INTO org_banner (Org, Time, Data) VALUES(?, ?, ?);', pl:GetOrg(), os.time(), util.TableToJSON(data), function()
		net.Start('rp.OrgBannerInvalidate')
			net.WriteString(pl:GetOrg())
		net.Broadcast()
	end)
end)