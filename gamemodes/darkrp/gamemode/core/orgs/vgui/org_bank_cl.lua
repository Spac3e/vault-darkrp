local a = {}

function a:Init()
    self.pnlTop = ui.Create('Panel', function(b)
        b:Dock(TOP)
    end, self)

    self.pnlBottom = ui.Create('Panel', function(b)
        b:Dock(FILL)
    end, self)

    self.pnlTopPusher = ui.Create('Panel', function(b)
        b:Dock(RIGHT)
    end, self.pnlTop)

    self.pnlTopContent = ui.Create('Panel', function(b)
        b:Dock(RIGHT)
    end, self.pnlTop)

    self.btnFunds = ui.Create('ui_button', function(c)
        c:Dock(TOP)
        c:DockMargin(0, 5, 0, 0)
        c:SetTall(30)
        c:SetDisabled(true)
        c:SetCursor('arrow')
    end, self.pnlTopContent)

    self.lblAmount = ui.Create('DLabel', function(d)
        d:Dock(TOP)
        d:DockMargin(0, 5, 0, 0)
        d:SetText('Amount')
        d:SetFont('ui.24')
        d:SizeToContentsY()
    end, self.pnlTopContent)

    self.txtAmount = ui.Create('DTextEntry', function(e)
        e:Dock(TOP)
        e:DockMargin(0, 5, 0, 0)
        e:SetTall(30)
        e:SetFont('ui.22')
    end, self.pnlTopContent)

    self.lblWarning = ui.Create('DLabel', function(d)
        d:Dock(TOP)
        d:DockMargin(0, 5, 0, 0)
        d:SetFont('ui.15')
        d:SetText('Withdrawal/Deposits are taxed ' .. rp.cfg.OrgBankTax * 100 .. '%')
        d:SizeToContentsY()
        d:SetTextColor(rp.col.Red)
    end, self.pnlTopContent)

    self.btnDeposit = ui.Create('ui_button', function(c)
        c:Dock(TOP)
        c:DockMargin(0, 5, 0, 0)
        c:SetTall(30)
        c:SetText('Deposit')

        c.DoClick = function(c)
            local f = self:GetInputAmount()
            self.OrgMenu.Funds = self.OrgMenu.Funds + f * (1 - rp.cfg.OrgBankTax)
            net.Start("rp.OrgBankDeposit")
            net.WriteUInt(f, 32)
            net.SendToServer()
        end
    end, self.pnlTopContent)

    self.btnWithdraw = ui.Create('ui_button', function(c)
        c:Dock(TOP)
        c:DockMargin(0, 5, 0, 0)
        c:SetTall(30)
        c:SetText('Withdraw')

        c.DoClick = function(c)
            local f = self:GetInputAmount()
            self.OrgMenu.Funds = self.OrgMenu.Funds - f * (1 + rp.cfg.OrgBankTax)
            net.Start("rp.OrgBankWithdraw")
            net.WriteUInt(f, 32)
            net.SendToServer()
        end
    end, self.pnlTopContent)

    self.pnlBottomLeft = ui.Create('Panel', function(b)
        b:Dock(LEFT)
    end, self.pnlBottom)

    self.pnlBottomRight = ui.Create('Panel', function(b)
        b:Dock(RIGHT)
    end, self.pnlBottom)

    self.lblPocket = ui.Create('ui_button', function(c)
        c:SetText('Pocket')
        c:Dock(TOP)
        c:DockMargin(5, 5, 2.5, 5)
        c:SetTall(30)
        c:SetDisabled(true)
        c:SetCursor('arrow')
    end, self.pnlBottomLeft)

    self.playerPocket = ui.Create('org_pocket', function(b)
        b:Dock(FILL)
        b:SetData(rp.pocket.Data or {})
    end, self.pnlBottomLeft)

    self.lblInventory = ui.Create('ui_button', function(c)
        c:SetText('Org Inventory')
        c:Dock(TOP)
        c:DockMargin(2.5, 5, 5, 5)
        c:SetTall(30)
        c:SetDisabled(true)
        c:SetCursor('arrow')
    end, self.pnlBottomRight)

    self.orgInventory = ui.Create('org_inventory', function(b)
        b:Dock(FILL)
    end, self.pnlBottomRight)

    hook('PlayerPocketUpdated', self, function()
        self.playerPocket:SetData(rp.pocket.Data or {})
        local g = self.OrgMenu.InventorySpace > self.orgInventory.ItemAmount
        self.playerPocket:EnableDeposit(g)
    end)
end

function a:PerformLayout()
    self.pnlTop:SetTall(self.btnWithdraw.y + self.btnWithdraw:GetTall() + 5)
    local h = math.max(300, self:GetWide() / 3)
    self.pnlTopContent:SetWide(h)
    self.pnlTopPusher:SetWide((self:GetWide() - h) * 0.5)
    local i = self:GetWide() / 2
    self.pnlBottomLeft:SetWide(i)
    self.pnlBottomRight:SetWide(i)
end

function a:Think()
    local f = self:GetInputAmount()

    if f <= 1 then
        self.btnDeposit:SetDisabled(true)
        self.btnWithdraw:SetDisabled(true)
        self.btnDeposit:SetText('Deposit')
        self.btnWithdraw:SetText('Withdraw')
    else
        if not self.OrgMenu.Perms.Withdraw then
            self.btnWithdraw:SetDisabled(true)
        else
            if f > self.OrgMenu.Funds * (1 + rp.cfg.OrgBankTax) then
                self.btnWithdraw:SetDisabled(true)
            else
                self.btnWithdraw:SetDisabled(false)
            end
        end

        self.lblAmount:SetText('Amount (' .. string.FormatUSD(math.ceil(f * rp.cfg.OrgBankTax)) .. ' tax)')
        local j = f - f * rp.cfg.OrgBankTax
        self.btnDeposit:SetText('Deposit ' .. string.FormatUSD(math.floor(j)))
        self.btnWithdraw:SetText('Withdraw ' .. string.FormatUSD(math.floor(j)))

        if f > LocalPlayer():GetMoney() then
            self.btnDeposit:SetDisabled(true)
        else
            self.btnDeposit:SetDisabled(false)
        end
    end
end

function a:GetInputAmount()
    if not tonumber(self.txtAmount:GetValue()) then return 0 end
    local f = math.floor(tonumber(self.txtAmount:GetValue()))

    if self.txtAmount:GetValue() ~= tostring(f) then
        self.txtAmount:SetValue(f)
    end

    return f
end

function a:SetOrgMenu(k)
    self.BaseClass.SetOrgMenu(self, k)
    self.orgInventory:SetOrgMenu(k)
    self.btnFunds:SetText('Bank: ' .. string.FormatUSD(self.OrgMenu.Funds))
    self:UpdateOrgInventory()
end

function a:UpdateOrgInventory()
    self.orgInventory:Update()
    local g = self.OrgMenu.InventorySpace > self.orgInventory.ItemAmount
    self.playerPocket:EnableDeposit(g)
end

vgui.Register('org_bank', a, 'org_tab_panel')