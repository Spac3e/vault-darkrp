if SERVER then  
    AddCSLuaFile()
    AddCSLuaFile("uc2_subconfig.lua")
end
include("uc2_subconfig.lua")

BUC2.GivePermaWeaponsOnSpawn = true
BUC2.AnnounceUnboxings = true
BUC2.CanTradePermaWeapons = false
BUC2.BuyItemsWithPoints = false
BUC2.BuyItemsWithPoints2 = false
BUC2.RanksThatCanGiveItems = {
	"root",
}
BUC2.ShouldDropCratesAndKeys = false
BUC2.DropTimer = 25
BUC2.DropsAreRankLimited = true
BUC2.DropRankList = {
	"donator1",
	"donator2",
	"admins",
	"superadmin",
	"mod",
	"vip"
}

bu_addCrate(1,"Кейс привилегий" , "У вас есть шанс выбить админку!" , Color(255, 215, 0, 255) , true , true ,  69)
bu_addCrate(2,"Кейс Оруженый" , "Донатые оружие от 200₽ до 5к₽." , Color(255, 125, 55, 255) , true , true ,  85)
bu_addCrate(3,"Кейс SF-Stars" , "Именной кейс!" , Color(155, 125, 55, 255) , true , true ,  59)
bu_addCrate(4,"Кейс 'Всё или ничего'" , "Шанс выбить овнерку!" , Color(255, 55, 55, 255) , true , true ,  449)
bu_addCrate(5,"Кейс 'Money rain'" , "Шанс стать миллионером!" , Color(52, 73, 40, 255) , true , true ,  89)
 
bu_addMoney(6,"VIP+ 30d" , "" , "vip30d" , Color(255,218,131) , "Кейс привилегий", 600)
bu_addMoney(7,"VIP+" , "" , "vip" , Color(255,218,131) , "Кейс привилегий", 200)
bu_addMoney(8,"Модератор 30d" , "" , "dmod30d" , Color(99,180,174) , "Кейс привилегий", 40)
bu_addMoney(9,"Модератор" , "" , "dmod" , Color(99,180,174) , "Кейс привилегий", 30)
bu_addMoney(10,"Админ 30d" , "" , "adm30d" , Color(240,140,120) , "Кейс привилегий", 20)
bu_addMoney(11,"Админ" , "" , "adm" , Color(240,140,120) , "Кейс привилегий", 15)
bu_addMoney(12,"Суперaдмин 30d" , "" , "sadm30d" , Color(255,15,15) , "Кейс привилегий", 10)
bu_addMoney(13,"Суперадмин" , "" , "sadm" , Color(255,15,15) , "Кейс привилегий", 5)

