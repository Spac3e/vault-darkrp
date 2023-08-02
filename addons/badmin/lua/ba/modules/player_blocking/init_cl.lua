cvar.Register 'blocked_players'
	:SetDefault('')

function ba.PlayerIsBlocked(steamid)
	return cvar.Get('blocked_players'):GetMetadata(steamid)
end

function PLAYER:Block(block)
	if (self == LocalPlayer()) then return end

	self:SetMuted(block)

	local cv = cvar.Get('blocked_players')
	cv:AddMetadata(self:SteamID(), block)
	cv:Save()

	if block then
		chat.AddText(ui.col.White, self:NameID() .. ' был заблокирован. ', ui.col.Red, 'ПРЕДУПРЕЖДЕНИЕ: ', ui.col.White, 'Это блокирует его только для вас. Если этого недостаточно для разрешения ситуации, сообщите об этом администратору.')
	else
		chat.AddText(ui.col.White, self:NameID() .. ' был разблокирован.')
	end
end

function PLAYER:IsBlocked()
	return ba.PlayerIsBlocked(self:SteamID())
end

hook('InitPostEntity', 'ba.playerblocking.OnEntityCreated', function()
	for k, v in ipairs(player.GetAll()) do
		if v:IsBlocked() then
			v:SetMuted(true)
		end
	end
end)

hook('OnEntityCreated', 'ba.playerblocking.OnEntityCreated', function(ent)
	if ent:IsPlayer() and ent:IsBlocked() then
		ent:SetMuted(true)
	end
end)

hook('PlayerStartVoice', 'ba.playerblocking.PlayerStartVoice', function(pl)
	if IsValid(pl) and pl:IsBlocked() then
		pl:SetMuted(true)
	end
end)