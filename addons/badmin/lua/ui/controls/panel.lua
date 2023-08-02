local a = {}
Derma_Hook(a, 'Paint', 'Paint', 'Panel')

function a:DockToFrame()
    local b = self:GetParent()
    local c, d = b:GetDockPos()
    self:SetPos(c, d)
    self:SetSize(b:GetWide() - 10, b:GetTall() - (d + 5))
end

vgui.Register('ui_panel', a, 'Panel')