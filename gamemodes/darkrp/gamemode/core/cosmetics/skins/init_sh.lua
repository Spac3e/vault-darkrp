nw.Register 'OwnedSkin'
    :Write(function(v)
        net.WriteUInt(table.Count(v), 6)
        for k, v in pairs(v) do
            net.WriteString(k)
        end
    end)
    :Read(function()
        local tbl     = {}
        for i = 1, net.ReadUInt(6) do
            tbl[net.ReadString()] = true
        end
        return tbl
    end)

rp.skins = rp.skins or {
	List = {}
}
rp.skins.SortedList = {}

nw.Register'ActiveSkin'
	:Write(function(v)
    	net.WriteUInt(table.Count(v), 6)
        for k, v in pairs(v) do
            net.WriteString(k)
			net.WriteString(v)
        end
    end)
    :Read(function()
        local tbl     = {}
        for i = 1, net.ReadUInt(6) do
            tbl[net.ReadString()] = net.ReadString()
        end
        return tbl
    end)

function PLAYER:GetSkin()
    return self:GetNetVar('ActiveSkin') or {}
end

function rp.skins.Add(data)
    data.Credits = math.max(300, math.floor(data.Price / 10000))
    data.UID = util.CRC(data.Texture)

    if CLIENT and (not data.PreviewNoDraw) and (not data.IconTexture) then
        if data.Animated then
            data.Material = CreateMaterial(data.UID .. '_animaged_unlitgeneric', 'UnlitGeneric', {
                ['$basetexture'] = data.Texture,
                ['$vertexcolor'] = 1,
                ['$vertexalpha'] = 1,
                ['$translucent'] = 1,
                ['$nolod'] = 1,
                ['Proxies'] = {
                    ['AnimatedTexture'] = {
                        ['animatedtexturevar'] = '$basetexture',
                        ['animatedtextureframenumvar'] = '$frame',
                        ['animatedtextureframerate'] = '15'
                    }
                }
            })
        else
            data.Material = CreateMaterial(data.UID .. '_unlitgeneric', 'UnlitGeneric', {
                ['$basetexture'] = data.Texture,
                ['$vertexcolor'] = 1,
                ['$vertexalpha'] = 1,
                ['$translucent'] = 1,
                ['$nolod'] = 1
            })
        end
    end

    rp.skins.List[data.UID] = data
    rp.skins.SortedList[#rp.skins.SortedList + 1] = data
end

function rp.skins.GetPath(uid)
    return rp.skins.List[uid] and rp.skins.List[uid].Texture
end

hook('rp.AddUpgrades', 'rp.Cosmetics.Skins', function()
    for k, v in SortedPairsByMemberValue(rp.skins.List, 'Price', false) do
        local obj = rp.shop.Add(v.Name, 'skin_' .. v.Name)
        obj:SetCat('Skins')
        obj:SetDesc('Permanently gives you the ' .. v.Name .. ' weapon skin.')
        obj:SetPrice(v.Credits)

        obj:SetCanBuy(function(self, pl)
            if pl:HasUpgrade(pl, 'skin_' .. v.Name) or pl:HasWeaponSkin(v.UID) then return false, 'Вы уже купили это.' end

            return true
        end)

        obj:SetOnBuy(function(self, pl)
            rp.data.RemoveActiveWeaponSkin(pl, function()
                if IsValid(pl) then
                    rp.data.AddWeaponSkin(pl, v.UID, function()
                        if IsValid(pl) then
                            pl:SetActiveWeaponSkin(v.UID)
                            pl:AddOwnedWeaponSkin(v.UID)
                        end
                    end)
                end
            end)
        end)

        rp.skins.List[k].UpgradeObj = obj
    end
end)

function PLAYER:GetActiveWeaponSkin()
    return self:GetNetVar('ActiveSkin')
end

function PLAYER:HasWeaponSkin(uid)
    local skins = self:GetNetVar('OwnedSkin')

    return skins and skins[uid]
end

function rp.skins.Reset(ent)
    for k, v in ipairs(ent:GetMaterials()) do
        ent:SetSubMaterial(k - 1)
    end
end

function rp.skins.IsValidWeaponClass(class)
    return (class:Contains('swb') or class:Contains('m9k') or rp.cfg.SkinClassWhitelist[class]) and (class ~= 'swb_base') and (class ~= 'swb_knife')
end