local math      = math
local a         = math.ceil
local surface   = surface

surface.CreateFont('ui.door', {
    font = 'Montserrat Medium',
    size = 135,
    weight = 1000,
    extended = true,
    antialias = true
})

surface.CreateFont('ui.130', {
    font = 'Montserrat Medium',
    size = 130,
    weight = 500,
    extended = true,
    antialias = true
})

surface.CreateFont('ui.128', {
    font = 'Montserrat Medium',
    size = 128,
    weight = 500,
    extended = true,
    antialias = true
})

surface.CreateFont('ui.85', {
    font = 'Montserrat Medium',
    size = 85,
    weight = 500,
    extended = true,
    antialias = true
})

surface.CreateFont('ui.60', {
    font = 'Montserrat Medium',
    size = 60,
    weight = 500,
    extended = true,
    antialias = true
})

surface.CreateFont('ui.40', {
    font = 'Montserrat Medium',
    size = 40,
    weight = 500,
    extended = true,
    antialias = true
})

surface.CreateFont('ui.39', {
    font = 'Montserrat Medium',
    size = 39,
    weight = 500
})

surface.CreateFont('ui.38', {
    font = 'Montserrat Medium',
    size = 38,
    weight = 500,
    extended = true,
    antialias = true
})

surface.CreateFont('ui.37', {
    font = 'Montserrat Medium',
    size = 37,
    weight = 500,
    extended = true,
    antialias = true
})

surface.CreateFont('ui.36', {
    font = 'Montserrat Medium',
    size = 36,
    weight = 500,
    extended = true,
    antialias = true
})

surface.CreateFont('ui.35', {
    font = 'Montserrat Medium',
    size = 35,
    weight = 500,
    extended = true,
    antialias = true
})

surface.CreateFont('ui.34', {
    font = 'Montserrat Medium',
    size = 34,
    weight = 500,
    extended = true,
    antialias = true
})

surface.CreateFont('ui.33', {
    font = 'Montserrat Medium',
    size = 33,
    weight = 500,
    extended = true,
    antialias = true
})

surface.CreateFont('ui.32', {
    font = 'Montserrat Medium',
    size = 32,
    weight = 500,
    extended = true,
    antialias = true
})

surface.CreateFont('ui.31', {
    font = 'Montserrat Medium',
    size = 31,
    weight = 500,
    extended = true,
    antialias = true
})

surface.CreateFont('ui.30', {
    font = 'Montserrat Medium',
    size = 30,
    weight = 500,
    extended = true,
    antialias = true
})

surface.CreateFont('ui.29', {
    font = 'Montserrat Medium',
    size = 29,
    weight = 500,
    extended = true,
    antialias = true
})

surface.CreateFont('ui.28', {
    font = 'Montserrat Medium',
    size = 28,
    weight = 500,
    extended = true,
    antialias = true
})

surface.CreateFont('ui.27', {
    font = 'Montserrat Medium',
    size = 27,
    weight = 500,
    extended = true,
    antialias = true
})

surface.CreateFont('ui.26', {
    font = 'Montserrat Medium',
    size = 26,
    weight = 500,
    extended = true,
    antialias = true
})

surface.CreateFont('ui.25', {
    font = 'Montserrat Medium',
    size = 25,
    weight = 500,
    extended = true,
    antialias = true
})

surface.CreateFont('ui.24', {
    font = 'Montserrat Medium',
    size = 24,
    weight = 500,
    extended = true,
    antialias = true
})

surface.CreateFont('ui.23', {
    font = 'Montserrat Medium',
    size = 23,
    weight = 500,
    extended = true,
    antialias = true
})

surface.CreateFont('ui.22', {
    font = 'Montserrat Medium',
    size = 22,
    weight = 500,
    extended = true,
    antialias = true
})

surface.CreateFont('ui.20', {
    font = 'Montserrat Medium',
    size = 20,
    weight = 500,
    extended = true,
    antialias = true
})

surface.CreateFont('ui.19', {
    font = 'Montserrat Medium',
    size = 19,
    weight = 500,
    extended = true,
    antialias = true
})

