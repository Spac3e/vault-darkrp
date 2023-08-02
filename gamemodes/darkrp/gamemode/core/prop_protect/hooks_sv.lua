local oktools = {
	["#Tool.advdupe2.name"] = true,
	-- ["#Tool.stacker.name"] 	= true
}
hook('PlayerSpawnProp', 'pp.PlayerSpawnProp', function(pl, mdl)
	local tool = pl:GetTool()
	if (pl:IsSuperAdmin()) then return true end
	if pl.lastPropSpawn and (pl.lastPropSpawn > CurTime() - .25) and ((tool == nil) or not oktools[tool.Name]) then
		rp.Notify(pl, NOTIFY_ERROR, 'Пожалуйста, не создавайте пропы так быстро.')

		if pl.failedPropAttempts and (pl.failedPropAttempts >= 5) and (pl.toldStaff ~= true) then
			for k,v in pairs(player.GetAll()) do
				if v:IsAdmin() then
					rp.Notify(v,30,'# был остановлен из-за спавна более чем 5 пропов в секунду. Следите за ним!', pl)
				end
			end
			pl.toldStaff = true
		end

		pl.lastPropSpawn = CurTime()
		pl.failedPropAttempts = (pl.failedPropAttempts or 0) + 1

		return false
	end

	pl.toldStaff 			= nil
	pl.failedPropAttempts 	= nil
	pl.lastPropSpawn 		= CurTime()
end)


hook('PlayerSpawnedProp', 'pp.PlayerSpawnedProp', function(pl, mdl, ent)

	ent:CPPISetOwner(pl)
end)

hook('PlayerSpawnedVehicle', 'pp.PlayerSpawnedVehicle', function(pl, ent)
	ent:CPPISetOwner(pl)
end)

hook('PlayerSpawnedSENT', 'pp.PlayerSpawnedSENT', function(pl, ent)
	ent:CPPISetOwner(pl)
end)

function GM:CanTool(pl, trace, tool)
	return rp.pp.PlayerCanTool(pl, trace.Entity, tool)
end

local aaitem = {
	["gmod_button"] = true,
	["spawned_money"] = true,
	["keypad"] = true,
	["gmod_light"] = true,
}

hook('PhysgunPickup', 'pp.PhysgunPickup', function(pl, ent)
	if aaitem[ent:GetClass()] then
		return false
	end
	if IsValid(ent) then
		local canphys = rp.pp.PlayerCanManipulate(pl, ent)

		if (not canphys) and ent.PhysgunPickup then
			canphys = ent:PhysgunPickup(pl)
		elseif ent.LazyFreeze then
			canphys = (ent.ItemOwner == pl)
		end

		if (canphys == true) then
			ent.BeingPhysed = true
			hook.Call('PlayerPhysgunEntity', GAMEMODE, pl, ent)
		end

		-- if not ent:IsPlayer() then
		-- 	if not ent.renderMode then ent.renderMode = ent:GetRenderMode() end
		-- 	ent:SetCollisionGroup(0)
		-- end

		return canphys
	end
	return false
end)

local vec = Vector(0,0,0)
function GM:PhysgunDrop(pl, ent)
	local props = ent:IsConstrained() and constraint.GetAllConstrainedEntities(ent) or {}
	table.insert(props, ent)
	for _, prop in pairs(props) do
		local colliding = ents.FindInSphere(prop:LocalToWorld(prop:OBBCenter()), prop:BoundingRadius())
		for k, v in pairs(colliding) do
			if v:IsPlayer() and v:GetObserverMode() then

				if prop:NearestPoint(v:NearestPoint(prop:GetPos())):Distance(v:NearestPoint(prop:GetPos())) <= 20 then
					--weapon:GetOwner():SendLua( "notification.AddLegacy( 'Вы не можете заморозить проп т.к он может застрять в игроке!', NOTIFY_ERROR, 5 )" )
					return false
				end
			end
		end
	end
	for k, v in pairs(props) do
		local phys = v:GetPhysicsObject()
		if phys:IsValid() and phys:IsMotionEnabled() then
			phys:EnableMotion( false )
		end
	end
	ent.BeingPhysed = false
	-- if IsValid(ent) and (not ent:IsPlayer()) then
	-- 	local phys = ent:GetPhysicsObject()
	-- 	if IsValid(phys) then
	-- 		phys:AddAngleVelocity(phys:GetAngleVelocity() * -1)
	-- 		phys:SetVelocityInstantaneous(vec)
	-- 		ent:SetCollisionGroup(0)
	-- 	end
	-- end
