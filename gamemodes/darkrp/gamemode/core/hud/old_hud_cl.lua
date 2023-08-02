local CurTime						= CurTime
local IsValid 						= IsValid
local ipairs 						= ipairs
local Color 						= Color
local DrawColorModify 				= DrawColorModify

local nw_GetGlobal 					= nw.GetGlobal
local cvar_Get 						= cvar.GetValue
local table_Filter 					= table.Filter
local player_GetAll 				= player.GetAll
local hook_Call 					= hook.Call

local rp_FormatMoney 				= rp.FormatMoney

local math_ceil 					= math.ceil
local math_sin 						= math.sin
local math_max 						= math.max

local draw_SimpleText 				= draw.SimpleText
local draw_SimpleTextOutlined 		= draw.SimpleTextOutlined
local draw_OutlinedBox 				= draw.OutlinedBox
local draw_Box 						= draw.Box
local draw_BlurBox 					= draw.BlurBox

local surface_SetDrawColor 			= surface.SetDrawColor
local surface_DrawLine 				= surface.DrawLine
local surface_DrawTexturedRect 		= surface.DrawTexturedRect
local surface_GetTextSize			= surface.GetTextSize
local surface_SetFont 				= surface.SetFont
local surface_SetMaterial 			= surface.SetMaterial
local surface_DrawOutlinedRect 		= surface.DrawOutlinedRect
local surface_SetTextPos 			= surface.SetTextPos
local surface_SetTextColor 			= surface.SetTextColor
local surface_DrawText 				= surface.DrawText
local surface_DrawRect 				= surface.DrawRect

local cam_Start3D2D 				= cam.Start3D2D
local cam_End3D2D 					= cam.End3D2D

local color_white 					= rp.col.White
local color_black 					= rp.col.Black
local color_red 					= ui.col.Red
local color_orange 					= ui.col.Orange
local color_blue 					= rp.col.SUP
local color_darkred 				= Color(100, 0, 0)
local color_gradient 				= Color(50, 50, 50)
local color_bg 						= ui.col.Header
local color_outline 				= ui.col.Outline:Copy()

local color_armor 					= Color(18, 76, 94, 60)
local color_money 					= Color(135, 135, 31, 60)
local color_time 					= Color(31, 59, 137, 60)
local color_food 					= Color(107, 73, 31, 60)
local color_health 					= Color(59, 109, 45, 60)
local color_job 					= Color(35, 31, 32, 60)
local color_event 					= Color(71, 61, 11, 60)
local color_grace 					= Color(76, 24, 84, 60)
local color_radio 					= Color(15, 15, 15, 60)
local color_sup 					= Color(27, 82, 102, 60)
local color_agenda 					= Color(33, 92, 132, 60)
local color_laws 					= Color(135, 33, 33, 60)
local color_arrest_warrants 		= Color(211, 36, 36, 60)
local color_search_warrants 		= Color(51, 77, 92, 60)
local color_hits 					= Color(40, 40, 40, 60)

local function mat(texture)
    return Material(texture, 'smooth')
end

-- Bar
local material_grad = mat'gui/gradient_down'
local material_job = c
local material_health = mat'sup/hud/health.png'
local material_armor = mat'sup/hud/armor.png'
local material_hunger = mat'sup/hud/food.png'
local material_money = mat'sup/hud/money.png'
local material_events = mat'sup/hud/event.png'
local material_sup = mat'sup/hud/superior.png'
local material_employee = mat'sup/hud/employee.png'
local material_employed = mat'sup/hud/employer.png'
local material_grace = mat'sup/hud/mayorgrace.png'
local material_licence_hud = mat'sup/hud/gunlicense_hud.png'
local material_radio = mat'sup/hud/radio.png'
local material_lockdown = mat'sup/hud/lockdown'

-- player
local material_licence = mat'sup/hud/gunlicense.png'
local material_mic = mat'sup/hud/istalking'
local material_typing = mat'sup/hud/istyping'
local material_voice_muted = mat'sup/hud/voice_muted.png'
local material_chat_muted = mat'sup/hud/chat_muted.png'
local material_presse = mat'sup/hud/button.png'

local mat_bullet = mat'sup/hud/bullet.png'
local mat_911 = mat'sup/hud/911.png'
local mat_aids_right = mat'sup/hud/aids_right.png'
local mat_aids_left = mat'sup/hud/aids_left.png'
local mat_cuffs = mat'sup/hud/cuffs.png'
local mat_bloodstacks = mat'sup/hud/bloodstacks.png'

