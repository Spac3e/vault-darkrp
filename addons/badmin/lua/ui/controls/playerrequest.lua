local a = {}

function a:Init()
    self.Players = player.GetAll()
    self.SearchBar = ui.Create('DTextEntry', self)
    self.SearchBar:RequestFocus()
    self.SearchBar:SetPlaceholderText('Поиск...')

    self.SearchBar.OnChange = function(b)
        self.PlayerList:AddPlayers(b:GetValue())
    end

    self.PlayerList = ui.Create('ui_listview', self)

    self.PlayerList.AddPlayers = function(b, c)
        c = c and c:Trim()
        b:Reset()
        local d = 0

        for e, f in ipairs(self.Players) do
            if IsValid(f) and f ~= LocalPlayer() then
                if not c or (c and string.find(f:Name():lower(), c:lower(), 1, true) or f:SteamID() == c or f:SteamID64() == c) then
                    b:AddPlayer(f).DoClick = function(g)
                        self:OnSelection(g, f)
                    end

                    d = d + 1
                end
            end
        end

        if d <= 0 then
            b:AddSpacer('Игроки не найдены!')
        end
    end

    self.PlayerList:AddPlayers()
end

function a:PerformLayout()
    self.SearchBar:SetPos(0, 0)
    self.SearchBar:SetSize(self:GetWide(), 25)
    self.PlayerList:SetPos(0, 30)
    self.PlayerList:SetSize(self:GetWide(), self:GetTall() - 30)
end

function a:SetPlayers(h)
    self.Players = h
    self.PlayerList:AddPlayers()
end

function a:OnSelection(g, i)
end

function a:DockToFrame()
    local j = self:GetParent()
    local k, l = j:GetDockPos()
    self:SetPos(k, l)
    self:SetSize(j:GetWide() - 10, j:GetTall() - (l + 5))
end

vgui.Register('ui_playerrequest', a, 'Panel')