bu_addWeapon(14,"Аптечка", "", "weapon_medkitt" , "models/weapons/w_medkit.mdl", Color(55,55,255) , "Кейс Оруженый" , 5 , false)
bu_addWeapon(15,"P08 Luger", "", "wep_m9k_luger" , "models/weapons/w_luger_p08.mdl", Color(55,55,255) , "Кейс Оруженый" , 300 , false)
bu_addWeapon(16,"Glock 18", "", "wep_m9k_glock" , "models/weapons/w_dmg_glock.mdl", Color(55,55,255) , "Кейс Оруженый" , 350 , false)
bu_addWeapon(17,"Desert Eagle", "", "wep_m9k_deagle" , "models/weapons/w_tcom_deagle.mdl", Color(55,55,255) , "Кейс Оруженый" , 100 , false)
bu_addWeapon(18,"AAC Honey Badger", "", "wep_m9k_honeybadger" , "models/weapons/w_aac_honeybadger.mdl", Color(160,25,160) , "Кейс Оруженый" , 70 , false)
bu_addWeapon(19,"AWP", "", "wep_swb_awp" , "models/weapons/w_snip_awp.mdl", Color(160,25,160) , "Кейс Оруженый" , 50 , false)
bu_addWeapon(20,"M249", "", "wep_swb_m249" , "models/weapons/w_mach_m249para.mdl", Color(160,25,160) , "Кейс Оруженый" , 50 , false)
bu_addWeapon(21,"Double Barrel Shotgun", "", "wep_m9k_dbarrel" , "models/weapons/w_double_barrel_shotgun.mdl", Color(160,25,160) , "Кейс Оруженый" , 40 , false)
bu_addWeapon(22,"USAS", "", "wep_m9k_usas" , "models/weapons/w_usas_12.mdl", Color(160,25,160) , "Кейс Оруженый" , 40 , false)
bu_addWeapon(23,"Barret M98B", "", "wep_m9k_m98b" , "models/weapons/w_barrett_m98b.mdl", Color(160,25,160) , "Кейс Оруженый" , 40 , false)
bu_addWeapon(24,"Spas-12", "", "spas12blyat" , "models/weapons/w_spas_12.mdl", Color(255,55,55) , "Кейс Оруженый" , 40 , false)
bu_addWeapon(25,"AK-47 | Золотая коллекция", "", "AK-47g" , "models/weapons/w_rif_ak47_gold.mdl", Color(255,55,55) , "Кейс Оруженый" , 30 , false)
bu_addWeapon(26,"Minigun", "", "minigunn" , "models/weapons/w_m134_minigun.mdl", Color(255,55,55) , "Кейс Оруженый" , 25 , false)
bu_addWeapon(27,"Граната", "", "weapon_fragg" , "models/Items/grenadeAmmo.mdl", Color(255,55,55) , "Кейс Оруженый" , 30 , false)
bu_addWeapon(28,"Мина", "", "weapon_slamm" , "models/weapons/w_slam.mdl", Color(255,55,55) , "Кейс Оруженый" , 30 , false)

bu_addWeapon(29,"Камера", "", "wep_kamera" , "models/maxofs2d/camera.mdl", Color(55,55,255), "Кейс 'Всё или ничего'", 490, false)
bu_addMoney(30,"OWNER Навсегда" , "" , "owner_navsegda" , Color(255,55,55) , "Кейс 'Всё или ничего'", 50)

bu_addMoney(31,"$100,000" , "" , "100k_deneg" , Color(55,55,255) , "Кейс 'Money rain'", 600)
bu_addMoney(32,"$500,000" , "" , "500k_deneg" , Color(55,55,255) , "Кейс 'Money rain'", 400)
bu_addMoney(33,"$700,000" , "" , "700k_deneg" , Color(160,25,160) , "Кейс 'Money rain'", 100)
bu_addMoney(34,"$1,000,000" , "" , "1000k_deneg" , Color(160,25,160) , "Кейс 'Money rain'", 50)
bu_addMoney(35,"$4,500,000" , "" , "45000k_deneg" , Color(255,55,55) , "Кейс 'Money rain'", 25)

