function _R.Player:ShowProfile()
    gui.OpenURL('https://steamcommunity.com/profiles/'..self:SteamID64())
end

local a = {}

function a:Init()
    self:SetText('')
    self.Button = ui.Create('ui_button', self)
    self.Button:SetText('')
    
    self.Button.DoClick = function()
        self:DoClick()
    end
    
    self.Button.OnCursorEntered = function()
        self.Hovered = true
    end
    
    self.Button.OnCursorExited = function()
        self.Hovered = false
    end
    self.Button.PaintOver = function(b, c, d) end

    self.Button.Paint = function() end
end

function a:PerformLayout()
    if IsValid(self.AvatarImage) then
        self.AvatarImage:SetPos(0, 0)
        self.AvatarImage:SetSize(self:GetWide(), self:GetTall())
    end

    self.Button:SetPos(0, 0)
    self.Button:SetSize(self:GetWide(), self:GetTall())
end

function a:DoClick()
    local e = self:GetPlayer()

    if IsValid(e) then
        e:ShowProfile()
    elseif self:GetSteamID64() then
        gui.OpenURL('https://steamcommunity.com/profiles/' .. self.SteamID64)
    end
end

function a:SetPlayer(e, f)
    self.AvatarImage = ui.Create('AvatarImage', self)
    self.AvatarImage:SetPlayer(e, f)
    self.AvatarImage:SetPaintedManually(true)
    self.Button:SetParent(self.AvatarImage)
    self.Player = e
    self.SteamID64 = e:SteamID64()
end

local g = {}

function a:SetSteamID64(h, f)
    self.AvatarImage = ui.Create('AvatarImage', self)
    self.AvatarImage:SetSteamID(h, f)
    self.AvatarImage:SetPaintedManually(true)
    self.Button:SetParent(self.AvatarImage)
    self.SteamID64 = h
end

local i = {}

function a:SetURL(j, k)
    self.Url = j

    if i[j] then
        self.Material = i[j]
    else
        texture.Delete('ImageButton_' .. j)

        texture.Create('ImageButton_' .. j):EnableProxy(k):EnableCache(false):Download(j, function(l, m)
            if IsValid(self) then
                self.Material = m
                i[j] = m
            end
        end)
    end
end

function a:SetMaterial(n)
    self.Material = n
end

function a:GetPlayer()
    return self.Player
end

function a:GetSteamID64()
    return self.SteamID64
end

function a:GetURL()
    return self.Url
end

function a:Paint(c, d)
    derma.SkinHook('Paint', 'ImageButton', self, c, d)
end

vgui.Register('ui_imagebutton', a, 'DPanel')