resource.AddWorkshop("2485178558") -- контент

util.AddNetworkString('rp::PhoneSys.phone')
util.AddNetworkString('rp::PhoneSys.phone_client')
Phone = {}
Phone.Calls = {}

function Phone:IsTalking(p, p1)
    for k, v in pairs(Phone.Calls) do
        if table.HasValue(v, p) and table.HasValue(v, p1) and v[3] ~= false then return true end
    end

    return false
end

function Phone:Busy(p)
    if p.MuteNowPhone == true then return true end

    for k, v in pairs(Phone.Calls) do
        if table.HasValue(v, p) then return table.KeyFromValue(v, p) == 1 and v[2] or v[1] end
    end

    return false
end

local notallowjobs = {TEAM_ADMIN, TEAM_DOGE, TEAM_ZOMBIE, TEAM_NEMESIS, TEAM_BOSS}

function Phone:Call(p1, p2)
    if Phone:Busy(p1) or Phone:Busy(p2) then
        p1:SendLua'notification.AddLegacy("Абонент занят", NOTIFY_ERROR, 5)'

        return
    end

    if table.HasValue(notallowjobs, p2:Team()) or table.HasValue(notallowjobs, p1:Team()) then return end

    table.insert(Phone.Calls, {p1, p2, false})

    net.Start'rp::PhoneSys.phone_client'

    net.WriteTable({
        act = 'out',
        ply = p2
    })

    net.Send(p1)
    net.Start'rp::PhoneSys.phone_client'

    net.WriteTable({
        act = 'in',
        ply = p1
    })

    net.Send(p2)
    p1:SetNWEntity("TalkLeader", p2)
    p2:SetNWEntity("TalkLeader", p2) -- yes, kostyl time!!!

    timer.Create("LimitDisconnect_" .. p2:SteamID64(), 30, 1, function()
        Phone:Deny(p2)
    end)
end

function Phone:Accept(p1)
    local p2

    for k, v in pairs(self.Calls) do
        if v[2] == p1 and v[3] == false then
            self.Calls[k][3] = true
            p2 = v[1]
            break
        end
    end

    net.Start'rp::PhoneSys.phone_client'

    net.WriteTable({
        act = 'accept',
        ply = p2
    })

    net.Send(p1)
    net.Start'rp::PhoneSys.phone_client'

    net.WriteTable({
        act = 'accept',
        ply = p1
    })

    net.Send(p2)
    p1:SetNWEntity("TalkWith", p2)
    p2:SetNWEntity("TalkWith", p1)
    p1:SetNWBool("IsTalkingPhone", true)
    p2:SetNWBool("IsTalkingPhone", true)
    timer.Remove("LimitDisconnect_" .. p1:GetNWEntity("TalkLeader"):SteamID64())
end

function Phone:Deny(p1)
    local p2

    for k, v in pairs(self.Calls) do
        if v[2] == p1 or v[1] == p1 then
            table.remove(self.Calls, k)
            p2 = table.KeyFromValue(v, p1) == 1 and v[2] or v[1]
        end
    end

    if not IsValid(p2) then return end
    net.Start'rp::PhoneSys.phone_client'

    net.WriteTable({
        act = 'deny',
        ply = p2
    })

    net.Send(p1)
    net.Start'rp::PhoneSys.phone_client'

    net.WriteTable({
        act = 'deny',
        ply = p1
    })

    net.Send(p2)
    p1:SetNWBool("IsTalkingPhone", false)
    p2:SetNWBool("IsTalkingPhone", false)
    timer.Remove("LimitDisconnect_" .. p1:GetNWEntity("TalkLeader"):SteamID64())
    p1:SetNWEntity("TalkWith", nil)
    p2:SetNWEntity("TalkWith", nil)
    p1:SetNWEntity("TalkLeader", nil)
    p2:SetNWEntity("TalkLeader", nil) -- yes, kostyl time!!!
end

hook.Add("PlayerDisconnected", "PhoneFu11", function(ply)
    Phone:Deny(ply)
end)

hook.Add("PlayerDeath", "PhoneDenyFull", function(ply)
    Phone:Deny(ply)
end)

net.Receive('rp::PhoneSys.phone', function(_, ply)
    local t = net.ReadTable()
    if t.ply == ply then return end

    if t.act == 'call' then
        if not IsValid(t.ply) then
            ply:ChatPrint('игрок не существует или отключился')

            return
        end

        Phone:Call(ply, t.ply)
    end

    if t.act == 'accept' then
        Phone:Accept(ply)
    end

    if t.act == 'deny' then
        Phone:Deny(ply)
    end

    if t.act == 'mute' then
    end

    if t.act == 'muteforever' then
        if ply.MuteNowPhone == true then
            ply.MuteNowPhone = false
            rp.Notify(ply, NOTIFY_SUCCESS, 'Вы выключили режим "Не беспокоить"')
        else
            ply.MuteNowPhone = true
            rp.Notify(ply, NOTIFY_SUCCESS, 'Вы включили режим "Не беспокоить"')
        end
    end
end)

hook.Add('PlayerCanHearPlayersVoice', 'Phone', function(p1, p2)
    if Phone:IsTalking(p1, p2) then return true end
end)