local a = {}

AccessorFunc(a, 'm_bIsMenuComponent', 'IsMenu', FORCE_BOOL)
AccessorFunc(a, 'm_bDraggable', 'Draggable', FORCE_BOOL)
AccessorFunc(a, 'm_bSizable', 'Sizable', FORCE_BOOL)
AccessorFunc(a, 'm_bScreenLock', 'ScreenLock', FORCE_BOOL)
AccessorFunc(a, 'm_bDeleteOnClose', 'DeleteOnClose', FORCE_BOOL)
AccessorFunc(a, 'm_bPaintShadow', 'PaintShadow', FORCE_BOOL)
AccessorFunc(a, 'm_iMinWidth', 'MinWidth')
AccessorFunc(a, 'm_iMinHeight', 'MinHeight')
AccessorFunc(a, 'm_bBackgroundBlur', 'BackgroundBlur', FORCE_BOOL)

function a:Init()
    self:SetFocusTopLevel(true)
    self.btnClose = ui.Create('ui_button', self)
    self.btnClose:SetText('')

    self.btnClose.DoClick = function(b)
        surface.PlaySound('sup/ui/beep.ogg')
        self:Close()
    end

    self.btnClose.Paint = function(c, d, e)
        derma.SkinHook('Paint', 'WindowCloseButton', c, d, e)
    end

    self.lblTitle = ui.Create('DLabel', self)
    self.lblTitle:SetColor(ui.col.White)
    self.lblTitle:SetFont('ui.22')
    self:SetDraggable(true)
    self:SetSizable(false)
    self:SetScreenLock(false)
    self:SetDeleteOnClose(true)
    self:SetTitle('Window')
    self:SetSkin('SUP')
    self:SetMinWidth(50)
    self:SetMinHeight(50)
    self:SetPaintBackgroundEnabled(false)
    self:SetPaintBorderEnabled(false)
    self.m_fCreateTime = SysTime()
    self:DockPadding(5, 35, 5, 5)
    self:SetAlpha(0)
    self:FadeIn(0.2)

    hook('Think', self, function()
        if self.HandleMovement then
            self:HandleMovement()
        end

        if self.Anim then
            self.Anim:Run()
        end
    end)

    if self.InitDerived then
        self:InitDerived()
    end
end

