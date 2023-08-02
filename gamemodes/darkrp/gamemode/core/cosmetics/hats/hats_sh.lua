rp.hats = rp.hats or {}
rp.hats.List = {}
rp.hats.SortedList = {}

local c = 0
function rp.hats.Add(a)
    c = c + 1
    a.model = string.lower(a.model or "")
    a.model = string.Replace(a.model, "\\", "/")
    a.model = string.gsub(a.model, "[\\/]+", "/")

    if CLIENT then
        util.PrecacheModel(a.model)
    end

    local b = util.CRC(a.model .. (a.skin or ''))
    a.type = a.type or 1

    if not a.slots then
        if a.type == 1 then
            a.slots = {
                [APPAREL_HATS] = true
            }
        elseif a.type == 2 then
            a.slots = {
                [APPAREL_HATS] = true,
                [APPAREL_MASKS] = true,
                [APPAREL_GLASSES] = true
            }
        elseif a.type == 3 then
            a.slots = {
                [APPAREL_GLASSES] = true
            }
        elseif a.type == 4 then
            a.slots = {
                [APPAREL_SCARVES] = true
            }
        elseif a.type == 5 then
            a.slots = {
                [APPAREL_PETS] = true
            }
        end
    end

    if a.offsets and a.offsets['MALE_CITIZEN'] then
        for c = 1, 9 do
            a.offsets['models/player/group01/male_0' .. c .. '.mdl'] = a.offsets['MALE_CITIZEN']
            a.offsets['models/player/group03/male_0' .. c .. '.mdl'] = a.offsets['MALE_CITIZEN']
            a.offsets['models/player/group03m/male_0' .. c .. '.mdl'] = a.offsets['MALE_CITIZEN']
        end

        for c = 1, 4 do
            a.offsets['models/player/hostage/hostage_0' .. c .. '.mdl'] = a.offsets['MALE_CITIZEN']
        end

        a.offsets['MALE_CITIZEN'] = nil
    end

    if a.offsets and a.offsets['FEMALE_CITIZEN'] then
        for c = 1, 9 do
            a.offsets['models/player/group01/female_0' .. c .. '.mdl'] = a.offsets['FEMALE_CITIZEN']
            a.offsets['models/player/group03/female_0' .. c .. '.mdl'] = a.offsets['FEMALE_CITIZEN']
            a.offsets['models/player/group03m/female_0' .. c .. '.mdl'] = a.offsets['FEMALE_CITIZEN']
        end

        a.offsets['FEMALE_CITIZEN'] = nil
    end

    rp.hats.List[b] = {
        name = a.name or 'unkown',
        model = a.model,
        skin = a.skin,
        category = a.category or 'Misc',
        type = a.type,
        slots = a.slots,
        price = a.price,
        credits = math.max(300, math.floor(a.price / 10000)),
        scale = a.scale or 1,
        offpos = a.offpos or Vector(0, 0, 0),
        offang = a.offang or Angle(0, 0, 0),
        usebounds = a.infooffset == nil,
        infooffset = a.infooffset or 5,
        UID = b,
        offsets = a.offsets or {},
        bone = a.bone or 'ValveBiped.Bip01_Head1',
        CanCustom = a.cancustom or false,
        ShouldRender = file.Exists(a.model, 'GAME') or file.Exists(a.model, 'WORKSHOP'),
        unvisible = a.unvisible
    }

    rp.hats.SortedList[#rp.hats.SortedList + 1] = rp.hats.List[b]
	local d = a.variants

    if d then
        a.variants = nil

        for e, f in ipairs(d) do
            a.name = f
            a.skin = e
            rp.hats.Add(a)
        end
    end
end

function PLAYER:GetHat()
    return self:GetNetVar('Hat') and rp.hats.List[self:GetNetVar('Hat')]
end

local g = {}

function PLAYER:GetApparel()
    return self:GetNetVar('ActiveApparel')
end

-- function PLAYER:GetOwnedApparel()
--     return self:GetNetVar('OwnedApparel')
-- end

function PLAYER:HasApparel(h)
    local i = self:GetNetVar('OwnedApparel')

    return i and (i[h] ~= nil)
end

hook('rp.AddUpgrades', 'rp.Cosmetics.Hats', function()
    for e, f in SortedPairsByMemberValue(rp.hats.List, 'price', false) do
        local j = rp.shop.Add(f.name, 'hat_' .. f.name)
        j:SetCat('Hats')
        j:SetDesc('Permanently gives you the ' .. f.name .. ' hat.')
        j:SetPrice(f.credits)

        j:SetCanBuy(function(self, k)
            if k:HasUpgrade(k, 'hat_' .. f.name) or k:HasApparel(f.UID) then return false, 'You\'ve already purchased this.' end

            return true
        end)

        j:SetOnBuy(function(self, k)
            rp.data.AddApparel(k, f.UID, function()
                if IsValid(k) then
                    k:AddOwnedApparel(f.UID)
                    k:AddApparel(f)
                end
            end)
        end)

        rp.hats.List[e].upgradeobj = j
    end
end)