bu_addWeapon(36,"Камера", "", "wep_kamera" , "models/maxofs2d/camera.mdl", Color(55,55,255) , "Кейс SF-Stars" , 400 , false)
bu_addWeapon(37,"Аптечка", "", "weapon_medkitt" , "models/weapons/w_medkit.mdl", Color(55,55,255) , "Кейс SF-Stars" , 20 , false)
bu_addWeapon(38,"Монтировка", "", "wep_crowbar" , "models/weapons/w_crowbar.mdl", Color(55,55,255) , "Кейс SF-Stars" , 310 , false)
bu_addWeapon(39,"Нож", "", "wep_swb_knife" , "models/weapons/w_knife_ct.mdl", Color(55,55,255) , "Кейс SF-Stars" , 500 , false)
bu_addWeapon(40,"Отмычка", "", "wep_lockpro" , "models/weapons/w_crowbar.mdl", Color(55,55,255) , "Кейс SF-Stars" , 310 , false)
bu_addWeapon(41,"SIG Sauer P229R", "", "wep_m9k_sig_p229r" , "models/weapons/w_sig_229r.mdl", Color(160,25,160) , "Кейс SF-Stars" , 50 , false)
bu_addWeapon(42,"Raging Bull", "", "wep_m9k_scoped_taurus" , "models/weapons/w_taurus_raging_bull.mdl", Color(160,25,160) , "Кейс SF-Stars" , 50 , false)
bu_addWeapon(43,"Tommy Gun", "", "wep_m9k_thompson" , "models/weapons/w_tommy_gun.mdl", Color(160,25,160) , "Кейс SF-Stars" , 50 , false)
bu_addWeapon(44,"Паркур", "", "climb_swepp" , "models/weapons/w_knife_ct.mdl", Color(160,25,160) , "Кейс SF-Stars" , 20 , false)
bu_addWeapon(45,"AK-74", "", "wep_m9k_ak74" , "models/weapons/w_tct_ak47.mdl", Color(160,25,160) , "Кейс SF-Stars" , 20 , false)
bu_addWeapon(46,"HK 416", "", "wep_m9k_m416" , "models/weapons/w_hk_416.mdl", Color(160,25,160) , "Кейс SF-Stars" , 20 , false)
bu_addWeapon(47,"73 Winchester Carbine", "", "wep_m9k_winchester73" , "models/weapons/w_winchester_1873.mdl", Color(160,25,160) , "Кейс SF-Stars" , 20 , false)
bu_addWeapon(48,"F2000", "", "wep_m9k_f2000" , "models/weapons/w_fn_f2000.mdl", Color(160,25,160) , "Кейс SF-Stars" , 20 , false)
bu_addWeapon(49,"Double Barrel Shotgun", "", "wep_m9k_dbarrel" , "models/weapons/w_double_barrel_shotgun.mdl", Color(255,55,55) , "Кейс SF-Stars" , 20 , false)
bu_addWeapon(50,"USAS", "", "wep_m9k_usas" , "models/weapons/w_usas_12.mdl", Color(255,55,55) , "Кейс SF-Stars" , 20 , false)
bu_addWeapon(51,"Barret M82", "", "wep_m9k_barret_m82" , "models/weapons/w_barret_m82.mdl", Color(255,55,55) , "Кейс SF-Stars" , 15 , false)
bu_addWeapon(52,"AK-47 | Золотая коллекция", "", "AK-47g" , "models/weapons/w_rif_ak47_gold.mdl", Color(255,55,55) , "Кейс SF-Stars" , 5, false)

bu_addCrate(53,"Кейс Rande" , "Именной кейс!" , Color(155, 125, 55, 255) , true , true , 59)
bu_addWeapon(54,"Нож", "", "wep_swb_knife" , "models/weapons/w_knife_ct.mdl", Color(55,55,255) , "Кейс Rande" , 400 , false)
bu_addWeapon(55,"Glock 18", "", "wep_m9k_glock" , "models/weapons/w_dmg_glock.mdl", Color(55,55,255) , "Кейс Rande" , 220 , false)
bu_addWeapon(56,"Монтировка", "", "wep_crowbar" , "models/weapons/w_crowbar.mdl", Color(55,55,255) , "Кейс Rande" , 210 , false)
bu_addWeapon(57,"P08 Luger", "", "wep_m9k_luger" , "models/weapons/w_luger_p08.mdl", Color(55,55,255) , "Кейс Rande" , 600 , false)
bu_addWeapon(58,"Desert Eagle", "", "wep_m9k_deagle" , "models/weapons/w_tcom_deagle.mdl", Color(55,55,255) , "Кейс Rande" , 80 , false)
bu_addWeapon(59,"Raging Bull", "", "wep_m9k_scoped_taurus" , "models/weapons/w_taurus_raging_bull.mdl", Color(55,55,255) , "Кейс Rande" , 80 , false)
bu_addWeapon(60,"MP40", "", "wep_m9k_mp40" , "models/weapons/w_mp40smg.mdl", Color(160,25,160) , "Кейс Rande" , 80 , false)
bu_addWeapon(61,"AAC Honey Badger", "", "wep_m9k_honeybadger" , "models/weapons/w_aac_honeybadger.mdl", Color(160,25,160) , "Кейс Rande" , 80 , false)
bu_addWeapon(62,"KRISS Vector", "", "wep_m9k_vector" , "models/weapons/w_kriss_vector.mdl", Color(160,25,160) , "Кейс Rande" , 80 , false)
bu_addWeapon(63,"Двойной прыжок", "", "multijump_donate" , "models/xqm/afterburner1.mdl", Color(255,55,55) , "Кейс Rande" , 20 , false)
bu_addWeapon(64,"Double Barrel Shotgun", "", "wep_m9k_dbarrel" , "models/weapons/w_double_barrel_shotgun.mdl", Color(255,55,55) , "Кейс Rande" , 15 , false)
bu_addWeapon(65,"Minigun", "", "minigunn" , "models/weapons/w_m134_minigun.mdl", Color(255,55,55) , "Кейс Rande" , 5 , false)

