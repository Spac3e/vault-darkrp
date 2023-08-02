rp.doors 			= rp.doors or {}
rp.doors.Map 		= {}
rp.doors.EntMap		= {}
rp.doors.NetworkMap = {}

local function writeDoorData(data)
	net.WriteUInt(data.Owner:EntIndex(), 8)
	net.WriteString(data.Title)

	net.WriteUInt(#data.CoOwners, 8)
	for k, v in ipairs(data.CoOwners) do
		net.WriteUInt(v:EntIndex(), 8)
	end
end

local function readDoorData()
	local data = {
		OwnerID		= net.ReadUInt(8),
		Title		= net.ReadString(),
		CoOwners	= {},
		CoOwnersIDs	= {},
	}

	for i = 1, net.ReadUInt(8) do
		data.CoOwnersIDs[i] = net.ReadUInt(8)
	end

	return data
end

local function setupDoors()
	if (not rp.cfg.Doors) then
		print 'No doors set!'
		return
	end

	for id, data in ipairs(rp.cfg.Doors) do
		if (not data.Name) then
			data.Name = 'Property #' .. id
		end

		data.NetworkID = 'DoorData.' .. id
		data.DoorCount = #data.MapIDs
		data.SellPrice = math.floor(rp.cfg.DoorCostMin * data.DoorCount)

		nw.Register(data.NetworkID)
			:Write(writeDoorData)
			:Read(readDoorData)
			:SetGlobal()

		if data.Teams and (#data.Teams > 0) then
			data.Color = team.GetColor(data.Teams[1])
		end

		if (SERVER) then
			if data.Teams then
				data.AllowedTeams = {}

				for k, v in ipairs(data.Teams) do
					data.AllowedTeams[v] = true
				end
			end

			rp.doors.EntMap[data.NetworkID] = {}
		end

		rp.doors.NetworkMap[data.NetworkID] = data

		for k, v in ipairs(data.MapIDs) do
			rp.doors.Map[v] = data

			if (SERVER) then
				local ent = ents.GetMapCreatedEntity(v)
				rp.doors.EntMap[data.NetworkID][#rp.doors.EntMap[data.NetworkID] + 1] = ent

				ent:DoorLock(data.Locked == true)

				ent:SetNetVar('DoorID', v)
			end
		end
	end

	rp.doors.HasSetup = true
end
hook.Add('InitPostEntity', 'rp.doors.Setup', setupDoors)
if rp.doors.HasSetup then setupDoors() end

-- individual
local doorClasses = {
	['func_door'] = true,
	['func_door_rotating'] = true,
	['prop_door_rotating'] = true,
	--['prop_dynamic'] = true,
}

function ENTITY:IsDoor()
	return (doorClasses[self:GetClass()] == true)
end

function ENTITY:GetDoorID()
	return SERVER and self:MapCreationID() or self:GetNetVar('DoorID')
end

function ENTITY:IsDoorLocked()
	return (self:GetNetVar('DoorLocked') == true)
end

-- static
function rp.doors.GetPropertyInfo(networkId)
	return rp.doors.NetworkMap[networkId]
end

function ENTITY:GetPropertyInfo()
	return rp.doors.Map[self:GetDoorID()]
end

function ENTITY:IsPropertyOwnable()
	return (self:GetPropertyInfo() ~= nil) and (not IsValid(self:GetPropertyOwner())) and (not self:IsPropertyTeamOwned()) and (not self:IsPropertyHotelOwned())
end

function ENTITY:IsPropertyOwned()
	return (self:GetPropertyInfo() ~= nil) and IsValid(self:GetPropertyOwner())
end

function ENTITY:IsPropertyTeamOwned()
	return (self:GetPropertyInfo() ~= nil) and (self:GetPropertyInfo().Teams ~= nil)
end

function ENTITY:IsPropertyHotelOwned()
	return (self:GetPropertyInfo() ~= nil) and (self:GetPropertyInfo().Hotel == true)
end

function ENTITY:GetPropertyName()
	local data = self:GetPropertyData()
	return (data and data.Title and (data.Title ~= '')) and data.Title or self:GetPropertyInfo().Name
end

function ENTITY:GetPropertyPrice(pl)

	--Ищем сигнатуры дверей и записываем в локальную ячейку
	local coast = 1
	for k, v in pairs(rp.cfg.Doors) do 
		if table.HasValue(v.MapIDs,self:GetDoorID()) then 
			coast = coast * #v.MapIDs
		end
	end
	return pl:Wealth(rp.cfg.DoorCostMin, rp.cfg.DoorCostMax) * self:GetPropertyInfo().DoorCount * coast
end

function ENTITY:GetPropertySellPrice()
	return self:GetPropertyInfo().SellPrice
end
function ENTITY:GetPropertyColor()
	return self:GetPropertyInfo().Color
end

function ENTITY:GetPropertyNetworkID()
	local data = self:GetPropertyInfo()
	return data and data.NetworkID
end

-- networked
function rp.doors.GetPropertyData(networkId)
	return nw.GetGlobal(networkId)
end

function ENTITY:GetPropertyData()
	local networkId = self:GetPropertyNetworkID()
	return networkId and nw.GetGlobal(networkId)
end

if (SERVER) then
	function ENTITY:GetPropertyOwner()
		local data = self:GetPropertyData()
		return data and data.Owner
	end

	function ENTITY:GetPropertyCoOwners()
		local data = self:GetPropertyData()
		return data and data.CoOwners
	end
else
	function ENTITY:GetPropertyOwner()
		local data = self:GetPropertyData()

		if (not data) then return end

		if IsValid(data.Owner) then
			return data.Owner
		end

		if data.OwnerID then
			data.Owner = Entity(data.OwnerID)
		end

		return data.Owner
	end

	function ENTITY:GetPropertyCoOwners()
		local data = self:GetPropertyData()

		if (not data) then return end

		if data.HasAddedCoOwners then
			return data.CoOwners
		end

		if data.CoOwnersIDs then
			data.CoOwners = {}

			for k, v in ipairs(data.CoOwnersIDs) do
				local co = Entity(v)
				if IsValid(co) then
					data.CoOwners[#data.CoOwners + 1] = co
				end
			end

			data.HasAddedCoOwners = true
			data.CoOwnersIDs = nil
		end

		return data.CoOwners
	end
end

function ENTITY:IsPropertyCoOwner(pl)
	local coOwners = self:GetPropertyCoOwners()

	if (not coOwners) then return false end

	for k, v in ipairs(coOwners) do
		if (v == pl) then
			return true
		end
	end
end

function ENTITY:DoorIsOwnable()
	return (self:GetNetVar('DoorData') == nil) and (self:GetNetVar('DoorData') ~= false)
end
function ENTITY:DoorOwnedBy(pl)
	return (istable(self:GetNetVar('DoorData')) and (self:GetNetVar('DoorData').Owner == pl) or false)
end

function ENTITY:DoorOrgOwned()
	return (istable(self:GetNetVar('DoorData')) and self:GetNetVar('DoorData').OrgOwn or false)
end

function ENTITY:DoorCoOwnedBy(pl)
	if (self:DoorGetGroup() ~= nil) then
		return (rp.teamDoors[self:DoorGetGroup()].Teams[pl:Team()] or false)
	end

	if IsValid(self:DoorGetOwner()) and self:DoorGetOwner():GetOrg() and self:DoorOrgOwned() and (pl:GetOrg() == self:DoorGetOwner():GetOrg()) then
		return true
	end

	return (istable(self:GetNetVar('DoorData')) and table.HasValue(self:GetNetVar('DoorData').CoOwners or {}, pl) or false)
end

function ENTITY:DoorGetTitle()
	return (istable(self:GetNetVar('DoorData')) and (self:GetNetVar('DoorData').Title) or nil)
end

function ENTITY:DoorGetOwner()
	return (istable(self:GetNetVar('DoorData')) and (self:GetNetVar('DoorData').Owner) or nil)
end

function ENTITY:DoorGetCoOwners()
	return (istable(self:GetNetVar('DoorData')) and (self:GetNetVar('DoorData').CoOwners) or nil)
end

function ENTITY:DoorGetTeam()
	return (istable(self:GetNetVar('DoorData')) and (self:GetNetVar('DoorData').Team) or nil)
end

function ENTITY:DoorGetGroup()
	return (istable(self:GetNetVar('DoorData')) and (self:GetNetVar('DoorData').Group) or nil)
end

nw.Register('DoorData')