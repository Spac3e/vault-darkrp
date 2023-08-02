-- топ щахтёр, мi не воры, мы тупо нихуя не делали 
-- за на пянгвин все сделав
include('shared.lua')

local color_white = ui.col.White:Copy()
local color_black = ui.col.Black:Copy()

local complex_off = Vector(0, 0, 9)

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
		draw.SimpleTextOutlined('Железный Ахиллуй', '3d2d', 0, 0, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_BOTTOM, 1, color_black)
	cam.End3D2D()
end

local fr
net('open_rude_menu', function()
	local values = net.ReadTable() or {}

	fr = ui.Create('ui_frame', function(self)
		self:SetTitle('Железный Ахиллуй')
		self:SetSize(450, 500)
		self:Center()
		self:MakePopup()
	end)

	ui.Create('DButton', function(self)
		self:SetText('Продать')
		self:Dock(BOTTOM)
		self.DoClick = function(self)
			net.Start('sell_rude')
			net.SendToServer()
			fr:Close()
		end
	end, fr)

	ui.Create('DPanel', function(self)
	self:Dock(FILL)
	self.Paint = function(s,w,h)
			local old = (values[#values - 1] or 0)
			local color = ( values[#values] > old and Color(0,255,0) or Color(255,0,0) )
			local sym = (values[#values] > old and '▲' or '▼')
			draw.SimpleText( 'Курс цен на драг.металлы','DermaLarge',w/2,0,color_white,1,0 )
			draw.SimpleText('Текущий курс: ~'..math.floor((values[#values] or 0)/2)..'% | '..sym,'ui.23',w/2,32,color,1,0) 
			for b = 1, #values do 
				values[b] = math.Clamp( values[b],1,190 )
			end
			for i = 1, #values do 
				surface.SetDrawColor( color.r,color.g,color.b )
				if (values[i-1] ~= nil) then 
					surface.DrawLine( (w/#values * (i-1)) - (w/#values)/2,h-values[i-1],(w/#values * i) - (w/#values)/2,h - values[i] )
				else

				end
			end
		end
	end, fr)
end)