surface.CreateFont('ui.18', {
    font = 'Montserrat Medium',
    size = 18,
    weight = 500,
    extended = true,
    antialias = true
})

surface.CreateFont('ui.17', {
    font = 'Montserrat Medium',
    size = 17,
    weight = 500,
    extended = true,
    antialias = true
})

surface.CreateFont('ui.16', {
    font = 'Montserrat Medium',
    size = 16,
    weight = 500,
    extended = true,
    antialias = true
})

surface.CreateFont('ui.15', {
    font = 'Montserrat Medium',
    size = 15,
    weight = 500,
    extended = true,
    antialias = true
})

surface.CreateFont('ui.14', {
    font = 'Montserrat Medium',
    size = 14,
    weight = 500,
    extended = true,
    antialias = true
})

surface.CreateFont('ui.12', {
    font = 'Montserrat Medium',
    size = 12,
    weight = 500,
    extended = true,
    antialias = true
})

surface.CreateFont('ui.10', {
    font = 'Montserrat Medium',
    size = 10,
    weight = 500,
    extended = true,
    antialias = true
})

surface.CreateFont('ui.5percent', {
    font = 'Montserrat Medium',
    size = math.ceil(ScrH() * 0.05),
    weight = 500,
    extended = true,
    antialias = true,
    antialias = true
})

surface.CreateFont('ForkAwesome', {
    font = 'forkawesome',
    size = 18,
    extended = true,
    symbol = true
})

local a = {
    ['DTextEntry'] = function(self, p)
        self:SetFont('ui.20')
    end,
    ['DNumberWang'] = function(self, p)
        self:SetFont('ui.20')
    end,
    ['DLabel'] = function(self, p)
        self:SetFont('ui.22')
        self:SetColor(ui.col.White)
    end,
    ['DComboBox'] = function(self, p)
        self:SetFont('ui.22')
    end
}

function ui.Create(b, c, p)
    local d

    if not isfunction(c) and c ~= nil then
        d = c
    elseif not isfunction(p) and p ~= nil then
        d = p
    end

    local e = vgui.Create(b, d)
    e:SetSkin('SUP')

    if a[b] then
        a[b](e, d)
    end

    if isfunction(c) then
        c(e, d)
    elseif isfunction(p) then
        p(e, c)
    end

    return e
end

function ui.Label(f, g, h, i, d)
    return ui.Create('DLabel', function(self, p)
        self:SetText(f)
        self:SetFont(g)
        self:SetTextColor(ui.col.White)
        self:SetPos(h, i)
        self:SizeToContents()
        self:SetWrap(true)
        self:SetAutoStretchVertical(true)
    end, d)
end

function ui.DermaMenu(j)
    if not parentmenu then
        CloseDermaMenus()
    end

    return ui.Create("DMenu", function(self)
        self:SetTall(30)
    end, p)
end

function ui.BoolRequest(k, l, n)
    local m = ui.Create('ui_frame', function(self)
        self:SetTitle(k)
        self:ShowCloseButton(false)
        self:SetWide(ScrW() * .2)
        self:MakePopup()
    end)

    local f = string.Wrap('ui.18', l, m:GetWide() - 10)
    local i = m:GetTitleHeight()

    for o, e in ipairs(f) do
        local q = ui.Create('DLabel', function(self, p)
            self:SetText(e)
            self:SetFont('ui.18')
            self:SizeToContents()
            self:SetPos((p:GetWide() - self:GetWide()) / 2, i)
            i = i + self:GetTall() + 5
        end, m)
    end

    local r = ui.Create('ui_button', function(self, p)
        self:SetText('Да')
        self:SetPos(5, i)
        self:SetSize(p:GetWide() / 2 - 7.5, 25)

        self.DoClick = function(s)
            p:Close()
            n(true)
        end
    end, m)

    local t = ui.Create('ui_button', function(self, p)
        self:SetText('Нет')
        self:SetPos(r:GetWide() + 10, i)
        self:SetSize(r:GetWide(), 25)
        self:RequestFocus()

        self.DoClick = function(s)
            p:Close()
            n(false)
        end

        i = i + self:GetTall() + 5
    end, m)

    m:SetTall(i)
    m:Center()
    m:Focus()

    return m
