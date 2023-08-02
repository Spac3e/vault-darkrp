if SERVER then

	util.AddNetworkString("eventCommand")
	util.AddNetworkString("eventMenu")

	local bots = {}

	net.Receive("eventCommand", function(_,ply)
		if !IsValid(ply) then return false end
		if not ply:HasFlag("A") then return false end

		local cmd = net.ReadString()

		local info = nw.GetGlobal('eventInfo')

		if cmd == "Create" and info == nil then
			local ivent = net.ReadTable()
			nw.SetGlobal("eventInfo",{
				name = ivent.name,
				admin = ply,
				pos = ivent.pos,
				players = {},
				state = true
			})
			SendMessageAll( Color( 55, 55, 255 ), "[ИВЕНТ] ",Color(255,255,255),"Администратор ",ply,Color(255,255,255)," начал событие '"..ivent.name.."' /goevent")
		end

		if cmd == "Close" then
			if info != nil and nw.GetGlobal('eventInfo').admin == ply or ply:IsRoot() then
				nw.SetGlobal("eventInfo",{
					name = nw.GetGlobal('eventInfo').name,
					admin = nw.GetGlobal('eventInfo').admin,
					pos = nw.GetGlobal('eventInfo').pos,
					players = nw.GetGlobal('eventInfo').players,
					state = false
				})
				SendMessageAll( Color( 55, 55, 255 ), "[ИВЕНТ] ",Color(255,255,255),"Администратор ",ply,Color(255,255,255)," закрыл /goevent")
			end
		end

		if cmd == "Open" then
			if info != nil and nw.GetGlobal('eventInfo').admin == ply or ply:IsRoot() then
				nw.SetGlobal("eventInfo",{
					name = nw.GetGlobal('eventInfo').name,
					admin = nw.GetGlobal('eventInfo').admin,
					pos = nw.GetGlobal('eventInfo').pos,
					players = nw.GetGlobal('eventInfo').players,
					state = true
				})
				SendMessageAll( Color( 55, 55, 255 ), "[ИВЕНТ] ",Color(255,255,255),"Администратор ",ply,Color(255,255,255)," открыл /goevent")
			end
		end

		if cmd == "Spawn" then
			if info != nil and nw.GetGlobal('eventInfo').admin == ply or ply:IsRoot() then
				nw.SetGlobal("eventInfo",{
					name = nw.GetGlobal('eventInfo').name,
					admin = nw.GetGlobal('eventInfo').admin,
					pos = ply:GetPos(),
					players = nw.GetGlobal('eventInfo').players,
					state = nw.GetGlobal('eventInfo').state
				})
				rp.Notify(ply, NOTIFY_SUCCESS, "Вы успешно поменяли спавн на ивенте.")
			end
		end

		if cmd == "End" then
			if info != nil and nw.GetGlobal('eventInfo').admin == ply or ply:IsRoot() then
				SendMessageAll( Color( 55, 55, 255 ), "[ИВЕНТ] ",Color(255,255,255),"Администратор ",ply,Color(255,255,255)," закончил событие '"..nw.GetGlobal('eventInfo').name.."'")
				for k,v in pairs(nw.GetGlobal('eventInfo').players) do
					v:SetPos(v:GetNWVector("RetrunSpawn"))
				end
				nw.SetGlobal('eventInfo',nil)
				bots = {}
			end
		end

		if cmd == "Delete" then
			if info != nil and nw.GetGlobal('eventInfo').admin == ply or ply:IsRoot() then
				local player = net.ReadEntity()
				if IsValid(player) and player:IsPlayer() then
					for k,v in pairs(bots) do
						if v == player then
							table.remove( bots,k )
						end
					end
					
					rp.Notify(player, NOTIFY_ERROR, "Вас удалили из ивента.")
					player:SetPos(player:GetNWVector("RetrunSpawn"))

					nw.SetGlobal("eventInfo",{
						name = nw.GetGlobal('eventInfo').name,
						admin = nw.GetGlobal('eventInfo').admin,
						pos = nw.GetGlobal('eventInfo').pos,
						players = bots,
						state = nw.GetGlobal('eventInfo').state
					})

				end
			end
		end
	end)

	hook.Add("PlayerSpawn","JopaSpasimenya", function(ply)
		if nw.GetGlobal('eventInfo') != nil then
			timer.Simple(.1,function()
				if table.HasValue(bots,ply) then
					ply:SetPos(nw.GetGlobal('eventInfo').pos)
				end
			end)
		end
	end)

	local function eventGO(ply, args)
		if nw.GetGlobal('eventInfo') == nil then
			rp.Notify(ply, NOTIFY_ERROR, "Сейчас нету ивентов!")
			return ''
		end

		if nw.GetGlobal('eventInfo').state == false then
			rp.Notify(ply, NOTIFY_ERROR, "Сейчас вход на ивент закрыт!")
			return ''
		end

		if table.HasValue(nw.GetGlobal('eventInfo').players,ply) then
			rp.Notify(ply, NOTIFY_ERROR, "Вы уже зарегистрован на ивент.")
			return ''
		end
		
		rp.Notify(ply, NOTIFY_SUCCESS, "Вы успешно зарегистрирован на ивент.")

		table.insert(bots,ply)

		nw.SetGlobal("eventInfo",{
			name = nw.GetGlobal('eventInfo').name,
			admin = nw.GetGlobal('eventInfo').admin,
			pos = nw.GetGlobal('eventInfo').pos,
			players = bots,
			state = nw.GetGlobal('eventInfo').state
		})		

		ply:SetPos(nw.GetGlobal('eventInfo').pos)

		ply:SetNWVector("RetrunSpawn",ply:GetPos())

		rp.Notify(nw.GetGlobal('eventInfo').admin, NOTIFY_SUCCESS, "Игрок "..ply:Name().." зашёл на ивент!")

		return ''
	end
	rp.AddCommand('goevent', eventGO)

	hook.Add("PlayerDisconnected", "DownStop", function(ply)
		local info = nw.GetGlobal('eventInfo')
		if info != nil and nw.GetGlobal('eventInfo').admin == ply then
			SendMessageAll( Color( 55, 55, 255 ), "[ИВЕНТ] ",Color(255,255,255),"Администратор ",ply,Color(255,255,255)," закончил событие '"..nw.GetGlobal('eventInfo').name.."'")
			for k,v in pairs(nw.GetGlobal('eventInfo').players) do
				v:SetPos(v:GetNWVector("RetrunSpawn"))
			end
			nw.SetGlobal('eventInfo',nil)
			bots = {}
		end
	end)

end