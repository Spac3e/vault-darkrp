AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
include( "shared.lua" )

function ENT:Initialize()
	self:SetModel( "models/craphead_scripts/the_cocaine_factory/extractor/extractor.mdl" )
	--self:SetAngles( self:Getowning_ent():GetAngles() - Angle( 0, 180, 0 ) )
	self:PhysicsInit( SOLID_VPHYSICS )
	self:SetMoveType( MOVETYPE_VPHYSICS )
	self:SetSolid( SOLID_VPHYSICS )
	self:SetHP( TCF.Config.ExtractorHealth )
	self.SteamSound = CreateSound( self, TCF.Config.ExtractorSound )
	
	self:SetBodygroup( 3, 1 )
	self:SetBodygroup( 4, 1 )
	self:SetBodygroup( 8, 1 )
	self.IsExtracting = false
	self.ReadyToExtract = false
	self.BucketAttached = false
end

function ENT:OnTakeDamage( dmg )
	local owner = self:CPPIGetOwner()
	self:SetHP( ( self:GetHP() or 100 ) - dmg:GetDamage() )
	if self:GetHP() <= 0 then                  
		if not IsValid( self ) then
			return
		end
		
		if TCF.Config.ExtractorExplosion then
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
				
				rp.Notify(owner, 5, "Ваш экстрактор взорвался из за критического урона", "")
			else
				rp.Notify(owner, 5, "Ваш экстрактор взорвался из за критического урона", "")
			end
		end
		
        self:Remove()
    end
end

util.AddNetworkString( "COCAINE_ExtractorSwitch" )
util.AddNetworkString( "COCAINE_ExtractorGaugeBucketFill" )

function ENT:AcceptInput( key, ply )
	local owner = self:CPPIGetOwner()
	
	if ( self.lastUsed or CurTime() ) <= CurTime() then

		self.lastUsed = CurTime() + 1

		local tr = self:WorldToLocal( ply:GetEyeTrace().HitPos ) 
		
		if tr:WithinAABox( TCF.Config.ExtractorPos.posone, TCF.Config.ExtractorPos.postwo ) then
			
			if self.IsExtracting then
				rp.Notify(owner, 5, "Экстрактор уже создаёт кокс!", "")
				return
			end
			
			if not self.BucketAttached then
				rp.Notify(owner, 5, "Ведро не подключено к экстрактору.", "")
				return
			end
			
			if not self.ReadyToExtract then
				rp.Notify(owner, 5, "В экстракторе недостаточно микстуры или листов коки!", "")
				return
			end
			
			self.SteamSound:Play()
			
			self.IsExtracting = true
			self:SetBodygroup( 5, 1 )
			self:SetBodygroup( 6, 1 )
			
			self:ResetSequence( "on" )
			self:SetSkin( 1 )
			
			self.BucketEntity:SetBodygroup( 1, 1 )
			
			-- Turning on the switch with blend sequences
			net.Start( "COCAINE_ExtractorSwitch" )
				net.WriteEntity( self )
				net.WriteBool( true )
			net.Send( owner )
			
			-- Updating gauge and bucket parameters with blend sequences
			net.Start( "COCAINE_ExtractorGaugeBucketFill" )
				net.WriteEntity( self )
				net.WriteEntity( self.BucketEntity )
				net.WriteBool( true )
			net.Send( owner )

			timer.Simple( TCF.Config.ExtractionTime, function()
				if IsValid( self ) and IsValid( owner ) then
					rp.Notify(owner, 5, "Кокаин был успешно выведен. Ведро готово снова!", "")
					self.IsExtracting = false
					self.BucketAttached = false
					self.ReadyToExtract = false
					
					self.SteamSound:Stop()
					
					self:SetBodygroup( 3, 1 )
					self:SetBodygroup( 4, 1 )
					self:SetBodygroup( 5, 0 )
					self:SetBodygroup( 6, 0 )
					
					self:ResetSequence( "off" )
					self:SetSkin( 0 )
					
					-- Bucket lights on the right
					self:SetBodygroup( 7, 1 )
					self:SetBodygroup( 8, 0 )
					
					timer.Simple( 5, function()
						if IsValid( self ) then
							self:SetBodygroup( 7, 0 ) -- Turn off the green light after a little while has passed.
							self:SetBodygroup( 8, 1 )
						end
					end )
					
					self:SetLeafs( 0 )
					self:SetBakingSoda( 0 )
					
					net.Start( "COCAINE_ExtractorSwitch" )
						net.WriteEntity( self )
						net.WriteBool( false )
					net.Send( owner )
					
					net.Start( "COCAINE_ExtractorGaugeBucketFill" )
						net.WriteEntity( self )
						net.WriteEntity( self.BucketEntity )
						net.WriteBool( false )
					net.Send( owner )
					
					if IsValid( self.BucketEntity ) then
						self.BucketEntity:SetParent( nil )
						self.BucketEntity.FullBucket = true
						self.BucketEntity:SetPos( self.BucketEntity:GetPos() + Vector( 0, 0, 1 ) )
						
						self.BucketEntity = nil
					end
					
					if TCF.Config.ExtractorGiveXP then
						owner:addXP( TCF.Config.ExtractorXPAmount, true )
					end
				end
			end)
		end
	end	
