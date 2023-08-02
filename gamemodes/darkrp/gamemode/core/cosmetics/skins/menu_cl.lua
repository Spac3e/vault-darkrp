local PANEL = {}

function PANEL:Init()
    self.List = ui.Create('ui_listview', self)
    self.List:SetSpacing(1)
    
    self.Name = ui.Create('ui_button', self)
    self.Name:SetDisabled(true)
    self.Name:SetText('Выберите скин')
    
    self.Weapon = ui.Create('DComboBox', self)
    local activeWep = LocalPlayer():GetActiveWeapon()
    local activeWepIsValid = IsValid(activeWep) and rp.skins.IsValidWeaponClass(activeWep:GetClass())
    
    self.Weapon:AddChoice('Физическая Пушка', 'models/weapons/w_Physics.mdl', true)

    for k, v in ipairs(weapons.GetList()) do
        if rp.skins.IsValidWeaponClass(v.ClassName) and (v.ClassName:Contains('m9k') or v.ClassName:Contains('swb')) then
            self.Weapon:AddChoice(v.PrintName, v, activeWepIsValid and (v.ClassName == activeWep:GetClass()) or false)
        end
    end

    self.Weapon.OnSelect = function(s, index, text, data)
        _, cat = self.Weapon:GetSelected()
        self.Preview:SetModel(isstring(data) and data or data.WorldModel)
    end

    self.Preview = ui.Create('DModelPanel', self)
    local selected, data = self.Weapon:GetSelected()
    cat = data
    self.Preview:SetModel(isstring(data) and data or data.WorldModel)
    self.Preview:SetFOV(100)
    self.Preview:SetCamPos(Vector(0, 25, 0))
    self.Preview:SetLookAt(Vector(0, 0, 0))
    self.Preview._Paint = self.Preview._Paint or self.Preview.Paint

    self.Preview.Paint = function(s, w, h)
        self.Preview._Paint(s, w, h)
    end

    self.Preview.PreDrawModel = function(s, ent)
        if self.Texture then
            rp.skins.Draw(ent, self.Texture)
        end
    end

    local function GetWep(a)
        local c = 1

        for i = 2, #self.Weapon:GetTable().Data - 1 do
            if istable(a) then
                local b = a.ViewModel
                if b == self.Weapon:GetTable().Data[i].ViewModel then return self.Weapon:GetTable().Data[i].ClassName end
            end
        end
    end

    self.BuyCash = ui.Create('ui_button', self)
    self.BuyCash:Hide()
    self.BuyCash.Confirm = false

    self.BuyCash.DoClick = function(s)
        if not s.Confirm then
            s:SetText('Подтвердите')
            s.Confirm = true
        else
            local _, m = self.Weapon:GetSelected()
            cmd.Run('buywepskin', self.Skin.UID, isstring(GetWep(m)) and GetWep(m) or 'weapon_physgun')
            self.BuyCash:Hide()
            self.Spacer:Hide()
            self.BuyCredits:Hide()
            self.Equip:Show()
            self.Equip:SetText('Снять')
        end
    end

    self.Spacer = ui.Create('DLabel', self)
    self.Spacer:SetText('-ИЛИ-')
    self.Spacer:Hide()
    self.BuyCredits = ui.Create('ui_button', self)
    self.BuyCredits:Hide()
    self.BuyCredits.Confirm = false
    self.BuyCredits.BackgroundColor = ui.col.DarkGreen
    self.BuyCredits.OutlineColor = ui.col.OffWhite

    self.BuyCredits.DoClick = function(s)
        local price = self.Skin.UpgradeObj:GetPrice()

        if (not s.Confirm) and IGS.CanAfford(LocalPlayer(), price) then
            s:SetText('Подтвердите')
            s.Confirm = true
        else
            if not IGS.CanAfford(LocalPlayer(), price) then
                ui.BoolRequest('Недостаточно Средств', 'Вам нужно больше рублей, чтобы купить это. Хотели бы вы купить рубли?', function(ans)
                    if ans == true then
                        IGS.WIN.Deposit(self.Hat.credits - LocalPlayer():IGSFunds())
                    end
                end)
            else
                cmd.Run('donateskin', self.Skin.UID, isstring(GetWep(m)) and GetWep(m) or 'weapon_physgun')
                self.BuyCash:Hide()
                self.Spacer:Hide()
                self.BuyCredits:Hide()
                self.Equip:Show()
                self.Equip:SetText('Снять')
            end
        end
    end

    self.Equip = ui.Create('ui_button', self)
    self.Equip:Hide()

    self.Equip.DoClick = function()
        if self.Equip:GetText() == 'Снять' then
            cmd.Run('removewepskin', self.Skin.UID, isstring(cat) and 'weapon_physgun' or cat.ClassName)
            self.Equip:SetText('Надеть')
        else
            cmd.Run('setwepskin', self.Skin.UID, isstring(cat) and 'weapon_physgun' or cat.ClassName)
            self.Equip:SetText('Снять')
        end
    end
