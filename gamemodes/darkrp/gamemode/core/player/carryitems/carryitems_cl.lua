function PLAYER:IsCarryingItem()
	return IsValid(self:GetNetVar('CarriedItem'))
end

hook('PlayerButtonDown', 'rp.carryitems.PlayerButtonDown', function(pl, key)
	if key == KEY_G and IsFirstTimePredicted() then
		net.Start 'rp::crarryitems.Toggle'
		net.SendToServer()
	end
end)

hook('Think', 'rp.carryitems.Think', function()
	local lp = LocalPlayer()
	if IsValid(lp) then
		local ent = lp:GetNetVar('CarriedItem')
	end
end)

hook('NetPlayerDropItem', 'rp.carryitems.NetPlayerDropItem', function(ent, value, oldVal)
	if IsValid(oldVal) then
		oldVal:SetNoDraw(false)
	end
end)