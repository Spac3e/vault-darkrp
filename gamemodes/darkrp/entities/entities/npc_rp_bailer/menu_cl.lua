local a = {}

function a:Init()
    self.Players = ui.Create('ui_listview', self)
    self.Players:Dock(TOP)
    self.Players:DockMargin(0, 0, 0, 5)
    self.Players:SetPlaceholderText('Никто не арестован!')

    local b = table.Filter(player.GetAll(), function(pl)
        return pl:IsArrested()
    end)

    local function d(c)
        local e = self.Players:AddPlayer(c)
        e:SetContentAlignment(4)
        e:SetTextInset(32, 0)

        e.PaintOver = function(f, g, h)
            if c:IsArrested() then
                draw.SimpleText(string.FormattedTime(c:GetArrestTime(), '%02i:%02i'), 'ui.12', g - 2, 2, ui.col.White, TEXT_ALIGN_RIGHT, TEXT_ALIGN_TOP)
                draw.SimpleText(rp.FormatMoney(c:GetBailPrice(LocalPlayer())), 'ui.12', g - 2, h - 2, ui.col.White, TEXT_ALIGN_RIGHT, TEXT_ALIGN_BOTTOM)
            end
        end

        e.Player = c
    end

    for i, c in ipairs(b) do
        d(pl)
    end

    hook('nw.ArrestedInfo', self, function(self, j, k, l)
        if k == nil then
            for i, c in ipairs(self.Players.Rows) do
                if c.Player == j then
                    c:Remove()
                    break
                end
            end
        else
            d(j)
        end
    end)

    self.Bail = ui.Create('ui_button', self)
    self.Bail:SetText'Выбрать заключённого'
    self.Bail:SetEnabled(false)
    self.Bail:Dock(TOP)

    self.Bail.Think = function(f)
        local m = self.Players:GetSelected()

        if IsValid(m) and IsValid(m.Player) and m.Player:IsArrested() then
            local n = m.Player:GetBailPrice(LocalPlayer())
            local o = LocalPlayer():CanAfford(n)
            f:SetText('Bail ' .. m.Player:Name() .. ' (' .. (o and rp.FormatMoney(n) or 'Cannot Afford!') .. ')')
            f:SetEnabled(o)
        else
            f:SetText'Выбрать заключённого'
            f:SetEnabled(false)
        end
    end

    self.Bail.DoClick = function(f)
        local m = self.Players:GetSelected()
        net.Start'rp.bail.BailPlayer'
        net.WritePlayer(m.Player)
        net.WriteEntity(self.Machine)
        net.SendToServer()
        m:Remove()
    end

    self:SetTitle'Залог'
    self:SetSize(500, 400)
    self:Center()
    self:MakePopup()
end

function a:PerformLayout(g, h)
    self.BaseClass.PerformLayout(self, g, h)
    local p, q = self:GetDockPadding()
    self.Players:SetTall(h - ui.ButtonHeight - q - 10)
    self.Bail:SetTall(ui.ButtonHeight)
end

function a:Think()
    if not LocalPlayer():Alive() then
        self:Remove()
    end
end

vgui.Register('rp_bail_frame', a, 'ui_frame')
a = {}

function a:Think()
    self.BaseClass.Think(self)
    local n = LocalPlayer():GetBailPrice(LocalPlayer())
    self.BtnYes:SetEnabled(LocalPlayer():CanAfford(n))
    self:SetText('Would you like to bail yourself for ' .. rp.FormatMoney(n) .. '?')
end

function a:Answer(r)
    if r then
        net.Start'rp.bail.BailPlayer'
        net.WritePlayer(LocalPlayer())
        net.SendToServer()
    end

    self:Remove()
end

vgui.Register('ba_bail_question', a, 'rp_question_panel')

hook('nw.ArrestedInfo', 'rp.bail.nw.ArrestedInfo', function(j, k, l)
    if j == LocalPlayer() then
        if k ~= nil then
            timer.Create('SelfBail', 30, 1, function()
                if LocalPlayer():IsArrested() then
                    rp.question.AddPanel(ui.Create('ba_bail_question'), LocalPlayer():GetArrestTime() - 1, 'SelfBail')
                end
            end)
        else
            if rp.question.Exists('SelfBail') then
                rp.question.Destroy('SelfBail')
            end

            if timer.Exists('SelfBail') then
                timer.Remove('SelfBail')
            end
        end
    end
end)