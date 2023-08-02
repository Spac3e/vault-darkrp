plib.IncludeSH 'shared.lua'

local color_white = ui.col.White:Copy()
local color_black = ui.col.Black:Copy()

local complex_off = Vector(0, 0, 9)

local mat = Material("sup/entities/npcs/meth.png")

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
		draw.SimpleTextOutlined('Брей Кинг Бэд', '3d2d', 0, 0, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_BOTTOM, 1, color_black)
		surface.SetDrawColor(255, 255, 255)
			surface.SetMaterial(mat)
			surface.DrawTexturedRect(-64, -230, 128, 128)
	cam.End3D2D()
end

local fr
net('mth', function()
	if IsValid(fr) then fr:Close() end

	local hasMeth = LocalPlayer():GetNWInt('methcnt')
	local hasMethZero = LocalPlayer():GetNWInt('methcnt') == 0

	fr = ui.Create('ui_frame', function(self)
		self:SetTitle('Брей Кинг Бэд')
		if hasMethZero then
			self:SetSize(360, 80)
		else
			self:SetSize(400, 130)
		end

		self:Center()
		self:MakePopup()
	end)

	ui.Create('DLabel', function(self)
		self:SetPos(5, 30)
		self:SetText(hasMethZero and ('Эй, чувак так дело не пойдет, давай ты\nпридешь когда у тебя что нибудь будет.') or ('Оу чувак! Ты принес мне ' .. hasMeth .. ' г метамфетамина.\nСейчас 1 грамм метамфетамина стоит $'.. MethProd_SellPrice ..'.\nЗа весь твой товар, я тебе дам $'.. hasMeth * MethProd_SellPrice))
		self:SizeToContents()
	end, fr)

	if hasMethZero then return end

	ui.Create('DButton', function(self)
		self:SetText('Продать метамфетамин')
		self:Dock(BOTTOM)
		self.DoClick = function(self)
			net.Start('mth_sell')
			net.SendToServer()
			fr:Close()
		end
	end, fr)
end)