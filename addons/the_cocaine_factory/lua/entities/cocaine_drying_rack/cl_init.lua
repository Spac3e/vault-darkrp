include( "shared.lua" )

net.Receive( "COCAINE_DryerLoadingBar", function( length, ply )
	cocaine_dryer = net.ReadEntity()
	
	cocaine_dryer.LoadingBar = CurTime() + 10
end )

function ENT:Draw()	
	self:DrawModel()
end

local DryValue = 0
local LastThink = 0
local DrySpeed = ( 106 / TCF.Config.DryingTime ) -- 106 is 1 second

net.Receive( "COCAINE_DryCocaine", function( length, ply )
	local drying_rack = net.ReadEntity()
	local dry_value = net.ReadBool()
	
	drying_rack.DryingCocaine = dry_value
	if dry_value then
		DryValue = 0
	else
		DryValue = 100
	end
end )

function ENT:Think()
	local now = CurTime()
	local timepassed = now - LastThink
	LastThink = now
	
	if self.DryingCocaine then
		DryValue = math.Approach( DryValue, 100, DrySpeed * timepassed )
		
		self:SetPoseParameter( "arrow", DryValue )
	else
		DryValue = math.Approach( DryValue, 0, DrySpeed * timepassed )
		
		self:SetPoseParameter( "arrow", DryValue )
	end
	
	self:InvalidateBoneCache()
end