
hook.Add('ShowHelp', 'motd.ShowHelp', function(pl)
	net.Start("ba.jails.OpenMotd")
	net.Send(pl)
	return true
end)

util.AddNetworkString('ba.FullServerRedirect')
	
hook.Add('playerRankLoaded', 'PerformFullServerRedirect', function(pl)
	if (#player.GetAll() >= 108) then
		local target
		if (pl:GetRank() ~= 'vip') and (not pl:IsAdmin()) then
			target = pl
		else
			local afk = table.Filter(player.GetAll(), function(v) return v:IsAFK(1200) end)
			table.SortByMember(afk, 'NotAFK', true)
			target = afk[1]
		end

		if IsValid(target) then
			net.Start('ba.FullServerRedirect')
				net.WriteBool(target == pl)
			net.Send(target)
		end

	end
end)
