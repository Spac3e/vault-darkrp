-- Global vars
nw.Register'Skills':Write(function(v)
    net.WriteUInt(table.Count(v), 4)

    for k, v in pairs(v) do
        net.WriteUInt(k, 4)
        net.WriteUInt(v, 4)
    end
end):Read(function()
    local tbl = {}

    for i = 1, net.ReadUInt(4) do
        tbl[net.ReadUInt(4)] = net.ReadUInt(4)
    end

    return tbl
end):SetLocalPlayer()

nw.Register 'TheLaws'
	:Write(net.WriteString)
	:Read(net.ReadString)
	:SetGlobal()

nw.Register 'lockdown'
	:Write(net.WriteBool)
	:Read(net.ReadBool)
	:SetGlobal()

nw.Register 'lockdown_reason'
	:Write(net.WriteString)
	:Read(net.ReadString)
	:SetGlobal()

nw.Register 'mayorGrace'
	:Write(net.WriteUInt, 32)
	:Read(net.ReadUInt, 32)
	:SetGlobal()

nw.Register'JeromePrice'
	:Write(net.WriteFloat)
	:Read(net.ReadFloat)
	:SetGlobal()
	:SetHook('nw.JeromePrice')

nw.Register'SashaPrice'
	:Write(net.WriteFloat)
	:Read(net.ReadFloat)
	:SetGlobal()
	:SetHook('nw.SashaPrice')

-- Player Vars
nw.Register 'HasGunlicense'
	:Write(net.WriteBool)
	:Read(net.ReadBool)
	:SetPlayer()

nw.Register 'org_banner'
	:Write(net.WriteBool)
	:Read(net.ReadBool)
	:SetPlayer()

nw.Register 'Name'
	:Write(net.WriteString)
	:Read(net.ReadString)
	:SetPlayer()

nw.Register 'Money'
	:Write(net.WriteUInt, 32)
	:Read(net.ReadUInt, 32)
	:SetLocalPlayer()

nw.Register 'Karma'
	:Write(net.WriteInt, 32)
	:Read(net.ReadInt, 32)
	:SetLocalPlayer()

nw.Register 'Energy'
	:Write(net.WriteUInt, 32)
	:Read(net.ReadUInt, 32)
	:SetLocalPlayer()

nw.Register 'job'
	:Write(net.WriteString)
	:Read(net.ReadString)
	:SetPlayer()

nw.Register'Hat'
	:Write(net.WriteUInt, 6)
	:Read(net.ReadUInt, 6)
	:SetPlayer()