bu_addCrate(66,"Кейс Ковбойка" , "Шанс выбить ковбойку!" , Color(245, 196, 0, 255) , true , true , 119)
bu_addWeapon(67,"P08 Luger", "", "wep_m9k_luger" , "models/weapons/w_luger_p08.mdl", Color(55,55,255) , "Кейс Ковбойка" , 750 , false)
--bu_addWeapon(68,"Double Barrel Shotgun", "", "wep_m9k_dbarrel" , "models/weapons/w_double_barrel_shotgun.mdl", Color(255,55,55) , "Кейс Ковбойка" , 50 , false)
bu_addWeapon(69,"Ковбойка", "", "wep_swb_357_a" , "models/weapons/w_357.mdl", Color(245, 196, 0) , "Кейс Ковбойка" , 5 , false)

bu_addCrate(70,"Кейс Новогодний" , "Сезонный кейс!" , Color(220, 220, 220, 255) , true , true , 199)
bu_addWeapon(71,"Камера", "", "wep_kamera" , "models/maxofs2d/camera.mdl", Color(55,55,255) , "Кейс Новогодний" , 300 , false)
bu_addWeapon(72,"SIG Sauer P229R", "", "wep_m9k_sig_p229r" , "models/weapons/w_sig_229r.mdl", Color(55,55,255) , "Кейс Новогодний" , 200 , false)
bu_addWeapon(73,"Аптечка", "", "weapon_medkitt" , "models/weapons/w_medkit.mdl", Color(55,55,255) , "Кейс Новогодний" , 50 , false)
bu_addWeapon(74,"M16A4 ACOG", "", "wep_m9k_m16a4_acog" , "models/weapons/w_dmg_m16ag.mdl", Color(160,25,160) , "Кейс Новогодний" , 75 , false)
bu_addWeapon(75,"AS VAL", "", "wep_m9k_val" , "models/weapons/w_dmg_vally.mdl", Color(160,25,160) , "Кейс Новогодний" , 76 , false)
bu_addWeapon(76,"F2000", "", "wep_m9k_f2000" , "models/weapons/w_fn_f2000.mdl", Color(160,25,160) , "Кейс Новогодний" , 77 , false)
bu_addWeapon(77,"Double Barrel Shotgun", "", "wep_m9k_dbarrel" , "models/weapons/w_double_barrel_shotgun.mdl", Color(255,55,55) , "Кейс Новогодний" , 15 , false)
bu_addWeapon(78,"Мина", "", "weapon_slamm" , "models/weapons/w_slam.mdl", Color(255,55,55) , "Кейс Новогодний" , 15 , false)
bu_addWeapon(79,"AK-47 | Золотая коллекция", "", "AK-47g" , "models/weapons/w_rif_ak47_gold.mdl", Color(255,55,55) , "Кейс Новогодний" , 15, false)
bu_addWeapon(80,"Spas-12", "", "spas12blyat" , "models/weapons/w_spas_12.mdl", Color(255,55,55) , "Кейс Новогодний" , 15 , false)
bu_addMoney(81,"Суперадмин 30d" , "" , "superadmin_na_mesyac" , Color(245, 196, 0) , "Кейс Новогодний", 15)
bu_addMoney(82,"Овнер 30d" , "" , "owner_mesyac" , Color(245, 196, 0) , "Кейс Новогодний", 10)

