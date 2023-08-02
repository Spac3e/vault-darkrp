local a = {}
local b = Color(51, 51, 51)

function a:Init()
end

function a:Paint(c, d)
    draw.RoundedBoxEx(5, 0, 0, c, d, b, false, false, true, true)
end

function a:SetTabElement(e)
    self.TabElement = e
end

function a:SetOrgMenu(f)
    self.OrgMenu = f
end

function a:OnOpen()
end

function a:OnClose()
end

vgui.Register('org_tab_panel', a, 'Panel')