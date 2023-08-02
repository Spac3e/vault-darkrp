/*
	Drugs System
	Coded by KingofBeast
	Inspired by Durgz, but that's a shitty addon
*/
-- пацаны я тут был, и ето тупо отредаченые наркотяки
-- наркотяки вред
AddCSLuaFile()

ENT.Type			= 'anim'
ENT.Base			= 'drug_base'

ENT.Category		= 'RP Drugs'
ENT.PrintName		= 'Coffee'
ENT.Author			= 'The D3vine'
ENT.Spawnable		= true
ENT.AdminSpawnable	= true

ENT.Model			= 'models/props_junk/garbage_coffeemug001a.mdl'
ENT.ID				= 'Coffee'

local DRUG = {}
DRUG.Name = 'Coffee'
DRUG.Duration = 30

function DRUG:StartHighServer(pl)
	pl:RemoveAllHighs()

	pl:AddHealth(2)
	pl:AddHunger(2)

--	pl:EmitSound('vo/npc/male01/moan0' .. math.random(4, 5) .. '.wav')

	pl.DrugOldWalkSpeed = pl.DrugOldWalkSpeed or pl:GetWalkSpeed()
	pl.DrugOldRunSpeed = pl.DrugOldRunSpeed or pl:GetRunSpeed()

	pl:SetWalkSpeed(pl.DrugOldWalkSpeed * 1.2)
	pl:SetRunSpeed(pl.DrugOldRunSpeed * 1.2)
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