bu_addCrate(83,"Кейс Cyberpunk 2077" , "В честь выхода игры!" , Color(122, 4, 235, 255) , true , true , 249)
bu_addWeapon(84,"Камера", "", "wep_kamera" , "models/maxofs2d/camera.mdl", Color(55,55,255) , "Кейс Cyberpunk 2077" , 300, false)
bu_addWeapon(85,"Аптечка", "", "weapon_medkitt" , "models/weapons/w_medkit.mdl", Color(55,55,255) , "Кейс Cyberpunk 2077" , 120 , false)
bu_addWeapon(86,"Мина", "", "weapon_slamm" , "models/weapons/w_slam.mdl", Color(255,55,55) , "Кейс Cyberpunk 2077" , 60 , false)
bu_addWeapon(87,"SIG Sauer P229R", "", "wep_m9k_sig_p229r" , "models/weapons/w_sig_229r.mdl", Color(55,55,255) , "Кейс Cyberpunk 2077" , 200 , false)
bu_addWeapon(88,"S&W Model 500", "", "wep_m9k_model500" , "models/weapons/w_sw_model_500.mdl", Color(55,55,255) , "Кейс Cyberpunk 2077" , 200 , false)
bu_addWeapon(89,"KRISS Vector", "", "wep_m9k_vector" , "models/weapons/w_kriss_vector.mdl", Color(160,25,160) , "Кейс Cyberpunk 2077" , 110 , false)
bu_addWeapon(90,"AAC Honey Badger", "", "wep_m9k_honeybadger" , "models/weapons/w_aac_honeybadger.mdl", Color(160,25,160) , "Кейс Cyberpunk 2077" , 110 , false)
bu_addWeapon(91,"F2000", "", "wep_m9k_f2000" , "models/weapons/w_fn_f2000.mdl", Color(160,25,160) , "Кейс Cyberpunk 2077" , 100 , false)
bu_addWeapon(92,"Steyr AUG A3", "", "wep_m9k_auga3" , "models/weapons/w_auga3.mdl", Color(160,25,160) , "Кейс Cyberpunk 2077" , 100, false)
bu_addWeapon(93,"Barret M98B", "", "wep_m9k_m98b" , "models/weapons/w_barrett_m98b.mdl", Color(160,25,160) , "Кейс Cyberpunk 2077" , 20 , false)
bu_addWeapon(94,"Striker 12", "", "wep_m9k_striker12" , "models/weapons/w_striker_12g.mdl", Color(255,55,55) , "Кейс Cyberpunk 2077" , 20 , false)
bu_addWeapon(95,"Двойной прыжок", "", "multijump_donate" , "models/xqm/afterburner1.mdl", Color(255,55,55) , "Кейс Cyberpunk 2077" , 20 , false)
bu_addWeapon(96,"AK-47 | Золотая коллекция", "", "AK-47g" , "models/weapons/w_rif_ak47_gold.mdl", Color(255,55,55) , "Кейс Cyberpunk 2077" , 5, false)
bu_addWeapon(97,"Ковбойка", "", "wep_swb_357_a" , "models/weapons/w_357.mdl", Color(245, 196, 0) , "Кейс Cyberpunk 2077" , 1 , false)

bu_addMoney(98,"Овнер 30d" , "" , "owner_mesyac" , Color(245, 196, 0) , "Кейс привилегий", 3)
bu_addMoney(99,"Овнер" , "" , "owner_navsegda" , Color(245, 196, 0) , "Кейс привилегий", 1)

bu_addWeapon(100,"Ковбойка", "", "wep_swb_357_a" , "models/weapons/w_357.mdl", Color(245, 196, 0) , "Кейс 'Всё или ничего'" , 10, false)

print("[UNBOXING INFO] UNBOXING CONFIG LOADED!")