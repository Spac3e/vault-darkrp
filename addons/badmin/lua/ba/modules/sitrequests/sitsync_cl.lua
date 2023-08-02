/*
local function confirmJoin(name, ip)
	ui.BoolRequest("Переезд", "Вы уверены, что хотите присоединиться на " .. name .. " ?", function(resp)
		if resp then
			LocalPlayer():ConCommand('connect ' .. ip)
		end
	end)
end

local function createSitSyncFrame(context)
	local LP = LocalPlayer()

	ui.Create("ui_frame", function(self)
		ba.sitsync.Frame = self

		local w = 200

		self:SetSize(w, #ba.sitsync.Servers * 35 + 35)
		self:SetPos(ScrW() - self:GetWide() - 10, (ScrH() - self:GetTall()) * 0.5)
		self:ShowCloseButton(false)
		self:SetTitle("Наши сервера")
		self:SetMouseInputEnabled(true)
		self:SetDraggable(false)

		for k, v in ipairs(ba.sitsync.Servers) do
			local btn = ui.Create('ui_button', function(btn)
				btn:SetWide(w - 10)
				btn:SetPos(5, 35 * k)
				btn:SetTall(30)
				btn:SetText(v.Name)

				btn.DoClick = function()
					confirmJoin(v.ID, v.IP)
				end

				if game.GetIPAddress() == v.IP or "0.0.0.0:27015" == v.IP then
					btn:SetDisabled(true)
				end
			end, self)
		end

		self.PaintOver = function(self, w, h)end
	end, context)
end

hook('OnContextMenuOpen', function()
	local context = g_ContextMenu

	if (IsValid(ba.sitsync.Frame)) then return end

	createSitSyncFrame(context)
end)
*/
