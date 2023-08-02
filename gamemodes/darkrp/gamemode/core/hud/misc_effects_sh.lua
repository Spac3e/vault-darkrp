if (SERVER) then
	util.AddNetworkString("rp.misc_effect_whiteflash")

	function PLAYER:MiscEffect(name)
	end

	return
end

local function whiteFlash()
	
end
net.Receive("rp.misc_effect_whiteflash", whiteFlash)