IGS.C.CURRENCY_SIGN = "₽"

IGS.C.CurrencyPlurals = {
	"рубль",
	"рубля",
	"рублей"
}

IGS.C.MENUBUTTON = KEY_F6

IGS.C.COMMANDS = {
	["donate"] = true,
	['upgrade'] = true,
	['upgrades'] = true,
}

IGS.C.Inv_Enabled = true

-- Разрешить выбрасывать предметы с инвентаря на пол
-- Это позволит игрокам покупать донат подарки для друзей или вам делать донат раздачи
IGS.C.Inv_AllowDrop = true



if SERVER then return end -- не смотрите так на меня :)


-- Показывать ли уведомление о новых предметах в донат меню
-- Выглядит вот так https://img.qweqwe.ovh/1526574184864.png
IGS.C.NotifyAboutNewItems = true


-- Эта иконка будет отображена для предмета, если для него не будет установлена кастомная через :SetIcon()
-- Отображается вот тут: https://img.qweqwe.ovh/1494088609445.png
IGS.C.DefaultIcon = "https://i.imgur.com/mLoHaCE.jpg"




-- Уберите "--" с начала строки, чтобы отключить появление определенного фрейма
IGS.C.DisabledFrames = {
	-- ["faq_and_help"] = true, -- Чат бот (страница помощи)
	-- ["profile"]      = true, -- Страница профиля игрока (с транзакциями)
	-- ["purchases"]    = true, -- Активные покупки
}


-- Оставьте так, если не уверены
-- Инфо: https://vk.cc/6xaFOe
IGS.C.DATE_FORMAT = "%d.%m.%y %H:%M:%S"
IGS.C.DATE_FORMAT_SHORT = "%d.%m.%y"