local mat_agenda = mat'sup/hud/agenda.png'
local mat_laws = mat'sup/hud/laws.png'
local mat_warrents = mat'sup/hud/warrents.png'
local mat_search_warrants = mat'sup/hud/search_warrant.png'
local mat_hits = mat'sup/hud/hits.png'

local sw, sh = ScrW(), ScrH()

local players = {}

cvar.Register 'enable_localplayerinfotag'
	:SetDefault(false, true)
	:AddMetadata('Catagory', 'HUD')
	:AddMetadata('Menu', 'Отображать свой тэг в 3 лице')

cvar.Register 'disable_crosshair'
	:SetDefault(false, true)
	:AddMetadata('Catagory', 'HUD')
	:AddMetadata('Menu', 'Отключить прицел')

cvar.Register 'disable_drawkey'
	:SetDefault(false, true)
	:AddMetadata('Catagory', 'HUD')
	:AddMetadata('Menu', 'Отключить надписи взаимодействия')

surface.CreateFont('HudFont', {
    font = 'Prototype',
    size = 20,
    weight = 350
})

surface.CreateFont('HudFont2', {
    font = 'Helvetica',
    size = 24,
    weight = 700
})

surface.CreateFont('BannedInfo', {
    font = 'Tahoma',
    size = 42,
    weight = 700
})

surface.CreateFont('PlayerInfo', {
    font = 'Tahoma',
    extended = true,
    outline = true,
    shadow = true,
    size = 128,
    weight = 750
})

local talkingplayers = {}

hook('PlayerStartVoice', 'rp.hud.PlayerStartVoice', function(pl)
    talkingplayers[pl] = true
end)

hook('PlayerEndVoice', 'rp.hud.PlayerEndVoice', function(pl)
    talkingplayers[pl] = nil
end)

timer.Simple(1, function()
    Material('voice/icntlk_pl'):SetFloat('$alpha', 0) -- hacky voice bubble fix
end)

