pdash.IncludeSH 'shared.lua'

local mat_wheel = Material 'sup/entities/spinwheel/wheel'
local mat_cursor = Material 'sup/entities/spinwheel/cursor'

function ENT:DrawScreen(x, y, w, h)
	surface.SetDrawColor(255, 255, 255)

	surface.SetMaterial(mat_wheel)
	surface.DrawTexturedRectRotated(0, 0, w, h, 360 * (self:GetRoll()/8))

	surface.SetMaterial(mat_cursor)
	surface.DrawTexturedRect(x, y, w, h)

	draw.SimpleText(rp.FormatMoney(self:Getprice()), 'rp.GamblingMachines', x + 926, y + 724, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
end
