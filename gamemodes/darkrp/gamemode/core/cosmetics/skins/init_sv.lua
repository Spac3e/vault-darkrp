rp.AddCommand('buywepskin', function(pl, targ, text)
    if not targ or not rp.skins.List[targ] then return '' end
    local skin = rp.skins.List[targ]
    if not pl:CanAfford(skin.Price) then
        rp.Notify(pl, NOTIFY_ERROR, term.Get('CannotAfford'))

        return
    end

    local OwnedApparel = pl:GetNetVar('OwnedSkin') or {}
    local ActiveSkin = pl:GetNetVar('ActiveSkin') or {}

    ActiveSkin[text] = skin.UID
    pl:SetNetVar('ActiveSkin',ActiveSkin)

    rp.data.UpdateSkin(pl, skin.UID, text)
    local ApparelCount = table.Count(OwnedApparel)
    OwnedApparel[skin.UID] = 0

    pl:SetNetVar('OwnedSkin', OwnedApparel)
    pl:TakeMoney(skin.Price)
    rp.data.SetSkinGun(pl, skin, function()
        rp.Notify(pl, NOTIFY_SUCCESS, term.Get('HatPurchased'), skin.Name, rp.FormatMoney(skin.Price))
        
        for k, v in ipairs(player.GetAll()) do
            v:SendMessageFD(ui.col.Red, "[Skins] ", pl:GetJobColor(), pl:Name(), Color(255, 255, 255), " купил ", skin.Color, skin.Name, Color(255, 255, 255), " за $" .. skin.Price)
        end

        rp.achievements.AddProgress(pl, ACHIEVEMENT_GUNSKIN, 1)
    end)
end)
:AddParam(cmd.STRING)
:AddParam(cmd.STRING)

rp.AddCommand('donateskin', function(pl, targ, text)
    if not targ or not rp.skins.List[targ] then return '' end
    local skin = rp.skins.List[targ]

    if not IGS.CanAfford(pl, skin.Credits) then
        rp.Notify(pl, NOTIFY_ERROR, term.Get('CannotAfford'))

        return
    end

    local OwnedApparel = pl:GetNetVar('OwnedSkin') or {}
    local ActiveSkin = pl:GetNetVar('ActiveSkin') or {}
    
    ActiveSkin[text] = skin.UID
    
    pl:SetNetVar('ActiveSkin', ActiveSkin)
    rp.data.UpdateSkin(pl, skin.UID, text)
    
    local ApparelCount = table.Count(OwnedApparel)
    
    OwnedApparel[skin.UID] = 0
    
    pl:SetNetVar('OwnedSkin', OwnedApparel)
    pl:AddIGSFunds(-skin.Credits, 'Покупка скина: ' .. skin.Name .. ' - ' .. skin.UID)

    rp.data.SetSkinGun(pl, skin, function()
        rp.Notify(pl, NOTIFY_SUCCESS, term.Get('HatPurchased'), skin.Name, rp.FormatMoney(skin.Credits))

        for k, v in ipairs(player.GetAll()) do
            v:SendMessageFD(ui.col.Red, "[Skins] ", pl:GetJobColor(), pl:Name(), Color(255, 255, 255), " купил ", skin.Color, skin.Name, Color(255, 255, 255), " за " .. skin.Credits .. ' руб')
        end

        rp.achievements.AddProgress(pl, ACHIEVEMENT_GUNSKIN, 1)
    end)
end)
:AddParam(cmd.STRING)
:AddParam(cmd.STRING)

rp.AddCommand('setwepskin', function(pl,targ,text)
    if not targ or not rp.skins.List[targ] then return '' end 
    local Update = pl:GetNetVar('ActiveSkin')
    Update[text] = targ 
    pl:SetNetVar('ActiveSkin',Update)
    rp.Notify(pl, NOTIFY_SUCCESS, term.Get('SkinEquiped'))
    rp.data.UpdateSkin(pl,targ,text)
end)
:AddParam(cmd.STRING)
:AddParam(cmd.STRING)

rp.AddCommand('removewepskin', function(pl, targ, text)
    if not targ or not rp.skins.List[targ] or not pl:HasWeaponSkin(targ) then return '' end 
    local Update = pl:GetNetVar('ActiveSkin')
    Update[tostring(text)] = nil
    pl:SetNetVar('ActiveSkin',Update)
    rp.Notify(pl, NOTIFY_SUCCESS, term.Get('SkinRemoved'))
    rp.data.RemoveSkin(pl,targ,text)
end)
:AddParam(cmd.STRING)
:AddParam(cmd.STRING)