end
local fzents = {
	['uweed_light_big'] = true,
	['rp_casino'] = true,
}
hook('OnPhysgunFreeze', 'pp.OnPhysgunFreeze', function(weapon, physobj, ent, pl)
	local props = ent:IsConstrained() and constraint.GetAllConstrainedEntities(ent) or {}
	table.insert(props, ent)
	for _, prop in pairs(props) do
		local colliding = ents.FindInSphere(prop:LocalToWorld(prop:OBBCenter()), prop:BoundingRadius())
		for k, v in pairs(colliding) do
			if v:IsPlayer() and v:GetObserverMode() then

				if prop:NearestPoint(v:NearestPoint(prop:GetPos())):Distance(v:NearestPoint(prop:GetPos())) <= 20 then
					weapon:GetOwner():SendLua( "notification.AddLegacy( 'Вы не можете заморозить проп т.к он может застрять в игроке!', NOTIFY_ERROR, 5 )" )
					return false
				end
			end
		end
	end
	ent.BeingPhysed = false
	if IsValid(physobj) and ent.ItemOwner == pl and ent.LazyFreeze and table.HasValue(fzents,ent:GetClass()) then
		--physobj:Sleep()
		return false
	end
end)

function GM:GravGunOnPickedUp(pl, ent)
	if (pl:IsSuperAdmin()) then return true end
	if (string.match(ent:GetClass(), "ch_")) then return true end

	if ent:IsConstrained() then
		DropEntityIfHeld(ent)
	end
end

function GM:GravGunPunt(pl, ent)
	if (pl:IsSuperAdmin()) then return true end

	DropEntityIfHeld(ent)
	return false
end

function GM:OnPhysgunReload(wep, pl)
	return false
end

function GM:GravGunPickupAllowed(pl, ent)
	if (ent:IsValid() and ent.GravGunPickupAllowed) then
		return ent:GravGunPickupAllowed(pl)
	end

	return true
end

local nodamage = {
	prop_fix		= true,
	prop_physics 	= true,
	prop_dynamic 	= true,
	donation_box 	= true,
	gmod_winch_controller = true,
	gmod_poly 		= true,
	gmod_button 	= true,
	gmod_balloon 	= true,
	gmod_cameraprop = true,
	gmod_emitter 	= true,
	gmod_light 		= true,
	keypad          = true,
    gmod_poly       = true,
    ent_picture 	= true
}

local nocolide = {
	prop_fix		= true,
	prop_physics 		= true,
	prop_dynamic 		= true,
	func_door 			= true,
	func_door_rotating	= true,
	prop_door_rotating	= true,
	spawned_food		= false,
	func_movelinear 	= true,
	ent_picture 		= true
}


hook.Add('PlayerShouldTakeDamage', 'AntiPK_PlayerShouldTakeDamage', function(victim, attacker)
	if nodamage[attacker:GetClass()] or victim:IsPlayer() and attacker:IsVehicle() then
		return false
	end
end)

hook.Add('EntityTakeDamage', 'AntiPK.EntityTakeDamage', function(pl, dmginfo)
	if (dmginfo:GetDamageType() == DMG_CRUSH) then
		return true
	end
end)

hook.Add('ShouldCollide', 'AntiPK_NoColide', function(ent1, ent2)
	if IsValid(ent1) and IsValid(ent2) and nocolide[ent1:GetClass()] and nocolide[ent2:GetClass()] then
		return false
	end
end)

hook.Add('PlayerSpawnedProp', 'AntiPk_OnEntityCreated', function(pl, mdl, ent)
	local phys = ent:GetPhysicsObject()
	if IsValid( phys ) then
		phys:EnableMotion( false )
	end
	--ent:SetCustomCollisionCheck(true)
end)