function a:Focus()
    local f = {}
    self:SetBackgroundBlur(true)

    for g, h in ipairs(vgui.GetWorldPanel():GetChildren()) do
        if h:IsVisible() and h ~= self then
            f[#f + 1] = h
            h:SetVisible(false)
        end
    end

    self._OnClose = self.OnClose

    self.OnClose = function(self)
        for g, h in ipairs(f) do
            if IsValid(h) then
                h:SetVisible(true)
            end
        end

        self:_OnClose()
    end
end

function a:ShowCloseButton(i)
    self.btnClose:SetVisible(i)
end

function a:SetTitle(j)
    self.lblTitle:SetText(j)
end

function a:GetTitleHeight()
    return 35
end

function a:GetDockPos()
    return 5, self:GetTitleHeight()
end

function a:Center()
    self:InvalidateLayout(true)
    self:SetPos(ScrW() / 2 - self:GetWide() / 2, ScrH() / 2 - self:GetTall() / 2)
end

function a:Close(k)
    if self:GetDeleteOnClose() then
        self.Think = function() end
    end
    
    self:FadeOut(0.2, function() 
        if self:GetDeleteOnClose() then
            self:Remove()
        else
            self:SetVisible(false)
        end
    
        if k then
            k()
        end
    end)
    
    self:OnClose()
end

function a:OnClose()
end

function a:Think()
end

function a:IsActive()
    if self:HasFocus() then
        return true
    end
    
    if vgui.FocusedHasParent(self) then
        return true
    end
    
    return false
end

function a:HandleMovement()
    local l = math.Clamp(gui.MouseX(), 1, ScrW() - 1)
    local m = math.Clamp(gui.MouseY(), 1, ScrH() - 1)

    if self.Dragging then
        local n = l - self.Dragging[1]
        local o = m - self.Dragging[2]

        if self:GetScreenLock() then
            n = math.Clamp(n, 0, ScrW() - self:GetWide())
            o = math.Clamp(o, 0, ScrH() - self:GetTall())
        end

        self:SetPos(n, o)
    end

    if self.Sizing then
        local n = l - self.Sizing[1]
        local o = m - self.Sizing[2]
        local p, q = self:GetPos()

        if n < self.m_iMinWidth then
            n = self.m_iMinWidth
        elseif n > ScrW() - p and self:GetScreenLock() then
            n = ScrW() - p
        end

        if o < self.m_iMinHeight then
            o = self.m_iMinHeight
        elseif o > ScrH() - q and self:GetScreenLock() then
            o = ScrH() - q
        end

        self:SetSize(n, o)
        self:SetCursor('sizenwse')

        return
    end

    if self.Hovered and self.m_bSizable and l > self.x + self:GetWide() - 20 and m > self.y + self:GetTall() - 20 then
        self:SetCursor('sizenwse')

        return
    end

    if self.Hovered and self:GetDraggable() and m < self.y + 24 then
        self:SetCursor('sizeall')

        return
    end

    self:SetCursor('arrow')

    if self.y < 0 then
        self:SetPos(self.x, 0)
    end
end

function a:Paint(d, e)
    if self.m_bBackgroundBlur then
        Derma_DrawBackgroundBlur(self, self.m_fCreateTime)
    end

    derma.SkinHook('Paint', 'Frame', self, d, e)

    if self.TitleAnim then
        local r = math.Clamp((RealTime() - self.TitleAnim) / 0.7, 0, 1)
        self.TitleAnimDelta = r
        derma.SkinHook('Paint', 'FrameTitleAnim', self, d, e)

        if r == 2 then
            self.TitleAnim = nil
            self.TitleAnimDelta = nil
        end
    end

    return true
end

function a:PaintOver(d, e)
    derma.SkinHook('Paint', 'FrameLoading', self, d, e)
end

function a:OnMousePressed()
    if self.m_bSizable then
        if gui.MouseX() > self.x + self:GetWide() - 20 and gui.MouseY() > self.y + self:GetTall() - 20 then
            self.Sizing = {gui.MouseX() - self:GetWide(), gui.MouseY() - self:GetTall()}

            self:MouseCapture(true)

            return
        end
    end

    if self:GetDraggable() and gui.MouseY() < self.y + 24 then
        self.Dragging = {gui.MouseX() - self.x, gui.MouseY() - self.y}

        self:MouseCapture(true)

        return
    end
end

function a:OnMouseReleased()
    self.Dragging = nil
    self.Sizing = nil
    self:MouseCapture(false)
end

function a:FadeIn(s, k)
    self.Anim = Derma_Anim('Fade Panel', self, function(c, t, r, u)
        c:SetAlpha(r * 255)

        if t.Finished then
            self.Anim = nil
            self.TitleAnim = RealTime() + 0.25

            if k then
                k()
            end
        end
    end)

    if self.Anim then
        self.Anim:Start(s)
    end
end

function a:FadeOut(s, k)
    self.Anim = Derma_Anim('Fade Panel', self, function(c, t, r, u)
        c:SetAlpha(255 - r * 255)

        if t.Finished then
            self.Anim = nil

            if k then
                k()
            end
        end
    end)

    if self.Anim then
        self.Anim:Start(s)
    end
end

function a:SetLoading(v)
    self.ShowIsLoadingAnim = v
end

function a:PerformLayout()
    self.lblTitle:SizeToContents()
    self.lblTitle:SetPos(8, 4)
    self.btnClose:SetPos(self:GetWide() - 30, 0)
    self.btnClose:SetSize(30, 30)
end

vgui.Register('ui_frame', a, 'EditablePanel')
a = vgui.GetControlTable('ui_frame')
local w = a.SetSize

a.SetSize = function(self, d, e)
    if d <= 1 then
        d = d * ScrW()
    end

    if e <= 1 then
        e = e * ScrH()
    end

    w(self, d, e)
end

local x = a.SetWide

a.SetWide = function(self, d)
    if d <= 1 then
        d = d * ScrH()
    end

    x(self, d)
end

local y = a.SetTall

a.SetTall = function(self, e)
    if e <= 1 then
        e = e * ScrH()
    end

    y(self, e)
end