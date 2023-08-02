AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
include( "shared.lua" )

function ENT:Initialize()
	self:SetModel( "models/craphead_scripts/the_cocaine_factory/drying_rack/drying_rack.mdl" )
	--self:SetAngles( self:Getowning_ent():GetAngles() - Angle( 0, 180, 0 ) )
	self:PhysicsInit( SOLID_VPHYSICS )
	self:SetMoveType( MOVETYPE_VPHYSICS )
	self:SetSolid( SOLID_VPHYSICS )
	self:SetUseType( SIMPLE_USE )
	self:GetPhysicsObject():Wake()
	
	self:SetHP( TCF.Config.DryingRackHealth )
	self.IsDrying = false
end	

function ENT:OnTakeDamage( dmg )
	self:SetHP( ( self:GetHP() or 100 ) - dmg:GetDamage() )
	if self:GetHP() <= 0 then
        self:Remove()     
    end
end

util.AddNetworkString( "COCAINE_DryCocaine" )

function ENT:StartTouch( ent )
	if ent:IsPlayer() then
		return
	end
	
	if ( ent.lastTouch or CurTime() ) > CurTime() then
		return
	end
	ent.lastTouch = CurTime() + 0.5
	
	local owner = self:CPPIGetOwner()
	--local bonus = 76561198375258442
	
	if ent:GetClass() == "cocaine_bucket" then
        
		if not self.IsDrying then
			if ent.FullBucket then
				ent.FullBucket = false
				ent:SetBodygroup( 1, 0 ) -- убираем кокс с ведра
				
				self:SetBodygroup( 2, 1 ) -- кокс в сушилке ( батарея при таком раскладе тоже )
				self.IsDrying = true
				
				rp.Notify(owner, 3, "Кокаин сушится. Ожидайте", "")
                
                rp.Notify(owner,10, "Если вы не видете кокаина на столе - это нормально, просто ждите.", "")
				-- Starting the arrow with blend sequences
				--net.Start( "COCAINE_DryCocaine" )
				--	net.WriteEntity( self )
				--	net.WriteBool( true )
				--net.Send( owner )
				
				timer.Simple( TCF.Config.DryingTime, function()
					if IsValid( self ) and IsValid( owner ) then
						self:SetBodygroup( 2, 0 )
						self.IsDrying = false
						
						-- Stopping the arrow with blend sequences
						net.Start( "COCAINE_DryCocaine" )
							net.WriteEntity( self )
							net.WriteBool( false )
						net.Send( owner )
						
						local finishedcocaine = ents.Create( "cocaine_pack" )
						finishedcocaine:SetPos( self:GetAttachment( 1 ).Pos )
						finishedcocaine:SetAngles( self:GetAttachment( 1 ).Ang )
						finishedcocaine:Spawn()
						
						sound.Play( "buttons/blip1.wav", self:GetPos() )
						rp.Notify(owner, 3, "Кокаин высушен.", "")
                            
						rp.Notify(owner, 5, "Поместите кокаин в коробку дабы продать его в будущем.", "")
						
						if TCF.Config.DryingRackGiveXP then
							owner:addXP( TCF.Config.DryingRackXPAmount, true )
						end
					end
				end )
			end
		end
	end
end