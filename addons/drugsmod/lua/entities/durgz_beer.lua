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
ENT.PrintName		= 'Beer'
ENT.Author			= 'The D3vine'
ENT.Spawnable		= true
ENT.AdminSpawnable	= true

ENT.Model			= 'models/drug_mod/alcohol_can.mdl'
ENT.ID				= 'Beer'

local DRUG = {}
DRUG.Name = 'Beer'
DRUG.Duration = 45

function DRUG:StartHighServer(pl)
end

function DRUG:TickServer(pl, stacks, startTime, endTime)
end

function DRUG:EndHighServer(pl)
end

function DRUG:StartHighClient(pl)
	pl:ConCommand('say подожди, подожди. парни-х. мне нужно рассказать тебе о microsoft excel!11!')
	
	local movecommands = {'left', 'right', 'moveleft', 'moveright', 'attack'}
	local numcommands = math.random(1, 5)

	for i = 0, numcommands-1 do
		timer.Simple(i * 7 + math.Rand(2, 7), function()
			local cmd = movecommands[math.random(1, #movecommands)]
			
			pl:ConCommand('+' .. cmd)
			
			timer.Simple(1, function()
				pl:ConCommand('-' .. cmd)
			end)
		end)
	end
end

function DRUG:TickClient(pl, stacks, startTime, endTime)
end

function DRUG:EndHighClient(pl)
end

function DRUG:HUDPaint(pl, stacks, startTime, endTime)
end

function DRUG:RenderSSEffects(pl, stacks, startTime, endTime)
	DrawMotionBlur(0.03, 0.4, 0.05)
end

RegisterDrug(DRUG)