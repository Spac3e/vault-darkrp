local a = {}
local b = Color(51, 51, 51)

local function con(v)
    if v then 
        return 1
    else 
        return 0
    end
end

local c = {
    {
        "chkInvite",
        "Может приглашать",
        "Invite"
    },
    {
        "chkKick",
        "Может кикать",
        "Kick"
    },
    {
        "chkRank",
        "Менять ранги",
        "Rank"
    },
    {
        "chkMOTD",
        "Менять MOTD",
        "MoTD"
    }
    -- {
    --     "chkBanner",
    --     "Can Set Flag",
    --     "Banner"
    -- },
    -- {
    --     "chkWithdraw",
    --     "Can Withdraw Funds",
    --     "Withdraw"
    -- },
    -- {
    --     "chkInvWithdraw",
    --     "Can Withdraw Items",
    --     "InvWithdraw"
    -- }
}

function a:Init()
    self:SetTall(30) 
    self.Opened = false
    self.DisableUntil = 0
    self.SaveAt = math.huge
    self.PlayerCount = 0
    
    self.headerRank = ui.Create('ui_button', function(d)
        d:SetZPos(-3)
        d:Dock(TOP)
        d:SetTall(30)
        
        d.DoClick = function(d)
            self:Toggle()
        end
        
        d.lblMem = ui.Create('Panel', function(e)
            e:Dock(RIGHT)
            e:DockMargin(0, 3, 3, 3)
            e:SetWide(30)
            
            e.Paint = function(e, f, g)
                surface.SetFont('ui.18')
                local h = surface.GetTextSize(self.PlayerCount)
                draw.RoundedBox(5, 0, 0, f, g, b)
                surface.SetTextColor(ui.col.White)
                surface.SetTextPos((f - h) * 0.5, 3)
                surface.DrawText(self.PlayerCount)
            end
        end, d)
    end, self)
    
    ui.Create('Panel', function(i)
        i:SetZPos(-3)
        i:Dock(TOP)
        i:SetTall(5)
    end, self)
    self.txtRename = ui.Create('DTextEntry', function(j)
        j:SetZPos(-2)
        j:SetTall(25)
        j:Dock(TOP)
        j:DockMargin(5, 0, 5, 5)
        j:SetVisible(false)
        
        j.OnEnter = function(j, k) end
        j.OnFocusChanged = function(j, l)
            if !l then
                j:SetVisible(false)
                self.btnRename:SetVisible(true)
                self:RenameRank(string.Trim(j:GetValue()))
            end
        end
    end, self)
    
    self.btnRename = ui.Create('ui_button', function(d)
        d:SetZPos(-1)
        d:SetText('Изменить')
        d:SetTall(25)
        d:Dock(TOP)
        d:DockMargin(5, 0, 5, 5)
        
        d.DoClick = function(m)
            d:SetVisible(false)
            self.txtRename:SetVisible(true)
            self.txtRename:RequestFocus()
            self.txtRename:SelectAll()
        end
    end, self)
    
    self.btnMove = ui.Create('ui_button', function(d)
        d:SetZPos(0)
        d:SetText('Задать наследие')
        d:SetTall(25)
        d:Dock(TOP)
        d:DockMargin(5, 0, 5, 5)
        d.DoClick = function(m)
            local n = ui.DermaMenu()
            for o, p in ipairs(self.OrgMenu.OrgRanks) do
                if p.Weight == 1 or p.Name == self.Rank.Name then
                    continue
                end
                n:AddOption(p.Name, function()
                    
                    self.Rank.Weight = p.Weight - 1
                    print(self.Rank.Weight)
                    local gJ = {
                        [1]='Weight',
                        [2]=self.Rank.Weight,
                        [3]= self.Rank.Name 
                        -- Invite = con(self.Rank.Invite),
                        -- Kickk = con(self.Rank.Kick),
                        -- Rank = con(self.Rank.Rank),
                        -- MoTD = con(self.Rank.MoTD)
                    }
                    net.Start("rp.AddEditOrgRank")
                        net.WriteBool(false)
                        net.WriteTable(gJ)
                        -- net.WriteString(self.Rank.Name)
                        -- net.WriteUInt(self.Rank.Weight, 7)
                        -- net.WriteBit(self.Rank.Invite)
                        -- net.WriteBit(self.Rank.Kick)
                        -- net.WriteBit(self.Rank.Rank)
                        -- net.WriteBit(self.Rank.MoTD)

                        -- net.WriteBit(self.Rank.Banner)
                        -- net.WriteBit(self.Rank.Withdraw)
                        -- net.WriteBit(self.Rank.InvWithdraw)
                    net.SendToServer()
                    
                    self.OrgMenu.ReorderRanks(self.Rank.Name)
                end)
            end
            n:Open()
        end
    end, self)
    
    for o, p in ipairs(c) do
        self[p[1]] = ui.Create('ui_checkbox', function(q)
            q:SetZPos(o)
            q:Dock(TOP)
            q:SetText(p[2])
            q:DockMargin(5, 0, 0, 0)
            q:SizeToContents()
            q:SetTall(25)
            q.OnChange = function(m, k)
                // p[3] func
                // p[2] title
                net.Start('rp.AddEditOrgRank')
                net.WriteBool(false)
                net.WriteTable({p[3],con(k),self.Rank.Name})
                net.SendToServer()
                if self.SuppressUpdates then return end
                -- print(self:GetValue())
                self.SaveAt = CurTime() + 0.5
            end
        end, self)
    end
    
    self.btnRemove = ui.Create('ui_button', function(d)
        d:SetZPos(32767)
        d:SetText('Удалить')
        d:SetTall(25)
        d:Dock(TOP)
        d:DockMargin(5, 0, 5, 5)
        d:SetBackgroundColor(ui.col.Red)
        d:EnableConfirmation(true)
        d.DoConfirm = function(d)
            self:RemoveRank()
        end
    end, self)
