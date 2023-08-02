ENT.Type 		= 'anim'
ENT.Base 		= 'base_rp'
ENT.PrintName 	= 'Microwave'
ENT.Author 		= ''
ENT.Spawnable 	= false

ENT.MinPrice = 10
ENT.MaxPrice = 150

function ENT:SetupDataTables()
	self:NetworkVar('Int',0,'price')
	self:NetworkVar('Entity',1,'owning_ent')
end