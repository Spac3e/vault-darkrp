local a = {}

function a:Init()
    self.TextArea = ui.Create('HTML', function(b)
        b:Dock(FILL)
    end, self)
end

function a:Paint(c, d)
    draw.RoundedBoxEx(5, 0, 0, c, d, self.bgCol, false, false, true, true)
end

function a:SetBackgroundColor(e)
    self.bgCol = e
end

function a:SetContent(f, g)
    if f then
        self:SetBackgroundColor(Color(51, 51, 51))
    else
        self:SetBackgroundColor(Color(241, 241, 241))
    end

    local h = '<head><style type="text/css">' .. (f and rp.orgs.MDStyleDark or rp.orgs.MDStyleLight) .. '</style></head><body class="markdown-body">' .. rp.orgs.ParseMarkdown(g) .. "</body>"
    self.TextArea:SetHTML(h)
end

function a:SetTabElement(i)
    self.BaseClass.SetTabElement(self, i)

    if self.OrgMenu.Perms.MoTD then
        self.TabElement.btnEdit = ui.Create('ui_button', function(j)
            j:Dock(RIGHT)
            j:DockMargin(0, 3, 3, 3)
            j:SetWide(30)
            j:SetFont('ForkAwesome')
            j:SetText(utf8.char(0xf040))
            j:SetContentAlignment(4)
            j:SetTextInset(9, 1)
            local k

            j.DoClick = function(j)
                if IsValid(self.OrgMenu.overMoTD) then
                    j:SetTextColor(ui.col.White)
                    j:SetText(utf8.char(0xf040))
                    self.OrgMenu.overMoTD:Remove()
                    if self.OrgMenu.MOTD.Text == k.Text and self.OrgMenu.MOTD.Dark == k.Dark then return end
                    self.OrgMenu.MOTD.Dark = k.Dark
                    self.OrgMenu.MOTD.Text = k.Text
                    net.Start('rp.SetOrgMoTD')
                        net.WriteString(self.OrgMenu.MOTD.Text)
                        net.WriteBit(self.OrgMenu.MOTD.Dark == true)
                    net.SendToServer()
                else
                    j:SetTextColor(ui.col.Green)
                    j:SetText(utf8.char(0xf00c))

                    k = {
                        Dark = self.OrgMenu.MOTD.Dark,
                        Text = self.OrgMenu.MOTD.Text
                    }

                    self.OrgMenu.overMoTD = ui.Create('org_motd_editor', function(l)
                        l:SetPos(self.OrgMenu.colLeft:GetPos())
                        l:SetSize(self.OrgMenu.colMid.x + self.OrgMenu.colMid:GetWide(), self.OrgMenu.colLeft:GetTall())
                        l:SetValue(k.Dark, k.Text)

                        l.OnUpdated = function(l, f, m)
                            k.Dark = f
                            k.Text = m
                            self:SetContent(f, m)
                        end
                    end, self.OrgMenu)
                end
            end
        end, self.TabElement)
    end
end

vgui.Register('org_motd', a, 'org_tab_panel')