/*
	Drugs System
	Coded by KingofBeast
	Inspired by Durgz, but that's a shitty addon
*/ -- asfasf Скаченно с группы вконтакте: https://vk.com/urbanichka
-- пацаны я тут был, и ето тупо отредаченые наркотяки
-- наркотяки вред
AddCSLuaFile()

ENT.Type			= 'anim'
ENT.Base			= 'drug_base'

ENT.Category		= 'RP Drugs'
ENT.Author			= 'The D3vine'
ENT.PrintName		= 'Meth'
ENT.Spawnable		= true
ENT.AdminSpawnable	= true

ENT.Model			= 'models/cocn.mdl'
ENT.ID				= 'Meth'

function ENT:Initialize()
	self:SetModel(self.Model)
	
	if (SERVER) then
		self:PhysicsInit(SOLID_VPHYSICS)
		self:SetMoveType(MOVETYPE_VPHYSICS)
		self:SetSolid(SOLID_VPHYSICS)
		self:SetCollisionGroup(COLLISION_GROUP_DEBRIS_TRIGGER)

		self:PhysWake()
		
		self:GetPhysicsObject():SetMass(2)
	end

	self:SetColor(Color(75,128,255))
end

local DRUG = {}
DRUG.Name = 'Meth'
DRUG.Duration = 30

local vec4 = Vector(4, 4, 4)
local vec1 = Vector(1, 1, 1)
function DRUG:StartHighServer(pl)
	if (pl:Health() > 1) then
		
		pl.DrugOldWalkSpeed = pl.DrugOldWalkSpeed or pl:GetWalkSpeed()
		pl.DrugOldRunSpeed = pl.DrugOldRunSpeed or pl:GetRunSpeed()

		pl:SetWalkSpeed(pl.DrugOldWalkSpeed * 2)
		pl:SetRunSpeed(pl.DrugOldRunSpeed * 2)

		pl:ManipulateBoneScale(6, vec4)
		pl:SetHunger(200, true)
	else
		pl:SetWalkSpeed(50)
		pl:SetRunSpeed(100)
		
		timer.Simple(1, function()
			if (IsValid(pl)) then
				pl:ConCommand('say Мое сердце не бьется..')
				timer.Simple(2, function()
					if (IsValid(pl)) then
						pl:Kill()
					end
				end)
			end
		end)
	end
end

function DRUG:TickServer(pl, stacks, startTime, endTime)
end

function DRUG:EndHighServer(pl)
	if pl.DrugOldWalkSpeed then
		pl:SetWalkSpeed(pl.DrugOldWalkSpeed)
		pl.DrugOldWalkSpeed = nil
	end

	if pl.DrugOldRunSpeed then
		pl:SetRunSpeed(pl.DrugOldRunSpeed)
		pl.DrugOldRunSpeed = nil
	end
	pl:ManipulateBoneScale(6, vec1)
end

function DRUG:StartHighClient(pl)
end

function DRUG:TickClient(pl, stacks, startTime, endTime)
end

function DRUG:EndHighClient(pl)
end

function DRUG:HUDPaint(pl, stacks, startTime, endTime)
end

function DRUG:RenderSSEffects(pl, stacks, startTime, endTime)
	ColorModify = {
		['$pp_colour_addr'] = 0,
		['$pp_colour_addg'] = 0,
		['$pp_colour_addb'] = 0,
		['$pp_colour_brightness'] = -0.15,
		['$pp_colour_contrast'] = 2.57,
		['$pp_colour_mulr'] = 0,
		['$pp_colour_mulg'] = 0,
		['$pp_colour_mulb'] = 0,
		['$pp_colour_colour'] = 0.63,
	}

	DrawMaterialOverlay('highs/shader3', math.sin(SysTime()/math.pi) * 0.05)
	DrawMotionBlur(0.82, 1, 0)
	DrawColorModify(ColorModify)
	DrawSharpen(8.32, 1.03)
end

RegisterDrug(DRUG)