local citizens = {
	'models/player/Group01/Female_01.mdl',
	'models/player/Group01/Female_02.mdl',
	'models/player/Group01/Female_03.mdl',
	'models/player/Group01/Female_04.mdl',
	'models/player/Group01/Female_06.mdl',
	'models/player/group01/male_01.mdl',
	'models/player/Group01/Male_02.mdl',
	'models/player/Group01/male_03.mdl',
	'models/player/Group01/Male_04.mdl',
	'models/player/Group01/Male_05.mdl',
	'models/player/Group01/Male_06.mdl',
	'models/player/Group01/Male_07.mdl',
	'models/player/Group01/Male_08.mdl',
	'models/player/Group01/Male_09.mdl',
	'models/player/Group02/male_02.mdl',
	'models/player/Group02/male_04.mdl',
	'models/player/Group02/male_06.mdl',
	'models/player/Group02/male_08.mdl',
}

local gangsters = {
	'models/player/Group01/Female_01.mdl',
	'models/player/group03/female_01.mdl',
	'models/player/Group01/Female_02.mdl',
	'models/player/group03/female_02.mdl',
	'models/player/Group01/Female_03.mdl',
	'models/player/group03/female_03.mdl',
	'models/player/Group01/Female_04.mdl',
	'models/player/group03/female_04.mdl',
	'models/player/Group01/Female_06.mdl',
	'models/player/group03/female_06.mdl',
	'models/player/group01/male_01.mdl',
	'models/player/group03/male_01.mdl',
	'models/player/Group01/Male_02.mdl',
	'models/player/group03/male_02.mdl',
	'models/player/Group01/male_03.mdl',
	'models/player/group03/male_03.mdl',
	'models/player/Group01/Male_04.mdl',
	'models/player/group03/male_04.mdl',
	'models/player/Group01/Male_05.mdl',
	'models/player/group03/male_05.mdl',
	'models/player/Group01/Male_06.mdl',
	'models/player/group03/male_06.mdl',
	'models/player/Group01/Male_07.mdl',
	'models/player/group03/male_07.mdl',
	'models/player/Group01/Male_08.mdl',
	'models/player/group03/male_08.mdl',
	'models/player/Group01/Male_09.mdl',
	'models/player/group03/male_09.mdl',
}


TEAM_CITIZEN = rp.addTeam('Гражданин', {
	color = Color(150,170,200),
	model = citizens,
	weapons = {},
	command = 'citizen',
	max = 0,
	salary = 45,
	hasLicense = false,
	candemote = false
})

TEAM_BIZNEC = rp.addTeam('Бизнесмен', {
	color = Color(50,50,255),
	model = citizens,
	weapons = {},
	command = 'biznec',
	max = 2,
	salary = 125,
	hasLicense = false,
	candemote = false
})

TEAM_ADMIN = rp.addTeam('Администратор', {
	color =  Color(51,128,255),
	model = 'models/player/combine_super_soldier.mdl',
	weapons = {'weapon_keypadchecker', 'unarrest_baton'},
	command = 'staff',
	max = 0,
	salary = 50,
	candemote = false,
	hasLicense = true,
	spawns = {
		rp_bangclaw_vault = {
			Vector(1270.541260,872.146790,3137.031250)
		}
	},
	CannotOwnDoors = true,
	PlayerSpawn = function(pl)
		pl:SetHealth(500)
	end,
	customCheck = function(pl) return pl:IsAdmin() end, 
	CustomCheckFailMsg = 'JobNeedsAdmin'
})

--
-- Hobos
--
local spawnHobo = function(pl)
	pl:SetHunger(25)
end

TEAM_HOBOKING = rp.addTeam('Король бездомных', {
	color = Color(80, 45, 0),
	category = 'Бездомные',
	model = 'models/player/corpse1.mdl',
	GetRelationships = function() return {TEAM_HOBOKING, TEAM_HOBO} end,
	weapons = {'weapon_bugbait'},
	command = 'hoboking',
	max = 1,
	salary = 1,
	hasLicense = false,
	candemote = false,
	hobo = true,
	CannotOwnDoors = true,
	PlayerSpawn = spawnHobo
})

