nw.Register 'eventInfo'
	:Write(net.WriteTable)
	:Read(net.ReadTable)
	:SetGlobal()

ba.cmd.Create('event', function(pl, args)
	net.Start("eventMenu")
	net.Send(pl)
end)
:SetFlag('a')
:SetHelp('Открыть ивент меню')