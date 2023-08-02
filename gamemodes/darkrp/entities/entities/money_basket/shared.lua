ENT.Type 		= 'anim'
ENT.Base 		= 'base_rp'
ENT.PrintName 	= 'Корзина для денег'
ENT.Author 		= ''
ENT.Spawnable 	= true
ENT.Category 	= 'RP'
ENT.MaxHealth 	= 100

function ENT:SetupDataTables()
	self:NetworkVar('Entity', 1, 'owning_ent')
	self:NetworkVar('Float', 0, 'money')
end