rp.AddCommand('playercolor', function(pl, text, args)
	pl:SetPlayerColor(Vector(pl:GetInfo('cl_playercolor')))
end)

rp.AddCommand('physcolor', function(pl, text, args)
	pl:SetWeaponColor(Vector(pl:GetInfo('cl_weaponcolor')))
end)