include( "shared.lua" )

function ENT:DrawTranslucent()
	self:DrawModel()
end

local CurNumber = 0
local LastThink = 0
local SwitchSpeed = 300

local GaugeNumber = 0
local GaugeSpeed = ( 100 / TCF.Config.ExtractionTime )

net.Receive( "COCAINE_ExtractorGaugeBucketFill", function( length, ply )
	local extractor = net.ReadEntity()
	cocaine_bucket = net.ReadEntity()
	local gauge_on = net.ReadBool()
	
	extractor.GaugeOn = gauge_on
	if gauge_on then
		GaugeNumber = 0
	else
		GaugeNumber = 100
	end
end )

net.Receive( "COCAINE_ExtractorSwitch", function( length, ply )
	local extractor = net.ReadEntity()
	local switch_value = net.ReadBool()
	
	extractor.SwitchOn = switch_value
	if switch_value then
		CurNumber = 0
	else
		CurNumber = 100
	end
end )

function ENT:Think()
	local now = CurTime()
	local timepassed = now - LastThink
	LastThink = now
	
	if self.SwitchOn then
		CurNumber = math.Approach( CurNumber, 100, SwitchSpeed * timepassed )
		
		self:SetPoseParameter( "switch", CurNumber )
	else
		CurNumber = math.Approach( CurNumber, 0, SwitchSpeed * timepassed )
		
		self:SetPoseParameter( "switch", CurNumber )
	end
	
	-- Leafs Amount
	if self:GetLeafs() >= 0 then
		self:SetPoseParameter( "arrow_1", self:GetLeafs() )
	end
		
	-- Baking Soda Amount
	if self:GetBakingSoda() >= 0 then
		self:SetPoseParameter( "arrow_2", self:GetBakingSoda() )
	end
	
	if IsValid( cocaine_bucket ) then
		if self.GaugeOn then
			GaugeNumber = math.Approach( GaugeNumber, 100, GaugeSpeed * timepassed )
			
			self:SetPoseParameter( "gauge", GaugeNumber )
			cocaine_bucket:SetPoseParameter( "cocaine", GaugeNumber )
		else
			GaugeNumber = math.Approach( GaugeNumber, 0, 20 * timepassed )
			
			self:SetPoseParameter( "gauge", GaugeNumber )
			cocaine_bucket:SetPoseParameter( "cocaine", 100 )
		end
	end
	
	self:InvalidateBoneCache()
end