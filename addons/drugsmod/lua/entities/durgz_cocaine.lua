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
ENT.Author			= 'The D3vine'
ENT.PrintName		= 'Cocaine'
ENT.Spawnable		= true
ENT.AdminSpawnable	= true

ENT.Model			= 'models/cocn.mdl'
ENT.ID				= 'Cocaine'

local DRUG = {}
DRUG.Name = 'Cocaine'
DRUG.Duration = 15

function DRUG:StartHighServer(pl)
	if (pl:Health() > 1) then
		
		pl:SetHealth(pl:Health() / 2)
		
		pl.DrugOldWalkSpeed = pl.DrugOldWalkSpeed or pl:GetWalkSpeed()
		pl.DrugOldRunSpeed = pl.DrugOldRunSpeed or pl:GetRunSpeed()

		pl:SetWalkSpeed(pl.DrugOldWalkSpeed * 2)
		pl:SetRunSpeed(pl.DrugOldRunSpeed * 2)
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
		['$pp_colour_brightness'] = 0,
		['$pp_colour_contrast'] = 1,
		['$pp_colour_mulr'] = 0,
		['$pp_colour_mulg'] = 0,
		['$pp_colour_mulb'] = 0
	}

	DrawMaterialOverlay('highs/shader3', math.sin(SysTime()/math.pi) * 0.05)
	DrawColorModify(ColorModify)
end

RegisterDrug(DRUG)