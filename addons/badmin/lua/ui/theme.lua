ui.SpacerHeight = 35
ui.ButtonHeight = 30

local a = {
    PrintName = 'SUP',
    Author = 'xide'
}

local b = ui.col.SUP
local c = ui.col.Gradient
local d = ui.col.Header
local e = ui.col.Background
local f = ui.col.Outline
local g = ui.col.Hover
local h = ui.col.Button
local i = ui.col.ButtonHover
local j = ui.col.Close
local k = ui.col.CloseBackground
local l = ui.col.CloseHovered
local m = ui.col.OffWhite
local n = ui.col.FlatBlack
local o = ui.col.Black
local p = ui.col.White
local q = ui.col.Red
local r = ui.col.Green
local s = Material'gui/gradient_down'
local t = Material'sup/ui/check.png'
local u = Material'sup/ui/x.png'

function a:PaintFrame(self, v, w)
    if self.Blur ~= false then
        draw.Blur(self)
    end

    draw.RoundedBoxEx(5, 0, 0, v, 30, d, true, true, false, false)

    if self.Accent then
        draw.RoundedBox(5, 0, 0, 3, 30, b)
    end

    draw.RoundedBox(5, 0, 0, v, w, e)
end

function a:PaintFrameLoading(self, v, w)
    if self.ShowIsLoadingAnim then
        draw.RoundedBox(5, 0, 27, v, w - 27, e)
        local x = SysTime() * 5
        draw.NoTexture()
        surface.SetDrawColor(255, 255, 255)
        surface.DrawArc(v * 0.5, w * 0.5, 41, 46, x * 80, x * 80 + 180, 20)
    end
end

function a:PaintFrameTitleAnim(self, v, w)
    local y = self.TitleAnimDelta
    local z = b.a
    b.a = y * 255
    draw.RoundedBox(5, 0, 0, 3, 30, b)
    b.a = z

    if y == 1 then
        self.Accent = true
    end
end

function a:PaintPanel(self, v, w)
    draw.RoundedBox(5, 0, 0, v, w, e)
end

function a:PaintShadow()
end

function a:PaintButton(self, v, w)
    if not self.m_bBackground then return end

    if self:GetDisabled() then
        if self.Corners then
            draw.RoundedBoxEx(5, 0, 0, v, w, self.BackgroundColor or ui.col.FlatBlack, unpack(self.Corners))
        else
            draw.RoundedBox(5, 0, 0, v, w, self.BackgroundColor or ui.col.FlatBlack)
        end
    else
        if self.Corners then
            draw.RoundedBoxEx(5, 0, 0, v, w, self.BackgroundColor or ui.col.Button, unpack(self.Corners))
        else
            draw.RoundedBox(5, 0, 0, v, w, self.BackgroundColor or ui.col.Button)
        end

        if self:IsHovered() or self.Active then
            if self.Corners then
                draw.RoundedBoxEx(5, 0, 0, v, w, ui.col.Hover, unpack(self.Corners))
            else
                draw.RoundedBox(5, 0, 0, v, w, ui.col.Hover)
            end
        end
    end
end

local function A(B, C, D, E, F)
    local G = C + B * 1 - C
    local H = D + B * 1 - D
    local I = 64
    local J = 2 * math.pi / I
    local K = {}
    X, Y = E - B, F - B

    for L = 0, I - 1 do
        local M = J * L % I
        local N = X + B * math.cos(M)
        local O = Y + B * math.sin(M)

        if L == I / 4 - 1 then
            X, Y = C + B, F - B

            table.insert(K, {
                x = X,
                y = Y,
                u = G,
                v = H
            })
        elseif L == I / 2 - 1 then
            X, Y = C, B

            table.insert(K, {
                x = X,
                y = Y,
                u = G,
                v = H
            })

            X = C + B
        elseif L == 3 * I / 4 - 1 then
            X, Y = E - B, 0

            table.insert(K, {
                x = X,
                y = Y,
                u = G,
                v = H
            })

            Y = B
        end

        table.insert(K, {
            x = N,
            y = O,
            u = G,
            v = H
        })
    end

    return K
end

local P = Material("effects/flashlight001")

