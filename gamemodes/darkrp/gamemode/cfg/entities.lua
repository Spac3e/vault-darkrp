-- Money Printers
-- Printers
local p = 'Денежный принтер'

rp.AddEntity('Денежный принтер', {
	catagory = p,
	ent = 'money_printer',
	model = 'models/sup/printer/printer.mdl',
	price = 5000,
	max = 8,
	cmd = '/buymoneyprinter',
	allowed = {TEAM_CITIZEN,TEAM_BIZNEC,TEAM_MAYOR,TEAM_MOBBOSS,TEAM_GANGSTER,TEAM_VIPGANGSTER,TEAM_THUG,TEAM_THIEF,TEAM_THIEFPRO,TEAM_HACKER,TEAM_GUN,TEAM_BMIDEALER,TEAM_METAVAR,TEAM_COCS,TEAM_DRUGDEALER,TEAM_BARTENDER,TEAM_COOK,TEAM_HITMAN,TEAM_VIPHITMAN,TEAM_SECURITY,TEAM_BANK,TEAM_DOCTOR,TEAM_FREERUNNER,TEAM_HOTEL},
	pocket = false,
	onSpawn = function(self, b, d)
//    	if IsValid(d.Entity) and d.Entity.IsPrinerRack then
//            d.Entity:AddPrinter(b)
//      end
		rp.achievements.AddProgress(b, ACHIEVEMENT_PRINTERS, 1)
	end
})	

local pr = 'Стойки для принтеров'

rp.AddEntity('Маленькая Стойка', {
    catagory = pr,
	ent = 'money_printer_rack_small',
    model = 'models/sup/printerrack/sup_printerrack_small.mdl',
    price = 2000,
    max = 4,
	allowed = {TEAM_BIT},
    cmd = '/buyprinterracks',
	pocket = false
})

rp.AddEntity('Большая Стойка', {
    catagory = pr,
	ent = 'money_printer_rack_large',
    model = 'models/sup/printerrack/sup_printerrack_large.mdl',
    price = 4000,
    max = 4,
	allowed = {TEAM_BIT},
    cmd = '/buyprinterrackl',
	pocket = false
})

rp.AddEntity('Контроллер-Стойка', {
    catagory = pr,
	ent = 'money_printer_rack_base',
    model = 'models/sup/printerrack/sup_printerrack_main.mdl',
    price = 2000,
    max = 4,
	allowed = {TEAM_BIT},
    cmd = '/buyprinterrackc',
	pocket = false
})

rp.AddEntity('Стойка Для Принтеров', {
    catagory = pr,
	ent = 'money_printer_rack',
    model = 'models/sup/printerrack/rack.mdl',
    price = 4000,
    max = 4,
	allowed = {TEAM_BIT},
    cmd = '/buyprinterrack',
    pocket = false
})

rp.AddEntity('Корзина для денег', {
	catagory = 'Денежный принтер',
	ent = 'money_basket', 
	model = 'models/props_junk/PlasticCrate01a.mdl', 
	price = 500, 
	max = 1, 
	cmd = '/buybasket',
	pocket = false
})


rp.AddEntity("Битмайнер S1", {
	ent = "bm2_bitminer_1",
	model = "models/bitminers2/bitminer_1.mdl",
	price = 5000,
	max = 1,
	cmd = "/buybitminers1",
	category = "Нелегальные предметы",
	allowed = {TEAM_BIT}
}) 

rp.AddEntity("Битмайнер S2", {
	ent = "bm2_bitminer_2",
	model = "models/bitminers2/bitminer_3.mdl",
	price = 25000,
	max = 1,
	cmd = "/buybitminers2",
	category = "Нелегальные предметы",
	allowed = {TEAM_BIT}
})

rp.AddEntity("Сервер", {
	ent = "bm2_bitminer_server",
	model = "models/bitminers2/bitminer_2.mdl",
	price = 50000,
	max = 8,
	cmd = "/buybitminerserver",
	category = "Нелегальные предметы",
	allowed = {TEAM_BIT}
})

rp.AddEntity("Склад для сервера", {
	ent = "bm2_bitminer_rack",
	model = "models/bitminers2/bitminer_rack.mdl",
	price = 90000,
	max = 1,
	cmd = "/buybitminerrack",
	category = "Нелегальные предметы",
	allowed = {TEAM_BIT}
})

