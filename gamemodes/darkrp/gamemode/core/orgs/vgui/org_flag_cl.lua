local a = {}

function a:Init()
    self:SetCursor('hand')
end

function a:PerformLayout()
    self:SetTall(self:GetWide())
end

local flag_ico = 'https://i.imgur.com/'

function a:Paint(b, c)
    surface.SetMaterial(surface.GetWeb(flag_ico..LocalPlayer():GetNetVar('OrgBanner')))
    surface.SetDrawColor(255,255,255)
    surface.DrawTexturedRect((b-c)*.5,0,c,c)
end

function a:PaintOver(b, c)
    if self:IsHovered() then
        self:DrawHoverText('Изменить', b, c)
    end
end

function a:DrawHoverText(f, b, c)
    surface.SetFont('ui.18')
    local g, h = surface.GetTextSize(f)
    g, h = g + 10, h + 10
    draw.RoundedBox(5, b * 0.5 - g * 0.5, c * 0.5 - h * 0.5, g, h, LocalPlayer():GetOrgColor())
    draw.SimpleText(f, 'ui.18', b * 0.5, c * 0.5, ui.col.White, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
end

function a:OnMousePressed(i)
    if i == MOUSE_LEFT then
        -- rp.orgs.OpenOrgBannerEditor(self, self.Perms) -- origin code 
        ui.StringRequest('Изменение флага', 'Вставьте ссылку на изображение Imgur', '', function(resp)
            net.Start("org.setflag")
                net.WriteString(resp)
            net.SendToServer()
        end)
    end
end
 

function a:SetPermissions(j)
    self.Perms = j
end

vgui.Register('org_flag', a, 'Panel')