
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
~ file: addons/badmin/lua/ba/modules/darkrp/logs/nlr_sh.lua ~

]]

nw.Register 'NLR'
	:Write(function(v)
		net.WriteUInt(v.Time, 32)
		net.WriteVector(v.Pos)
	end)
	:Read(function()
		return { 
			Time = net.ReadUInt(32),
			Pos = net.ReadVector()
		}
	end)
	:SetLocalPlayer()

function PLAYER:InNLRZone()
	if self:Alive() and self:GetNetVar('NLR') then
		return (self:GetNetVar('NLR').Pos:DistToSqr(self:GetPos()) < 122500)
	end
	return false
end

function PLAYER:GetNLRTime()
	if self:Alive() and self:GetNetVar('NLR') then
		return math.Round(self:GetNetVar('NLR').Time - CurTime(), 0)
	end
end