TEAM_HOBO = rp.addTeam('Бездомный', {
	color = Color(80, 45, 0),
	category = 'Бездомные',
	model = 'models/player/corpse1.mdl',
	GetRelationships = function() return {TEAM_HOBOKING, TEAM_HOBO} end,
	weapons = {'weapon_bugbait'},
	command = 'hobo',
	max = 0,
	salary = 1,
	hasLicense = false,
	candemote = false,
	hobo = true,
	CannotOwnDoors = true,
	PlayerSpawn = spawnHobo
})

local police_spawns = {
	rp_bangclaw_vault = {
		Vector(2603.290039,868.414063,112.031250),
		Vector(2681.373779,865.519104,112.031250),
		Vector(2552.001465,914.945801,112.031250),
		Vector(2639.555908,967.825806,112.031250),
		Vector(2749.918701,961.603821,112.031250),
		Vector(2836.591309,921.867432,112.031250),
	}
}

TEAM_MAYOR = rp.addTeam('Мэр', {
	category = 'Правопорядок',
	color = Color(240, 0, 0, 255),
	model = 'models/player/breen.mdl',
	GetRelationships = function() return {TEAM_MAYOR, TEAM_POLICE, TEAM_CHIEF, TEAM_SWAT, TEAM_SWATLEADER, TEAM_FBR} end,
	weapons = {},
	spawns = {
		rp_bangclaw_vault = {
			Vector(1392.845825,2378.202148,248.031250)
		}
	},
	command = 'mayor',
	max = 1,
	salary = 60,
	vote = true,
	candemote = true,
	hasLicense = true,
	mayor = true,
	PoliceChief = true,
	CannotOwnDoors = true,
})

TEAM_POLICE = rp.addTeam('Полиция', {
	category = 'Правопорядок',
	color = Color(60,80,255),
    model = {"models/player/kerry/police_02_female.mdl", "models/player/kerry/policeru_01_patrol.mdl", "models/player/kerry/policeru_02_patrol.mdl", "models/player/kerry/policeru_03_patrol.mdl", "models/player/kerry/policeru_04_patrol.mdl", "models/player/kerry/policeru_05_patrol.mdl", "models/player/kerry/policeru_06_patrol.mdl", "models/player/kerry/policeru_07_patrol.mdl"},
	CanRaid = 'С действующим ордером',
	GetRelationships = function() return {TEAM_MAYOR, TEAM_POLICE, TEAM_CHIEF} end,
	weapons = {'arrest_baton', 'unarrest_baton', 'swb_usp', 'stun_baton', 'door_ram', 'weaponchecker', 'handcuffs'},
	spawns = police_spawns,
	command = 'police',
	max = 15,
	-- playtime = 10800,
	salary = 50,
	candemote = true,
	hasLicense = true,
	police = true,
	CannotOwnDoors = true,
})

TEAM_CHIEF = rp.addTeam('Шериф', {
	category = 'Правопорядок',
	color = Color(60,80,255),
	model = {"models/player/kerry/policeru_01.mdl", "models/player/kerry/policeru_02.mdl", "models/player/kerry/policeru_03.mdl", "models/player/kerry/policeru_04.mdl", "models/player/kerry/policeru_05.mdl"},
	CanRaid = 'С действующим ордером',
	GetRelationships = function() return {TEAM_MAYOR, TEAM_POLICE, TEAM_CHIEF} end,
	weapons = {'arrest_baton', 'unarrest_baton', 'swb_357', 'swb_m3super90', 'stun_baton', 'door_ram', 'weaponchecker', 'handcuffs'},
	spawns = police_spawns,
	command = 'chief',
	max = 1,
	--playtime = 10800,
	salary = 60,
	candemote = true,
	hasLicense = true,
	police = true,
	PoliceChief = true,
	CannotOwnDoors = true,
	NeedChange = TEAM_POLICE
})


