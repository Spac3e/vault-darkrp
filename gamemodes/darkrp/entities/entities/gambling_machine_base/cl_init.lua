pdash.IncludeSH 'shared.lua'

surface.CreateFont('rp.GamblingMachines', {
	font = 'Montserrat Medium',
	size = 90,
	weight = 500,
	shadow = true,
	antialias = true,
})

function ENT:Draw()
	self:DrawModel()

	local pos = self:GetPos()
	local ang = self:GetAngles()

	if (not self:InDistance(150000)) then return end

	local inService = self:GetInService()
	local isPayingOut = self:GetIsPayingOut()

	ang:RotateAroundAxis(ang:Up(), 90)
	ang:RotateAroundAxis(ang:Forward(), 84.16463)

	cam.Start3D2D(self:GetPos() - (self:GetForward() * -1.954) - (self:GetUp() * -44.485) - (self:GetRight() * 0.25), ang, 0.026)
		local x, y, w, h = -580.5, -403, 1161, 806

		if (not inService) then
			surface.SetDrawColor(0, 0, 0, 255)
			surface.DrawRect(x, y, w, h)

			draw.SimpleText('Выключен...', 'rp.GamblingMachines', 0, 0, ui.col.DarkRed, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		else
			self:DrawScreen(x, y, w, h)
		end

		if isPayingOut then
			surface.SetDrawColor(0, 0, 0)
			surface.DrawRect(x, y, w, 230)

			local t = SysTime() * 5
			draw.NoTexture()
			surface.SetDrawColor(255, 255, 255)
			surface.DrawArc(-20, y + 75, 41, 46, t * 180, t * 180 + 180, 5)
			draw.SimpleText('Транзакция...', 'rp.GamblingMachines', 0, y + 130, ui.col.DarkGreen, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)
		end

	cam.End3D2D()
end

function ENT:DrawScreen()

end

local fr
function ENT:PlayerUse()
	if IsValid(fr) then fr:Close() end

	local ent = self

	if (ent:GetPos():Distance(LocalPlayer():GetPos()) >= 80) then return end

	local w, h = 160, 160
	fr = ui.Create('ui_frame', function(self)
		self:SetTitle(ent.PrintName)
		self:SetSize(w, h)
		self:Center()
		self:MakePopup()
		self.Think = function()
			if (not IsValid(ent)) or (ent:GetPos():Distance(LocalPlayer():GetPos()) >= 80) then
				fr:Close()
			end
		end
	end)

	local x, y = fr:GetDockPos()

	ui.Create('rp_entity_priceset', function(self, p)
		self:SetEntity(ent)
		self:SetPos(p:GetDockPos())
		self:SetWide(w - 10)
	end, fr)

	local btnDisable = ui.Create('ui_button', function(self, p)
		self:SetPos(x, y + 89)
		self:SetSize(w - 10, 30)
		self:SetText(ent:GetInService() and 'Выключить' or 'Включить')
		self.Think = function()
			if (not IsValid(ent)) then return end

			self:SetDisabled(ent:GetIsPayingOut())
		end
		self.DoClick = function()
			cmd.Run('setmachineservice')
		end
	end, fr)
end