nw.Register'HatData':Write(function(v)
    net.WriteUInt(#v, 6)

    for k, v in ipairs(v) do
        net.WriteString(v)
    end
end):Read(function()
    local tbl = {}

    for i = 1, net.ReadUInt(6) do
        tbl[i] = net.ReadString()
    end

    return tbl
end):SetLocalPlayer()

nw.Register'HatData':Write(function(v)
    net.WriteUInt(#v, 6)

    for k, v in ipairs(v) do
        net.WriteString(v)
    end
end):Read(function()
    local tbl = {}

    for i = 1, net.ReadUInt(6) do
        tbl[i] = net.ReadString()
    end

    return tbl
end):SetLocalPlayer()

nw.Register'ActiveApparel':Write(function(v)
    for i = 1, 4 do
        local isSet = (v[i] ~= nil)
        net.WriteBool(isSet)

        if isSet then
            net.WriteString(v[i])
        end
    end
end):Read(function()
    local tbl = {}

    for i = 1, 4 do
        if net.ReadBool() then
            tbl[i] = net.ReadString()
        end
    end

    return tbl
end):SetPlayer()

nw.Register'OwnedApparel':Write(function(v)
    net.WriteUInt(table.Count(v), 6)

    for k, v in pairs(v) do
        net.WriteString(k)
    end
end):Read(function()
    local tbl = {}

    for i = 1, net.ReadUInt(6) do
        tbl[net.ReadString()] = true
    end

    return tbl
end):SetLocalPlayer()

nw.Register 'HasRespawned'
	:Write(net.WriteBool)
	:Read(net.ReadBool)
	:SetLocalPlayer()

nw.Register 'ShareProps'
	:Write(net.WriteTable)
	:Read(net.ReadTable)
	:SetLocalPlayer()

nw.Register 'EmployeePrice'
	:Write(net.WriteUInt, 32)
	:Read(net.ReadUInt, 32)
	:SetPlayer()

nw.Register'Employee'
	:Write(net.WritePlayer)
	:Read(net.ReadPlayer)
	:SetLocalPlayer()
	
nw.Register'Employer'
	:Write(net.WritePlayer)
	:Read(net.ReadPlayer)
	:SetPlayer()

nw.Register 'PropIsOwned'
	:Write(net.WriteBool)
	:Read(net.ReadBool)
	:Filter(function(self)
		return self:CPPIGetOwner()
	end)
	:SetNoSync()

nw.Register 'IsWanted'
	:Write(net.WriteBool)
	:Read(net.ReadBool)
	:SetPlayer()

nw.Register 'WantedReason'
	:Write(net.WriteString)
	:Read(net.ReadString)
	:SetLocalPlayer()

nw.Register 'ArrestedInfo'
	:Write(function(v)
		net.WriteUInt(v.Release, 32)
	end)
	:Read(function()
		return {
			Release = net.ReadUInt(32)
		}
	end)
	:SetLocalPlayer()

nw.Register 'Credits'
	:Write(net.WriteUInt, 32)
	:Read(net.ReadUInt, 32)
	:SetLocalPlayer()

nw.Register 'Upgrades'
	:Write(function(v)
		net.WriteUInt(#v, 8)
		for k, upgid in ipairs(v) do
			net.WriteUInt(upgid, 8)
		end
	end)
	:Read(function()
		local ret = {}
		for i = 1, net.ReadUInt(8) do
			local obj = rp.shop.Get(net.ReadUInt(8))
			ret[obj:GetUID()] = true
		end
		return ret
	end)
	:SetLocalPlayer()

nw.Register 'DoorID'
	:Write(net.WriteUInt, 32)
	:Read(net.ReadUInt, 32)

nw.Register 'DoorLocked'
	:Write(net.WriteBool)
	:Read(net.ReadBool)

nw.Register 'PrinterInRack'
	:Write(net.WriteBool)
	:Read(net.ReadBool)
	:SetPlayer()

nw.Register 'ActiveApparel'
	:Write(function(v)
		for i = 1, 4 do
			local isSet = (v[i] ~= nil)
			net.WriteBool(isSet)
			if isSet then
				net.WriteString(v[i])
			end
		end
	end)
	:Read(function()
		local tbl = {}
		for i = 1, 4 do
			if net.ReadBool() then
				tbl[i] = net.ReadString()
			end
		end
		return tbl
	end)
	:SetPlayer()

nw.Register 'IsDisguise'
    :Write(net.WriteBool)
    :Read(net.ReadBool)
    :SetPlayer()

nw.Register 'DisguiseJob'
    :Write(net.WriteUInt, 32)
    :Read(net.ReadUInt, 32)
    :SetPlayer()

nw.Register 'DisguiseTime'
    :Write(net.WriteUInt, 32)
    :Read(net.ReadUInt, 32)
    :SetPlayer()

nw.Register 'DisguiseColor'
    :Write(net.WriteUInt, 32)
    :Read(net.ReadUInt, 32)
    :SetPlayer()

nw.Register 'CarriedItem'
	:Write(net.WriteEntity)
	:Read(net.ReadEntity)
	:SetLocalPlayer()
	:SetHook('NetPlayerDropItem')

nw.Register'AbilitiesCooldown'
	:Write(function(data)
		net.WriteUInt(table.Count(data), 6)
		for k, v in pairs(data) do
			net.WriteInt(k, 6)
			net.WriteInt(v, 32)
		end
	end)
	:Read(function()
		local tbl = {}
		local count = net.ReadUInt(6)
		for i = 1, count do
			local k , v = net.ReadInt(6), net.ReadInt(32)
			tbl[k] = v
		end
		return tbl
	end)
	:SetLocalPlayer()
	:SetHook('AbilitiesCooldownReceived')