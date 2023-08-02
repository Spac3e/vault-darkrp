local id = 1
local fr

function rp.ToggleF4Menu(c)
    if IsValid(fr) then
        fr:Close()

        return
    end

    local d, e = math.Clamp(ScrW() * 0.75, 1100, ScrW()), math.Clamp(ScrH() * 0.7, 575, ScrH())

    fr = ui.Create('ui_frame', function(self)
        self:SetTitle('Главное меню')
        self:SetSize(d, e)
        self:MakePopup()
        self:Center()
        local f = false

        function self:Think()
            if input.IsKeyDown(KEY_F4) and f then
                self:Close()
            elseif not input.IsKeyDown(KEY_F4) then
                f = true
            end
        end

        function self:OnClose()
            id = self.tabs:GetActiveTabID()
--            net.Ping('rp.CloseF4Menu')
        end
    end)

    fr.tabs = ui.Create('ui_tablist', fr)
    fr.tabs:DockToFrame()
    fr.tabs.tabList:DockMargin(5, 5, 5, ui.SpacerHeight * 3 + 30)

    fr.tabs:AddTab('Действия', function(self)
        return ui.Create'rp_commandlist'
    end):SetIcon'sup/gui/generic/actions.png'

    fr.tabs:AddTab('Работы', function(self)
        return ui.Create'rp_jobslist'
    end):SetIcon'sup/gui/generic/job.png'

    fr.tabs:AddTab('Магазин', function(self)
        return ui.Create'rp_shoplist'
    end):SetIcon'sup/gui/generic/money.png'

    local skill = fr.tabs:AddTab('Скиллы', function(self)
        local color_canafford = ui.col.DarkGreen:Copy()
        color_canafford.a = 100
        local color_cannotafford = ui.col.Red:Copy()
        color_cannotafford.a = 100
        local color_maxed = ui.col.SUP:Copy()
        color_maxed.a = 100
        local color_disabled = ui.col.FlatBlack:Copy()
        color_disabled.a = 100
        local dp = ui.Create 'ui_listview'
        dp:Dock(FILL)
      //  dp:SetSpacing(5)
        
        net.Start 'skill_channel'
        net.WriteTable({
            ['method'] = 'receive',
        })

        net.SendToServer()
        local wide = self:GetWide() - 180
        local locwide = math.floor(wide / ((wide - 5) / 3))

        net.Receive('skill_channel', function()
            local skills = net.ReadTable()
            local i = 0

            for k, v in next, skills do
                i = i + 1
                local title = v.other.Name
                local desc = v.other.Description

                local data = {
                    required = v.nextlevel_price
                }

                local x = (i - 1) % locwide
                local y = math.floor((i - 1) / locwide) % locwide
                local pn = ui.Create('ui_button', dp)
                pn:SetPos(5 + x * ((wide - 5) / 3), 5 + y * (((self:GetWide() - 180 - 5) / 3) / 1.7))
                pn:SetSize((self:GetWide() - 180 - 5) / 3, ((self:GetWide() - 190 - 5) / 3) / 1.7)
                pn.DoClick = function()
                    if tonumber(v.level) > 2 then
                        chat.AddText(ui.col.Red, '[Skills]', ui.col.White, ' Вы уже достигли максимального уровня, мастер!')
                    else
                        ui.BoolRequest('Покупка', 'Вы уверены, что хотите прокачать "' .. title ..  '" за ' ..data.required .. ' Кармы?', function(ans)
                            if ans == true then
                                net.Start 'skill_channel'
                                    net.WriteTable({
                                        ['method'] = 'buy',
                                        ['key'] = k
                                    })
                                net.SendToServer()
                                ui.AdoptionRequest('Успешно!', 'Вы успешно прокачали Скилл!', function() fr:Close() end)
                            end
                        end)
                    end
                end
                pn:SetText('')

                pn.Paint = function(self, w, h)
                    local nextPrice = v.nextlevel_price
                    local barColor = nextPrice and (LocalPlayer():CanKarmaAfford(nextPrice) and color_canafford or color_cannotafford)
                    local mul = 1
                    surface.SetDrawColor(color_disabled)
                    surface.SetDrawColor(255, 255, 255)
                    surface.SetMaterial(Material(v.other.Icon))
                    local tTH = 0
                    local s = h - 120 - tTH
                    surface.DrawTexturedRect((w - s) * 0.5, (h - s) * 0.5 + 10, s, s)

                    if tonumber(v.level) > 2 then
                        draw.RoundedBox(5, mul, mul, w - mul * 2, 55, color_maxed)
                    else
                        draw.RoundedBox(5, mul, mul, w - mul * 2, 55, barColor)
                    end

                    draw.SimpleText(title .. ' - ' .. desc, 'ui.20', w / 2, mul + 30 / 2, color_white, 1, 1)
                    draw.SimpleText("Уровень " .. v.level .. '/3', 'ui.20', w / 2, mul + 70 / 2, color_white, 1, 1)

                    if tonumber(v.level) > 2 then
                        draw.RoundedBox(5, mul, h - mul - 30, w - mul * 2, 30, color_maxed)
                    else
                        draw.RoundedBox(5, mul, h - mul - 30, w - mul * 2, 30, barColor)
                    end

                    draw.SimpleText(tonumber(v.level) > 2 and 'Скилл вкачан' or (data.required .. ' Кармы'), 'ui.20', w / 2, h - mul - 30 / 2, color_white, 1, 1)

                    if self:IsHovered() then
                        draw.RoundedBox(0, mul, mul, w - mul * 2, h - mul * 2, Color(255, 255, 255, 5))
                    end
                //    dp:AddCustomRow(pn)
                end
            end
        end)
        return dp
    end):SetIcon'sup/gui/generic/karma.png'

    local g

    fr.tabs:AddTab('Скины', function(self)
        g = ui.Create'rp_skinspanel'

        return g
    end):SetIcon'sup/gui/generic/rifle.png'

    local h

    fr.tabs:AddTab('Аксессуары', function(self)
        h = ui.Create'rp_apparel_panel'

        return h
    end):SetIcon'sup/gui/generic/cap.png'

    hook.Call('PopulateF4Tabs', GAMEMODE, fr.tabs, fr)
    
    

    local i
    local j = fr.tabs:AddTab('Донат', function(self)
        i = ui.Create'rp_creditshop_panel'

        return i
    end)
    j:SetIcon'sup/gui/generic/credits.png'
    j:SetTextColor(ui.col.Gold)
    local k = ui.Create('Panel', fr)
    k:SetSize(150, ui.SpacerHeight * 3 + 30)
    k:SetPos(5, fr:GetTall() - k:GetTall())

    local l = fr.tabs:AddButton('Discord', function()
        gui.OpenURL(rp.cfg.DiscordURL)
    end)
    l:SetIcon'sup/gui/generic/discord.png'
    l:SetParent(k)
    l:DockMargin(0, 0, 0, 0)
    l:Dock(TOP)

    local m = fr.tabs:AddTab('Достижения', function(self)
        return ui.Create'rp_achievements'
    end)
    m:SetIcon'sup/gui/generic/achievement.png'
    m:SetParent(k)
    m:DockMargin(0, 5, 0, 0)
    m:Dock(TOP)

    local n = fr.tabs:AddTab('Настройки', function(self)
        return ui.Create'rp_settings'
    end)

    n:SetIcon'sup/gui/generic/gear.png'
    n:SetParent(k)
    n:DockMargin(0, 5, 0, 5)
    n:Dock(TOP)

    if not c then
        fr.tabs:SetActiveTab(id)
    else
        fr.tabs:SetActiveTab(9)
    end

    if IsValid(i) then
        i:AddControls(fr)
    end

    if IsValid(h) then
        h:AddControls(fr)
    end

    if IsValid(g) then
        g:AddControls(fr)
    end

    function fr.tabs:TabChanged(o)
        if IsValid(fr) then
            if IsValid(i) then
                if o ~= i then
                    i:HideControls()
                else
                    i:AddControls(fr)
                end
            end

            if IsValid(h) then
                if o ~= h then
                    h:HideControls()
                else
                    h:AddControls(fr)
                end
            end

            if IsValid(g) then
                if o ~= g then
                    g:HideControls()
                else
                    g:AddControls(fr)
                end
            end

            hook.Call('F4TabChanged', nil, o)
        end
    end
end

local PANEL = {}

function PANEL:Init()
    self.HTML = ui.Create("DHTML", self)

    self.HTML.Paint = function(self, w, h)
        draw.Box(0, 0, w, h, color_white)
    end

    self.HTML:OpenURL(rp.cfg.RulesURL)
end

function PANEL:PerformLayout()
    self.HTML:SetPos(5, 5)
    self.HTML:SetSize(self:GetWide() - 10, self:GetTall() - 10)
end

function GM:ShowSpare2()
    rp.ToggleF4Menu()
end

vgui.Register('rp_rulespanel', PANEL, 'Panel')