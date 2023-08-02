local a = {}

function a:SetText(b)
    self.Label = self.Label or ui.Create('DLabel', self)
    self.Label:SetFont('ui.18')
    self.Label:SetText(b)
end

function a:PerformLayout()
end

function a:SetConVar(c)
    self.Button.DoClick = function()
        self.Button:Toggle()
        cvar.SetValue(c, not cvar.GetValue(c))
    end

    self.Label:SetMouseInputEnabled(true)
    self.Label.OnMousePressed = self.Button.DoClick
    self:SetValue(cvar.GetValue(c) and 1 or 0)
    self:SetTextColor(ui.col.White)
end

function a:SizeToContents()
    local d, e = 40, 20
    self.Button:SetSize(d, e)

    if self.Label then
        self.Label:SizeToContents()
        e = math.max(e, self.Label:GetTall())
        self.Label:SetPos(d + 5, (e - self.Label:GetTall()) * 0.5 - 1)
        d = d + 10 + self.Label:GetWide()
    end

    self:SetSize(d, e)
end

vgui.Register('ui_checkbox', a, 'DCheckBoxLabel')