function TCF_SetPosNPCBuyer( ply, cmd, args )
	if ply:IsAdmin() then
		local FileName = args[1]
		
		if not FileName then
			ply:ChatPrint("Please choose a UNIQUE name for the fire! For example type 'cocainebuyer_setpos gasstation'") 
			return
		end
		
		if file.Exists( "craphead_scripts/the_cocaine_factory/".. string.lower(game.GetMap()) .."/drugs_buyer_location_".. FileName ..".txt", "DATA" ) then 
			ply:ChatPrint("This file name is already in use. Please choose another name for this location of fire.")
			return
		end
		
		local HisVector = string.Explode(" ", tostring(ply:GetPos()))
		local HisAngles = string.Explode(" ", tostring(ply:GetAngles()))
		
		file.Write("craphead_scripts/the_cocaine_factory/".. string.lower(game.GetMap()) .."/drugs_buyer_location_".. FileName ..".txt", ""..(HisVector[1])..";"..(HisVector[2])..";"..(HisVector[3])..";"..(HisAngles[1])..";"..(HisAngles[2])..";"..(HisAngles[3]).."", "DATA")
		ply:ChatPrint( "Successfully setup a new spawn point for a cocaine buyer NPC!" )
		ply:ChatPrint( "All NPC's will respawn in 5 seconds. Please move out of the way." )
		
		for k, v in pairs( ents.FindByClass( "cocaine_drugs_buyer" ) ) do
			if IsValid( v ) then
				v:Remove()
			end
		end
		
		timer.Simple( 5, function()
			TCF_SpawnNPCBuyer()
		end )
	else
		ply:ChatPrint( "Only administrators can perform this action" )
	end
end
concommand.Add("cocainebuyer_setpos", TCF_SetPosNPCBuyer )

function TCF_RemoveNPCBuyerPos( ply, cmd, args )
	if ply:IsAdmin() then
		local FileName = args[1]
		
		if not FileName then
			ply:ChatPrint("Please enter a filename!") 
			return
		end
		
		if file.Exists( "craphead_scripts/the_cocaine_factory/".. string.lower(game.GetMap()) .."/drugs_buyer_location_".. FileName ..".txt", "DATA" ) then
			file.Delete( "craphead_scripts/the_cocaine_factory/".. string.lower(game.GetMap()) .."/drugs_buyer_location_".. FileName ..".txt" )
			ply:ChatPrint("The selected NPC has been removed!")
		else
			ply:ChatPrint("The selected NPC does not exist!")
		end
	else
		ply:ChatPrint("Only administrators can perform this action")
	end
end
concommand.Add("cocainebuyer_removepos", TCF_RemoveNPCBuyerPos)

function TCF_SpawnNPCBuyer()
	timer.Simple( 5, function()
		if not file.IsDir( "craphead_scripts", "DATA" ) then
			file.CreateDir( "craphead_scripts", "DATA" )
		end
			
		if not file.IsDir( "craphead_scripts/the_cocaine_factory/".. string.lower(game.GetMap()) .."", "DATA" ) then
			file.CreateDir( "craphead_scripts/the_cocaine_factory/".. string.lower(game.GetMap()) .."", "DATA" )
		end
		
		for k, v in pairs(file.Find( "craphead_scripts/the_cocaine_factory/".. string.lower(game.GetMap()) .."/drugs_buyer_location_*.txt", "DATA") ) do
			local PositionFile = file.Read( "craphead_scripts/the_cocaine_factory/".. string.lower(game.GetMap()) .."/".. v, "DATA" )
			local ThePosition = string.Explode( ";", PositionFile )
			local TheVector = Vector( ThePosition[1], ThePosition[2], ThePosition[3] )
			local TheAngle = Angle( tonumber( ThePosition[4] ), ThePosition[5], ThePosition[6] )

			local druggie_npc = ents.Create( "cocaine_drugs_buyer" )
			druggie_npc:SetPos( TheVector )
			druggie_npc:SetAngles( TheAngle )
			druggie_npc:Spawn()
		end
	end )
end
hook.Add( "Initialize", "TCF_SpawnNPCBuyer", TCF_SpawnNPCBuyer )