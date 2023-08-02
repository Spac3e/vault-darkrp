rp.orgs = rp.orgs or {}

function PLAYER:GetOrg()
    return self:GetNetVar('Org')
end

function PLAYER:GetOrgID()
    return self:GetNetVar('OrgID')
end

function PLAYER:GetOrgData()
    return self:GetNetVar('OrgData')
end

local a = Color(255, 255, 255)

require 'pcolor'

function PLAYER:GetOrgColor()
    return pcolor.FromHex(self:GetNetVar('OrgColor')) or a
end

function PLAYER:GetOrgRank()
    local b = self:GetNetVar('OrgData')

    return b and b.Rank
end

function PLAYER:IsOrgOwner()
    local b = self:GetNetVar('OrgData')

    return b and b.Perms and b.Perms.Owner
end

function PLAYER:HasOrgPerm(c)
    local b = self:GetNetVar('OrgData')

    return b and b.Perms and b.Perms[c]
end

rp.orgs.BaseData = {
    ['Owner'] = {
        Rank = 'Owner',
        Perms = {
            Weight = 100,
            Owner = true,
            Invite = true,
            Kick = true,
            Rank = true,
            MoTD = true,
            Banner = true,
            Withdraw = true,
            InvWithdraw = true
        }
    }
}

function rp.orgs.GetOnlineMembers(d)
    return table.Filter(player.GetAll(), function(e)
        return e:GetOrg() == d
    end)
end

function rp.orgs.GetOnline()
    local f = {}
    local g = {}

    for h, i in ipairs(player.GetAll()) do
        local d = i:GetOrg()

        if d and not g[d] then
            f[#f + 1] = {
                Name = d,
                Color = i:GetOrgColor()
            }

            g[d] = true
        end
    end

    g = nil

    return f
end

nw.Register'Org':Write(net.WriteString):Read(net.ReadString):SetPlayer():SetHook('nw.Org')
nw.Register'OrgBanner':Write(net.WriteString):Read(net.ReadString):SetPlayer():SetHook('nw.OrgBanner')
nw.Register'OrgID':Write(net.WriteUInt, 16):Read(net.ReadUInt, 16):SetLocalPlayer()
nw.Register'OrgColor':Write(net.WriteString):Read(net.ReadString):SetPlayer():SetHook('nw.OrgColor')

nw.Register'OrgData':Write(function(i)
    net.WriteString(i.Rank)
    net.WriteString(i.MoTD)
    net.WriteBool(tobool(i.MoTD))
    net.WriteUInt(i.Perms.Weight, 7)
    net.WriteBool(i.Perms.Owner)
    net.WriteBool(i.Perms.Invite)
    net.WriteBool(i.Perms.Kick)
    net.WriteBool(i.Perms.Rank)
    net.WriteBool(i.Perms.MoTD)
    net.WriteBool(i.Perms.Banner)
    net.WriteBool(i.Perms.Withdraw)
    net.WriteBool(i.Perms.InvWithdraw)
end):Read(function()
    return {
        Rank = net.ReadString(),
        MoTD = {
            Text = net.ReadString(),
            Dark = net.ReadBool()
        },
        Perms = {
            Weight = net.ReadUInt(7),
            Owner = net.ReadBool(),
            Invite = net.ReadBool(),
            Kick = net.ReadBool(),
            Rank = net.ReadBool(),
            MoTD = net.ReadBool(),
            Banner = net.ReadBool(),
            Withdraw = net.ReadBool(),
            InvWithdraw = net.ReadBool()
        }
    }
end):SetLocalPlayer()