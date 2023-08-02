-- Play Time
local function formatTimeProgress(self, progress, total)
	return math.Round(progress/3600, 2) .. '/' .. math.floor(total/3600)
end

nw.Register 'Achs'
	:Write(net.WriteTable)
	:Read(net.ReadTable)
	:SetPlayer()

ACHIEVEMENT_TIME_250 = rp.achievements.Add {
	Name = 'Только Начал',
	Description = 'Отыграть 250 часов',
	Reward = 'Золотой ник',
    Icon = 'sup/gui/achievements/hours_250.png',
	StoreProgress = false,
	Total = 900000,
	FormatProgress = formatTimeProgress,
	Tick = function(self, pl)
		if pl:GetPlayTime() and (pl:GetPlayTime() > 900000) then
			rp.achievements.Finish(pl, self.UID)
		else
			pl:SetAchievementProgress(self.UID, pl:GetPlayTime())
		end
	end
}

ACHIEVEMENT_TIME_1K = rp.achievements.Add {
	Name = '400 IQ',
	Description = 'Отыграть 1к часов',
	Icon = 'sup/gui/achievements/hours_250.png',
	StoreProgress = false,
	Total = 3600000,
	FormatProgress = formatTimeProgress,
	Tick = function(self, pl)
		if pl:GetPlayTime() and (pl:GetPlayTime() > 3600000) then
			rp.achievements.Finish(pl, self.UID)
		else
			pl:SetAchievementProgress(self.UID, pl:GetPlayTime())
		end
	end
}

ACHIEVEMENT_TIME_5K = rp.achievements.Add {
	Name = 'Нет личной жизни',
	Description = 'Отыграть 5к часов',
	Reward = 'Фиолетовый ник',
	Icon = 'sup/gui/achievements/hours_5000.png',
	Total = 18000000,
	FormatProgress = formatTimeProgress,
	Tick = function(self, pl)
		if pl:GetPlayTime() and (pl:GetPlayTime() > 18000000) then
			rp.achievements.Finish(pl, self.UID)
		else
			pl:SetAchievementProgress(self.UID, pl:GetPlayTime())
		end
	end,
	StoreProgress = false
}

ACHIEVEMENT_TIME_10K = rp.achievements.Add{
    Name = 'Помогите',
    Description = 'Отыграть 10к часов',
    Reward = 'Кастомный цвет ника',
    Icon = 'sup/gui/achievements/hours_10000.png',
    Total = 36000000,
    FormatProgress = formatTimeProgress,
    Tick = function(self, pl)
		if pl:GetPlayTime() and (pl:GetPlayTime() > 36000000) then
			rp.achievements.Finish(pl, self.UID)
		else
			pl:SetAchievementProgress(self.UID, pl:GetPlayTime())
		end
	end,
    StoreProgress = false
}

ACHIEVEMENT_TIME_15K = rp.achievements.Add {
	Name = 'Что',
	Description = 'Отыграть 15к часов',
	Reward = 'Радужный ник',
	Icon = 'sup/gui/achievements/hours_15000.png',
	Total = 54000000,
	FormatProgress = formatTimeProgress,
	Tick = function(self, pl)
		if pl:GetPlayTime() and (pl:GetPlayTime() > 54000000) then
			rp.achievements.Finish(pl, self.UID)
		else
			pl:SetAchievementProgress(self.UID, pl:GetPlayTime())
		end
	end,
	StoreProgress = false
}

-- Raiding
ACHIEVEMENT_LOCKPICK = rp.achievements.Add {
	Name = 'Слесарь',
	Description = 'Взломать 250 замков',
	Icon = 'sup/gui/skills/lockpick.png',
	Total = 250
}

ACHIEVEMENT_APPAREL = rp.achievements.Add{
    Name = 'Энтузиаст моды',
    Description = 'Приобрести 5 аксессуаров',
    Icon = 'sup/gui/achievements/suit.png',
    Total = 5
}

