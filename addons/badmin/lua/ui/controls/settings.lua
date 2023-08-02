local a = FindMetaTable'Cvar'

function a:ShouldShow()
    return true
end

function a:SetShouldShow(b)
    self.ShouldShow = b

    return self
end

function a:SetDescription(c)
    self.Description = c

    return self
end

function a:GetDescription()
    return self.Description
end

function a:SetCustomElement(d)
    self:AddMetadata('Type', 'Custom')
    self.CustomElementName = d

    return self
end

function a:GetCustomElement()
    return self.CustomElementName
end

local e = {}

function e:Init()
end

function e:PerformLayout(f, g)
end

vgui.Register('ui_setting', e, 'Panel')
e = {}
Derma_Hook(e, 'Paint', 'Paint', 'Panel')

function e:Populate(h)
    local i = {}

    for j, k in ipairs(cvar.GetOrderedTable()) do
        if k:GetMetadata('Menu') or k:GetCustomElement() then
            local l = k:GetMetadata('Category') or k:GetMetadata('Catagory') or 'Other'

            if not i[l] then
                i[l] = {}
            end

            i[l][#i[l] + 1] = k
        end
    end

    local function m(j, k)
        self:SetSpacing(1)
        self:AddSpacer(j)

        for j, k in ipairs(k) do
            if k:ShouldShow() then
                local n
                local o = k:GetMetadata('Type') or 'bool'

                if o == 'bool' then
                    n = self:AddItem(ui.Create('DPanel', function(self, p)
                        self:SetTall(30)

                        ui.Create('ui_checkbox', function(self, p)
                            self:SetPos(5, 5)
                            self:SetText(k:GetMetadata('Menu'))
                            self:SetConVar(k:GetName())
                            self:SizeToContents()
                        end, self)
                    end))
                elseif o == 'number' then
                    n = self:AddItem(ui.Create('DPanel', function(self, p)
                        self:SetTall(45)

                        ui.Create('DLabel', function(self, p)
                            self:SetFont('ui.18')
                            self:SetColor(ui.col.ButtonText)
                            self:SetText(k:GetMetadata('Menu'))
                            self:SizeToContents()
                            self:SetTall(14)
                            self:SetPos(5, 5)
                        end, self)

                        ui.Create('ui_slider', function(self, p)
                            self:SetValue(k:GetValue())

                            self.OnChange = function(q, r)
                                k:SetValue(r)
                            end

                            self:SetWide(200)
                            self:SetPos(5, 23)
                        end, self)
                    end))
                elseif o == 'Custom' then
                    n = self:AddItem(ui.Create(k:GetCustomElement(), function(self)
                        self:SetCvar(k)
                    end))
                end

                if IsValid(n) and k:GetDescription() then
                    ui.Create('DLabel', function(self, p)
                        self:Dock(BOTTOM)
                        self:SetFont('ui.12')
                        self:SetText(k:GetDescription())
                        self:SetTextInset(5, 0)
                        self:SetTextColor(ui.col.LightGrey)
                        p:SetTall(p:GetTall() + 15)
                    end, n)
                end
            end
        end
    end

    if h then
        for j, k in ipairs(h) do
            if i[k] then
                m(k, i[k])
                i[k] = nil
            end
        end
    end

    for j, k in pairs(i) do
        m(j, k)
    end

    hook.Call('ba.LayoutSettingsPanel', nil, self)
end

function e:DockToFrame()
    local p = self:GetParent()
    local s, t = p:GetDockPos()
    self:SetPos(s, t)
    self:SetSize(p:GetWide() - 10, p:GetTall() - (t + 5))
end

vgui.Register('ui_settingspanel', e, 'ui_listview')