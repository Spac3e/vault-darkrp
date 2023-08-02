plib.IncludeSH'shared.lua'
plib.IncludeCL'menu_cl.lua'

local color_white = ui.col.White:Copy()
local color_black = ui.col.Black:Copy()

local complex_off = Vector(0, 0, 9)

local mat = Material("sup/entities/npcs/jerome.png")

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
		draw.SimpleTextOutlined('Скупщик наркотиков', '3d2d', 0, 0, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_BOTTOM, 1, color_black)
		surface.SetDrawColor(255, 255, 255)
		surface.SetMaterial(mat)
		surface.DrawTexturedRect(-64, -230, 128, 128)
	cam.End3D2D()
end

local a

net('rp.DrugBuyerMenu', function()
    local b = self

    if IsValid(a) then
        a:Close()
    end

    local c = math.Round(100 * (nw.GetGlobal('JeromePrice') or 1))

    a = ui.Create('ui_frame', function(self)
        self:SetTitle('Jerome')
        self:SetSize(600, 626)
        self:Center()
        self:MakePopup()

        ui.Create('ui_button', function(self, d)
            self:SetText('Цены: ' .. c .. '%')
            self:SetDisabled(true)
            self:SizeToContents()
            self:SetSize(self:GetWide() + 10, d.btnClose:GetTall())
            self:SetPos(d.btnClose.X - self:GetWide(), 0)

            self.Corners = {true, false, true, false}
        end, self)

        ui.Create('rp_npc_jerome_panel', function(self)
            self:DockToFrame()
            self.NpcEntity = b
            self:AddChildren()
        end, self)
    end)
end)