end

function PANEL:Reset()
    self.Skin = nil
    self.Preview:SetApparel(LocalPlayer():GetSkin())
    self.BuyCash:Hide()
    self.BuyCredits:Hide()
    self.Equip:Hide()
end

function PANEL:SelectSkin(skinTbl)
    self.Skin = skinTbl
    self.Texture = skinTbl.Texture
    self.Name:SetText(skinTbl.Name)
    self.Preview:Show()
    local hasSkin = LocalPlayer():HasWeaponSkin(skinTbl.UID)
    local ActiveSkin = LocalPlayer():GetActiveWeaponSkin()

    if hasSkin then
        self.Equip:Show()
        local iu
        if isstring(cat) then 
            iu = (ActiveSkin and (ActiveSkin['weapon_physgun'] == skinTbl.UID)) and 'Снять' or 'Надеть'
            
        else 
            iu = (ActiveSkin and (ActiveSkin[table.KeyFromValue(ActiveSkin,skinTbl.UID)] == skinTbl.UID and ActiveSkin[cat.ClassName]==skinTbl.UID )) and 'Снять' or 'Надеть'
        end
        self.Equip:SetText(iu)
        self.BuyCash:Hide()
        self.Spacer:Hide()
        self.BuyCredits:Hide()
    else
        if not LocalPlayer():CanAfford(skinTbl.Price) then
            self.BuyCash:SetDisabled(true)
        else
            self.BuyCash:SetDisabled(false)
        end

        self.BuyCash:SetText(rp.FormatMoney(skinTbl.Price))
        self.BuyCash:Show()
        self.Spacer:Show()
        self.BuyCredits:SetText(string.Comma(skinTbl.Credits) .. ' Рублей')
        self.BuyCredits:Show()
        self.Equip:Hide()
    end
end

function PANEL:AddCatagory(name, check)
    self.List:AddSpacer(name)
    local size
    local i = 0
    local cont

    for k, v in ipairs(self.Skins) do
        if not check(v) then continue end

        if (i == 4) or (not cont) then
            i = 0
            cont = ui.Create('ui_panel')
            self.List:AddItem(cont)
            size = cont:GetWide() / 4
            cont:SetTall(size)
        end

        ui.Create('ui_button', function(s)
            s:SetSize(size, size)
            s:SetPos(size * i, 0)
            s:SetText('')
            s:SetTooltip(v.Name .. '\n' .. rp.FormatMoney(v.Price) .. '\n -ИЛИ-\n' .. string.Comma(v.Credits) .. ' Rub')

            s.Paint = function(s, w, h)
                draw.RoundedBox(5, 0, 0, w, h, ui.col.Background)
                draw.RoundedBox(5, 0, 0, w, h, ui.col.Hover)
                surface.SetDrawColor(255, 255, 255)

                if v.PreviewNoDraw then
                    surface.SetTexture(surface.GetTextureID(v.Texture))
                elseif v.IconTexture then
                    surface.SetTexture(surface.GetTextureID(v.IconTexture))
                else
                    surface.SetMaterial(v.Material)
                end

                if self.Selected == s then
                    surface.DrawTexturedRect(10, 10, w - 20, h - 20)
                else
                    surface.DrawTexturedRect(0, 0, w, h)
                end
            end

            s.DoClick = function()
                self.Selected = s
                self:SelectSkin(v)
            end

            if LocalPlayer():GetActiveWeaponSkin() and (LocalPlayer():GetActiveWeaponSkin() == v.UID) then
                self:SelectSkin(v)
                self.Selected = s
            end
        end, cont)

        i = i + 1
    end
