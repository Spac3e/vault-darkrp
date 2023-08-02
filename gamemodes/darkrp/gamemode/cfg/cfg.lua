rp.cfg.StartMoney       = 25000

rp.cfg.StartKarma		= 1000
rp.cfg.MoneyPerKarma    = 125
rp.cfg.SecondMoneyPerKarma = 150

rp.cfg.DisguiseTime     = 300

rp.cfg.OrgCost 				= 50000
rp.cfg.OrgBasicBankMax		= 100000
rp.cfg.OrgBankTax			= 0.01
rp.cfg.OrgRenameCost		= 50000
rp.cfg.OrgInviteCost		= 1000
rp.cfg.OrgMaxMembers		= 50
rp.cfg.OrgMaxMembersPremium	= 250
rp.cfg.OrgMaxRanks			= 5
rp.cfg.OrgMaxRanksPremium	= 30

rp.cfg.MaxPrinters = 3

rp.cfg.AdvertCost		= 100

rp.cfg.HungerRate 		= 4000 --1800

rp.cfg.DoorTaxMin		= 10
rp.cfg.DoorTaxMax		= 500
rp.cfg.DoorCostMin		= 100
rp.cfg.DoorCostMax 		= 2000

rp.cfg.PropLimit 		= 40

rp.cfg.RagdollDelete	= 60

rp.cfg.ChangeJobTime	= 1

-- Speed
rp.cfg.WalkSpeed 		= 180
rp.cfg.RunSpeed 		= 280

-- Printers
rp.cfg.PrintDelay 		= 200
rp.cfg.PrintAmount 		= 2500
rp.cfg.InkCost 			= 250

-- Hits
rp.cfg.HitExpire		= 600
rp.cfg.HitCoolDown 		= 300
rp.cfg.HitMinCost 		= 1000
rp.cfg.HitMaxCost 		= 50000

-- Afk
rp.cfg.AfkDemote 		= (60*60)*1
rp.cfg.AfkPropRemove 	= (60*60)*3
rp.cfg.AfkDoorSell 		= (60*60)*3

rp.cfg.CreditSale 		= ''
rp.cfg.CreditsURL 		= ''

-- Lotto
rp.cfg.MinLotto 		= 1000
rp.cfg.MaxLotto 		= 50000

rp.cfg.LockdownTime 	= 600

rp.cfg.DefaultLaws 		= 
[[
Денежные Принтеры: Тюрьма
Нелегал: Тюрьма
Убийство, Взлом: Тюрьма
Оружие: Тюрьма
]]

rp.cfg.LockdownSounds = 'lockdown.ogg'

rp.cfg.RulesURL = 'https://book.vaultcommunity.net/books/pravila-garrys-mod/page/pravila-dark-rp'
rp.cfg.DiscordURL = 'https://discord.gg/vaultcommunity'

rp.cfg.DisallowDrop = {
	arrest_stick 	= true,
	door_ram 		= true,
	gmod_camera 	= true,
	gmod_tool 		= true,
	keys 			= true,
	med_kit 		= true,
	pocket 			= true,
	stunstick 		= false,
	unarrest_stick 	= false,
	weapon_keypadchecker = true,
	weapon_physcannon = true,
	weapon_physgun 	= true,
	weaponchecker 	= true,
	weapon_fists 	= true
}

rp.cfg.DefaultWeapons = {
	'weapon_physcannon',
	'weapon_physgun',
	'gmod_tool',
	'keys',
	'pocket'
}

rp.cfg.TextSrceenFonts = {
	'Tahoma'
}

-- Automated announcements
if (CLIENT) then
	rp.cfg.AnnouncementDelay = 320
	rp.cfg.Announcements = {
		{ui.col.Purple, 'Есть жалоба или вопрос? Напишите в чате @ и текст вашего сообщения.'},
		{ui.col.Purple, 'Хотите найти приятное место для общения или ищите наш дискорд сервер? Переходите по ссылке - https://discord.gg/vaultcommunity'},
		{ui.col.Gold, 'Быстрое меню команд на "C".'},
		{ui.col.Green, 'Авто-рестарт в 4:00 по Московскому времени.'},
		{ui.col.Brown, 'Контент сервера -> https://steamcommunity.com/sharedfiles/filedetails/?id=2927812004'}
	}
