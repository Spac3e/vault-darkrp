pdash.IncludeSH 'shared.lua'

ENT.Light = {
	Material = 'sup/entities/fiftyfifty/light',
	Color = Color(30, 128, 8)
}

function ENT:DrawScreen(x, y, w, h)
	local rollY = y + 343

	draw.SimpleText(self:GetPlayerRoll(), 'rp.GamblingMachines', x + 335, rollY, ui.col.White, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)

	draw.SimpleText(self:GetHouseRoll(), 'rp.GamblingMachines', x + 827, rollY, ui.col.White, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)

	draw.SimpleText(rp.FormatMoney(self:Getprice()), 'rp.GamblingMachines', x + (w * 0.5), y + 627, ui.col.White, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
end