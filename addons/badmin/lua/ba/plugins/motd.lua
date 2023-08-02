term.Add('MOTDSet', 'The MoTD has been set to "#".')

if SERVER then return end

ba.AddCommand'MoTD':RunOnClient(function(a)
    ba.OpenMoTD()
end)
:SetHelp'Opens the rules of the server'
:AddAlias'rules'

ba.AddCommand('SetMoTD', function(b, c)
    ba.svar.Set('motd', c)
    ba.notify(b, term.Get('MOTDSet'), c)
end)
:AddParam('STRING')
:SetFlag'*'
:SetHelp'Sets the MoTD URL for the server'

ba.AddCommand'SMoTD':RunOnClient(function(a)
    gui.OpenURL(ba.svar.Get('smotd'))
end)
:SetHelp'Opens the staff MoTD'

ba.AddCommand('SetSMoTD', function(b, c)
    ba.svar.Set('smotd', c)
end)
:AddParam('STRING')
:SetFlag'*'
:SetHelp'Sets the SMoTD URL for the server'

local d = {
    {
        Name = 'Правила',
        Icon = 'sup/gui/generic/rules.png',
        Callback = function()
            gui.OpenURL(rp.cfg.RulesURL)
        end
    },
    {
        Name = 'Discord',
        Icon = 'sup/gui/generic/discord.png',
        Callback = function()
            gui.OpenURL(rp.cfg.DiscordURL)
        end
    },
   --[[{
        Name = 'VK',
        Icon = 'sup/gui/generic/steam.png',
        Callback = function()
            gui.OpenURL(rp.cfg.VKURL)
        end
    },--]]
    {
        Name = 'Контент',
        Icon = 'sup/gui/generic/steam.png',
        TextColor = ui.col.Gold,
        Callback = function()
            gui.OpenURL("https://steamcommunity.com/sharedfiles/filedetails/?id=2927812004")
        end
    }
}

function ba.OpenMoTD()
    local e = ui.Create('ui_frame', function(self)
        self:SetTitle('Ссылки')
        self:MakePopup()
    end)

    local f, g = e:GetDockPos()
    local h, i = 200, f

    local j = ui.Create('ui_tablist', function(self, k)
        self:DockToFrame()
    end, e)

    for l, m in ipairs(d) do
        local n = j:AddButton(m.Name, function()
            if m.URL then
                gui.OpenURL(m.URL)
            elseif m.CMD then
                cmd.Run(m.CMD)
            elseif m.Callback then
                m.Callback()
            end

            if m.Remove then
                e:Remove()
            end
        end)

        if m.Icon then
            n:SetIcon(m.Icon)
        end

        if m.TextColor then
            n:SetTextColor(m.TextColor)
        end

        h = n:GetWide() + 22
        i = i + n:GetTall() + 10
    end

    e:SetSize(h, i + 5)
    e:Center()
    j:DockToFrame()
end

local id = math.random(1, 127)

local o = {'#Подключение...', '#Получаем информацию о вас...', '#Авторизировались под кодом: ' .. id, '#Ожидайте прогрузки карты!',}

local p = ui.col.Background:Copy()
local q = Material('hud/logos/logo.png', 'smooth noclamp')
local r = Material('hud/logos/logo.png', 'smooth noclamp')
local s = Color(255, 255, 255, 255)
local t = 128
local u = {}

function u:Init()
    self.Title = ui.Create('ui_button', self)
    self.Title:SetText'Недавние обновления'
    self.Title:SetEnabled(false)
    self.Title:Dock(TOP)
    self.Loading = true

    http.Fetch('https://pastebin.com/raw/wu1CfErr', function(v)
        tablej = util.JSONToTable(v)
        self.Loading = false

        for l, m in ipairs(tablej) do
            if l > 3 then continue end

            ui.Create('ui_button', function(w)
                w:SetText(m.Title)
                w:Dock(TOP)
                w:DockMargin(0, 5, 0, 0)

                w.DoClick = function()
                    gui.OpenURL(m.Url)
                end

                w.Paint = function(w, h, i)
                    derma.SkinHook('Paint', 'TabButton', w, h, i)
                end

                --  print(os.time())
                if os.time() - m.Start < 432000 then
                    w.PaintOver = function(w, h, i)
                        surface.SetDrawColor(255, 255, 255)
                        surface.SetMaterial(r)
                        surface.DrawTexturedRect(h - 64, 0, 64, 64)
                    end
                end
            end, self)
        end
    end)