function a:PaintImageButton(self, v, w)
    if not self.Poly or (self.LastW ~= v or self.LastH ~= w) then
        self.Poly = A(5, 0, 0, v, w)
        self.LastW = v
        self.LastH = w
    end

    render.ClearStencil()
    render.SetStencilEnable(true)
    render.SetStencilWriteMask(1)
    render.SetStencilTestMask(1)
    render.SetStencilFailOperation(STENCILOPERATION_REPLACE)
    render.SetStencilPassOperation(STENCILOPERATION_ZERO)
    render.SetStencilZFailOperation(STENCILOPERATION_ZERO)
    render.SetStencilCompareFunction(STENCILCOMPARISONFUNCTION_NEVER)
    render.SetStencilReferenceValue(1)
    draw.NoTexture()
    surface.SetMaterial(P)
    surface.SetDrawColor(o)
    surface.DrawPoly(self.Poly)
    render.SetStencilFailOperation(STENCILOPERATION_ZERO)
    render.SetStencilPassOperation(STENCILOPERATION_REPLACE)
    render.SetStencilZFailOperation(STENCILOPERATION_ZERO)
    render.SetStencilCompareFunction(STENCILCOMPARISONFUNCTION_EQUAL)
    render.SetStencilReferenceValue(1)

    if self.Material then
        surface.SetDrawColor(255, 255, 255)
        surface.SetMaterial(self.Material)
        surface.DrawTexturedRect(0, 0, v, w)
    end

    if IsValid(self.AvatarImage) then
        self.AvatarImage:SetPaintedManually(false)
        self.AvatarImage:PaintManual()
        self.AvatarImage:SetPaintedManually(true)
    end

    render.SetStencilEnable(false)
    render.ClearStencil()

    if self.Hovered then
        draw.RoundedBox(5, 0, 0, v, w, g)
    end
end

function a:PaintImageRow(self, v, w)
    if self.Active then
        draw.RoundedBox(5, 0, 0, v, w, n)

        return
    else
        draw.RoundedBox(5, 0, 0, v, w, self.BackgroundColor or e)
    end

    if self:IsHovered() then
        draw.RoundedBox(5, 0, 0, v, w, g)
    end
end

local Q = utf8.char(0xf00d)