rp.AddEntity("Удлинитель", {
	ent = "bm2_extention_lead",
	model = "models/bitminers2/bitminer_plug_3.mdl",
	price = 500,
	max = 3,
	cmd = "/buybitminerextension",
	category = "Нелегальные предметы",
	allowed = {TEAM_BIT}
})

rp.AddEntity("Кабель питания", {
	ent = "bm2_power_lead",
	model = "models/bitminers2/bitminer_plug_2.mdl",
	price = 500,
	max = 4,
	cmd = "/buybitminerpowerlead",
	category = "Нелегальные предметы",
	allowed = {TEAM_BIT}
})

rp.AddEntity("Генератор", {
	ent = "bm2_generator",
	model = "models/bitminers2/generator.mdl",
	price = 6000,
	max = 2,
	cmd = "/buybitminergenerator",
	category = "Нелегальные предметы",
	allowed = {TEAM_BIT}
})

rp.AddEntity("Топливо", {
	ent = "bm2_fuel",
	model = "models/props_junk/gascan001a.mdl",
	price = 850,
	max = 2,
	cmd = "/buybitminerfuel",
	category = "Нелегальные предметы",
	allowed = {TEAM_BIT}
})

rp.AddEntity('Экстрактор',{
	category = "Приготовление коки",
    model = "models/craphead_scripts/the_cocaine_factory/extractor/extractor.mdl",
    ent = "cocaine_extractor",
    cmd = "/extractorkoks",
    max = 2,
    vip = false,
    price = 10000,
    allowed = {TEAM_COCS},
    inventory = false,
})

rp.AddEntity('Ведро',{
	category = "Приготовление коки",
    model = "models/craphead_scripts/the_cocaine_factory/utility/bucket.mdl",
    ent = "cocaine_bucket",
    cmd = "/bucketkoka",
    max = 4,
    vip = false,
    price = 500,
    allowed = {TEAM_COCS},
    inventory = false,
})

rp.AddEntity('Коробка для экспорта',{
	category = "Приготовление коки",
    model = "models/craphead_scripts/the_cocaine_factory/utility/cocaine_box.mdl",
    ent = "cocaine_box",
    cmd = "/korobkakok",
    max = 4,
    vip = false,
    price = 100,
    allowed = {TEAM_COCS},
    inventory = false,
})

rp.AddEntity('Сода',{
	category = "Приготовление коки",
    model = "models/craphead_scripts/the_cocaine_factory/utility/soda.mdl",
    ent = "cocaine_baking_soda",
    cmd = "/cocaine_soda",
    max = 1,
    vip = false,
    price = 1000,
    allowed = {TEAM_COCS},
    inventory = false,
})

rp.AddEntity('Мануальная плита',{
	category = "Приготовление коки",
    model = "models/craphead_scripts/the_cocaine_factory/utility/stove_upgrade.mdl",
    ent = "cocaine_cooking_plate",
    cmd = "/cocaine_plita",
    max = 8,
    vip = false,
    price = 1500,
    allowed = {TEAM_COCS},
    inventory = false,
})

rp.AddEntity('Батарея',{
	category = "Приготовление коки",
    model = "models/craphead_scripts/the_cocaine_factory/utility/battery.mdl",
    ent = "cocaine_battery",
    cmd = "/cocaine_batareya",
    max = 4,
    vip = false,
    price = 500,
    allowed = {TEAM_COCS},
    Inventory = false,
})
    
rp.AddEntity('Кастрюлька',{
	category = "Приготовление коки",
    model = "models/craphead_scripts/the_cocaine_factory/utility/pot.mdl",
    ent = "cocaine_cooking_pot",
    cmd = "/cocaine_pot",
    max = 8,
    vip = false,
    price = 1500,
    allowed = {TEAM_COCS},
    Inventory = false,
})

rp.AddEntity('Сушилка',{
	category = "Приготовление коки",
    model = "models/craphead_scripts/the_cocaine_factory/drying_rack/drying_rack.mdl",
    ent = "cocaine_drying_rack",
    cmd = "/cocaine_rack",
    max = 2,
    vip = false,
    price = 2000,
    allowed = {TEAM_COCS},
    inventory = false,
})

