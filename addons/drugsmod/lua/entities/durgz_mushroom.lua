/*
	Drugs System
	Coded by KingofBeast
	Inspired by Durgz, but that's a shitty addon
*/ -- Скаченно с группы вконтакте: https://vk.com/urbanichka saf
-- пацаны я тут был, и ето тупо отредаченые наркотяки
-- наркотяки вред
AddCSLuaFile()

ENT.Type			= 'anim'
ENT.Base			= 'drug_base'

ENT.Category		= 'RP Drugs'
ENT.PrintName		= 'Mushrooms'
ENT.Author			= 'The D3vine'
ENT.Spawnable		= true
ENT.AdminSpawnable	= true

ENT.Model			= 'models/ipha/mushroom_small.mdl'
ENT.ID				= 'Mushroom'

local DRUG = {}
DRUG.Name = 'Mushroom'
DRUG.Duration = 60

function DRUG:StartHighServer(pl)
	if (math.random(0, 22) == 0) then
		pl:Ignite(5, 0)
		pl:ConCommand('say AAAAAAAAAAAAAAAAAAAAAA')
		return
	end

	pl:SetGravity(0.135)
end

function DRUG:TickServer(pl, stacks, startTime, endTime)
end

function DRUG:EndHighServer(pl)
	pl:SetGravity(1)
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
	local ColorModify = {
		['$pp_colour_addr'] 		= 0,
		['$pp_colour_addg'] 		= 0,
		['$pp_colour_addb'] 		= 0,
		['$pp_colour_mulr'] 		= 0,
		['$pp_colour_mulg'] 		= 0,
		['$pp_colour_mulb'] 		= 0,
		['$pp_colour_colour'] 		= 0.63,
		['$pp_colour_brightness'] 	= -0.15,
		['$pp_colour_contrast'] 	= 2.57
	}

	DrawColorModify(ColorModify)
	DrawSharpen(8.32, 1.03)
end

RegisterDrug(DRUG)