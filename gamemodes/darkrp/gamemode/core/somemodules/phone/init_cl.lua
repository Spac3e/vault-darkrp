Phone = {}
Phone.Accepted = false

function Phone.StartCall(ply)
    net.Start('rp::PhoneSys.phone')

    net.WriteTable{
        ply = ply,
        act = 'call'
    }

    net.SendToServer()
end

function Phone.Call(ply)
    if IsValid(Phone.ActiveFrame) then return end
    Phone.ActiveFrame = ui.Create('ui_frame')
    Phone.ActiveFrame:SetSize(241, 102)
    Phone.ActiveFrame:SetPos(10, ScrH() / 2 - Phone.ActiveFrame:GetWide() / 2)
    local f = Phone.ActiveFrame
    f:SetTitle('Звонок')
    local f = Phone.ActiveFrame

    function f:Close()
        local m = DermaMenu()

        m:AddOption('Бросить трубку').DoClick = function()
            Phone.Deny()
            self:Remove()
        end

        m:Open()
    end

    local accept = ui.Create('DPanel', f)
    accept:SetWide(110)
    accept:SetPos(100, 50)
    accept:SetText('')
    local pt = nil

    function accept:Paint(w, h)
        if Phone.Accepted == true then
            if not pt then
                pt = CurTime()
            end

            local time = CurTime() - pt
            local ft = string.FormattedTime(math.floor(time))
            draw.DrawText(string.format('%s:%s:%s', ft.h, ft.m, ft.s), 'ui.22', w / 2, h / 2 - 9, Color(255, 255, 255), TEXT_ALIGN_CENTER)
        else
            draw.DrawText(string.rep('.', CurTime() % 4), 'ui.22', w / 2, h / 2 - 9, Color(255, 255, 255), TEXT_ALIGN_CENTER)
        end
    end

    slb = ui.Create("ui_button", Phone.ActiveFrame)
    slb:SetSize(154, 20)
    slb:SetPos(78, 78)
    slb:SetText("Бросить")
    slb:SetImage("icon16/phone_delete.png")
    slb:SetTextColor(Color(255, 255, 255))

    slb.DoClick = function(self)
        Phone.Deny()
    end

    local avatar = ui.Create("AvatarImage", f)
    avatar:SetPos(5, 34)
    avatar:SetPlayer(ply, 128)
    avatar:SetSize(64, 64)
    local lbl = ui.Create("DLabel", f)
    lbl:SetPos(78, 31)
    lbl:SetText("")
    lbl:SetSize(154, 20)

    lbl.Paint = function(self, w, h)
        local name = ply:Nick()

        if string.len(name) > 13 then
            name = string.sub(name, 1, 13) .. "..."
        end

        draw.DrawText(name, 'ui.22', w / 2, h / 2 - 9, Color(255, 255, 255), TEXT_ALIGN_CENTER)
    end
    --[[
	local lbl2 = ui.Create( "DLabel", f )

	lbl2:SetPos( 75, 60 )

	lbl2:SetText( ply:GetJobName() )

	lbl2:SetSize( 200, 20 )

	lbl2:SetColor(Color(255,255,255,255) )
	]]
end

function Phone.InCall(ply)
    if IsValid(Phone.ActiveFrame) then return end
    Phone.ActiveFrame = ui.Create('ui_frame')
    Phone.ActiveFrame:SetSize(241, 102)
    Phone.ActiveFrame:SetPos(10, ScrH() / 2 - Phone.ActiveFrame:GetWide() / 2)
    local f = Phone.ActiveFrame
    f:SetTitle('Звонок')

    function f:Close()
        local m = DermaMenu()

        m:AddOption('Заглушить звонок').DoClick = function()
            self:SetAlpha(100)
            Phone.Mute()
        end

        m:AddSpacer()

        m:AddOption('Бросить трубку').DoClick = function()
            Phone.Deny()
            self:Remove()
        end

        m:Open()
    end

    local decline = ui.Create('ui_button', f)
    decline:SetSize(154, 20)
    decline:SetPos(78, 78)
    decline:SetText('Бросить')
    decline:SetImage("icon16/phone_delete.png")

    function decline:DoClick()
        Phone.Deny()
    end

    local accept = ui.Create('ui_button', f)
    accept:SetSize(154, 20)
    accept:SetPos(78, 54)
    accept:SetText('Принять')
    accept:SetImage("icon16/phone_add.png")

    function accept:DoClick()
        net.Start'rp::PhoneSys.phone'
        net.WriteTable{
            act = 'accept'
        }
        net.SendToServer()
        f:Remove()
        Phone.Call(ply)
    end

    local avatar = ui.Create("AvatarImage", f)
    avatar:SetPos(5, 34)
    avatar:SetPlayer(ply, 128)
    avatar:SetSize(64, 64)
    local lbl = ui.Create("DLabel", f)
    lbl:SetPos(78, 31)
    lbl:SetText("")
    lbl:SetSize(154, 20)

    lbl.Paint = function(self, w, h)
        local name = ply:Nick()

        if string.len(name) > 13 then
            name = string.sub(name, 1, 13) .. "..."
        end

        draw.DrawText(name, 'ui.22', w / 2, h / 2 - 9, Color(255, 255, 255), TEXT_ALIGN_CENTER)
    end
    --[[
	local lbl2 = ui.Create( "DLabel", f )

	lbl2:SetPos( 75, 60 )

	lbl2:SetText( ply:GetJobName() )

	lbl2:SetSize( 200, 20 )

	lbl2:SetColor(Color(255,255,255,255) )]]
end

function Phone.Deny()
    net.Start('rp::PhoneSys.phone')
    net.WriteTable{
        act = 'deny'
    }
    net.SendToServer()
end

function Phone.MuteForever()
    net.Start('rp::PhoneSys.phone')
    net.WriteTable{
        act = 'muteforever'
    }
    net.SendToServer()
end

function Phone.Mute()
    net.Start('rp::PhoneSys.phone')
    net.WriteTable{
        act = 'mute'
    }
    net.SendToServer()
end

net.Receive('rp::PhoneSys.phone_client', function()
    local t = net.ReadTable()

    if t.act == 'in' then
        Phone.InCall(t.ply)
    end

    if t.act == 'out' then
        Phone.Call(t.ply)
    end

    if t.act == 'accept' then
        Phone.Accepted = true
    end

    if t.act == 'deny' then
        Phone.Accepted = false

        if IsValid(Phone.ActiveFrame) then
            Phone.ActiveFrame:Remove()
        end
    end
end)