rp.AddEntity('Газ',{
	category = "Приготовление коки",
    model = "models/craphead_scripts/the_cocaine_factory/utility/gas_tank.mdl",
    ent = "cocaine_gas",
    cmd = "/cocaine_gas",
    max = 4,
    vip = false,
    price = 1000,
    allowed = {TEAM_COCS},
    inventory = false,
})

rp.AddEntity('Листья коки',{
	category = "Приготовление коки",
    model = "models/craphead_scripts/the_cocaine_factory/utility/leaves.mdl",
    ent = "cocaine_leaves",
    cmd = "/cocaine_leaves",
    max = 1,
    vip = false,
    price = 1000,
    allowed = {TEAM_COCS},
    Inventory = false,
})

rp.AddEntity('Газовая плита',{
	category = "Приготовление коки",
    model = "models/craphead_scripts/the_cocaine_factory/stove/gas_stove.mdl",
    ent = "cocaine_stove",
    cmd = "/cocaine_stove",
    max = 2,
    vip = false,
    price = 2000,
    allowed = {TEAM_COCS},
    Inventory = false,
})

rp.AddEntity('Вода',{
	category = "Приготовление коки",
    model = "models/craphead_scripts/the_cocaine_factory/utility/water.mdl",
    ent = "cocaine_water",
    cmd = "/cocaine_water",
    max = 1,
    vip = false,
    price = 500,
    allowed = {TEAM_COCS},
    Inventory = false,
})

rp.AddEntity("Банка", {
	category = "Варка метамфетамина",
	ent = "eml_jar",
	model = "models/props_lab/jar01a.mdl",
	price = 300,
	max = 5,
	cmd = "/eml_jar",
	allowed = {TEAM_METAVAR},
	Inventory = true,    
    Desc = "",
})

rp.AddEntity("Газ", {
	category = "Варка метамфетамина",
	ent = "eml_gas",
	Desc = [[Для варки Мета]],
	model = "models/props_c17/canister01a.mdl",
	price = 500,
	max = 5,
	cmd = "/eml_gas",
	allowed = {TEAM_METAVAR},
	Inventory = true,    
    Desc = "",
})

rp.AddEntity("Плита", {
	category = "Варка метамфетамина",
	ent = "eml_stove",
	Desc = [[Для варки Мета]],
	model = "models/props_c17/furnitureStove001a.mdl",
	price = 1500,
	max = 2,
	cmd = "/eml_stove",
	allowed = {TEAM_METAVAR},
	Inventory = true,    
    Desc = "",
})

rp.AddEntity("Жидкая сера", {
	category = "Варка метамфетамина",
	ent = "eml_sulfur",
	Desc = [[Для варки Мета]],
	model = "models/props_lab/jar01a.mdl",
	price = 300,
	max = 5,
	cmd = "/eml_sulfur",
	allowed = {TEAM_METAVAR},
	Inventory = true,    
    Desc = "",
})

rp.AddEntity("Жидкий Йод", {
	category = "Варка метамфетамина",
	ent = "eml_iodine",
	Desc = [[Для варки Мета]],
	model = "models/props_lab/jar01a.mdl",
	price = 550,
	max = 5,
	cmd = "/eml_iodine",
	allowed = {TEAM_METAVAR},
	Inventory = true,    
    Desc = "",
})

rp.AddEntity("Соляная Кислота", {
	category = "Варка метамфетамина",
	ent = "eml_macid",
	Desc = [[Для варки Мета]],
	model = "models/props_lab/jar01a.mdl",
	price = 450,
	max = 5,
	cmd = "/eml_macid",
	allowed = {TEAM_METAVAR},
	Inventory = true,    
    Desc = "",
})

rp.AddEntity("Вода", {
    category = "Варка метамфетамина",
	ent = "eml_water",
	Desc = [[Для варки Мета]],
	model = "models/props_junk/garbage_plasticbottle003a.mdl",
	price = 450,
	max = 5,
	cmd = "/eml_water",
	allowed = {TEAM_METAVAR},
	inventory = true,    
    Desc = "",
})

rp.AddEntity("Кастрюля", {
	category = "Варка метамфетамина",
	ent = "eml_pot",
	model = "models/props_c17/metalPot001a.mdl",
	price = 450,
	max = 4,
	cmd = "/eml_pot",
	allowed = {TEAM_METAVAR},
	inventory = true,    
    Desc = "",
})

