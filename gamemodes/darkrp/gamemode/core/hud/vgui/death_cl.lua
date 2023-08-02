surface.CreateFont('rp.hud.DeathScreenTitle', {
	font = 'Prototype',
	size = 100,
	weight = 550
})

surface.CreateFont('rp.hud.DeathScreenText', {
	font = 'Prototype',
	size = 50,
	weight = 550
})

local mat_death = Material('sup/hud/death_screen.png', 'smooth')
local mats_death = {
	Material('sup/hud/death_frame-1.png', 'smooth'),
	Material('sup/hud/death_frame-2.png', 'smooth'),
	Material('sup/hud/death_frame-3.png', 'smooth'),
	Material('sup/hud/death_frame-4.png', 'smooth'),
}
local deadok
local PANEL = {}
function PANEL:Init()
	self.BaseClass.Init(self)

	self.Respawn = self:Add('DLabel')
	self.Respawn:SetFont('rp.hud.DeathScreenText')
	self.Respawn:SetTextColor(ui.col.White)

	self:Dock(FILL)
end

function PANEL:PerformLayout(w, h)
	self.Respawn:SizeToContents()
	self.Respawn:SetPos((w * 0.5) - (self.Respawn:GetWide() * 0.5), (h * 0.75) + self.Respawn:GetTall())
end

function PANEL:StartAnimation()
	deadok = RealTime()
end

function PANEL:OnUpdate()
	self.Respawn:SetText('Нажмите любую кнопку для возрождения')
	self:InvalidateLayout(true)
end

function PANEL:ShouldDraw()
	return not LocalPlayer().SelectingGenome and not LocalPlayer():Alive()
end

function PANEL:Paint(w, h)
	draw.Box(0, 0, w, h, ui.col.Black)

	local x, y = w * 0.5 - 256, h * 0.5 - 256

	surface.SetDrawColor(255, 255, 255)
	surface.SetMaterial(mat_death)
	surface.DrawTexturedRect(x, y, 512, 512)

	surface.SetDrawColor(ui.col.DarkRed:Unpack())

	for i = 1, 4 do
		surface.SetMaterial(mats_death[i])
		surface.DrawTexturedRect(x, y, 512, 512)
	end
end

vgui.Register('rp_hud_death', PANEL, 'rp_hud_base')
