if SERVER then 
	include("sv_config.lua")
	include("relay/sv_msg.lua")
	local files, _ = file.Find( 'relay/commands/' .. "*", "LUA" )
	for num, fl in ipairs(files) do
		include("relay/commands/" .. fl)
		print('[Discord Relay] module ' .. fl .. ' added!')
	end
	AddCSLuaFile('cl_config.lua')
	AddCSLuaFile('relay/cl_msg.lua')
	print( "----------------------\n" )
	print( "DISCORD RELAY LOADED!\n" )
	print( "----------------------" )
end
if CLIENT then 
	include('cl_config.lua')
	include('relay/cl_msg.lua')
end