rp.AddEntity("Специальная Кастрюля", {
	category = "Варка метамфетамина",
	ent = "eml_spot",
	model = "models/props_c17/metalPot001a.mdl",
	price = 450,
	max = 4,
	cmd = "/eml_spot",
	allowed = {TEAM_METAVAR},
	inventory = true,    
})

rp.AddEntity('Металлодетектор', {
	category = "Варка метамфетамина",
	ent = 'metal_detector',
	model = 'models/props_wasteland/interior_fence002e.mdl',
	price = 7500,
	max = 1,
	cmd = '/buymetal',
	pocket = false
})

-- Hobo
rp.AddEntity('Коробка для пожертвования', {
	ent = 'donation_box', 
	model = 'models/props/CS_militia/footlocker01_open.mdl', 
	price = 500, 
	max = 1, 
	cmd = '/buybox',
	allowed = {TEAM_HOBO, TEAM_HOBOKING},
	pocket = false
})

-- DJ
-- rp.AddEntity('Радио', {
-- 	ent = 'media_radio',
-- 	model = 'models/props_lab/citizenradio.mdl',
-- 	price = 1500,
-- 	max = 1,
-- 	cmd = '/buyradio',
-- 	allowed = TEAM_DJ,
-- 	pocket = false
-- })

-- rp.AddEntity("Телевизор", {
-- 	ent = "media_tv",
-- 	model = "models/props/cs_office/TV_plasma.mdl",
-- 	price = 1000,
-- 	max = 1,
-- 	cmd = "/buytv",
-- 	allowed = {TEAM_CINEMAOWNER},
-- 	pocket = false,
-- })

-- Notes
rp.AddEntity('Записка', {
	ent = 'ent_note',
	model = 'models/props_c17/paper01.mdl',
	price = 500,
	max = 1,
	cmd = '/note',
	pocket = false,
	onSpawn = function(ent, pl)
		if (IsValid(pl.LastNote)) then
			pl.LastNote:Remove()
		end	
		pl.LastNote = ent
		rp.Notify(pl, NOTIFY_SUCCESS, term.Get('USENote'))
	end
})

-- Mayor
rp.AddShipment('Лицензия','models/props_lab/clipboard.mdl', 'ent_licence', 3000, 10, true, 500, false, {TEAM_MAYOR})

-- Gun Dealer
rp.AddWeapon('AWP', 'models/weapons/3_snip_awp.mdl', 'swb_awp', 95000, {TEAM_GUN})
rp.AddWeapon('AK47', 'models/weapons/3_rif_ak47.mdl', 'swb_ak47', 33000, {TEAM_GUN})
rp.AddWeapon('Desert Eagle', 'models/weapons/3_pist_deagle.mdl', 'swb_deagle', 14000, {TEAM_GUN})
rp.AddWeapon('Famas', 'models/weapons/3_rif_famas.mdl', 'swb_famas', 31250, {TEAM_GUN})
rp.AddWeapon('Fiveseven', 'models/weapons/3_pist_fiveseven.mdl', 'swb_fiveseven', 8500, {TEAM_GUN})
rp.AddWeapon('P90', 'models/weapons/3_smg_p90.mdl', 'swb_p90', 21000, {TEAM_GUN})
rp.AddWeapon('Glock', 'models/weapons/3_pist_glock18.mdl', 'swb_glock18', 9500, {TEAM_GUN})
rp.AddWeapon('G3SG1', 'models/weapons/3_snip_g3sg1.mdl', 'swb_g3sg1', 73500, {TEAM_GUN})
rp.AddWeapon('MP5', 'models/weapons/3_smg_mp5.mdl', 'swb_mp5', 21500, {TEAM_GUN})
rp.AddWeapon('UMP45', 'models/weapons/3_smg_ump45.mdl', 'swb_ump', 21000, {TEAM_GUN})
rp.AddWeapon('Galil', 'models/weapons/3_rif_galil.mdl', 'swb_galil', 32000, {TEAM_GUN})
rp.AddWeapon('Mac10', 'models/weapons/3_smg_mac10.mdl', 'swb_mac10', 20500, {TEAM_GUN})
rp.AddWeapon('M249', 'models/weapons/3_mach_m249para.mdl', 'swb_m249', 100000, {TEAM_GUN})
rp.AddWeapon('M3 Super 90', 'models/weapons/3_shot_m3super90.mdl', 'swb_m3super90', 32000, {TEAM_GUN})
rp.AddWeapon('P228', 'models/weapons/3_pist_p228.mdl', 'swb_p228', 7500, {TEAM_GUN})
rp.AddWeapon('SG550', 'models/weapons/3_snip_sg550.mdl', 'swb_sg550', 82500, {TEAM_GUN})
rp.AddWeapon('SG552', 'models/weapons/3_rif_sg552.mdl', 'swb_sg552', 51500, {TEAM_GUN})
rp.AddWeapon('AUG', 'models/weapons/3_rif_aug.mdl', 'swb_aug', 43000, {TEAM_GUN})
rp.AddWeapon('Scout', 'models/weapons/3_snip_scout.mdl', 'swb_scout', 50000, {TEAM_GUN})
rp.AddWeapon('TMP', 'models/weapons/3_smg_tmp.mdl', 'swb_tmp', 21500, {TEAM_GUN})
rp.AddWeapon('XM1014', 'models/weapons/3_shot_xm1014.mdl', 'swb_xm1014', 43000, {TEAM_GUN})
rp.AddWeapon('M4A1', 'models/weapons/3_rif_m4a1.mdl', 'swb_m4a1', 33500, {TEAM_GUN})
rp.AddWeapon('USP', 'models/weapons/3_pist_usp.mdl', 'swb_usp', 8000, {TEAM_GUN})
rp.AddWeapon('357', 'models/weapons/w_357.mdl', 'swb_357', 15000, {TEAM_GUN})