TEAM_FBR = rp.addTeam('ФБР', {
	category = 'Правопорядок',
	color = Color(98,98,155),
    model = {"models/player/fbi/fbi_01.mdl", "models/player/fbi/fbi_02.mdl", "models/player/fbi/fbi_03.mdl", "models/player/fbi/fbi_04.mdl"},
	CanRaid = 'С действующим ордером',
	GetRelationships = function() return {TEAM_MAYOR} end,
	weapons = {'arrest_baton', 'unarrest_baton', 'swb_p228', 'swb_mp5', 'stun_baton', 'door_ram', 'weaponchecker', 'handcuffs'},
	spawns = police_spawns,
	command = 'fbr',
	max = 4,
	candisguise = true,
	vip = true,
	salary = 70,
	candemote = true,
	hasLicense = true,
	police = true,
	PoliceChief = true,
	CannotOwnDoors = true
})

TEAM_SWAT = rp.addTeam('Спецназ', {
	category = 'Правопорядок',
	color = Color(119,221,231),
	model = {
		'models/player/gasmask.mdl',
		'models/player/swat.mdl',
		'models/player/riot.mdl',
		'models/player/urban.mdl',
	},
	CanRaid = 'С действующим ордером',
	GetRelationships = function() return {TEAM_MAYOR, TEAM_SWAT, TEAM_SWATLEADER, TEAM_SWAT_JUGGERNAUT} end,
	weapons = {'arrest_baton', 'unarrest_baton', 'swb_usp', 'swb_m4a1', 'stun_baton', 'door_ram', 'weaponchecker', 'handcuffs', 'riot_shield'},
	spawns = police_spawns,
	command = 'swat',
	max = 5,
	playtime = 300,
	salary = 80,
	candemote = true,
	hasLicense = true,
	police = true,
	CannotOwnDoors = true
})

TEAM_SWAT_JUGGERNAUT = rp.addTeam('Джаггернаут', {
	category = 'Правопорядок',
	color = Color(119,221,231),
	model = {"models/mw2guy/riot/juggernaut.mdl"},
	CanRaid = 'С действующим ордером',
	GetRelationships = function() return {TEAM_MAYOR, TEAM_SWAT, TEAM_SWATLEADER, TEAM_SWAT_JUGGERNAUT} end,
	weapons = {'arrest_baton', 'unarrest_baton', 'swb_usp', 'm9k_m249lmg', 'stun_baton', 'door_ram', 'weaponchecker', 'handcuffs', 'heavy_shield'},
	spawns = police_spawns,
	command = 'juggernaut',
	max = 2,
	salary = 120,
	candemote = true,
	hasLicense = true,
	police = true,
	CannotOwnDoors = true,
    PlayerSpawn = function(ply) ply:SetMaxHealth(200) ply:SetHealth(200) ply:SetArmor(200) ply:SetMaxArmor(200) ply:SetRunSpeed(200) end,
	vip = true
})

TEAM_SWATLEADER = rp.addTeam('Командир спецназа', {
	category = 'Правопорядок',
	color = Color(119,221,231),
	model = {
	    'models/player/riot.mdl',
		'models/player/gasmask.mdl',
		'models/player/swat.mdl',
		'models/player/urban.mdl',
	},
	CanRaid = 'С действующим ордером',
	GetRelationships = function() return {TEAM_MAYOR, TEAM_SWAT, TEAM_SWATLEADER, TEAM_SWAT_JUGGERNAUT} end,
	weapons = {'arrest_baton', 'unarrest_baton', 'swb_deagle', 'swb_m4a1', 'stun_baton', 'door_ram', 'weaponchecker', 'handcuffs'},
	spawns = police_spawns,
	command = 'swatleader',
	max = 1,
	playtime = 300,
	salary = 100,
	candemote = true,
	hasLicense = true,
	police = true,
	PoliceChief = true,
	CannotOwnDoors = true
})

TEAM_MOBBOSS = rp.addTeam('Глава банды', {
	category = 'Криминал',
	color = Color(70,70,70),
	model = 'models/player/gman_high.mdl',
	CanRaid = true,
	CanMug = true,
	CanHostage = true,
	GetRelationships = function() return {TEAM_MOBBOSS, TEAM_VIPGANGSTER, TEAM_GANGSTER} end,
	weapons = {'unarrest_baton', 'lockpick'},
	command = 'nmobboss',
	max = 1,
	salary = 30,
	candemote = true,
	canrobbery = true
})

