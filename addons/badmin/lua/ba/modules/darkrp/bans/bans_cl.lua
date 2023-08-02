local function appeal_menu(banData)
    local ply = LocalPlayer()

    if not ply:IsBanned() then return rp.Notify(NOTIFY_ERROR, "Вы не в бане!") end

    local fr = ui.Create("ui_frame")
    fr:SetPos(ScrW() / 2 - 250, ScrH() / 2 - 350)
    fr:SetSize(500, 800)
    fr:SetTitle("Подать аппеляцию")
    fr:SetVisible(true)
    fr:SetDraggable(true)
    fr:ShowCloseButton(true)
    fr:MakePopup()

    local nick = ui.Create("DLabel", fr)
    nick:SetFont("ui.20")
    nick:SetPos(10, 35)
    nick:SetSize(fr:GetWide(), 20)
    nick:SetText("1) Ваш Ник:")

    local nick_txt = ui.Create('DTextEntry', fr)
    nick_txt:SetPos(10, 55)
    nick_txt:SetSize(fr:GetWide() - 20, 20)
    nick_txt:SetFont('ui.22')
    nick_txt:SetText(ply:Nick())
    nick_txt:SetEditable(false)

    local sid = ui.Create("DLabel", fr)
    sid:SetFont("ui.20")
    sid:SetPos(10, 75)
    sid:SetSize(fr:GetWide(), 20)
    sid:SetText("2) Ваш SteamID:")

    local sid_txt = ui.Create('DTextEntry', fr)
    sid_txt:SetPos(10, 95)
    sid_txt:SetSize(fr:GetWide() - 20, 20)
    sid_txt:SetFont('ui.22')
    sid_txt:SetText(ply:SteamID())
    sid_txt:SetEditable(false)

    local discordik = ui.Create("DLabel", fr)
    discordik:SetFont("ui.20")
    discordik:SetPos(10, 115)
    discordik:SetSize(fr:GetWide(), 20)
    discordik:SetText("3) Ваш Discord (имя#тэг): ")

    local discordik_txt = ui.Create('DTextEntry', fr)
    discordik_txt:SetPos(10, 135)
    discordik_txt:SetSize(fr:GetWide() - 20, 20)
    discordik_txt:SetFont('ui.20')
    discordik_txt:SetText("")
    discordik_txt:SetPlaceholderText("Вставьте ваш Discord аккаунт (имя#тэг)")
    discordik_txt:SetMultiline(true)
    discordik_txt.OnTextChanged = function(self)
        if #self:GetValue() > 64 then
            self:SetText(string.sub(self:GetValue(), 1, 64))
            rp.Notify(NOTIFY_ERROR, 'Имя вашего Discord не может превышать 64 символа..')
        end
    end

    local nickadm = ui.Create("DLabel", fr)
    nickadm:SetFont("ui.20")
    nickadm:SetPos(10, 155)
    nickadm:SetSize(fr:GetWide(), 20)
    nickadm:SetText("4) Ник администратора:")

    local nickadm_txt = ui.Create('DTextEntry', fr)
    nickadm_txt:SetPos(10, 175)
    nickadm_txt:SetSize(fr:GetWide() - 20, 20)
    nickadm_txt:SetFont('ui.22')
    nickadm_txt:SetText(banData.AdminName)
    nickadm_txt:SetEditable(false)
    nickadm_txt:SetPlaceholderText("Введите ник администратора")

    local sidadm = ui.Create("DLabel", fr)
    sidadm:SetFont("ui.20")
    sidadm:SetPos(10, 195)
    sidadm:SetSize(fr:GetWide(), 20)
    sidadm:SetText("5) SteamID администратора:")

    local sidadm_txt = ui.Create('DTextEntry', fr)
    sidadm_txt:SetPos(10, 215)
    sidadm_txt:SetSize(fr:GetWide() - 20, 20)
    sidadm_txt:SetFont('ui.22')
    sidadm_txt:SetText(banData.AdminSteamID != "0" and ba.InfoTo32(banData.AdminSteamID) or "(No SteamID)")
    sidadm_txt:SetEditable(false)
    sidadm_txt:SetPlaceholderText("Введите SteamID администратора")

    local rankadm = ui.Create("DLabel", fr)
    rankadm:SetFont("ui.20")
    rankadm:SetPos(10, 235)
    rankadm:SetSize(fr:GetWide(), 20)
    rankadm:SetText("6) Причина бана:")

    local banreason_txt = ui.Create('DTextEntry', fr)
    banreason_txt:SetPos(10, 255)
    banreason_txt:SetSize(fr:GetWide() - 20, 20)
    banreason_txt:SetFont('ui.22')
    banreason_txt:SetText(banData.Reason)
    banreason_txt:SetEditable(false)

    local reason = ui.Create("DLabel", fr)
    reason:SetFont("ui.20")
    reason:SetPos(10, 275)
    reason:SetSize(fr:GetWide(), 20)
    reason:SetText("7) Что нарушил администратор:")

    local reason_txt = ui.Create('DTextEntry', fr)
    reason_txt:SetPos(10, 295)
    reason_txt:SetSize(fr:GetWide() - 20, (fr:GetTall() - 410) / 2)
    reason_txt:SetFont('ui.22')
    reason_txt:SetText("")
    reason_txt:SetPlaceholderText("Введите нарушение администратора")
    reason_txt:SetMultiline(true)
    reason_txt.OnTextChanged = function(self)
        if #self:GetValue() > 255 then
            self:SetText(string.sub(self:GetValue(), 1, 255))
            rp.Notify(NOTIFY_ERROR, 'Текст нарушения не может превышать 255 символов.')
        end
    end

    local dokva = ui.Create("DLabel", fr)
    dokva:SetFont("ui.20")
    dokva:SetPos(10, (fr:GetTall() - 350) / 2 + 245)
    dokva:SetSize(fr:GetWide(), 100)
    dokva:SetWrap(true)
    dokva:SetText("8) Доказательства нарушения [Скриншоты/Демонстрация экрана], (Демонстрации экрана загружать на YouTube, Google Drive, Яндекс Диск и т. д.):")

	local dokva_txt = ui.Create('DTextEntry', fr)
    dokva_txt:SetPos(10, 325 + ((fr:GetTall() - 350) / 2))
    dokva_txt:SetSize(fr:GetWide() - 20, (fr:GetTall() - 400) / 2)
    dokva_txt:SetFont('ui.22')
    dokva_txt:SetText("")
    dokva_txt:SetPlaceholderText("Вставьте ссылки на доказательства")
    dokva_txt:SetMultiline(true)
    dokva_txt.OnTextChanged = function(self)
        if #self:GetValue() > 512 then
            self:SetText(string.sub(self:GetValue(), 1, 512))
            rp.Notify(NOTIFY_ERROR, 'Текст доказательств не может превышать 512 символов.')
        end
    end

    local submit = ui.Create("ui_button", fr)
    submit:SetPos(10, fr:GetTall() - 40)
    submit:SetSize(fr:GetWide() - 20, 30)
    submit:SetText("Отправить")
    submit.DoClick = function()
        if #dokva_txt:GetValue() < 7 then
            rp.Notify(NOTIFY_ERROR, "Текст в поле 'Доказательства' не может быть меньше 7 символов!")
        elseif #reason_txt:GetValue() < 7 then
            rp.Notify(NOTIFY_ERROR, "Текст в поле 'Что нарушил администратор' не может быть меньше 7 символов!")
        else
            fr:Close()
            net.Start("badmin::sendAppeal")
                net.WriteString(nick_txt:GetValue())
                net.WriteString(sid_txt:GetValue())
                net.WriteString(discordik_txt:GetValue())
                net.WriteString(nickadm_txt:GetValue())
                net.WriteString(sidadm_txt:GetValue())
                net.WriteString(banreason_txt:GetValue())
                net.WriteString(reason_txt:GetValue())
                net.WriteString(dokva_txt:GetValue())
            net.SendToServer()
        end
    end
