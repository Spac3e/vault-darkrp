pdash.IncludeSH 'shared.lua'

local color_red 	= Color(255,50,50)
local color_yellow 	= Color(255,255,50)
local color_green 	= Color(50,255,50)
local color_grey 	= Color(50,50,50)
local color_black 	= Color(0,0,0)
local color_white 	= Color(245,245,245)
local color_sup     = Color(27, 82, 102, 60)
local color_black = Color(0, 0, 0, 255)

local surface_SetDrawColor 		= surface.SetDrawColor
local surface_DrawRect 			= surface.DrawRect
local surface_SetMaterial 		= surface.SetMaterial
local surface_DrawTexturedRect 	= surface.DrawTexturedRect
local draw_SimpleText 			= draw.SimpleText
local draw_Outline 				= draw.Outline
local draw_Box 					= draw.Box
local cam_Start3D2D 			= cam.Start3D2D
local cam_End3D2D 				= cam.End3D2D
local math_Clamp 				= math.Clamp
local math_Round 				= math.Round
local CurTime 					= CurTime
local IsValid 					= IsValid

local font 			= '3d2d'
local printdelay 	= rp.cfg.PrintDelay

local x, y, w, h = -475, 634, 2081, 458
local bx1, by1, bh1, bw1 = x + 10, 			y + 200, w/3 - 10, h - 210
local bx2, by2, bh2, bw2 = bx1 + bh1 + 10, 	y + 200, w/3 - 10, h - 210
local bx3, by3, bh3, bw3 = bx2 + bh2 + 10, 	y + 200, w/3 - 10, h - 210
local tx, ty = w * .5 + x, y + 30

local function predict(timeValue, value)
	return math_Clamp(math_Round((CurTime() - timeValue)/value, 2), 0, 1)
end

local function barcolor(perc)
	return ((perc <= .39) and color_red or ((perc <= .75) and color_yellow or color_green))
end

local logo = Material "icons/money.png"

local function DrawPrinterBar(g, h, i, j, k, l, m)
    color_black:Lerp(k, ui.col.Red, ui.col.Green)
    draw.RoundedBoxEx(25, g, h, j, j, ui.col.Black, true, false, true, false)
    surface.SetDrawColor(255, 255, 255)
    surface.SetMaterial(l)
    local n = j - 50
    surface.DrawTexturedRect(g + 25, h + 25, n, n)
    g = g + j
    i = i - j
    draw.RoundedBoxEx(25, g, h, math.Clamp(i * k, 3, i), j, color_black, false, true, false, true)
    draw.RoundedBoxEx(25, g, h, i, j, ui.col.Background, false, true, false, true)
    draw.SimpleText(m or math.floor(k * 100) .. '%', '3d2d', g + i * 0.5, h + j * 0.5, d, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
end

local material_ink 		= Material 'sup/printer/ink-cartridge-refill.png'
local material_hp 		= Material 'sup/gui/generic/health2.png'
local material_print 	= Material 'sup/printer/printer.png'

function ENT:Draw()
	self:DrawModel()

	local pos = self:GetPos()
	local ang = self:GetAngles()

	if (not self:InDistance(150000)) then return end

	ang:RotateAroundAxis(ang:Up(), 90)
	ang:RotateAroundAxis(ang:Forward(), 39.6)

	cam_Start3D2D(pos + ang:Up() * 24.99, ang, 0.01)
		draw_Box(x, y, w, h, color_grey)

		DrawPrinterBar(bx1, by1, bh1, bw1, self:GetInk()/self:GetMaxInk(), material_ink, self:GetInk() .. '/' .. self:GetMaxInk())
		DrawPrinterBar(bx2, by2, bh2, bw2, self:GetHP()/100, material_hp)

		local printperc = predict(self:GetLastPrint(), printdelay)
		DrawPrinterBar(bx3, by3, bh3, bw3, printperc, material_print)

		local pl = self:Getowning_ent()
		if IsValid(pl) then
			draw_SimpleText(pl:Name(), font, tx, ty, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)
		else
			draw_SimpleText('Неизвестно', font, tx, ty, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)
		end
	cam_End3D2D()
end

function ENT:Think()
	self.PressKeyText = self:GetInk() < self:GetMaxInk() and 'Установить новые чернилы' or nil
end