TEAM_GANGSTER = rp.addTeam('Бандит', {
	category = 'Криминал',
	color = Color(70,70,70),
	model = gangsters,
	CanRaid = true,
	CanMug = true,
	CanHostage = true,
	GetRelationships = function() return {TEAM_MOBBOSS, TEAM_VIPGANGSTER, TEAM_GANGSTER} end,
	weapons = {},
	command = 'gangster',
	max = 15,
	salary = 15,
	candemote = false,
	canrobbery = true
})

TEAM_VIPGANGSTER = rp.addTeam('Профессиональный бандит', {
	category = 'Криминал',
	color = Color(70,70,70),
	model = gangsters,
	CanRaid = true,
	CanMug = true,
	CanHostage = true,
	GetRelationships = function() return {TEAM_MOBBOSS, TEAM_GANGSTER, TEAM_VIPGANGSTER} end,
	weapons = {'swb_ak47'},
	command = 'vipgangster',
	max = 5,
	vip = true,
	salary = 25,
	candemote = false,
	canrobbery = true
})

TEAM_THUG = rp.addTeam('Громила', {
	category = 'Рейдеры',
	color= Color(179,53,247),
	model = {'models/player/Group01/male_03.mdl'},
	CanRaid = true,
	CanMug = true,
	weapons = {'weapon_combo_fists'},
	command = 'thug',
	max = 2,
	salary = 25,
	vip = true,
	canrobbery = true,
	candemote = false,
	PlayerSpawn = function(pl)
		pl:SetHealth(150)
	end
})

TEAM_THIEF = rp.addTeam('Взломщик', {
	category = 'Рейдеры',
	color = Color(204, 204, 0),
	model = 'models/player/guerilla.mdl',
	CanRaid = true,
	weapons = {'lockpick'},
	command = 'thief',
	lockpicktime = 0.70,
	max = 8,
	salary = 45,
	candemote = false
})

TEAM_THIEFPRO = rp.addTeam('Профессиональный взломщик', {
	category = 'Рейдеры',
	color = Color(152, 11, 35),
	model = 'models/player/phoenix.mdl',
	CanRaid = true,
	weapons = {'lockpick', 'keypad_cracker', 'swb_p228'},
	command = 'thiefpro',
	vip = true,
	keypadcracktime = 0.55,
	lockpicktime = 0.50,
	max = 2,
	salary = 55,
	candemote = false
})

TEAM_HACKER = rp.addTeam('Хакер', {
	category = 'Рейдеры',
	color = Color(50,50,90),
	model = {
		'models/player/Hostage/Hostage_04.mdl',
		'models/player/kleiner.mdl',
		'models/player/magnusson.mdl'
	},
	CanRaid = true,
	weapons = {'keypad_cracker'},
	command = 'hacker',
	keypadcracktime = 0.75,
	max = 6,
	salary = 45,
	candemote = false
})

TEAM_GUN = rp.addTeam('Продавец оружия', {
	category = 'Торговцы',
	color = Color(255, 140, 0),
	model = {
		'models/player/monk.mdl',
		'models/player/alyx.mdl',
	},
	weapons = {},
	command = 'gundealer',
	max = 4,
	salary = 45,
	candemote = true,
	hasLicense = false
})

TEAM_BMIDEALER = rp.addTeam('Торговец черного рынка', {
	category = 'Торговцы',
	color = Color(0, 51, 51),
	model = 'models/player/guerilla.mdl',
	weapons = {},
	command = 'blackmarketdealer',
	max = 2,
	salary = 45,
	candemote = true
})

TEAM_METAVAR = rp.addTeam('Метоварщик', {
	category = 'Криминал',
	color = Color(0,155,119),
	model = citizens,
	weapons = {},
	command = 'metavar',
	max = 3,
	playtime = 5800,
	salary = 20,
	candemote = false
})

