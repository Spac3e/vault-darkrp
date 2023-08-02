-- Misc
-- rp.shop.Add('+20 Pocket Space', 'pocket_space_2')
-- 	:SetCat('Основное')
-- 	:SetDesc('Increases your total pocket space by 20.\n This upgrade is stackable.')
-- 	:SetImage('004-clothing.png')
-- 	:SetPrice(300)
-- 	:SetNetworked(true)
-- 	:SetGetPrice(function(self, pl)
-- 		local cost = 0
-- 		if pl:HasUpgrade(self:GetUID()) then
-- 			cost = self.Price * (pl:GetUpgradeCount(self:GetUID()) * 0.5)
-- 		end
-- 		return self.Price + cost
-- 	end)

rp.shop.Add('Беск.Патр', 'perma_ammo')
	:SetCat('Основное')
	:SetDesc('Вы всегда будете спавниться с бесконечными патронами каждого типа.')
	:SetImage('bullets.png')
	:SetPrice(550)
	:SetStackable(false)
	:SetOnBuy(function(self, pl)
		pl:GiveAmmos(120, true)
	end)
	:AddHook('PlayerUpgradesLoaded', function(pl)
		pl:GiveAmmos(9999, true)
	end)
	:AddHook('PlayerLoadout', function(pl)
		pl:GiveAmmos(9999, true)
	end)

rp.shop.Add('Прем-Орга', 'org_prem')
	:SetCat('Основное')
	:SetDesc([[
		Это улучшит организацию, в которой вы находитесь.
		ДАЖЕ ЕСЛИ ВЫ НЕ ВЛАДЕЛЕЦ!
		
		- Разрешает доступ к баннерам организации
		- Организация никогда не будет переименована из-за бездействия
		- Поднимает максимальное количество участников с ]] .. rp.cfg.OrgMaxMembers.. [[ до ]] .. rp.cfg.OrgMaxMembersPremium .. [[
		- Повышает максимальное количество рангов с ]] .. rp.cfg.OrgMaxRanks.. [[ до ]] .. rp.cfg.OrgMaxRanksPremium .. [[
		- Организация никогда не будет переименована из-за бездействия
	]])
	:SetImage('org_banner.png')
	:SetPrice(350)
	:SetNetworked(true)
	:SetCanBuy(function(self, pl)
		local org = pl:GetOrgInstance()
		if (!org or org:IsUpgraded()) then
			return false, (org and (org.Name .. " уже улучшена.") or "Вы не состоите в организации!")
		end
		return true
	end)
	:SetOnBuy(function(self, pl)
		local org = pl:GetOrgInstance()
		if (org) then
			org:Upgrade()
		end
	end)
	:SetGetCustomPurchaseNote(function(self, pl)
		local org = pl:GetOrgInstance()
		if (org) then
			return org.ID .. '-' .. org.Name
		end
		return 'ОШИБКА'
	end)

rp.shop.Add('+15 К лимиту пропов', 'prop_limit_15')
	:SetCat('Основное')
	:SetDesc('Добавляет 15 дополнительных пропов к проп лимиту.\n Это улучшение можно покупать много раз.')
	:SetIcon('models/weapons/w_toolgun.mdl')
	:SetPrice(30)
	:SetNetworked(true)
	:SetGetPrice(function(self, pl)
		return ((pl:GetUpgradeCount('prop_limit_15') + 1) * self.Price)
	end)


hook('PlayerGetLimit', 'rp.upgrades.props.PlayerGetLimit', function(pl, name)
	local new = rp.GetLimit('props')
	if (name == 'props') then
		if pl:IsVIP() then
			new = new + 20
		end

		local upgradeCount = pl:GetUpgradeCount('prop_limit_15')
		if (upgradeCount ~= 0) then
			new = new + (15 * upgradeCount)
		end

		return new
	end
end)

