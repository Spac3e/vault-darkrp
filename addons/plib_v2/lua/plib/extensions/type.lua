
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
~ file: addons/plib_v2/lua/plib/extensions/type.lua ~

]]

local getmetatable 	= getmetatable
local tonumber 		= tonumber

local STRING 	= getmetatable ''
local ANGLE 	= FindMetaTable 'Angle'
local MATRIX 	= FindMetaTable 'VMatrix'
local VECTOR 	= FindMetaTable 'Vector'
local MATERIAL 	= FindMetaTable 'IMaterial'
local ENTITY 	= FindMetaTable 'Entity'
local PLAYER 	= FindMetaTable 'Player'
local PHYS 		= FindMetaTable 'PhysObj'
local WEAPON 	= FindMetaTable 'Weapon'
local NPC 		= FindMetaTable 'NPC'
local NEXTBOT 	= FindMetaTable 'NextBot'
local VEHICLE 	= FindMetaTable 'Vehicle'

local entmts = {
	[ENTITY] 	= true,
	[VEHICLE] 	= true,
	[PHYS] 		= true,
	[WEAPON] 	= true,
	[NPC] 		= true,
	[PLAYER]	= true,
}

if (SERVER) then
	entmts[NEXTBOT] = true
end

function isstring(v)
	return (getmetatable(v) == STRING)
end

function isangle(v)
	return (getmetatable(v) == ANGLE)
end

function ismatrix(v)
	return (getmetatable(v) == MATRIX)
end

function isvector(v)
	return (getmetatable(v) == VECTOR)
end

function ismaterial(v)
	return (getmetatable(v) == MATERIAL)
end

function isnumber(v)
	return (v ~= nil) and (v == tonumber(v))
end

function isbool(v)
	return (v == true) or (v == false)
end

function isentity(v)
	return (entmts[getmetatable(v)] == true)
end
IsEntity = isentity

function isplayer(v)
	return (getmetatable(v) == PLAYER)
end


function ENTITY:IsPlayer()
	return false
end

function PLAYER:IsPlayer()
	return true
end

function PHYS:IsPlayer()
	return false
end

function WEAPON:IsPlayer()
	return false
end

function NPC:IsPlayer()
	return false
end


function ENTITY:IsWeapon()
	return false
end

function PLAYER:IsWeapon()
	return false
end

function PHYS:IsWeapon()
	return false
end

function WEAPON:IsWeapon()
	return true
end

function NPC:IsWeapon()
	return false
end


function ENTITY:IsNPC()
	return false
end

function PLAYER:IsNPC()
	return false
end

function PHYS:IsNPC()
	return false
end

function WEAPON:IsNPC()
	return false
end

function NPC:IsNPC()
	return true
end


function ENTITY:IsNextbot()
	return false
end

function PLAYER:IsNextbot()
	return false
end

function PHYS:IsNextbot()
	return false
end

function WEAPON:IsNextbot()
	return false
end

function NPC:IsNextbot()
	return false
end


function ENTITY:IsPhysObj()
	return false
end

function PLAYER:IsPhysObj()
	return false
end

function PHYS:IsPhysObj()
	return false
end

function WEAPON:IsPhysObj()
	return false
end

function NPC:IsPhysObj()
	return false
end


if (SERVER) then
	function NEXTBOT:IsPlayer()
		return false
	end

	function NEXTBOT:IsWeapon()
		return false
	end

	function NEXTBOT:IsNPC()
		return false
	end

	function NEXTBOT:IsPhysObj()
		return false
	end

	function NEXTBOT:IsNextbot()
		return true
	end
end