-- Black Market Dealer
rp.AddShipment('C4','models/weapons/2_c4_planted.mdl', 'weapon_c4', 250000, 10, false, 35000, false, {TEAM_BMIDEALER})
rp.AddShipment('Взломщик кейпада','models/weapons/w_c4.mdl', 'keypad_cracker', 16000, 10, false, 1050, false, {TEAM_BMIDEALER})
rp.AddShipment('Отмычка','models/weapons/w_crowbar.mdl', 'lockpick', 14000, 10, false, 950, false, {TEAM_BMIDEALER})
rp.AddShipment('Броня','models/props_junk/cardboard_box004a.mdl', 'armor_piece_full', 7500, 10, false, 900, false, {TEAM_BMIDEALER})
rp.AddShipment('Crowbar','models/weapons/w_crowbar.mdl', 'weapon_crowbar', 5500, 10, false, 700, false, {TEAM_BMIDEALER})
rp.AddShipment('Демократизатор','models/weapons/w_stunbaton.mdl', 'stun_baton', 5000, 10, false, 650, false, {TEAM_BMIDEALER})
rp.AddShipment('Разарестовать','models/weapons/w_stunbaton.mdl', 'unarrest_baton', 6500, 10, false, 800, false, {TEAM_BMIDEALER})
rp.AddShipment('Нож','models/weapons/w_knife_t.mdl', 'swb_knife', 5000, 10, false, 675, false, {TEAM_BMIDEALER})
rp.AddShipment('Поддельная лицензия','models/props_lab/clipboard.mdl', 'ent_licence', 9500, 10, false, 1250, false, {TEAM_BMIDEALER})
    
-- Bartender and Doctor
rp.AddShipment('Пиво', 'models/drug_mod/alcohol_can.mdl', 'durgz_beer', 200, 10, false, 0, false, {TEAM_BARTENDER})
rp.AddShipment('Содовая', 'models/props_junk/PopCan01a.mdl', 'drugz_soda', 400, 10, false, 0, false, {TEAM_BARTENDER})
rp.AddShipment('Кофе', 'models/props_junk/garbage_coffeemug001a.mdl', 'drugz_coffee', 500, 10, false, 0, false, {TEAM_BARTENDER})
rp.AddShipment('Вода', 'models/drug_mod/the_bottle_of_water.mdl', 'durgz_water', 350, 10, false, 0, false, {TEAM_BARTENDER, TEAM_DOCTOR})
rp.AddShipment('Молоко', 'models/props_junk/garbage_milkcarton001a.mdl', 'drugz_milk', 750, 10, false, 0, false, {TEAM_BARTENDER, TEAM_DOCTOR})
rp.AddShipment('Аспирин', 'models/jaanus/aspbtl.mdl', 'durgz_aspirin', 500, 10, false, 0, false, {TEAM_DOCTOR})

