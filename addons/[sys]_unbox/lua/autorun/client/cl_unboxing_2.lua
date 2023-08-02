include("unbox_config_2.lua")
local errorMat = Material("error")
local WebImageCache = {}

if not file.IsDir('unbox', 'DATA') then
    file.CreateDir('unbox')
end

local function DownloadMaterial(url, path, callback)
    if WebImageCache[url] then return callback(WebImageCache[url]) end
    local data_path = "data/unbox/" .. path

    if file.Exists('unbox/' .. path, "DATA") then
        WebImageCache[url] = Material(data_path, "smooth", "noclamp")
        callback(WebImageCache[url])
    else
        http.Fetch(url, function(img)
            if img == nil or string.find(img, "<!DOCTYPE HTML>", 1, true) then return callback(errorMat) end
            file.Write('unbox/' .. path, img)
            WebImageCache[url] = Material(data_path, "smooth", "noclamp")
            callback(WebImageCache[url])
        end, function()
            callback(errorMat)
        end)
    end
end

local ubFrame = nil
local ubSpinPanel = nil
local ubCratePanel = nil
local ubShopPanel
local ubPage = "Crate"
local ubIsChangePage = false
local ubST = 0
local ubSP = 0
local isOpen = false
local buttonsLocked = false
local p = FindMetaTable("Panel")
local spinBackground = Material("bu2/spin_bg.png", "smooth noclamp")
local spinGlass = Material("bu2/spin_glass.png", "smooth noclamp")
local crateMat = Material("bu2/case.png", "smooth noclamp")
local itemShadowMat = Material("bu2/item_shadow.png", "smooth noclamp")
local itemBannerMat = Material("bu2/item_banner.png", "smooth noclamp")
local keyMat = Material("bu2/key.png", "smooth noclamp")
local moneyIcon = Material("bu2/money.png", "smooth noclamp")

net.Receive("ub_annouceunbox", function()
    local player = net.ReadEntity()
    local playerName = player:Name()
    local playerColor = team.GetColor(player:Team())
    local itemID = net.ReadString()
    local itemName = BUC2.ITEMS[itemID].name1
    local itemColor = BUC2.ITEMS[itemID].color
    --Print the message
    chat.AddText(ui.col.Red, '[Кейсы] ', playerColor, playerName, Color(255, 255, 255, 255), " Открыл кейс и получил -> ", itemColor, itemName .. "!", ui.col.SUP:Copy(), "  /case")
end)

