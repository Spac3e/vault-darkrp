util.AddNetworkString('rp.achievement.Finish')

local db = rp._Stats

local function SendFinished(pl, uid)
	net.Start('rp.achievement.Finish')
	net.WriteUInt(uid, 32)
	net.Send(pl)
end

function rp.achievements.Finish(pl, uid)
	if pl:GetNetVar('Achievement_'..uid) == -1 then return end
	pl:SetNetVar('Achievement_'..uid, -1)

	local ach = rp.achievements.List[uid]
	if ach.StoreProgress == false then return end

	SendFinished(pl, uid)
	
	if ach.OnFinish then
		ach.OnFinish(ach, pl)
	end
 
	local achs = pl:GetNetVar('Achs') or {}
	if !achs[uid] then achs[uid] = {} end
	achs[uid] = -1

	db:Query("UPDATE player_data SET Achs=? WHERE SteamID=?;", util.TableToJSON(achs), pl:SteamID64())
end

function rp.achievements.AddProgress(pl, uid, count)
	local progress = pl:GetNetVar('Achievement_'..uid) or 0
	progress = progress + 1
	pl:SetNetVar('Achievement_'..uid, progress)

	if rp.achievements.List[uid].StoreProgress == false || progress > rp.achievements.List[uid].Total then return end

	local achs = pl:GetNetVar('Achs') or {}
	if !achs[uid] then achs[uid] = {} end
	
	if progress >= rp.achievements.List[uid].Total then
		progress = -1
		SendFinished(pl, uid)
	end

	achs[uid] = progress

	db:Query("UPDATE player_data SET Achs=? WHERE SteamID=?;", util.TableToJSON(achs), pl:SteamID64())
end

function PLAYER:SetAchievementProgress(uid, progress)
	self:SetNetVar('Achievement_'..uid, progress)

	if rp.achievements.List[uid].StoreProgress == false then return end
	SendFinished(self, uid)

	local achs = self:GetNetVar('Achs') or {}
	if !achs[uid] then achs[uid] = {} end
	achs[uid] = progress

	db:Query("UPDATE player_data SET Achs=? WHERE SteamID=?;", util.TableToJSON(achs), self:SteamID64())
end

hook.Add("PlayerDataLoaded", 'loadachs', function(ply)
	for k,v in pairs(ply:GetNetVar'Achs' or {}) do
		ply:SetNetVar('Achievement_'..k, v)
	end
end)

hook.Add("PlayerTick", "achievmentload", function(ply)
	for k,v in pairs(rp.achievements.List) do
		if v.Tick then
			v.Tick(v, ply)
		end
		if v.GetProgress then
			if !ply["LastGameTickek"..v.UID] || CurTime()-ply["LastGameTickek"..v.UID] >= 1 then
				ply["LastGameTickek"..v.UID] = CurTime()
			else
				return
			end

			if v.Total <= v.GetProgress(v,ply) then
				rp.achievements.Finish(ply, v.UID)
			else
				ply:SetAchievementProgress(v.UID, v.GetProgress(v,ply))
			end
		end
	end
end)