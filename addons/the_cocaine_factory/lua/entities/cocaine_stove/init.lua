AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
include( "shared.lua" )

function ENT:Initialize()
	self:SetModel( "models/craphead_scripts/the_cocaine_factory/stove/gas_stove.mdl" )
	--self:SetAngles( self:Getowning_ent():GetAngles() - Angle( 76561198375258442 ) )
	self:PhysicsInit( SOLID_VPHYSICS )
	self:SetMoveType( MOVETYPE_VPHYSICS )
	self:SetSolid( SOLID_VPHYSICS )
	self:GetPhysicsObject():Wake()
	self.GasCylinder = 0
	self:SetHP( TCF.Config.StoveHealth )
	self:CoolDown()
	self.PotsOnStove = {}
	
	self.CookerOneActive = false
	self.CookerTwoActive = false
	self.CookerThreeActive = false		
	self.CookerFourActive = false
end

function ENT:OnTakeDamage( dmg )
	local owner = self:CPPIGetOwner()
	self:SetHP( ( self:GetHP() or 100 ) - dmg:GetDamage() )
	if self:GetHP() <= 0 then                  
		if not IsValid( self ) then
			return
		end
		
		if TCF.Config.StoveExplosion then
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
				
				rp.Notify(owner, 3, "Ваша плита взорвалась из за критического урона!", "")
			else
				rp.Notify(owner, 3, "Ваша плита взорвалась из за критического урона!", "")
			end
		end
		
        self:Remove()
    end
end

