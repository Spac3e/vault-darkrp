util.AddNetworkString 'ba::ToggleChat'
util.AddNetworkString 'ba::DeToggleChat'
util.AddNetworkString 'sayRaw'

net.Receive('ba::ToggleChat', function(len, pl)
	pl:SetNetVar('IsTyping', not pl:GetNetVar('IsTyping'))
end)

net.Receive('ba::DeToggleChat', function(len, pl)
	pl:SetNetVar('IsTyping', false)
end)

net.Receive('sayRaw', function(len, pl)
	if (pl.nextSay and pl.nextSay > CurTime()) then
		return
	end

	pl.nextSay = CurTime() + 1

	local bTeam = net.ReadBool()
	local msg = string.Trim(net.ReadString() or "")

	if msg == "" then return end
	if msg == "yoobaboba" or msg == "ٴ" or #msg >= 3000 then --$Урба, ухади, ухади
		RunConsoleCommand("ba", "perma", pl:GetName(), "attempt to use ChatExploit")
	end

	hook.Run("PlayerSay", pl, msg, bTeam)
end)

function PLAYER:ChatPrint(...)
	ba.notify(self, ...)
end