end

-- Cop shops
rp.cfg.CopShops = {
	rp_bangclaw_vault = {
		Pos = Vector(2826.552490,504.000275,112.031250),
		Ang = Angle(0, 90, 0)
	},
}

-- Drug buyers
rp.cfg.DrugBuyers = {
	rp_bangclaw_vault = {
		Pos = Vector(-156,-2680,136),
		Ang = Angle(0, -90, 0)
	}
}

rp.cfg.GunBuyers = {
	rp_bangclaw_vault = {
		Pos = Vector(2336.971191,504.031250,112.031250),
		Ang = Angle(0, 90, 0)
	}
}

rp.cfg.MethBuyers = {
	rp_bangclaw_vault = {
		Pos = Vector(5550.790527,-1263.968750,72.031250),
		Ang = Angle(0, 90, 0)
	}
}

rp.cfg.CocaineBuyer = {
	rp_bangclaw_vault = {
		Pos = Vector(-1744.031250,464.031250,64.024597),
		Ang = Angle(0, 125, 0)
	}
}

rp.cfg.HitmanMenu = {
	rp_bangclaw_vault = {
		Pos = Vector(-367.968750,-2329.801758,72.031250),
		Ang = Angle(0, 0, 0)
	}
}

-- Spawn
rp.cfg.SpawnDisallow = {
	prop_physics		= true,
	ent_textscreen 		= true,
	metal_detector		= true,
	gmod_light 			= true,
	gmod_lamp 			= true,
	keypad 				= true,
	gmod_button 		= true,
	gmod_cameraprop 	= true
}

rp.cfg.Spawns = {
	rp_bangclaw_vault = {
        Vector(12495.516602,1044.646729,56.716076),
		Vector(11504.454102,1552.445923,74.808174)
	},
}

rp.cfg.TeamSpawns = rp.cfg.TeamSpawns or {
    [game.GetMap()] = {},
    rp_bangclaw_vault = {}
}

rp.cfg.SpawnPos = rp.cfg.SpawnPos or {
	rp_bangclaw_vault = {
        Vector(11733,1461,64),
        Vector(11724,1362,64),
        Vector(11736,1225,64),
        Vector(11671,1131,72),
        Vector(11644,1489,72),
        Vector(11600,1312,64)
    },
}

-- Jail
rp.cfg.WantedTime = 600
rp.cfg.WarrantTime = 300
rp.cfg.ArrestTime = 300

rp.cfg.Jails = {
    rp_bangclaw_vault = {
		Vector(2749.259033,505.910339,-45.406437),
		Vector(911.973450,1540.558350,-27.986359)
	}
}

rp.cfg.JailPos = {
    rp_bangclaw_vault = {
		Vector(2603.536133,607.561035,-31.968752),
		Vector(2513.687744,607.935242,-31.968752),
		Vector(2393.025879,612.657349,-31.968748),
		Vector(2308.031982,608.365356,-31.968748),
		Vector(2248.893066,604.969116,-31.968748),
		Vector(2141.410400,603.983948,-31.968750),
		Vector(2050.512207,600.862854,-31.968750)
    }
}

-- Dumpsters 
rp.cfg.Dumpsters = {
    rp_bangclaw_vault = {
        {Vector(11108,1829,97), Angle(0,-90,0)},
        {Vector(6874,234,97), Angle(0, 0, 0)},
        {Vector(7012,-870,97), Angle(0, 90, 0)},
        {Vector(7936,-902,97), Angle(0, 90, 0)},
        {Vector(5530,421,97), Angle(0, 0, 0)},
        {Vector(-303,1589,97), Angle(0, -90, 0)},
		{Vector(2853,-2434,97), Angle(0, 180, 0)},
        {Vector(-1243,-539,97), Angle(0, -90, 0)},
        {Vector(69,672,97), Angle(0, -180, 0)},
		{Vector(3930,-3013,97), Angle(0,0,0)}
    }
}

