local a = {}

function a:Init()
    self.colPickerPanel = ui.Create('org_color_picker', function(self)
        self:Dock(TOP)
    end, self)
end

function a:PerformLayout()
    self.colPickerPanel:SetTall(math.max(300, self:GetTall() / 3))
end

function a:SetOrgMenu(b)
    self.BaseClass.SetOrgMenu(self, b)

    if not self.OrgMenu.Perms.Owner then
        self.colPickerPanel:SetMouseInputEnabled(false)
    end
end

vgui.Register('org_settings', a, 'org_tab_panel')