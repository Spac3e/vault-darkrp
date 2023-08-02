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
ENT.PrintName		= 'Heroin'
ENT.Author			= 'The D3vine'
ENT.Spawnable		= true
ENT.AdminSpawnable	= true

ENT.Model			= 'models/katharsmodels/syringe_out/syringe_out.mdl'
ENT.ID				= 'Heroin'

local DRUG = {}
DRUG.Name = 'Heroin'
DRUG.Duration = 20

function DRUG:StartHighServer(pl)
	if (!pl.HeroinPassive) then
		pl.HeroinPassive = true
		return
	end
	
	pl:ConCommand('say Я неуязвим!')

	pl:GodEnable()
	
	pl.HeroinPassive = false
end

function DRUG:TickServer(pl, stacks, startTime, endTime)
end

function DRUG:EndHighServer(pl)
	pl:GodDisable()
	if pl:Alive() then
		pl:Kill()
	end
end

function DRUG:StartHighClient(pl)
end

function DRUG:TickClient(pl, stacks, startTime, endTime)
end

function DRUG:EndHighClient(pl)
end

function DRUG:HUDPaint(pl, stacks, startTime, endTime)
	draw.SimpleTextOutlined('Ваше сердце останавливается','Trebuchet24', ScrW()/2, ScrH() * 0.6, Color(255,255,255,math.sin(SysTime() / math.pi) * 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 2, ui.col.Red)
end

function DRUG:RenderSSEffects(pl, stacks, startTime, endTime)	
	local ColorModify = {
		['$pp_colour_addr'] 		= 0,
		['$pp_colour_addg'] 		= 0,
		['$pp_colour_addb'] 		= 0,
		['$pp_colour_mulr'] 		= 0,
		['$pp_colour_mulg'] 		= 0,
		['$pp_colour_mulb'] 		= 0,
		['$pp_colour_colour'] 		= 1,
		['$pp_colour_brightness'] 	= 0,
		['$pp_colour_contrast'] 	= 1
	}
	
	DrawMaterialOverlay('highs/shader3', math.sin(SysTime()/math.pi) * 0.05)
	DrawColorModify(ColorModify)
end

RegisterDrug(DRUG)

local function ActivateHeroin(target, dmginfo)
	if (target.HeroinPassive) then
		if (dmginfo:GetDamage() > target:Health()) then
			target:SetHealth(10)
			target:AddHigh('Heroin', true)
			target.HeroinPassive = nil
			
			dmginfo:SetDamage(0)
		end
	end
end
hook.Add('EntityTakeDamage', 'ActivateHeroin', ActivateHeroin)