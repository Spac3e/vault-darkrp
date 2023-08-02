cvar.Register 'enable_chatsounds'
	:SetDefault(true, true)
	:AddMetadata('Catagory', 'Chat')
	:AddMetadata('Menu', 'Включить чат-фразы')

hook('PlayerLocalChat', 'rp.chatsounds.PlayerLocalChat', function(pl, text)
	if cvar.GetValue('enable_chatsounds') and pl:Alive() and (not pl:IsBanned()) then

		local sounds = rp.cfg.ChatSounds[text:lower():Replace(',', ''):Replace('.', '')]
		if sounds then
			local toplay = sounds[math.random(1, #sounds)]

			if (!IsValid(pl.LastChatSound) or pl.LastChatSoundPath != toplay) then
				if (IsValid(pl.LastChatSound)) then pl.LastChatSound:Stop() end

				pl.LastChatSound = CreateSound(pl, toplay)
			end

			pl.LastChatSoundPath = toplay

			pl.LastChatSound:Play()
		end
	end
end)