local function NetIsValid(str)
    return isstring(str) and util.NetworkStringToID(str) != 0 and str != ''
end
local G = "FidgetSpinnerColor"
if NetIsValid(G) then
    util.AddNetworkString(G)
    net.Receive(G, function(len, ply)
    	local wep = net.ReadEntity()
        if wep ~= "fidgetspinner" or
        wep ~= "freespinner" or
        wep ~= "shurikenspinner" or
        wep ~= "weapon_fidget" or
        wep ~= "weapon_spinner" then
            ply:Kick("не умничай пока не умный")
            return
        end
    	local r, g, b = net.ReadUInt(8), net.ReadUInt(8), net.ReadUInt(8)
    	wep:SetColor(Color(r, g, b))
    end)
end