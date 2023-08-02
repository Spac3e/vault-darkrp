rp.hats = rp.hats or {}
rp.hats.List = {}
rp.hats.stored = rp.hats.stored or {}
local a = Vector(0, 0, -32000)

function rp.hats.Render(b, c)
    if c and c.ShouldRender then
        local d = b:LookupBone(c.bone or 'ValveBiped.Bip01_Head1')
        rp.hats.stored[b] = rp.hats.stored[b] or {}
        local e = rp.hats.stored[b][c.type] or ClientsideModel(c.model, RENDERGROUP_BOTH)
        e.UID = c.UID

        if IsValid(e) then
            rp.hats.stored[b][c.type] = rp.hats.stored[b][c.type] or e

            if d then
                local f = c.offsets[b:GetModel()]
                local g, h = b:GetBonePosition(d)
                local i = f and f.offang or c.offang
                h:RotateAroundAxis(h:Forward(), i.p + 270)
                h:RotateAroundAxis(h:Right(), i.y + 270)
                h:RotateAroundAxis(h:Up(), i.r - 5)
                local j = f and f.offpos or c.offpos
                g = g + h:Forward() * j.x + h:Right() * j.y + h:Up() * j.z
                e:SetModelScale(f and f.scale or c.scale, 0)
                e:SetPos(g)
                e:SetAngles(h)
                e:SetSkin(c.skin or 0)
                e:SetRenderOrigin(g)
                e:SetRenderAngles(h)
                e:SetupBones()
                e:DrawModel()
                e:SetRenderOrigin()
                e:SetRenderAngles()

                if c.model ~= e:GetModel() then
                    e:SetModel(c.model)
                end
            else
                e:SetRenderOrigin(a)
            end

            local k, l = e:GetModelBounds()
            local m = c.usebounds and l.z - k.z or c.infooffset

            if not b.InfoOffset or m > b.InfoOffset then
                b.InfoOffset = m
            end
        end
    end
end

hook('PostPlayerDraw', 'hats.PostPlayerDraw', function(n)
    local o = n:GetApparel() or {}
    n.InfoOffset = nil

    if o then
        local p = LocalPlayer()
        if n ~= p and not n.IsCurrentlyVisible then return end
        if n == p and not rp.thirdPerson.isEnabled() and (IsValid(p:GetActiveWeapon()) and p:GetActiveWeapon():GetClass() ~= 'gmod_camera') then return end

        for q, r in pairs(o) do
            rp.hats.Render(n, rp.hats.List[r])
        end
    end
end)

hook('Think', 'hats.Think', function()
    local p = LocalPlayer()

    for b, s in pairs(rp.hats.stored) do
        for t, e in pairs(s) do
            if not IsValid(e) then
                rp.hats.stored[b][t] = nil
            elseif not IsValid(b) or b:IsPlayer() and (not b:Alive() or not b:GetApparel() or b:GetApparel()[t] ~= e.UID or not rp.thirdPerson.isEnabled() and b == p or b ~= p and not b.IsCurrentlyVisible) then
                e:Remove()
                rp.hats.stored[b][t] = nil
            end
        end
    end
end)