rp.hud = rp.hud or {
    Panels = {}
}

cvar.Register'enable_lawshud'
    :SetDefault(true, true)
    :AddMetadata('Catagory', 'HUD')
    :AddMetadata('Menu', 'Включить Законы')

local function a(b)
    local c = vgui.Create(b)
    table.insert(rp.hud.Panels, c)

    return c
end

function rp.hud.Create()
    for d, e in ipairs(rp.hud.Panels) do
        if IsValid(e) then
--            print('REMOVING HUD PANEL ' .. tostring(e))
            e:Remove()
        end

        rp.hud.Panels[d] = nil
    end

    
	rp.hud.Bar = a'rp_hud_container_bar'
    
	rp.hud.LeftBar = a'rp_hud_container_left'
    rp.hud.LeftBar:SetSize(ScrW() - 10, ScrH() - rp.hud.Bar:GetTall() - 15)
    rp.hud.LeftBar:SetPos(5, rp.hud.Bar:GetTall() + 10)
    
	rp.hud.RightBar = a'rp_hud_container_right'
    rp.hud.RightBar:SetSize(rp.hud.LeftBar:GetWide(), rp.hud.LeftBar:GetTall())
    rp.hud.RightBar:SetPos(5, rp.hud.LeftBar.Y)
    
	rp.hud.Ammo = a'rp_hud_ammo'
    
	rp.hud.WeaponTooltips = a'rp_hud_weapon_tooltips'

    hook('PlayerSwitchWeapon', rp.hud.WeaponTooltips, function(self, f, g, h)
        if IsFirstTimePredicted() and f == LocalPlayer() then
            self:Clear()

            if h.Tooltips then
                self:SetWeapon(h)
            end
        end
    end)

    -- rp.hud.Props = a'rp_hud_iconbox'
    -- rp.hud.Props:SetMaterial('sup/ui/notifications/info.png')
    -- rp.hud.Props:SetColor(ui.col.FlatBlack)

    -- function rp.hud.Props:ShouldDraw()
    --     local i = LocalPlayer():GetActiveWeapon()

    --     return IsValid(i) and (i:GetClass() == 'weapon_physgun' or i:GetClass() == 'gmod_tool' and i:GetToolObject() and i:GetToolObject().Limit)
    -- end

    -- function rp.hud.Props:GetString()
    --     local i = LocalPlayer():GetActiveWeapon()

    --     if i:GetClass() == 'weapon_physgun' then
    --         return string.Comma(LocalPlayer():GetCount('props')) .. '/' .. string.Comma(LocalPlayer():GetLimit('props'))
    --     elseif i:GetClass() == 'gmod_tool' then
    --         local j = i:GetToolObject()
    --         if j and j.Limit then return string.Comma(LocalPlayer():GetCount(j.Limit)) .. '/' .. string.Comma(LocalPlayer():GetLimit(j.Limit)) end
    --     end
    -- end

    -- function rp.hud.Props:OnUpdate()
    --     local k, l = ScrW() - self:GetWide() - 5, ScrH() - self:GetTall() - 5

    --     if self.X ~= k or self.Y ~= l then
    --         self:SetPos(k, l)
    --     end
    -- end

	rp.hud.Death = a 'rp_hud_death'
    function rp.hud.Death:ShouldDraw()
        return not LocalPlayer():Alive()
    end
end

timer.Simple(2, function()
    if IsValid(LocalPlayer()) then
        rp.hud.Create()
    end
end)

hook('ScreenSizeChanged', 'rp.hud.ScreenSizeChanged', rp.hud.Create)
hook('InitPostEntity', 'rp.hud.InitPostEntity', rp.hud.Create)

function GM:HUDPaint()
    draw.BlurResample()
    DrawWepSwitch()
end

function GM:PreDrawHUD()
end

local o = {
    CHudHealth = true,
    CHudBattery = true,
    CHudSuitPower = true,
    CHudAmmo = true,
    CHudSecondaryAmmo = true,
    CHudWeaponSelection = true,
    CHudCrosshair = true
}

function GM:HUDShouldDraw(b)
    if o[b] or b == 'CHudDamageIndicator' and not LocalPlayer():Alive() then return false end
    local i = IsValid(LocalPlayer()) and LocalPlayer():GetActiveWeapon()
    if IsValid(i) and i:GetClass() == 'gmod_camera' then return b == 'CHudGMod' end

    return true
end

local p = {
    ['$pp_colour_addr'] = 0,
    ['$pp_colour_addg'] = 0,
    ['$pp_colour_addb'] = 0,
    ['$pp_colour_brightness'] = 0,
    ['$pp_colour_contrast'] = 1,
    ['$pp_colour_colour'] = 0,
    ['$pp_colour_mulr'] = 0.05,
    ['$pp_colour_mulg'] = 0.05,
    ['$pp_colour_mulb'] = 0.05
}

function GM:RenderScreenspaceEffects()
    if LocalPlayer():Health() <= 15 and LocalPlayer():GetNetVar('HasInitSpawn') then
        DrawColorModify(p)
    end
end

local q, r = ScrW(), ScrH()

hook('Think', 'rp.hud.Think', function()
    if ScrW() ~= q or ScrH() ~= r then
        hook.Call('ScreenSizeChanged', GAMEMODE, q, r)
        q, r = ScrW(), ScrH()
    end
end)