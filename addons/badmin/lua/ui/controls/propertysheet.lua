local a = {}

function a:Paint(b, c)
    derma.SkinHook('Paint', 'PropertySheet', self, b, c)
end

function a:DockToFrame()
    local d = self:GetParent()
    local e, f = d:GetDockPos()
    self:SetPos(e, f - 5)
    self:SetSize(d:GetWide() - 10, d:GetTall() - f)
end

vgui.Register('ui_propertysheet', a, 'DPropertySheet')