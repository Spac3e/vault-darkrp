local PANEL = {}

function PANEL:Init()
	-- Arrested
	rp.hud.Arrested = self:Add 'rp_hud_box'
	rp.hud.Arrested:SetTitle('Арестован')
	rp.hud.Arrested:SetMaterial('sup/gui/generic/handcuffs.png')
	rp.hud.Arrested:SetColor(ui.col.DarkRed)

	function rp.hud.Arrested:FindPos()
		return ScrW() * 0.5 - self:GetWide() * 0.5, ScrH() - self:GetTall() - 5
	end

	rp.hud.Arrested.Time = ui.Create('rp_hud_info')
	rp.hud.Arrested.Time:SetName('Осталось:')
	rp.hud.Arrested:AddItem(rp.hud.Arrested.Time)

	function rp.hud.Arrested:ShouldDraw()
		return LocalPlayer():IsArrested()
	end
	function rp.hud.Arrested:OnUpdate()
		local info = LocalPlayer():GetArrestInfo()
		rp.hud.Arrested.Time:SetInfo(string.FormattedTime(info.Release - CurTime(), '%02i:%02i'))
	end


	-- Wanted
	rp.hud.Wanted = self:Add 'rp_hud_box'
	rp.hud.Wanted:SetTitle('Розыск')
	rp.hud.Wanted:SetMaterial('sup/gui/generic/wanted.png')
	rp.hud.Wanted:SetColor(ui.col.DarkRed)

	function rp.hud.Wanted:FindPos()
		return ScrW() * 0.5 - self:GetWide() * 0.5, ScrH() - self:GetTall() - 5
	end

	rp.hud.Wanted.Reason = ui.Create('rp_hud_info')
	rp.hud.Wanted.Reason:SetName('Причина:')
	rp.hud.Wanted:AddItem(rp.hud.Wanted.Reason)

//	rp.hud.Wanted.Time = ui.Create('rp_hud_info')
//	rp.hud.Wanted.Time:SetName('Осталось:')
//	rp.hud.Wanted:AddItem(rp.hud.Wanted.Time)

	function rp.hud.Wanted:ShouldDraw()
		return LocalPlayer():IsWanted()
	end

	function rp.hud.Wanted:OnUpdate()
		local info = LocalPlayer():GetWantedReason()

		rp.hud.Wanted.Reason:SetInfo(info)
	//	rp.hud.Wanted.Time:SetInfo(string.FormattedTime(math.ceil(info.Time - CurTime(), '%02i:%02i')))
	end


	-- Laws
	rp.hud.Laws = self:Add 'rp_hud_textbox'
	rp.hud.Laws:SetTitle('Законы города')
	rp.hud.Laws:SetMaterial('materials/sup/gui/generic/court.png')
	rp.hud.Laws:SetColor(Color(34, 188, 36))
	function rp.hud.Laws:GetString()
		return rp.cfg.DefaultLaws .. (nw.GetGlobal('TheLaws') or '')
	end
	function rp.hud.Laws:ShouldDraw()
		return cvar.GetValue('enable_lawshud') and (not rp.hud.Arrested:IsVisible()) and (not rp.hud.Wanted:IsVisible())
	end
	function rp.hud.Laws:FindPos()
		return ScrW() - self:GetWide() - 5, 44
	end


	-- Camera
	--rp.hud.Camera = self:Add 'rp_hud_camera'
	--rp.hud.Camera:SetTitle('Security Cameras (F3)')
	--rp.hud.Camera:SetMaterial('sup/gui/generic/camera.png')
	--rp.hud.Camera:SetColor(Color(49, 116, 143))
	----function rp.hud.Camera:ShouldDraw()
	--	return #rp.SecurityCameras > 0
	--end
end

function PANEL:PerformLayout(w, h)
	local y = 0
	for k, v in ipairs(self:GetChildren()) do
		if v:IsVisible() then
			v:SetPos((self.DockType == LEFT) and 0 or (w - v:GetWide()), y)
			y = y + v:GetTall() + 5
		end
	end
end

vgui.Register('rp_hud_container_right', PANEL, 'Panel')
