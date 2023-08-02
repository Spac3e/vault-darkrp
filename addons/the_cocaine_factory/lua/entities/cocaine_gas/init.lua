AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
include( "shared.lua" )

function ENT:Initialize()
	self:SetModel( "models/craphead_scripts/the_cocaine_factory/utility/gas_tank.mdl" )
	self:PhysicsInit( SOLID_VPHYSICS )
	self:SetMoveType( MOVETYPE_VPHYSICS )
	self:SetSolid( SOLID_VPHYSICS )
	self:GetPhysicsObject():Wake()
	self:SetHP( TCF.Config.GasHealth )
end

function ENT:OnTakeDamage( dmg )
	self:SetHP( ( self:GetHP() or 100 ) - dmg:GetDamage() )
	if self:GetHP() <= 0 then                  
		if not IsValid( self ) then
			return
		end
		
		if TCF.Config.GasExplosion then
			local vPoint = self:GetPos()
			local effect_explode = ents.Create( "env_explosion" )
			if not IsValid( effect_explode ) then return end
			effect_explode:SetPos( vPoint )
			effect_explode:Spawn()
			effect_explode:SetKeyValue( "iMagnitude","75" )
			effect_explode:Fire( "Explode", 0, 0 )
			
			if TCF.Config.CreateFireOnExplode then
				local Fire = ents.Create( "fire" )
				Fire:SetPos( vPoint )
				Fire:SetAngles( Angle( 0, 0, 0 ) )
				Fire:Spawn()
			end
		end
		
        self:Remove()
    end
end