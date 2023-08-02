nw.Register 'TeamData'
:Write(function(v)
	for i = 1, 4 do
		local isSet = (v[i] ~= nil)
		net.WriteBool(isSet)
		if isSet then
			net.WriteEntity(v[i])
		end
	end
end)
:Read(function()
	local tbl = {}
	for i = 1, 4 do
		if net.ReadBool() then
			tbl[i] = net.ReadEntity()
		end
	end
	return tbl
end)
:SetPlayer()

function PLAYER:GetTeamData()
	return self:GetNetVar('TeamData') or {}
end