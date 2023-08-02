rp.abilities.Add('Money', 'Деньги')
	:SetDescription([[
	Добавляет 4000$ на ваш аккаунт
	Можно использовать раз в 17 часов
	]])
	:SetSound(Sound("vo/npc/male01/yeah02.wav"))
	:SetColor(Color(34, 139, 34))
	:SetCooldown(17 * 3600)
	:SetModel('models/props_c17/cashregister01a.mdl')
	:SetPlayTime(0 * 3600)
	:OnUse(function(self, ply) ply:AddMoney(5000) end)

rp.abilities.Add('Heal', 'Здоровье')
	:SetDescription([[
	Мгновенно восполняет здоровье до максимума
	Можно использовать раз в 1 час
	]])
	:SetCooldown(1 * 3600)
	:SetSound(Sound( "HealthKit.Touch" ))
	:SetColor(Color(127, 255, 0))
	:SetModel('models/Items/HealthKit.mdl')
	:SetPlayTime(5 * 3600)
	:SetCantUseReason(function(self, ply) return 'вы здоровы' end)
	:SetCanUse(function(self, ply) return ply:Health() < ply:GetMaxHealth() end)
	:OnUse(function(self, ply) ply:SetHealth(ply:GetMaxHealth()) end)
	
rp.abilities.Add('Armor', 'Броня')
	:SetDescription([[
	Мгновенно восполняет броню до максимума
	Можно использовать раз в 1 час
	]])
	:SetCooldown(1 * 3600)
	:SetSound(Sound('items/suitchargeok1.wav'))
	:SetColor(Color(70, 130, 180))
	:SetModel('models/Items/battery.mdl')
	:SetPlayTime(10 * 3600)
	:OnUse(function(self, ply) ply:SetArmor(ply:Armor() + 100) end)
	
local weps = {"m9k_m4a1", "m9k_browningauto5", "m9k_g3a3", "m9k_tec9", "m9k_thompson", "m9k_ak47"}

rp.abilities.Add('Weapon', 'Оружие')
	:SetDescription([[
	Выдает вам одно рандомное оружие (M4A1, XM1014, G3SG1, TEC-9, Tommy Gun, AK47).
	Можно использовать раз в 35 часов
	]])
	:SetCooldown(15 * 3600)
	:SetModel('models/weapons/3_rif_ak47.mdl')
	:SetColor(Color(128, 0, 128))
	:SetPlayTime(50 * 3600)
	:SetSound(Sound('items/ammo_pickup.wav'))
	:OnUse(function(self, ply) ply:Give(table.Random(weps)) end)
	
rp.abilities.Add('Unjail', 'Выйти из Тюрьмы')
	:SetDescription([[
	Мгновенно освобождает вас из тюрьмы
	Можно использовать раз в 1 день
	]])
	:SetSound(Sound('physics/plastic/plastic_box_break1.wav'))
	:SetColor(Color(0, 0, 128))
	:SetCooldown(24 * 3600)
	:SetModel('models/weapons/w_crowbar.mdl')
	:SetPlayTime(80 * 3600)
	:SetCanUse(function(self, ply) return ply:IsArrested() end)
	:SetCantUseReason(function(self, ply) return 'вы не арестованы' end)
	:OnUse(function(self, ply) ply:UnArrest() end)