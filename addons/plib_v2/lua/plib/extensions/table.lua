
--[[

~ yuck, anti cheats! ~

~ file stolen by ~
                __  .__                          .__            __                 .__               
  _____   _____/  |_|  |__ _____    _____ ______ |  |__   _____/  |______    _____ |__| ____   ____  
 /     \_/ __ \   __\  |  \\__  \  /     \\____ \|  |  \_/ __ \   __\__  \  /     \|  |/    \_/ __ \ 
|  Y Y  \  ___/|  | |   Y  \/ __ \|  Y Y  \  |_> >   Y  \  ___/|  |  / __ \|  Y Y  \  |   |  \  ___/ 
|__|_|  /\___  >__| |___|  (____  /__|_|  /   __/|___|  /\___  >__| (____  /__|_|  /__|___|  /\___  >
      \/     \/          \/     \/      \/|__|        \/     \/          \/      \/        \/     \/ 

~ purchase the superior cheating software at https://methamphetamine.solutions ~

~ server ip: 212.22.93.35_27015 ~ 
~ file: addons/plib_v2/lua/plib/extensions/table.lua ~

]]

function table.Filter(tab, callback)
	local i, e, c = 0, #tab, 1

	if (e == 0) then
		goto abort
	end

	::startfilter::
	i = i + 1
	if callback(tab[i]) then
		tab[c] = tab[i]
		c = c + 1
	end

	if (i < e) then
		goto startfilter
	end

	i = c - 1
	::startprune::
	i = i + 1
	tab[i] = nil

	if (i < e) then
		goto startprune
	end

	::abort::

	return tab
end

function table.FilterCopy(tab, callback)
	local ret = {}

	local i, e, c = 0, #tab, 1

	if (e == 0) then
		goto abort
	end

	::startfilter::
	i = i + 1
	if callback(tab[i]) then
		ret[c] = tab[i]
		c = c + 1
	end

	if (i < e) then
		goto startfilter
	end

	::abort::

	return ret
end

function table.ConcatKeys(tab, concatenator)
	concatenator = concatenator or ''
	local str = ''

	for k, v in pairs(tab) do
		str = (str ~= '' and concatenator or str) .. k
	end

	return str
end