end

function ui.AdoptionRequest(m, n, o)
    local q = ui.Create('ui_frame', function(self)
        self:SetTitle(m)
        self:ShowCloseButton(false)
        self:SetWide(ScrW() * .2)
        self:MakePopup()
    end)

    local h = string.Wrap('ui.18', n, q:GetWide() - 10)
    local k = q:GetTitleHeight()

    for r, g in ipairs(h) do
        local s = ui.Create('DLabel', function(self, p)
            self:SetText(g)
            self:SetFont('ui.18')
            self:SizeToContents()
            self:SetPos((p:GetWide() - self:GetWide()) / 2, k)
            k = k + self:GetTall() + 5
        end, q)
    end

    local v = ui.Create('ui_button', function(self, p)
        self:SetText('Понятно')
        self:SetPos(100, k)
        self:Dock(BOTTOM)
        self:RequestFocus()

        self.DoClick = function(u)
            p:Close()
            o(false)
        end

        k = k + self:GetTall() + 5
    end, q)

    q:SetTall(k)
    q:Center()
    q:Focus()

    return q
end

function ui.StringRequest(k, l, u, n)
    local m = ui.Create('ui_frame', function(self)
        self:SetTitle(k)
        self:ShowCloseButton(false)
        self:SetWide(ScrW() * .3)
        self:MakePopup()
    end)

    local f = string.Wrap('ui.18', l, m:GetWide() - 10)
    local i = m:GetTitleHeight()

    for o, e in ipairs(f) do
        local q = ui.Create('DLabel', function(self, p)
            self:SetText(e)
            self:SetFont('ui.18')
            self:SizeToContents()
            self:SetPos((p:GetWide() - self:GetWide()) / 2, i)
            i = i + self:GetTall()
        end, m)
    end

    local v = ui.Create('DTextEntry', function(self, p)
        self:SetPos(5, i + 5)
        self:SetSize(p:GetWide() - 10, 25)
        self:SetValue(u or '')
        i = i + self:GetTall() + 10

        self.OnEnter = function(s)
            p:Close()
            n(self:GetValue())
        end
    end, m)

    local r = ui.Create('ui_button', function(self, p)
        self:SetText('Окей')
        self:SetPos(5, i)
        self:SetSize(p:GetWide() / 2 - 7.5, 25)

        self.DoClick = function(s)
            p:Close()
            n(v:GetValue())
        end
    end, m)

    local t = ui.Create('ui_button', function(self, p)
        self:SetText('Отмена')
        self:SetPos(r:GetWide() + 10, i)
        self:SetSize(r:GetWide(), 25)
        self:RequestFocus()

        self.DoClick = function(s)
            m:Close()
        end

        i = i + self:GetTall() + 5
    end, m)

    m:SetTall(i)
    m:Center()
    m:Focus()

    return m
end

function ui.PlayerRequest(w, n)
    if isfunction(w) then
        n = w
        w = nil
    end

    local x = ui.Create('ui_frame', function(self)
        self:SetTitle('Выберите игрока')
        self:SetSize(.2, .3)
        self:Center()
        self:MakePopup()
    end)

    ui.Create('ui_playerrequest', function(self, p)
        self:DockToFrame()

        if w then
            self:SetPlayers(w)
        end

        self.OnSelection = function(self, y, z)
            x:Close()
            n(z)
        end
    end, x)

    x:Focus()

    return m
end

function ui.ListRequest(k, A, n)
    local x = ui.Create('ui_frame', function(self)
        self:SetTitle(k)
        self:SetSize(.2, .3)
        self:Center()
        self:MakePopup()
    end)

    ui.Create('ui_listrequest', function(self, p)
        self:DockToFrame()
        self:SetOptions(A)

        self.OnSelection = function(self, y, B)
            x:Close()
            n(B)
        end
    end, x)

    x:Focus()

    return x
end

