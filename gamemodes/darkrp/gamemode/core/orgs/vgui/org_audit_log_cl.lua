local a = {}

function a:Init()
    self.pnlLogs = ui.Create('ui_listview', function(self, b)
        self:Dock(FILL)
        self:DockMargin(5, 5, 5, 5)
    end, self)
end

function a:SetOrgMenu(c)
    self.BaseClass.SetOrgMenu(self, c)

    net('rp.OrgLog', function()
        self:LoadLog()
    end)
end

function a:OnOpen()
    cmd.Run('orglog')
end

function a:LoadLog()
    self.pnlLogs:Reset(true)

    for d = 1, net.ReadUInt(8) do
        local e = net.ReadUInt(32)
        local f = net.ReadString()
        local g = os.date("[%H:%M:%S - %m/%d/%Y] ", e)
        local h = g .. f
        local i = self.pnlLogs:AddRow(h)
        i:SetTooltip(h)
        i:SetContentAlignment(4)
        i:SetTextInset(5, 0)

        i.DoClick = function(i)
            local j = ui.DermaMenu(i)

            j:AddOption('Copy Log', function()
                SetClipboardText(i:GetText())
            end)

            j:AddOption('Copy Date', function()
                SetClipboardText(g)
            end)

            j:Open()
        end
    end
end

vgui.Register('org_audit_log', a, 'org_tab_panel')