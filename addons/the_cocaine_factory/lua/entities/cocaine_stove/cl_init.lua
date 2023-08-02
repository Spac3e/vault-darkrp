include( "shared.lua" )

function ENT:Initialize()
	if TCF.Config.StoveSmokeEffect then
		self.emitTime = CurTime()
		
		self.potpos1 = ParticleEmitter( self:GetPos() )
		self.potpos2 = ParticleEmitter( self:GetPos() )
		self.potpos3 = ParticleEmitter( self:GetPos() )
		self.potpos4 = ParticleEmitter( self:GetPos() )
	end
end

function ENT:DrawTranslucent()
    self:DrawModel()
end

function ENT:Think()
	if TCF.Config.StoveSmokeEffect then
		if self:GetGasAmount() > 0 then
			if self.emitTime < CurTime() then
				if self:GetPlate1() then
					if self:GetBodygroup( 11 ) == 1 then
						if self:GetCelious1() >= TCF.Config.MinTemperatureForSmoke then
							local smoke = self.potpos1:Add( "particle/smokesprites_000"..math.random( 1, 9 ), self:GetAttachment( 1 ).Pos )
							smoke:SetVelocity( Vector( 0, 0, 125 ) )
							smoke:SetDieTime( math.Rand( 1, 1 ) )
							smoke:SetStartAlpha( 5 )
							smoke:SetEndAlpha( 0 )
							smoke:SetStartSize( math.random( 5, 10 ) )
							smoke:SetEndSize( math.random( 20, 30 ) )
							smoke:SetRoll( math.Rand( 180, 480 ) )
							smoke:SetRollDelta( math.Rand( -3, 3 ) ) 
							smoke:SetColor( 255, 255, 255, 5 ) -- smoke:SetColor( math.random( 50, 100 ), math.random( 50, 100 ), math.random( 50, 100 ), 255 )
							smoke:SetGravity( Vector( 0, 0, 10 ) )
							smoke:SetAirResistance( 256 )
							
							self.emitTime = CurTime() + 0.1
						end
					end
				end
				if self:GetPlate2() then
					if self:GetBodygroup( 12 ) == 1 then
						if self:GetCelious2() >= TCF.Config.MinTemperatureForSmoke then
							local smoke = self.potpos1:Add( "particle/smokesprites_000"..math.random( 1, 9 ), self:GetAttachment( 2 ).Pos )
							smoke:SetVelocity( Vector( 0, 0, 125 ) )
							smoke:SetDieTime( math.Rand( 1, 1 ) )
							smoke:SetStartAlpha( 5 )
							smoke:SetEndAlpha( 0 )
							smoke:SetStartSize( math.random( 5, 10 ) )
							smoke:SetEndSize( math.random( 20, 30 ) )
							smoke:SetRoll( math.Rand( 180, 480 ) )
							smoke:SetRollDelta( math.Rand( -3, 3 ) ) 
							smoke:SetColor( 255, 255, 255, 5 ) -- smoke:SetColor( math.random( 50, 100 ), math.random( 50, 100 ), math.random( 50, 100 ), 255 )
							smoke:SetGravity( Vector( 0, 0, 10 ) )
							smoke:SetAirResistance( 256 )
							
							self.emitTime = CurTime() + 0.1
						end
					end
				end
				if self:GetPlate3() then
					if self:GetBodygroup( 13 ) == 1 then
						if self:GetCelious3() >= TCF.Config.MinTemperatureForSmoke then
							local smoke = self.potpos1:Add( "particle/smokesprites_000"..math.random( 1, 9 ), self:GetAttachment( 3 ).Pos )
							smoke:SetVelocity( Vector( 0, 0, 125 ) )
							smoke:SetDieTime( math.Rand( 1, 2 ) )
							smoke:SetStartAlpha( 5 )
							smoke:SetEndAlpha( 0 )
							smoke:SetStartSize( math.random( 5, 10 ) )
							smoke:SetEndSize( math.random( 20, 30 ) )
							smoke:SetRoll( math.Rand( 180, 480 ) )
							smoke:SetRollDelta( math.Rand( -3, 3 ) ) 
							smoke:SetColor( 255, 255, 255, 5 ) -- smoke:SetColor( math.random( 50, 100 ), math.random( 50, 100 ), math.random( 50, 100 ), 255 )
							smoke:SetGravity( Vector( 0, 0, 10 ) )
							smoke:SetAirResistance( 256 )
							
							self.emitTime = CurTime() + 0.1
						end
					end
				end
				if self:GetPlate4() then
					if self:GetBodygroup( 14 ) == 1 then
						if self:GetCelious4() >= TCF.Config.MinTemperatureForSmoke then
							local smoke = self.potpos1:Add( "particle/smokesprites_000"..math.random( 1, 9 ), self:GetAttachment( 4 ).Pos )
							smoke:SetVelocity( Vector( 0, 0, 175 ) )
							smoke:SetDieTime( math.Rand( 1, 2 ) )
							smoke:SetStartAlpha( 5 )
							smoke:SetEndAlpha( 0 )
							smoke:SetStartSize( math.random( 5, 10 ) )
							smoke:SetEndSize( math.random( 20, 30 ) )
							smoke:SetRoll( math.Rand( 180, 480 ) )
							smoke:SetRollDelta( math.Rand( -3, 3 ) ) 
							smoke:SetColor( 255, 255, 255, 5 ) -- smoke:SetColor( math.random( 50, 100 ), math.random( 50, 100 ), math.random( 50, 100 ), 255 )
							smoke:SetGravity( Vector( 0, 0, 10 ) )
							smoke:SetAirResistance( 256 )
							
							self.emitTime = CurTime() + 0.1
						end
					end
				end
			end
		end
	end
	-- Plate Temperature 
	if self:GetCelious1() >= 0 then
		self:SetPoseParameter( "thermometer_1", self:GetCelious1() )
	end
	
	if self:GetCelious2() >= 0 then
		self:SetPoseParameter( "thermometer_2", self:GetCelious2() )
	end
	
	if self:GetCelious3() >= 0 then
		self:SetPoseParameter( "thermometer_3", self:GetCelious3() )
	end
	
	if self:GetCelious4() >= 0 then
		self:SetPoseParameter( "thermometer_4", self:GetCelious4() )
	end
	
	-- Gas Amount
	if self:GetGasAmount() >= 0 then
		self:SetPoseParameter( "arrow", self:GetGasAmount() )
	end
	
	if self:GetPlate1() then
		self:SetPoseParameter( "button_1", 100 )
	elseif not self:GetPlate1() then
		self:SetPoseParameter( "button_1", 0 )
	end
		
	if self:GetPlate2() then
		self:SetPoseParameter( "button_2", 100 )
	elseif not self:GetPlate2() then
		self:SetPoseParameter( "button_2", 0 )
	end
		
	if self:GetPlate3() then
		self:SetPoseParameter( "button_3", 100 )
	elseif not self:GetPlate3() then
		self:SetPoseParameter( "button_3", 0 )
	end
		
	if self:GetPlate4() then
		self:SetPoseParameter( "button_4", 100 )
	elseif not self:GetPlate4() then
		self:SetPoseParameter( "button_4", 0 )
	end
	
	self:InvalidateBoneCache()
end