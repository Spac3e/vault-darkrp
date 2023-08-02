term.Add('SeeConsole', 'Посмотрите в консоль.')

-------------------------------------------------
-- Reload
-------------------------------------------------
ba.cmd.Create('Reload', function(pl, args)
	RunConsoleCommand('changelevel', game.GetMap())
end)
:SetFlag('*')
:SetHelp('Перезагружает карту.')

-------------------------------------------------
-- Bots
-------------------------------------------------
ba.cmd.Create('Bots', function(pl, args)
	for i = 1, tonumber(args.number) do
		RunConsoleCommand('bot')
	end
end)
:SetFlag('*')
:AddParam('string', 'number')
:SetHelp('Создает бота.')

ba.cmd.Create('KickBots', function(pl)
	for k, v in ipairs(player.GetBots()) do
		v:Kick()
	end
end)
:SetFlag '*'
:SetHelp 'Кикнуть всех роботов'

-------------------------------------------------
-- Previous offences
-------------------------------------------------
ba.cmd.Create('PO')
:RunOnClient(function(args)
	ba.ui.OpenURL('https://desk-justrp.ru/')
end)
:SetFlag('m')
:SetHelp('Показывает баны игрока. Пример: /po (ник)')


-------------------------------------------------
-- Lookup
-------------------------------------------------
if (SERVER) then
	util.AddNetworkString('ba.Lookup')
end

ba.cmd.Create('Lookup', function(pl, args)
local columns = {}
columns[1] = {
	Header = 'Имя',
	Data = {}
}

columns[2] = {
	Header = 'Группа',
	Data = {}
}

columns[3] = {
	Header = 'Наигранное время',
	Data = {}
}

table.insert(columns[1].Data, {args.target:Name(), args.target:SteamID()})
table.insert(columns[2].Data, args.target:GetRank())
table.insert(columns[3].Data, ba.str.FormatTime(args.target:GetPlayTime()))
local data = util.TableToJSON(columns)
local size = #data
net.Start('ba.Lookup')
	net.WriteUInt(size, 16)
	net.WriteString(data)
net.Send(pl)
end)

:AddParam('player_entity', 'target')
:SetFlag('u')
:SetHelp('Показывает информацию об игроке.')

:RunOnClient(function(args)
	local fr
	net.Receive('ba.Lookup', function(len)
		local size = net.ReadUInt(16)
		print(size)
		local columns = util.JSONToTable(net.ReadString())

	if (IsValid(fr)) then fr:Remove() end
	fr = ui.Create('ui_frame', function(self)
		self:SetSize(610, 76) 
		self:SetTitle("Информация об игроке")
		self:Center()
		self:SetDraggable(true)
		self:MakePopup()
		self:SetKeyboardInputEnabled(false)
	end)
	local list = ui.Create('DListView', function(self, p)
		self:Dock(FILL)
		self:SetSize(p:GetWide(), p:GetTall() - 35)
		self:SetMultiSelect(false)
		self:AddColumn('Ник и стимайди')	
		self:AddColumn('Группа'):SetFixedWidth(115)		
		self:AddColumn('Наигранное время')
		self:SetHeaderHeight(25)
	end, fr)
	list.OnRowSelected = function(parent, line)
	local row 		= list:GetLine(line)
	local log 		= row:GetColumnText(1) .. ' | ' ..  row:GetColumnText(2) .. ' | ' .. row:GetColumnText(3)
	local menu 		= ui.DermaMenu()

	menu:AddOption('Скопировать строку', function()
		SetClipboardText(log)
		chat.AddText(color_white, 'Строка скопирована: ' .. log)
	end)

	for k, v in SortedPairs(row.Copy or {}) do
		menu:AddOption('Скопировать ' .. k, function()
			SetClipboardText(v)
			LocalPlayer():ChatPrint(k .. ' скопирован')
		end)
	end
	menu:Open()
	end
	for k, v in ipairs(columns[1].Data) do
		local line = {v[1] .. ' (' .. v[2] .. ')'}
		if (columns[2]) then
			line[2] = columns[2].Data[k]
			if (columns[3]) then
				line[3] = columns[3].Data[k]
			end
		end
		list:AddLine(unpack(line)).Copy = {SteamID=v[2]}
	end
	end)
end)
-------------------------------------------------
-- Who
-------------------------------------------------
local white = Color(200,200,200)
ba.cmd.Create('Who', function(pl, args)
	ba.notify(pl, term.Get('SeeConsole'))
end)
:RunOnClient(function(args)
	MsgC(white, '--------------------------------------------------------\n')
	MsgC(white, '          SteamID      |      Name      |      Rank\n')
	MsgC(white, '--------------------------------------------------------\n')

	for k, v in ipairs(player.GetAll()) do
		local id 	= v:SteamID()
		local nick 	= v:Name()
		local text 	= string.format("%s%s %s%s ", id, string.rep(" ", 2 - id:len()), nick, string.rep(" ", 20 - nick:len()))
		text 		= text .. v:GetRank()
		MsgC(white, text .. '\n')
	end
end)
:SetHelp('Показывает информацию о всех игроках.')

-------------------------------------------------
-- Exec
-------------------------------------------------
ba.cmd.Create('Exec', function(pl, args)
	args.target:SendLua([[pcall(RunString, ]] .. args.lua .. [[)]])
end)
:SetFlag('*')
:AddParam('player_entity', 'target')
:AddParam('string', 'lua')
:SetHelp('Инжектит lua на игрока.')