function ENT:AcceptInput( key, ply )	
	local owner = self:CPPIGetOwner()
	
	if ( self.lastUsed or CurTime() ) <= CurTime() then

		self.lastUsed = CurTime() + TCF.Config.GasButtonDelay
		-- Check if eyetrace hit the stove.
		
		local ei_ = self:EntIndex()
		local tr = self:WorldToLocal( ply:GetEyeTrace().HitPos ) 
		
		if tr:WithinAABox( TCF.Config.StovePos.dpos1, TCF.Config.StovePos.dpos2 ) then
			if not self.CookerOneActive then
				rp.Notify(owner,3,'Мануальная плита не подключена, дабы использовать газовую плиту подключите мануальные!',"")
				return
			end
			
			if self:GetGasAmount() <= 0 then
				rp.Notify(owner, 3, "Вы не подключили газ к плите!", "")
				return
			end
			
			if not ( timer.Exists( "cooktimer_gas_1"..ei_ ) and self:GetPlate1() ) then
				self:SetPlate1( true )
				
				if timer.Exists( "cooktimer_pot_1"..ei_ ) then
					self:SetBodygroup( 3, 2 )
				else
					self:SetBodygroup( 3, 1 )
				end
				
				timer.Create( "cooktimer_gas_1"..ei_, 2, 0, function() 
					if self:GetGasAmount() <= 0 then
						self:SetBodygroup( 3, 0 ) -- Turn off green light
						
						self:SetPlate1( false )
						timer.Remove( "cooktimer_gas_1"..ei_ )
						return 
					end
					
					self:SetCelious1( math.Clamp( self:GetCelious1() + 2, 0, 100 ) )
					self:SetGasAmount( self:GetGasAmount() - 1 )
				end )
			else
				timer.Remove( "cooktimer_gas_1"..ei_ )
				self:SetPlate1( false )
				
				self:SetBodygroup( 3, 0 )
			end	
		elseif tr:WithinAABox( TCF.Config.StovePos.dpos3, TCF.Config.StovePos.dpos4 ) then
			if not self.CookerTwoActive then
				rp.Notify(owner,3,'Мануальная плита не подключена, дабы использовать газовую плиту подключите мануальные!',"")
				return
			end
			
			if self:GetGasAmount() <= 0 then
				rp.Notify(owner, 3, "Вы не подключили газ к плите!", "")
				return
			end
			
			if not ( timer.Exists( "cooktimer_gas_2"..ei_ ) and self:GetPlate2() ) then
				self:SetPlate2( true )
				
				if timer.Exists( "cooktimer_pot_2"..ei_ ) then
					self:SetBodygroup( 4, 2 )
				else
					self:SetBodygroup( 4, 1 )
				end
				
				timer.Create( "cooktimer_gas_2"..ei_, 2, 0, function() 
					if self:GetGasAmount() <= 0 then 
						self:SetBodygroup( 4, 0 ) -- Turn off green light 76561198375258442
						
						self:SetPlate2( false )
						timer.Remove( "cooktimer_gas_2"..ei_ ) 
						return
					end
					
					self:SetCelious2( math.Clamp( self:GetCelious2() + 2, 0, 100 ) )
					self:SetGasAmount( self:GetGasAmount() - 1 )
				end )
			else
				timer.Remove( "cooktimer_gas_2"..ei_ )
				self:SetPlate2( false )
				
				self:SetBodygroup( 4, 0 )
			end
		elseif tr:WithinAABox( TCF.Config.StovePos.dpos5, TCF.Config.StovePos.dpos6 ) then
			if not self.CookerThreeActive then
				rp.Notify(owner,3,'Мануальная плита не подключена, дабы использовать газовую плиту подключите мануальные!',"")
				return
			end
			
			if self:GetGasAmount() <= 0 then
				rp.Notify(owner,3,'Вы не подключили газ к плите!',"")
				return
			end
			
			if not ( timer.Exists( "cooktimer_gas_3"..ei_ ) and self:GetPlate3() ) then
				self:SetPlate3( true )
				
				if timer.Exists( "cooktimer_pot_3"..ei_ ) then
					self:SetBodygroup( 5, 2 )
				else
					self:SetBodygroup( 5, 1 )
				end
				
				timer.Create( "cooktimer_gas_3"..ei_, 2, 0, function()
					if self:GetGasAmount() <= 0 then
						self:SetBodygroup( 5, 0 ) -- Turn off green light
						
						self:SetPlate3( false )
						timer.Remove( "cooktimer_gas_3"..ei_ )
						return
					end
					
					self:SetCelious3( math.Clamp( self:GetCelious3() + 2, 0, 100 ) )
					self:SetGasAmount( self:GetGasAmount() - 1 )			
				end )
			else
				timer.Remove( "cooktimer_gas_3"..ei_ )
				self:SetPlate3( false )
				
				self:SetBodygroup( 5, 0 )
			end	
		elseif tr:WithinAABox( TCF.Config.StovePos.dpos7, TCF.Config.StovePos.dpos8 ) then
			if not self.CookerFourActive then
				rp.Notify(owner,3,'Мануальная плита не подключена, дабы использовать газовую плиту подключите мануальные!',"")
				return
			end
			
			if self:GetGasAmount() <= 0 then
				rp.Notify(owner,3,'Вы не подключили газ к плите!',"")
				return
			end
			
			if not ( timer.Exists( "cooktimer_gas_4"..ei_ ) and self:GetPlate4() ) then
				self:SetPlate4( true )
				
				if timer.Exists( "cooktimer_pot_4"..ei_ ) then
					self:SetBodygroup( 6, 2 )
				else
					self:SetBodygroup( 6, 1 )
				end
				
				timer.Create( "cooktimer_gas_4"..ei_, 2, 0, function() 
					if self:GetGasAmount() <= 0 then
						self:SetBodygroup( 6, 0 ) -- Turn off green light
						
						self:SetPlate4( false )
						timer.Remove( "cooktimer_gas_4"..ei_ )
						return
					end
					
					self:SetCelious4( math.Clamp( self:GetCelious4() + 2, 0, 100 ) )
					self:SetGasAmount( self:GetGasAmount() - 1 )
				end )
			else
				timer.Remove( "cooktimer_gas_4"..ei_ )
				self:SetPlate4( false )
				
				self:SetBodygroup( 6, 0 )
			end					
		end	
	end	
