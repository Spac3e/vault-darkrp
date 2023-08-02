include('shared.lua')

local color_white = ui.col.White:Copy()
local color_black = ui.col.Black:Copy()

local complex_off = Vector(0, 0, 11)
local ang = Angle(0, 90, 90)
function ENT:Draw()
    if LocalPlayer():GetPos():Distance(self:GetPos()) < 1000 then
    end
	self:DrawModel()
	if self:GetPos():Distance( LocalPlayer():GetPos() ) > 250 then return end
	local pos = self:GetPos()
	local ang = self:GetAngles()
	
	ang:RotateAroundAxis(ang:Forward(), 90)
	ang:RotateAroundAxis(ang:Right(), -180)

	cam.Start3D2D(pos, ang, 0.05)
		surface.SetDrawColor(255, 255, 255, alpha)
		surface.SetMaterial(Material('sup/entities/bail.png'))
		surface.DrawTexturedRect(-64, -600, 128, 128)

		draw.SimpleTextOutlined('Внести залог', '3d2d', 0, -350, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_BOTTOM, 1, color_black)
	cam.End3D2D()
end

net.Receive('rp.OpenBail', function()
	local fr = ui.Create('ui_frame', function(self)
		self:SetSize(500, 400)
		self:SetTitle('Освободить из тюрьмы за деньги')
		self:Center()
		self:MakePopup()
	end)

	local list = ui.Create('ui_listview', function(self, p)
		local x, y = p:GetDockPos()
		self:SetPos(x, y)
		self:SetSize(p:GetWide() - 10, p:GetTall() - y - 35)
	end, fr)

	local tbl 	= {}
	local count = net.ReadUInt(8)

	for i=1, count do
		local pl 	= net.ReadEntity()
		local price = net.ReadUInt(16)
		if IsValid(pl) then
			list:AddRow(pl:Name()).Info = {Name = pl:Name(), Price = (LocalPlayer():IsMayor() and 0 or price)}
		end
	end

	if (count == 0) then
		list:AddSpacer('Нет заключённых!')
	end

	local btn = ui.Create('ui_button', function(self, p)
		self:SetText('Bail Machine')
		self:SetPos(5, p:GetTall() - 30)
		self:SetSize(p:GetWide() - 10, 25)

		self.Think = function()
			if (list:GetSelected() ~= nil) then
				local name 	= list:GetSelected().Info.Name
				local price = list:GetSelected().Info.Price

				if LocalPlayer():IsMayor() or (LocalPlayer():GetMoney() >= price) then
					self:SetText('Освободить ' .. name .. ' за ' .. rp.FormatMoney(price))
					self:SetDisabled(false)
				else
					self:SetText('Недостаточно средств!')
					self:SetDisabled(true)
				end
			else
				self:SetText('Не выбран заключённый')
				self:SetDisabled(true)
			end
		end

		self.DoClick = function()
			cmd.Run('bail', list:GetSelected().Info.Name)
			fr:Close()
		end
	end, fr)
end)
