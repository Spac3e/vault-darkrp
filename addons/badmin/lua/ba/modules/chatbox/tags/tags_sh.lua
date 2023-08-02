nw.Register 'ChatTag'
	:Write(net.WriteString)
	:Read(net.ReadString)
	:SetPlayer()

function PLAYER:GetChatTag()
	local tag = hook.Call('PlayerOverrideChatTag', nil, self) or self:GetNetVar('ChatTag') or hook.Call('PlayerGetChatTag', nil, self)

	if tag and ba.chatEmotes[tag] and (SERVER or (not cvar.GetValue('DisableEmotes'))) then
		return tag .. ' '
	end

	return ''
end