end

function ENT:StartTouch( ent )
	if ent:IsPlayer() then
		return
	end
	
	if ( ent.lastTouch or CurTime() ) > CurTime() then
		return
	end
	ent.lastTouch = CurTime() + 0.5
	
	local ei_ = self:EntIndex()
	local tr = self:WorldToLocal( ent:GetPos() )
	local owner = self:CPPIGetOwner()
	
	if ent:GetClass() == "cocaine_cooking_plate" then
		if not self.CookerOneActive then
			self:SetBodygroup( 7, 1 )
			self.CookerOneActive = true

			rp.Notify(owner,3,'Вы установили плиту | 1/4',"")
            
			sound.Play( "plats/hall_elev_door.wav", self:GetPos() )
			ent:Remove()
		elseif not self.CookerTwoActive then
			self:SetBodygroup( 8, 1 )
			self.CookerTwoActive = true

			rp.Notify(owner,3,'Вы установили плиту | 2/4',"")
            
			sound.Play( "plats/hall_elev_door.wav", self:GetPos() )
			ent:Remove()
		elseif not self.CookerThreeActive then
			self:SetBodygroup( 9, 1 )
			self.CookerThreeActive = true

			rp.Notify(owner,3,'Вы установили плиту | 3/4',"")
      
			sound.Play( "plats/hall_elev_door.wav", self:GetPos() )
			ent:Remove()
		elseif not self.CookerFourActive then
			self:SetBodygroup( 10, 1 )
			self.CookerFourActive = true
            
			sound.Play( "plats/hall_elev_door.wav", self:GetPos() )
			ent:Remove()
		else
			rp.Notify(owner,3,'Вы больше не можете установить плиты | 4/4',"")
		end
	elseif ent:GetClass() == "cocaine_cooking_pot" then
		if ent.ReadyToCook then -- Check to see if we have water and baking soda in the pot.
			for i = 1, 4, 1 do
				if ( self.PotsOnStove[i] == nil ) then
					if i == 1 then
						if not self.CookerOneActive then
							return
						end
						
						self:SetBodygroup( 11, 1 ) -- Thermometer enabled
						
						if timer.Exists( "cooktimer_gas_1"..ei_ ) then
							self:SetBodygroup( 3, 2 ) -- Change flame to surround the pot
						end
					elseif i == 2 then
						if not self.CookerTwoActive then
							return
						end
						
						self:SetBodygroup( 12, 1 ) -- Thermometer enabled
						
						if timer.Exists( "cooktimer_gas_2"..ei_ ) then
							self:SetBodygroup( 4, 2 ) -- Change flame to surround the pot
						end
					elseif i == 3 then
						if not self.CookerThreeActive then
							return
						end
						
						self:SetBodygroup( 13, 1 ) -- Thermometer enabled
						
						if timer.Exists( "cooktimer_gas_3"..ei_ ) then
							self:SetBodygroup( 5, 2 ) -- Change flame to surround the pot
						end
					elseif i == 4 then
						if not self.CookerFourActive then
							return
						end
						
						self:SetBodygroup( 14, 1 ) -- Thermometer enabled
						
						if timer.Exists( "cooktimer_gas_4"..ei_ ) then
							self:SetBodygroup( 6, 2 ) -- Change flame to surround the pot
						end
					end
					
					ent:SetParent( self )
					ent:SetPos( self:WorldToLocal( self:GetAttachment( i ).Pos ) )
					ent:SetAngles( self:GetAttachment( i ).Ang )
					
					timer.Simple( 20, function()
						if IsValid( ent ) then
							ent.PotCanFinish = true
						end
					end )

					timer.Create( "cooktimer_pot_"..i..""..ei_, 5, 0, function()
						if self:GetGasAmount() > 0 then
							if i == 1 then
								if ent.PotCanFinish and self:GetCelious1() >= 100 and ( math.random( 1, 2 ) == 1 ) then
									ent:SetCooked( true )
									ent:SetBodygroup( 1, 4 ) -- Set pot bodygroup to fully cooked
									ent.ReadyToCook = false
									ent.PotCanFinish = false
									
									if timer.Exists( "cooktimer_pot_1"..ei_ ) then
										timer.Remove( "cooktimer_pot_1"..ei_ )
									end
									
									if TCF.Config.FinishCookGiveXP then
										owner:addXP( TCF.Config.FinishCookXPAmount, true )
									end
								end
							elseif i == 2 then
								if ent.PotCanFinish and self:GetCelious2() >= 100 and ( math.random( 1, 2 ) == 1 ) then
									ent:SetCooked( true )
									ent:SetBodygroup( 1, 4 ) -- Set pot bodygroup to fully cooked
									ent.ReadyToCook = false
									ent.PotCanFinish = false
									
									if timer.Exists( "cooktimer_pot_2"..ei_ ) then
										timer.Remove( "cooktimer_pot_2"..ei_ )
									end
									
									if TCF.Config.FinishCookGiveXP then
										owner:addXP( TCF.Config.FinishCookXPAmount, true )
									end
								end
							elseif i == 3 then
								if ent.PotCanFinish and self:GetCelious3() >= 100 and ( math.random( 1, 2 ) == 1 ) then
									ent:SetCooked( true )
									ent:SetBodygroup( 1, 4 ) -- Set pot bodygroup to fully cooked
									ent.ReadyToCook = false
									ent.PotCanFinish = false
									
									if timer.Exists( "cooktimer_pot_3"..ei_ ) then
										timer.Remove( "cooktimer_pot_3"..ei_ )
									end
									
									if TCF.Config.FinishCookGiveXP then
										owner:addXP( TCF.Config.FinishCookXPAmount, true )
									end
								end
							elseif i == 4 then
								if ent.PotCanFinish and self:GetCelious4() >= 100 and ( math.random( 1, 2 ) == 1 ) then
									ent:SetCooked( true )
									ent:SetBodygroup( 1, 4 ) -- Set pot bodygroup to fully cooked
									ent.ReadyToCook = false
									ent.PotCanFinish = false
									
									if timer.Exists( "cooktimer_pot_4"..ei_ ) then
										timer.Remove( "cooktimer_pot_4"..ei_ )
									end
									
									if TCF.Config.FinishCookGiveXP then
										owner:addXP( TCF.Config.FinishCookXPAmount, true )
									end
								end					
							end
						end
					end )

					self.PotsOnStove[i] = ent
					break
				end
			end
		end
	elseif ent:GetClass() == "cocaine_gas"then
		if self.GasCylinder == 0 then
			self:SetGasAmount( self:GetGasAmount() + 100 )
			self.GasCylinder = self.GasCylinder + 1
			
			self:SetBodygroup( 2, 1 )
			self:SetPoseParameter( "arrow", 0.5 )
			
			sound.Play( "physics/metal/metal_canister_impact_hard".. math.random( 1, 3 ) ..".wav", self:GetPos() )
			ent:Remove()
		elseif self.GasCylinder == 1 then
			self:SetGasAmount( self:GetGasAmount() + 100 )
			self.GasCylinder = self.GasCylinder + 1
			
			self:SetBodygroup( 2, 2 )
			self:SetPoseParameter( "arrow", 1 )
			
			sound.Play( "physics/metal/metal_canister_impact_hard".. math.random( 1, 3 ) ..".wav", self:GetPos() )
			ent:Remove()
		end
	end
