AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
include( "shared.lua" )

function ENT:Initialize()
	self:SetModel( "models/craphead_scripts/the_cocaine_factory/utility/cocaine_box.mdl" )
	self:PhysicsInit( SOLID_VPHYSICS )
	self:SetMoveType( MOVETYPE_VPHYSICS )
	self:SetSolid( SOLID_VPHYSICS )
	self:SetUseType( SIMPLE_USE )
	self:SetHP( TCF.Config.CocaineBoxHealth )
	self.BoxCocaineAmount = 0
	self.IsClosed = false
end

function ENT:OnTakeDamage( dmg )
	self:SetHP( ( self:GetHP() or 100 ) - dmg:GetDamage() )
    if self:GetHP() <= 0 then
		self:Remove()
  	end
end

function ENT:Use( ply )	
	if ( self.lastUsed or CurTime() ) <= CurTime() then
		self.lastUsed = CurTime() + 1.5
		
		if table.HasValue( TCF.Config.PoliceTeams, team.GetName( ply:Team() ) ) then
			if self.BoxCocaineAmount > 0 then
				local police_confiscate_reward = self.BoxCocaineAmount * TCF.Config.PoliceConfiscateAmount
			
				rp.Notify(ply, 3, "Вы конфисковали коробку с кокаином. Вам выдали награду!", "")
				ply:AddMoney( police_confiscate_reward )
				self:Remove()
				return
			end
		end

		if not self.IsClosed then
			self:SetBodygroup( 1, 1 )
			self.IsClosed = true
			rp.Notify(ply, 3, "Ваша коробка с порошком готова к продаже, барыга ждёт вас.", "")
		else
			self:SetBodygroup( 1, 0 )
			self.IsClosed = false
			rp.Notify(ply, 3, "Ваша коробка была открыта. Вы можете заново класть туда порошок.", "")
		end
	end
end

function ENT:StartTouch( ent )
	if self.IsClosed then
		return
	end
	
	if ( ent.lastTouch or CurTime() ) > CurTime() then
		return
	end
	ent.lastTouch = CurTime() + 0.5
	
	if ent:GetClass() == "cocaine_pack" then
		if self.BoxCocaineAmount < 4 then 
			self.BoxCocaineAmount = self.BoxCocaineAmount + 1
			
			self:SetBodygroup( 2, self.BoxCocaineAmount )
			ent:Remove()
		end
	end
end