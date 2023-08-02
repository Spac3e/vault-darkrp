util.AddNetworkString 'rp::ScoreboardStats'
net.Receive('rp::ScoreboardStats', function(len, pl)
	if not pl:GetNetVar('Country') then
		local cc = net.ReadString()
		pl:SetNetVar('Country', cc:lower())
	end
end)