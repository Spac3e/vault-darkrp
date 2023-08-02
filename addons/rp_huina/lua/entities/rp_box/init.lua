AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")
local prefix = rp_box.NPC_name..": "
function ENT:Initialize()
	self:SetModel("models/props_c17/Lockers001a.mdl")
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
	self:SetUseType( SIMPLE_USE )
	local phys = self:GetPhysicsObject()
	phys:EnableMotion(false)
end

function ENT:Use(ply)
	if ply.box_nextuse == nil then
		ply.box_nextuse = CurTime()
	end
	if ply.box_nextuse > CurTime() then
		ply:SendMessageFD(Color(255,255,55), prefix, Color(255,255,255), "Подожди "..math.Round(ply.box_nextuse - CurTime()).." сек!" )
		return false
	end
	if ply:Team() == TEAM_ADMIN then
		ply:SendMessageFD(Color(255,255,55), prefix, Color(255,255,255), "Але блять, ты чо ахуел абузить" )
		return false
	end
	if !ply:CanAfford(250) then
		ply:SendMessageFD(Color(255,255,55), prefix, Color(255,255,255), "Але блять, ты чо ахуел абузить" )
		return false
	end
	if IsValid(ply) and ply:IsPlayer() and ply:Alive() and (self:GetPos():Distance(ply:GetPos()) < 130) then
		if ply:GetNWBool("TakeBox", false) == false then
			ply:SetNWBool("TakeBox", true)
			ply.OldWalkSpeed = ply:GetWalkSpeed()
			ply.OldRunSpeed = ply:GetRunSpeed()
			ply.OldMaxSpeed = ply:GetMaxSpeed()

			ply:SetMaxSpeed(ply.OldWalkSpeed * .4)
			ply:SetWalkSpeed(ply.OldWalkSpeed * .4)
			ply:SetRunSpeed(ply.OldWalkSpeed * .4)
			ply:SetCanWalk( false )
			ply:Give("rp_box_in_hands")
			ply:SelectWeapon("rp_box_in_hands")
			ply:SendMessageFD(Color(0,255,128), prefix, Color(255,255,255), "Теперь отнеси коробку мне и я дам тебе денег. Пытайся не бегать с ней!")
			ply.box_nextuse = CurTime() + 10
		else
			ply:SendMessageFD(Color(0,255,128), prefix, Color(255,255,255), "Ты слишком хилый что бы нести больше одной коробки.")
		end
	end
end
