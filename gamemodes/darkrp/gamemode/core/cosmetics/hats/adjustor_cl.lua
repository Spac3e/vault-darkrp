local a = {}

function a:Init()
    self.ModelSelect = ui.Create('DComboBox', self)
    self.ModelSelect:SetSortItems(false)
    self.ModelSelect:Dock(TOP)
    self.ModelSelect:DockMargin(0, 0, 0, 5)
    local b = LocalPlayer():GetModel():lower()
    local c = {}

    for d, e in ipairs(rp.teams) do
        if istable(e.model) then
            for f, g in ipairs(e.model) do
                if c[g] then continue end
                self.ModelSelect:AddChoice(e.name .. (rp.hats.ModelGroups[g:lower()] and '(' .. rp.hats.ModelGroups[g:lower()] .. ')' or '') .. ' #' .. f, g, g:lower() == b)
                c[g] = true
            end
        else
            if c[e.model] then continue end
            self.ModelSelect:AddChoice(e.name .. (rp.hats.ModelGroups[e.name:lower()] and '(' .. rp.hats.ModelGroups[e.name:lower()] .. ')' or ''), e.model, e.model:lower() == b)
            c[e.model] = true
        end
    end

    self.Spacer1 = ui.Create('ui_button', self)
    self.Spacer1:SetText('Настройки шапок:')
    self.Spacer1:SetDisabled(true)
    self.Spacer1:Dock(TOP)
    self.Spacer1:DockMargin(0, 0, 0, 5)
    self.PosX = ui.Create('DNumSlider', self)
    self.PosX:SetText('Pos X')
    self.PosX:SetMin(-100)
    self.PosX:SetMax(100)
    self.PosX:SetDecimals(3)
    self.PosX:Dock(TOP)
    self.PosX:DockMargin(0, 0, 0, 5)

    self.PosX.OnValueChanged = function()
        self:AdjustSettings()
    end

    self.PosY = ui.Create('DNumSlider', self)
    self.PosY:SetText('Pos Y')
    self.PosY:SetMin(-100)
    self.PosY:SetMax(100)
    self.PosY:SetDecimals(3)
    self.PosY:Dock(TOP)
    self.PosY:DockMargin(0, 0, 0, 5)

    self.PosY.OnValueChanged = function()
        self:AdjustSettings()
    end

    self.PosZ = ui.Create('DNumSlider', self)
    self.PosZ:SetText('Pos Z')
    self.PosZ:SetMin(-100)
    self.PosZ:SetMax(100)
    self.PosZ:SetDecimals(3)
    self.PosZ:Dock(TOP)
    self.PosZ:DockMargin(0, 0, 0, 5)

    self.PosZ.OnValueChanged = function()
        self:AdjustSettings()
    end

    self.AngP = ui.Create('DNumSlider', self)
    self.AngP:SetText('Angle Pitch')
    self.AngP:SetMin(-180)
    self.AngP:SetMax(180)
    self.AngP:SetDecimals(3)
    self.AngP:Dock(TOP)
    self.AngP:DockMargin(0, 0, 0, 5)

    self.AngP.OnValueChanged = function()
        self:AdjustSettings()
    end

    self.AngY = ui.Create('DNumSlider', self)
    self.AngY:SetText('Angle Yaw')
    self.AngY:SetMin(-180)
    self.AngY:SetMax(180)
    self.AngY:SetDecimals(3)
    self.AngY:Dock(TOP)
    self.AngY:DockMargin(0, 0, 0, 5)

    self.AngY.OnValueChanged = function()
        self:AdjustSettings()
    end

    self.AngR = ui.Create('DNumSlider', self)
    self.AngR:SetText('Angle Roll')
    self.AngR:SetMin(-180)
    self.AngR:SetMax(180)
    self.AngR:SetDecimals(3)
    self.AngR:Dock(TOP)
    self.AngR:DockMargin(0, 0, 0, 5)

    self.AngR.OnValueChanged = function()
        self:AdjustSettings()
    end

    self.Scale = ui.Create('DNumSlider', self)
    self.Scale:SetText('Размер')
    self.Scale:SetMin(0)
    self.Scale:SetMax(2)
    self.Scale:SetDecimals(3)
    self.Scale:Dock(TOP)
    self.Scale:DockMargin(0, 0, 0, 5)

    self.Scale.OnValueChanged = function()
        self:AdjustSettings()
    end

    self.Spacer2 = ui.Create('ui_button', self)
    self.Spacer2:SetText('Preview Settings:')
    self.Spacer2:SetDisabled(true)
    self.Spacer2:Dock(TOP)
    self.Spacer2:DockMargin(0, 0, 0, 5)
    self.FOV = ui.Create('DNumSlider', self)
    self.FOV:SetText('Preview Size')
    self.FOV:SetMin(0)
    self.FOV:SetMax(360)
    self.FOV:SetDecimals(0)
    self.FOV:Dock(TOP)
    self.FOV:DockMargin(0, 0, 0, 5)
    self.FOV:SetValue(60)

    self.FOV.OnValueChanged = function(h, i)
        self.Preview:SetFOV(i)
    end

    self.Preview = ui.Create('rp_playerpreview', self)
    self.Preview:Dock(FILL)
    self.Preview:SetModel(b)
    self.Preview:DockMargin(0, 0, 0, 5)
    self.Preview:SetFOV(self.FOV:GetValue())
    self.Preview:ShowPitch(true)

    self.Preview.ModelPanel.DrawModel = function(h)
        h.Entity:DrawModel()
        h.Entity:SetEyeTarget(gui.ScreenToVector(gui.MousePos()))

        if h.Apparel then
            for f, j in pairs(h.Apparel) do
                rp.hats.Render(h.Entity, self.SelectedItem == j and self.SettingsTable or rp.hats.List[j])
            end
        end
    end

    self.Previews = {}
    local k = LocalPlayer():GetApparel()

    for l = 1, 5 do
        local m = k[l] and rp.hats.List[k[l]] or nil
        self.Previews[l] = ui.Create('rp_modelicon', self.Preview)
        self.Previews[l]:SetToolTip('Слот #' .. l)

        self.Previews[l].DoClick = function(h)
            if m then
                self:SetItem(m)
                self.SelectedPanel = h
                self.SelectedItem = m.UID
            end
        end

        self.Previews[l].Paint = function(h, n, o)
            draw.RoundedBox(5, 0, 0, n, o, ui.col.Black)

            if self.SelectedPanel == h then
                draw.RoundedBox(5, 0, 0, n, o, ui.col.Hover)
            end
        end

        self.Previews[l].PaintOver = function(h, n, o)
            if not m then
                draw.RoundedBox(5, 0, 0, n, o, ui.col.Black)
                draw.SimpleText('Слот ' .. l, 'ui.18', n * 0.5, o * 0.5, ui.col.White, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
            end
        end

        if m then
            self.Previews[l]:SetModel(m.model)
        end
    end

    self.ModelSelect.OnSelect = function(h, p, q, g)
        self.Preview:SetModel(g)
    end

    self.CopySettings = ui.Create('ui_button', self)
    self.CopySettings:SetText('Скопировать Конфиг')
    self.CopySettings:Dock(BOTTOM)
    self.CopySettings:SetDisabled(true)

    self.CopySettings.DoClick = function(h)
        h:SetText('Скопировано!')
        local g = rp.hats.ModelGroups[self.Preview:GetModel()] and rp.hats.ModelGroups[self.Preview:GetModel()] or self.Preview:GetModel()
        local r = '[\'' .. g .. '\'] = {\n'

        if self.SettingsTable.offpos.x ~= 0 or self.SettingsTable.offpos.y ~= 0 or self.SettingsTable.offpos.z ~= 0 then
            r = r .. '	offpos = Vector(' .. self.SettingsTable.offpos.x .. ', ' .. self.SettingsTable.offpos.y .. ', ' .. self.SettingsTable.offpos.z .. '),\n'
        end

        if self.SettingsTable.offang.p ~= 0 or self.SettingsTable.offang.y ~= 0 or self.SettingsTable.offang.r ~= 0 then
            r = r .. '	offang = Angle(' .. self.SettingsTable.offang.p .. ', ' .. self.SettingsTable.offang.y .. ', ' .. self.SettingsTable.offang.r .. '),\n'
        end

        if self.SettingsTable.scale ~= 1 then
            r = r .. '	scale = ' .. self.SettingsTable.scale .. '\n'
        end

        r = r .. '},'
        SetClipboardText(r)

        timer.Simple(2, function()
            if IsValid(h) then
                h:SetText('Copy Settings')
            end
        end)
    end

    self.OpenThread = ui.Create('ui_button', self)
    self.OpenThread:SetText('Скопировать конфиг')
    self.OpenThread:Dock(BOTTOM)
    self.OpenThread:DockMargin(0, 0, 0, 5)

    self.OpenThread.DoClick = function(h)
        gui.OpenURL('https://discord.gg/ZxwRDB4znn')
    end
end

function a:AdjustSettings()
    if not self.SettingsTable then return end
    self.SettingsTable.offpos.x = self.PosX:GetValue()
    self.SettingsTable.offpos.y = self.PosY:GetValue()
    self.SettingsTable.offpos.z = self.PosZ:GetValue()
    self.SettingsTable.offang.p = self.AngP:GetValue()
    self.SettingsTable.offang.y = self.AngY:GetValue()
    self.SettingsTable.offang.r = self.AngR:GetValue()
    self.SettingsTable.scale = self.Scale:GetValue()
end

function a:SetItem(s)
    self.CopySettings:SetDisabled(false)
    local t = table.Copy(s)
    local g = rp.hats.ModelGroups[self.Preview:GetModel()] and rp.hats.ModelGroups[self.Preview:GetModel()] or self.Preview:GetModel()
    local u = t.offsets[g]

    if u then
        t.offpos = Vector(u.offpos.x, u.offpos.y, u.offpos.z)
        t.offang = Angle(u.offang.p, u.offang.y, u.offang.r)
        t.scale = u.scale or s.scale
        t.offsets = {}
    else
        t.offpos = Vector(s.offpos.x, s.offpos.y, s.offpos.z)
        t.offang = Angle(s.offang.p, s.offang.y, s.offang.r)
    end

    self.PosX:SetValue(t.offpos.x)
    self.PosY:SetValue(t.offpos.y)
    self.PosZ:SetValue(t.offpos.z)
    self.AngP:SetValue(t.offang.p)
    self.AngY:SetValue(t.offang.y)
    self.AngR:SetValue(t.offang.r)
    self.Scale:SetValue(t.scale)
    self.SettingsTable = t
end

function a:PerformLayout(n, o)
    self.ModelSelect:SetTall(ui.ButtonHeight)
    self.Spacer1:SetTall(ui.ButtonHeight)
    self.Spacer2:SetTall(ui.ButtonHeight)
    self.CopySettings:SetTall(ui.ButtonHeight)
    self.OpenThread:SetTall(ui.ButtonHeight)
    local v = 0

    for f, j in ipairs(self.Previews) do
        j:SetPos(0, v)
        v = v + j:GetTall() + 5
    end
end

vgui.Register('rp_hatadjustor', a, 'ui_panel')

local function w()
    ui.Create('ui_frame', function(self)
        self:SetSize(ScrW() * 0.75, ScrH() * 0.9)
        self.Adjustment = ui.Create('rp_hatadjustor', self)
        self.Adjustment:DockToFrame()
        self:SetTitle('Редактор Аксессуаров')
        self:Center()
        self:MakePopup()
    end)
end

concommand.Add('apparel_editor', w)

hook.Add('ba.LayoutSettingsPanel', 'rp.apparel.LayoutSettingsPanel', function(x)
    x:AddSpacer('Аксессуары')

    x:AddItem(ui.Create('ui_button', function(self)
        self:SetTall(ui.ButtonHeight)
        self:SetText('Открыть Редактор Аксессуаров')

        self.DoClick = function()
            rp.ToggleF4Menu()
            w()
        end
    end))
end)

concommand.Add('apparel_find', function(y, z, A, B)
    print(B)

    for f, j in pairs(rp.hats.List) do
        if j.name:lower():Contains(B:lower()) then
            PrintTable(j)
        end
    end
end)