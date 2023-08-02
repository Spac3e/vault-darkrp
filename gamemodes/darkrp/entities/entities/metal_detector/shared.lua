ENT.Type 		= 'anim' 
ENT.Base		= 'base_anim' 
ENT.PrintName	= 'Металлодетектор'
ENT.Author		= ''
ENT.Spawnable	= false
ENT.Category 	= 'RP'
ENT.MaxHealth 	= 150

function ENT:SetupDataTables()
	self:NetworkVar('Int', 1, 'Mode')
end