end

function PANEL:AddSkins()
    self.Skins = table.Copy(rp.skins.SortedList)
    table.SortByMember(self.Skins, 'Price', true)

    self:AddCatagory('Приобретено', function(data)
        return LocalPlayer():HasWeaponSkin(data.UID)
    end)

    self:AddCatagory('Стандартные Скины', function(data)
        return (data.Animated ~= true) and (not LocalPlayer():HasWeaponSkin(data.UID))
    end)

    self:AddCatagory('Анимированные Скины', function(data)
        return (data.Animated == true) and (not LocalPlayer():HasWeaponSkin(data.UID))
    end)
end

function PANEL:PerformLayout(w, h)
    self.List:SetPos(5, 5)
    self.List:SetSize(w * 0.5 - 7.5, h - 10)
    self.Name:SetPos(self.List.x + self.List:GetWide() + 5, self.List.y)
    self.Name:SetSize(self.List:GetWide() * 0.5 - 2.5, ui.SpacerHeight)
    self.Weapon:SetPos(self.Name.x + self.Name:GetWide() + 5, self.List.y)
    self.Weapon:SetSize(self.List:GetWide() * 0.5 - 2.5, ui.SpacerHeight)
    self.Preview:SetPos(self.Name.x, self.Name.y + ui.SpacerHeight + 5)
    self.Preview:SetSize(self.List:GetWide(), self.List:GetWide())
    local leftW = w * 0.5 - 7.5
    local leftX = self.List.x + self.List:GetWide() + 5
    self.BuyCash:SetPos(leftX, h - 80)
    self.BuyCash:SetSize(leftW, ui.ButtonHeight)
    self.Spacer:SizeToContents()
    self.Spacer:SetPos(leftX + (leftW * 0.5) - (self.Spacer:GetWide() * 0.5), h - 50)
    self.BuyCredits:SetPos(leftX, h - ui.ButtonHeight - 5)
    self.BuyCredits:SetSize(leftW, ui.ButtonHeight)
    self.Equip:SetPos(leftX, h - ui.ButtonHeight - 5)
    self.Equip:SetSize(leftW, ui.ButtonHeight)

    if not self.SkinsAdded then
        self.SkinsAdded = true
        self:AddSkins()
    end
end

function PANEL:ApplySchemeSettings()
    self.Spacer:SetFont('ui.15')
end

function PANEL:AddControls(f4)
    if IsValid(self.BuyMoreCredits) then
        self.BuyMoreCredits:Show()
    elseif IsValid(f4) then
        self.BuyMoreCredits = ui.Create('ui_button', f4)
        self.BuyMoreCredits:SetText('Пополнить') -- .. rp.cfg.CreditSale
        self.BuyMoreCredits.BackgroundColor = ui.col.DarkGreen
        self.BuyMoreCredits:SizeToContents()
        self.BuyMoreCredits:SetSize(self.BuyMoreCredits:GetWide() + 10, f4.btnClose:GetTall())
        self.BuyMoreCredits:SetPos(f4.btnClose.x - self.BuyMoreCredits:GetWide() + 1, 0)

        self.BuyMoreCredits.DoClick = function(s)
            IGS.WIN.Deposit()
        end
    end

    if IsValid(self.CreditsBalance) then
        self.CreditsBalance:Show()
    elseif IsValid(f4) then
        self.CreditsBalance = ui.Create('ui_button', f4)
        self.CreditsBalance:SetDisabled(true)
        self.CreditsBalance.TextColor = rp.col.Yellow
        self.CreditsBalance:SetText(string.Comma(LocalPlayer():IGSFunds()) .. ' Руб')
        self.CreditsBalance:SizeToContents()
        self.CreditsBalance:SetSize(self.CreditsBalance:GetWide() + 10, f4.btnClose:GetTall())
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

vgui.Register('rp_skinspanel', PANEL, 'Panel')