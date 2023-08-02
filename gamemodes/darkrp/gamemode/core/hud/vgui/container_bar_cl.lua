cvar.Register 'enable_fpshud'
	:SetDefault(false, true)
	:AddMetadata('Catagory', 'HUD')
	:AddMetadata('Menu', 'Включить FPS счётчик')

cvar.Register 'enable_clockhud'
	:SetDefault(false, true)
	:AddMetadata('Catagory', 'HUD')
	:AddMetadata('Menu', 'Включить часы')

cvar.Register 'enable_clockhudserver'
	:SetDefault(false, true)
	:AddMetadata('Catagory', 'HUD')
	:AddMetadata('Menu', 'Включить серверное время')

local PANEL = {}

function PANEL:IconBox(dock)
	local pnl = self:Add 'rp_hud_iconbox'
	pnl:DockMargin(5, 0, 0, 0)
	pnl:Dock(dock or LEFT)

	return pnl
end

function PANEL:Init()
	self:SetPos(0, 5)
	self:SetSize(ScrW() - 5, 34)

	-- Left Side
	self.Org = self:IconBox()
	self.Org:SetMaterial('sup/gui/generic/group.png')
	function self.Org:ShouldDraw()
		return (LocalPlayer():GetOrg() ~= nil)
	end
	function self.Org:GetString()
		local org = LocalPlayer():GetOrg()
		self:SetColor(LocalPlayer():GetOrgColor())
		return org
     /*	local org = LocalPlayer():GetOrg()
        if org and LocalPlayer():GetOrgData() and LocalPlayer():GetOrgData().Flag then
            self:SetMaterial(surface.GetWeb('https://i.imgur.com/' .. LocalPlayer():GetOrgData().Flag .. '.png'))
        end
        self:SetColor(LocalPlayer():GetOrgColor())
        return org */	
	end

	self.Job = self:IconBox()
	self.Job:SetColor(Color(35, 31, 32))
	self.Job:SetMaterial('sup/gui/generic/job.png')
	function self.Job:GetString()
		self:SetColor(LocalPlayer():GetJobColor())
		return LocalPlayer():GetJobName()
	end

	self.Health = self:IconBox()
	self.Health:SetColor(Color(59, 109, 45))
	self.Health:SetMaterial('sup/gui/generic/health2.png')
	function self.Health:GetString()
		return math.max(LocalPlayer():Health(), 0) .. '%'
	end
	function self.Health:GetProgress()
		return LocalPlayer():Health() / 100
	end

	self.Armor = self:IconBox()
	self.Armor:SetColor(Color(18, 76, 94))
	self.Armor:SetMaterial('sup/gui/generic/armor.png')
	function self.Armor:ShouldDraw()
		return LocalPlayer():Armor() > 0
	end
	function self.Armor:GetString()
		return math.max(LocalPlayer():Armor(), 0) .. '%'
	end
	function self.Armor:GetProgress()
		return LocalPlayer():Armor() / 100
	end

	self.Food = self:IconBox()
	self.Food:SetColor(Color(107, 73, 31))
	self.Food:SetMaterial('sup/gui/generic/food.png')
	function self.Food:GetString()
		return LocalPlayer():GetHunger() .. '%'
	end
	function self.Food:GetProgress()
		return LocalPlayer():GetHunger() / 100
	end

	self.Money = self:IconBox()
	self.Money:SetColor(Color(135, 135, 31))
	self.Money:SetMaterial('sup/gui/generic/money.png')
	function self.Money:GetString()
		local salary = LocalPlayer():GetSalary()
		return rp.FormatMoney(LocalPlayer():GetMoney()) .. ' | +' .. salary
	end
	self.Karma = self:IconBox()
	self.Karma:SetColor(Color(81, 31, 104))
	self.Karma:SetMaterial('sup/gui/generic/karma.png')
	function self.Karma:GetString()
		return string.Comma(LocalPlayer():GetKarma())
	end
	-- Right Side
	local logoTexts = {
		'[VAULT] DarkRP'
	}

	local i = 1
	local logoText = logoTexts[1]
	self.Logo = self:IconBox(RIGHT)
	self.Logo:SetColor(Color(14, 20, 40))
    self.Logo:SetSize(10,10)
	self.Logo:SetMaterial('hud/logos/logo.png')
	self.Logo:SetUpdateRate(300)
	function self.Logo:GetString()
		logoText = logoTexts[i]
		i = logoTexts[i + 1] and i + 1 or 1
		return logoText
	end
	
	-- todo: fix raids sys
	-- self.Raid = self:IconBox(RIGHT)
	-- self.Raid:SetColor(Color(182, 125, 21))
	-- self.Raid:SetMaterial('sup/gui/generic/timer.png')
	-- function self.Raid:ShouldDraw()
	-- 	return nw.GetGlobal('rp.raid') and nw.GetGlobal('rp.raid.time') > CurTime() and nw.GetGlobal('rp.raid.time') != nil
	-- end
	-- function self.Raid:GetString()
	-- 	return 'Рейд: ' .. string.FormattedTime(math.ceil(nw.GetGlobal('rp.raid.time') - CurTime()), '%02i:%02i')
	-- end

	self.RealClock = self:IconBox(RIGHT)
	self.RealClock:SetColor(ui.col.FlatBlack)
	self.RealClock:SetMaterial('sup/gui/generic/clock.png')
	self.RealClock:SetUpdateRate(1)
	function self.RealClock:GetString()
		return os.date('%I:%M:%S %p')
	end
	function self.RealClock:ShouldDraw()
		return cvar.GetValue('enable_clockhud')
	end

	self.ServerClock = self:IconBox(RIGHT)
	self.ServerClock:SetColor(ui.col.FlatBlack)
	self.ServerClock:SetMaterial('sup/gui/generic/clock.png')
	self.ServerClock:SetUpdateRate(1)
	function self.ServerClock:GetString()
		return os.date('%I:%M:%S', CurTime())
	end
	function self.ServerClock:ShouldDraw()
		return cvar.GetValue('enable_clockhudserver')
	end

	self.FPS = self:IconBox(RIGHT)
	self.FPS:SetColor(Color(0, 0, 0))
	self.FPS:SetMaterial('sup/gui/generic/fps.png')
	self.FPS:SetUpdateRate(1)
	function self.FPS:GetString()
		local fps = math.floor(1 / FrameTime())

		local perc = math.min(fps/100, 1)

		self.ColorPrimary.r = 180 - (perc * 180)
		self.ColorPrimary.g = perc * 180

		self.ColorSecondary.r = self.ColorPrimary.r
		self.ColorSecondary.g = self.ColorPrimary.g

		return fps
	end
	function self.FPS:ShouldDraw()
		return cvar.GetValue('enable_fpshud')
	end

	self.Lockdown = self:IconBox(RIGHT)
	self.Lockdown:SetColor(Color(87, 87, 87))
	self.Lockdown:SetMaterial('sup/hud/911.png')
	function self.Lockdown:GetString()
		return 'Начался Ком.Час! Срочно возвращайтесь по домам!'
	end
	function self.Lockdown:ShouldDraw()
		return (nw.GetGlobal('lockdown') ~= nil)
	end

	self.Events = self:IconBox(RIGHT)
	self.Events:SetColor(ui.col.Gold)
	self.Events:SetMaterial('sup/gui/generic/event.png')
	function self.Events:ShouldDraw()
		return (nw.GetGlobal('EventsRunning') ~= nil) and (table.Count(nw.GetGlobal('EventsRunning')) > 0)
	end
	function self.Events:GetString()
		local events = nw.GetGlobal('EventsRunning')

		local c = 0
		local str = ''
		for k, v in pairs(events) do
			c = c + 1
			str = str .. ((c == 1) and '' or ', ') .. k
		end

		str = str .. ((c > 1) and ' Ивент' or ' Ивент')

		return str
	end

	self.MayorGrace = self:IconBox(RIGHT)
	self.MayorGrace:SetColor(Color(81, 31, 104))
	self.MayorGrace:SetMaterial('sup/gui/generic/clock.png')
	function self.MayorGrace:ShouldDraw()
		return nw.GetGlobal('mayorGrace') and nw.GetGlobal('mayorGrace') > CurTime()
	end
	function self.MayorGrace:GetString()
		return 'Неприкосновенность мэра: ' .. string.FormattedTime(math.ceil(nw.GetGlobal('mayorGrace') - CurTime()), '%02i:%02i')
	end

	self.MayorCheckin = self:IconBox(RIGHT)
	self.MayorCheckin:SetColor(Color(104, 31, 31))
	self.MayorCheckin:SetMaterial('sup/gui/generic/clock.png')
	function self.MayorCheckin:ShouldDraw()
		return LocalPlayer():IsMayor() and nw.GetGlobal('MayorCheckin')
	end
	function self.MayorCheckin:GetString()
		return 'Check In: ' .. string.FormattedTime(math.ceil(nw.GetGlobal('MayorCheckin') - CurTime()), '%02i:%02i')
	end



	rp.hud.Timers = rp.hud.Timers or {}

	local function makeTimer(name, timerEnd)
		local timerBox = self:IconBox(RIGHT)
		timerBox:SetColor(Color(150, 72, 0))
		timerBox:SetMaterial('sup/gui/generic/timer.png')
		function timerBox:ShouldDraw()
			local shouldDraw = timerEnd > CurTime()

			if (not shouldDraw) then
				rp.hud.Timers[name] = nil
				self:Remove()
			end

			return shouldDraw
		end
		function timerBox:GetString()
			return name .. ': ' .. string.FormattedTime(math.ceil(timerEnd - CurTime()), '%02i:%02i')
		end

		rp.hud.Timers[name] = {
			End = timerEnd,
			Box = timerBox
		}
	end

	net('rp::timer.Modify', function()
		local name = net.ReadString()

		local tab = rp.hud.Timers[name]

		if tab and IsValid(tab.Box) then
			tab.Box:Remove()
			rp.hud.Timers[name] = nil
		end

		if net.ReadBool() then
			makeTimer(name, CurTime() + net.ReadUInt(32))
		end
	end)


	for k, v in pairs(rp.hud.Timers) do
		makeTimer(k, v.End)
	end


	self.RadioChannel = self:IconBox(RIGHT)
	self.RadioChannel:SetColor(Color(15, 15, 15))
	self.RadioChannel:SetMaterial('sup/gui/generic/radio.png')
	function self.RadioChannel:ShouldDraw()
		return LocalPlayer():GetNetVar('RadioChannel') ~= nil
	end
	function self.RadioChannel:GetString()
		return LocalPlayer():GetNetVar('RadioChannel')
	end

	self.Employer = self:IconBox(RIGHT)
	self.Employer:SetColor(Color(42, 22, 116))
	self.Employer:SetMaterial('sup/gui/generic/employer.png')
	function self.Employer:ShouldDraw()
		return IsValid(LocalPlayer():GetNetVar('Employer'))
	end

	self.Employee = self:IconBox(RIGHT)
	self.Employee:SetColor(Color(42, 22, 116))
	self.Employee:SetMaterial('sup/gui/generic/employee.png')
	function self.Employee:ShouldDraw()
		return LocalPlayer():GetNetVar('Employees') ~= nil
	end

	self.GunLicense = self:IconBox(RIGHT)
	self.GunLicense:SetColor(Color(0, 100, 100))
	self.GunLicense:SetMaterial('sup/gui/generic/gun_license.png')
	function self.GunLicense:ShouldDraw()
		return LocalPlayer():HasLicense()
	end

	function PLAYER:IsAdminMode()
		return self:GetNWBool('adminmode')
	end

	self.AdminMode = self:IconBox(RIGHT)
	self.AdminMode:SetColor(ui.col.SUP:Copy())
	self.AdminMode:SetMaterial('sup/gui/generic/admin.png')
	function self.AdminMode:GetString()
		return 'Режим администратора'
	end
	function self.AdminMode:ShouldDraw()
		return LocalPlayer():GetNWBool('adminmode') and LocalPlayer():Team() != TEAM_ADMIN
	end
end

function PANEL:Paint(w, h)
end

function PANEL:PerformLayout(w, h)

end

vgui.Register('rp_hud_container_bar', PANEL, 'Panel')