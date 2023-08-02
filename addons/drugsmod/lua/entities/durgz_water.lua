/*
	Drugs System
	Coded by KingofBeast
	Inspired by Durgz, but that's a shitty addon
*/ -- Скаченно с группы вконтакте: https://vk.com/urbanichka safqwr
-- пацаны я тут был, и ето тупо отредаченые наркотяки
-- наркотяки вред
AddCSLuaFile()

ENT.Type			= 'anim'
ENT.Base			= 'drug_base'

ENT.Category		= 'RP Drugs'
ENT.PrintName		= 'Water'
ENT.Author			= 'The D3vine'
ENT.Spawnable		= true
ENT.AdminSpawnable	= true

ENT.Model			= 'models/drug_mod/the_bottle_of_water.mdl'
ENT.ID				= 'Water'

local DRUG = {}
DRUG.Name = 'Water'
DRUG.Duration = 1

-- DRUG.NoKarmaLoss = true

function DRUG:StartHighServer(pl)
	pl:RemoveAllHighs()

	pl:Extinguish()

	pl:AddHealth(2)
	pl:AddHunger(2)
	
--	pl:EmitSound('vo/npc/male01/moan0' .. math.random(4, 5) .. '.wav')
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
end

RegisterDrug(DRUG)