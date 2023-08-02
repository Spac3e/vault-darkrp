local function eventAdmin()
	local info = nw.GetGlobal("eventInfo")

	if IsValid(a) then
		a:Remove()
	end

	a = ui.Create("ui_frame")
	a:SetTitle("Ивент Меню")
	a:SetSize(550,500)
	a:Center()
	a:MakePopup()

	if info == nil then
		local state = ui.Create("DLabel", a)
		state:SetText("ИВЕНТОВ НЕТ")
		state:SetFont('ui.60')
		state:SizeToContents()
		state:Center()
		state:SetPos(state:GetPos(1), 150)

		local btn_create = ui.Create("ui_button", a)
		btn_create:SetText('Создать ивент')
		btn_create:SetFont('ui.32')
		btn_create:SizeToContents()
		btn_create:Center()
		btn_create:SetPos(btn_create:GetPos(1), 220)
		btn_create.DoClick = function(self)
			a:Close()
			ui.StringRequest('Создание ивента', 'Дайте название вашему ивенту', '', function(a)	
				if #a > 30 then
					rp.Notify(NOTIFY_ERROR, 'Название ивента не может привышать более 30 символов') 
					return
				elseif #a <= 3 then
					rp.Notify(NOTIFY_ERROR, 'Название ивента не может быть меньше 3 символов') 
					return
				end
				net.Start('eventCommand')
					net.WriteString('Create')
					net.WriteTable({name = a, pos = LocalPlayer():GetPos()})
				net.SendToServer()
			end)
		end

		local btn_create = ui.Create("ui_button", a)
		btn_create:SetText('Выбрать ивент')
		btn_create:SetFont('ui.32')
		btn_create:SizeToContents()
		btn_create:Center()
		btn_create:SetPos(btn_create:GetPos(1), 290)
		btn_create.DoClick = function(self)
			a:Close()

			a = ui.Create("ui_frame")
			a:SetTitle("Ивент-Меню")
			a:SetSize(550,500)
			a:Center()
			a:MakePopup()

			local event = ui.Create("ui_button", a)
			event:SetText("Паркур Ивент")
			event:SetFont('ui.24')
			event:SizeToContents()
			event:Center()
			event:SetSize(550, 30)
			event:SetPos(0, 30)
			event.DoClick = function(self)
				a:Close()
				ui.StringRequest('Создание события', 'Введите длительность события (15mi, 1d)', '', function(a)
					RunConsoleCommand("ba", "startevent", "Паркур", a)
				end)
			end

			local event = ui.Create("ui_button",a)
			event:SetText("Зарплата Ивент")
			event:SetFont('ui.24')
			event:SizeToContents()
			event:Center()
			event:SetSize(550, 30)
			event:SetPos(0,60)
			event.DoClick = function(self)
				a:Close()
				ui.StringRequest('Создание события', 'Введите длительность события (15mi, 1d)', '', function(a)
					RunConsoleCommand("ba", "startevent", "Salary", a)
				end)
			end

			local event = ui.Create("ui_button",a)
			event:SetText("Burgatron Ивент")
			event:SetFont('ui.24')
			event:SizeToContents()
			event:Center()
			event:SetSize(550, 30)
			event:SetPos(0,90)
			event.DoClick = function(self)
				a:Close()
				ui.StringRequest('Создание события', 'Введите длительность события (15mi, 1d)', '', function(a)
					RunConsoleCommand("ba", "startevent", "BURGATRON", a)
				end)
			end

			local event = ui.Create("ui_button",a)
			event:SetText("VIP Ивент")
			event:SetFont('ui.24')
			event:SizeToContents()
			event:Center()
			event:SetSize(550, 30)
			event:SetPos(0,120)
			event.DoClick = function(self)
				a:Close()
				ui.StringRequest('Создание события', 'Введите длительность события (15mi, 1d)', '', function(a)
					RunConsoleCommand("ba", "startevent", "VIP", a)
				end)
			end
		end
	else
		if LocalPlayer() == info.admin or LocalPlayer():GetUserGroup() == "root" then
			local pl_list = ui.Create("DScrollPanel", a)
			pl_list:Dock(LEFT)
			pl_list:DockMargin(5, 10, 0, 5)
			pl_list:SetSize(125, 0)
			for k, v in pairs(info.players) do
				local pl_inv = pl_list:Add("ui_button")
				pl_inv:SetText(v:Name())
				pl_inv:Dock(TOP)
				pl_inv:DockMargin(5, 5, 5, 5)
				pl_inv.DoClick = function(self)
					local menu = ui.DermaMenu()
					menu:AddOption( "Выгнать с ивента", function()
						net.Start('eventCommand')
							net.WriteString('Delete')
							net.WriteEntity(v)
						net.SendToServer()
						self:Remove()
					end):SetIcon("icon16/user_delete.png")

					menu:AddOption( "Телепоритовать", function()
						LocalPlayer():ConCommand("ba tp " .. v:SteamID()) 
					end):SetIcon("icon16/arrow_left.png")
					
					menu:AddOption( "Телепоритоваться", function()
						LocalPlayer():ConCommand("ba goto " .. v:SteamID())
					end):SetIcon("icon16/arrow_right.png")
					menu:Open()
				end
			end

			local right_pnl = ui.Create("DPanel", a)
			right_pnl:Dock(FILL)
			right_pnl:DockMargin(5, 10, 5, 5)

			local btn_decline = ui.Create("ui_button", right_pnl)
			btn_decline:SetText('Завершить ивент')
			btn_decline:SetFont('ui.32')
			btn_decline:SizeToContents()
			btn_decline:Dock(BOTTOM)
			btn_decline.DoClick = function(self)
				net.Start('eventCommand')
					net.WriteString('End')
				net.SendToServer()
				a:Close()
			end	

			local btn_openlobby = ui.Create("ui_button", right_pnl)
			btn_openlobby:SetText('Открыть вход')
			btn_openlobby:SetFont('ui.32')
			btn_openlobby:SizeToContents()
			btn_openlobby:Dock(BOTTOM)
			btn_openlobby.DoClick = function(self)
				net.Start('eventCommand')
					net.WriteString('Open')
				net.SendToServer()
			end	

			local btn_closelobby = ui.Create("ui_button", right_pnl)
			btn_closelobby:SetText('Закрыть вход')
			btn_closelobby:SetFont('ui.32')
			btn_closelobby:SizeToContents()
			btn_closelobby:Dock(BOTTOM)
			btn_closelobby.DoClick = function(self)
				net.Start('eventCommand')
					net.WriteString('Close')
				net.SendToServer()
			end	

			local btn_chgspawn = ui.Create("ui_button", right_pnl)
			btn_chgspawn:SetText('Изменить спавн')
			btn_chgspawn:SetFont('ui.32')
			btn_chgspawn:SizeToContents()
			btn_chgspawn:Dock(BOTTOM)
			btn_chgspawn.DoClick = function(self)
				net.Start('eventCommand')
					net.WriteString('Spawn')
				net.SendToServer()
			end		
		else
			local state = ui.Create("DLabel", a)
			state:SetText("ИВЕНТ УЖЕ ИДЁТ!")
			state:SetFont('ui.60')
			state:SizeToContents()
			state:Center()
			state:SetPos(state:GetPos(1), 150)

			if LocalPlayer():GetUserGroup() == "root" then
				local btn_decline = ui.Create("ui_button", a)
				btn_decline:SetText('Завершить ивент')
				btn_decline:SetFont('ui.32')
				btn_decline:SizeToContents()
				btn_decline:Center()
				btn_decline:SetPos(btn_decline:GetPos(1), 220)
				btn_decline.DoClick = function(self) end
			end
		end
	end
end
net.Receive("eventMenu", eventAdmin)