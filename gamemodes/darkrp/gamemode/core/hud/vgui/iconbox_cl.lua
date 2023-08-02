local a = {}

function a:Init()
    self.BaseClass.Init(self)
    self.Progress = 1
    self.Title = self:Add'DLabel'
    self.Title:SetFont(rp.hud.GetFont())
    self.Title:SetTextColor(ui.col.White)
    self:SetSize(34, 34)
end

function a:GetProgress()
    return 1
end

function a:SetText(b)
    if not b then return end
    self.Value = b
    self.Title:SetText(b)
    local c, d = self.Title:GetContentSize()
    self:SetWide(c + 44)
end

function a:SetProgress(e)
    self.Progress = e
end

function a:Update()
    if not self.GetString then return end
    local f = self:GetString()
    if self.Value == f then return end
    self:SetText(f)
    self:SetProgress(self:GetProgress())
    self.BaseClass.Update(self)
end

function a:PerformLayout(c, d)
    self.Title:SetPos(39, 0)
    self.Title:SizeToContentsX()
    self.Title:SetTall(d)
end

function a:Paint(c, d)
    draw.Blur(self)

    if self.Value then
        draw.RoundedBox(5, 0, 0, c, d, ui.col.Background)
        draw.RoundedBoxEx(5, d, 0, (c - d) * self.Progress, d, self.ColorSecondary, false, true, false, true)
        draw.RoundedBoxEx(5, 0, 0, d, d, self.ColorPrimary, true, false, true, false)
        surface.SetDrawColor(255, 255, 255)
        surface.SetMaterial(self.Material)
        surface.DrawTexturedRect(5, 5, 24, 24)
    else
        draw.RoundedBox(5, 0, 0, d, d, self.ColorPrimary)
        surface.SetDrawColor(255, 255, 255)
        surface.SetMaterial(self.Material)
        surface.DrawTexturedRect(5, 5, 24, 24)
    end
end

vgui.Register('rp_hud_iconbox', a, 'rp_hud_base')