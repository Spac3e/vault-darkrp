ba.chatEmotes = ba.chatEmotes or {}

local function loadEmotesList(data)
	for _, emojiSet in pairs(data) do
		for k, v in pairs(emojiSet.Emotes) do
			local em = ':' .. k .. ':'
			ba.chatEmotes[em] = {
				name = em,
				loadUrl = string.Replace(emojiSet.ImageUrl, '{item_id}', tostring(v)),
				mat = false
			}
		end
	end
end

local function fetchEmotes()
	local cacheFile = 'badmin/emotes.dat'

	ba.http.FetchJson('emotes', function(data)
		loadEmotesList(data)

		file.Write(cacheFile, pon.encode(data))
	end, function()
		if file.Exists(cacheFile, 'DATA') then
			loadEmotesList(pon.decode(file.Read(cacheFile, 'DATA')))
		end
	end)
end
hook('InitPostEntity', 'ba.emotes.InitPostEntity', fetchEmotes)