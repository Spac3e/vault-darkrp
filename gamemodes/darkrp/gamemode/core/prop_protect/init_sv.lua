local string 	= string
local IsValid 	= IsValid
local util 		= util

rp.pp = rp.pp or {}

local toolFuncs = {
	[0] = function(pl)
		return true
	end,
	[1] = PLAYER.IsVIP,
	[2] = PLAYER.IsAdmin,
	[3] = PLAYER.IsSuperAdmin
}

rp.pp.BlockedTools = {
	['button']		= 0,
	['camera']		= 0,
	['colour']		= 0,
	['fading_door'] = 0,
	['keypad']		= 0,
	['lamp']		= 3,
	['light']		= 0,
	['material']	= 0,
	['nocollide']	= 0,
	['precision']	= 0,
	['remover']		= 0,
	['stacker']		= 0,
	['textscreen']	= 0,
	['weld']		= 0,
	['advdupe2']	= 1,
}

function rp.pp.PlayerCanManipulate(pl, ent)
	if pl:IsBanned() then
		return false
	end

	if IsValid(ent:CPPIGetOwner()) and ent:CPPIGetOwner().propBuddies and ent:CPPIGetOwner().propBuddies[pl] then
		return true
	end

	return (ent:CPPIGetOwner() == pl) or (pl:HasAccess('M') and ba.canAdmin(pl) and IsValid(ent:CPPIGetOwner()))
end


local can_dupe = {
	['prop_physics']	= true,
	['keypad']			= true
}


function rp.pp.PlayerCanTool(pl, ent, tool)
	if pl:IsBanned() then
		return false
	end

	local tool = tool:lower()

	if rp.pp.BlockedTools[tool] then
		local canTool = toolFuncs[rp.pp.BlockedTools[tool]](pl)
		if not canTool then
			rp.Notify(pl, NOTIFY_ERROR, term.Get('CannotTool'), tool)
			return canTool
		end
	end

	local EntTable =
		(tool == "adv_duplicator" and pl:GetActiveWeapon():GetToolObject().Entities) or
		(tool == "advdupe2" and pl.AdvDupe2 and pl.AdvDupe2.Entities) or
		(tool == "duplicator" and pl.CurrentDupe and pl.CurrentDupe.Entities)

	if EntTable then
		for k, v in pairs(EntTable) do
			if not can_dupe[string.lower(v.Class)] then
				rp.Notify(pl, NOTIFY_ERROR, term.Get('DupeRestrictedEnts'))
				return false
			end
		end
	end

	if ent:IsWorld() then 
		return true
	elseif not IsValid(ent) then
		return false
	end

	local cantool = rp.pp.PlayerCanManipulate(pl, ent)

	if (cantool == true) then
		hook.Call('PlayerToolEntity', GAMEMODE, pl, ent, tool)
	end

	return cantool
end


--
-- Meta functions
--
function ENTITY:CPPISetOwner(pl)
	self.pp_owner = pl
	self:SetNetVar('PropIsOwned', true)
	self:SetNWString('PropOwnedd', pl:Name())
end

function ENTITY:CPPIGetOwner()
	return self.pp_owner
end


--
-- Workarounds
--
PLAYER._AddCount = PLAYER._AddCount or PLAYER.AddCount
function PLAYER:AddCount(t, ent)
	if IsValid(ent) then
		ent:CPPISetOwner(self)
	end
	return self:_AddCount(t, ent)
end

ENTITY._SetPos = ENTITY._SetPos or ENTITY.SetPos
function ENTITY.SetPos(self, pos)
	if IsValid(self) and (not util.IsInWorld(pos)) and (not self:IsPlayer()) and (self:GetClass() ~= 'gmod_hands') then
		self:Remove()
		return
	end
	return self:_SetPos(pos)
end

local PHYS = FindMetaTable('PhysObj')
PHYS._SetPos = PHYS._SetPos or PHYS.SetPos
function PHYS.SetPos(self, pos)
	if IsValid(self) and (not util.IsInWorld(pos)) then
		--self:Remove()
		return
	end
	return self:_SetPos(pos)
end

ENTITY._SetAngles = ENTITY._SetAngles or ENTITY.SetAngles
function ENTITY:SetAngles(ang)
	if not ang then return self:_SetAngles(ang) end
	ang.p = ang.p % 360
	ang.y = ang.y % 360
	ang.r = ang.r % 360
	return self:_SetAngles(ang)
end

if undo then
	local AddEntity, SetPlayer, Finish =  undo.AddEntity, undo.SetPlayer, undo.Finish
	local Undo = {}
	local UndoPlayer
	function undo.AddEntity(ent, ...)
		if type(ent) ~= "boolean" and IsValid(ent) then table.insert(Undo, ent) end
		AddEntity(ent, ...)
	end

	function undo.SetPlayer(ply, ...)
		UndoPlayer = ply
		SetPlayer(ply, ...)
	end

	function undo.Finish(...)
		if IsValid(UndoPlayer) then
			for k,v in pairs(Undo) do
				v:CPPISetOwner(UndoPlayer)
			end
		end
		Undo = {}
		UndoPlayer = nil

		Finish(...)
	end
end

duplicator.BoneModifiers = {}
duplicator.EntityModifiers['VehicleMemDupe'] = nil
for k, v in pairs(duplicator.ConstraintType) do
	if (k ~= 'Weld') and (k ~= 'NoCollide') then
		duplicator.ConstraintType[k] = nil
	end
end

rp.AddCommand('shareprops', function(pl, args, text)
	pl.propBuddies = pl.propBuddies or {}

	if pl.propBuddies[args] then
		rp.Notify(pl, NOTIFY_SUCCESS, term.Get('UnsharedPropsYou'), args)
		rp.Notify(args, NOTIFY_SUCCESS, term.Get('UnsharedProps'), pl)
		pl.propBuddies[args] = false
	else
		rp.Notify(pl, NOTIFY_SUCCESS, term.Get('SharedPropsYou'), args)
		rp.Notify(args, NOTIFY_SUCCESS, term.Get('SharedProps'), pl)
		pl.propBuddies[args] = true
	end

	pl:SetNetVar('ShareProps', pl.propBuddies)
end)
:AddParam(cmd.PLAYER_ENTITY)

-- Overwrite 
concommand.Add('gmod_admin_cleanup', function(pl, cmd, args)
	if (not pl:IsRoot())  then 
		pl:Notify(NOTIFY_ERROR, term.Get('CantAdminCleanup'))
		return
	end
	if args[1] then
		for k, v in ipairs(ents.GetAll()) do 
			if (v:GetClass() == args[1]) then
				v:Remove()
			end
		end
	end
end)