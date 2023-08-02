if SuiScoreBoard then
	SuiScoreBoard:Remove()
	SuiScoreBoard = nil
end

local activePlayer
local PANEL = {}

--[[---------------------------------------------------------
   Name: PerformLayout
---------------------------------------------------------]]
function PANEL:Init()
	self.btnHours = vgui.Create("DButton", self)
	self.btnRank = vgui.Create("DButton", self)
	self.btnOrg = vgui.Create("DButton", self)
	self.btnSteam = vgui.Create("DButton", self)
	self.btnSteamID = vgui.Create("DButton", self)

	self.btnSteam.DoClick = function()
		self.Player:ShowProfile()
	end

	self.btnSteamID.DoClick = function()
		SetClipboardText(self.Player:SteamID())
		self.btnSteamID.Copied = true
		self.btnSteamID:SetText("Copied to clipboard")

		timer.Simple(2.5, function()
			if IsValid(self) and IsValid(self.btnSteamID) then
				self.btnSteamID.Copied = nil
			end
		end)
	end
end

--[[---------------------------------------------------------
   Name: PerformLayout
---------------------------------------------------------]]

--[[---------------------------------------------------------
   Name: UpdatePlayerData
---------------------------------------------------------]]
function PANEL:SetPlayer(ply)
	self.Player = ply
	self:UpdatePlayerData()
end

--[[---------------------------------------------------------
   Name: UpdatePlayerData
---------------------------------------------------------]]
function PANEL:UpdatePlayerData()
	if not IsValid(self.Player) then return end
	self.btnSteam:SetText("View Steam Profile")

	if (not self.btnSteamID.Copied) then
		self.btnSteamID:SetText(self.Player:SteamID())
	end

	self.btnHours:SetText("Play time: " .. ba.str.FormatTime(self.Player:GetPlayTime()))
	--self.btnHours:SetDisabled(true)
	self.btnRank:SetText("Rank: " .. self.Player:GetUserGroup())
	--self.btnRank:SetDisabled(true)
	self.btnOrg:SetText('Org: ' .. (self.Player:GetNWString("orgName") and self.Player:GetNWString("orgName") or 'None'))
	--self.btnOrg:SetDisabled(true)
	self:InvalidateLayout()
end

--[[---------------------------------------------------------
   Name: PerformLayout
---------------------------------------------------------]]
function PANEL:ApplySchemeSettings()
	local w, h = (self:GetWide() / 3), (self:GetTall() / 3) - 3
	self.btnRank:SetSize(w, h)
	self.btnRank:SetPos(2, 2)
	self.btnHours:SetSize(w, h)
	self.btnHours:SetPos(2, h + 4)
	self.btnOrg:SetSize(w, h)
	self.btnOrg:SetPos(2, h * 2 + 6)
	self.btnSteam:SetSize(w, h)
	self.btnSteam:SetPos(w + 4, h + 4)
	self.btnSteamID:SetSize(w, h)
	self.btnSteamID:SetPos(w + 4, h * 2 + 6)
end

--[[---------------------------------------------------------
   Name: PerformLayout
---------------------------------------------------------]]
function PANEL:Think()
	if self.PlayerUpdate and self.PlayerUpdate > CurTime() then return end
	self.PlayerUpdate = CurTime() + 1
	self:UpdatePlayerData()
end

--[[---------------------------------------------------------
   Name: PerformLayout
---------------------------------------------------------]]
function PANEL:PerformLayout()
end

function PANEL:Paint(w, h)
	return true
end




if SuiScoreBoard then
	SuiScoreBoard:Remove()
	SuiScoreBoard = nil
end


local activePlayer
local PANEL = {}

--[[---------------------------------------------------------
   Name: PerformLayout
---------------------------------------------------------]]
function PANEL:Init()
	self.btnHours = vgui.Create("DButton", self)
	self.btnRank = vgui.Create("DButton", self)
	self.btnOrg = vgui.Create("DButton", self)
	self.btnSteam = vgui.Create("DButton", self)
	self.btnSteamID = vgui.Create("DButton", self)

	self.btnSteam.DoClick = function()
		self.Player:ShowProfile()
	end

	self.btnSteamID.DoClick = function()
		SetClipboardText(self.Player:SteamID())
		self.btnSteamID.Copied = true
		self.btnSteamID:SetText("Copied to clipboard")

		timer.Simple(2.5, function()
			if IsValid(self) and IsValid(self.btnSteamID) then
				self.btnSteamID.Copied = nil
			end
		end)
	end
end

--[[---------------------------------------------------------
   Name: PerformLayout
---------------------------------------------------------]]

--[[---------------------------------------------------------
   Name: UpdatePlayerData
---------------------------------------------------------]]
function PANEL:SetPlayer(ply)
	self.Player = ply
	self:UpdatePlayerData()
end

--[[---------------------------------------------------------
   Name: UpdatePlayerData
---------------------------------------------------------]]
function PANEL:UpdatePlayerData()
	if not IsValid(self.Player) then return end
	self.btnSteam:SetText("View Steam Profile")

	if (not self.btnSteamID.Copied) then
		self.btnSteamID:SetText(self.Player:SteamID())
	end

	self.btnHours:SetText("Play time: " .. ba.str.FormatTime(self.Player:GetPlayTime()))
	--self.btnHours:SetDisabled(true)
	self.btnRank:SetText("Rank: " .. self.Player:GetUserGroup())
	--self.btnRank:SetDisabled(true)
	self.btnOrg:SetText('Org: ' .. (self.Player:GetNWString("orgName") and self.Player:GetNWString("orgName") or 'None'))
	--self.btnOrg:SetDisabled(true)
	self:InvalidateLayout()
end

--[[---------------------------------------------------------
   Name: PerformLayout
---------------------------------------------------------]]
function PANEL:ApplySchemeSettings()
	local w, h = (self:GetWide() / 3), (self:GetTall() / 3) - 3
	self.btnRank:SetSize(w, h)
	self.btnRank:SetPos(2, 2)
	self.btnHours:SetSize(w, h)
	self.btnHours:SetPos(2, h + 4)
	self.btnOrg:SetSize(w, h)
	self.btnOrg:SetPos(2, h * 2 + 6)
	self.btnSteam:SetSize(w, h)
	self.btnSteam:SetPos(w + 4, h + 4)
	self.btnSteamID:SetSize(w, h)
	self.btnSteamID:SetPos(w + 4, h * 2 + 6)
end

--[[---------------------------------------------------------
   Name: PerformLayout
---------------------------------------------------------]]
function PANEL:Think()
	if self.PlayerUpdate and self.PlayerUpdate > CurTime() then return end
	self.PlayerUpdate = CurTime() + 1
	self:UpdatePlayerData()
end

--[[---------------------------------------------------------
   Name: PerformLayout
---------------------------------------------------------]]
function PANEL:PerformLayout()
end

function PANEL:Paint(w, h)
	return true
end


