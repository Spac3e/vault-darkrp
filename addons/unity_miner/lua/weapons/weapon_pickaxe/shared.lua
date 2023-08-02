if (SERVER) then 
	AddCSLuaFile()
	util.AddNetworkString("LootLog")
	local meta = FindMetaTable("Player")
	function meta:LootLog(...) 
		net.Start("LootLog")
		net.WriteTable({...})
		net.Send(self)
	end
end

if (CLIENT) then 
	SWEP.PrintName 		= 'Монтировка шахтера'
	SWEP.Slot 			= 2
	SWEP.SlotPos 		= 0
	SWEP.DrawAmmo 		= false 
	SWEP.DrawCrosshair 	= false 

end

SWEP.Instructions 		= 'Добывает камень'
SWEP.Purpose 			= 'What?'
SWEP.ViewModelFOV 		= 62
SWEP.ViewModelFlip 		= false 
SWEP.ViewModel 			= 'models/weapons/v_crowbar.mdl'
SWEP.WorldModel 		= 'models/weapons/w_crowbar.mdl'
SWEP.Category 			= 'RP'
SWEP.Spawnable 			= true 
SWEP.Primary.LastStrike = 0

function SWEP:Initialize()
	if (CLIENT) then 
		self:SetWeaponHoldType('grenade')
	end
end

local Rudes = {
	[1] = {
		['coast'] = 5,
		['name'] = 'Камень',
		['rarity'] = 1
	},
	[2] = {
		['coast'] = 8,
		['name'] = 'Уголь',
		['rarity'] = 1
	},
	[3] = {
		['coast'] = 10,
		['name'] = 'Бронза',
		['rarity'] = 2,
	},
	[4] = {
		['coast'] = 12,
		['name'] = 'Железо',
		['rarity'] = 5,
	},
	[5] = {
		['coast'] = 15,
		['name'] = 'Серебро',
		['rarity'] = 10
	},
	[6] = {
		['coast'] = 20,
		['name'] = 'Золото',
		['rarity'] = 15
	},
	[6] = {
		['coast'] = 80,
		['name'] = 'Алмаз',
		['rarity'] = 20
	}
}

function SWEP:PrimaryAttack()
	self:SetNextPrimaryFire(CurTime() + 2)
	util.PrecacheSound('weapons/crossbow/hitbod1.wav')
	if (SERVER) then
	local ply = self.Owner
	local ent = ply:GetEyeTrace().Entity

	if ply:Team() != TEAM_MINER then return rp.Notify(ply, NOTIFY_ERROR,'Вы должны быть шахтером, чтобы использовать это.') end
	if ply:GetNWInt('inventory_rudy') == 20 then return rp.Notify(ply, NOTIFY_ERROR, 'Перед добычей руды, вам нужно освободить место.') end

		if (ent:GetClass() == 'ent_rock' && ply:GetPos():Distance(ent:GetPos()) < 75) then
			ply:EmitSound( 'weapons/crossbow/hitbod1.wav' )
			util.ScreenShake(ply:GetPos(),5,5,1,100)

			local rudy = math.Rand(0,100)
			local rand = table.Random(Rudes)
			if rudy < ( 100 / rand['rarity'] ) then 
				//rp.Notify(ply,NOTIFY_SUCCESS,"Вы добыли 1кг "..rand['name']..'!')
				//self.Owner:SendLua([[LootLog("Вы добыли 1кг ]]..rand['name']..[[")]])
				self.Owner:LootLog( "1x "..rand['name'],rand['name'] == "Алмаз" )
				ply:SetNWInt('rudy_tottaly', ply:GetNWInt('rudy_tottaly') + rand['coast'])
				ply:SetNWInt('inventory_rudy', ply:GetNWInt('inventory_rudy') + 1)
				if (rand['rarity'] > 15) then 
					util.ScreenShake(ply:GetPos(),15,15,5,100)
				end
			else
				rp.Notify(ply, NOTIFY_ERROR, 'Не удалось добыть руду.')
			end
		end
	end
end

function SWEP:SecondaryAttack() return end