local hour = (60 * 60)
rp.cfg.PlayTimeRanks = {
	{'Новичок', 0},
	{'Опытный Новичок', (hour * 5)},
	{'Попрошайка', (hour * 10)},
	{'Ученик', (hour * 15)},
	{'Студент', (hour * 20)},
	{'Работяга', (hour * 25)},
	{'Задира', (hour * 30)},
	{'Уличный Хулиган', (hour * 35)},
	{'Ворюга', (hour * 40)},
	{'Кто-то', (hour * 45)},
	{'Опытный Игрок', (hour * 50)},
	{'Пистолетный Хулиган', (hour * 55)},
	{'Трудоголик', (hour * 60)},
	{'Солдат', (hour * 65)},
	{'Главарь', (hour * 70)},
	{'Заместитель Босса', (hour * 75)},
	{'Советник Босса', (hour * 80)},
	{'Уволенный', (hour * 85)},
	{'Да да я!', (hour * 90)},
	{'Скоро что-то будет', (hour * 95)},
	{'Босс', (hour * 100)},
	{'Я знаю все', (hour * 150)},
	{'Профессиональный Гражданин', (hour * 200)},
	{'Организатор', (hour * 250)},
	{'Токсичный', (hour * 300)},
	{'Оружейный Барон', (hour * 350)},
	{'Плакса', (hour * 400)},
	{'Рейдер', (hour * 420)},
	{'Плохой Рейдер', (hour * 450)},
	{'Миллиардер Больших денег', (hour * 500)},
	{'Юридически Отсталый', (hour * 550)},
	{'Незаконно Интеллектуальный', (hour * 600)},
	{'Анимешник', (hour * 650)},
	{'Хентайщик', (hour * 700)},
	{'БДСМ', (hour * 750)},
	{'Строитель', (hour * 800)},
	{'Опытный Строитель', (hour * 850)},
	{'Ниггер', (hour * 900)},
	{'Жопо-Горящий', (hour * 950)},
	{'400 IQ', (hour * 1000)},
	{'Да? и что?', (hour * 1100)},
	{'Чо?', (hour * 1200)},
	{'Дерьмо на Дерьме', (hour * 1300)},
	{'ЛоЛялист', (hour * 1400)},
	{'Вкусное Занятие', (hour * 1500)},
	{'Ламповый', (hour * 1600)},
	{'Детектив', (hour * 1700)},
	{'Святой', (hour * 1800)},
	{'Божественный', (hour * 1900)},
	{'2k', (hour * 2000)},
	{'Привет, я маленькая девочка ', (hour * 2500)},
	{'Что? Где я?', (hour * 3000)},
}

