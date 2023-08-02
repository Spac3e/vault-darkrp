pdash.IncludeSH 'shared.lua'

local color_white = ui.col.White:Copy()
local color_black = ui.col.Black:Copy()

local mat = Material("sup/entities/dumpster.png")

function ENT:Draw()
	self:DrawModel()

	local pos = self:GetPos()
	local ang = self:GetAngles()

	ang.y = (LocalPlayer():EyeAngles().y - 180)

	local inView, dist = self:InDistance(125000)

	if (not inView) then return end

	color_white.a = 255 - (dist/500)
	color_black.a = color_white.a

	ang:RotateAroundAxis(ang:Forward(), 90)
	ang:RotateAroundAxis(ang:Right(), -90)
		
	local nextuse = self:GetNextUse()
	if (nextuse > CurTime()) then
		cam.Start3D2D(pos, ang, .1)
			draw.SimpleTextOutlined(string.FormattedTime(nextuse - CurTime(), '%01i:%02i'), '3d2d', 0, -280, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_BOTTOM, 1, color_black)
		cam.End3D2D()
	else 
		cam.Start3D2D(pos, ang, .1)
			draw.SimpleTextOutlined('Мусорка', '3d2d', 0, -280, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_BOTTOM, 1, color_black)
			surface.SetDrawColor(255, 255, 255)
			surface.SetMaterial(mat)
			surface.DrawTexturedRect(-64, -510, 128, 128)		
		cam.End3D2D()
	end
end