util.AddNetworkString 'cvar.RequestEncryptionKey'

net('cvar.RequestEncryptionKey', function(len, pl)
	local name = net.ReadString()

	net.Start('cvar.RequestEncryptionKey')
		net.WriteString(name)
		net.WriteString(hook.Call('cvar.RequestEncryptionKey', nil, pl, name) or (name .. pl:SteamID() .. 'super secret unique per player key'))
	net.Send(pl)
end)