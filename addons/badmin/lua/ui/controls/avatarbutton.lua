function _R.Player:ShowProfile()
	gui.OpenURL('https://steamcommunity.com/profiles/' .. self:SteamID64())
end

local PANEL = {}

function PANEL:Init()
	self:SetText('')

	self.Button = ui.Create('DButton', self)
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
	self.Button.PaintOver = function(_, w, h)
		derma.SkinHook('Paint', 'AvatarImage', self, w, h)
	end
	self.Button.Paint = function() end
end

function PANEL:PerformLayout()
	if IsValid(self.AvatarImage) then
		self.AvatarImage:SetPos(0, 0)
		self.AvatarImage:SetSize(self:GetWide(), self:GetTall())
	end

	self.Button:SetPos(0, 0)
	self.Button:SetSize(self:GetWide(), self:GetTall())
end

function PANEL:DoClick()
	local pl = self:GetPlayer()
	if IsValid(pl) then
		pl:ShowProfile()
	else
		gui.OpenURL('https://steamcommunity.com/profiles/' .. self.SteamID64)
	end
end

function PANEL:SetPlayer(pl)
	self.AvatarImage = ui.Create('AvatarImage', self)
	self.AvatarImage:SetPlayer(pl)

	self.Button:SetParent(self.AvatarImage)

	self.Player = pl
	self.SteamID64 = pl:SteamID64()
end

function PANEL:SetSteamID64(steamid64)
	self.SteamID64 = steamid64
end

function PANEL:GetPlayer()
	return self.Player
end

function PANEL:GetSteamID64()
	return self.SteamID64
end

vgui.Register('ui_avatarbutton', PANEL, 'DPanel')