end

function u:PerformLayout(h, i)
    for l, m in ipairs(self:GetChildren()) do
        m:SetTall(64)
    end

    self.Title:SetHeight(ui.SpacerHeight)
end

function u:Paint(h, i)
    if self.Loading then
        draw.RoundedBox(5, 0, 0, h, i, ui.col.Background)
        local x = SysTime() * 5
        draw.NoTexture()
        surface.SetDrawColor(255, 255, 255)
        surface.DrawArc(h * 0.5, i * 0.5, 20, 25, x * 80, x * 80 + 180, 20)
    end
end

vgui.Register('ba_load_updates', u, 'Panel')
u = {}

function u:Init()
    self.Rules = self:Button('Правила', 'sup/gui/generic/rules.png', function()
        gui.OpenURL(rp.cfg.RulesURL)
    end)

    self.Rules:Dock(LEFT)
    self.Rules:DockMargin(0, 0, 2.5, 0)
    self.Forums = self:Button('Discord', 'sup/gui/generic/discord.png', rp.cfg.DiscordURL)
    self.Forums:Dock(FILL)
    self.Forums:DockMargin(2.5, 0, 2.5, 0)

    self.Credits = self:Button('Контент', 'sup/gui/generic/steam.png', function()
        gui.OpenURL("https://steamcommunity.com/sharedfiles/filedetails/?id=2927812004")
    end)

    self.Credits:Dock(RIGHT)
    self.Credits:DockMargin(2.5, 0, 0, 0)
end

function u:Button(y, z, c)
    return ui.Create('ui_button', function(w)
        w:SetText(y)
        w:SetIcon(z)

        w.DoClick = function()
            if isfunction(c) then
                c()
            else
                gui.OpenURL(c)
            end
        end

        w.Paint = function(w, h, i)
            derma.SkinHook('Paint', 'TabButton', w, h, i)
        end
    end, self)
end

function u:PerformLayout(h, i)
    for l, m in ipairs(self:GetChildren()) do
        m:SetSize(h / 3, i)
    end
end

vgui.Register('ba_load_links', u, 'Panel')
u = {}

function u:Init()
    self.Messages = {}
    self.MinimizeEnabled = true
    self:DockPadding(25, 140, 25, 25)
    self.Links = ui.Create('ba_load_links', self)
    self.Links:SetVisible(false)
    self.Links:Dock(TOP)
    self.Container = ui.Create('Panel', self)
    self.Container:SetVisible(false)
    self.Container:Dock(FILL)
    self.Container:DockMargin(0, 25, 0, 25)
    self.Updates = ui.Create('ba_load_updates', self.Container)
    self.Updates:Dock(LEFT)
    self.Updates:DockMargin(0, 0, 2.5, 0)
    self.Rewards = ui.Create('ba_rewards_panel', self.Container)
    self.Rewards:Dock(RIGHT)
    self.Rewards:DockMargin(2.5, 0, 0, 0)
    self.Rewards:FetchData()
    self.CloseButton = ui.Create('ui_button', self)
    self.CloseButton:SetText'Играть!'
    self.CloseButton:SetVisible(false)

    self.CloseButton.DoClick = function(w)
        self:Close()
    end

    self.CloseButton:Dock(BOTTOM)
    self:SetSize(ScrW(), ScrH())
    self:Center()
    self:MakePopup()
    self:SetCursor'blank'
    local B = 1

    timer.Create('ba.LoadingMessages', 0.6, #o + 1, function()
        if o[B] then
            table.insert(self.Messages, o[B])
        elseif self.MinimizeEnabled then
            self:SizeTo()
        else
            self:LoadingCompleted()
        end

        B = B + 1
    end)

    self.HiddenPanels = {}

    for l, m in ipairs(vgui.GetWorldPanel():GetChildren()) do
        if IsValid(m) and m:IsVisible() and m ~= self then
            table.insert(self.HiddenPanels, m)
            m:SetVisible(false)
        end
    end

    hook.Add('HUDShouldDraw', self, function(w, C)
        return C == 'CHudGMod' or C == 'NetGraph'
    end)

    hook.Add('HUDPaint', self, function()
        if hook.Call('PaintLoadinBackground', nil, self) ~= true then
            local h, i = ScrW(), ScrH()
            p.a = math.min(ui.col.Background.a, self:GetAlpha())
            draw.Box(0, 0, h, i, p)
            draw.BlurBox(0, 0, h, i)
            draw.BlurResample(10)
        end
    end)

    hook.Call('PlayerOpenedLoadInScreen', nil, self)
