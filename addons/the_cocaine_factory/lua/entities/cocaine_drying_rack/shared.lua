ENT.Type = "anim"
ENT.Base = "base_gmodentity"
ENT.PrintName = "Drying Rack"
ENT.Author = "Crap-Head"
ENT.Spawnable = true
ENT.AdminSpawnable = true
ENT.Category = "The Cocaine Factory"

function ENT:SetupDataTables()
	self:NetworkVar( "Int", 0, "HP" )	
	
	self:NetworkVar( "Entity", 0, "owning_ent" ) -- darkrp owner support
end