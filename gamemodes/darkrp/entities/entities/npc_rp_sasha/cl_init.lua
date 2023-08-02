plib.IncludeSH 'shared.lua'
plib.IncludeCL 'menu_cl.lua'

local color_white = ui.col.White:Copy()
local color_black = ui.col.Black:Copy()

local complex_off = Vector(0, 0, 9)

local mat = Material("sup/entities/npcs/sasha.png")

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
		draw.SimpleTextOutlined('Скупщик оружия', '3d2d', 0, 0, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_BOTTOM, 1, color_black)
		surface.SetDrawColor(255, 255, 255)
		surface.SetMaterial(mat)
		surface.DrawTexturedRect(-64, -230, 128, 128)
	cam.End3D2D()
end

local fr
net.Receive('rp.GunBuyerMenu', function()
	local ent = self
	if IsValid(fr) then fr:Close() end

	local buyPerc = math.Round(100 * (nw.GetGlobal('SashaPrice') or 1))

	fr = ui.Create('ui_frame', function(self)
		self:SetTitle('Саша')
		self:SetSize(600, 626)
		self:Center()
		self:MakePopup()

		ui.Create('ui_button', function(self, p)
			self:SetText('Цена: ' .. buyPerc .. '%')
			self:SetDisabled(true)
			self:SizeToContents()
			self:SetSize(self:GetWide() + 10, p.btnClose:GetTall())
			self:SetPos(p.btnClose.X - self:GetWide(), 0)
			self.Corners = {true, false, true, false}
		end, self)

		ui.Create('rp_npc_sasha_panel', function(self)
			self:DockToFrame()
			self.NpcEntity = ent
			self:AddChildren()
		end, self)
	end)
end)