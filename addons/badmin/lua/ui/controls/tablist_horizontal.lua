local a = {}

function a:Init()
    self.Buttons = {}
end

function a:PerformLayout(b, c)
    local d = 5

    for e, f in ipairs(self.Buttons) do
        f:SetPos(d, 5)
        f:SetTall(40)
        f:SizeToContentsX()
        f:SetWide(f:GetWide() + 10)
        d = d + f:GetWide() + 5

        if IsValid(f.Tab) then
            f.Tab:SetSize(b - 10, c - 50)
            f.Tab:SetPos(5, 50)
        end
    end
end

function a:SetActiveTab(g)
    if IsValid(self.ActiveTab) then
        self.ActiveTab:SetVisible(false)
    end

    for e, f in ipairs(self.Buttons) do
        f.Active = g == e

        if e == g then
            if not f.FinishedLayout then
                f:LayoutTab()
            end

            f.Tab:SetVisible(true)
            self.ActiveTab = f.Tab
        end
    end
end

local function h(i, tab, j)
    local k = ui.Create('ui_button', function(l)
        l:SetText(i)

        l.DoClick = function(self)
            j(self)
        end

        l.Paint = function(l, b, c)
            derma.SkinHook('Paint', 'TabButton', l, b, c)
        end
    end)

    return k
end

function a:AddTab(i, m, n)
    local k = h(i, tab, function(o)
        if !o.FinishedLayout then
            o:LayoutTab()
        end
        
        self:SetActiveTab(o.ID)
    end)
    
    k:SetParent(self)
    
    function k.LayoutTab(o)
        local tab = isfunction(m) and m(self) or m
        
        tab.Paint = function(tab, b, c) end
        tab:SetVisible(false)
        tab:SetParent(self)
        tab:SetSkin(self:GetSkin().PrintName)
        o.Tab = tab
        o.FinishedLayout = true
    end
    
    k.ID = table.insert(self.Buttons, k)
    if n then
        if !isfunction(m) then
            k:LayoutTab()
        end
        
        self:SetActiveTab(k.ID)
    end
    
    return k
end

function a:DockToFrame()
    local p = self:GetParent()
    local d, q = p:GetDockPos()
    q = q - 5
    self:SetPos(0, q)
    self:SetSize(p:GetWide(), p:GetTall() - q)
end

vgui.Register('ui_tablist_horizontal', a, 'Panel')