ba.svar = ba.svar or {
	stored = {}
}

if (CLIENT) then
	net.Receive('ba.svars', function()
		ba.svar.stored = pon.decode(net.ReadString())

		hook.Call('svarsLoaded', ba)
	end)

	function ba.svar.Get(name)
		return ba.svar.stored[name]
	end
end