local sayings = {
	'# это сексуальный зверь!',
	'# заплатил 100 рублей, чтобы выглядеть круто перед всеми',
	'# это любовь # это жизнь',
	'(° ͜ʖ ͡° # ͡(° ͜ʖ ͡°',
	'Все говорят: "#, какие они крутые"',
	'# крутой как огурец',
	'# потратил 100 руб, поэтому я, официант, должен сообщить вам, что они классные',
}
rp.shop.Add('Объявление', 'announcement')
	:SetCat('Основное')
	:SetDesc('Если вам скучно и у вас есть 25 рублей, вы можете купить это и сообщить всему серверу, какой вы крутой.')
	:SetImage('005-megaphone.png')
	:SetPrice(25)
	:SetOnBuy(function(self, pl)
		local msg = string.gsub(sayings[math.random(#sayings)], '#', pl:Name())
		RunConsoleCommand('ba', 'tellall', msg)
	end)

-- Cash Packs
rp.shop.Add('$10,000', '10k_RP_Cash')
	:SetCat('Наборы Денег')
	:SetDesc('Добавляет $10,000 на ваш аккаунт')
	:SetImage('money-1.png')
	:SetPrice(50)
	:SetOnBuy(function(self, pl)
		pl:AddMoney(10000)
	end)

rp.shop.Add('$50,000', '50k_RP_Cash')
	:SetCat('Наборы Денег')
	:SetDesc('Добавляет $50,000 на ваш аккаунт')
	:SetImage('money-2.png')
	:SetPrice(150)
	:SetOnBuy(function(self, pl)
		pl:AddMoney(50000)
	end)

rp.shop.Add('$100,000', '100k_RP_Cash')
	:SetCat('Наборы Денег')
	:SetDesc('Добавляет $100,000 на ваш аккаунт')
	:SetImage('money-3.png')
	:SetPrice(250)
	:SetOnBuy(function(self, pl)
		pl:AddMoney(100000)
	end)

rp.shop.Add('$250,000', '250k_RP_Cash')
	:SetCat('Наборы Денег')
	:SetDesc('Добавляет $250,000 на ваш аккаунт')
	:SetImage('money-4.png')
	:SetPrice(350)
	:SetOnBuy(function(self, pl)
		pl:AddMoney(250000)
	end)

rp.shop.Add('$750,000', '750k_RP_Cash')
	:SetCat('Наборы Денег')
	:SetDesc('Добавляет $750,000 на ваш аккаунт')
	:SetImage('profits.png')
	:SetPrice(499)
	:SetOnBuy(function(self, pl)
		pl:AddMoney(750000)
	end)


-- Karma Packs
rp.shop.Add('200 Кармы', '200_karma')
	:SetCat('Наборы Кармы')
	:SetDesc('Добавляет 200 кармы на ваш аккаунт')
	:SetImage('karma-1.png')
	:SetPrice(50)
	:SetOnBuy(function(self, pl)
		pl:AddKarma(200)
	end)

rp.shop.Add('750 Кармы', '750_karma')
	:SetCat('Наборы Кармы')
	:SetDesc('Добавляет 750 кармы на ваш аккаунт')
	:SetImage('karma-2.png')
	:SetPrice(150)
	:SetOnBuy(function(self, pl)
		pl:AddKarma(750)
	end)

rp.shop.Add('1,500 Кармы', '1500_karma')
	:SetCat('Наборы Кармы')
	:SetDesc('Добавляет 1,500 кармы на ваш аккаунт')
	:SetImage('karma-3.png')
	:SetPrice(250)
	:SetOnBuy(function(self, pl)
		pl:AddKarma(1500)
	end)

rp.shop.Add('3,000 Кармы', '3000_karma')
	:SetCat('Наборы Кармы')
	:SetDesc('Добавляет 3,000 кармы на ваш аккаунт')
	:SetImage('karma-4.png')
	:SetPrice(350)
	:SetOnBuy(function(self, pl)
		pl:AddKarma(3000)
	end)

rp.shop.Add('7,500 Кармы', '7500_karma')
	:SetCat('Наборы Кармы')
	:SetDesc('Добавляет 7,500 кармы на ваш аккаунт')
	:SetImage('karma-5.png')
	:SetPrice(499)
	:SetOnBuy(function(self, pl)
		pl:AddKarma(7500)
	end)

-- Ranks
local vipdesc = [[
		VIP-ранг на всех наших серверах DarkRP
		VIP-работы
		Значок VIP в табе
		Теги эмоций
		Эмоции чата
		20 дополнительных пропов
		3 дополнительных очка генома для полицейских
		Дубликатор Adv Dupe
		Precision инструмент
		Light инструмент
		
		И всё остальное, что будет добавлено для VIP-персон в будущем!
	]]

rp.shop.Add('VIP 30d', 'trial_vip')
	:SetCat('Ранги')
	:SetDesc(vipdesc)
	:SetImage('vip-30d.png')
	:SetPrice(50)
	:SetCanBuy(function(self, pl)
		if (pl:GetRank() == 'vip') or pl:IsAdmin() then
			return false, 'Вы уже VIP или выше!'
		end
		return true
	end)
	:SetOnBuy(function(self, pl)
		RunConsoleCommand('ba', 'setgroup', pl:SteamID(), 'vip', '30d', 'user')
	end)


rp.shop.Add('VIP', 'vip')
	:SetCat('Ранги')
	:SetDesc(vipdesc)
	:SetImage('vip-perma.png')
	:SetPrice(100)
	:SetCanBuy(function(self, pl)
		if (pl:GetRank() == 'vip') or pl:IsAdmin() then
			return false, 'Вы уже VIP или выше!'
		end
		return true
	end)
	:SetOnBuy(function(self, pl)
		RunConsoleCommand('ba', 'setgroup', pl:SteamID(), 'vip')
	end)


rp.shop.Add('Moderator 30d', 'trial_mod')
	:SetCat('Ранги')
	:SetDesc([[
		30 дней модерации на всех наших серверах DarkRP
		Все VIP-привилегии навсегда:
			VIP-работы
			Значок VIP в табе
			Теги эмоций
			Эмоции чата
			20 дополнительных пропов
			3 дополнительных очка генома для полицейских
			Дубликатор Adv Dupe
			Precision инструмент
			Light инструмент

			И всё остальное, что будет добавлено для VIP-персон в будущем
		
		Если вы уже являетесь модератором, это продлит ваше время.
		ВНИМАНИЕ: если вы злоупотребите этим рангом или станете неактивным, вы будете переведены в VIP без возмещения!
	]])
	:SetImage('mod-30d.png')
	:SetPrice(200)
	:SetCanBuy(function(self, pl)
		if pl:IsAdmin() and pl:GetRank() != 'dmoderator' then
			return false, 'Вы уже выше чем Moderator!'
		elseif (pl:GetPlayTime() < 36000) then
			return false, 'Вам нужно наиграть 10 часов, чтобы купить Модератора!'
		end
		return true
	end)
	:SetOnBuy(function(self, pl)
		local timeInSeconds = 30 * 86400
		local startTime = math.max((pl:GetRank() == 'dmoderator' and pl:GetBVar('expire_time') or os.time()), os.time())

		ba.data.SetRank(pl, 'dmoderator', 'vip', startTime + timeInSeconds)
	end)

rp.shop.Add('Moderator 60d', 'trial_mod_60d')
	:SetCat('Ранги')
	:SetDesc([[
		60 дней модерации на всех наших серверах DarkRP
		Все VIP-привилегии навсегда:
			VIP-работы
			Значок VIP в табе
			Теги эмоций
			Эмоции чата
			20 дополнительных пропов
			3 дополнительных очка генома для полицейских
			Дубликатор Adv Dupe
			Precision инструмент
			Light инструмент

			И всё остальное, что будет добавлено для VIP-персон в будущем
		
		Если вы уже являетесь модератором, это продлит ваше время.
		ВНИМАНИЕ: если вы злоупотребите этим рангом или станете неактивным, вы будете переведены в VIP без возмещения!
	]])
	:SetImage('mod-60d.png')
	:SetPrice(300)
	:SetCanBuy(function(self, pl)
		if pl:IsAdmin() and pl:GetRank() != 'dmoderator' then
			return false, 'Вы уже выше чем Moderator!'
		elseif (pl:GetPlayTime() < 36000) then
			return false, 'Вам нужно наиграть 10 часов, чтобы купить Модератора!'
		end
		return true
	end)
	:SetOnBuy(function(self, pl)
		local timeInSeconds = 60 * 86400
		local startTime = math.max((pl:GetRank() == 'dmoderator' and pl:GetBVar('expire_time') or os.time()), os.time())

		ba.data.SetRank(pl, 'dmoderator', 'vip', startTime + timeInSeconds)
	end)

	rp.shop.Add('Moderator', 'mod')
	:SetCat('Ранги')
	:SetDesc([[
		Модератор на всех наших серверах DarkRP
		Все VIP-привилегии навсегда:
			VIP-работы
			Значок VIP в табе
			Теги эмоций
			Эмоции чата
			20 дополнительных пропов
			3 дополнительных очка генома для полицейских
			Дубликатор Adv Dupe
			Precision инструмент
			Light инструмент

			И всё остальное, что будет добавлено для VIP-персон в будущем
		
		Если вы уже являетесь модератором, это продлит ваше время.
		ВНИМАНИЕ: если вы злоупотребите этим рангом или станете неактивным, вы будете переведены в VIP без возмещения!
	]])
	:SetImage('mod-60d.png')
	:SetPrice(350)
	:SetCanBuy(function(self, pl)
		if pl:IsAdmin() and pl:GetRank() != 'dmoderator' then
			return false, 'Вы уже выше чем Moderator!'
		elseif (pl:GetPlayTime() < 36000) then
			return false, 'Вам нужно наиграть 10 часов, чтобы купить Модератора!'
		end
		return true
	end)
	:SetOnBuy(function(self, pl)
		RunConsoleCommand('ba', 'setgroup', pl:SteamID(), 'dmoderator')
	end)


-- Events
rp.shop.Add('Parkour Event', 'event_parkour')
	:SetCat('Ивенты')
	:SetDesc('Everyone will be able to use the climb swep.\nLasts 30 minutes.')
	:SetImage('parkour.png')
	:SetPrice(300)
	:SetOnBuy(function(self, pl)
		RunConsoleCommand('ba', 'startevent', 'Parkour', '30mi')
	end)

rp.shop.Add('Vape Event', 'event_vape')
	:SetCat('Ивенты')
	:SetDesc('Everyone will spawn with a vape.\nLasts 30 minutes.')
	:SetIcon('models/swamponions/vape.mdl')
	:SetPrice(300)
	:SetOnBuy(function(self, pl)
		RunConsoleCommand('ba', 'startevent', 'Vape', '30mi')
	end)


rp.shop.Add('VIP Event', 'event_vip')
	:SetCat('Ивенты')
	:SetDesc('Everyone will be able to use VIP perks.\nLasts 30 minutes.')
	:SetImage('ticket.png')
	:SetPrice(350)
	:SetOnBuy(function(self, pl)
		RunConsoleCommand('ba', 'startevent', 'VIP', '30mi')
	end)

rp.shop.Add('Printer Event', 'event_printer')
	:SetCat('Ивенты')
	:SetDesc('Everyone\'s printers will print 50% more.\nLasts 30 minutes.')
	:SetIcon('models/sup/printer/printer.mdl')
	:SetPrice(450)
	:SetOnBuy(function(self, pl)
		RunConsoleCommand('ba', 'startevent', 'printer', '30mi')
	end)

rp.shop.Add('Crafting Event', 'event_crafting')
	:SetCat('Ивенты')
	:SetDesc('Everyone\'s labs will craft 25% faster.\nLasts 30 minutes.')
	:SetIcon('models/props/cs_italy/it_mkt_table3.mdl')
	:SetPrice(450)
	:SetOnBuy(function(self, pl)
		RunConsoleCommand('ba', 'startevent', 'crafting', '30mi')
	end)

rp.shop.Add('BURGATRON', 'event_burger')
	:SetCat('Ивенты')
	:SetDesc('Players spawn with BURGATRON to turn into burgers, and can eat each other to escape hunger.\nLasts 30 minutes.')
	:SetIcon('models/food/burger.mdl')
	:SetPrice(300)
	:SetOnBuy(function(self, pl)
		RunConsoleCommand('ba', 'startevent', 'burgatron', '30mi')
	end)

rp.shop.Add('Gambling Event', 'event_gambling')
	:SetCat('Ивенты')
	:SetDesc('Casino Owner slots become unlimited, gambling machines cost $1 and gambling becomes legal.\nLasts 30 minutes.')
	:SetImage('gambling.png')
	:SetPrice(350)
	:SetOnBuy(function(self, pl)
		RunConsoleCommand('ba', 'startevent', 'Gambling', '30mi')
	end)

rp.shop.Add('Rona', 'event_rona')
	:SetCat('Ивенты')
	:SetDesc('Starts a VOCID-20 plague for which there is no surviving once infected.\nLasts 3 minutes.')
	:SetImage('coronavirus.png')
	:SetPrice(1000)
	:SetCanBuy(function(self, pl)
		if rp.EventIsRunning('Rona') then
			return false, 'This event is already running!'
		end
		return true
	end)
	:SetOnBuy(function(self, pl)
		RunConsoleCommand('ba', 'startevent', 'rona', '3mi')
	end)

-- Permanent Weapons
rp.shop.Add('Camera', 'perma_camera')
	:SetCat('Оружие Навсегда')
	:SetIcon('models/MaxOfS2D/camera.mdl')
	:SetPrice(20)
	:SetWeapon('gmod_camera')

-- rp.shop.Add('Bug Bait', 'bug_bait')
-- 	:SetCat('Оружие Навсегда')
-- 	:SetIcon('models/weapons/w_bugbait.mdl')
-- 	:SetPrice(350)
-- 	:SetWeapon('weapon_bugbait')

rp.shop.Add('Монтировка', 'perma_crowbar')
	:SetCat('Оружие Навсегда')
	:SetPrice(50)
	:SetWeapon('weapon_crowbar')
	:SetIcon('models/weapons/w_crowbar.mdl')

rp.shop.Add('Glock-18', 'perma_glock')
	:SetCat('Оружие Навсегда')
	:SetPrice(70)
	:SetWeapon('bb_glock_alt')
	:SetIcon('models/weapons/3_pist_glock18.mdl')

rp.shop.Add('Fiveseven', 'perma_fiveseven')
	:SetCat('Оружие Навсегда')
	:SetPrice(50)
	:SetWeapon('bb_fiveseven_alt')
	:SetIcon('models/weapons/3_pist_fiveseven.mdl')

rp.shop.Add('P228', 'perma_p228')
	:SetCat('Оружие Навсегда')
	:SetPrice(50)
	:SetWeapon('m9k_sig_p229r')
	:SetIcon('models/weapons/3_pist_p228.mdl')

rp.shop.Add('USP.45', 'perma_usp')
	:SetCat('Оружие Навсегда')
	:SetPrice(50)
	:SetWeapon('bb_usp_alt')
	:SetIcon('models/weapons/3_pist_usp.mdl')

rp.shop.Add('.357 Magnum', 'perma_357')
	:SetCat('Оружие Навсегда')
	:SetPrice(50)
	:SetWeapon('m9k_coltpython')
	:SetIcon('models/weapons/w_357.mdl')

rp.shop.Add('.454 Raging Bull', 'perma_454')
	:SetCat('Оружие Навсегда')
	:SetPrice(70)
	:SetWeapon('m9k_ragingbull')
	:SetIcon('models/weapons/w_taurus_raging_bull.mdl')

rp.shop.Add('Desert Eagle', 'perma_deagle')
	:SetCat('Оружие Навсегда')
	:SetPrice(70)
	:SetWeapon('m9k_deagle')
	:SetIcon('models/weapons/3_pist_deagle.mdl')

rp.shop.Add('MP-40', 'perma_mp40')
	:SetCat('Оружие Навсегда')
	:SetPrice(120)
	:SetWeapon('m9k_mp40')
	:SetIcon('models/weapons/w_mp40smg.mdl')

rp.shop.Add('Kriss Vector', 'perma_vector')
	:SetCat('Оружие Навсегда')
	:SetPrice(150)
	:SetWeapon('m9k_vector')
	:SetIcon('models/weapons/w_kriss_vector.mdl')

rp.shop.Add('AAC Honey Badger', 'perma_honey')
	:SetCat('Оружие Навсегда')
	:SetPrice(150)
	:SetWeapon('m9k_honeybadger')
	:SetIcon('models/weapons/w_aac_honeybadger.mdl')

rp.shop.Add('Tommy Gun', 'perma_tom')
	:SetCat('Оружие Навсегда')
	:SetPrice(100)
	:SetWeapon('m9k_thompson')
	:SetIcon('models/weapons/w_tommy_gun.mdl')

rp.shop.Add('AWP', 'perma_awp')
	:SetCat('Оружие Навсегда')
	:SetPrice(200)
	:SetWeapon('bb_awp_alt')
	:SetIcon('models/weapons/w_snip_awp.mdl')

rp.shop.Add('M249', 'perma_m249')
	:SetCat('Оружие Навсегда')
	:SetPrice(300)
	:SetWeapon('bb_m249_alt')
	:SetIcon('models/weapons/w_mach_m249para.mdl')

rp.shop.Add('АК-74', 'perma_ak74')
	:SetCat('Оружие Навсегда')
	:SetPrice(200)
	:SetWeapon('m9k_ak74')
	:SetIcon('models/weapons/w_tct_ak47.mdl')

rp.shop.Add('HK 416', 'perma_hk416')
	:SetCat('Оружие Навсегда')
	:SetPrice(200)
	:SetWeapon('m9k_m416')
	:SetIcon('models/weapons/w_hk_416.mdl')

rp.shop.Add('SPAS-12', 'perma_spas12')
	:SetCat('Оружие Навсегда')
	:SetPrice(450)
	:SetWeapon('m9k_spas12')
	:SetIcon('models/weapons/w_spas_12.mdl')

rp.shop.Add('СР-3 «Вихрь»', 'perma_vikhr')
	:SetCat('Оружие Навсегда')
	:SetPrice(150)
	:SetWeapon('m9k_vikhr')
	:SetIcon('models/weapons/w_dmg_vikhr.mdl')

rp.shop.Add('Steyr AUG A3', 'perma_aug')
	:SetCat('Оружие Навсегда')
	:SetPrice(120)
	:SetWeapon('m9k_auga3')
	:SetIcon('models/weapons/w_auga3.mdl')

rp.shop.Add('ВС ВАЛ', 'perma_val')
	:SetCat('Оружие Навсегда')
	:SetPrice(250)
	:SetWeapon('m9k_val')
	:SetIcon('models/weapons/w_dmg_vally.mdl')

rp.shop.Add('73 Winchester Carbine', 'perma_winche')
	:SetCat('Оружие Навсегда')
	:SetPrice(220)
	:SetWeapon('m9k_winchester73')
	:SetIcon('models/weapons/w_winchester_1873.mdl')

rp.shop.Add('SCAR', 'perma_scar')
	:SetCat('Оружие Навсегда')
	:SetPrice(150)
	:SetWeapon('m9k_scar')
	:SetIcon('models/weapons/w_fn_scar_h.mdl')

rp.shop.Add('F2000AR', 'perma_f2000')
	:SetCat('Оружие Навсегда')
	:SetPrice(229)
	:SetWeapon('m9k_f2000')
	:SetIcon('models/weapons/w_fn_f2000.mdl')

rp.shop.Add('Double Barrel Shotgun', 'perma_dbarrel')
	:SetCat('Оружие Навсегда')
	:SetPrice(230)
	:SetWeapon('m9k_dbarrel')
	:SetIcon('models/weapons/w_double_barrel_shotgun.mdl')

rp.shop.Add('Mossberg 590', 'perma_mossberg590')
	:SetCat('Оружие Навсегда')
	:SetPrice(230)
	:SetWeapon('m9k_mossberg590')
	:SetIcon('models/weapons/w_mossberg_590.mdl')

rp.shop.Add('Remington 870', 'perma_remington')
	:SetCat('Оружие Навсегда')
	:SetPrice(150)
	:SetWeapon('m9k_remington870')
	:SetIcon('models/weapons/w_remington_870_tact.mdl')

rp.shop.Add('Striker 12', 'perma_striker')
	:SetCat('Оружие Навсегда')
	:SetPrice(270)
	:SetWeapon('m9k_striker12')
	:SetIcon('models/weapons/w_striker_12g.mdl')

rp.shop.Add('Winchester 1897', 'perma_wnchester')
	:SetCat('Оружие Навсегда')
	:SetPrice(300)
	:SetWeapon('m9k_1897winchester')
	:SetIcon('models/weapons/w_winchester_1897_trench.mdl')

rp.shop.Add('USAS', 'perma_usas')
	:SetCat('Оружие Навсегда')
	:SetPrice(400)
	:SetWeapon('m9k_usas')
	:SetIcon('models/weapons/w_usas_12.mdl')

rp.shop.Add('Winchester 87', 'perma_winchester87')
	:SetCat('Оружие Навсегда')
	:SetPrice(210)
	:SetWeapon('m9k_1887winchester')
	:SetIcon('models/weapons/w_winchester_1887.mdl')

rp.shop.Add('SVT 40', 'perma_svt40')
	:SetCat('Оружие Навсегда')
	:SetPrice(320)
	:SetWeapon('m9k_svt40')
	:SetIcon('models/weapons/w_svt_40.mdl')

rp.shop.Add('SVD Dragunov', 'perma_svd')
	:SetCat('Оружие Навсегда')
	:SetPrice(300)
	:SetWeapon('m9k_dragunov')
	:SetIcon('models/weapons/w_svd_dragunov.mdl')

rp.shop.Add('Barret M82', 'perma_barret')
	:SetCat('Оружие Навсегда')
	:SetPrice(450)
	:SetWeapon('m9k_barret_m82')
	:SetIcon('models/weapons/w_barret_m82.mdl')

rp.shop.Add('Barret M82B', 'perma_barret82')
	:SetCat('Оружие Навсегда')
	:SetPrice(200)
	:SetWeapon('m9k_m98b')
	:SetIcon('models/weapons/w_barrett_m98b.mdl')

rp.shop.Add('Intervention', 'perma_int')
	:SetCat('Оружие Навсегда')
	:SetPrice(200)
	:SetWeapon('m9k_intervention')
	:SetIcon('models/weapons/w_snip_int.mdl')

rp.shop.Add('Dragunov SVU', 'perma_svu')
	:SetCat('Оружие Навсегда')
	:SetPrice(450)
	:SetWeapon('m9k_svu')
	:SetIcon('models/weapons/w_dragunov_svu.mdl')

rp.shop.Add('Minigun', 'perma_m9k_minigun')
	:SetCat('Оружие Навсегда')
	:SetPrice(999)
	:SetWeapon('m9k_minigun')
	:SetIcon('models/weapons/w_m60_machine_gun.mdl')

rp.shop.Add('Отмычка', 'perma_lockpick')
	:SetCat('Оружие Навсегда')
	:SetPrice(50)
	:SetWeapon('lockpick')
	:SetIcon('models/weapons/w_crowbar.mdl')

rp.shop.Add('Взломщик', 'perma_keypad_cracker')
	:SetCat('Оружие Навсегда')
	:SetPrice(50)
	:SetWeapon('keypad_cracker')
	:SetIcon('models/weapons/w_c4.mdl')

-- rp.shop.Add('Stunstick', 'perma_stunstick')
-- 	:SetCat('Оружие Навсегда')
-- 	:SetPrice(900)
-- 	:SetWeapon('weapon_stunstick')
-- 	:SetIcon('models/weapons/w_stunbaton.mdl')

-- rp.shop.Add('Fists', 'perma_fists')
-- 	:SetCat('Оружие Навсегда')
-- 	:SetImage('boxing-gloves.png')
-- 	:SetPrice(900)
-- 	:SetWeapon('weapon_combo_fists')

-- rp.shop.Add('Climb Swep', 'climb_swep')
-- 	:SetCat('Оружие Навсегда')
-- 	:SetImage('parkour.png')
-- 	:SetPrice(1000)
-- 	:SetWeapon('climb_swep')

-- rp.shop.Add('Pimp Hand', 'perma_pimphand')
-- 	:SetCat('Оружие Навсегда')
-- 	:SetImage('pimp.png')
-- 	:SetPrice(1000)
-- 	:SetWeapon('weapon_pimphand')


-- Permanent Weapons - high price
-- rp.shop.Add('Grenade', 'perma_grenade')
-- 	:SetCat('Permanent Weapons')
-- 	:SetPrice(12500)
-- 	:SetWeapon('weapon_frag')
-- 	:SetDesc('Yes, you really spawn with a perma grenade. If you buy this you have a spending problem, thank you for your money :)')
-- 	:SetIcon('models/weapons/w_grenade.mdl')
-- 	:SetOnBuy(function(self, pl)
-- 		local weps = pl:GetVar('PermaWeapons')
-- 		weps[#weps + 1] = wep
-- 		pl:SetVar('PermaWeapons', weps)

-- 		RunConsoleCommand('ba', 'tellall', 'Everyone thank ' .. pl:Name() .. ' for wasting $125 on a perma grenade.')
-- 	end)
-- 	:AddHook('PlayerLoadout', function(pl)
-- 		pl:GiveAmmo(2, 'Grenade')
-- 	end)
-- rp.shop.Add('Slam', 'perma_slam')
-- 	:SetCat('Permanent Weapons')
-- 	:SetPrice(25000)
-- 	:SetWeapon('weapon_slam')
-- 	:SetDesc('Yes, you really spawn with a perma slam. If you buy this you have a spending problem, thank you for your money :)')
-- 	:SetIcon('models/weapons/w_slam.mdl')
-- 	:SetOnBuy(function(self, pl)
-- 		local weps = pl:GetVar('PermaWeapons')
-- 		weps[#weps + 1] = wep
-- 		pl:SetVar('PermaWeapons', weps)

-- 		RunConsoleCommand('ba', 'tellall', 'Everyone thank ' .. pl:Name() .. ' for wasting $250 on a perma slam.')
-- 	end)

-- hook('WeaponEquip', 'rp.upgrades.slams.WeaponEquip', function(wep, pl)
-- 	local class = wep:GetClass()

-- 	if (class == 'weapon_slam') then
-- 		local tripMines = table.Filter(ents.FindByClass('npc_tripmine'), function(v) return (v:GetInternalVariable('m_hOwner') == pl) end)
-- 		local satchels = table.Filter(ents.FindByClass('npc_satchel'), function(v) return (v:GetInternalVariable('m_hThrower') == pl) end)

-- 		if (#tripMines + #satchels) >= 3 then
-- 			wep:SetClip1(0)
-- 		end
-- 	end

-- 	/*if (class == 'weapon_frag') or (class == 'weapon_crossbow') or (class == 'perma_rpg') then
-- 		print 'clip set'
-- 		wep:SetClip1(0)
-- 		wep:SetClip2(0)
-- 	end*/
-- end)

-- hook('GravGunPickupAllowed', 'rp.upgrades.slams.GravGunPickupAllowed', function(pl, ent)
-- 	if (ent:GetClass() == 'npc_satchel') and (ent:GetInternalVariable('m_hThrower') ~= pl) then
-- 		return false
-- 	end
-- end)


-- rp.shop.Add('Crossbow', 'perma_crossbow')
-- 	:SetCat('Permanent Weapons')
-- 	:SetPrice(50000)
-- 	:SetWeapon('weapon_crossbow')
-- 	:SetDesc('Yes, you really spawn with a perma crossbow. If you buy this you have a spending problem, thank you for your money :)')
-- 	:SetIcon('models/weapons/w_crossbow.mdl')
-- 	:SetOnBuy(function(self, pl)
-- 		local weps = pl:GetVar('PermaWeapons')
-- 		weps[#weps + 1] = wep
-- 		pl:SetVar('PermaWeapons', weps)

-- 		RunConsoleCommand('ba', 'tellall', 'Everyone thank ' .. pl:Name() .. ' for wasting $500 on a perma crossbow.')
-- 	end)

-- rp.shop.Add('RPG', 'perma_rpg')
-- 	:SetCat('Permanent Weapons')
-- 	:SetPrice(100000)
-- 	:SetWeapon('weapon_rpg')
-- 	:SetDesc('Yes, you really spawn with a perma RPG. If you buy this you have a spending problem, thank you for your money :)')
-- 	:SetIcon('models/weapons/w_rocket_launcher.mdl')
-- 	:SetOnBuy(function(self, pl)
-- 		local weps = pl:GetVar('PermaWeapons')
-- 		weps[#weps + 1] = wep
-- 		pl:SetVar('PermaWeapons', weps)

-- 		RunConsoleCommand('ba', 'tellall', 'Everyone thank ' .. pl:Name() .. ' for wasting $1000 on a perma RPG.')
-- 	end)

-- rp.shop.Add('C4', 'perma_c4')
-- 	:SetCat('Permanent Weapons')
-- 	:SetPrice(200000)
-- 	:SetWeapon('weapon_c4')
-- 	:SetDesc('Yes, you really spawn with a perma C4. If you buy this you have a spending problem, thank you for your money :)')
-- 	:SetIcon('models/weapons/3_c4.mdl')
-- 	:SetOnBuy(function(self, pl)
-- 		local weps = pl:GetVar('PermaWeapons')
-- 		weps[#weps + 1] = wep
-- 		pl:SetVar('PermaWeapons', weps)

-- 		RunConsoleCommand('ba', 'tellall', 'Everyone thank ' .. pl:Name() .. ' for wasting $2000 on a perma C4.')
-- 	end)

-- Add ALL the knife skins!
--name, ent, w_model, texture, skinindex
local permaKnives = {
	{
		'perma_knife_bayonet_knife_|_night',
	 	'Bayonet | Night',
	 	'knife_bayonet_night',
	 	'models/weapons/w_csgo_bayonet.mdl',
	 	'models/csgo_knife/knife_bayonet_night.vmt',
		7,
	},
		{
		'perma_knife_shadow_daggers_|_fade',
	 	'Shadow Dagger | Fade',
	 	'knife_daggers_fade',
	 	'models/weapons/w_csgo_push.mdl',
	 	'models/csgo_knife/knife_push_fade.vmt',
		5,
	},
		{
		'perma_knife_butterfly_knife_|_slaughter',
	 	'Butterfly | Slaughter',
	 	'knife_butterfly_slaughter',
	 	'models/weapons/w_csgo_butterfly.mdl',
	 	'models/csgo_knife/knife_butterfly_slaughter.vmt',
		8,
	},
		{
		'perma_knife_huntsman_knife_|_tiger_tooth',
	 	'Huntsman | Tiger Tooth',
	 	'knife_huntsman_tiger',
	 	'models/weapons/w_csgo_tactical.mdl',
	 	'models/csgo_knife/knife_tactical_tiger.vmt',
		9,
	},
		{
		'perma_knife_huntsman_knife_|_boreal_forest',
	 	'Huntsman | Boreal Forest',
	 	'knife_huntsman_boreal',
	 	'models/weapons/w_csgo_tactical.mdl',
	 	'models/csgo_knife/knife_tactical_boreal.vmt',
		1,
	},
		{
		'perma_knife_gut_knife_|_case_hardened',
	 	'Gut | Case Hardened',
	 	'knife_gut_case',
	 	'models/weapons/w_csgo_gut.mdl',
	 	'models/csgo_knife/knife_gut_case.vmt',
		2,
	},
		{
		'perma_knife_bowie_knife',
	 	'Bowie Knife',
	 	'knife_bowie',
	 	'models/weapons/w_csgo_bowie.mdl',
	},
		{
		'perma_knife_falchion_knife_|_crimson_webs',
	 	'Falchion | Crimson Webs',
	 	'knife_falchion_crimsonwebs',
	 	'models/weapons/w_csgo_falchion.mdl',
	 	'models/csgo_knife/knife_falchion_crimsonwebs.vmt',
		3,
	},
		{
		'perma_knife_flip_knife_|_fade',
	 	'Flip | Fade',
	 	'knife_flip_fade',
	 	'models/weapons/w_csgo_flip.mdl',
	 	'models/csgo_knife/knife_flip_fade.vmt',
		6,
	},
		{
		'perma_knife_bayonet_knife_|_slaughter',
	 	'Bayonet | Slaughter',
	 	'knife_bayonet_slaughter',
	 	'models/weapons/w_csgo_bayonet.mdl',
	 	'models/csgo_knife/knife_bayonet_slaughter.vmt',
		8,
	},
		{
		'perma_knife_bowie_knife_|_forest_ddpat',
	 	'Bowie | Forest',
	 	'knife_bowie_ddpat',
	 	'models/weapons/w_csgo_bowie.mdl',
	 	'models/csgo_knife/knife_survival_ddpat.vmt',
		4,
	},
		{
		'perma_knife_butterfly_knife_|_night',
	 	'Butterfly | Night',
	 	'knife_butterfly_night',
	 	'models/weapons/w_csgo_butterfly.mdl',
	 	'models/csgo_knife/knife_butterfly_night.vmt',
		7,
	},
		{
		'perma_knife_default_t_knife_|_golden',
	 	'Default T | Golden',
	 	'knife_default_t_golden',
	 	'models/weapons/w_csgo_default_t.mdl',
	 	'models/csgo_knife/knife_t_golden.vmt',
		1,
	},
		{
		'perma_knife_falchion_knife_|_tiger_tooth',
	 	'Falchion | Tiger Tooth',
	 	'knife_falchion_tiger',
	 	'models/weapons/w_csgo_falchion.mdl',
	 	'models/csgo_knife/knife_falchion_tiger.vmt',
		9,
	},
		{
		'perma_knife_flip_knife_|_crimson_webs',
	 	'Flip | Crimson Webs',
	 	'knife_flip_crimsonwebs',
	 	'models/weapons/w_csgo_flip.mdl',
	 	'models/csgo_knife/knife_flip_crimsonweb.vmt',
		3,
	},
		{
		'perma_knife_gut_knife',
	 	'Gut Knife',
	 	'knife_gut',
	 	'models/weapons/w_csgo_gut.mdl',
	},
		{
		'perma_knife_karambit_knife_|_fade',
	 	'Karambit | Fade',
	 	'knife_karambit_fade',
	 	'models/weapons/w_csgo_karambit.mdl',
	 	'models/csgo_knife/karam_fade.vmt',
		6,
	},
		{
		'perma_knife_m9_bayonet_knife_|_ultraviolet',
	 	'Bayonet | Ultraviolet',
	 	'knife_m9_ultraviolet',
	 	'models/weapons/w_csgo_m9.mdl',
	 	'models/csgo_knife/knife_m9_ultraviolet.vmt',
		10,
	},
		{
		'perma_knife_shadow_daggers_|_damascus_steel',
	 	'Shadow Dagger | Damascus',
	 	'knife_daggers_damascus',
	 	'models/weapons/w_csgo_push.mdl',
	 	'models/csgo_knife/knife_push_damascus.vmt',
		3,
	},
	//vlad
	{
		'perma_knife_karambit_lore',
		'Karambit | Lore',
		'knife_karambit_lore',
		'models/weapons/w_csgo_karambit.mdl',
		'models/csgo_knife/karam_lore.vmt',
		19
	},
	{
		'perma_knife_bayonet_fade',
		'Bayonet | Fade',
		'knife_bayonet_fade',
		'models/weapons/w_csgo_bayonet.mdl',
		'models/csgo_knife/knife_bayonet_fade.vmt',
		6
	},
	{
		'perma_knife_butterfly_crimsonweb',
		'Butterfly | Crimsonweb',
		'knife_butterfly_crimsonweb',
		'models/weapons/w_csgo_butterfly.mdl',
		'models/csgo_knife/knife_butterfly_crimsonweb.vmt',
		3
	},
	{
		'perma_knife_butterfly_damascus',
		'Butterfly | Damascus',
		'knife_butterfly_damascus',
		'models/weapons/w_csgo_butterfly.mdl',
		'models/csgo_knife/knife_butterfly_dam.vmt',
		4
	},
	{
		'perma_knife_falchion_freehand',
		'Falchion | Freehand',
		'knife_falchion_freehand',
		'models/weapons/w_csgo_falchion.mdl',
		'models/csgo_knife/knife_falchion_freehand.vmt',
		17
	},
	{
		'perma_knife_flip_autotronic',
		'Flip | Autotronic',
		'knife_flip_autotronic',
		'models/weapons/w_csgo_flip.mdl',
		'models/csgo_knife/knife_flip_autotronic.vmt',
		14
	},
	{
		'perma_knife_gut_laminate',
		'Gut | Black Laminate',
		'knife_gut_laminate',
		'models/weapons/w_csgo_gut.mdl',
		'models/csgo_knife/knife_gut_black_laminate.vmt',
		15
	},
	{
		'perma_knife_gut_lore_vladdy',
		'Gut | Lore Vladdy',
		'knife_gut_lore_vladdy',
		'models/weapons/w_csgo_gut.mdl',
		'models/csgo_knife/knife_gut_lore.vmt',
		19
	},
	{
		'perma_knife_m9_bayonet_lore',
		'M9 Bayonet | Lore',
		'knife_m9_bayonet_lore',
		'models/weapons/w_csgo_m9.mdl',
		'models/csgo_knife/knife_m9_lore.vmt',
		19
	},
	{
		'perma_knife_shadow_default',
		'Shadow Dagger | Default',
		'knife_shadow_default',
		'models/weapons/w_csgo_push.mdl',
		'models/csgo_knife/knife_push.vmt',
		0
	},
	{
		'perma_knife_shadow_freehand',
		'Shadow Dagger | Freehand',
		'knife_shadow_freehand',
		'models/weapons/w_csgo_push.mdl',
		'models/csgo_knife/knife_push_freehand.vmt',
		18
	},
	{
		'perma_knife_huntsman_marble_fade',
		'Huntsman | Marble Fade',
		'knife_huntsman_marble_fade',
		'models/weapons/w_csgo_tactical.mdl',
		'models/csgo_knife/knife_tactical_marblefade.vmt',
		13
	},
	{
		'perma_knife_bowie_rust_coat',
		'Bowie | Rust Coat',
		'knife_bowie_rust_coat',
		'models/weapons/w_csgo_bowie.mdl',
		'models/csgo_knife/knife_survival_rustcoat.vmt',
		12
	}
}

local knife = rp.shop.Add('Basic Knife', 'perma_knife')
	:SetCat('Ножи Навсегда')
	:SetPrice(300)
	:SetWeapon('swb_knife')
	:SetIcon('models/weapons/w_knife_t.mdl')
	:SetStackable(false)
	knife.SWEP = 'swb_knife'

for k, v in ipairs(permaKnives) do
	weapons.Register({
		Weight				= 5,
		AutoSwitchTo		= false,
		AutoSwitchFrom		= false,
		PrintName			= v[2],
		DrawAmmo 			= false,
		DrawCrosshair 		= true,
		ViewModelFOV		= 65,
		ViewModelFlip		= false,
		CSMuzzleFlashes		= true,
		UseHands			= true,
		Slot				= 3,
		SlotPos				= 0,
		Base 				= 'baseknife',
		Category			= 'SUP Knives',
		Spawnable			= true,
		AdminSpawnable		= true,
		ViewModel 			= string.Replace(v[4], '/w_', '/v_'),
		WorldModel 			= v[4],
		DrawWeaponInfoBox  	= false,
		Skin 				= v[5],
		SkinIndex 			= v[6] or 0,
	}, v[3])

	local knife = rp.shop.Add(v[2], v[1])
		:SetCat('Ножи Навсегда')
		:SetPrice(350)
		:SetIcon(v[4])
		:SetStackable(false)
		:SetWeapon(v[3])
	knife.Skin 		= v[5]
	knife.SkinIndex = v[6]
	knife.SWEP = v[3]
end

rp.shop.Add('Вейп', 'perma_vape')
	:SetCat('Плюшки')
	:SetIcon('models/swamponions/vape.mdl')
	:SetPrice(50)
	:SetWeapon('weapon_vape')

rp.shop.Add('Спиннер', 'perma_fidget')
	:SetCat('Плюшки')
	:SetIcon('models/props_workshop/fidget_spinner.mdl')
	:SetPrice(50)
	:SetWeapon('weapon_fidget')

hook.Call('rp.AddUpgrades', GAMEMODE)