-- а вот всё, раньше надо было
util.AddNetworkString("ba.rewards.Claim")
/*
local db = rp.AuthInfo
local fileexists = file.Exists
local crtfiledir = file.CreateDir

util.AddNetworkString("ba.rewards.Claim")
crtfiledir("badmin/rewards")

net.Receive("ba.rewards.Claim", function(len, pl)
	crtfiledir("badmin/rewards/"..pl:SteamID64())

	local cmd = net.ReadString()
	if not cmd or cmd == nil or cmd == "" then return end

	if (cmd == "award_steam") then
		if fileexists("badmin/rewards/"..pl:SteamID64().."/group.txt", "DATA") then
			ba.notify(pl, term.Get("AlreadyInSteamGroup"))
		else
			file.Write("badmin/rewards/"..pl:SteamID64().."/group.txt", "1")
			pl:AddMoney(RewardsModule.Reward.SteamGroup) --*TODO* Заменить на прибавление кредитов
		end
	elseif (cmd == "award_name") then
		local newTime = os.time() + 86400 --$24 часа
		local checkTime = file.Read("badmin/rewards/"..pl:SteamID64().."/steamtag.txt", "DATA")
		print(newTime)
		print(checkTime)
		if fileexists("badmin/rewards/"..pl:SteamID64().."/steamtag.txt", "DATA") then
			print("found!")
			if checkTime >= newTime then
				print("Finished!")
				file.Write("badmin/rewards/"..pl:SteamID64().."/steamtag.txt", newTime)
				pl:AddMoney(RewardsModule.Reward.SteamName) --*TODO* Заменить на прибавление кредитов
			elseif checkTime <= newTime then
				//badmin.notify(pl, term.Get("AlreadySteamTag"))
				print("Already!")
			end
		else
			print("Not found!")
			file.Write("badmin/rewards/"..pl:SteamID64().."/steamtag.txt", newTime)
			pl:AddMoney(RewardsModule.Reward.SteamName) --*TODO* Заменить на прибавление кредитов
		end
	end
end)
*/