local a = {}
Derma_Hook(a, 'Paint', 'Paint', 'UIListView')

function a:Init()
    self.Rows = {}
    self.SearchResults = {}
    self.HideInvisible = true
    self.RowHeight = ui.ButtonHeight
    self:SetSpacing(1)
end

function a:SetRowHeight(b)
    self.RowHeight = b
end

function a:AddCustomRow(c, d)
    self:AddItem(c)
    self.Rows[#self.Rows + 1] = c
    self.SearchResults[#self.SearchResults + 1] = c

    return c
end

function a:AddRow(e, d)
    local c = ui.Create('ui_button', function(f)
        f:SetText(tostring(e))
        f:SetTall(self.RowHeight)

        if d == true then
            f:SetDisabled(true)
        end
    end)

    self:AddItem(c)
    self.Rows[#self.Rows + 1] = c
    self.SearchResults[#self.SearchResults + 1] = c

    c.DoClick = function()
        if IsValid(self.Selected) then
            self.Selected.Active = false
        end

        c.Active = true
        self.Selected = c
    end

    return c
end

function a:AddImageRow()
    local g = ui.Create('ui_imagerow')
    self.Rows[#self.Rows + 1] = g

    g.DoClick = function()
        if IsValid(self.Selected) then
            self.Selected.Active = false
        end

        g.Active = true
        self.Selected = g
    end

    self:AddItem(g)

    return g
end

function a:AddPlayer(h, i)
    local g = self:AddImageRow()
    g:SetPlayer(h, i)

    return g
end

function a:AddSpacer(e)
    local c = self:AddRow(e, true)
    c:SetTall(ui.SpacerHeight)
    c:SetFont('ui.20')

    return c
end

function a:GetSelected()
    return self.Selected
end

function a:Search(e)
    self.SearchResults = {}

    if not e or e == '' then
        for j, k in ipairs(self.Rows) do
            if IsValid(k) then
                k:SetVisible(true)
                self.SearchResults[#self.SearchResults + 1] = k
            end
        end

        if IsValid(self.NoResultsSpacer) then
            self.NoResultsSpacer:Remove()
        end

        self:PerformLayout()
    else
        local l = 0

        for j, k in ipairs(self.Rows) do
            if not IsValid(k) then continue end

            if self:FilterSearchResult(k, e) then
                l = l + 1
                k:SetVisible(true)
                self.SearchResults[#self.SearchResults + 1] = k
            else
                k:SetVisible(false)
            end
        end

        if l == 0 then
            if IsValid(self.NoResultsSpacer) then
                self.NoResultsSpacer:SetVisible(true)
            else
                self.NoResultsSpacer = self:AddSpacer(self.NoResultsMessage or 'No results found!')
            end
        elseif IsValid(self.NoResultsSpacer) then
            self.NoResultsSpacer:SetVisible(false)
        end

        self:PerformLayout()
    end
end

function a:SetNoResultsMessage(m)
    self.NoResultsMessage = m
end

function a:GetSearchResults()
    return self.SearchResults
end

function a:FilterSearchResult(c, e)
    return string.find(c:GetText():lower(), e:lower(), 1, true) ~= nil
end

function a:PaintOver(n, o)
    if self.PlaceholderMessage and self:ShouldDrawPlaceholder() then
        draw.RoundedBox(5, 0, 0, n, o, ui.col.Background)
        draw.SimpleText(self.PlaceholderMessage, 'ui.24', n * 0.5, o * 0.5, ui.col.White, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
    end
end

function a:SetPlaceholderText(m)
    self.PlaceholderMessage = m
end

function a:ShouldDrawPlaceholder()
    return #self.Rows == 0
end

vgui.Register('ui_listview', a, 'ui_scrollpanel')