TEAM_COCS = rp.addTeam("Кокаинщик", {
	color = Color(30, 105, 141, 255),
	model = citizens,
	weapons = {},
	command = "cocs",
	max = 3,
	salary = 130,
	admin = 0,
	category = "Криминал",
	candemote = true,
})

TEAM_DRUGDEALER = rp.addTeam('Наркобарон', {
	category = 'Торговцы',
	color = Color(153, 51, 255),
	model = {
		'models/player/group01/Male_03.mdl', 
		'models/player/Group01/Male_04.mdl'
	},
	weapons = {},
	command = 'drugdealer',
	max = 2,
	salary = 20,
	admin = 0,
	candemote = true
})

TEAM_DRUGMAKER = rp.addTeam('Гровер', {
	category = 'Криминал',
	color = Color(107, 142, 35),
	model = {
		'models/player/group01/Male_03.mdl', 
		'models/player/Group01/Male_04.mdl'
	},
	weapons = {},
	command = 'drugmaker',
	max = 4,
	salary = 20,
	admin = 0,
	candemote = true
})

TEAM_BARTENDER = rp.addTeam('Бармен', {
	category = 'Торговцы',
	color = Color(153, 102, 51),
	model = 'models/player/eli.mdl',
	weapons = {},
	command = 'bartender',
	max = 4,
	candemote = true
})

TEAM_COOK = rp.addTeam('Повар', {
	category = 'Торговцы',
	color = Color(238, 99, 99),
	model = 'models/player/mossman_arctic.mdl',
	weapons = {},
	command = 'cook',
	max = 4,
	salary = 45,
	candemote = true,
	cook = true
})

TEAM_HITMAN = rp.addTeam('Наемный убийца', {
	color =  Color(150, 80, 80),
	model = {
		'models/player/Group01/female_02.mdl',
		'models/player/Group01/male_07.mdl',
		'models/player/Group01/male_03.mdl',
		'models/player/Group01/female_05.mdl',
		'models/player/Group03m/male_03.mdl',
		'models/player/Group03m/female_02.mdl',
		'models/player/Group03m/female_06.mdl',
		'models/player/Group03m/male_07.mdl',
		'models/player/Group03m/female_01.mdl',
	},
	CanRaid = 'Только для завершения заказа',
	weapons = {},
	command = 'hitman',
	max = 4,
	salary = 45,
	candemote = true,
	hitman = true
})

TEAM_VIPHITMAN = rp.addTeam('Опытный убийца', {
	color =  Color(150, 80, 80),
	model = {
		'models/player/Group01/male_07.mdl',
		'models/player/Group01/female_02.mdl',
		'models/player/Group01/male_03.mdl',
		'models/player/Group01/female_05.mdl',
		'models/player/Group03m/male_03.mdl',
		'models/player/Group03m/female_02.mdl',
		'models/player/Group03m/female_06.mdl',
		'models/player/Group03m/male_07.mdl',
		'models/player/Group03m/female_01.mdl',
	},
	CanRaid = 'Только для завершения заказа',
	weapons = {'swb_awp', 'swb_knife', 'swb_p228'},
	command = 'viphitman',
	max = 2,
	salary = 60,
	candemote = true,
	vip = true,
	hitman = true
})

TEAM_SECURITY = rp.addTeam('Охранник', {
	color = Color(0,140,255),
	model = {
		'models/player/odessa.mdl',
		'models/player/leet.mdl'
	},
	weapons = {'stun_baton'},
	command = 'security',
	max = 6,
	salary = 45,
	candemote = true
})

TEAM_BANK = rp.addTeam('Банкир', {
	color = Color(79, 121, 66),
	model = {
		'models/player/hostage/hostage_02.mdl',
		'models/player/hostage/hostage_03.mdl',
	},
	weapons = {},
	command = 'banker',
	max = 1,
	salary = 45,
	candemote = true,
})

