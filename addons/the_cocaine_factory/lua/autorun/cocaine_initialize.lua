-- INITIALIZE SCRIPT
if SERVER then
	resource.AddWorkshop( "1734833080" )
	
	for k, v in pairs( file.Find( "autorun/ch_cocaine/server/*.lua", "LUA" ) ) do
		include( "autorun/ch_cocaine/server/" .. v )
		--print("server: ".. v)
	end
	
	for k, v in pairs( file.Find( "autorun/ch_cocaine/client/*.lua", "LUA" ) ) do
		AddCSLuaFile( "autorun/ch_cocaine/client/" .. v )
		--print("cs client: ".. v)
	end
	
	for k, v in pairs( file.Find( "autorun/ch_cocaine/shared/*.lua", "LUA" ) ) do
		include( "autorun/ch_cocaine/shared/" .. v )
		--print("shared: ".. v)
	end
	
	for k, v in pairs( file.Find( "autorun/ch_cocaine/shared/*.lua", "LUA" ) ) do
		AddCSLuaFile( "autorun/ch_cocaine/shared/" .. v )
		--print("cs shared: ".. v)
	end
	
	for k, v in pairs( file.Find( "autorun/ch_cocaine/itemstore/items/*.lua", "LUA" ) ) do
		include( "autorun/ch_cocaine/itemstore/" .. v )
		--print("itemstore: ".. v)
	end
	
	for k, v in pairs( file.Find( "autorun/ch_cocaine/itemstore/items/*.lua", "LUA" ) ) do
		AddCSLuaFile( "autorun/ch_cocaine/itemstore/items/" .. v )
		--print("cs itemstore: ".. v)
	end
end

if CLIENT then
	for k, v in pairs( file.Find( "autorun/ch_cocaine/client/*.lua", "LUA" ) ) do
		include( "autorun/ch_cocaine/client/" .. v )
		--print("client: ".. v)
	end
	
	for k, v in pairs( file.Find( "autorun/ch_cocaine/shared/*.lua", "LUA" ) ) do
		include( "autorun/ch_cocaine/shared/" .. v )
		--print("shared client: ".. v)
	end
	
	for k, v in pairs( file.Find( "autorun/ch_cocaine/itemstore/items/*.lua", "LUA" ) ) do
		include( "autorun/ch_cocaine/itemstore/items/" .. v )
		--print("itemstore client: ".. v)
	end
end