ENT.Type 		= 'anim'
ENT.Base 		= 'gambling_machine_base'
ENT.PrintName 	= 'Roulette'
ENT.Spawnable 	= true
ENT.Category 	= 'RP Machines'
ENT.PressE 		= true

ENT.MenuBased = true

function ENT:SetupDataTables()
	self.BaseClass.SetupDataTables(self)

	self:NetworkVar('Int', 1, 'Roll')
	self:NetworkVar('Int', 2, 'Bet')
end

function ENT:WritePlayerUse(pl)
	net.WriteBool(pl == self:CPPIGetOwner())
end

function ENT:ReadPlayerUse()
	return net.ReadBool()
end