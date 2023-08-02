-- ммм ебучий вор, тебе не видать новьё донат
pdash.IncludeSH'shared.lua'

local color_black = ui.col.Black:Copy()

local complex_off = Vector(0, 0, 9)

local mat = Material("sup/gui/generic/credits.png")

local ang = Angle(0, 90, 90)
function ENT:Draw()
	self:DrawModel()

	local bone = self:LookupBone('ValveBiped.Bip01_Head1')
	pos = self:GetBonePosition(bone) + complex_off

	ang.y = (LocalPlayer():EyeAngles().y - 90)

	local inView, dist = self:InDistance(150000)

	if (not inView) then return end

	local alpha = 255 - (dist/590)
	color_black.a = alpha

	local x = math.sin(CurTime() * math.pi) * 30

	cam.Start3D2D(pos, ang, 0.03)
		draw.SimpleTextOutlined('Донат-Магазин', 'ui.door', 0, -40, ui.col.SUP, TEXT_ALIGN_CENTER, TEXT_ALIGN_BOTTOM, 1, color_black)
		surface.SetDrawColor(255, 255, 255)
		surface.SetMaterial(mat)
		surface.DrawTexturedRect(-64, -290, 128, 128)
	cam.End3D2D()
end