ACHIEVEMENT_GUNSKIN = rp.achievements.Add{
    Name = 'Энтузиаст огнестрельного оружия',
    Description = 'Приобрести 5 скинов на оружия',
    Icon = 'sup/gui/achievements/gunskin.png',
    Total = 5
}

ACHIEVEMENT_HACKER = rp.achievements.Add {
	Name = 'Хакер',
	Description = 'Взломать 250 кейпадов',
	Icon = 'sup/gui/skills/keypadcracking.png',
	Total = 250
}

ACHIEVEMENT_ESCORT = rp.achievements.Add{
    Name = 'Сумка Гуччи',
    Description = 'Займитесь любовью с людьми 50 раз',
    Icon = 'sup/gui/achievements/high-heels.png',
    Total = 50
}

ACHIEVEMENT_DOORS = rp.achievements.Add{
    Name = 'Собственник',
    Description = 'Арендовать 100 зданий',
    Icon = 'sup/gui/achievements/door.png',
    Total = 100
}


-- Misc
ACHIEVEMENT_HEALER = rp.achievements.Add {
	Name = 'Доктор',
	Description = 'Вылечить 100 игроков',
	Icon = 'sup/gui/skills/medic.png',
	Total = 100
}

ACHIEVEMENT_MERCHANT = rp.achievements.Add{
    Name = 'Торговец',
    Description = 'Купить 100 коробок',
    Icon = 'sup/gui/achievements/merchant.png',
    Total = 100
}

ACHIEVEMENT_HIGH_PROFILE = rp.achievements.Add{
    Name = 'Высокий Профиль',
    Description = 'Выполните 100 заказов',
    Icon = 'sup/gui/achievements/high-profile.png',
    Total = 100
}

ACHIEVEMENT_HITMAN = rp.achievements.Add{
    Name = 'Профессиональный убийца',
    Description = 'Выполните 200 заказов',
    Icon = 'sup/gui/generic/hitman.png',
    Total = 200
}

ACHIEVEMENT_ARRESTED = rp.achievements.Add{
    Name = 'Правонарушитель',
    Description = 'Быть арестованным 250 раз',
    Icon = 'sup/gui/achievements/prisoner.png',
    Total = 250
}

ACHIEVEMENT_BAILED = rp.achievements.Add{
    Name = 'Под системой',
    Description = 'Быть выкупленным под залог 150 раз',
    Icon = 'sup/gui/achievements/bail.png',
    Total = 150
}

ACHIEVEMENT_PAYCHECK_ROBBER = rp.achievements.Add{
    Name = 'Мэдофф',
    Description = 'Обчистите карманы людей 50 раз',
    Icon = 'sup/gui/achievements/robbery.png',
    Total = 50
}

ACHIEVEMENT_PRINTERS = rp.achievements.Add{
    Name = 'Фальшивомонетчик',
    Description = 'Купите 100 Денежных Принтеров',
    Icon = 'sup/gui/achievements/printing.png',
    Total = 100
}

ACHIEVEMENT_COPMAIN = rp.achievements.Add{
    Name = "Главный Полицейский",
    Description = "Арестовать 100 человек",
    Icon = "sup/gui/achievements/police.png",
    Total = 100
}

ACHIEVEMENT_SECRETPHRASE = rp.achievements.Add{
    Name = "Секрет",
    Description = "Написать секретную фразу в чат",
    Icon = "icon16/comment.png",
    Total = 1
}

rp.cfg.NameTagOptions = {
    {
        Name = "Default (White)",
        Color = rp.col.White
    },
    {
        Name = "Light Blue",
        Color = Color(182, 216, 255),
        Achievement = ACHIEVEMENT_TIME_250
    },
    {
        Name = "Gold",
        Color = Color(240, 191, 0),
        Achievement = ACHIEVEMENT_TIME_5K
    },
    {
        Name = "Custom",
        Color = 1,
        Achievement = ACHIEVEMENT_TIME_10K
    },
    {
        Name = "Rainbow",
        Color = 2,
        Achievement = ACHIEVEMENT_TIME_15K
    }
}
