local a = {}

function a:Init()
    self.Vertical = true
    self.Button = ui.Create('ui_button', self)

    self.Button.OnMousePressed = function(b, c)
        if c == MOUSE_LEFT then
            b:GetParent():StartDrag()
        end
    end

    self.Button:SetText('')
    self:SetValue(0.5)
end

function a:PerformLayout()
    self:SetWide(16)
    self.Button:SetSize(16, 16)
    self.Button:SetPos(0, self.Value * (self:GetTall() - 16))
end

function a:Paint(d, e)
    derma.SkinHook('Paint', 'UISlider', self, d, e)
end

function a:Think()
    if self.Dragging then
        local f, g = self:CursorPos()
        g = math.Clamp(g - self.OffY, 0, self:GetTall() - 16)

        if self.Button.y ~= g then
            self:SetValue(g / (self:GetTall() - 16))
            self:OnChange(self.Value)
        end

        if not input.IsMouseDown(MOUSE_LEFT) then
            self:EndDrag()
        end
    end
end

function a:StartDrag()
    self.Dragging = true
    _, self.OffY = self.Button:CursorPos()
end

function a:EndDrag()
    self.Dragging = false
end

function a:OnChange(h)
end

function a:SetValue(h)
    self.Value = h
    self.Button:SetPos(h * (self:GetTall() - 16), 0)
end

function a:GetValue()
    return self.Value
end

vgui.Register('ui_slider_vertical', a, 'Panel')