AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
include( "shared.lua" )

function ENT:Initialize()
	self:SetModel( "models/craphead_scripts/the_cocaine_factory/utility/pot.mdl" )
	self:PhysicsInit( SOLID_VPHYSICS )
	self:SetMoveType( MOVETYPE_VPHYSICS )
	self:SetSolid( SOLID_VPHYSICS )
	self:GetPhysicsObject():Wake()
	self:SetHP( TCF.Config.CookingPanHealth )
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

function ENT:StartTouch( ent )
	if ent:IsPlayer() then 
		return 
	end
	if self:GetCooked() then 
		return 
	end
	
	if ( ent.lastTouch or CurTime() ) > CurTime() then
		return
	end
	ent.lastTouch = CurTime() + 0.5
	
	if ent:GetClass() == "cocaine_baking_soda" then
		if self:GetCooking() then
			return 
		end
		
		if not self.HasCarbonate and not self.HasWater then
			ent:Remove()
			
			self.HasCarbonate = true
			self:SetBodygroup( 1, 2 )
		elseif not self.HasCarbonate and self.HasWater then
			ent:Remove()
			
			self.HasCarbonate = true
			self.ReadyToCook = true
			self:SetBodygroup( 1, 3 )
		end
	elseif ent:GetClass() == "cocaine_water" then
		if self:GetCooking() then
			return 
		end
		
		if not self.HasCarbonate and not self.HasWater then
			ent:Remove()
			
			self.HasWater = true
			self:SetBodygroup( 1, 1 )
		elseif not self.HasWater and self.HasCarbonate then
			ent:Remove()
			
			self.HasWater = true
			self.ReadyToCook = true
			self:SetBodygroup( 1, 3 )
		end
	end
end