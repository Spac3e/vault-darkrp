local a, b = utf8.char(0xf0ab), utf8.char(0xf0aa)

local c = {}

function c:Init()
    self.Collapsed = false
    self.Header = ui.Create('ui_button', self)
    self.Header:SetDisabled(true)
    
    self.Header.Paint = function(d, e, f)
        derma.SkinHook("Paint", "Button", d, e, f)
        if d:IsHovered() or self.CollapseBtn:IsHovered() then
            draw.RoundedBox(5, 0, 0, e, f, ui.col.Hover)
        end
    end
    
    self.Header.OnMousePressed = function(d ,g)
        if g == MOUSE_LEFT then
            self:Collapse(not self:IsCollapsed())
        end
    end
    
    self.CollapseBtn = ui.Create('ui_button', self)
    self.CollapseBtn:SetFont('ForkAwesome')
    self.CollapseBtn:SetText(b)
    self.CollapseBtn:SetToolTip('Collapse')
    self.CollapseBtn.Paint = function() end
    self.CollapseBtn.DoClick = function()
        self:Collapse(not self:IsCollapsed())
    end
    
    self.Container = ui.Create('DPanel', self)
end

function c:SetTall(f)
    self.OriginalTall = f + ui.SpacerHeight
    self.BaseClass.SetTall(self, self.OriginalTall)
end

function c:SetText(h)
    self.Header:SetText(h)
end

function c:AddItem(i)
    i:SetParent(self.Container)
end

function c:Collapse(j, k)
    self.Collapsed = j
    local l = j and ui.SpacerHeight or self.OriginalTall

    if k then
        self.BaseClass.SetTall(self, l)
    else
        self.TargetHeight = l
    end

    self.CollapseBtn:SetToolTip(j and 'Expand' or 'Collapse')
    self.CollapseBtn:SetText(j and a or b)
end

function c:IsCollapsed()
    return self.Collapsed
end

function c:OnCollapsing()
end

function c:Think()
    if self.TargetHeight and self:GetTall() ~= self.TargetHeight then
        local m = self:GetTall()
        local n = m > self.TargetHeight and -1 or 1
        m = m + FrameTime() * (m - self.TargetHeight * -n) * 8 * n

        if math.abs(m - self.TargetHeight) < 1 then
            m = self.TargetHeight
            self.TargetHeight = nil
        end

        self.BaseClass.SetTall(self, m)
        self.OnCollapsing(self)
    end
end

function c:PerformLayout(e, f)
    self.Header:SetPos(0, 0)
    self.Header:SetSize(e, ui.SpacerHeight)
    self.Container:SetPos(0, ui.SpacerHeight)
    self.Container:SetSize(e, f - ui.SpacerHeight)
    self.CollapseBtn:SetPos(e - ui.SpacerHeight, 0)
    self.CollapseBtn:SetSize(ui.SpacerHeight, ui.SpacerHeight)
end

vgui.Register('ui_collapsible_section', c, 'DPanel')