local a = {}

function a:Init()
    self.ItemsLabel = ui.Create('ui_button', self)
    self.ItemsLabel:SetText('Инструкция')
    self.ItemsLabel:SetDisabled(true)
    self.ItemsLabel:Dock(TOP)

    self.ItemsLabel.Corners = {true, true, false, false}

    self.Items = ui.Create('ui_listview', self)
    self.Items:SetSpacing(2)
    self.Items:Dock(TOP)
    self.PricesLabel = ui.Create('ui_button', self)
    self.PricesLabel:SetText('Цены')
    self.PricesLabel:SetDisabled(true)
    self.PricesLabel:Dock(TOP)
    self.PricesLabel:DockMargin(0, 5, 0, 0)

    self.PricesLabel.Corners = {true, true, false, false}

    self.Prices = ui.Create('ui_listview', self)
    self.Prices:SetSpacing(2)
    self.Prices:Dock(TOP)
end

function a:AddChildren()
    local b = {}
    local c = 0
    local d
    for e, f in ipairs(rp.Drugs) do
    --    if rp.pocket.Data[f.Entity] and rp.pocket.Data[f.Entity] > 0 then
    --        b[#b + 1] = f
    --    end
        
        if c == 0 then
            d = ui.Create('ui_panel', function(self)
                self.Paint = function() end    
                self:SetTall(100)
            end)
            self.Prices:AddItem(d)
        end
        
        local g = ui.Create('rp_modelbutton', d)
            g:SetModel(f.Model)
            g:SetTopText(f.Name)
            g:SetBottomText(rp.FormatMoney(f.BuyPrice))
            g:SetWide(143)
            g:Dock(LEFT)
            g:DockMargin(0,0,2,0)
            c = c == 3 and 0 or c + 1
        end
        
        if #b == 0 then
            self.Items.PaintOver = function(h, i, j)
                draw.RoundedBoxEx(5, 0, 0, i, j, ui.col.Background, false, false, true, true)
                draw.SimpleText('Просто поднеси гравиганом эту дрянь!', 'ui.24', i * 0.5, j * 0.5, ui.col.White, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
            end
        else
            local c = 0
            local d
            for e, f in ipairs(b) do
                if c == 0 then
                    d = ui.Create('ui_panel', function(self)
                        self.Paint = function() end
                        self:SetTall(100)
                    end)
                    self.Items:AddItem(d)
                end
                local function k(l)
                    net.Start'rp.jerome.SellItem'
                    net.WriteString(f.Entity)
                    net.WriteUInt(l, 10)
                    net.WriteEntity(self.NpcEntity)
                    net.SendToServer()
                    self:GetParent():Close()
                end
                local g = ui.Create('rp_modelbutton', d)
                g:SetModel(f.Model)
                g:SetTopText(f.Name)
                g:SetBottomText(rp.FormatMoney(f.BuyPrice)..' - x'..rp.pocket.Data[f.Entity])
                g:SetHoverText('Sell')
                g:SetWide(143)
                g:Dock(LEFT)
                g:DockMargin(0, 0, 2, 0)
                g.DoClick = function(h)
                    if rp.pocket.Data[f.Entity] == 1 then
                        k(1)
                    else
                        local m = ui.DermaMenu(h)
                        m:AddOption('Sell All', function()
                            k(rp.pocket.Data[f.Entity])
                        end)
                        m:AddOption('Sell Some', function()
                            ui.NumberRequest('Sell '..f.Name, 'How many '..f.Name..' would you like to sell?', 1, 1, rp.pocket.Data[f.Entity], function(l)
                                k(l)
                            end)
                        end)
                        m:Open()
                    end
                end
                c = c == 3 and 0 or c + 1
            end
        end
    end

function a:PerformLayout(i, j)
    self.ItemsLabel:SetSize(i, ui.SpacerHeight)
    self.Items:SetSize(i, 100)
    self.PricesLabel:SetSize(i, ui.SpacerHeight)
    self.Prices:SetSize(i, 406)
end
    
function a:Paint() end
    
vgui.Register('rp_npc_jerome_panel', a, 'ui_panel')