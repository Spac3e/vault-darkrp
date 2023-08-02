rp      = rp or {} 
rp.util = rp.util or {}
rp.cfg 	= rp.cfg or {} 
rp.inv 	= rp.inv or {Data = {}, Wl = {}} 
pdash = plib -- lol
PLAYER	= FindMetaTable 'Player'
ENTITY	= FindMetaTable 'Entity'
VECTOR	= FindMetaTable 'Vector'

if (SERVER) then
	require 'mysql'
else
	require'texture'
    require'imgui'
    texture.SetProxy'https://gmod-api.superiorservers.co/api/imageproxy/?url=%s&width=%i&height=%i&format=%s'
end

require 'cvar'
require 'hash'
require 'nw'
require 'pon'
require 'term'
require 'cmd'
require 'chat'
require 'utf8'

rp.include = function(f)
	if string.find(f, '_sv.lua') then
		return plib.IncludeSV(f)
	elseif string.find(f, '_cl.lua') then
		return plib.IncludeCL(f)
	else
		return plib.IncludeSH(f)
	end
end
rp.include_dir = function(dir, recursive)
	local fol = dir .. '/'
	local files, folders = file.Find(fol .. '*', 'LUA')
	for _, f in ipairs(files) do
		rp.include(fol .. f)
	end
	if (recursive ~= false) then
		for _, f in ipairs(folders) do
			rp.include_dir(dir .. '/' .. f)
		end
	end
end

local loadmsg1 = {
[[ 
	╭╮╱╱╭┳━━━┳╮╱╭┳╮╱╭━━━━┳━━━┳━━━╮
	┃╰╮╭╯┃╭━╮┃┃╱┃┃┃╱┃╭╮╭╮┃╭━╮┃╭━╮┃
	╰╮┃┃╭┫┃╱┃┃┃╱┃┃┃╱╰╯┃┃╰┫╰━╯┃╰━╯┃
	╱┃╰╯┃┃╰━╯┃┃╱┃┃┃╱╭╮┃┃╱┃╭╮╭┫╭━━╯
	╱╰╮╭╯┃╭━╮┃╰━╯┃╰━╯┃┃┃╱┃┃┃╰┫┃
	╱╱╰╯╱╰╯╱╰┻━━━┻━━━╯╰╯╱╰╯╰━┻╯

--------------------------------------------------------------
Credits: -Spac3
--------------------------------------------------------------
File's Fully Loaded
--------------------------------------------------------------
]]
}


GM.Name 	= 'DarkRP'

/*
Иерархия инклюдов
Здравствуйте, моё имя Доктор Шпак Багиров, сегодня я проведу вам теорию по кривоте Plib, который инклюдает не вообщем а по-очерёдно
*/

plib.IncludeSV 'darkrp/gamemode/db.lua' // Ты у нас главный за загрузку данных

plib.IncludeSH 'darkrp/gamemode/cfg/cfg.lua' // Ты у нас подгружаешь нужные столики и конфиг впринципе
plib.IncludeSH 'darkrp/gamemode/cfg/colors.lua' // Чтоб цветы были
rp.include_dir 'darkrp/gamemode/util' // Ютил помогает коре
rp.include_dir('darkrp/gamemode/core', false) // Ядрышко
rp.include_dir 'darkrp/gamemode/core/sandbox' // Ядрышко спавнменю
rp.include_dir('darkrp/gamemode/core/chat', false) // Похуй
rp.include_dir 'darkrp/gamemode/core/player' // Важно, но похуй
rp.include_dir 'darkrp/gamemode/core/ui/controls'
rp.include_dir 'darkrp/gamemode/core/ui'
rp.include_dir('darkrp/gamemode/core/orgs', false) // Похуй
rp.include_dir('darkrp/gamemode/core/orgs/vgui', false) // Похуй
rp.include_dir 'darkrp/gamemode/core/credits' // Важно, не похуй.
rp.include_dir 'darkrp/gamemode/core/karma' // Похуй
rp.include_dir('darkrp/gamemode/core/prop_protect', false) // Похуй
rp.include_dir 'darkrp/gamemode/core/cosmetics' // Похуй
rp.include_dir('darkrp/gamemode/core/makethings', false) // Важно
rp.include_dir('darkrp/gamemode/core/commands', false) // Важно
rp.include_dir('darkrp/gamemode/core/smallscripts', false) // Не важно, не похуй
rp.include_dir('darkrp/gamemode/core/hud', true) // Похуй
rp.include_dir 'darkrp/gamemode/core/achievements' // Похуй
rp.include_dir 'rp_base/gamemode/core/somemodules'
rp.include_dir 'darkrp/gamemode/core/bonuses' // Похуй
rp.include_dir 'darkrp/gamemode/core/teammode' // Тимы типа
rp.include_dir('darkrp/gamemode/core/doors', false) // Важно, грузим до загрузки самого конфига
rp.include_dir 'darkrp/gamemode/core/somemodules'
plib.IncludeSH 'darkrp/gamemode/cfg/jobs.lua' // Похуй
plib.IncludeSH('darkrp/gamemode/cfg/doors/'.. game.GetMap() .. '.lua') // Загрузилась мапка
plib.IncludeSH 'darkrp/gamemode/cfg/entities.lua'// Похуй
plib.IncludeSH 'darkrp/gamemode/cfg/cosmetics.lua' // ПохуйПохуй
plib.IncludeSH 'darkrp/gamemode/cfg/skills.lua' // ПохуйПохуйПохуй
plib.IncludeSH 'darkrp/gamemode/cfg/upgrades.lua' // Похуй
rp.include_dir 'darkrp/gamemode/core/events' // Не важно, не похуй но похуй
plib.IncludeSH 'darkrp/gamemode/cfg/terms.lua' // Похуй, важно
plib.IncludeSV 'darkrp/gamemode/cfg/limits.lua' // Похуй, важно
plib.IncludeSH 'darkrp/gamemode/cfg/achievements.lua' // ПохуйПохуйПохуйПохуйПохуйПохуйПохуйПохуйПохуй
plib.IncludeCL 'darkrp/gamemode/cfg/renderoffsets.lua' // ПохуйПохуйПохуйПохуйПохуйПохуйПохуйПохуйПохуй
plib.IncludeCL 'darkrp/gamemode/cfg/bonuses.lua' // Похуй, пока не работает вроде
plib.IncludeSH 'darkrp/gamemode/cfg/skins.lua' // ПохуйПохуйПохуйПохуйПохуйПохуйПохуйПохуйПохуй

concommand.Add( "player_position", function( ply, cmd, args )
	chat.AddText( Color( 255, 255, 255 ), "Ваша позиция была скопирована. CTRL+V,чтобы вставить")
	SetClipboardText(("Vector(%s)"):format(string.gsub(tostring(ply:GetPos())," ", ",")))
end)

for _, v in ipairs(loadmsg1) do
	MsgC(rp.col.White, v .. '\n')
end

function PLAYER:HasPurchase(sUID)
	return IGS.PlayerPurchases(self)[sUID]
end