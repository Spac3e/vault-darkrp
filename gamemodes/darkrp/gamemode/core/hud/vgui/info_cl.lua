local a = {}

function a:Init()
    self.Name = self:Add'DLabel'
    self.Name:Dock(FILL)
    self.Name:DockMargin(0, 0, 5, 0)
    self.Name:SetTextInset(5, 0)
    self.Name:SetFont(rp.hud.GetSecondaryFont())
    self.Name:SetTextColor(ui.col.White)
    self.Name:SetText('')

    self.Name.Paint = function(b, c, d)
        draw.RoundedBox(5, 0, 0, c, d, self.ColorSecondary)
    end

    self.Info = self:Add'DLabel'
    self.Info:Dock(RIGHT)
    self.Info:SetTextInset(5, 0)
    self.Info:SetFont(rp.hud.GetSecondaryFont())
    self.Info:SetTextColor(ui.col.White)
    self.Info:SetText('')

    self.Info.Paint = function(b, c, d)
        draw.RoundedBox(5, 0, 0, c, d, self.ColorSecondary)
    end

    self:SetTall(34)
end

function a:SetName(e)
    self.Name:SetText(e)
end

function a:SetInfo(f)
    self.Info:SetText(f)
end

function a:GetContentSize()
    local g, h = self.Name:GetContentSize()
    local i, j = self.Info:GetContentSize()

    return g + i + 20, self:GetTall()
end

function a:PerformLayout(c, d)
    self.Name:SizeToContents()
    self.Info:SizeToContents()
    self.Info:SetSize(self.Info:GetWide() + 10)
end

function a:Update()
end

function a:Paint(c, d)
end

vgui.Register('rp_hud_info', a, 'rp_hud_base')