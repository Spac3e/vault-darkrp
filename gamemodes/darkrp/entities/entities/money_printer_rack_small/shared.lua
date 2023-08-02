ENT.Type 			= 'anim'
ENT.Base 			= 'base_rp'
ENT.PrintName 		= 'Money Printer Rack Small'
ENT.Category 		= 'RP Printing Devices'
ENT.Author 			= 'aStonedPenguin'
ENT.Spawnable 		= true
ENT.PressKeyText	= 'Чтобы вытащить принтер'


function ENT:SetupDataTables()
	self:NetworkVar('Int', 1, 'Printers')
end