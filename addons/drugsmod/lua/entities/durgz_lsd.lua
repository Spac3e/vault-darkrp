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
ENT.PrintName		= 'LSD'
ENT.Author			= 'The D3vine'
ENT.Spawnable		= true
ENT.AdminSpawnable	= true

ENT.Model			= 'models/smile/smile.mdl'
ENT.ID				= 'LSD'

local DRUG = {}
DRUG.Name = 'LSD'
DRUG.Duration = 60

function DRUG:StartHighServer(pl)
	local sayings = {
		'О, Боже мой, я просто устал',
		'Это должно быть лекарство от рака, чувак'
	}
	
	pl:ConCommand('say ' .. sayings[math.random(1,#sayings)])
end

function DRUG:TickServer(pl, stacks, startTime, endTime)
end

function DRUG:EndHighServer(pl)
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
		['$pp_colour_colour'] 		= 4,
		['$pp_colour_brightness'] 	= -0.19,
		['$pp_colour_contrast'] 	= 6.31
	}
	
	DrawBloom(0.65, 0.1, 9, 9, 4, 7.7, 255, 255, 255)
	DrawColorModify(ColorModify)
end

RegisterDrug(DRUG)