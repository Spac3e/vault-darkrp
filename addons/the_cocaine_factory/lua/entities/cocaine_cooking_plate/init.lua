AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
include( "shared.lua" )

function ENT:Initialize()
	self:SetModel( "models/craphead_scripts/the_cocaine_factory/utility/stove_upgrade.mdl" )
	self:PhysicsInit( SOLID_VPHYSICS )
	self:SetMoveType( MOVETYPE_VPHYSICS )
	self:SetSolid( SOLID_VPHYSICS )
	self:GetPhysicsObject():Wake()
	self:SetHP( TCF.Config.CookingPlateHealth )
	self.HasWater = false
	self.HasCarbonate = false
	self.ReadyToCook = false
end

function ENT:OnTakeDamage( dmg )
	self:SetHP( ( self:GetHP() or 100 ) - dmg:GetDamage() )
    if self:GetHP() <= 0 then
		self:Destruct()
		
		self:Remove()
  	end
end

function ENT:Destruct()
	for i = 1, 3 do
		local vPoint = self:GetPos()
		local effectdata = EffectData()
		effectdata:SetStart( vPoint )
		effectdata:SetOrigin( vPoint )
		effectdata:SetScale( 1 )
		util.Effect( "ManhackSparks", effectdata )
	end
end