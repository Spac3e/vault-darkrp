local a = {}

function a:Init()
    self.parent = self:GetParent()
    self.scrollButton = vgui.Create('Panel', self)

    self.scrollButton.OnMousePressed = function(b, c)
        if c == MOUSE_LEFT and not self:GetParent().ShouldHideScrollbar then
            local d, e = b:CursorPos()
            b.scrolling = true
            b.mouseOffset = e
        end
    end

    self.scrollButton.OnMouseReleased = function(b, c)
        if c == MOUSE_LEFT then
            b.scrolling = false
            b.mouseOffset = nil
        end
    end

    self.height = 0
end

function a:Think()
    if self.scrollButton.scrolling then
        if not input.IsMouseDown(MOUSE_LEFT) then
            self.scrollButton:OnMouseReleased(MOUSE_LEFT)

            return
        end

        local d, e = self.scrollButton:CursorPos()
        local f = e - self.scrollButton.mouseOffset
        local g = self.parent:GetCanvas():GetTall() - self.parent:GetTall()
        local h = (self.scrollButton.y + f) / (self:GetTall() - self.height)
        self.parent.yOffset = math.Clamp(h * g, 0, g)
        self.parent:InvalidateLayout()
    end
end

function a:PerformLayout()
    local g = self.parent:GetCanvas():GetTall() - self.parent:GetTall()
    self:SetPos(self.parent:GetWide() - self:GetWide(), 0)
    self.heightRatio = self.parent:GetTall() / self.parent:GetCanvas():GetTall()
    self.height = math.Clamp(math.ceil(self.heightRatio * self.parent:GetTall()), 20, math.huge)
    self.scrollButton:SetSize(self:GetWide() - 4, self.height)
    self.scrollButton:SetPos((self:GetWide() - self.scrollButton:GetWide()) * 0.5, math.Clamp(self.parent.yOffset / g, 0, 1) * (self:GetTall() - self.height))
end

function a:Paint(i, j)
    if self:GetParent().ShouldHideScrollbar then return end
    derma.SkinHook('Paint', 'UIScrollBar', self, i, j)
end

function a:OnMouseWheeled(k)
    self.parent:OnMouseWheeled(k)
end

vgui.Register('ui_scrollbar', a, 'Panel')
local l = {}

function l:Init()
    self.scrollBar = vgui.Create('ui_scrollbar', self)
    self.scrollBar:SetMouseInputEnabled(true)
    self.contentContainer = vgui.Create('Panel', self)
    self.contentContainer:SetMouseInputEnabled(true)

    self.contentContainer.PerformLayout = function(b)
        self:PerformLayout()
        self.scrollBar:PerformLayout()
    end

    self.yOffset = 0
    self.ySpeed = 0
    self.scrollSize = 4
    self.SpaceTop = 1
    self.Padding = 0
    self.scrollBar:Dock(RIGHT)
    self.scrollBar:SetWidth(12)

    function self.contentContainer.OnChildRemoved(b, m)
        self:PerformLayout()
    end
end

function l:Reset()
    self:GetCanvas():Clear(true)
    self.yOffset = 0
    self.ySpeed = 0
    self.scrollSize = 1
    self:PerformLayout()
end

function l:AddItem(m)
    m:SetParent(self:GetCanvas())
    self:PerformLayout()

    return m
end

function l:SetSpacing(n)
    self.SpaceTop = n
end

function l:SetPadding(n)
    self.Padding = n
end

function l:GetCanvas()
    return self.contentContainer
end

function l:SetScrollSize(o)
    self.scrollSize = o
end

function l:ScrollTo(p)
    self.yOffset = p
    self:InvalidateLayout()
end

function l:OnMouseWheeled(k)
    if k > 0 and self.ySpeed < 0 or k < 0 and self.ySpeed > 0 then
        self.ySpeed = 0
    else
        self.ySpeed = self.ySpeed + k * self.scrollSize
    end

    if system.IsOSX() then
        self.ySpeed = self.ySpeed * 0.1
    end

    self:PerformLayout()
end

function l:SetOffset(q)
    local g = self:GetCanvas():GetTall() - self:GetTall()

    if g < 0 then
        g = 0
    end

    self.yOffset = math.Clamp(q, 0, g)
    self:PerformLayout()
    if self.yOffset == 0 or self.yOffset == g then return true end
end

function l:Think()
    if self.ySpeed ~= 0 then
        if self:SetOffset(self.yOffset - self.ySpeed) then
            self.ySpeed = 0
        else
            if self.ySpeed < 0 then
                self.ySpeed = math.Clamp(self.ySpeed + FrameTime() * self.scrollSize * 4, self.ySpeed, 0)
            else
                self.ySpeed = math.Clamp(self.ySpeed - FrameTime() * self.scrollSize * 4, 0, self.ySpeed)
            end
        end
    end
end

function l:PerformLayout()
    local r = self:GetCanvas()
    local p = 0

    if self.NoAutoLayout then
        for s, t in ipairs(r:GetChildren()) do
            local u = t.y + t:GetTall()

            if u > p then
                p = u
            end
        end
    else
        local v

        for s, t in ipairs(r:GetChildren()) do
            if not t:IsVisible() and self.HideInvisible then continue end
            local w = p + (s > 1 and self.Padding or 0)

            if t.x ~= self.Padding or t.y ~= w then
                t:SetPos(math.max(0, self.Padding), w)
            end

            if t:GetWide() ~= r:GetWide() - self.Padding * 2 then
                t:SetWide(math.min(r:GetWide(), r:GetWide() - self.Padding * 2))
            end

            p = t.y + t:GetTall() + self.SpaceTop + self.Padding
            v = t
        end

        p = v and v.y + v:GetTall() or p
    end

    if r:GetTall() ~= p then
        r:SetTall(p)
    end

    if (self.ShouldHideScrollbar or r:GetTall() <= self:GetTall()) and self.scrollBar:IsVisible() then
        r:SetTall(self:GetTall())
        self.scrollBar:SetVisible(false)
        self.scrollBar:SetWide(0)
    elseif not self.ShouldHideScrollbar and r:GetTall() > self:GetTall() and not self.scrollBar:IsVisible() then
        self.scrollBar:SetVisible(true)
        self.scrollBar:SetWide(12)
    end

    local g = self:GetCanvas():GetTall() - self:GetTall()

    if self.yOffset > g then
        self.yOffset = g
    end

    if self.yOffset < 0 then
        self.yOffset = 0
    end

    local x = self:GetWide() - self.scrollBar:GetWide()

    if r:GetWide() ~= x then
        r:SetWide(x)
    end

    if r.x ~= 0 or r.y ~= -self.yOffset then
        r:SetPos(0, -self.yOffset)
        self.scrollBar:InvalidateLayout()
    end
end

function l:IsAtMaxOffset()
    local g = math.Clamp(self:GetCanvas():GetTall() - self:GetTall(), 0, math.huge)

    return self.yOffset == g
end

function l:Paint(i, j)
end

function l:HideScrollbar(y)
    self.ShouldHideScrollbar = y
end

function l:DockToFrame()
    local z = self:GetParent()
    local A, p = z:GetDockPos()
    self:SetPos(A, p)
    self:SetSize(z:GetWide() - 10, z:GetTall() - (p + 5))
end

vgui.Register('ui_scrollpanel', l, 'Panel')