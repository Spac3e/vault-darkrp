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
ENT.PrintName		= 'Bleach'
ENT.Author			= 'The D3vine'
ENT.Spawnable		= true
ENT.AdminSpawnable	= true

ENT.Model			= 'models/props_junk/garbage_plasticbottle001a.mdl'
ENT.ID				= 'Bleach'

local DRUG = {}
DRUG.Name = 'Bleach'
DRUG.Duration = 3

function DRUG:StartHighServer(pl)
	pl:SetHealth(1)
	timer.Simple(math.random(1,3), function()
		if IsValid(pl) and pl:Alive() then
	--		pl:EmitSound('ambient/creatures/town_child_scream1.wav')
			pl:Kill()
		end
	end)
	
	local sayings = {
		'Напиток отбеливатель хорошо для души',
		'ПРОСТО ОЧИСТКА СИСТЕМЫ ПИЩЕВАРЕНИЯ '
	}
	pl:ConCommand('say ' .. sayings[math.random(1, #sayings)])
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
	DrawSharpen(-18, 2)
end

RegisterDrug(DRUG)