rp.cfg.weapontablez = { -- не трогайя етот прякол ето же мем про то как вы юзаете сборку, которую сами обсираете
	['Легкое'] = { -- не трогайя етот прякол ето же мем про то как вы юзаете сборку, которую сами обсираете
		'swb_357', -- не трогайя етот прякол ето же мем про то как вы юзаете сборку, которую сами обсираете
		'swb_deagle', -- не трогайя етот прякол ето же мем про то как вы юзаете сборку, которую сами обсираете
		'swb_fiveseven', -- не трогайя етот прякол ето же мем про то как вы юзаете сборку, которую сами обсираете
		'swb_glock18', -- не трогайя етот прякол ето же мем про то как вы юзаете сборку, которую сами обсираете
		'swb_p228', -- не трогайя етот прякол ето же мем про то как вы юзаете сборку, которую сами обсираете
		'swb_usp', -- не трогайя етот прякол ето же мем про то как вы юзаете сборку, которую сами обсираете
		-- submachines
		'swb_p90', -- не трогайя етот прякол ето же мем про то как вы юзаете сборку, которую сами обсираете
		'swb_mp5', -- не трогайя етот прякол ето же мем про то как вы юзаете сборку, которую сами обсираете
		'swb_ump', -- не трогайя етот прякол ето же мем про то как вы юзаете сборку, которую сами обсираете
		'swb_mac10', -- не трогайя етот прякол ето же мем про то как вы юзаете сборку, которую сами обсираете
		'swb_tmp', -- не трогайя етот прякол ето же мем про то как вы юзаете сборку, которую сами обсираете
		-- knife -- не трогайя етот прякол ето же мем про то как вы юзаете сборку, которую сами обсираете
		'swb_knife' -- не трогайя етот прякол ето же мем про то как вы юзаете сборку, которую сами обсираете
	}, -- не трогайя етот прякол ето же мем про то как вы юзаете сборку, которую сами обсираете
	['Тяжелое'] = { -- не трогайя етот прякол ето же мем про то как вы юзаете сборку, которую сами обсираете
		'swb_ak47', -- не трогайя етот прякол ето же мем про то как вы юзаете сборку, которую сами обсираете
		'swb_famas', -- не трогайя етот прякол ето же мем про то как вы юзаете сборку, которую сами обсираете
		'swb_galil', -- не трогайя етот прякол ето же мем про то как вы юзаете сборку, которую сами обсираете
		'swb_m249', -- не трогайя етот прякол ето же мем про то как вы юзаете сборку, которую сами обсираете
		'swb_m4a1', -- не трогайя етот прякол ето же мем про то как вы юзаете сборку, которую сами обсираете
		'swb_sg550', -- не трогайя етот прякол ето же мем про то как вы юзаете сборку, которую сами обсираете
		'swb_sg552', -- не трогайя етот прякол ето же мем про то как вы юзаете сборку, которую сами обсираете
		'swb_aug', -- не трогайя етот прякол ето же мем про то как вы юзаете сборку, которую сами обсираете
		-- shotgun -- не трогайя етот прякол ето же мем про то как вы юзаете сборку, которую сами обсираете
		'swb_m3super90', -- не трогайя етот прякол ето же мем про то как вы юзаете сборку, которую сами обсираете
		'swb_xm1014', -- не трогайя етот прякол ето же мем про то как вы юзаете сборку, которую сами обсираете
		-- sniper -- не трогайя етот прякол ето же мем про то как вы юзаете сборку, которую сами обсираете
		'swb_g3sg1', -- не трогайя етот прякол ето же мем про то как вы юзаете сборку, которую сами обсираете
		'swb_scout', -- не трогайя етот прякол ето же мем про то как вы юзаете сборку, которую сами обсираете
		'swb_awp' -- не трогайя етот прякол ето же мем про то как вы юзаете сборку, которую сами обсираете
	}, -- не трогайя етот прякол ето же мем про то как вы юзаете сборку, которую сами обсираете
	['all'] = {},  -- не трогайя етот прякол ето же мем про то как вы юзаете сборку, которую сами обсираете
} -- не трогайя етот прякол ето же мем про то как вы юзаете сборку, которую сами обсираете

rp.cfg.allowedW = {
	-- спасибо
	['TEAM_CITIZEN'] 	= {'Легкое'},
	['TEAM_ADMIN'] 		= {'all'},
	-- 
	['TEAM_HOBOKING'] 	= {'Легкое'},
	['TEAM_HOBO'] 		= {'Легкое'},
	-- Gov
	['TEAM_MAYOR'] 		= {'Легкое'},
	['TEAM_POLICE'] 	= {'all'},
	['TEAM_SWAT_JUGGERNAUT'] 	= {'all'},
	['TEAM_CHIEF'] 		= {'all'},
	['TEAM_FBR'] 		= {'all'},
	['TEAM_SWAT'] 		= {'all'},
	['TEAM_SWATLEADER'] = {'all'},
	--
	['TEAM_VIPHITMAN'] = {'all'},
	['TEAM_MOBBOSS'] 	= {'all'},
	['TEAM_GANGSTER'] 	= {'all'},
	['TEAM_VIPGANGSTER']= {'all'},
	['TEAM_THUG'] 		= {'all'},
	['TEAM_THIEF'] 		= {'Легкое'},
	['TEAM_THIEFPRO'] 	= {'Легкое'},
	['TEAM_HACKER'] 	= {'Легкое'},
	['TEAM_GUN'] 		= {'all'},
	['TEAM_BMIDEALER'] 	= {'all'},
	['TEAM_METAVAR'] 	= {'Легкое'},
	['TEAM_DRUGDEALER'] = {'Легкое'},
	['TEAM_DRUGMAKER'] 	= {'Легкое'},
	['TEAM_BARTENDER'] 	= {'Легкое'},
	['TEAM_COOK'] 		= {'Легкое'},
	['TEAM_HITMAN'] 	= {'all'},
	['TEAM_SECURITY'] 	= {'all'},
	['TEAM_BANK'] 		= {'Легкое'},
	['TEAM_DOCTOR'] 	= {'Легкое'},
	['TEAM_FREERUNNER'] = {'Легкое'},
	['TEAM_WHORE'] 		= {'Легкое'},
	['TEAM_PIMP'] 		= {'all'},
	['TEAM_HOTEL']		= {'Легкое'},
	['TEAM_MINER']		= {'Легкое'}
}