end

function a:PerformLayout()
    self:GetParent():InvalidateLayout()
end

function a:Paint(f, g)
    draw.RoundedBox(5, 0, 0, f, g, b)
end

function a:Think()
    if CurTime() > self.SaveAt then
        self:SaveRank()
    end
end

function a:Toggle(r)
    self.Opened = not self.Opened
    self.DisableUntil = SysTime() + .75

    if r then
        self:SizeTo(self:GetWide(), 0, .3, 0, .5, function()
            self:Remove()
        end)

        return
    end

    if self.Opened then
        local s

        if self.btnRemove:IsVisible() then
            s = self.btnRemove.y + self.btnRemove:GetTall() + 5
        else
            s = self.chkMOTD.y + self.chkMOTD:GetTall()
        end

        self:SizeTo(self:GetWide(), s, .3, 0, .5)
    else
        self:SizeTo(self:GetWide(), 30, .3, 0, .5)
    end
end

function a:SetOrgMenu(t)
    self.OrgMenu = t
end

function a:SetRankReferences(u)
    self.RankReferences = u
end

function a:SetRank(v)
    self.SuppressUpdates = true
    self.Rank = v
    self.txtRename:SetValue(self.Rank.Name)
    self.headerRank:SetText(self.Rank.Name)
    self.btnRename:SetVisible(self.OrgMenu.Perms.Owner)
    self.btnMove:SetVisible(self.OrgMenu.Perms.Owner and self.Rank.Weight > 1 and self.Rank.Weight < 100)
    self.btnRemove:SetVisible(self.OrgMenu.Perms.Owner and self.Rank.Weight < 100 and self.Rank.Weight > 1)

    for o, p in ipairs(c) do
        local q = self[p[1]]
        q:SetChecked(self.Rank[p[3]])

        if not self.OrgMenu.Perms.Rank or self.Rank.Weight == 100 then
            q:SetDisabled(true)
        end
    end

    self.SuppressUpdates = nil
end

function a:SetPlayerCount(w)
    self.PlayerCount = w
end

function a:RenameRank(x)
    if not self.RankReferences[x] then
        net.Start("rp.RenameOrgRank")
        net.WriteString(self.Rank.Name)
        net.WriteString(x)
        net.SendToServer()
        local y = self.Rank.Name
        self.Rank.Name = x
        self.headerRank:SetText(x)
        self.OrgMenu:NotifyRankRename(y, x)
    end
end

function a:RemoveRank()
    net.Start('rp.RemoveOrgRank')
    net.WriteString(self.Rank.Name)
    net.SendToServer()
    self:Toggle(true)
    self.OrgMenu:NotifyRankRemoved(self.Rank.Name)
end

function a:SaveRank()
    self.SaveAt = math.huge
    local v = self.Rank
    local z = {}
    local A = false

    for o, p in ipairs(c) do
        local q = self[p[1]]
        local k = q:GetChecked()
        z[p[3]] = k

        if k ~= v[p[3]] then
            A = true
        end
    end

    if A then
        -- net.Start("rp.AddEditOrgRank")
        -- net.WriteBool(false)
        -- net.WriteString(v.Name)
        -- net.WriteUInt(v.Weight, 7)

        -- for o, p in ipairs(c) do
        --     local k = z[p[3]]
        --     net.WriteBit(k)
        --     self.Rank[p[3]] = k
        -- end

        -- net.SendToServer()
    end
end

vgui.Register('org_rank_entry', a, 'Panel')