SWEP.Contact = ""
SWEP.Category = "RP"
SWEP.Spawnable = true
SWEP.AdminSpawnable = true
SWEP.DrawAmmo = false
SWEP.Base = "weapon_base"

SWEP.Primary.ClipSize = -1
SWEP.Primary.DefaultClip = -1
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = "none"

SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = -1
SWEP.Secondary.Automatic = false
SWEP.Secondary.Ammo = "none"

SWEP.ViewModelFOV = 54
SWEP.ViewModel = "models/weapons/v_hands.mdl" --models/weapons/c_handcuffs.mdl
SWEP.WorldModel = "" --models/weapons/w_handcuffs.mdl
--util.PrecacheModel( "models/weapons/c_handcuffs.mdl" )
--util.PrecacheModel( "models/weapons/w_handcuffs.mdl" )


SWEP.ViewModelFlip = false
SWEP.AutoSwitchTo = false
SWEP.AutoSwitchFrom = false

SWEP.UseHands = true
SWEP.HoldType = "slam"
SWEP.FiresUnderwater = true

SWEP.DrawCrosshair = false

function SWEP:Initialize()
	
	self:SetHoldType(self.HoldType)
end


function SWEP:PrimaryAttack()
	if SERVER then return self:SecretPrimaryAttack() end

	if !IsFirstTimePredicted then return end
	if self:GetOwner():GetEyeTraceNoCursor().Entity:IsPlayer() and self:GetOwner():GetEyeTraceNoCursor().Entity:GetNWBool("isHandcuffed") == false  then
		
	end

	-- TODO Let's put client-only stuff in here
end

function SWEP:SecondaryAttack()
	self:SetNextSecondaryFire(CurTime() + 1.5)
	if SERVER then return self:SecretSecondaryAttack() end

	if self:GetOwner():GetEyeTraceNoCursor().Entity:IsPlayer() and self:GetOwner():GetEyeTraceNoCursor().Entity:GetNWBool("isHandcuffed") == false  then
		
	end

	-- TODO Let's put client-only stuff in here
end