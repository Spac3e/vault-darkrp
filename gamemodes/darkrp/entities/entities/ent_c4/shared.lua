ENT.Type 		= 'anim'
ENT.PrintName	= 'C4'
ENT.Author		= ''
ENT.Spawnable 	= false

function ENT:Initialize()
	self:EmitSound('C4.Plant')
end