ENT.Type 			= 'anim'
ENT.Base 			= 'base_anim'
ENT.PrintName 		= 'Горшок'
ENT.Author 			= ''
ENT.Spawnable 		= true
ENT.Category 		= 'RP'

function ENT:SetupDataTables()
	self:NetworkVar('Int', 0, 'Stage')
	self:NetworkVar('Entity', 1, 'owning_ent')
end