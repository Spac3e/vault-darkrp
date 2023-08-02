nw.Register 'eventInfo'
	:Write(net.WriteTable)
	:Read(net.ReadTable)
	:SetGlobal()

ba.AddCommand('event', function(pl, args)
	net.Start("eventMenu")
	net.Send(pl)
end)
:SetFlag('a')
:SetHelp('Открыть ивент меню')