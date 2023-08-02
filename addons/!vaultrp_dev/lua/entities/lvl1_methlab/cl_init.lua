include('shared.lua')

local color_white = Color(255,255,255)
local bg_colors = Color(35,35,35,250)
local color_black = Color(35,35,35,250)

function ENT:Draw()
	self:DrawModel()

	local pos = self:GetPos()
	local ang = self:GetAngles()

	local inView, dist = self:InDistance(150000)

	if (not inView) then return end

	color_white.a = 255 - (dist/590)
	color_black.a = color_white.a
	bg_colors.a = color_white.a

	local owner = IsValid(self:Getowning_ent()) and self:Getowning_ent():Name() or 'unknown'
	
	ang:RotateAroundAxis(ang:Up(), 180)
	ang:RotateAroundAxis(ang:Forward(), 35)

	cam.Start3D2D(pos + ang:Up() * 19.5 +ang:Forward() * -0.4 +ang:Right() * -10, ang, 0.24)
		surface.SetDrawColor(bg_colors)
		surface.DrawRect(2,0,132,50)

		surface.SetDrawColor(color_white)
		surface.DrawOutlinedRect(2,0,132,50,40)

		draw.SimpleTextOutlined(owner, 'ui.18', 5, 0, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_LEFT, 1, color_black)
		draw.SimpleTextOutlined('Метамфетамина:', 'ui.18', 5, 15, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_LEFT, 1, color_black)
		draw.SimpleTextOutlined(self:GetNWInt('curmeth') .. 'г', 'ui.18', 5, 30, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_LEFT, 1, color_black)
	cam.End3D2D()
end