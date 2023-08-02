local errors = {
	[cmd.ERROR_INVALID_PLAYER]   = 'Игрок # не найден',
	[cmd.ERROR_MISSING_PARAM]    = 'Отстутствует # параметр: #',
	[cmd.ERROR_INVALID_COMMAND]  = 'Неизвестная команда: #',
	[cmd.ERROR_COMMAND_COOLDOWN] = 'Подождите # сек перед повторным вводом #',
	[cmd.ERROR_INVALID_NUMBER]   = 'Некорректный номер: #',
	[cmd.ERROR_INVALID_TIME]     = 'Некорректное время: #'
}

hook('cmd.OnCommandError','MessageCommandError',function(pl,obj,code,params)
	local msg = 'Неизвестная ошибка.'
	if errors[code] then
		local i = 0
		msg = errors[code]:gsub('#', function()
			i = i + 1
			return params[i]
		end)
	end

	rp.Notify(pl, NOTIFY_ERROR, msg)
end)

function GM:PlayerSay(pl, text, teamonly, dead)
	text = string.Trim(text)

	if pl:IsBanned() or (text == '') or (text == '/') or (text == '!') then return '' end

	if teamonly then
		chat.Send('Group', pl, text)
		return ''
	end

	chat.Send('Local', pl, text)
	return ''
end