function initUnboxFrame()
    ubPage = "Crate"
    ubST = 0
    ubSP = 0
    ubIsChangePage = false
    isOpen = true
    ubFrame = vgui.Create("ui_frame")
    ubFrame:SetSize(800, 600)
    ubFrame:Center()
    ubFrame:SetDraggable(false)
    ubFrame:SetVisible(true)
    ubFrame:U_PaintFrame()
    ubFrame:ShowCloseButton(false)
    ubFrame:MakePopup()
    ubFrame:SetTitle("")
    local closeBut = vgui.Create("ui_button", ubFrame)
    closeBut:SetSize(32, 32)
    closeBut:SetPos(800 - 42, 10)
    closeBut:SetText("")

    closeBut.DoClick = function()
        if buttonsLocked == false then
            isOpen = false
            ubFrame:Close()
        end
    end

    closeBut.Paint = function(s, w, h)
        draw.RoundedBox(5, 0, 0, w, h, Color(214, 27, 31))
        draw.SimpleText("×", "ui.40", w / 2, h / 2, Color(255, 255, 255, 255), 1, 1)
    end

    local last
    local igs_money = vgui.Create("EditablePanel", ubFrame)
    igs_money:SetSize(30, 30)
    igs_money:SetPos(25, 10)
    igs_money:SetText""

    igs_money.CalculateSize = function(self)
        surface.SetFont("ui.25")
        local w, h = surface.GetTextSize(self.Text)
        self:SetWide(w + 4 + 32 + 4 + 8)
    end

    igs_money.Paint = function(self, w, h)
        local igs = LocalPlayer():IGSFunds()

        if last ~= igs then
            last = igs
            self.Text = igs .. " ₽"
            self:CalculateSize()
        end

        draw.RoundedBox(5, 0, 0, w, h, Color(92, 137, 52))
        draw.SimpleText(self.Text, "ui.25", 32 + 4 + 4, h / 2 - 2, Color(255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
    end

    local plus = vgui.Create("ui_button", ubFrame)
    plus:SetSize(30, 30)
    plus:SetPos(5, 10)
    plus:SetText""

    plus.Paint = function(self, w, h)
        draw.RoundedBox(5, 0, 0, w, h, Color(145, 235, 65))
        draw.SimpleText("+", "DermaLarge", w / 2, h / 2, Color(255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
    end

    plus.DoClick = function(self)
        if BUC2.buttonsLocked then return end
        IGS.WIN.Deposit(100)
    end

    local shopBut = vgui.Create("ui_button", ubFrame)
    shopBut:SetSize(140, 32)
    shopBut:SetPos(450, 10)
    shopBut:SetText("")

    shopBut.DoClick = function()
        if buttonsLocked == false then
            ub_Goto("Shop")
        end
    end

    shopBut.Paint = function(s, w, h)
        if buttonsLocked then
            draw.RoundedBox(5, 0, 0, w, h, Color(70, 70, 70))
        else
            draw.RoundedBox(5, 0, 0, w, h, Color(57, 171, 187))
        end

        draw.SimpleText("Кейсы", "ui.20", w / 2, h / 2, Color(255, 255, 255, 255), 1, 1)
    end

    local inventoryBut = vgui.Create("ui_button", ubFrame)
    inventoryBut:SetSize(140, 32)
    inventoryBut:SetPos(600, 10)
    inventoryBut:SetText("")

    inventoryBut.DoClick = function()
        if buttonsLocked == false then
            ub_Goto("Crate")
        end
    end

    inventoryBut.Paint = function(s, w, h)
        if buttonsLocked then
            draw.RoundedBox(5, 0, 0, w, h, Color(70, 70, 70))
        else
            draw.RoundedBox(5, 0, 0, w, h, Color(189, 204, 95))
        end

        draw.SimpleText("Инвентарь", "ui.20", w / 2, h / 2, Color(255, 255, 255, 255), 1, 1)
    end

    ubCratePanel = vgui.Create("DScrollPanel", ubFrame)
    ubCratePanel:SetPos(ubSP, 150)
    ubCratePanel:SetSize(800, 600 - 35)

    ubCratePanel.Paint = function(s, w, h)
        if LocalPlayer().ubinv == nil or table.Count(LocalPlayer().ubinv) == 0 then
            draw.SimpleText("ПУСТО:(", "ui.85", 800 / 2, (600 / 2) - 50, Color(255, 255, 255, 255), 1, 1)
        end
    end

    ubSpinPanel = vgui.Create("ui_panel", ubFrame)
    ubSpinPanel:SetPos(ubSP + 800, 35)
    ubSpinPanel:SetSize(800, 600 - 35)

    ubSpinPanel.Paint = function(s, w, h)
        surface.SetDrawColor(255, 255, 255, 255)
        surface.SetMaterial(spinBackground)
        surface.DrawTexturedRect(0, 0, w, h)
    end

    ubShopPanel = vgui.Create("DScrollPanel", ubFrame)
    ubShopPanel:SetPos(ubSP - 800, 55)
    ubShopPanel:SetSize(800, 600 - 55)
    ub_CreateInventory()
    ub_createShop()
end

local diagBack = Material("bu2/dialog_background.png", "noclamp smooth")

function ub_refreshInventory()
    if isOpen then
        ubCratePanel:Remove()
        ubCratePanel = vgui.Create("DScrollPanel", ubFrame)
        ubCratePanel:SetPos(ubSP, 35)
        ubCratePanel:SetSize(800, 600 - 35)

        ubCratePanel.Paint = function(s, w, h)
            if table.Count(LocalPlayer().ubinv) == 0 then
                draw.SimpleText("ПУСТО :(", "ui.85", 800 / 2, (600 / 2) - 50, Color(255, 255, 255, 255), 1, 1)
            end
        end

        ub_CreateInventory()
    end
end

function createTansactionWindow(itemID, Amount)
    local buyWindow = vgui.Create("ui_frame")
    buyWindow:SetSize(400, 200)
    buyWindow:Center()
    buyWindow:SetTitle("")
    buyWindow:ShowCloseButton(false)
    buyWindow.itemID = itemID
    buyWindow.Amount = Amount
    buyWindow:SetText("")

    buyWindow.Paint = function(s, w, h)
        Derma_DrawBackgroundBlur(s, CurTime())
        surface.SetDrawColor(255, 255, 255, 255)
        surface.SetMaterial(diagBack)
        surface.DrawTexturedRect(0, 0, w, h)
        draw.SimpleText("Чек", "ui.40", 200, 60, Color(255, 255, 255), 1, 1)
        draw.SimpleText("Кейс : " .. BUC2.ITEMS[s.itemID].name1, "ui.24", 200, 90, Color(255, 255, 255), 1, 1)
        draw.SimpleText("Количество : " .. s.Amount, "ui.24", 200, 115, Color(255, 255, 255), 1, 1)
        draw.SimpleText("Цена: " .. (BUC2.ITEMS[s.itemID].price * s.Amount) .. "₽", "ui.24", 200, 115 + 25, Color(255, 255, 255), 1, 1)
    end

    buyWindow:SetVisible(true)
    buyWindow:MakePopup()
    local cb = vgui.Create("ui_button", buyWindow)
    cb:SetPos(23, 200 - 35)
    cb:SetSize(200 - 60, 23)
    cb:SetText("")
    cb.p = buyWindow

    cb.Paint = function(s, w, h)
        draw.RoundedBox(5, 0, 0, w, h, Color(214, 27, 31))
        draw.SimpleText("ОТМЕНА", "ui.12", math.floor(w / 2), math.floor(h / 2), Color(255, 255, 255, 255), 1, 1)
    end

    cb.DoClick = function(s)
        s.p:Close()
    end

    local bb = vgui.Create("ui_button", buyWindow)
    bb:SetPos(400 - 23 - (200 - 60), 200 - 35)
    bb:SetSize(200 - 60, 23)
    bb:SetText("")
    bb.itemID = itemID
    bb.Amount = Amount
    bb.parent = buyWindow
    bb.price = BUC2.ITEMS[itemID].price * Amount
    bb.canBuy = false

    bb.Paint = function(s, w, h)
        local c = Color(30, 150, 30)

        if not BUC2.BuyItemsWithPoints and not BUC2.BuyItemsWithPoints2 then
            if IGS.CanAfford(LocalPlayer(), s.price) == false then
                s.canBuy = false
                c = Color(90, 90, 90)
            else
                s.canBuy = true
            end
        else
            if BUC2.BuyItemsWithPoints then
                if LocalPlayer():PS_HasPoints(s.price) == false then
                    s.canBuy = false
                    c = Color(90, 90, 90)
                else
                    s.canBuy = true
                end
            else
                if BUC2.BuyItemsWithPoints2 then
                    if LocalPlayer().PS2_Wallet.points < s.price then
                        s.canBuy = false
                        c = Color(90, 90, 90)
                    else
                        s.canBuy = true
                    end
                end
            end
        end

        draw.RoundedBox(5, 0, 0, w, h, c)
        draw.SimpleText("КУПИТЬ", "ui.12", math.floor(w / 2), math.floor(h / 2), Color(255, 255, 255, 255), 1, 1)
    end

    bb.DoClick = function(s)
        if s.canBuy then
            net.Start("ub_purchase")
            net.WriteString(s.itemID)
            net.WriteInt(s.Amount, 8)
            net.SendToServer()
            s.parent:Close()
        end
    end
end

local matsfstars = Material("data/sfstarslogos.jpg", "smooth")

http.Fetch("https://i.imgur.com/Noiu7Pp.png", function(data)
    file.Write("sfstarslogos.jpg", data)
    matsfstars = Material("data/sfstarslogos.jpg")
end)

local matrande = Material("data/randelogos.jpg", "smooth")

http.Fetch("https://i.imgur.com/3zOYJLQ.png", function(data)
    file.Write("randelogos.jpg", data)
    matrande = Material("data/randelogos.jpg")
end)

function ub_createShop()
    local xPos = 0
    local yPos = 0

    for k, v in pairs(BUC2.ITEMS) do
        if v.canBuy then
            local temp = vgui.Create("ui_panel", ubShopPanel)
            temp:SetSize(180, 250)
            temp:SetPos(xPos + 10, yPos)
            temp.itemTable = v
            temp.itemType = v.itemType
            temp.outlinec = Color(0, 0, 0)

            temp.Paint = function(s, w, h)
                surface.SetDrawColor(255, 255, 255, 255)
                surface.SetMaterial(itemShadowMat)
                surface.DrawTexturedRect(0, 40, 180, 210)
                local col = s.itemTable.color
                draw.RoundedBox(0, 1, 20, 180, 40, col)

                if s.itemType == "Crate" then
                    if s.itemTable.name1 == "Кейс SF-Stars" and matsfstars then
                        surface.SetDrawColor(Color(255, 255, 255))
                        surface.SetMaterial(matsfstars)
                        surface.DrawTexturedRect(20, 60, 140, 140)
                    elseif s.itemTable.name1 == "Кейс Rande" and matrande then
                        surface.SetDrawColor(Color(255, 255, 255))
                        surface.SetMaterial(matrande)
                        surface.DrawTexturedRect(20, 60, 140, 140)
                    elseif s.itemTable.name1 == "Кейс 'Incheyz'" and matinch then
                        surface.SetDrawColor(Color(255, 255, 255))
                        surface.SetMaterial(matinch)
                        surface.DrawTexturedRect(20, 60, 140, 140)
                    else
                        surface.SetDrawColor(s.itemTable.color)
                        surface.SetMaterial(crateMat)
                        surface.DrawTexturedRect(0, 60, 180, 180)
                    end
                elseif s.itemType == "Key" then
                    surface.SetDrawColor(s.itemTable.color)
                    surface.SetMaterial(keyMat)
                    surface.DrawTexturedRect(0, 0, 180, 180)
                end

                surface.SetDrawColor(col)
                surface.SetMaterial(itemBannerMat)
                surface.DrawTexturedRect(0, 180, 180, -40)
                --Draw text
                draw.SimpleText(s.itemTable.name1, "ui.19", 5, 30, Color(255, 255, 255))
                draw.SimpleText(s.itemTable.name2, "ui.12", 5, 45, Color(255, 255, 255))

                --surface.SetDrawColor(Color(0,0,0))
                --surface.DrawLine(0,180 , 180, 180)
                for i = 0, 1 do
                    surface.DrawOutlinedRect(i, i, w - (i * 2), h - (i * 2))
                end
            end

            local amountPanel = vgui.Create("ui_panel", temp)
            amountPanel:SetPos(0, 0)
            amountPanel:SetSize(180, 30)

            amountPanel.Paint = function(s, w, h)
                draw.RoundedBox(0, 0, 0, w, h, Color(55, 55, 55))
            end

            local plusAmount = vgui.Create("ui_button", amountPanel)
            plusAmount:SetPos(5, 5)
            plusAmount:SetSize(20, 20)
            plusAmount:SetText("")

            plusAmount.Paint = function(s, w, h)
                draw.RoundedBox(5, 0, 0, w, h, Color(0, 215, 54))
                draw.SimpleText("-", "ui.12", w / 2, h / 2, Color(255, 255, 255, 255), 1, 1)
            end

            plusAmount.DoClick = function(s)
                s.dis.Amount = s.dis.Amount - 1

                if s.dis.Amount < 1 then
                    s.dis.Amount = 1
                end
            end

            local minusAmount = vgui.Create("ui_button", amountPanel)
            minusAmount:SetPos(180 / 2 - 5 - 20, 5)
            minusAmount:SetSize(20, 20)
            minusAmount:SetText("")

            minusAmount.Paint = function(s, w, h)
                draw.RoundedBox(5, 0, 0, w, h, Color(0, 215, 54))
                draw.SimpleText("+", "ui.12", w / 2, h / 2, Color(255, 255, 255, 255), 1, 1)
            end

            minusAmount.DoClick = function(s)
                s.dis.Amount = s.dis.Amount + 1

                if s.dis.Amount > 16 then
                    s.dis.Amount = 16
                end
            end

            local amountDisplay = vgui.Create("ui_panel", amountPanel)
            amountDisplay:SetPos(5 + 20 + 5, 5)
            amountDisplay:SetSize(180 / 2 - 20 - 20 - 5 - 5 - 5 - 5, 20)
            amountDisplay.Amount = 1

            amountDisplay.Paint = function(s, w, h)
                draw.RoundedBox(5, 0, 0, w, h, Color(10, 10, 10))
                draw.SimpleText(s.Amount, "ui.12", w / 2, h / 2, Color(255, 255, 255, 255), 1, 1)
            end

            plusAmount.dis = amountDisplay
            minusAmount.dis = amountDisplay
            local buyButton = vgui.Create("ui_button", amountPanel)
            buyButton:SetPos(180 / 2 + 5, 5)
            buyButton:SetSize(180 / 2 - 5 - 5, 20)
            buyButton.item = k
            buyButton.dis = amountDisplay

            buyButton.Paint = function(s, w, h)
                draw.RoundedBox(5, 0, 0, w, h, Color(0, 215, 54))
                draw.SimpleText((BUC2.ITEMS[s.item].price * s.dis.Amount) .. " ₽", "ui.19", w / 2 - 30, h / 2, Color(255, 255, 255, 255), 0, 1)
            end

            --draw.SimpleText((BUC2.ITEMS[s.item].price * s.dis.Amount) * 3 .."₽","ui.12", 10 , h / 2, Color(255,255,255,255) , 0 , 1)
            --draw.SimpleText((BUC2.ITEMS[s.item].price * s.dis.Amount).."₽","ui.19", 35, h / 2, Color(255,0,0,255) , 0 , 1)
            --surface.SetDrawColor( 255, 255, 255, 255 )
            --surface.DrawLine( 5, 5, w / 2 - 5, h - 5 )
            buyButton:SetText("")

            buyButton.DoClick = function(s)
                createTansactionWindow(s.item, s.dis.Amount)
            end

            local chkButton = vgui.Create("ui_button", temp)
            chkButton:SetPos(180 / 2 + 5, 220)
            chkButton:SetSize(180 / 2 - 5 - 5, 20)
            chkButton.item = k
            chkButton.dis = amountDisplay

            chkButton.Paint = function(s, w, h)
                draw.RoundedBox(5, 0, 0, w, h, Color(24, 151, 24))
                draw.SimpleText("Посмотреть", "ui.12", w / 2, h / 2, Color(255, 255, 255, 255), 1, 1)
            end

            chkButton:SetText("")

            chkButton.DoClick = function(s)
                --createTansactionWindow(s.item , s.dis.Amount)
                local t = BUC2.ITEMS[s.item].itemType

                if t == "Crate" then
                    initSpinMenu(s.item, true)
                    ub_Goto("Spin")
                end
            end

            xPos = xPos + 198

            if xPos > 700 then
                xPos = 0
                yPos = yPos + 220 + 30 + 15
            end
        end
    end
end

function createModelModule(k, v, x, y)
    local temp = vgui.Create("ui_panel", ubCratePanel)
    temp:SetSize(180, 220)
    temp:SetPos(x + 10, y + 10)
    temp.itemTable = v
    temp.itemType = v.itemType
    temp.outlinec = Color(0, 0, 0)

    temp.Paint = function(s, w, h)
        surface.SetDrawColor(255, 255, 255, 255)
        surface.SetMaterial(itemShadowMat)
        surface.DrawTexturedRect(0, 0, 180, 180)
        local col = s.itemTable.color
        surface.SetDrawColor(col)
        surface.SetMaterial(itemBannerMat)
        surface.DrawTexturedRect(0, 180, 180, 40)
        --Draw text
        draw.SimpleText(s.itemTable.name1, "ui.19", 5, 180, Color(255, 255, 255))
        draw.SimpleText(s.itemTable.name2, "ui.12", 5, 200, Color(255, 255, 255))
    end

    local mod = vgui.Create("DModelPanel", temp)
    mod:SetPos(0, 0)
    mod:SetSize(180, 180)
    mod:SetModel(v.model)
    mod:SetAnimated(false)
    mod.ang = mod.Entity:GetAngles()

    function mod:LayoutEntity(Entity)
        if self.bAnimated then
            self:RunAnimation()
        end
    end

    local min, max = mod.Entity:GetRenderBounds()
    mod:SetCamPos(min:Distance(max) * Vector(0.5, 0.5, 0.2))
    mod:SetLookAt((max + min) / 2)
    local over = vgui.Create("ui_button", temp)
    over:SetText("")
    over:SetPos(0, 0)
    over:SetSize(180, 220)
    over.col = Color(0, 0, 0, 255)
    over.alpha = 0
    over.itemID = k

    over.Paint = function(s, w, h)
        --draw.SimpleText("OPEN","ui.25",180/2,180/2,Color(255,255,255 , s.alpha) , 1 , 1)
        if BUC2.ITEMS[s.itemID].itemType == "Weapon" then
            if BUC2.ITEMS[s.itemID].permanent then
                draw.RoundedBox(5, 0, 0, 180, 20, Color(255, 90, 90, 255))
                draw.SimpleText("PERMANENT", "ui.19", 180 / 2, 10, Color(255, 255, 255), 1, 1)
            end
        end

        draw.RoundedBox(5, 0, 0, w, h, Color(40, 40, 40, s.alpha))
        surface.SetDrawColor(s.col)
        surface.DrawLine(0, 180, 180, 180)

        for i = 0, 1 do
            surface.DrawOutlinedRect(i, i, w - (i * 2), h - (i * 2))
        end
    end

    over.Think = function(s)
        if s:IsHovered() then
            s.col = Color(30, 150, 30)
            s.alpha = Lerp(10 * FrameTime(), s.alpha, 190)
        else
            s.col = Color(0, 0, 0)
            s.alpha = Lerp(10 * FrameTime(), s.alpha, 0)
        end
    end

    return over
end

function createPngModule(k, v, x, y)
    local temp = vgui.Create("ui_panel", ubCratePanel)
    temp:SetSize(180, 220)
    temp:SetPos(x + 10, y + 10)
    temp.itemTable = v
    temp.itemType = v.itemType
    temp.outlinec = Color(0, 0, 0)

    temp.Paint = function(s, w, h)
        surface.SetDrawColor(255, 255, 255, 255)
        surface.SetMaterial(itemShadowMat)
        surface.DrawTexturedRect(0, 0, 180, 180)

        if s.itemType == "Crate" then
            if s.itemTable.name1 == "Кейс SF-Stars" and matsfstars then
                surface.SetDrawColor(Color(255, 255, 255))
                surface.SetMaterial(matsfstars)
                surface.DrawTexturedRect(20, 20, 140, 140)
            elseif s.itemTable.name1 == "Кейс Rande" and matrande then
                surface.SetDrawColor(Color(255, 255, 255))
                surface.SetMaterial(matrande)
                surface.DrawTexturedRect(20, 20, 140, 140)
            else
                surface.SetDrawColor(s.itemTable.color)
                surface.SetMaterial(crateMat)
                surface.DrawTexturedRect(0, 0, 180, 180)
            end
        elseif s.itemType == "Key" then
            surface.SetDrawColor(s.itemTable.color)
            surface.SetMaterial(keyMat)
            surface.DrawTexturedRect(0, 0, 180, 180)
        end

        local col = s.itemTable.color
        surface.SetDrawColor(col)
        surface.SetMaterial(itemBannerMat)
        surface.DrawTexturedRect(0, 180, 180, 40)
        --Draw text
        draw.SimpleText(s.itemTable.name1, "ui.19", 5, 180, Color(255, 255, 255))
        draw.SimpleText(s.itemTable.name2, "ui.12", 5, 200, Color(255, 255, 255))
    end

    local over = vgui.Create("ui_button", temp)
    over:SetText("")
    over:SetPos(0, 0)
    over:SetSize(180, 220)
    over.col = Color(0, 0, 0, 255)
    over.alpha = 0
    over.itemID = k

    over.Paint = function(s, w, h)
        draw.RoundedBox(5, 0, 0, w, h, Color(40, 40, 40, s.alpha))
        --draw.SimpleText("OPEN","ui.25",180/2,180/2,Color(255,255,255 , s.alpha) , 1 , 1)
        surface.SetDrawColor(s.col)
        surface.DrawLine(0, 180, 180, 180)

        for i = 0, 1 do
            surface.DrawOutlinedRect(i, i, w - (i * 2), h - (i * 2))
        end
    end

    over.Think = function(s)
        if s:IsHovered() then
            s.col = Color(30, 150, 30)
            s.alpha = Lerp(10 * FrameTime(), s.alpha, 190)
        else
            s.col = Color(0, 0, 0)
            s.alpha = Lerp(10 * FrameTime(), s.alpha, 0)
        end
    end

    return over
end

local containPanel = nil

function generateTape(itemID)
    local totalChance = 0

    for k, v in pairs(BUC2.ITEMS[itemID].items) do
        v = BUC2.ITEMS[v]
        totalChance = totalChance + v.chance
    end

    local itemList = {}

    for i = 0, 99 do
        local num = math.random(1, totalChance)
        local prevCheck = 0
        local curCheck = 0
        local item = nil

        for k, v in pairs(BUC2.ITEMS[itemID].items) do
            v = BUC2.ITEMS[v]

            if v.itemType ~= "Key" and v.itemType ~= "Crate" then
                if num >= prevCheck and num <= prevCheck + v.chance then
                    item = v.name1
                end

                prevCheck = prevCheck + v.chance
            end
        end

        itemList[i] = item
    end

    return itemList
end

local tape = {}
local tapePans = {}
local tapePos = 10
local tapeIsMoving = false

net.Receive("StartClientSpinAnimation", function()
    tapePos = 10
    LocalPlayer():EmitSound("buttons/lever1.wav")
    local id = net.ReadString()
    tapePans[87].item = BUC2.ITEMS[id]
    tapePans[87].id = c

    if BUC2.ITEMS[id].itemType == "Weapon" or BUC2.ITEMS[id].itemType == "PSItem" or BUC2.ITEMS[id].itemType == "PSItem2" or BUC2.ITEMS[id].itemType == "Entity" then
        tapePans[87].mod:SetModel(BUC2.ITEMS[id].model)
        tapePans[87].mod:SetAnimated(false)
        tapePans[87].mod.ang = tapePans[87].mod.Entity:GetAngles()

        tapePans[87].mod.LayoutEntity = function(Entity)
            if Entity.bAnimated then
                Entity:RunAnimation()
            end
        end

        local min, max = tapePans[87].mod.Entity:GetRenderBounds()
        tapePans[87].mod:SetCamPos(min:Distance(max) * Vector(0.55, 0.55, 0.2))
        tapePans[87].mod:SetLookAt((max + min) / 2)
    end

    if BUC2.ITEMS[id].itemType == "IGS" or BUC2.ITEMS[id].itemType == "Points" or BUC2.ITEMS[id].itemType == "Points2" or BUC2.ITEMS[id].itemType == "Trail" then
        if tapePans[87].mod ~= nil then
            tapePans[87].mod:Remove()
        end
    end

    if tapeIsMoving == false then
        tapePos = 10
        tapeIsMoving = true
    end
end)

local prevItemValue = 0
local tim = 0

hook.Add("Think", "TapeManager", function()
    tim = tim + FrameTime()

    if tapeIsMoving then
        tapePos = Lerp(0.7 * FrameTime(), tapePos, (110 * 85) * -1)
        local c = 0

        for k, v in pairs(tapePans) do
            v:SetPos(tapePos + (110 * c), 6)
            c = c + 1
        end

        if math.floor((tapePos + 50) / (100 + 10)) ~= prevItemValue then
            prevItemValue = math.floor((tapePos + 50) / (100 + 10))

            if tim > 0.1 then
                tim = 0
                LocalPlayer():EmitSound("ub_tick.wav")
            end
        end

        if math.Round(tapePos) <= ((110 * 85) * -1) + 3 then
            net.Start("SpinEnded")
            net.SendToServer()
            LocalPlayer():EmitSound("buttons/lever6.wav")

            timer.Simple(2.5, function()
                ub_Goto("Crate")
                buttonsLocked = false
            end)

            tapeIsMoving = false
        end
    end
end)

function initSpinMenu(itemID, check)
	tape = generateTape(itemID)

	if containPanel ~= nil then
		ubSpinPanel:Remove()
		containPanel:Remove()
	end
	
	ubSpinPanel = vgui.Create("ui_panel" , ubFrame)
	ubSpinPanel:SetPos(ubSP + 800,40)
	ubSpinPanel:SetSize(800,600 - 40)
	ubSpinPanel.Paint = function(s , w , h) end   

	ubSpinItemPanel = vgui.Create("ui_panel" , ubSpinPanel)
	ubSpinItemPanel:SetPos(136,37)
	ubSpinItemPanel:SetSize(540 - 4,143)
	ubSpinItemPanel.Paint = function(s , w , h) end

	containPanel = vgui.Create("DScrollPanel",ubSpinPanel)
	containPanel:SetSize(800, 280)
	containPanel:SetPos(5,285)
	containPanel.Paint = function(s , w , h) end

	local spinBut = vgui.Create("ui_button" , ubSpinPanel)
	spinBut:SetSize(130 , 30)
	spinBut:SetPos(400 - (130/2) , 195)
	spinBut:SetText("")
	spinBut.requestSent = false
	spinBut.crateID = itemID
	spinBut.DoClick = function(s)
		if check then
			ub_Goto("Shop")
		else
			if s.requestSent == false then
				
				s.requestSent = true
				buttonsLocked = true

				net.Start("BeginSpin")
					net.WriteString(s.crateID)
				net.SendToServer()
			end 
		end
	end
	spinBut.Paint = function(s, w, h)
		if check then
			draw.RoundedBox(5, 0, 0, w, h, Color(30, 150, 30))
			draw.SimpleText("НАЗАД", "ui.24", math.floor(w / 2), math.floor(h / 2), Color(255, 255, 255, 255), 1, 1)
		else
			if buttonsLocked then
				draw.RoundedBox(5, 0, 0, w, h, Color(70, 70, 70))
			else
				draw.RoundedBox(5, 0, 0, w, h, Color(245, 196, 0))
			end
	
			draw.SimpleText("ОТКРЫТЬ", "ui.24", math.floor(w / 2), math.floor(h / 2), Color(255, 255, 255, 255), 1, 1)
		end
	end
	
	--Generate Fake Wheel
	local c = 0
	
	for k, v in pairs(tape) do
		local t = vgui.Create("ui_panel", ubSpinItemPanel)
		t:SetPos(tapePos + (110 * c), 6)
		t:SetSize(100, 130)
		t.item = BUC2.ITEMS[v]
		t.id = c
	
		t.Paint = function(s, w, h)
			surface.SetDrawColor(255, 255, 255, 255)
			surface.SetMaterial(itemShadowMat)
			surface.DrawTexturedRect(0, 0, 100, 100)
	
			if s.item.itemType == "IGS" then
				surface.SetDrawColor(255, 255, 255, 255)
				surface.SetMaterial(moneyIcon)
				surface.DrawTexturedRect(10, 10, 80, 80)
			end
	
			local bc = s.item.color
			surface.SetDrawColor(bc)
			surface.SetMaterial(itemBannerMat)
			surface.DrawTexturedRect(0, 100, 100, 30)
			surface.SetDrawColor(0, 0, 0, 255)
			surface.DrawOutlinedRect(0, 0, 100, 130)
			surface.DrawOutlinedRect(1, 1, 98, 128)
			surface.DrawOutlinedRect(0, 100, 100, 1)
			draw.SimpleText(s.item.name1, "ui.16", 5, 105, Color(255, 255, 255, 255), 0, 0)
		end
	
		if k == 87 or BUC2.ITEMS[v].itemType == "Weapon" then
			tmod = vgui.Create("DModelPanel", t)
			tmod:SetSize(100, 100)
			tmod:SetPos(0, 0)
	
			if BUC2.ITEMS[v].itemType == "Weapon" then
				tmod:SetModel(BUC2.ITEMS[v].model)
				tmod:SetAnimated(false)
				tmod.ang = tmod.Entity:GetAngles()
	
				function tmod:LayoutEntity(Entity)
					if self.bAnimated then
						self:RunAnimation()
					end
				end
	
				local min, max = tmod.Entity:GetRenderBounds()
				tmod:SetCamPos(min:Distance(max) * Vector(0.55, 0.55, 0.2))
				tmod:SetLookAt((max + min) / 2)
			end
		end
	
		t.mod = tmod
		tapePans[c] = t
		tapePans[c].mod = tmod
		c = c + 1
	end

	--Create All the Items Modules
	if BUC2.ITEMS[itemID] ~= nil then
		if BUC2.ITEMS[itemID].items ~= nil and table.Count(BUC2.ITEMS[itemID].items) > 0 then
			local xPos = 10
			local yPos = 10
	
			for k, v in pairs(BUC2.ITEMS[itemID].items) do
				local testPan = vgui.Create("ui_panel", containPanel)
				testPan:SetPos(xPos, yPos)
				testPan:SetSize(100, 100 + 20)
				testPan.item = BUC2.ITEMS[v]
	
				testPan.Paint = function(s, w, h)
					surface.SetDrawColor(255, 255, 255, 255)
					surface.SetMaterial(itemShadowMat)
					surface.DrawTexturedRect(0, 0, 100, 100)
	
					if s.item.itemType == "IGS" then
						surface.SetDrawColor(255, 255, 255, 255)
						surface.SetMaterial(moneyIcon)
						surface.DrawTexturedRect(10, 10, 80, 80)
					end
	
					surface.SetDrawColor(s.item.color)
					surface.SetMaterial(itemBannerMat)
					surface.DrawTexturedRect(0, 100, 100, 20)
					draw.SimpleText(s.item.name1, "ui.12", 5, 108, Color(255, 255, 255, 255), 0, 1)
					surface.SetDrawColor(0, 0, 0, 255)
					surface.DrawOutlinedRect(0, 0, 100, 120)
					surface.DrawOutlinedRect(1, 1, 98, 118)
					surface.DrawOutlinedRect(0, 100, 100, 1)
				end
	
				--surface.DrawOutlinedRect(0,100,100,20)
				if k == 87 or BUC2.ITEMS[v].itemType == "Weapon" then
					local mod = vgui.Create("DModelPanel", testPan)
					mod:SetSize(100, 100)
					mod:SetPos(0, 0)
	
					if BUC2.ITEMS[v].itemType == "Weapon" then
						mod:SetModel(BUC2.ITEMS[v].model)
					end
	
					mod:SetAnimated(false)
					mod.ang = mod.Entity:GetAngles()
	
					function mod:LayoutEntity(Entity)
						if self.bAnimated then
							self:RunAnimation()
						end
					end
	
					local min, max = mod.Entity:GetRenderBounds()
					mod:SetCamPos(min:Distance(max) * Vector(0.55, 0.55, 0.2))
					mod:SetLookAt((max + min) / 2)
				end
	
				xPos = xPos + 100 + 12
	
				if xPos > 750 then
					xPos = 10
					yPos = yPos + 100 + 20 + 12
				end
			end
		end
	end

	local ubSpinItemPanelOverlay = vgui.Create("ui_panel" , ubSpinItemPanel)
	ubSpinItemPanelOverlay:SetPos(0,0) 
	ubSpinItemPanelOverlay:SetSize(540 - 4,143)
	ubSpinItemPanelOverlay.Paint = function(s , w , h)
		draw.RoundedBox(5,w/2 - 1 , 0 , 2 , h , Color(255,140,0 , 150))
		surface.SetDrawColor(255,255,255,255)
		surface.SetMaterial(spinGlass)
		surface.DrawTexturedRect(0,0,w,h)
	end
end

function ub_inventory_menu(itemID)
    local m = vgui.Create("DMenu")
    m:SetPos(gui.MouseX(), gui.MouseY())
    local t = BUC2.ITEMS[itemID].itemType

    if t == "Crate" then
        local t = m:AddOption("Открыть")
        t.id = itemID

        t.DoClick = function(s)
            initSpinMenu(s.id)
            ub_Goto("Spin")
        end
    end

    if t == "Entity" then
        local e = m:AddOption("Spawn", function(s)
            net.Start("ub_spawnEntity")
            net.WriteString(s.id)
            net.SendToServer()
            isOpen = false
            ubFrame:Close()
        end)

        e.id = itemID
    end

    if t == "Weapon" then
        m:AddOption("Equip", function(s)
            net.Start("ub_equipweapon")
            net.WriteString(itemID)
            net.SendToServer()
        end)

        m.id = itemID
    end

    m:Open()
    if player.GetCount() == 1 then return end
    local sm = m:AddSubMenu("Подарить")

    for k, v in pairs(player.GetAll()) do
        if v ~= LocalPlayer() then
            local temp = sm:AddOption(v:Name(), function(s)
                net.Start("ub_giftitem")
                net.WriteString(s.id)
                net.WriteEntity(s.ply)
                net.SendToServer()
            end)

            temp.id = itemID
            temp.ply = v
        end
    end

    sm:AddSpacer()
    m:Open()
end

function ub_CreateInventory()
    if LocalPlayer().ubinv ~= nil and table.Count(LocalPlayer().ubinv) > 0 then
        local xPos = 0
        local yPos = 0

        for k, v in pairs(LocalPlayer().ubinv) do
            if v ~= nil and BUC2.ITEMS[v] ~= nil then
                local id = v
                v = BUC2.ITEMS[v]
                local pan = nil

                if v.itemType == "Key" or v.itemType == "Crate" then
                    pan = createPngModule(k, v, xPos, yPos)
                else
                    pan = createModelModule(k, v, xPos, yPos)
                end

                pan.itemID = id

                pan.DoClick = function(s)
                    ub_inventory_menu(s.itemID)
                end

                xPos = xPos + 198

                if xPos > 700 then
                    xPos = 0
                    yPos = yPos + 230
                end
            end
        end
    end
end

local prevPos = 0

function ub_Goto(page)
    if ubIsChangePage == false and page ~= ubPage then
        ubIsChangePage = true
        ubST = 0
        ubPage = page
        prevPos = ubSP
    end
end

function ub_herm(s, e, v)
    return Lerp(v * v * (3.0 - 2.0 * v), s, e)
end

function ub_PageChange()
    if isOpen then
        ubCratePanel:SetPos(ubSP, 50)
        ubSpinPanel:SetPos(ubSP + 800, 40)
        ubShopPanel:SetPos(ubSP - 800, 55)
    end

    if ubIsChangePage then
        ubST = ubST + (FrameTime() * 1.5)

        if ubPage == "Crate" then
            ubSP = ub_herm(prevPos, 0, ubST)
        elseif ubPage == "Spin" then
            ubSP = ub_herm(prevPos, -800, ubST)
        elseif ubPage == "Shop" then
            ubSP = ub_herm(prevPos, 800, ubST)
        end

        if ubST >= 1 then
            ubIsChangePage = false
            ubST = 0
        end
    end
end

hook.Add("Think", "UpdateUBPageChange", ub_PageChange)

function p:U_PaintFrame()
    self.Paint = function(s, w, h)
        draw.RoundedBox(5, 0, 0, w, h, Color(37, 37, 37))
    end
end

net.Receive("ub_openui", function()
    if isOpen == false then
        initUnboxFrame()
    end
end)

function ub_hasItem(itemID)
    for k, v in pairs(LocalPlayer().ubinv) do
        if v == itemID then return true end
    end

    return false
end

net.Receive("ub_inventory_update", function()
    local len = net.ReadDouble()
    local e = net.ReadData(len)
    e = util.Decompress(e)
    e = util.JSONToTable(e)
    --Convert from ID'S to string ID's
    local i = {}

    for k, v in pairs(e) do
        for a = 1, v do
            table.insert(i, k)
        end
    end

    LocalPlayer().ubinv = i
    ub_refreshInventory()
end)

net.Receive("unboxadmin", function()
    local isAllowed = false

    for k, v in pairs(BUC2.RanksThatCanGiveItems) do
        if LocalPlayer():GetUserGroup() == v then
            isAllowed = true
        end
    end
end)

function ub_giveitems()
    local frame = vgui.Create("ui_frame")
    frame:SetSize(250, 160)
    frame:Center()
    frame:SetVisible(true)
    frame:SetTitle("Unboxing Admin Panel")
    frame:MakePopup()
    local item = vgui.Create("DComboBox", frame)
    item:SetPos(20, 35)
    item:SetSize(210, 20)
    item:SetValue("Select An Item")

    for k, v in pairs(BUC2.ITEMS) do
        if v.itemType ~= "IGS" and v.itemType ~= "Points" and v.itemType ~= "Points2" and v.itemType ~= "PSItem" and v.itemType ~= "PSItem2" then
            item:AddChoice(k)
        end
    end

    local target = vgui.Create("DComboBox", frame)
    target:SetPos(20, 35 + 30)
    target:SetSize(210, 20)
    target:SetValue("Select A Player")

    for k, v in pairs(player.GetAll()) do
        target:AddChoice(v:Name(), v)
    end

    local amount = vgui.Create("DTextEntry", frame)
    amount:SetPos(20, 35 + 30 + 30)
    amount:SetSize(210, 20)
    amount:SetText("Enter Amount")
    local give = vgui.Create("ui_button", frame)
    give:SetPos(20, 35 + 30 + 30 + 30)
    give:SetSize(210, 20)
    give:SetText("Give")
    give.target = target
    give.item = item
    give.amount = amount

    give.DoClick = function(s)
        if BUC2.ITEMS[s.item:GetSelected()] ~= nil then
            local name, ply = s.target:GetSelected()

            if name ~= "Select A Player" and IsValid(ply) then
                local amount = tonumber(amount:GetValue())

                if amount ~= nil and amount > 0 and amount < 1000 then
                    net.Start("ub_admingiveitems")
                    net.WriteString(s.item:GetSelected())
                    net.WriteEntity(ply)
                    net.WriteInt(amount, 8)
                    net.SendToServer()
                end
            end
        end
    end
end