include('shared.lua')

local mat = Material("sup/entities/npcs/donate.png")

local color_white = ui.col.White:Copy()
local color_black = ui.col.Black:Copy()
local complex_off = Vector(0, 0, 9)
local simple_off = Vector(0, 0, 75)
local ang = Angle(0, 90, 90)

function ENT:Draw()
	self:DrawModel()
	local pos
	local bone = self:LookupBone('ValveBiped.Bip01_Head1')
	if bone then
		pos = self:GetBonePosition(bone) + complex_off
	else
		pos = self:GetPos() + simple_off
	end
	ang.y = (LocalPlayer():EyeAngles().y - 90)
	local inView, dist = self:InDistance(150000)
	if (not inView) then return end
	local alpha = 255 - (dist/590)
	color_white.a = alpha
	color_black.a = alpha
	local x = math.sin(CurTime() * math.pi) * 30
	cam.Start3D2D(pos, ang, 0.03)
		surface.SetDrawColor(255, 255, 255, alpha)
		surface.SetMaterial(mat)
		surface.DrawTexturedRect(-64, -246 + x, 128, 128)
		draw.SimpleTextOutlined('Кладовщик', '3d2d', 0, x, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_BOTTOM, 1, color_black)
	cam.End3D2D()
end

local function DrawPosInfoFD(icon,pos, s)
	local d = math.floor(LocalPlayer():GetPos():Distance(pos)/100)
	local pos = pos:ToScreen()

	surface.SetDrawColor(255, 255, 255, 255)
	surface.SetMaterial(Material(icon))
	surface.DrawTexturedRect(pos.x, pos.y, 16, 16)

	surface.SetFont( "ui.22" )
	surface.SetTextColor(235, 203, 87, 255)
	surface.SetTextPos(pos.x + 20, pos.y)
	surface.DrawText(s)

	local x, y = surface.GetTextSize(s)
	surface.SetFont("ui.22" )
	surface.SetTextColor(255, 255, 255, 255)
	surface.SetTextPos(pos.x + 20, pos.y + y)
	surface.DrawText("Дистанция: "..d.."m")
end

hook.Add("HUDPaint","PaintRpBoxHud", function()
	if LocalPlayer():GetNWBool("TakeBox", false) then
		for k,v in pairs(ents.FindByClass("npc_ashot")) do
			DrawPosInfoFD("icon16/box.png",v:EyePos(), rp_box.NPC_name)
		end
	end
end)