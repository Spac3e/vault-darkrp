local a = {}
local b = Color(51, 51, 51)
local c = Material'vgui/gradient-l'
local d = Material'vgui/gradient-r'

function a:Init()
    self:DockPadding(0, 5, 0, 5)

    self.pnlPusher = ui.Create('Panel', function(e)
        e:Dock(RIGHT)
    end, self)

    self.pnlContent = ui.Create('Panel', function(e)
        e:Dock(RIGHT)
    end, self)

    self.lblColor = ui.Create('ui_button', function(f)
        f:Dock(TOP)
        f:SetTall(30)
        f:SetText('Цвет организации')
        f:SetDisabled(true)
        f:SetCursor('arrow')
    end, self.pnlContent)

    self.ColorPicker = ui.Create('DColorMixer', function(e)
        e:Dock(FILL)
        e:DockMargin(0, 5, 0, 0)
        e:SetAlphaBar(false)
    end, self.pnlContent)

    self.pnlButtons = ui.Create('Panel', function(e)
        e:Dock(BOTTOM)
        e:DockMargin(0, 5, 0, 0)

        e.PerformLayout = function(e)
            local g = (e:GetWide() - 5) / 2
            self.btnSubmit:SetWide(g)
            self.btnCancel:SetWide(g)
        end
    end, self.pnlContent)

    self.btnSubmit = ui.Create('ui_button', function(f)
        f:SetText('Выбрать')
        f:Dock(LEFT)

        f.DoClick = function(f)
            local h = self:GetColor()

            if h ~= LocalPlayer():GetOrgColor() then
                net.Start('rp.SetOrgColor')
                net.WriteString(pcolor.ToHex(h))
                net.SendToServer()
            end
        end
    end, self.pnlButtons)

    self.btnCancel = ui.Create('ui_button', function(f)
        f:SetText('Отмена')
        f:Dock(RIGHT)

        f.DoClick = function(f)
            self:SetColor(LocalPlayer():GetOrgColor())
        end
    end, self.pnlButtons)

    self:SetColor(LocalPlayer():GetOrgColor())
end

function a:PerformLayout()
    local g = math.max(300, self:GetWide() / 3)
    self.pnlContent:SetWide(g)
    self.pnlPusher:SetWide((self:GetWide() - g) * 0.5)
end

function a:Paint(i, j)
    draw.RoundedBox(5, 0, 0, i, j, b)
    surface.SetDrawColor(self:GetColor())
    surface.SetMaterial(c)
    surface.DrawTexturedRect(i * .5, 0, i * .5, j)
    surface.SetMaterial(d)
    surface.DrawTexturedRect(0, 0, i * .5, j)
end

function a:SetColor(k)
    self.ColorPicker:SetColor(k)
end

function a:GetColor()
    return self.ColorPicker:GetColor()
end

function a:SetOrgMenu()
end

vgui.Register('org_color_picker', a, 'Panel')