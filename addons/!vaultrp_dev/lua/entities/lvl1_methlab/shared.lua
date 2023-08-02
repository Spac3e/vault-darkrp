ENT.Type 		= 'anim'
ENT.Base 		= 'base_anim'
ENT.PrintName 	= 'Мет лаборатория 1 уровня'
ENT.Spawnable 	= true
ENT.Category 	= 'RP'

function ENT:SetupDataTables()
	self:NetworkVar('Int', 0, 'price')
	self:NetworkVar('Entity', 0, 'owning_ent')
end