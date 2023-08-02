rp.AddCommand('buyapparel', function(pl, targ, text)
    if not targ or not rp.hats.List[targ] or pl:HasApparel(targ) then return '' end
    local hat = rp.hats.List[targ]

    if not pl:CanAfford(hat.price) then
        rp.Notify(pl, NOTIFY_ERROR, term.Get('CannotAfford'))

        return
    end

    local OwnedApparel = pl:GetNetVar('OwnedApparel') or {}
    local ApparelCount = table.Count(OwnedApparel)
    OwnedApparel[hat.UID] = 0
    pl:SetNetVar('OwnedApparel', OwnedApparel)
    pl:TakeMoney(hat.price)

    rp.data.SetHat(pl, hat, function()
        rp.Notify(pl, NOTIFY_SUCCESS, term.Get('HatPurchased'), hat.name, rp.FormatMoney(hat.price))
        rp.achievements.AddProgress(pl, ACHIEVEMENT_APPAREL, 1)
    end)
end)
:AddParam(cmd.STRING)

rp.AddCommand('donateapparel', function(pl, targ, text)
    if not targ or not rp.hats.List[targ] or pl:HasApparel(targ) then return '' end
    local hat = rp.hats.List[targ]

    if not IGS.CanAfford(pl, hat.credits) then
        rp.Notify(pl, NOTIFY_ERROR, term.Get('CannotAfford'))

        return
    end

    local OwnedApparel = pl:GetNetVar('OwnedApparel') or {}
    local ApparelCount = table.Count(OwnedApparel)
    OwnedApparel[hat.UID] = 1
    pl:SetNetVar('OwnedApparel', OwnedApparel)
    pl:AddIGSFunds(-hat.credits, 'Покупка шапки: ' .. hat.name .. ' - ' .. hat.UID)

    rp.data.SetHat(pl, hat, function()
        rp.Notify(pl, NOTIFY_SUCCESS, term.Get('HatPurchased'), hat.name, hat.credits .. ' Rub')
        rp.achievements.AddProgress(pl, ACHIEVEMENT_APPAREL, 1)
    end)
end)
:AddParam(cmd.STRING)

rp.AddCommand('setapparel', function(pl, targ, text)
    if not targ or not rp.hats.List[targ] or not pl:HasApparel(targ) then return '' end
    local hat = rp.hats.List[targ]
    rp.Notify(pl, NOTIFY_SUCCESS, term.Get('HatEquipped'))
    rp.data.SetHat(pl, hat)
end)
:AddParam(cmd.STRING)

rp.AddCommand('removeapparel', function(pl, targ, text)
    if not targ then return '' end
    local hat = rp.hats.List[targ]
    if not hat or not pl:GetApparel()[hat.type] then return end
    rp.Notify(pl, NOTIFY_SUCCESS, term.Get('HatRemoved'))
    rp.data.RemoveHat(pl, hat)
end)
:AddParam(cmd.STRING)