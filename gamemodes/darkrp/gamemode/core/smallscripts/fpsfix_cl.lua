hook.Add("SetupWorldFog", "FoxController", function()
    render.FogMode(1)
    render.FogStart(3000 - 150)
    render.FogEnd(3000 - 50)
    render.FogMaxDensity(1)
    local col = Vector(0.8, 0.8, 0.8)
    render.FogColor(col.x * 255, col.y * 255, col.z * 255)

    return true
end)

hook.Add("SetupSkyboxFog", "FoxControllerSky", function()
    render.FogMode(MATERIAL_FOG_LINEAR)
    render.FogStart((3000 - 600) / 16 - (200 / 16))
    render.FogEnd(3000 / 16 - (200 / 16))
    render.FogMaxDensity(1)
    local col = Vector(0.8, 0.8, 0.8)
    render.FogColor(col.x * 255, col.y * 255, col.z * 255)

    return true
end)

hook.Add("OnEntityCreated", "Optimization", function(ent)
    ent.RenderOverride = function()
        if LocalPlayer():GetPos():Distance(ent:GetPos()) < 3000 then
            ent:DrawModel()
            ent:DrawShadow(true)
        else
            ent:DrawShadow(false)
        end
    end
end)