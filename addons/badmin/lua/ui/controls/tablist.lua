local a = {}

function a:Init()
    self.tabList = ui.Create('ui_scrollpanel', function(b)
        b:SetSize(150, 0)
        b:DockMargin(5, 5, 5, 5)
        b:Dock(LEFT)
        b:SetSpacing(5)
    end, self)

    self.Buttons = {}
end

function a:GetButtons()
    return self.Buttons
end

function a:SetActiveTab(c)
    self.ActiveTabID = c

    for d, e in ipairs(self.Buttons) do
        e.Active = c == d

        if IsValid(e.Tab) and e.Tab:IsVisible() then
            e.Tab:Dock(NODOCK)
            e.Tab:SetVisible(false)
        end

        if c == d then
            if not e.FinishedLayout then
                e:LayoutTab()
            end

            e.Tab:SetVisible(true)
            e.Tab:DockMargin(0, 0, 0, 0)
            e.Tab:Dock(FILL)
            self:TabChanged(e.Tab)
        end
    end
end

function a:TabChanged(tab)
end

function a:GetActiveTab()
    for d, e in ipairs(self.Buttons) do
        if e.Active then return e.Tab end
    end
end

function a:GetActiveTabID()
    return self.ActiveTabID
end

local function f(g, tab, h)
    local i = ui.Create('ui_button', function(btn)
        btn:SetSize(0, 40)
        btn:SetText(g)

        btn.DoClick = function(self)
            h(self)
        end

        btn.Paint = function(btn, j, k)
            derma.SkinHook('Paint', 'TabButton', btn, j, k)
        end
    end)

    return i
end

function a:AddTab(g, l, m)
    local i = f(g, tab, function(n)
        if !n.FinishedLayout then
            n:LayoutTab()
        end
        
        self:SetActiveTab(n.ID)
    end)
    
    function i.LayoutTab(n)
        local tab = isfunction(l) and l(self) or l
        
        tab.Paint = function(tab, j, k) end
        
        tab:SetSize(self:GetWide() - 160, self:GetTall())
        tab:SetVisible(false)
        tab:SetParent(self)
        tab:SetSkin(self:GetSkin().PrintName)
        n.Tab = tab
        n.FinishedLayout = true
    end
    
    if !isfunction(l) then
        i:LayoutTab()
    end
    i.ID = table.insert(self.Buttons, i)
    self.tabList:AddItem(i)
    if m then
        self:SetActiveTab(i.ID)
    end
    
    return i
end

local o

function a:AddButton(g, h)
    local i = f(g, tab, h)
    self.tabList:AddItem(i)
    table.insert(self.Buttons, btn)
    o = self

    return i
end

function a:DockToFrame()
    local p = self:GetParent()
    local q, r = p:GetDockPos()
    r = r - 5
    self:SetPos(0, r)
    self:SetSize(p:GetWide(), p:GetTall() - r)
end

function a:Paint(j, k)
    derma.SkinHook('Paint', 'TabListPanel', self, j, k)
end

vgui.Register('ui_tablist', a, 'Panel')