-- Drug Dealer
rp.AddDrug('Трава', 'durgz_weed', 'models/katharsmodels/contraband/zak_wiet/zak_wiet.mdl', 300, TEAM_DRUGDEALER)
rp.AddDrug('Сигареты', 'durgz_cigarette', 'models/boxopencigshib.mdl', 200, TEAM_DRUGDEALER)
rp.AddDrug('Героин', 'durgz_heroine', 'models/katharsmodels/syringe_out/syringe_out.mdl', 1500, TEAM_DRUGDEALER)
rp.AddDrug('ЛСД', 'durgz_lsd', 'models/smile/smile.mdl', 350, TEAM_DRUGDEALER)
rp.AddDrug('Грибы', 'durgz_mushroom', 'models/ipha/mushroom_small.mdl', 525, TEAM_DRUGDEALER)
rp.AddDrug('Кокаин', 'durgz_cocaine', 'models/cocn.mdl', 700, TEAM_DRUGDEALER)
rp.AddDrug('Мет', 'durgz_meth', 'models/cocn.mdl', 600, TEAM_DRUGDEALER)
rp.AddDrug('Соль', 'durgz_bathsalts', 'models/props_lab/jar01a.mdl', 900, TEAM_DRUGDEALER)
rp.AddDrug('Отбеливатель', 'drugz_bleach', 'models/props_junk/garbage_plasticbottle001a.mdl', 300, TEAM_DRUGDEALER)

rp.AddEntity('Горшок', {
	ent = 'weed_plant',
	model = 'models/alakran/marijuana/pot_empty.mdl',
	price = 250,
	max = 2,
	cmd = '/buypot',
	allowed = {TEAM_DRUGMAKER},
	pocket = false
})

rp.AddEntity('Семя', {
	ent = 'seed_weed',
	model = 'models/Items/AR2_Grenade.mdl',
	price = 40,
	max = 2,
	cmd = '/buyseed',
	allowed = {TEAM_DRUGMAKER}
})

rp.AddEntity('Микроволновка', {
	ent = 'microwave',
	model = 'models/props/cs_office/microwave.mdl',
	price = 500,
	max = 1,
	cmd = '/buymicrowave',
	allowed = {TEAM_COOK},
	pocket = false
})

hook.Call('rp.AddEntities', GAMEMODE)

-- Cook
rp.AddFoodItem('Чизбургер', 'models/food/burger.mdl', 25, 50)
rp.AddFoodItem('Хот-дог', 'models/food/hotdog.mdl', 35, 75)
rp.AddFoodItem('Арбуз', 'models/props_junk/watermelon01.mdl', 10, 20)
rp.AddFoodItem('Апельсин', 'models/props/cs_italy/orange.mdl', 35, 35)
rp.AddFoodItem('Фастфуд', 'models/props_junk/garbage_bag001a.mdl', 50, 60)

-- Ammo
rp.AddAmmoType('Pistol', 'Патроны для пистолета', 'models/Items/BoxSRounds.mdl', 50, 25)
rp.AddAmmoType('Buckshot', 'Картечь для дробовика', 'models/Items/BoxBuckshot.mdl', 75, 15)
rp.AddAmmoType('smg1', 'СМГ Патроны', 'models/Items/BoxSRounds.mdl', 85, 45)
rp.AddAmmoType('Rifle', 'Крупнокалиберные патроны', 'models/Items/BoxSRounds.mdl', 120, 60)

-- Copshop
rp.AddCopItem('Коробка патронов', {
	Price = 150,
	Model = 'models/Items/BoxSRounds.mdl',
	Callback = function(pl)
		for k, v in ipairs(rp.ammoTypes) do
			pl:GiveAmmo(120, v.ammoType, true)
		end
	end
})

rp.AddCopItem('Здоровье', {
	Price = 50,
	Model = 'models/Items/HealthKit.mdl',
	Callback = function(pl)
		pl:SetHealth(100)
	end
})

rp.AddCopItem('Броня', {
	Price = 100,
	Model = 'models/props_junk/cardboard_box004a.mdl',
	Callback = function(pl)
		pl:SetArmor(100)
	end
})