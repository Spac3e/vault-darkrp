local IsValid = IsValid
local ipairs = ipairs
local LocalPlayer = LocalPlayer
local Angle = Angle
local Vector = Vector
local ents_FindInSphere = ents.FindInSphere
local util_TraceLine = util.TraceLine
local draw_SimpleTextOutlined = draw.SimpleTextOutlined
local team_GetColor = team.GetColor
local team_GetName = team.GetName
local cam_Start3D2D = cam.Start3D2D
local cam_End3D2D = cam.End3D2D
local surface_SetDrawColor = surface.SetDrawColor
local surface_SetMaterial = surface.SetMaterial
local surface_DrawTexturedRect = surface.DrawTexturedRect
local rp_orgs_GetBanner = rp.orgs.GetBanner
local color_white = ui.col.White:Copy()
local color_black = ui.col.Black:Copy()
local color_green = ui.col.Green:Copy()
local off_ang = Angle(0, 90, 90)
local doorcache = {}
local color_gold = Color(255, 215, 0)

timer.Create('rp.RefreshDoorCache', 0.5, 0, function()
    if IsValid(LocalPlayer()) then
        local count = 0
        doorcache = {}

        for k, ent in ipairs(ents_FindInSphere(LocalPlayer():GetPos(), 350)) do
            if IsValid(ent) and ent:IsDoor() and (ent:IsPropertyOwnable() or ent:IsPropertyOwned() or ent:IsPropertyTeamOwned() or ent:IsPropertyHotelOwned()) then
                ent.PressKeyText = 'Открыть/Закрыть'
                count = count + 1
                doorcache[count] = ent
            end
        end
    end
end)

local h = 0
local a = 255

local function drawtext(text, color)
    color.a = a
    color_black.a = a
    local tw, th = draw.SimpleTextOutlined(text, 'ui.door', 0, h, color, 1, TEXT_ALIGN_TOP, 2, color_black)
    h = h + th
end

local function IsDoorHotel(door_ent)
	if not IsValid(door_ent) or not door_ent:IsDoor() then return end
	for k, v in pairs(rp.cfg.Doors) do 
		if table.HasValue(v.MapIDs,door_ent:GetDoorID()) then 
			is_hotel = (v.Hotel == true) 
		end
	end
	return is_hotel or false
end

local trace = {}

local drawFixes = {
    ['models/props_c17/door02_double.mdl'] = function(ent, tr, lw)
        local cent = ent:OBBCenter()
        cent.y = cent.y * 0.625
        local lw = ent:LocalToWorld(cent)
        lw.z = lw.z + 17.5
        trace.start = LocalPlayer():GetPos() + LocalPlayer():OBBCenter()
        trace.endpos = lw
        trace.filter = LocalPlayer()
        local tr = util_TraceLine(trace)

        return lw, tr
    end
}

local material_locked = Material('sup/gui/generic/locked.png')
local material_unlocked = Material('sup/gui/generic/unlocked.png')

local function drawLockedInfo(ent)
    local isLocked = ent:IsDoorLocked()
    draw.RoundedBox(20, -42, -89, 84, 84, isLocked and ui.col.DarkRed or ui.col.DarkGreen)
    surface.SetDrawColor(255, 255, 255)
    surface.SetMaterial(isLocked and material_locked or material_unlocked)
    surface_DrawTexturedRect(-32, -79, 64, 64)
end

local trace = {}

hook('PostDrawTranslucentRenderables', 'rp.doors.PostDrawTranslucentRenderables', function()
    for _, ent in ipairs(doorcache) do
        if IsValid(ent) and ent:InView() then
            h = 0
            local dist = ent:GetPos():DistToSqr(LocalPlayer():GetPos())
            a = (122500 - dist) / 350
            local lw, tr
            lw = ent:LocalToWorld(ent:OBBCenter())
            lw.z = lw.z + 17.5
            trace.start = LocalPlayer():GetPos() + LocalPlayer():OBBCenter()
            trace.endpos = lw
            trace.filter = LocalPlayer()
            tr = util_TraceLine(trace)

            if (tr.Entity == ent) and (lw:DistToSqr(tr.HitPos) < 65) then
                cam_Start3D2D(tr.HitPos + tr.HitNormal, tr.HitNormal:Angle() + off_ang, .03)

                if ent:GetPropertyName() ~= nil then
                    drawtext(ent:GetPropertyName(), ent:GetPropertyColor() or color_white) --$Название помещения
                    drawLockedInfo(ent)
                end

                local isteamown = false

                for k, v in pairs(rp.cfg.Doors) do
                    if table.HasValue(v.MapIDs, ent:GetDoorID()) then
                        isteamown = v.Teams ~= nil
                    end
                end

                if not IsDoorHotel(ent) then
                    if ent:DoorIsOwnable() and not isteamown then
                        drawLockedInfo(ent)
						drawtext('F2 - Арендовать', color_gold)
						drawtext('' .. rp.FormatMoney(LocalPlayer():Wealth(rp.cfg.DoorCostMin, rp.cfg.DoorCostMax) * ent:GetNWInt("PriceMultiplier")), color_green)
                    elseif not ent:DoorIsOwnable() then
                        -- Group Own
                        if ent:DoorGetGroup() ~= nil then
                            drawtext(ent:DoorGetGroup(), rp.teamDoors[ent:DoorGetGroup()].Color)
                        end

                        local owner = ent:DoorGetOwner()

                        -- Org
                        if owner:GetNetVar('org_banner') and IsValid(owner) and (owner:GetOrg() ~= nil) then
							local org = owner:GetOrg()
						--	local banner = rp.orgs.GetBanner(org)
						--	if banner then
								surface.SetDrawColor(255, 255, 255)
								surface.SetMaterial(surface.GetWeb('https://i.imgur.com/'..owner:GetOrgData().Flag..'.png'))
								surface_DrawTexturedRect(-256, -660, 512, 512)
						--	end
							drawtext(org, owner:GetOrgColor())
						end

                        -- Team Own
                        if ent:DoorGetTeam() ~= nil then
                            drawtext(team_GetName(ent:DoorGetTeam()), team_GetColor(ent:DoorGetTeam()))
                        end

                        -- Owner
                        if IsValid(owner) then
                            drawtext(owner:Name(), owner:GetJobColor())
                        end

                        -- Co-Owners
                        if ent:DoorGetCoOwners() ~= nil then
                            for k, co in ipairs(ent:DoorGetCoOwners()) do
                                if IsValid(co) then
                                    drawtext(co:Name(), co:GetJobColor())
                                end

                                if k >= 4 then
                                    drawtext('еще ' .. (#ent:DoorGetCoOwners() - 4) .. ' совладельцев.', color_white)
                                    break
                                end
                            end
                        end
                    end
                else
                    if true then
                        drawtext("Жильцы:", color_white)

                        if ent:DoorGetCoOwners() ~= nil then
                            for k, co in ipairs(ent:DoorGetCoOwners()) do
                                if IsValid(co) then
                                    drawtext(co:Name(), co:GetJobColor())
                                end

                                if k >= 4 then
                                    drawtext('еще ' .. (#ent:DoorGetCoOwners() - 4) .. ' жильцов.', color_white)
                                    break
                                end
                            end
                        end
                    else
                        if LocalPlayer():Team() == 29 then
                            drawtext("Вы хозяин!", color_green)
                        end
                    end
                end
                cam_End3D2D()
            end
        end
    end
end)