end

local banPanel
local function createBanPanel(banData)
	if (IsValid(banPanel)) then banPanel:Remove() end

	if (file.Exists("vlt/ban_ack.dat", "DATA")) then
		if (file.Read("vlt/ban_ack.dat") == tostring(banData.ID)) then
			return
		end
	end

	file.CreateDir("vlt")

	banPanel = ui.Create("ui_frame", function(self)
		self:ShowCloseButton(false)
		self:SetTitle("Заблокирован")
		self:SetSize(540, 480)
		self:Center()
		self:MakePopup()
	end)

	local scrollPanel = ui.Create("ui_scrollpanel", function(self)
		self:Dock(FILL)
		self:DockMargin(0, 4, 0, 0)

		self:AddItem(ui.Create("DLabel", function(lbl)
			lbl.Paint = function(s, w, h)
				surface.SetDrawColor(0, 0, 0)
				surface.DrawRect(0, 0, w, h)
			end

			lbl:SetText("Вы были забанены.")
			lbl:SetFont('ui.32')
			lbl:SetContentAlignment(8)
			lbl:SizeToContents()
			lbl:SetTextColor(Color(255, 50, 50))

			ui.Create("DLabel", function(lbl)
				lbl:SetText("Ban ID: " .. banData.ID)
				lbl:SetFont('ui.15')
				lbl:Dock(RIGHT)
				lbl:DockMargin(0, 0, 4, 2)
				lbl:SetContentAlignment(3)
				lbl:SizeToContents()
				lbl:SetTextColor(Color(255, 50, 50))
			end, lbl)
		end))

		self:AddItem(ui.Create("DLabel", function(lbl)
			lbl:SetText("Админ:")
			lbl:SetFont('ui.26')
			lbl:SizeToContents()
		end))

		self:AddItem(ui.Create("DLabel", function(lbl)
			lbl:SetText(banData.AdminName)
			lbl:SetTextColor(Color(220, 220, 220))
		end))

		self:AddItem(ui.Create("DLabel", function(lbl)
			lbl:SetText(banData.AdminSteamID != "0" and ba.InfoTo32(banData.AdminSteamID) or "(No SteamID)")
			lbl:SetTextColor(Color(220, 220, 220))
		end))

		self:AddItem(ui.Create("DLabel", function(lbl)
			lbl:SetText("Продолжительность:")
			lbl:SetFont('ui.26')
			lbl:SizeToContents()
		end))

		local timeOffset = "Выдан " .. banData.Time .. "\n"
		local timeOnset = "Истекает " .. banData.Length
		self:AddItem(ui.Create("DLabel", function(lbl)
			lbl:SetText(timeOffset .. timeOnset)
			lbl:SetTextColor(Color(220, 220, 220))
			lbl:SetAutoStretchVertical(true)
			lbl:SetWrap(true)
		end))

		self:AddItem(ui.Create("DLabel", function(lbl)
			lbl:SetText("Причина:")
			lbl:SetFont('ui.26')
			lbl:SizeToContents()
		end))

		self:AddItem(ui.Create("DLabel", function(lbl)
			lbl:SetText(banData.Reason)
			lbl:SetTextColor(Color(220, 220, 220))
			lbl:SetAutoStretchVertical(true)
			lbl:SetWrap(true)
		end))

	end, banPanel)

	local accept = ui.Create('ui_button', function(self)
		self:Dock(BOTTOM)
		self:SetTall(32)
		self:SetText("Согласиться и открыть правила")

		self.DoClick = function() 
            banPanel:Close() 
            ba.OpenMoTD()
            file.Write("sup/ban_ack.dat", banData.ID) 
        end
	end, banPanel)	
	
	local previous = ui.Create('ui_button', function(self)
		self:Dock(BOTTOM)
		self:SetTall(32)
		self:DockMargin(0, 4, 0, 4)
		self:SetText("Подать апелляцию")

		self.DoClick = function()
            banPanel:Close() 
            appeal_menu(banData)
		end
	end, banPanel)

	scrollPanel:OnMouseWheeled(-1)
	banPanel:InvalidateLayout(false)
end

hook('OnBanDataChanged', function(pl, banData)
	concommand.Add("bpc", function() 
		if (banData != nil) then
			createBanPanel(banData)
		end
	end)
	RunConsoleCommand("bpc")
end)

hook.Add("HUDPaint","banInfo", function()
	if LocalPlayer():IsBanned() then
		draw.RoundedBox(5, 1660, 1010, 250, 50, Color(145, 145, 145, 200))
		surface.SetFont("ui.25")
		draw.SimpleText("Открыть бан-меню(F 3)", "ui.25", 1895, 1035, Color(255, 255, 255, 255), TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER)
	end
end)

hook.Add("PlayerButtonDown", "f3_info", function(ply, button)
	if IsFirstTimePredicted() and button == KEY_F3 and ply:IsBanned() then
		RunConsoleCommand("bpc")
	end
end)