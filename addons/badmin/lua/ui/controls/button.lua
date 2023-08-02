local a = {}

function a:Init()
    self:SetContentAlignment(5)
    self:SetDrawBorder(true)
    self:SetPaintBackground(true)
    self:SetTall(22)
    self:SetMouseInputEnabled(true)
    self:SetKeyboardInputEnabled(true)
    self:SetCursor("hand")
    self:SetFont('ui.18')
    self:SetTextColor(ui.col.White)
end

function a:SetImageColor(b)
    if IsValid(self.m_Image) then
        self.m_Image:SetImageColor(b)
    end
end

function a:PerformLayout()
    if IsValid(self.m_Image) then
        self:SetContentAlignment(4)
        self.m_Image:SetPos(5, 5)
        self.m_Image:SetSize(self:GetTall() - 10, self:GetTall() - 10)
        surface.SetFont(self:GetFont())
        local c, d = surface.GetTextSize(self:GetText())
        local e = self.m_Image:GetWide() + 5
        self:SetTextInset(self:GetWide() * 0.5 - c * 0.5 + e * 0.5, 0)
    end

    DLabel.PerformLayout(self)
end

function a:Paint(f, g)
    derma.SkinHook('Paint', 'Button', self, f, g)

    return false
end

function a:DoClick()
    if self.ConfirmationEnabled then
        if self:IsConfirming() then
            self:ResetConfirmation()
            self:DoConfirm()
        else
            self.PreConfirmText = self:GetText()
            self:SetText(self.ConfirmationText or 'Click to confirm')
            local h = SysTime()
            self.ConfirmationTime = h

            if self.ConfirmationHoldEnabled ~= false then
                timer.Simple(self.ConfirmationHold or 3, function()
                    if IsValid(self) and self:IsConfirming() and self.ConfirmationTime == h then
                        self:ResetConfirmation()
                    end
                end)
            end
        end
    end
end

function a:DoConfirm()
end

function a:SetBackgroundColor(b)
    self.BackgroundColor = b
end

function a:ResetConfirmation()
    self:SetText(self.PreConfirmText)
    self.ConfirmedOnce = nil
    self.ConfirmationTime = nil
    self.PreConfirmText = nil
end

function a:EnableConfirmation(i)
    self.ConfirmationEnabled = i
end

function a:EnableConfirmationHold(i)
    self.ConfirmationHoldEnabled = i
end

function a:SetConfirmationText(j)
    self.ConfirmationText = j
end

function a:SetConfirmationHold(k)
    self.ConfirmationHold = k
end

function a:IsConfirming()
    return self.ConfirmationTime ~= nil
end

vgui.Register('ui_button', a, 'DButton')