pdash.IncludeSH 'shared.lua'

local icons = {}

for i = 0, 9 do
	icons[i] = Material('sup/entities/basicslots/icons/' .. i)
end

function ENT:DrawScreen(x, y, w, h, alpha)
	surface.SetDrawColor(255, 255, 255, alpha)

	local iconX, iconY = x + 175, y + 236
	surface.SetMaterial(icons[self:GetRoll1()])
	surface.DrawTexturedRect(iconX, iconY, 256, 256)
	iconX = iconX + 277

	surface.SetMaterial(icons[self:GetRoll2()])
	surface.DrawTexturedRect(iconX, iconY, 256, 256)
	iconX = iconX + 277

	surface.SetMaterial(icons[self:GetRoll3()])
	surface.DrawTexturedRect(iconX, iconY, 256, 256)

	draw.SimpleText(rp.FormatMoney(self:Getprice()), 'rp.GamblingMachines', x + (w * 0.5), y + 731, ui.col.White, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
end