end

function ENT:Think()
    self:NextThink( CurTime() + 0.1 )
	return true
end

function ENT:StartTouch( ent )
	if ent:IsPlayer() then
		return
	end
	
	if ( ent.lastTouch or CurTime() ) > CurTime() then
		return
	end
	ent.lastTouch = CurTime() + 0.5
	
	local owner = self:CPPIGetOwner()
	local bonus = owner.GetDonatorBonus()
	
	if ent:GetClass() == "cocaine_leaves" then
		if self:GetLeafs() < 100 then
			local randomamt = math.Round( math.random( TCF.Config.MinLeafAmount, TCF.Config.MaxLeafAmount ) * bonus )
			local newamount = self:GetLeafs() + randomamt
		
			self:SetLeafs( math.Clamp( newamount, 0, 100 ) )
			
			timer.Simple( 0.5, function()
				if self:GetLeafs() == 100 then
					self:SetBodygroup( 3, 0 )
				end
				if self:GetLeafs() == 100 and self:GetBakingSoda() == 100 then
					self.ReadyToExtract = true
				end
			end )
			
			ent:Remove()
		end
	elseif ent:GetClass() == "cocaine_cooking_pot" then
		if ent:GetCooked() then
			if self:GetBakingSoda() < 100 then
				local randomamt = math.Round( math.random( TCF.Config.MinCarbonateAmount, TCF.Config.MaxCarbonateAmount ) * bonus )
				local newamount = self:GetBakingSoda() + randomamt
				
				self:SetBakingSoda( math.Clamp( newamount, 0, 100 ) )
				
				ent:SetCooked( false )
				ent.HasWater = false
				ent.HasCarbonate = false
				ent:SetBodygroup( 1, 0 )
				
				timer.Simple( 0.5, function()
					if self:GetBakingSoda() == 100 then
						self:SetBodygroup( 4, 0 )
					end
					if self:GetLeafs() == 100 and self:GetBakingSoda() == 100 then
						self.ReadyToExtract = true
					end
				end )
			end
		end
	elseif ent:GetClass() == "cocaine_bucket" then
		if not self.BucketAttached then
			if not ent.FullBucket then
				self.BucketAttached = true
				self.BucketEntity = ent
				
				-- Bucket lights on the right 76561198375258442
				self:SetBodygroup( 8, 0 )
				
				rp.Notify(owner, 5, "Ведро заполнено массой, наполни экстрактор микстурой или листьями коки чтобы ещё раз наполнить ведро", "")
				ent:SetParent( self )
				ent:SetPos( self:WorldToLocal( self:GetAttachment( 1 ).Pos ) )
				ent:SetAngles( self:GetAttachment( 1 ).Ang )
			end
		end
	end
end

function ENT:OnRemove()
	if self.SteamSound then 
		self.SteamSound:Stop() 
	end
	if IsValid( self.BucketEntity ) then
		timer.Remove( "COCAINE_ExtractorUpdateCocaine" )
		self.BucketEntity:Remove()
	end
end 