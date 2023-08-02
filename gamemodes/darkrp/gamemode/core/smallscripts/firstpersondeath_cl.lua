hook('CalcView', 'FirstPersonDeath', function(pl, pos, ang, fov)
	if (!pl:Alive() or !IsValid(pl:GetRagdollEntity())) then return end
	local rag = pl:GetRagdollEntity()
	local eyeattach = rag:LookupAttachment('eyes')
	if (!eyeattach) then return end
	local eyes = rag:GetAttachment(eyeattach)
	if (!eyes) then return end
	return {origin = eyes.Pos, angles = eyes.Ang, fov = fov}
end)