TEAM_DOCTOR = rp.addTeam('Доктор', {
	color = Color(47, 79, 79),
	model = {
		'models/player/Group03m/male_01.mdl',
		'models/player/Group03m/male_02.mdl',
		'models/player/Group03m/male_03.mdl',
		'models/player/Group03m/male_04.mdl',
		'models/player/Group03m/male_05.mdl',
		'models/player/Group03m/male_06.mdl',
		'models/player/Group03m/male_07.mdl',
		'models/player/Group03m/male_08.mdl',
		'models/player/Group03m/male_09.mdl',
		'models/player/Group03m/female_01.mdl',
		'models/player/Group03m/female_02.mdl',
		'models/player/Group03m/female_03.mdl',
		'models/player/Group03m/female_04.mdl',
		'models/player/Group03m/female_05.mdl',
		'models/player/Group03m/female_06.mdl'
	},
	weapons = {'med_kit'},
	command = 'medic',
	max = 8,
	salary = 45,
	candemote = true,
	hasLicense = false,
	medic = true
})

TEAM_FREERUNNER = rp.addTeam('Трейсер', {
	color= Color(71, 204, 71),
	model = 'models/player/p2_chell.mdl',
	weapons = {'climb_swep'},
	command = 'freerunner',
	max = 6,
	salary = 40,
	candemote = false
})

TEAM_BIT = rp.addTeam("Битмайнер", {
	color = Color(107, 107, 107, 255),
	model = citizens,
	weapons = {"moneychecker"},
	command = "bit",
	max = 4,
	salary = 20,
	admin = 0,
	vote = false,
	candemote = false,
	hasLicense = false
})

local banned_spawns = {
	rp_bangclaw_vault = {
		Vector(741.111389,-4233.000488,72.031250),
		Vector(752.813416,-4335.308594,72.031250),
		Vector(742.893005,-4428.295410,72.031250),
		Vector(841.513550,-4451.435547,72.031250),
		Vector(960.136597,-4449.628906,72.031250),
		Vector(1272.364258,-4444.873535,72.031250)
	}
}

TEAM_BANNED = rp.addTeam('Забаненный', {
	color = Color(255,0,0),
	model = 'models/player/charple.mdl',
	weapons = {},
	spawns = banned_spawns,
	command = 'banned124',
	max = 0,
	salary = 0,
	hasLicense = false,
	candemote = false,
	customCheck = function(pl) return pl:IsBanned() end,  
	CustomCheckFailMsg = 'JobNeedsBanned'
})

TEAM_HOTEL = rp.addTeam('Владелец отеля', {
	color = Color(205, 205, 205),
	model = 'models/player/magnusson.mdl',
	GetRelationships = function() return 'Жильцам' end,
	spawns = {
		rp_bangclaw_vault = {
			Vector(11386.279297,1742.067627,72.031250)
		}
	},
	weapons = {},
	command = 'hotelmanager',
	max = 1,
	salary = 20,
	hasLicense = false,
	candemote = true,
	HotelManager = true,
	CannotOwnDoors = true
})

TEAM_MINER = rp.addTeam('Шахтер', {
	color = Color(120, 120, 120),
	model = 'models/player/Group03/Male_04.mdl',
	weapons = {'weapon_pickaxe'},
	spawns = {
		rp_bangclaw_vault = {
			Vector(-8483.440430,1773.138794,64.031250),
			Vector(-8479.322266,1705.928467,64.031250),
			Vector(-8473.719727,1636.438232,64.031250)
		}
	},
	command = 'miner',
	max = 4,
	salary = 15,
	hasLicense = false
})

rp.AddDoorGroup('Полицейский участок', TEAM_MAYOR, TEAM_POLICE, TEAM_CHIEF, TEAM_SWAT, TEAM_SWATLEADER, TEAM_FBR)
rp.AddDoorGroup('Мэрия', TEAM_MAYOR, TEAM_POLICE, TEAM_CHIEF, TEAM_SWAT, TEAM_SWATLEADER, TEAM_FBR)

rp.addGroupChat(TEAM_MOBBOSS, TEAM_GANGSTER, TEAM_VIPGANGSTER)
rp.addGroupChat(TEAM_MAYOR, TEAM_POLICE, TEAM_CHIEF, TEAM_SWAT, TEAM_SWATLEADER, TEAM_FBR)
rp.addGroupChat(TEAM_HOBOKING, TEAM_HOBO) 

rp.DefaultTeam = TEAM_CITIZEN