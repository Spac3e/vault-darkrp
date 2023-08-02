local Types = {
    [1] = 'Шапки',
    [2] = 'Маски',
    [3] = 'Очки',
    [4] = 'Шарфы'
}

local icons = {'sup/gui/generic/hat.png', 'sup/gui/generic/mask.png', 'sup/gui/generic/glasses.png', 'sup/gui/generic/scarf.png'}

local function GetCatApparel()
    local type, category = {}, {}

    for f, g in ipairs(Types) do
        type[f] = {}

        for h, i in pairs(rp.hats.Categories) do
            type[f][i] = {
                Name = h
            }
        end

        category[f] = {
            Name = g
        }
    end

    for j, k in ipairs(rp.hats.SortedList) do
        table.insert(type[k.type][rp.hats.Categories[k.category]], k)

        if LocalPlayer():HasApparel(k.UID) then
            table.insert(category[k.type], k)
        end
    end

    return type, category
end

local pnl
local PANEL = {}

function PANEL:Init()
    self.Slot = 1
    self.Model = ui.Create('rp_modelicon', self)
    self.Model:Hide()

    self.Model.Paint = function(n, o, p)
        draw.RoundedBox(5, 0, 0, o, p, ui.col.Black)
    end

    self.Delete = ui.Create('ui_button', self)
    self.Delete:SetText''
    self.Delete:SetTooltip'Remove Preview'
    self.Delete:Hide()

    self.Delete.Paint = function(n, o, p)
        derma.SkinHook('Paint', 'WindowCloseButton', n, o, p)
    end

    self.Delete.DoClick = function()
        for q, r in pairs(self.ApparelObj.slots) do
            pnl:RemoveApparel(q)
        end

        self:InvalidateLayout()
    end

    self.Revert = ui.Create('ui_button', self)
    self.Revert:SetFont'ForkAwesome'
    self.Revert:SetText(utf8.char(0xf112))
    self.Revert:SetTooltip'Вернуться к экипированному предмету'
    self.Revert:Hide()

    self.Revert.DoClick = function()
        local s = LocalPlayer():GetApparel()
        local t = rp.hats.List[s[self.Slot]]
        pnl:AddApparel(t)
    end

    self.Equip = ui.Create('ui_button', self)
    self.Equip:SetText 'Надеть'
    self.Equip:Hide()

    self.Equip.DoClick = function()
        cmd.Run('setapparel', self.ApparelObj.UID)
    end

    self.UnEquip = ui.Create('ui_button', self)
    self.UnEquip:SetText 'Снять'
    self.UnEquip:Hide()

    self.UnEquip.DoClick = function()
        cmd.Run('removeapparel', self.ApparelObj.UID)
    end

    self.BuyCash = ui.Create('ui_button', self)
    self.BuyCash:Hide()

    self.BuyCash.DoClick = function(n)
        if not n.Confirmed then
            n:SetText 'Подтвердить'
            n.Confirmed = true
        else
            cmd.Run('buyapparel', self.ApparelObj.UID)
            n.Confirmed = nil
        end
    end

    self.BuyCash.Think = function(n)
        if self.ApparelObj then
            self:SetEnabled(LocalPlayer():CanAfford(self.ApparelObj.price))
        end
    end

    self.BuyCredits = ui.Create('ui_button', self)
    self.BuyCredits:Hide()
    self.BuyCredits.BackgroundColor = ui.col.DarkGreen
    self.BuyCredits.OutlineColor = ui.col.OffWhite

    self.BuyCredits.DoClick = function(n)
        local price = self.ApparelObj.upgradeobj:GetPrice()

        if not n.Confirm and IGS.CanAfford(LocalPlayer() ,price) then
            n:SetText 'Подтвердить'
            n.Confirm = true
        else
            if not IGS.CanAfford(LocalPlayer(), price) then
                ui.BoolRequest('Упс', 'У вас недостаточно рублей. Вы желаете пополнить счёт?', function(v)
                    if v == true then
                        IGS.WIN.Deposit(self.ApparelObj.credits)
                    end
                end)
            else
                cmd.Run('donateapparel', self.ApparelObj.UID)
            end
        end
    end
