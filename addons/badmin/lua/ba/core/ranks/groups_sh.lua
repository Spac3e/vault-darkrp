
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
~ file: addons/badmin/lua/ba/core/ranks/groups_sh.lua ~

]]

ba.ranks 			= ba.ranks 			or {}
ba.ranks.Stored 	= ba.ranks.Stored 	or {}

local rank_mt 		= {}
rank_mt.__index 	= rank_mt

function ba.ranks.Create(name, id)	
	local r = {
		Name 		= name:lower():gsub(' ', ''),
		NiceName	= name,
		ID 			= id,
		Immunity 	= 0,
		Flags 		= {},
		Global 		= false,
		VIP 		= false,
		Admin 		= false,
		SuperAdmin 	= false,
		Root 		= false
	}
	setmetatable(r, rank_mt)
	ba.ranks.Stored[r.ID] 		= r --ehhhhh, oh well..
	ba.ranks.Stored[r.Name] 	= r
	ba.ranks.Stored[r.NiceName] = r
	return r
end

function ba.ranks.GetTable()
	return ba.ranks.Stored
end

function ba.ranks.Get(rank)
	return ba.ranks.Stored[isstring(rank) and rank:lower() or rank]
end

function ba.ranks.CanTarget(pl, targ)
	if (not isplayer(pl)) or pl:IsRoot() or ((pl:IsSuperAdmin()) and (not targ:IsRoot())) or (pl == targ) then return true end
	return (pl:GetImmunity() > targ:GetImmunity())
end

-- Set
function rank_mt:SetImmunity(amt)
	self.Immunity = amt
	return self
end

function rank_mt:SetMaxBan(time,strTime)
	self.MaxBan = {time,strTime}
	return self
end

function rank_mt:SetGlobal(bool)
	self.Global = bool
	return self
end

function rank_mt:SetFlags(f)
	for i = 1, #f do
		self.Flags[f[i]] = true
		self.Flags[i] = f[i]
	end
	return self
end

function rank_mt:SetVIP(bool)
	self.VIP = bool
	return self
end

function rank_mt:SetAdmin(bool)
	if (bool == true) then
		self:SetVIP(bool)
	end
	self.Admin = bool
	return self
end

function rank_mt:SetSuperAdmin(bool)
	if (bool == true) then
		self:SetVIP(bool)
		self:SetAdmin(bool)
	end
	self.SuperAdmin = bool
	return self
end

function rank_mt:SetRoot(bool)
	if (bool == true) then
		self:SetGlobal(bool)
		self:SetVIP(bool)
		self:SetAdmin(bool)
		self:SetSuperAdmin(bool)
	end
	self.Root = bool
	return self
end

-- Get
function rank_mt:GetID()
	return self.ID
end

function rank_mt:GetName()
	return self.Name
end

function rank_mt:GetNiceName()
	return self.NiceName
end

function rank_mt:GetImmunity()
	return self.Immunity
end

function rank_mt:IsGlobal()
	return self.Global
end

function rank_mt:HasFlag(flag)
	return (self.Flags[flag:lower()] or self:IsRoot())
end

function rank_mt:CanTarget(rank)
	return self:IsRoot() or (self:GetImmunity() > rank:GetImmunity())
end

function rank_mt:IsVIP()
	return self.VIP
end

function rank_mt:IsAdmin()
	return self.Admin
end

function rank_mt:IsSuperAdmin()
	return self.SuperAdmin
end

function rank_mt:IsRoot()
	return self.Root
end

-- Player
function PLAYER:GetRankTable()
	return ba.ranks.Get(self:GetNetVar('UserGroup') or 1)
end

function PLAYER:GetRank()
	return self:GetRankTable():GetName()
end 
PLAYER.GetUserGroup = PLAYER.GetRank

function PLAYER:GetImmunity()
	return self:GetRankTable():GetImmunity()
end

function rank_mt:GetMaxBan()
	return self.MaxBan
end

function PLAYER:HasFlag(flag)
	if (hook.Call('PlayerAdminCheck', GAMEMODE, self) == false) then return false end
	
	return self:GetRankTable():HasFlag(flag)
end
PLAYER.HasAccess = PLAYER.HasFlag

function PLAYER:IsRank(group)
	return (self:GetRank() == group)
end
PLAYER.IsUserGroup = PLAYER.IsRank

function PLAYER:IsVIP()
	return ((hook.Call('PlayerVIPCheck', GAMEMODE, self) == true) or self:GetRankTable():IsVIP())
end

function PLAYER:IsAdmin()
	if (hook.Call('PlayerAdminCheck', GAMEMODE, self) == false) then return false end

	return self:GetRankTable():IsAdmin()
end

function PLAYER:IsSuperAdmin()
	if (hook.Call('PlayerAdminCheck', GAMEMODE, self) == false) then return false end

	return self:GetRankTable():IsSuperAdmin()
end

function PLAYER:IsRoot()
	return self:GetRankTable():IsRoot()
end

nw.Register 'UserGroup'
	:Write(net.WriteUInt, 32)
	:Read(net.ReadUInt, 32)
	:SetPlayer()