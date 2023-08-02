if (CLIENT) then
	cvar.Register 'oocchat_enable'
		:SetDefault(true, true)
		:AddMetadata('Catagory', 'Чат')
		:AddMetadata('Menu', 'Включить OOC чат')

	cvar.Register 'advert_blocker'
		:SetDefault(false, true)
		:AddMetadata('Catagory', 'Чат')
		:AddMetadata('Menu', 'Блокировать рекламу в чате')

	cvar.Register 'tts_enable'
		:SetDefault(true, true)
		:AddMetadata('Catagory', 'Чат')
		:AddMetadata('Menu', 'Включить TTS')
end

local function writemsg(pl, v)
	net.WritePlayer(pl)
	net.WriteString(v)
end


function encodeURI(str)
	if (str) then
		str = string.gsub (str, "\n", "\r\n")
		str = string.gsub (str, "([^%w ])",
			function (c) return string.format ("%%%02X", string.byte(c)) end)
		str = string.gsub (str, " ", "+")
	end
	return str
end
	
function decodeURI(s)
	if(s) then
		s = string.gsub(s, '%%(%x%x)', 
		function (hex) return string.char(tonumber(hex,16)) end )
	end
	return s
end

local function tts(txt, pl)
	pl.NextPlayTTS = pl.NextPlayTTS or 0
	if pl.NextPlayTTS and CurTime() > pl.NextPlayTTS then
		sound.PlayURL('https://translate.google.com/translate_tts?ie=UTF-8&client=tw-ob&q=' .. encodeURI(txt) ..'&tl=ru','2d',function(station)
			if IsValid(station) then
				station:SetVolume(.5)
				station:Play()
				pl.NextPlayTTS = CurTime() + station:GetLength()
			end
		end)
	end
end

local function applyMsgtts(c, p, pl, msg)
	c = c or ''
	p = p or ''
	if IsValid(pl) then
		chat.EnableEmotes(pl:IsVIP())
		if cvar.GetValue("tts_enable") and pl:GetNWBool("GovorilkaHave") and system.HasFocus() then
			tts(msg, pl)
			return c, p, pl:GetChatTag(),  pl:GetJobColor(), pl:Name(), rp.col.White, ': ', msg
		else
			return c, p, pl:GetJobColor(), pl:Name(), rp.col.White, ': ', msg
		end
	else
		return c, p, rp.col.Gray, 'Unknown: ', rp.col.White, msg
	end
end

local function applyMsg(c, p, pl, msg)
	if #msg > 128 or msg:find("\n") then return end

	c = c or ''
	p = p or ''
	if IsValid(pl) then
		chat.EnableEmotes(pl:IsVIP())
		return c, p, pl:GetChatTag(), pl:GetJobColor(), pl:Name(), rp.col.White, ': ', msg
	else
		return c, p, rp.col.Gray, 'Unknown: ', rp.col.White, msg
	end
end

local function readmsgtts(c, p)
	c = c or ''
	p = p or ''
	local pl = net.ReadPlayer()
	local msg = net.ReadString()
	if string.len(msg) > 128 then return end
	return applyMsgtts(c, p, pl, msg)
end

local function readmsg(c, p)
	c = c or ''
	p = p or ''
	local pl = net.ReadPlayer()
	local msg = net.ReadString()
	return applyMsg(c, p, pl, msg)
end

local function readBlockableMessage(c, p)
	c = c or ''
	p = p or ''

	local pl = net.ReadPlayer()
	if (not IsValid(pl)) then return end

	local msg = net.ReadString()
	return applyMsg(c, p, pl, msg)
end

local col = rp.col

chat.Register 'Local'
	:Write(writemsg)
	:Read(readmsgtts)
	:SetLocal(250)

chat.Register 'Whisper'
	:Write(writemsg)
	:Read(function()
		return readmsg(col.Red, '[Шепот] ')
	end)
	:SetLocal(90)

chat.Register 'Yell'
	:Write(writemsg)
	:Read(function()
		return readmsgtts(col.Red, '[Крик] ')
	end)
	:SetLocal(600)

chat.Register 'Me'
	:Write(writemsg)
	:Read(function()
		local pl = net.ReadPlayer()
		if IsValid(pl) then
			return pl:GetJobColor(), pl:Name() .. ' ' .. net.ReadString()
		end
	end)
	:SetLocal(250)