end

function PANEL:PerformLayout(o, p)
    self.Model:SetSize(p, p)
    self.Model:SetPos(0, 0)
    self.Delete:SetSize(25, 25)
    self.Delete:SetPos(o - 25, 0)
    self.Revert:SetSize(25, 25)
    self.Revert:SetPos(self.Delete:IsVisible() and self.Delete.X - 25 or self.Delete.X, 0)
    local w = (o - p - 15) * 0.5
    local x, y = p + 5, p - ui.ButtonHeight - 5
    self.Equip:SetSize(o - p - 10, ui.ButtonHeight)
    self.Equip:SetPos(x, y)
    self.UnEquip:SetSize(o - p - 10, ui.ButtonHeight)
    self.UnEquip:SetPos(x, y)
    self.BuyCash:SetSize(w, ui.ButtonHeight)
    self.BuyCash:SetPos(x, y)
    x = x + w + 5
    self.BuyCredits:SetSize(w, ui.ButtonHeight)
    self.BuyCredits:SetPos(x, y)
end

function PANEL:Paint(o, p)
    draw.RoundedBox(5, 0, 0, o, p, ui.col.FlatBlack)

    if self.ApparelObj then
        draw.SimpleText(self.ApparelObj.name, 'ui.17', o * 0.5 + p * 0.5, 5, ui.col.White, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)
    else
        draw.RoundedBox(5, 0, 0, 65, p, ui.col.Black)
        draw.SimpleText('Слот ' .. self.Slot, 'ui.18', 65 * 0.5, p * 0.5, ui.col.White, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
        draw.SimpleText(self.InUse and 'Используется' or 'Пусто', 'ui.17', o * 0.5 + p * 0.5, p * 0.5, ui.col.White, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
    end
end

function PANEL:Think()
    local s = LocalPlayer():GetApparel()

    if s[self.Slot] and (not self.ApparelObj or s[self.Slot] ~= self.ApparelObj.UID) then
        self.Revert:Show()
    else
        self.Revert:Hide()
    end

    if self.ApparelObj then
        local z, A = LocalPlayer():HasApparel(self.ApparelObj.UID), table.HasValue(s, self.ApparelObj.UID)
        self.Model:Show()
        self.Model:SetModel(self.ApparelObj.model, self.ApparelObj.skin or 0)
        self.Delete:Show()

        if z then
            self.BuyCash:Hide()
            self.BuyCredits:Hide()

            if A then
                self.Equip:Hide()
                self.UnEquip:Show()
            else
                self.Equip:Show()
                self.UnEquip:Hide()
            end
        else
            self.Equip:Hide()
            self.UnEquip:Hide()
            self.BuyCash:Show()
            self.BuyCash:SetText(rp.FormatMoney(self.ApparelObj.price))
            self.BuyCredits:Show()
            self.BuyCredits:SetText(string.Comma(self.ApparelObj.upgradeobj:GetPrice()) .. ' Рублей')
        end
    else
        self.Model:Hide()
        self.Delete:Hide()
        self.Equip:Hide()
        self.UnEquip:Hide()
        self.BuyCash:Hide()
        self.BuyCredits:Hide()
    end

    self:InvalidateParent()
end

function PANEL:SetSlot(q)
    self.Slot = q
end

function PANEL:SetInUse(B)
    self.InUse = B
end

function PANEL:SetApparel(C)
    self.ApparelObj = C
end

vgui.Register('rp_apparel_item', PANEL, 'Panel')
cvar.Register'apparel_outfits':SetDefault({}, true)

local function D(E, F)
    local G = cvar.GetValue('apparel_outfits') or {}
    G[E] = F
    cvar.SetValue('apparel_outfits', G)
end

local function H(E)
    local G = cvar.GetValue('apparel_outfits') or {}
    G[E] = nil
    cvar.SetValue('apparel_outfits', G)
end

local function I(E, J)
    local G = cvar.GetValue('apparel_outfits') or {}
    G[J] = G[E]
    G[E] = nil
    cvar.SetValue('apparel_outfits', G)
end

PANEL = {}

function PANEL:Init()
    self.Load = ui.Create('ui_button', self)
    self.Load:Dock(FILL)
    self.Load:SetTooltip'Load'

    self.Load.DoClick = function()
        for j, k in ipairs(self.Outfit) do
            local C = rp.hats.List[k]
            pnl:AddApparel(C)
        end

        self.OutfitPnl:Hide()
    end

    self.Delete = ui.Create('ui_button', self)
    self.Delete:SetFont'ForkAwesome'
    self.Delete:SetText(utf8.char(0xf1f8))
    self.Delete:SetTooltip'Remove'
    self.Delete:Dock(RIGHT)

    self.Delete.DoClick = function()
        ui.BoolRequest('Remove Outfit', 'Are you sure you\'type like to remove ' .. self.Name .. '?', function(v)
            if v then
                H(self.Name)
                self:Remove()
            end
        end)
    end

    self.Rename = ui.Create('ui_button', self)
    self.Rename:SetFont'ForkAwesome'
    self.Rename:SetText(utf8.char(0xf044))
    self.Rename:SetTooltip'Rename'
    self.Rename:Dock(RIGHT)

    self.Rename.DoClick = function()
        ui.StringRequest('Rename Outfit', 'What would you like to rename ' .. self.Name .. ' to?', 'Outfit #' .. table.Count(cvar.GetValue('apparel_outfits')) + 1, function(v)
            I(self.Name, v)
            self.Name = v
            self.Load:SetText(v)
        end)
    end
end

function PANEL:PerformLayout(o, p)
    self.Delete:SetSize(p, p)
    self.Rename:SetSize(p, p)
end

function PANEL:SetOutfit(E, F)
    self.Name = E
    self.Outfit = F
    self.Load:SetText(E)
end

vgui.Register('rp_apparel_outfit', PANEL, 'Panel')
PANEL = {}

function PANEL:Init()
    self.List = ui.Create('ui_listview', self)
    self.List:SetSpacing(1)
    self.List:Dock(FILL)
    local G = cvar.GetValue('apparel_outfits') or {}

    for E, F in pairs(G) do
        self:AddOutfit(E, F)
    end
end

function PANEL:Paint(o, p)
    draw.Box(0, 0, o, p, ui.col.Black)
end

function PANEL:AddOutfit(E, F)
    self.List:AddItem(ui.Create('rp_apparel_outfit', function(n)
        n.OutfitPnl = self
        n:SetOutfit(E, F)
    end))
end

vgui.Register('rp_apparel_outfits', PANEL, 'Panel')
PANEL = {}

function PANEL:Init()
    self.Apparel = {}
    pnl = self
    self.Model = ui.Create('rp_playerpreview', self)
    self.Model:SetFOV(15)
    local K = self.Model.ModelPanel:GetCamPos()
    K.z = K.z + 60
    self.Model.ModelPanel:SetCamPos(K)
    local L = self.Model.ModelPanel:GetLookAt()
    L.z = L.z + 20
    self.Model.ModelPanel:SetLookAt(L)

    self.Model.UpdateApparel = function(n)
        local M = {}

        for j, k in pairs(self.Apparel) do
            M[j] = k.UID
        end

        self.Model:SetApparel(M)
    end

    self.OutfitManager = ui.Create('rp_apparel_outfits', self)
    self.OutfitManager:Hide()
    self.ManageOutfits = ui.Create('ui_button', self.Model)
    self.ManageOutfits:SetFont'ForkAwesome'
    self.ManageOutfits:SetText(utf8.char(0xf0ea))
    self.ManageOutfits:SetTooltip'Manage Outfits'

    self.ManageOutfits.DoClick = function(n)
        self.OutfitManager:SetVisible(not self.OutfitManager:IsVisible())
    end

    self.SaveOutfit = ui.Create('ui_button', self.Model)
    self.SaveOutfit:SetFont'ForkAwesome'
    self.SaveOutfit:SetText(utf8.char(0xf0c7))
    self.SaveOutfit:SetTooltip'Save Outfit'

    self.SaveOutfit.DoClick = function(n)
        ui.StringRequest('Save Outfit', 'What would you like to name this outfit?', 'Outfit #' .. table.Count(cvar.GetValue('apparel_outfits')) + 1, function(v)
            local F = {}

            for j, k in pairs(self.Apparel) do
                table.insert(F, k.UID)
            end

            D(v, F)
            self.OutfitManager:AddOutfit(v, F)
        end)
    end

    self.SaveOutfit.Think = function(n)
        n:SetDisabled(table.Count(self.Apparel) == 0)
    end

    self.Items = {}

    for q = 1, 5 do
        self.Items[q] = ui.Create('rp_apparel_item', self)
        self.Items[q]:SetSlot(q)
    end

    for q, N in pairs(LocalPlayer():GetApparel()) do
        local C = rp.hats.List[N]
        self:AddApparel(C)
    end
end

function PANEL:PerformLayout(o, p)
    local O = 5

    for j, k in ipairs(self.Items) do
        k:SetSize(o - 10, k.ApparelObj and 65 or 30)
        k:SetPos(5, O)
        O = O + k:GetTall() + 5
    end

    self.Model:SetPos(5, O)
    self.Model:SetSize(o - 10, p - O - 5)
    self.OutfitManager:SetPos(self.Model.X, self.Model.Y + 30)
    self.OutfitManager:SetSize(self.Model:GetSize())
    self.OutfitManager:SetTall(self.OutfitManager:GetTall() - 30)
    self.ManageOutfits:SetPos(0, 0)
    self.ManageOutfits:SetSize(25, 25)
    self.SaveOutfit:SetPos(30, 0)
    self.SaveOutfit:SetSize(25, 25)
end

function PANEL:Paint(o, p)
    draw.RoundedBox(5, 0, 0, o, p, ui.col.Background)
end

function PANEL:AddApparel(C)
    for r, P in pairs(self.Apparel) do
        for q = 1, 5 do
            if C.slots[q] and P.slots[q] then
                self:RemoveApparel(q)
            end
        end
    end

    local Q = math.huge

    for q, r in pairs(C.slots) do
        if q < Q then
            Q = q
        end

        self.Items[q]:SetInUse(true)
        self.Apparel[q] = C
    end

    self.Items[Q]:SetApparel(C)
    self.Model:UpdateApparel()
end

function PANEL:RemoveApparel(q)
    local C = self.Apparel[q]

    if C then
        for q, r in pairs(C.slots) do
            self.Items[q]:SetInUse(false)
            self.Items[q]:SetApparel(nil)
            self.Apparel[q] = nil
        end

        self.Model:UpdateApparel()
    end
end

vgui.Register('rp_apparel_preview', PANEL, 'Panel')
PANEL = {}

function PANEL:Init()
    self.List = ui.Create('ui_listview', self)
end

function PANEL:PerformLayout(o, p)
    self.List:SetSize(o, p)
    self.List:SetPos(0, 0)

    if not self.AddedApparel then
        self:AddApparel(self.TypeSet)
        self.AddedApparel = true
    end
end

function PANEL:AddApparel(R)
    local S = 5
    local T = self.List:GetWide() / S - S * 0.5

    for r, U in ipairs(R) do
        if #U == 0 then continue end
        local V, W = 0, 1
        local X = ui.Create('ui_collapsible_section')
        X:SetText(U.Name)

        X.OnCollapsing = function()
            self.List:InvalidateLayout()
        end

        self.List:AddItem(X)

        table.sort(U, function(Y, Z)
            return Y.price < Z.price
        end)

        for r, C in ipairs(U) do
            if V == S then
                V = 0
                W = W + T + 1
            end

            X:AddItem(ui.Create('rp_shopbutton', function(_)
                _:SetFont('ui.14')
                _:SetTitle(C.name)
                _:SetHoverText('Предпросмотр')
                _:SetBottomText(LocalPlayer():HasApparel(C.UID) and 'Куплено' or rp.FormatMoney(C.price))
                _:SetSize(T, T)
                _:SetPos(V * T + V, W)
                _:SetModel(C.model, C.skin or 0)

                _.DoClick = function()
                    pnl:AddApparel(C)
                end

               _:SetTooltip(C.name .. '\n' .. rp.FormatMoney(C.price) .. '\n -ИЛИ-\n' .. string.Comma(C.credits) .. ' Рублей')
            end))

            V = V + 1
        end

        V = 0
        W = W + T + 1
        X:SetTall(W)
    end
end

vgui.Register('rp_apparel_store', PANEL, 'Panel')
local a0 = false
PANEL = {}



function PANEL:PerformLayout(o, p)
    self.Close:SetWide(150)
    self.DoIt:SetWide(150)
end

vgui.Register('rp_apparel_tf2', PANEL, 'Panel')
PANEL = {}

function PANEL:Init()
    self.Tabs = ui.Create('ui_tablist_horizontal', self)
    local a3, category = GetCatApparel()

    for f, R in ipairs(a3) do
        self.Tabs:AddTab(Types[f], function()
            local a4 = ui.Create'rp_apparel_store'
            a4.TypeSet = R

            return a4
        end, f == 1):SetIcon(icons[f])
    end

    self.Tabs:AddTab('Шкафчик', function()
        local a4 = ui.Create 'rp_apparel_store'
        a4.TypeSet = category

        return a4
    end):SetIcon'sup/gui/generic/wardrobe.png'

    self.Preview = ui.Create('rp_apparel_preview', self)

//    if not IsMounted('tf') and not a0 then
//        self.Tf2Prompt = ui.Create('rp_apparel_tf2', self)
//        self.Tf2Prompt:Dock(TOP)
//    end
end

function PANEL:PerformLayout(o, p)
    local a5 = o * 0.65
    self.Tabs:SetSize(a5, p - 10)
    self.Tabs:SetPos(0, 0)
    local a6 = o * .65
    local a7 = o * .35 - 5
    self.Preview:SetSize(a7, p - 10)
    self.Preview:SetPos(a6, 5)

//    if IsValid(self.Tf2Prompt) then
//        self.Tf2Prompt:SetTall(100)
 //   end
end

function PANEL:AddControls(a8)
    if IsValid(self.BuyMoreCredits) then
        self.BuyMoreCredits:Show()
    elseif IsValid(a8) then
        self.BuyMoreCredits = ui.Create('ui_button', a8)
        self.BuyMoreCredits:SetText('Пополнить счёт' .. rp.cfg.CreditSale)
        self.BuyMoreCredits.BackgroundColor = ui.col.DarkGreen
        self.BuyMoreCredits:SizeToContents()
        self.BuyMoreCredits:SetSize(self.BuyMoreCredits:GetWide() + 10, a8.btnClose:GetTall())
        self.BuyMoreCredits:SetPos(a8.btnClose.x - self.BuyMoreCredits:GetWide() + 1, 0)

        self.BuyMoreCredits.DoClick = function(n)
            IGS.WIN.Deposit() 
        end
    end

    if IsValid(self.CreditsBalance) then
        self.CreditsBalance:Show()
    elseif IsValid(a8) then
        self.CreditsBalance = ui.Create('ui_button', a8)
        self.CreditsBalance:SetDisabled(true)
        self.CreditsBalance.TextColor = rp.col.Yellow
        self.CreditsBalance:SetText(string.Comma(LocalPlayer():IGSFunds()) .. ' Рублей')
        self.CreditsBalance:SizeToContents()
        self.CreditsBalance:SetSize(self.CreditsBalance:GetWide() + 10, a8.btnClose:GetTall())
        self.CreditsBalance:SetPos(self.BuyMoreCredits.x - self.CreditsBalance:GetWide() + 1, 0)
    end
end

function PANEL:HideControls()
    if IsValid(self.BuyCredits) then
        self.BuyMoreCredits:Hide()
    end

    if IsValid(self.CreditsBalance) then
        self.CreditsBalance:Hide()
    end
end

vgui.Register('rp_apparel_panel', PANEL, 'ui_tablist_horizontal')