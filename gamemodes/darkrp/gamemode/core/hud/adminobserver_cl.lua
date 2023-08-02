local surface = surface
local Material = Material
local draw = draw
local DrawBloom = DrawBloom
local DrawSharpen = DrawSharpen
local DrawToyTown = DrawToyTown
local Derma_StringRequest = Derma_StringRequest;
local RunConsoleCommand = RunConsoleCommand;
local tonumber = tonumber;
local tostring = tostring;
local CurTime = CurTime;
local Entity = Entity;
local unpack = unpack;
local table = table;
local pairs = pairs;
local ScrW = ScrW;
local ScrH = ScrH;
local concommand = concommand;
local timer = timer;
local ents = ents;
local hook = hook;
local math = math;
local draw = draw;
local pcall = pcall;
local ErrorNoHalt = ErrorNoHalt;
local DeriveGamemode = DeriveGamemode;
local vgui = vgui;
local util = util
local net = net
local player = player

FSpectate = {}

local isSpectating = false
local specEnt
local thirdperson = true
local isRoaming = false

local maxdistmeters_plys = 200
local maxdist_plys = maxdistmeters_plys / 0.01905
local maxdistsqr_plys = maxdist_plys * maxdist_plys

local maxdistmeters_ents = 35
local maxdist_ents = maxdistmeters_ents / 0.01905
local maxdistsqr_ents = maxdist_ents * maxdist_ents

hook.Add("Initialize", "FSpectate", function()
    surface.CreateFont("UiBold", {
        size = 16,
        weight = 800,
        antialias = true,
        shadow = false,
        font = "Verdana"})
end)

local LineMat = Material("cable/new_cable_lit")
local linesToDraw = {}

local view = {}

function specCalcView()
    view.origin = LocalPlayer():GetShootPos()
    view.angles = LocalPlayer():EyeAngles()
end

local function lookingLines()
    if not linesToDraw[0] then return end
    render.SetMaterial(LineMat)
    cam.Start3D(view.origin, view.angles)
        for i = 0, #linesToDraw, 3 do
            render.DrawLine(linesToDraw[i], linesToDraw[i + 1], linesToDraw[i + 2]) --render.DrawBeam(linesToDraw[i], linesToDraw[i + 1], 2, 0.01, 10, linesToDraw[i + 2])
        end
    cam.End3D()
end

local function gunpos(ply)
    return ply:EyePos()
end

local function specThink()
    local ply = LocalPlayer()

    local pls = player.GetAll()
    local lastPly = 0
    local skip = 0
    for i = 0, #pls - 1 do
        local p = pls[i + 1]
        if not IsValid(p) then continue end
        if p == LocalPlayer() then
            skip = skip + 3
            continue
        end
        if not isRoaming and p == specEnt and not thirdperson then skip = skip + 3 continue end

        local tr = p:GetEyeTrace()
        local sp = gunpos(p)

        local pos = i * 3 - skip

        linesToDraw[pos] = tr.HitPos
        linesToDraw[pos + 1] = sp
        linesToDraw[pos + 2] = team.GetColor(p:Team())
        lastPly = i
    end
    for i = #linesToDraw, lastPly * 3 + 3, -1 do linesToDraw[i] = nil end
end

local uiForeground, uiBackground = Color(240, 240, 255, 255), Color(20, 20, 20, 120)
local red = Color(255, 0, 0, 255)
local green = Color(0, 255, 0, 255)

local ents_blacklist = {
    ["ent_bonemerged"] = true,
    ["base_gmodentity"] = true,
}

local function drawHelp()
    local scrHalfH = math.floor(ScrH() / 2)

    local pls = player.GetAll()
    for i = 1, #pls do
        local ply = pls[i]
        if not IsValid(ply) then continue end
        if LocalPlayer():GetPos():DistToSqr(ply:GetPos()) > maxdistsqr_plys then continue end

        local pos = ply:GetShootPos():ToScreen()
        if not pos.visible then continue end

        local x, y = pos.x, pos.y

        draw.RoundedBox(2, x, y - 6, 12, 12, team.GetColor(ply:Team()))
        draw.WordBox(2, x, y - 86, ply:Nick().."("..ply:Name()..")", "BudgetLabel", uiBackground, uiForeground)
        draw.WordBox(2, x, y - 66, ply:GetJobName(), "BudgetLabel", uiBackground, team.GetColor(ply:Team()))
        --draw.WordBox(2, x, y - 46, "HP: "..ply:Health().."/"..ply:GetMaxHealth(), "BudgetLabel", uiBackground, green)
      --  draw.WordBox(2, x, y - 26, ply:SteamID(), "BudgetLabel", uiBackground, uiForeground)
    end
    end

local funnywh = false

concommand.Add("funny_wallhackers", function()

    if !LocalPlayer():IsSuperAdmin() then return end

    funnywh = !funnywh

end)

hook.Add("Think", "FSpectate_AdminObserver", function()
    if !LocalPlayer():IsAdmin() then return end
    if LocalPlayer():InVehicle() then return end

        if (LocalPlayer():GetMoveType() == MOVETYPE_NOCLIP or funnywh) and !isSpectating and LocalPlayer():Team() != TEAM_SPECTATOR then
            isSpectating = true

            hook.Add("Think", "FSpectate", specThink)
            hook.Add("HUDPaint", "FSpectate", drawHelp)
            hook.Add("CalcView", "FSpectate", specCalcView)
            hook.Add("RenderScreenspaceEffects", "FSpectate", lookingLines)
        elseif ((LocalPlayer():GetMoveType() != MOVETYPE_NOCLIP and !funnywh) or LocalPlayer():Team() == TEAM_SPECTATOR) and isSpectating then
            isSpectating = false

            hook.Remove("Think", "FSpectate")
            hook.Remove("HUDPaint", "FSpectate")
            hook.Remove("CalcView", "FSpectate", specCalcView)
            hook.Remove("RenderScreenspaceEffects", "FSpectate")
        end
    end)