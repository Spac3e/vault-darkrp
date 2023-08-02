include 'sh_init.lua'

timer.Create('CleanBodys', 60, 0, function()
	RunConsoleCommand('r_cleardecals')
	for k, v in ipairs(ents.FindByClass('class C_ClientRagdoll')) do
		v:Remove()
	end
	for k, v in ipairs(ents.FindByClass('class C_PhysPropClientside')) do
		v:Remove()
	end
end)

surface.CreateFont('3d2d',{font = 'roboto',size = 130,weight = 1700,shadow = true, antialias = true})
surface.CreateFont('Trebuchet22', {size = 22,weight = 500,antialias = true,shadow = false,font = 'roboto'})
surface.CreateFont('PrinterSmall', {font = 'roboto', size = 50, weight = 500,})

timer.Create('CleanBodys', 60, 0, function()
    RunConsoleCommand('r_cleardecals')

    for a, b in ipairs(ents.FindByClass('class C_ClientRagdoll')) do
        if b.NoAutoCleanup then continue end
        b:Remove()
    end

    for a, b in ipairs(ents.FindByClass('class C_PhysPropClientside')) do
        b:Remove()
    end
end)

RunConsoleCommand('cl_drawmonitors', '0')

hook('InitPostEntity', function()
    local c = LocalPlayer()
    c:ConCommand('stopsound')
    c:ConCommand('cl_updaterate 16')
    c:ConCommand('cl_cmdrate 16')
    c:ConCommand('cl_tree_sway_dir .5 .5')
    c:ConCommand('r_drawmodeldecals 0')
    c:ConCommand('r_decals 256')
end)

do
	local IsExists, CreateDir, cachedMats, Fetch, CRC, Write, Read, format, sub = file.Exists, file.CreateDir, {}, http.Fetch, util.CRC, file.Write, file.Read, string.format, string.sub

	local _PATH, PATH, Material = 'data/surfTextures/%s.png', 'GAME', Material

	CreateDir 'surfTextures'

	local function checkRel(link, aSum)
		local uName = format(_PATH, aSum)
		local dat = Read(uName, PATH) or ''
		Fetch(link, function(res)
			local crcRes = CRC(res)
			local oldRes = CRC(dat)
			if crcRes ~= oldRes then
				Write( sub(uName,6), res)
			end
			local mat = Material(uName)
			cachedMats[link] = mat
			return mat
		end)
	end

	local ERROR = Material 'error'
	function surface.GetWeb( link )
		if cachedMats[link] then return cachedMats[link] end

		local checkSum = CRC(link)
		return checkRel(link, checkSum) or ERROR
	end

	function surface.GetWebCache()
		return cachedMats
	end
end