-- utils
function GM:DrawBannedHUD()
    local w, h = draw_SimpleText('Вы забанены. Дождитесь разбана', 'BannedInfo', ScrW() * 0.5, ScrH() * 0.1, color_red, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
    draw_SimpleText("Подать апелляцию можно в нашем Discord Сервере или нажав на кнопку F3", 'BannedInfo', ScrW() * 0.5, ScrH() * 0.1 + h, color_red, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
end

function GM:DrawBloodStacks()
    if LocalPlayer():Team() == TEAM_METHHEAD then
        local bs = LocalPlayer():GetNetVar('BloodStacks') or 0
        if bs <= 0 then return end
        surface.SetDrawColor(color_white)
        surface.SetMaterial(mat_bloodstacks)
        local scale = (ScrH() / 2160) * 10
        local size = 64 + scale * bs
        local hSize = size * 0.5
        local x = ScrW() * 0.5 - hSize
        local y = ScrH() * 0.5 - size - ((bs - 1) / 19) * (ScrW() * 0.15)
        surface.DrawTexturedRect(x, y, size, size)
    end
end

local ztcStart
local ztcEnd

function GM:DrawZiptieCutting()
    local pl = LocalPlayer()
    local endTime = pl:GetNetVar('ZiptieCutting')

    if endTime ~= nil then
        --surface.SetFont('ziptiestruggle')
        ztcStart = ztcStart or RealTime()
        ztcEnd = ztcEnd or RealTime() + (endTime - CurTime())
        --local str = pl:IsZiptied() and "Being freed.." or "Freeing.."
        local perc = math.min((RealTime() - ztcStart) / (ztcEnd - ztcStart), 1)
        local w, h = surface.GetTextSize(str) -- /*
        w = w + 16
        local x = (ScrW() - w) * 0.5
        local y = ScrH() * 0.15
        surface.SetDrawColor(rp.col.Outline)
        surface.DrawOutlinedRect(x, y, w, h)
        surface.SetDrawColor(rp.col.Background)
        surface.DrawRect(x, y, w, h)
        surface.SetTextPos(x + 8, y)
        surface.SetTextColor(200, 50, 50, math.abs(math.sin(RealTime() * 2)) * 255)
        surface.DrawText(str)
        surface.SetDrawColor(rp.col.Green)
        surface.DrawRect(x + perc * w, y, 5, h) -- */
        rp.ui.DrawCenteredProgress(pl:IsZiptied() and "Being freed.." or "Freeing..", perc)
    else
        if ztcStart then
            ztcStart = nil
            ztcEnd = nil
        end
    end
end

local function drawKey(text, key, x, y)
    local w, _ = draw_SimpleTextOutlined(text, 'ui.22', x + 37, y + 16, color_white, 1, 1, 1, color_black)
    local textW = w * 0.5
    surface.SetDrawColor(255, 255, 255)
    surface.SetMaterial(material_presse)
    surface.DrawTexturedRect(x - textW, y, 32, 32)
    draw_SimpleText(key, 'ui.24', x - textW + 16, y + 16, color_black, 1, 1)
end

local function DrawTeamMod()
    local plyTeam = LocalPlayer():GetTeamData()

    for i = 1, 4 do
        local plyTeams = plyTeam[i]

        if IsValid(plyTeams) then
            local armor = math.Clamp(plyTeams:Health(), 0, 100)
            local bronia = math.Clamp(plyTeams:Armor(), 0, 100)
            local armorclamp = armor * .525
            local broniaclamp = bronia * .525
            draw.RoundedBox(5, 25, 50 + i * 60, 50, 50, color_black)
            draw.RoundedBox(5, 11, 49 + i * 60, 6, 52, color_black)
            draw.RoundedBox(5, 18, 49 + i * 60, 6, 52, color_black)
            draw.RoundedBox(5, 18, 101.5 + i * 60 - armorclamp, 6, armorclamp, Color(25, 175, 76))
            draw.RoundedBox(5, 11, 101.5 + i * 60 - broniaclamp, 6, broniaclamp, Color(12, 118, 214))
        end
    end
end

function GM:DrawNLR()
    local LP = LocalPlayer()

    if IsValid(LP) and LP:Alive() and !LP:InSpawn() and LP:GetNetVar('NLR') then
        if LP:GetNetVar('NLR').Pos:DistToSqr(LP:GetPos()) < 122500 then
            draw.RoundedBox(0, 0, 0, ScrW(), ScrH(), Color(0, 0, 0, 254))
            draw.SimpleText('Вы в NLR зоне! Покиньте её!', 'ui.60', ScrW() * .5, ScrH() * .25, Color(255, math.sin(CurTime() * math.pi) * 255, math.sin(CurTime() * math.pi) * 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
        end
    end
end

function GM:DrawEntityDisplay(sw, sh)
    local ent = LocalPlayer():GetEyeTrace().Entity
    local x, y = ScrW() * 0.5, ScrH() * 0.65

    if IsValid(ent) and (LocalPlayer():GetPos():Distance(ent:GetPos()) < 115) and not cvar.GetValue('disable_drawkey') then
        if ent.PressKey or ent.PressKeyText or ent.PressE then
            if istable(ent.PressKeyText) then
                for k, v in pairs(ent.PressKeyText) do
                    drawKey(v, k, x, y)
                    y = y + 36
                end
            else
                drawKey(ent.PressKeyText or 'Для использования', ent.PressKey or 'E', x, y)
                y = y + 36
            end
        end

        if ent.CanCarry and (not LocalPlayer():IsCarryingItem()) then
            drawKey('Взять на спину', 'G', x, y)
            y = y + 36
        end
    end

    if LocalPlayer():IsCarryingItem() then
        drawKey('Сбросить со спины', 'G', x, y)
    end
end

function GM:DrawCrosshair()
    local wep = LocalPlayer():GetActiveWeapon()

    if IsValid(wep) then
        if not cvar.GetValue('disable_crosshair') and (wep.DrawCrosshair or (not wep.BaseClass)) then
            draw.SimpleText("●", "ui.20", ScrW() / 2 + 1, ScrH() / 2 - 2, Color(255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
        end
    end
end

hook('HUDPaint', 'rp.hud.HUDPaint', function()
    sw, sh = ScrW(), ScrH()

    if LocalPlayer():IsBanned() then
        GAMEMODE:DrawBannedHUD()
    else
        if hook.Call('HUDShouldDraw', GAMEMODE, 'SUPHUD') ~= false then
            --if LocalPlayer():HasSTD() or LocalPlayer():GetNetVar('Rona') then
            --	GAMEMODE:DrawSTD()
            --end

            GAMEMODE:DrawNLR()

            GAMEMODE:DrawBloodStacks()
            GAMEMODE:DrawEntityDisplay(sw, sh)
            GAMEMODE:DrawZiptieCutting()
            GAMEMODE:DrawCrosshair()
        end
    end
end)
-- Player info
timer.Create('rp.hud.DrawCache', 0.5, 0, function()
    local LP = LocalPlayer()

    players = table.Filter(player.GetAll(), function(pl)
        if IsValid(pl) then
            local insight = pl:Alive() and (pl == LP) or (pl:InSight() and pl:InTrace())
            pl.IsCurrentlyVisible = insight

            return (pl ~= LP or (cvar_Get('enable_localplayerinfotag') and rp.thirdPerson.isEnabled())) and insight and (hook_Call('HUDShouldDraw', nil, 'PlayerDisplay', pl) ~= false)
        end
    end)
end)

local infoy = 0

local function drawinfo(text, color)
    local w, h = surface_GetTextSize(text)
    surface_SetTextColor(color.r, color.g, color.b, color.a)
    local x = -(w * 0.5)
    local y = infoy
    surface_SetTextPos(x, infoy)
    surface_DrawText(text)
    infoy = infoy - (h - 20)

    return x, y, w, h, infoy
end

local color_12h = Color(190, 214, 229)
local color_5k = Color(240, 191, 0)
local color_cache = {}
local c = 0

for i = 0, 720 do
    color_cache[i] = HSVToColor(c, 1, 0.9)
    c = (c == 360) and 1 or (c + 1)
end

local offset = 0
local lastFreq = 0

local function drawRainbowInfo(text)
    local w, h = surface_GetTextSize(text)
    local x = -(w * 0.5)
    local y = infoy
    local freq = math.floor(math.sin(RealTime()) * 35)

    if (freq == 34) and (lastFreq ~= freq) then
        offset = (offset == 360) and 0 or (offset + 1)
    end

    lastFreq = freq

    for c = 1, #text do
        local i = (freq < 0) and (#text - (c - 1)) or c
        local hue = (freq * c) % 360
    end

    infoy = infoy - (h - 20)

    return x, y, w, h, infoy
end

local pang = Angle(0, 90, 90)

function GM:DrawPlayerInfo(pl)
    if not pl:Alive() or pl:GetNWBool('Cloak') then return end
    if pl:GetTeamTable().HidePlayerInfo then return end
    local bone = pl:LookupBone('ValveBiped.Bip01_Head1')
    if not bone then return end
    local pos, _ = pl:GetBonePosition(bone)
    if not pos then return end
    infoy = 0

    if pl.InfoOffset then
        pos.z = pos.z + pl.InfoOffset + 7.5
    else
        pos.z = pos.z + 12.5
    end

    pang.y = LocalPlayer():EyeAngles().y - 90
    cam_Start3D2D(pos, pang, 0.03)
    local x, y, w, h, y2
    local org = pl:GetOrg()

    if org ~= nil then
        x, y, w, h, y2 = drawinfo(org, pl:GetOrgColor())
    end

//    if pl:SteamID() == 'STEAM_0:0:212519647' then
    if pl:GetPlayTime() and (pl:GetPlayTime() > 900000) then
        x, y, w, h, y2 = drawinfo(pl:Name(), ui.col.Gold)
    else
        local color_name = color_white
        x, y, w, h, y2 = drawinfo(pl:Name(), color_name)
    end

    if pl:HasLicense() then
        surface_SetMaterial(material_licence)
        surface_SetDrawColor(color_white.r, color_white.g, color_white.b)
        surface_DrawTexturedRect(x + w + 10, y2 + 118, 128, 128)
    end

    local math_sin = math.sin
    local cin = (math_sin(CurTime() * 6) + 1) * .5
    

    if pl:IsWanted() then
        x, y, w, h, y2 = drawinfo('★ В розыске! ★', Color(cin * 255, 0, 255 - (cin * 255)))
        surface_SetMaterial(material_lockdown)
        surface_SetDrawColor(color_white.r, color_white.g, color_white.b)
        surface_DrawTexturedRect(x + w + 10, y2 + 118, 128, 128)
        surface_DrawTexturedRect(x - 138, y2 + 118, 128, 128)
    elseif pl:IsArrested() then
        x, y, w, h, y2 = drawinfo('Заключённый', color_orange)
        surface_SetMaterial(mat_cuffs)
        surface_SetDrawColor(color_orange.r, color_orange.g, color_orange.b)
        surface_DrawTexturedRect(x + w + 10, y2 + 118, 128, 128)
        surface_DrawTexturedRect(x - 138, y2 + 118, 128, 128)
    else
        x, y, w, h, y2 = drawinfo(pl:GetJobName(), pl:GetJobColor())
    end

    local Nabor = {
        'STEAM_0:0:0', -- 
    }
        
    for k, v in pairs(Nabor) do
        if pl:Team() == TEAM_ADMIN and pl:SteamID() == Nabor[k] then
            x, y, w, h, y2 = drawRainbowInfo('STAFF', Color(30, 144, 255))
        end
    end

    local stNabor = {
        'STEAM_0:0:0', -- 
    }
        
    for k, v in pairs(stNabor) do
        if pl:Team() == TEAM_ADMIN and pl:SteamID() == stNabor[k] then
            x, y, w, h, y2 = drawRainbowInfo('ST.STAFF', Color(30, 144, 255))
        end
    end

    local RNabor = {
        'STEAM_0:0:0', -- 
    }
        
    for k, v in pairs(RNabor) do
        if pl:SteamID() == RNabor[k] then
            x, y, w, h, y2 = drawRainbowInfo('D.ROOT', Color(30, 144, 255))
        end
    end


    local isadmin = LocalPlayer():Team() == TEAM_ADMIN

    if (LocalPlayer():IsHitman() or isadmin) and pl:HasHit() and (pl ~= LocalPlayer()) then
        x, y, w, h, y2 = drawinfo('Заказ: ' .. rp_FormatMoney(pl:GetHitPrice()), color_red)
    end

    local teamtbl = LocalPlayer():GetTeamTable()

    if teamtbl.medic or isadmin then
        x, y, w, h, y2 = drawinfo(pl:Health() .. ' HP', color_red)
    end

    if (teamtbl.bmidealer or isadmin) and (pl:Armor() > 0) then
        x, y, w, h, y2 = drawinfo(pl:Armor() .. ' Armor', color_blue)
    end

    if pl:GetNWBool('isHandcuffed') then
        x, y, w, h, y2 = drawinfo('В наручниках', color_red)
    end

    if pl:IsAdminMode() and pl:Team() != TEAM_ADMIN then
        x, y, w, h, y2 = drawinfo("Режим администратора", HSVToColor(CurTime() % 6 * 60, 1, 1))
    end

    if ( pl:Health() < 51 ) then
        local material_ranen = mat'sup/entities/medlab.png'
       -- x, y, w, h, y2 = drawinfo(pl:Health().."%", color_red)
        x, y, w, h, y2 = drawinfo("Ранен", color_red)
        surface_SetMaterial(material_ranen)
        surface_SetDrawColor(color_white.r, color_white.g, color_white.b)
        surface_DrawTexturedRect(x + w + 10, y2 + 118, 128, 128)
        surface_DrawTexturedRect(x - 138, y2 + 118, 128, 128)
    end
    if talkingplayers[pl] then
        if pl:IsMuted() then
            surface_SetMaterial(material_voice_muted)
            surface_SetDrawColor(color_white.r, color_white.g, color_white.b)
            surface_DrawTexturedRect(-64, y2 - 32, 128, 128)
        else
            surface_SetMaterial(material_mic)
            surface_SetDrawColor(color_white.r, color_white.g, color_white.b)
            surface_DrawTexturedRect(-128, y2 - 138, 256, 256)
        end
    elseif pl:IsTyping() then
        if pl:IsMuted() then
            surface_SetMaterial(material_chat_muted)
            surface_SetDrawColor(color_white.r, color_white.g, color_white.b)
            surface_DrawTexturedRect(-64, y2 - 32, 128, 128)
        else
            surface_SetMaterial(material_typing)
            surface_SetDrawColor(color_white.r, color_white.g, color_white.b)
            surface_DrawTexturedRect(-128, y2 - 64, 256, 256)
        end
    end

    cam_End3D2D()
end

function GM:PostDrawTranslucentRenderables()
    if not IsValid(LocalPlayer()) then return end
    local LP = LocalPlayer()
    surface_SetFont('ui.door')

    for k, v in ipairs(players) do
        if IsValid(v) then
            self:DrawPlayerInfo(v)
        end
    end
end