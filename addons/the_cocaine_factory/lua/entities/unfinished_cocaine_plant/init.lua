AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

function ENT:Initialize()
	self:SetModel("models/oldbill/ahtreepot.mdl")
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
	self:GetPhysicsObject():Wake()
end

function ENT:Use( ply )
	if ( ( self.lastUsed or CurTime() ) <= CurTime() ) then
		self.lastUsed = CurTime() + 0.25
		if ( self:Getdist_harvest() ) then
			self.plant:Remove()
			self:Setdist_harvest(false)
			if ( self:Getdist_crop() == 1 ) then
				local leaf = ents.Create( "simple_drugs_leaf" )
				if ( !IsValid( leaf ) ) then return end 
				leaf:SetPos( self:GetPos() + self:GetUp() * 12 )
				leaf:Spawn()
				self:Setdist_crop(0)				
			end
		end
	end
end

function ENT:StartTouch( ent )
	if (ent:GetClass() == "simple_drugs_seed") then
		if !IsValid( self.plant ) then
			self.plant = ents.Create( "prop_dynamic" )
			if ( !IsValid( self.plant ) ) then return end
			self.plant:SetModel( "models/oldbill/cocatree1.mdl" )
			self.plant:PhysicsInit( SOLID_VPHYSICS )
			self.plant:SetParent( self )
			self.plant:SetPos( Vector(0, 0, 6) )
			self.plant:SetAngles( self:GetAngles() )
			self.plant:SetModelScale(self.plant:GetModelScale() * 0.20, 0)
			self.plant:Spawn()
			self:GrowTimer(17)
			self:Setdist_crop(1)
			ent:Remove()
		end
	end
end

function ENT:GrowTimer(second)
	self.timeran = 0
	timer.Create( "growtimer"..self:EntIndex(), 6, 0, function()
		if self.timeran == second then
			self:Setdist_harvest(true)
			timer.Remove( "growtimer"..self:EntIndex() )
			return
		end
		self.timeran = ((self.timeran || 0) + 1)
		self.plant:SetModelScale( self.plant:GetModelScale() * 1.10, 1 )
	end)
end

function ENT:OnRemove()
	timer.Remove( "growtimer"..self:EntIndex() )
end