function ui.NumberRequest(k, l, u, C, D, n)
    local m = ui.Create('ui_frame', function(self)
        self:SetTitle(k)
        self:ShowCloseButton(false)
        self:SetWide(ScrW() * .3)
        self:MakePopup()
    end)

    local f = string.Wrap('ui.18', l, m:GetWide() - 10)
    local i = m:GetTitleHeight()

    for o, e in ipairs(f) do
        local q = ui.Create('DLabel', function(self, p)
            self:SetText(e)
            self:SetFont('ui.18')
            self:SizeToContents()
            self:SetPos((p:GetWide() - self:GetWide()) / 2, i)
            i = i + self:GetTall()
        end, m)
    end

    local v = ui.Create('DNumberWang', function(self, p)
        self:SetTall(25)
        self:SizeToContentsX()
        surface.SetFont(self:GetFont())
        local E, F = surface.GetTextSize(D)
        self:SetWide(math.min(self:GetWide() + E, p:GetWide() - 10))
        self:SetPos(p:GetWide() * 0.5 - self:GetWide() * 0.5, i + 5)
        self:SetMinMax(C, D)
        self:SetValue(u)
        i = i + self:GetTall() + 10

        self.OnEnter = function(s)
            p:Close()
            n(math.Clamp(tonumber(self:GetValue()), C, D))
        end
    end, m)

    local r = ui.Create('ui_button', function(self, p)
        self:SetText('Окей')
        self:SetPos(5, i)
        self:SetSize(p:GetWide() / 2 - 7.5, 25)

        self.DoClick = function(s)
            p:Close()
            n(math.Clamp(tonumber(v:GetValue()), C, D))
        end
    end, m)

    local t = ui.Create('ui_button', function(self, p)
        self:SetText('Отмена')
        self:SetPos(r:GetWide() + 10, i)
        self:SetSize(r:GetWide(), 25)
        self:RequestFocus()

        self.DoClick = function(s)
            m:Close()
        end

        i = i + self:GetTall() + 5
    end, m)

    m:SetTall(i)
    m:Center()
    m:Focus()

    return m
end

function ui.ColorRequest(k, l, G, H, n)
    local m = ui.Create('ui_frame', function(self)
        self:SetTitle(k)
        self:ShowCloseButton(false)
        self:SetWide(ScrW() * .3)
        self:MakePopup()
    end)

    local f = string.Wrap('ui.18', l, m:GetWide() - 10)
    local i = m:GetTitleHeight()

    for o, e in ipairs(f) do
        local q = ui.Create('DLabel', function(self, p)
            self:SetText(e)
            self:SetFont('ui.18')
            self:SizeToContents()
            self:SetPos((p:GetWide() - self:GetWide()) / 2, i)
            i = i + self:GetTall()
        end, m)
    end

    local I = ui.Create('DColorMixer', function(self, p)
        self:SetSize(p:GetWide() - 10, 300)
        self:SetPos(p:GetWide() * 0.5 - self:GetWide() * 0.5, i + 5)
        self:SetColor(G)
        self:SetAlphaBar(H)
        i = i + self:GetTall() + 10
    end, m)

    local r = ui.Create('ui_button', function(self, p)
        self:SetText('Окей')
        self:SetPos(5, i)
        self:SetSize(p:GetWide() / 2 - 7.5, 25)

        self.DoClick = function(s)
            p:Close()
            n(setmetatable(I:GetColor(), _R.Color))
        end
    end, m)

    local t = ui.Create('ui_button', function(self, p)
        self:SetText('Отмена')
        self:SetPos(r:GetWide() + 10, i)
        self:SetSize(r:GetWide(), 25)
        self:RequestFocus()

        self.DoClick = function(s)
            m:Close()
        end

        i = i + self:GetTall() + 5
    end, m)

    m:SetTall(i)
    m:Center()
    m:Focus()
end

function ui.OpenURL(J, k)
    local E, K = ScrW() * .9, ScrH() * .9

    local x = ui.Create('ui_frame', function(self)
        self:SetSize(E, K)
        self:SetTitle(J)
        self:Center()
        self:MakePopup()
    end)

    ui.Create('HTML', function(self)
        self:SetPos(5, 32)
        self:SetSize(E - 10, K - 37)
        self:OpenURL(J)
    end, x)

    return x
end