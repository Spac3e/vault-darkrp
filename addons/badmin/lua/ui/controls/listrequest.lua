local a = {}

function a:Init()
    self.OptionList = ui.Create('ui_listview', self)
end

function a:PerformLayout()
    self.OptionList:SetPos(0, 0)
    self.OptionList:SetSize(self:GetWide(), self:GetTall())
end

function a:SetOptions(b)
    self.OptionList:Reset()
    local c = 0

    for d, e in ipairs(b) do
        self.OptionList:AddRow(e).DoClick = function(f)
            self:OnSelection(f, e)
        end

        c = c + 1
    end

    if c <= 0 then
        self.OptionList:AddSpacer('No options found!')
    end
end

function a:OnSelection(f, g)
end

function a:DockToFrame()
    local h = self:GetParent()
    local i, j = h:GetDockPos()
    self:SetPos(i, j)
    self:SetSize(h:GetWide() - 10, h:GetTall() - (j + 5))
end

vgui.Register('ui_listrequest', a, 'Panel')