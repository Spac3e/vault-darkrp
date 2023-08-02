plib.IncludeSH'shared.lua'

local color_white = ui.col.White:Copy()
local color_black = ui.col.Black:Copy()

local complex_off = Vector(0, 0, 9)

local mat = Material("sup/entities/npcs/copshop.png")

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
		draw.SimpleTextOutlined('Арсенал полиции', '3d2d', 0, 0, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_BOTTOM, 1, color_black)
		surface.SetDrawColor(255, 255, 255)
		surface.SetMaterial(mat)
		surface.DrawTexturedRect(-64, -230, 128, 128)
	cam.End3D2D()
end

local a

net('rp.CopshopMenu', function()
    if IsValid(a) then
        a:Close()
    end

    local b = LocalPlayer():IsCP() or LocalPlayer():IsMayor()

    a = ui.Create('ui_frame', function(self)
        self:SetTitle('Роберт')

        if b then
            self:SetSize(ScrW() * .4, ScrH() * .5)
        else
            self:SetSize(300, 55)
        end

        self:Center()
        self:MakePopup()
    end)

    if b then
        local c = ui.Create('ui_scrollpanel', function(self, d)
            self:SetSpacing(2)
            self:DockToFrame()
            self:PerformLayout()
        end, a)

        local e = {}

        for f = 1, math.ceil(table.Count(rp.CopItems) / 4) do
            local g = ui.Create('Panel', function(self)
                self:SetSize(c:GetWide(), 100)
            end)

            c:AddItem(g)

            for f = 1, 4 do
                table.insert(e, g)
            end
        end

        local f = 1

        for h, i in pairs(rp.CopItems) do
            local j = ui.Create('rp_shopbutton', e[f])
            j:SetModel(i.Model)
            j:SetTitle(i.Name)
            j:SetPrice(i.Price)

            j.DoClick = function()
                cmd.Run('copbuy', i.Name)
            end

            j:SetWide(e[f]:GetWide() / 4 - 2)
            j:Dock(LEFT)
            j:DockMargin(2, 2, 0, 0)
            f = f + 1
        end
    else
        ui.Create('DLabel', function(self, d)
            self:SetPos(5, 30)
            self:SetText('Ты не гос чтобы покупать здесь!')
            self:SizeToContents()
        end, a)
    end
end)