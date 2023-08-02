local a = {}

function a:Init()
    self.lblEditing = ui.Create('ui_button', function(b)
        b:SetText('Редактирование MoTD')
        b:SetTall(ui.SpacerHeight)
        b:SetDisabled(true)
        b:DockMargin(0, 0, 0, -1)
        b:Dock(TOP)
        b:SetCursor('arrow')

        b.Corners = {true, true, false, false}
    end, self)

    self.TextEntry = ui.Create('DTextEntry', function(c)
        c:Dock(FILL)
        c:SetMultiline(true)
        c:SetFont('ui.22')
        c:RequestFocus()

        c.OnChange = function(d)
            self:OnUpdated(self.btnDarkTheme:GetChecked(), d:GetValue())
        end
    end, self)

    self.settingsBG = ui.Create('ui_button', function(b)
        b:SetText('')
        b:SetTall(ui.SpacerHeight)
        b:SetDisabled(true)
        b:DockMargin(0, 0, 0, -1)
        b:Dock(TOP)
        b:SetCursor('arrow')

        b.Corners = {false, false, false, false}
    end, self)

    self.btnDarkTheme = ui.Create('DCheckBoxLabel', function(e)
        e:DockMargin(5, 5, 5, 5)
        e:SetTall(35)
        e:Dock(LEFT)
        e:SetText("Тёмная Тема")
        e:SetFont('ui.22')

        e.OnChange = function(d)
            self:OnUpdated(d:GetChecked(), self.TextEntry:GetValue())
        end
    end, self.settingsBG)

    self.helpBtn = ui.Create('ui_button', function(b)
        b:SetText("Спец-Знаки")
        b:SetFont('ui.22')
        b:SizeToContents()
        b:SetTall(25)
        b:Dock(RIGHT)

        b.DoClick = function(d)
            gui.OpenURL("https://guides.github.com/features/mastering-markdown/")
        end
    end, self.settingsBG)
end

function a:Paint(f, g)
    surface.SetDrawColor(0, 0, 0, 255)
    surface.DrawRect(0, 0, f, g)
end

function a:OnUpdated(h, i)
end

function a:SetValue(h, i)
    self.btnDarkTheme:SetChecked(h)
    self.TextEntry:SetValue(i)
end

vgui.Register('org_motd_editor', a, 'Panel')