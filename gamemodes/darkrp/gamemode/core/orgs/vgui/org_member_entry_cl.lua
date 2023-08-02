local a = {}
local b = Color(51, 51, 51)

local function c(d)
    if d == 0 then
        return 'Давно'
    elseif d < 3600 then
        return 'Меньше часа'
    elseif d < 172800 then
        return math.floor(d / 3600) .. ' часов'
    else
        return math.floor(d / 86400) .. ' дней'
    end
end

function a:Init()
    self:SetTall(30)

    self.headerMember = ui.Create('ui_imagerow', function(e)
        e:Dock(TOP)
        e:SetTall(30)
        e:SetContentAlignment(4)
        e:SetTextInset(32, 0)

        e.DoClick = function(e)
            self:Toggle()
        end
    end, self)

    self.btnProfile = ui.Create('ui_button', function(f)
        f:Dock(TOP)
        f:SetTall(25)
        f:SetText('Открыть профиль')
        f:DockMargin(5, 5, 5, 5)

        f.DoClick = function(f)
            gui.OpenURL('https://steamcommunity.com/profiles/' .. self.Player.SteamID)
        end
    end, self)

    self.btnSteamID = ui.Create('ui_button', function(f)
        f:Dock(TOP)
        f:SetTall(25)
        f:SetText('Копировать SteamID')
        f:DockMargin(5, 0, 5, 5)

        f.DoClick = function(f)
            SetClipboardText(ba.InfoTo32(self.Player.SteamID))
            f:SetText('Скопировано!')

            timer.Simple(2.5, function()
                if IsValid(f) then
                    f:SetText('Копировать SteamID')
                end
            end)
        end
    end, self)

    self.btnRank = ui.Create('ui_button', function(f)
        f:Dock(TOP)
        f:SetTall(25)
        f:SetText('Выдать ранг')
        f:DockMargin(5, 0, 5, 5)

        f.DoClick = function(g)
            local h = ui.DermaMenu()
            local i = 0

            for j, k in ipairs(self.Ranks) do
                if k.Weight < self.Perms.Weight and k.Name ~= self.Player.Rank then
                    i = i + 1

                    h:AddOption(k.Name, function()
                        net.Start('rp.OrgSetRank')
                        net.WriteString(self.Player.SteamID)
                        net.WriteString(k.Name)
                        net.SendToServer()
                        self.Player.Rank = k.Name
                        self.Player.Weight = k.Weight
                        self.OrgMenu.PopulateMembers()
                        self.OrgMenu.ReassignRankPlayerCounts()
                    end)
                end
            end

            if i >= 1 then
                h:Open()
            else
                h:Remove()
            end
        end
    end, self)

    self.btnKick = ui.Create('ui_button', function(f)
        f:Dock(TOP)
        f:SetTall(25)
        f:SetText('Выгнать')
        f:DockMargin(5, 0, 5, 5)
        f:SetBackgroundColor(ui.col.Red)
        f:EnableConfirmation(true)

        f.DoConfirm = function(f)
            net.Start('rp.OrgKick')
            chat.AddText(self.Player.SteamID)
            net.WriteString(self.Player.SteamID)
            net.SendToServer()
            self:Toggle(true)
        end
    end, self)

    self.btnMakeOwner = ui.Create('ui_button', function(f)
        f:Dock(TOP)
        f:SetTall(25)
        f:SetText('Передать владельца')
        f:DockMargin(5, 0, 5, 5)
        f:SetBackgroundColor(ui.col.SUP)

        f.DoClick = function(g)
            ui.StringRequest('TПередать владельца', 'Вы уверены, что хотите сделать ' .. self.Player.Name .. ' в ' .. LocalPlayer():GetOrg() .. '\'новым владельцем? Введите YES для подтверждения.', '', function(l)
                if l:lower() == 'yes' then
                    -- head:Close()
                    net.Start('rp.PromoteOrgLeader')
                    net.WriteString(self.Player.SteamID)
                    net.SendToServer()
                end
            end)
        end
    end, self)
end

function a:Paint(m, n)
    draw.RoundedBox(5, 0, 0, m, n, b)
end

function a:Toggle(o)
    self.Opened = not self.Opened
    self.DisableUntil = SysTime() + .75

    if o then
        self:SizeTo(self:GetWide(), 0, .3, 0, .5, function()
            self:Remove()
            self.OrgMenu.CalculateMemberNumbers()
            self.OrgMenu.ReassignRankPlayerCounts()
        end)

        return
    end

    if self.Opened then
        local p

        if self.btnMakeOwner:IsVisible() then
            p = self.btnMakeOwner.y + self.btnMakeOwner:GetTall() + 5
        elseif self.btnKick:IsVisible() then
            p = self.btnKick.y + self.btnKick:GetTall() + 5
        elseif self.btnRank:IsVisible() then
            p = self.btnRank.y + self.btnRank:GetTall() + 5
        else
            p = self.btnSteamID.y + self.btnSteamID:GetTall() + 5
        end

        self:SizeTo(self:GetWide(), p, .3, 0, .5)
    else
        self:SizeTo(self:GetWide(), 30, .3, 0, .5)
    end
end

function a:SetOrgMenu(q)
    self.OrgMenu = q
end

function a:SetRanks(r)
    self.Ranks = r
end

function a:SetPermissions(s)
    self.Perms = s
    self.btnKick:SetVisible(self.Perms.Kick)
    self.btnRank:SetVisible(self.Perms.Rank)
    self.btnMakeOwner:SetVisible(self.Perms.Owner)
end

local t, u = utf8.char(0xf111), utf8.char(0xf017)

function a:SetPlayer(v)
    self.Player = v
    self.headerMember:SetPlayer(v.Name, v.SteamID)

    self.headerMember.PaintOver = function(f, m, n)
        surface.SetTextColor(ui.col.White)
        surface.SetFont('ForkAwesome')
        surface.SetTextPos(m - 14 - 3, n - 18)
        surface.DrawText(self.Player.IsOnline and t or u)
    end

    self.headerMember.lblLastSeen = ui.Create('DLabel', function(w)
        w:SetFont('ui.15')
        w:SetText(self.Player.IsOnline and 'В сети' or c(self.Player.LastConnect))
        w:SizeToContents()

        w.Think = function(w)
            w:SetPos(self.headerMember:GetWide() - w:GetWide() - 21, self.headerMember:GetTall() - w:GetTall() - 2)
        end
    end, self.headerMember)
end

vgui.Register('org_member_entry', a, 'Panel')