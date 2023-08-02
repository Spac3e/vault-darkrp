
--[[

~ yuck, anti cheats! ~

~ file stolen by ~
                __  .__                          .__            __                 .__               
  _____   _____/  |_|  |__ _____    _____ ______ |  |__   _____/  |______    _____ |__| ____   ____  
 /     \_/ __ \   __\  |  \\__  \  /     \\____ \|  |  \_/ __ \   __\__  \  /     \|  |/    \_/ __ \ 
|  Y Y  \  ___/|  | |   Y  \/ __ \|  Y Y  \  |_> >   Y  \  ___/|  |  / __ \|  Y Y  \  |   |  \  ___/ 
|__|_|  /\___  >__| |___|  (____  /__|_|  /   __/|___|  /\___  >__| (____  /__|_|  /__|___|  /\___  >
      \/     \/          \/     \/      \/|__|        \/     \/          \/      \/        \/     \/ 

~ purchase the superior cheating software at https://methamphetamine.solutions ~

~ server ip: 212.22.93.35_27015 ~ 
~ file: addons/plib_v2/lua/plib/extensions/player.lua ~

]]

local PLAYER, ENTITY = FindMetaTable 'Player', FindMetaTable 'Entity'
local GetTable = ENTITY.GetTable

-- Utils
function player.Find(info)
	info = tostring(info)
	for k, v in ipairs(player.GetAll()) do
		if (info == v:SteamID()) or (info == v:SteamID64()) or (string.find(string.lower(v:Name()), string.lower(info), 1, true) ~= nil) then
			return v
		end
	end
end

function player.GetStaff()
	return table.Filter(player.GetAll(), PLAYER.IsAdmin)
end

-- meta
function PLAYER:__index(key)
	return PLAYER[key] or ENTITY[key] or GetTable(self)[key]
end

function PLAYER:Timer(name, time, reps, callback, failure)
	name = self:SteamID64() .. '-' .. name
	timer.Create(name, time, reps, function()
		if IsValid(self) then
			callback(self)
		else
			if (failure) then
				failure()
			end

			timer.Destroy(name)
		end
	end)
end

function PLAYER:DestroyTimer(name)
	timer.Destroy(self:SteamID64() .. '-' .. name)
end

-- Fix for https://github.com/Facepunch/garrysmod-issues/issues/2447
local telequeue = {}
local setpos = ENTITY.SetPos
function PLAYER:SetPos(pos)
	telequeue[self] = pos
end

hook.Add('FinishMove', 'SetPos.FinishMove', function(pl)
	if telequeue[pl] then
		setpos(pl, telequeue[pl])
		telequeue[pl] = nil
		return true
	end
end)