end

local function TCF_PickupPots( ply, ent )
	if ent:GetClass() == "cocaine_cooking_pot" and IsValid( ent:GetParent() ) then
		local ei_ = ent:GetParent():EntIndex()
		
		if ent:GetCooked() then
			for i = 1, 4, 1 do
				if ent:GetParent().PotsOnStove[i] == ent then
					if i == 1 then
						ent:GetParent():SetBodygroup( 11, 0 )
						
						if timer.Exists( "cooktimer_gas_1"..ei_ ) then
							ent:GetParent():SetBodygroup( 3, 1 ) -- Small flame if gas is on
						end
					elseif i == 2 then
						ent:GetParent():SetBodygroup( 12, 0 )
						
						if timer.Exists( "cooktimer_gas_2"..ei_ ) then
							ent:GetParent():SetBodygroup( 4, 1 ) -- Small flame if gas is on
						end
					elseif i == 3 then
						ent:GetParent():SetBodygroup( 13, 0 )
						
						if timer.Exists( "cooktimer_gas_3"..ei_ ) then
							ent:GetParent():SetBodygroup( 5, 1 ) -- Small flame if gas is on
						end
					elseif i == 4 then
						ent:GetParent():SetBodygroup( 14, 0 )
						
						if timer.Exists( "cooktimer_gas_4"..ei_ ) then
							ent:GetParent():SetBodygroup( 6, 1 ) -- Small flame if gas is on
						end
					end
					
					ent:GetParent().PotsOnStove[i] = nil
					ent:SetParent( nil )
					ent:SetPos( ent:GetPos() + Vector( 0, 0, 1 ) )
					break
				end
			end
			
			return true
		end
	end