end

function u:EnableMinize(D)
    self.MinimizeEnabled = D
end

function u:LoadingCompleted()
end

function u:OnRemove()
    for l, m in ipairs(self.HiddenPanels) do
        if IsValid(m) then
            m:SetVisible(true)
        end
    end

    hook.Call('PlayerCloseLoadInScreen', nil, self)
end

function u:Think()
    if self.Anim then
        self.Anim:Run()
    end
end

function u:PerformLayout(h, i)
    self.Links:SetTall(ui.SpacerHeight)
    self.Updates:SetSize(self.Container:GetWide() * 0.5 - 2.5, self.Container:GetTall())
    self.Rewards:SetSize(self.Updates:GetSize())
    self.CloseButton:SetTall(ui.SpacerHeight)
end

function u:Paint(h, i)
    if not self.Messages then
        draw.Box(0, 0, h, 115, ui.col.Background)
        surface.SetDrawColor(255, 255, 255)
        surface.SetMaterial(q)
        surface.DrawTexturedRect((h - 64) * 0.5, 10, 64, 64)
        local nick = LocalPlayer():GetName()
        draw.SimpleText(nick .. ', Добро пожаловать на [VAULT] DarkRP!', 'ui.35', h * 0.5, 79, ui.col.White, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)
    end

    if self.Messages then
        local E = i * 0.25
        surface.SetDrawColor(255, 255, 255)
        surface.SetMaterial(q)
        surface.DrawTexturedRect((h - t) * 0.5, E, t, t)
        local F, G = h * 0.5, t + E + 15

        for l, m in ipairs(self.Messages) do
            s.a = 255 - l * 255 / (#o + 1)
            local H, I = draw.SimpleText(m, 'ui.30', F, G, s, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)
            G = G + I + 5
        end
    end
end

function u:SizeTo(J)
    local h, i = self:GetSize()
    local K, L = ScrW() * 0.5, math.min(530, ScrH())

    self.Anim = Derma_Anim('Size Panel', self, function(M, N, O, P)
        M:SetSize(Lerp(O, h, K), Lerp(O, i, L))
        M:Center()

        if N.Finished then
            M.Anim = nil
            M.Messages = nil

            for l, m in ipairs(M:GetChildren()) do
                m:SetVisible(true)
            end

            M:SetCursor'arrow'
        end
    end)

    if self.Anim then
        self.Anim:Start(0.5)
    end
end

function u:Close()
    self.Anim = Derma_Anim('Fade Panel', self, function(M, N, O, P)
        M:SetAlpha(255 - O * 255)

        if N.Finished then
            self.Anim = nil
            self:Remove()
        end
    end)

    if self.Anim then
        self.Anim:Start(0.2)
    end
end

vgui.Register('ba_load_menu', u, 'Panel')

hook.Add('InitPostEntity', 'ba.loadin.InitPostEntity', function()
    ui.Create('ba_load_menu')
end)

local motdshow = false

concommand.Add('load_menu', function()
    if IsValid(LOAD) then
        LOAD:Remove()
    end
    LOAD = ui.Create('ba_load_menu')
end)