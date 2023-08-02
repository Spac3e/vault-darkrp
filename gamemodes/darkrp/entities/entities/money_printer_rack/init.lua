AddCSLuaFile('cl_init.lua')
AddCSLuaFile('shared.lua')
pdash.IncludeSH 'shared.lua'

ENT.SeizeReward = 350
ENT.WantReason = 'Денежный принтер'

function ENT:Initialize()
	self:SetModel('models/sup/printerrack/rack.mdl')
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
	self:SetUseType(SIMPLE_USE)
	self:PhysWake()

	self.RemoveDelay = math.random(900, 1800)

	self.rack = {}
	self.rackStart = 8.15
	self.rackOffset = 19.7

	self.serverCores = 2
	self.cores = 0

	self:SetPrinters(0)

	self:SetHealth(500)
end

function ENT:UpdateConnectedServers()
	self:SetPrinters(self.cores)
end

function ENT:RemoveServer(index)
	if self.rack[index] == NULL then return end
	self.cores = self.cores - self.serverCores
	local pos = self.rack[index]:GetPos()
	pos = pos + self:GetAngles():Forward() * 60
	self.rack[index].beenPlacedIntoRack = false
	self.rack[index]:SetParent()
	self.rack[index]:SetMoveType(MOVETYPE_VPHYSICS)
	self.rack[index]:GetPhysicsObject():EnableGravity(true)
	self.rack[index]:SetPos(pos)
	self.rack[index] = nil
	self:UpdateConnectedServers()
end

function ENT:StartTouch(e)
	if e:GetClass() == "money_printer" then
		if (table.Count(self.rack) == 8) then
			return
		end

		if e.beenPlacedIntoRack then return end
		e.beenPlacedIntoRack = true
		local hasSpace = -1
		for i = 1 , 4 do
			if self.rack[i] == nil then
				hasSpace = i
				break
			end
		end

		if hasSpace ~= -1 then
			local pos = self:GetAngles():Up() * self.rackStart
			pos = pos + self:GetAngles():Up() * (self.rackOffset * (hasSpace - 1))
			pos = pos - self:GetAngles():Forward() * 5
			pos = pos + self:GetAngles():Right() * 3
			e:SetPos(self:GetPos() + pos)
			e:SetAngles(self:GetAngles())
			e:SetMoveType(MOVETYPE_NONE)
			e:SetParent(self)
			self.rack[hasSpace] = e
			self.rack[hasSpace].index = hasSpace
			self.rack[hasSpace].parentServer = self
			self.cores = self.cores + self.serverCores
			self:UpdateConnectedServers()
		end
	end
end

function ENT:HasServer()
	local hasServer = false
	self:SetNetVar("PrinterInRack", false)
	for i = 1 , 8 do
		if self.rack[i] ~= nil then
			hasServer = true
			self:SetNetVar("PrinterInRack", true)
			break
		end
	end 
	return hasServer
end

function ENT:Use(pl)
	if self:HasServer() then
		self:RemoveServer(table.Count(self.rack))
	end
end

function ENT:OnTakeDamage(damageData)
	self:SetHealth(self:Health() - damageData:GetDamage())

	if (self:Health() <= 0) then
		if self:HasServer() then
			for i=1,table.Count(self.rack) do
				self:RemoveServer(i)
			end
		end
		self:Explode()
	end
end

function ENT:Explode()
	local vPoint = self:GetPos()
	local effectdata = EffectData()
	effectdata:SetStart(vPoint)
	effectdata:SetOrigin(vPoint)
	effectdata:SetScale(1)
	util.Effect('Explosion', effectdata)

	self:Remove()
end

function ENT:OnRemove()
	if self:HasServer() then
		for i=1,table.Count(self.rack) do
			self:RemoveServer(i)
		end
	end
end