function a:PaintWindowCloseButton(R, v, w)
    if not R.m_bBackground then return end
    draw.RoundedBoxEx(5, 0, 0, v, w, R.Hovered and l or k, false, true, false, false)
    draw.SimpleText(Q, 'ForkAwesome', v * 0.5, w * 0.5, ui.col.White, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
end

function a:PaintTransparentWindowCloseButton(R, v, w)
    if not R.m_bBackground then return end
    surface.SetDrawColor(R.Hovered and l or j)
    local S = math.floor(v / 2 - 5)
    local T = math.floor(w / 2 - 5)
    render.PushFilterMin(3)
    render.PushFilterMag(3)
    surface.DrawLine(S, T, S + 10, T + 10)
    surface.DrawLine(S, T + 10, S + 10, T)
    render.PopFilterMag()
    render.PopFilterMin()
end

function a:PaintVScrollBar(self, v, w)
end

function a:PaintButtonUp(self, v, w)
end

function a:PaintButtonDown(self, v, w)
end

function a:PaintButtonLeft(self, v, w)
end

function a:PaintButtonRight(self, v, w)
end

local U = ui.col.SUP:Copy()
U.a = 180

function a:PaintScrollBarGrip(self, v, w)
    draw.RoundedBox(5, 0, 0, v, w, U)
end

function a:PaintScrollPanel(self, v, w)
    draw.RoundedBox(5, 0, 0, v, w, e)
end

function a:PaintUIScrollBar(self, v, w)
    local N = self.scrollButton.x
    draw.RoundedBox(5, N, 0, v - N - N, w, ui.col.FlatBlack)
    draw.RoundedBox(5, N, self.scrollButton.y, v - N - N, self.height, U)
end

function a:PaintUISlider(self, v, w)
    a:PaintPanel(self, v, w)
    draw.RoundedBox(5, 1, 1, v - 2, w - 2, n)

    if self.Vertical then
        draw.RoundedBox(5, 1, self:GetValue() * w, v - 2, w - self:GetValue() * w, b)
    else
        draw.RoundedBox(5, 41, 1, self:GetValue() * (v - 40) - self:GetValue() * 16, w - 2, b)
        draw.SimpleText(math.ceil(self:GetValue() * 100) .. '%', 'ui.18', 20, w * 0.5, p, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
    end
end

function a:PaintSliderButton(self, v, w)
    draw.RoundedBox(5, 0, 0, v, w, self:IsHovered() and i or m)
end

function a:PaintTextEntry(self, v, w)
    draw.RoundedBox(5, 0, 0, v, w, m)

    if self.GetPlaceholderText and self.GetPlaceholderColor and self:GetPlaceholderText() and self:GetPlaceholderText():Trim() ~= "" and self:GetPlaceholderColor() and (not self:GetText() or self:GetText() == "") then
        local V = self:GetText()
        local W = self:GetPlaceholderText()

        if W:StartWith("#") then
            W = W:sub(2)
        end

        W = language.GetPhrase(W)
        self:SetText(W)
        self:DrawTextEntryText(self:GetPlaceholderColor(), self:GetHighlightColor(), self:GetCursorColor())
        self:SetText(V)

        return
    end

    self:DrawTextEntryText(o, b, o)
end

function a:PaintUIListView(self, v, w)
    draw.RoundedBox(5, 0, 0, v, w, ui.col.Background)
end

function a:PaintListView(self, v, w)
end

function a:PaintListViewLine(self, v, w)
    if self.m_bAlt then
        draw.Box(0, 0, v, w, (self:IsSelected() or self:IsHovered()) and b or g)
    else
        draw.Box(0, 0, v, w, (self:IsSelected() or self:IsHovered()) and b or e)
    end

    for Z, _ in ipairs(self.Columns) do
        if self:IsSelected() or self:IsHovered() then
            _:SetTextColor(o)
            _:SetFont('ui.20')
        else
            _:SetTextColor(p)
            _:SetFont('ui.15')
        end
    end
end

function a:PaintCheckBox(self, v, w)
    local a0 = self:GetChecked()
    draw.RoundedBox(5, 0, 0, v, w, ui.col.FlatBlack)
    draw.RoundedBox(5, a0 and v * 0.5 or 1, 1, v * 0.5 - 1, w - 2, a0 and b or ui.col.OffWhite)

    if self:IsHovered() then
        draw.RoundedBox(5, 0, 0, v, w, ui.col.Hover)
    end
end

local a1 = b:Copy()
a1.a = 50

function a:PaintTabButton(self, v, w)
    draw.RoundedBox(5, 0, 0, v, w, ui.col.ButtonBlack)

    if self:IsHovered() then
        draw.RoundedBox(5, 0, 0, v, w, ui.col.Hover)
    end

    if self.Active then
        draw.RoundedBox(5, 0, 0, v, w, a1)
    end
end

function a:PaintTabListPanel(self, v, w)
    draw.RoundedBoxEx(5, 160, 0, v - 160, w, e, false, true, false, true)
end

function a:PaintComboBox(self, v, w)
    if IsValid(self.Menu) and not self.Menu.SkinSet then
        self.Menu:SetSkin('SUP')
        self.Menu.SkinSet = true
    end

    if not self.ColorSet then
        self:SetTextColor(ui.col.White)
        self.ColorSet = true
    end

    draw.RoundedBox(5, 0, 0, v, w, self.BackgroundColor or ui.col.Button)

    if self:IsHovered() then
        draw.RoundedBox(5, 0, 0, v, w, ui.col.Hover)
    end
end

local a2 = utf8.char(0xf107)

function a:PaintComboDownArrow(self, v, w)
    draw.SimpleText(a2, 'ForkAwesome', v * 0.5, w * 0.5, self.ComboBox:IsMenuOpen() and ui.col.OffWhite or ui.col.White, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
end

function a:PaintMenu(self, v, w)
    draw.RoundedBox(5, 0, 0, v, w, ui.col.FlatBlack)
end

function a:PaintMenuOption(self, v, w)
    if not self.FontSet then
        self:SetTextInset(0, 0)
        self:SetFont('ui.16')
        self:PerformLayout()
        self.ParentMenu:PerformLayout()
        self.FontSet = true
    end

    self:SetTextColor(p)
    draw.RoundedBox(5, 1, 1, v - 2, w - 2, ui.col.Button)

    if self.m_bBackground and (self.Hovered or self.Highlight) then
        draw.RoundedBox(5, 1, 1, v - 2, w - 2, ui.col.Hover)
    end
end

function a:PaintMenuRightArrow(R, v, w)
    surface.SetDrawColor(ui.col.White)
    draw.NoTexture()

    surface.DrawPoly({
        {
            x = 3,
            y = 3
        },
        {
            x = v,
            y = w * 0.5 + 3
        },
        {
            x = 3,
            y = w
        }
    })
end

local a3 = Color(200, 200, 200)
local a4 = ui.col.ButtonHover
local a5 = Color(b.r, b.g, b.b - 20)

function a:PaintPropertySheet(self, v, w)
    local a6 = self:GetActiveTab()

    if IsValid(a6) then
        if not self.Dark then
            draw.Box(0, a6:GetTall(), v, w - a6:GetTall(), a3)
        end
    end
end

function a:PaintTab(self, v, w)
    local a7 = self:GetPropertySheet():GetActiveTab() == self

    if a7 then
        self:SetTextColor(a5)

        if not self:GetPropertySheet().Dark then
            draw.Box(0, 0, v, w, a3)
        else
            draw.Box(0, 0, v, w, e)
            surface.SetDrawColor(f)
            surface.DrawOutlinedRect(0, 0, v, w + 1)
        end
    elseif self:IsHovered() then
        self:SetTextColor(a4)
    else
        self:SetTextColor(a3)
    end
end

derma.DefineSkin('SUP', 'SUP\'s derma skin', a)