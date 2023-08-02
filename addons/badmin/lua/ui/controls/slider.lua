local a = {}

function a:Init()
    self.ButtonContainer = ui.Create('Panel', self)
    self.ButtonContainer.Paint = function() end
    
    self.Button = ui.Create('ui_button', self.ButtonContainer)
    
    self.Button.OnMousePressed = function(b, c)
        if c == MOUSE_LEFT then
            self:StartDrag()
        end
    end
    
    self.Button:SetText('')
    
    self.Button.Paint = function(self, d, e)
        derma.SkinHook('Paint', 'SliderButton', self, d, e)
    end
    
    self:SetValue(0.5)
end

function a:PerformLayout()
    self:SetTall(20)
    self.ButtonContainer:SetPos(40, 0)
    self.ButtonContainer:SetSize(self:GetWide() - 40, self:GetTall())
    self.Button:SetSize(20, 20)
    self.Button:SetPos(self.Value * (self.ButtonContainer:GetWide() - 20), 0)
end

function a:Paint(d, e)
    derma.SkinHook('Paint', 'UISlider', self, d, e)
end

function a:Think()
    if self.Dragging then
        local f, g = self:CursorPos()
        f = f - 40
        f = math.Clamp(f - self.OffX, 0, self.ButtonContainer:GetWide() - 20)

        if self.Button.x ~= f then
            self:SetValue(f / (self.ButtonContainer:GetWide() - 20))
            self:OnChange(self.Value)
        end

        if not input.IsMouseDown(MOUSE_LEFT) then
            self:EndDrag()
        end
    end
end

function a:StartDrag()
    self.Dragging = true
    self.OffX = self.Button:CursorPos()
end

function a:EndDrag()
    self.Dragging = false
    self:OnMouseReleased(self.Value)
end

function a:OnMouseReleased(h)
end

function a:OnChange(h)
end

function a:SetValue(h)
    self.Value = h
    self.Button:SetPos(h * (self.ButtonContainer:GetWide() - 20), 0)
end

function a:GetValue()
    return self.Value
end

vgui.Register('ui_slider', a, 'Panel')