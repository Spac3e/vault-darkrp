/*
	Drugs System
	Coded by KingofBeast
	Inspired by Durgz, but that's a shitty addon
*/
-- пацаны я тут был, и ето тупо отредаченые наркотяки
-- наркотяки вред
AddCSLuaFile()
-- пацаны я тут был, и ето тупо отредаченые наркотяки
-- наркотяки вред
ENT.Type			= 'anim'
ENT.Base			= 'drug_base'
-- пацаны я тут был, и ето тупо отредаченые наркотяки
-- наркотяки вред
ENT.Category		= 'RP Drugs'
ENT.PrintName		= 'Bath Salts'
ENT.Author			= 'aStonedPenguin'
ENT.Spawnable		= true
ENT.AdminSpawnable	= true
-- пацаны я тут был, и ето тупо отредаченые наркотяки
-- наркотяки вред
ENT.Model			= 'models/props_lab/jar01a.mdl'
ENT.ID				= 'Bath'
-- пацаны я тут был, и ето тупо отредаченые наркотяки
-- наркотяки вред
local DRUG = {}
DRUG.Name = 'Bath'
DRUG.Duration = 60

function DRUG:StartHighServer(pl)
	pl:SetGravity(0.25)
	pl:SetHealth(pl:Health() + 200)
end

function DRUG:TickServer(pl, stacks, startTime, endTime)
end

function DRUG:EndHighServer(pl)
	pl:SetGravity(1)
	if pl:Health() <= 200 then
		pl:Kill()
	else
		pl:SetHealth(pl:Health() - 200)
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
	DrawSharpen(-1, 2)
	DrawMaterialOverlay('models/props_lab/Tank_Glass001', 0)
	DrawMotionBlur(0.13, 1, 0.00)
end

RegisterDrug(DRUG)