end
hook.Add( "GravGunPickupAllowed", "TCF_PickupPots", TCF_PickupPots )
hook.Add( "PhysgunPickup", "TCF_PickupPots", TCF_PickupPots )

function ENT:CoolDown()
	local ei_ = self:EntIndex()
	local owner = self:Getowning_ent()
	
	timer.Create( "cooktimer_cooldown"..ei_, 3, 0, function() 
		-- Using elseif here could result in the plates bugging out as they may need to run at the same time.
		-- 76561198375258442
		
		if (!self:GetPlate1()) and !(self:GetCelious1() <= 0) then
			self:SetCelious1( self:GetCelious1() - 2 )
		end
	
		if (!self:GetPlate2()) and !(self:GetCelious2() <= 0) then
			self:SetCelious2( self:GetCelious2() - 2 )
		end
	
		if (!self:GetPlate3()) and !(self:GetCelious3() <= 0) then
			self:SetCelious3( self:GetCelious3() - 2 )	
		end
	
		if (!self:GetPlate4()) and !(self:GetCelious4() <= 0) then
			self:SetCelious4( self:GetCelious4() - 2 )
		end
		
		-- Since the timer run all the time, its more efficient to do the gas check here than in a ent:think.
		if self:GetGasAmount() > 0 and self:GetGasAmount() <= 100 then
			if self.GasCylinder == 2 then
				self.GasCylinder = self.GasCylinder - 1
				self:SetBodygroup( 2, 1 )
			end
		elseif self:GetGasAmount() <= 0 then -- OUT OF GAS
			if self.GasCylinder == 1 then
				self.GasCylinder = self.GasCylinder - 1
				self:SetBodygroup( 2, 0 )
				rp.Notify(owner, 3, "Ваша плита потратила весь газ, вся варка приостановлена.", "")
			end
		end			
	end )
end

function ENT:OnRemove()
	local ei_ = self:EntIndex()
	
	timer.Remove( "cooktimer_gas_1"..ei_ )
	timer.Remove( "cooktimer_gas_2"..ei_ )
	timer.Remove( "cooktimer_gas_3"..ei_ )
	timer.Remove( "cooktimer_gas_4"..ei_ )
	timer.Remove( "cooktimer_cooldown"..ei_ )
	timer.Remove( "cooktimer_pot_1"..ei_ )	
	timer.Remove( "cooktimer_pot_2"..ei_ )		
	timer.Remove( "cooktimer_pot_3"..ei_ )	
	timer.Remove( "cooktimer_pot_4"..ei_ )	
end