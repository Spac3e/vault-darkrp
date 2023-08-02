local a

net.Receive('TeamModeFrame', function(b)
    local c = LocalPlayer():GetTeamData()

    if IsValid(a) then
        a:Remove()
    end

    for d = 1, 4 do
        local e = c[d]

        if e and IsValid(e) then
            if not IsValid(a) then
                a = ui.Create('ui_frame', function(self, f)
                    self:SetPos(24, 49)
                    self:SetSize(100, 300)
                    self:SetTitle('')
                    self:SetMouseInputEnabled(true)
                    self:ShowCloseButton(false)
                    self:SetDraggable(true)
                    self.Paint = function() end
                end)
            end

            local g = ui.Create('ui_avatarbutton', function(self, f)
                self:SetText('')
                self:SetSize(50, 50)
                self:SetPos(1, 1 + d * 60)
                self:SetPlayer(e, 50)

                self.DoClick = function()
                    cmd.Run('removeplyfromteam', d)
                    self:Remove()
                end

                self.PaintOver = function(self, h, i)
                    if IsValid(e) and not e:Alive() then
                        draw.RoundedBox(5, 0, 0, h, i, Color(0, 0, 0, 200))
                    end
                end
            end, a)
        end
    end
end)

local j

hook('OnContextMenuOpen', 'rp.TeamMode', function()
    local k = LocalPlayer()
    local c = k:GetTeamData()

    j = ui.Create('ui_frame', function(self, f)
        self:SetPos(200, 49)
        self:SetSize(100, 300)
        self:SetTitle('')
        self:SetMouseInputEnabled(true)
        self:ShowCloseButton(false)
        self:SetDraggable(false)
        self.Paint = function() end
    end, g_ContextMenu)

    for d = 1, 4 do
        if c and c[d] then
            local l = ui.Create('DPanel', function(self, f)
                self:SetText('')
                self:SetSize(52, 52)
                self:SetPos(5, 0 + d * 60)

                self.Paint = function(self, h, i)
                    draw.RoundedBox(5, 0, 0, h, i, color_black)
                end

                self.DoClick = function()
                    cmd.Run('addplytoteam', d)
                    g_ContextMenu:Close()
                end
            end, j)

            local g = ui.Create('ui_avatarbutton', function(self, f)
                self:SetText('')
                self:SetSize(50, 50)
                self:SetPos(6, 1 + d * 60)
                self:SetPlayer(c[d], 50)

                self.DoClick = function()
                    cmd.Run('removeplyfromteam', d)
                    self:Remove()
                    local m = self

                    local n = ui.Create('DButton', function(self, f)
                        self:SetText('')
                        self:SetSize(52, 52)
                        self:SetPos(5, 0 + d * 60)

                        self.Paint = function(self, h, i)
                            draw.RoundedBox(5, 1, 1, h - 2, i - 2, color_black)
                        end

                        self.DoClick = function()
                            cmd.Run('addplytoteam', d)
                            g_ContextMenu:Close()
                        end
                    end, j)
                end
            end, j)
        else
            local o = ui.Create('DButton', function(self, f)
                self:SetText('')
                self:SetSize(52, 52)
                self:SetPos(5, 0 + d * 60)

                self.Paint = function(self, h, i)
                    draw.RoundedBox(5, 1, 1, h - 2, i - 2, color_black)
                    draw.SimpleText('+', 'ui.25', 20, 12.5, self:IsHovered() and color_black or color_white)
                end

                self.DoClick = function()
                    ui.PlayerRequest(function(k)
                        cmd.Run('addplytoteam', k:SteamID(), d)
                    end)

                    g_ContextMenu:Close()
                end
            end, j)
        end
    end
end)

hook('OnContextMenuClose', 'rp.TeamMode', function()
    if IsValid(j) then
        j:Remove()
    end
end)