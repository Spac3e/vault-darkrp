
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
~ file: addons/plib_v2/lua/plib/thirdparty/aes.lua ~

]]

require 'hash'

local luaAES = plib.IncludeSH 'plib/submodules/lua_aes/lua_aes.lua'

aes = {
	Encrypt = function(key, data)
		return luaAES.ECB_256(luaAES.encrypt, tonumber(hash.SHA256('0x' .. key)), data)
	end,
	Decrypt = function(key, data)
		return luaAES.ECB_256(luaAES.decrypt, tonumber(hash.SHA256('0x' .. key)), data)
	end
}