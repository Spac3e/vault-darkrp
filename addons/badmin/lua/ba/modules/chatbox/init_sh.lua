-- PMs
if CLIENT then
	cvar.Register 'enable_non_pm_chat_tabs'
		:SetDefault(false, true)
		:AddMetadata('Catagory', 'Чат')
		:AddMetadata('Menu', 'Создать вкладку чатов для не PM чатов')

	hook.Add('ShouldCreateChatTab', 'rp.chat.ShouldCreateChatTab', function(name)
		if (not cvar.GetValue('enable_non_pm_chat_tabs')) and (string.find(name, '[PM]') == nil) then
			return false
		end
	end)
end

nw.Register 'IsTyping'
	:Write(net.WriteBool)
	:Read(net.ReadBool)
	:SetPlayer()
	:SetNoSync()

function PLAYER:IsTyping()
	return (self:GetNetVar('IsTyping') == true)
end