--[[
gamemodes/darkrp/gamemode/core/achievements/init_sh.lua
--]]
--[[
gamemodes/rp_base/gamemode/core/achievements/init_sh.lua
--]]
rp.achievements = rp.achievements or {

	List = {}

}

rp.achievements.SortedList = {}



function rp.achievements.Add(tab)

	tab.UID = tonumber(util.CRC(tab.Name))


	if CLIENT then

		tab.Material = Material(tab.Icon)

	end



	tab.NetVar = 'Achievement_' .. tab.UID



	nw.Register(tab.NetVar)

		:Write(net.WriteInt, 32)

		:Read(net.ReadInt, 32)

		:SetPlayer()



	rp.achievements.List[tab.UID] = tab

	rp.achievements.SortedList[#rp.achievements.SortedList + 1] = tab



	return tab.UID

end



function PLAYER:GetAchievements()

	return table.FilterCopy(rp.achievements.SortedList, function(v)

		return self:HasAchievement(v.UID)

	end)

end



function PLAYER:GetAchievementProgress(uid)

	local tab = rp.achievements.List[uid]



	return tab and self:GetNetVar(tab.NetVar)

end



function PLAYER:HasAchievement(uid)

	local progress = self:GetAchievementProgress(uid)



	return progress and (progress == -1)

end





