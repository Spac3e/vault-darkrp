rp_box = {}


rp_box.NPC_name = "Кладовщик" -- Имя NPC
rp_box.NPC_model = "models/Eli.mdl" -- Модель NPC

rp_box.MoneyForBox = 400  -- Награда за коробку (для рандомной награды пишем math.random(min,max))

if SERVER then
	util.AddNetworkString( "PlayerDisplayChat" )
	local PLAYER = FindMetaTable( "Player" )
	if PLAYER then
	    function PLAYER:SendMessageFD( ... )
	         local args = { ... }
	         net.Start( "PlayerDisplayChat" )
	             net.WriteTable( args )
	         net.Send( self )
	    end
	end
end

if CLIENT then
	net.Receive( "PlayerDisplayChat", function()
	    local args = net.ReadTable()
	    chat.AddText( unpack( args ) )
	end )
end