chat.Register 'Ad'
	:Write(writemsg)
	:Read(function()
		return readmsg(col.Red, '[Реклама] ')
	end)

chat.Register 'Radio'
	:Write(function(channel, pl, message)
		net.WriteUInt(channel, 8)
		writemsg(pl, message)
	end)
	:Read(function()
		return readmsg(col.Grey, '[Канал ' .. net.ReadUInt(8) .. '] ')
	end)
	:Filter(function(channel, pl, message)
		return table.Filter(player.GetAll(), function(v)
			return v.RadioChannel and (v.RadioChannel == pl.RadioChannel)
		end)
	end)

chat.Register 'Broadcast'
	:Write(writemsg)
	:Read(function()
		return readmsg(col.Red, '[Мэр Города] ')
	end)

chat.Register 'Group'
	:Write(writemsg)
	:Read(function()
		return readmsg(col.Green, '[Группа] ')
	end)
	:Filter(function(pl)
		return table.Filter(player.GetAll(), function(v)
			return (rp.groupChats[v:GetJob()] and rp.groupChats[v:GetJob()][pl:GetJob()]) or (v == pl)
		end)
	end)

chat.Register 'OOC'
	:Write(writemsg)
	:Read(function()
		if cvar.GetValue('oocchat_enable') then
			return readmsg(col.OOC, '[OOC] ')
		end
	end)

chat.Register 'PM'
	:Write(function(pl, targ, msg)
		net.WritePlayer(pl)
		net.WritePlayer(targ)
		net.WriteString(msg)
	end)
	:Read(function()
		local pl, targ = net.ReadPlayer(), net.ReadPlayer()
		local isTarget = (targ == LocalPlayer())
		local user = (isTarget and pl or targ)

		return ui.col.Yellow, '[PM '.. (isTarget and 'ОТ' or 'К') .. '] ', user:GetJobColor(), user:Name(), ': ', ui.col.White, net.ReadString()
	end)
	:Filter(function(pl, targ, msg)
		if #msg >= 1024 then return end
		return {targ, pl}
	end)

chat.Register 'Roll'
	:Write(function(pl, num)
		net.WritePlayer(pl)
		net.WriteUInt(num, 8)
	end)
	:Read(function()
		local pl = net.ReadPlayer()
		if IsValid(pl) then
			return col.Red, '[', col.Pink, 'Кубик', col.Red, '] ', pl:GetJobColor(), pl:Name() .. ' ', rp.col.White, 'кинул и выпало ', col.Pink, tostring(net.ReadUInt(8)), col.White, ' из 100.'
		end
	end)
	:SetLocal(250)

chat.Register 'Dice'
	:Write(function(pl, num1, num2)
		net.WritePlayer(pl)
		net.WriteUInt(num1, 8)
		net.WriteUInt(num2, 8)
	end)
	:Read(function()
		local pl = net.ReadPlayer()
		if IsValid(pl) then
			return col.Red, '[', col.Pink, 'Кости', col.Red, '] ', pl:GetJobColor(), pl:Name() .. ' ', rp.col.White, 'кинул и выпало ', col.Pink, tostring(net.ReadUInt(8)), col.White, ' и ', col.Pink, tostring(net.ReadUInt(8)), '.'
		end
	end)
	:SetLocal(250)

chat.Register 'Cards'
	:Write(function(pl, card)
		net.WritePlayer(pl)
		net.WriteString(card)
	end)
	:Read(function()
		local pl = net.ReadPlayer()
		if IsValid(pl) then
			return col.Red, '[', col.Pink, 'Карты', col.Red, '] ', pl:GetJobColor(), pl:Name() .. ' ', rp.col.White, 'вытянул ', col.Pink, net.ReadString(), col.White, '.'
		end
	end)
	:SetLocal(250)

chat.Register 'Coin'
	:Write(function(pl, card)
		net.WritePlayer(pl)
		net.WriteString(card)
	end)
	:Read(function()
		local pl = net.ReadPlayer()
		if IsValid(pl) then
			return col.Red, '[', col.Pink, 'Монетка', col.Red, '] ', pl:GetJobColor(), pl:Name() .. ' ', rp.col.White, 'подбросил и выпало ', col.Pink, net.ReadString(), col.White, '.'
		end
	end)
	:SetLocal(250)