rp.cfg.DefaultVoices = {
	{
		label = 'Привет', // кнопка в меню
		sound = 'vo/npc/male01/hi01.wav', 
		text = 'Привет.' // текст в чате
	},
	{
		label = 'Да',
		sound = 'vo/npc/male01/yeah02.wav',
		text = 'Да!',
	},
	{
		label = 'Нет',
		sound = 'vo/npc/male01/no01.wav',
		text = 'Нет!',
	},
	{
		label = 'Хорошо',
		sound = 'vo/npc/male01/ok01.wav',
		text = 'Хорошо.'
	},
	{
		label = 'Отлично',
		sound = 'vo/npc/male01/nice.wav',
		text = 'Отлично.'
	},
	{
		label = 'Вперёд',
		sound = 'vo/npc/male01/letsgo01.wav',
		text = 'Вперёд!'
	},
	{
		label = 'Я ранен',
		sound = 'vo/npc/male01/imhurt01.wav',
		text = 'Я ранен!'
	},
	{
		label = 'Извини',
		sound = 'vo/npc/male01/sorry01.wav',
		text = 'Извини.'
	},
	{
		label = 'В укрытие',
		sound = 'vo/npc/male01/takecover02.wav',
		text = 'В укрытие!'
	},
	{
		label = 'Осторожно',
		sound = 'vo/npc/male01/watchout.wav',
		text = 'Осторожно!',
	},
	{
		label = 'Убирайся',
		sound = 'vo/npc/male01/gethellout.wav',
		text = 'Убирайся!'
	},
	{
		label = 'Есть один',
		sound = 'vo/npc/male01/gotone01.wav',
		text = 'Есть один!',
	},
	{
		label = 'Помогите',
		sound = 'vo/npc/male01/help01.wav',
		text = 'Помогите!',
	},
	{
		label = 'Воина не кончится',
		sound = 'cit/question01.wav',
		text = 'Эта война вообще, похоже, не кончится.',
	},
	{
		label = 'Свобода',
		sound = 'cit/question07.wav',
		text = 'Чувствуешь? Это свобода!',
	},
	{
		label = 'Мало шансов',
		sound = 'cit/question21.wav',
		text = 'Я конечно не игрок, но шансов у нас мало...',
	},
	{
		label = 'Хуже и хуже',
		sound = 'cit/question12.wav',
		text = 'Мне сдается, что все идет только хуже и хуже!',
	},
	{
		label = 'Смысл был',
		sound = 'cit/vanswer09.wav',
		text = 'В этом почти был смысл...',
	},
	{
		label = 'Женюсь',
		sound = 'cit/question29.wav',
		text = 'Когда все кончится, я женюсь!',
	},
	{
		label = 'Альянс лучше',
		sound = 'cit/cit_remarks20.wav',
		text = 'Верите или нет, но при Альянсе мне было лучше...',
	},
	{
		label = 'Не крабы',
		sound = 'cit/cit_remarks19.wav',
		text = 'Хоть они и зовутся крабами, но на вкус совсем не похожи.',
	},
}