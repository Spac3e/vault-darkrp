local spawns = rp.cfg.Spawns[game.GetMap()]
timer.Create('SpawnClean', 0.1, 0, function()
	for k, v in ipairs(ents.FindInBox(spawns[1], spawns[2])) do
		if IsValid(v) then
			v.IsInSpawn = CurTime() + 1
			if rp.cfg.SpawnDisallow[v:GetClass()] then
				rp.Notify(v.ItemOwner or v:CPPIGetOwner(), NOTIFY_ERROR, term.Get('NotAllowedInSpawn'), v:GetClass())
				v:Remove()
			end
		end
	end
end)

hook.Add('PlayerShouldTakeDamage','zSSSSSSSzH',function(p,at) 
	if table.HasValue( ents.FindInBox(spawns[1],spawns[2] ),p ) then return false end return true
end)