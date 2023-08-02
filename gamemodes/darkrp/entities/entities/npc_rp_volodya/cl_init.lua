plib.IncludeSH 'shared.lua'

local color_white = ui.col.White:Copy()
local color_black = ui.col.Black:Copy()

local complex_off = Vector(0, 0, 9)

local mat = Material("sup/entities/npcs/santa.png")

local ang = Angle(0, 90, 90)
function ENT:Draw()
	self:DrawModel()

	local bone = self:LookupBone('ValveBiped.Bip01_Head1')
	pos = self:GetBonePosition(bone) + complex_off

	ang.y = (LocalPlayer():EyeAngles().y - 90)

	local inView, dist = self:InDistance(150000)

	if (not inView) then return end

	local alpha = 255 - (dist/590)
	color_white.a = alpha
	color_black.a = alpha

	local x = math.sin(CurTime() * math.pi) * 30

	cam.Start3D2D(pos, ang, 0.03)
		draw.SimpleTextOutlined('Продавец Сладостей', '3d2d', 0, 0, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_BOTTOM, 1, color_black)
		surface.SetDrawColor(255, 255, 255)
			surface.SetMaterial(mat)
			surface.DrawTexturedRect(-64, -230, 128, 128)
	cam.End3D2D()
end

local fr
net('rp.HitmanMenu', function()
	if IsValid(fr) then fr:Close() end

	fr = ui.Create('ui_frame', function(self)
		self:SetTitle('Володя')
		self:SetSize(564, 88)
		self:Center()
		self:MakePopup()
	end)

	ui.Create('DLabel', function(self, p)
		self:SetPos(5, 30)
		self:SetText('Здарова '.. LocalPlayer():Name() ..'! Хочешь заказать на кого-то сладостей?')
		self:SizeToContents()
	end, fr)

	ui.Create('ui_button', function(self, p)
		self:Dock(BOTTOM)
		self:SetTall(25)
		self:SetText('Заказать')
		self.DoClick = function()
			ui.PlayerRequest(function(v)
				ui.StringRequest('Заказать убийство', 'Укажите цену за убийство (' .. rp.FormatMoney(rp.cfg.HitMinCost) .. ' - ' .. rp.FormatMoney(rp.cfg.HitMaxCost) .. ')?', '', function(a)
					if IsValid(v) then
						cmd.Run('hit', v:SteamID(), a)
					end
				end)
			end)
		end
	end, fr)
end)