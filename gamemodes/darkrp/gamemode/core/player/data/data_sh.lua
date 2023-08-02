PLAYER.SteamName = PLAYER.SteamName or PLAYER.Name
function PLAYER:Name()
	if IsValid(self) then
		if CLIENT and self:IsBlocked() then
			return '[ЗАБЛОКИРОВАННЫЙ ИГРОК #' .. self:EntIndex() ..']'
		end
		return self:GetNetVar('Name') or self:SteamName()
	end
	return 'Unknown'
end

PLAYER.Nick 	= PLAYER.Name
PLAYER.GetName 	= PLAYER.Name

function PLAYER:GetMoney()
	return (self:GetNetVar('Money') or rp.cfg.StartMoney)
end

function PLAYER:GetKarma()
	return (self:GetNetVar('Karma') or rp.cfg.StartKarma)
end

local math_round 	= math.Round
local math_max 		= math.max
local CurTime 		= CurTime
function PLAYER:GetHunger()
	return self:Alive() and math_max(math_round((((self:GetNetVar('Energy') or (CurTime() + rp.cfg.HungerRate)) - CurTime()) / rp.cfg.HungerRate) * 100, 0), 0) or 100
end

function rp.Karma(pl, min, max) -- todo, remove this
	return pl:Karma(min, max)
end

function PLAYER:Karma(min, max)
	return math_floor(min + ((max - min) * (self:GetKarma()/100)))
end

function PLAYER:CanKarmaAfford(sum)
	return tonumber(self:GetKarma()) >= tonumber(sum) 
end

function PLAYER:Wealth(min, max)
	return math_min(math_floor(min + ((max - min) * (self:GetMoney()/25000000))), max)
end

local math_floor 	= math.floor
local math_min 		= math.min
function PLAYER:Wealth(min, max)
	return math_min(math_floor(min + ((max - min) * (self:GetMoney()/25000000))), max)
end

function PLAYER:HasLicense()
	return (self:GetNetVar('HasGunlicense') or self:GetJobTable().hasLicense)
end