ENT.Type 			= 'anim'
ENT.Base 			= 'base_rp'
ENT.PrintName 		= 'Мусорка'
ENT.Spawnable 		= true
ENT.Category 		= 'RP'

function ENT:SetupDataTables()
	self:NetworkVar('Int', 0, 'NextUse')
end