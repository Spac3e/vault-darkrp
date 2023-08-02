AddCSLuaFile()
SWEP.Base = "weapon_base"

if SERVER then
else
    SWEP.PrintName = "RP Weapon Base"
    SWEP.DrawAmmo = false
    SWEP.DrawCrosshair = false
    SWEP.ViewModelFOV = 68
    SWEP.Category = "RP"
    SWEP.Author = "code_gs"
end

SWEP.HoldType = "normal"
SWEP.ViewModel = ""
SWEP.WorldModel = ""
SWEP.AdminOnly = true
SWEP.UseHands = true

SWEP.Primary = {
    ClipSize = -1,
    DefaultClip = -1,
    Automatic = true,
    Ammo = "none",
    Delay = 0.5,
    Sound = Sound('ambient/voices/cough1.wav')
}

SWEP.Secondary = {
    ClipSize = -1,
    DefaultClip = -1,
    Automatic = true,
    Ammo = "none",
    Delay = 0.5,
    Sound = Sound('ambient/voices/cough2.wav')
}

SWEP._Reload = {
    Delay = 2,
    Sound = Sound('npc/combine_soldier/vo/administer.wav')
}

SWEP.HitDistance = 100

SWEP.Melee = {
    DotRange = 0.70721,
    HullRadius = 1.732,
    TestHull = Vector(16, 16, 16),
    Mask = MASK_SHOT_HULL
}

function SWEP:SetupDataTables()
    self:NetworkVar("Float", 0, "NextReload")
end

function SWEP:Initialize()
    self:SetHoldType(self.HoldType)
end

function SWEP:PrimaryAttack()
    self:SetNextPrimaryFire(CurTime() + self.Primary.Delay)
end

function SWEP:SecondaryAttack()
    self:SetNextSecondaryFire(CurTime() + self.Secondary.Delay)
end

function SWEP:Reload()
    self:SetNextReload(CurTime() + self._Reload.Delay)
end

function SWEP:CanReload()
    return CurTime() > self:GetNextReload()
end

function SWEP:Holster()
    return true
end

function SWEP:GetTrace(a)
    local b = self.Melee
    local c = self:GetOwner()
    c:LagCompensation(true)
    local d = c:EyePos()
    local e = c:GetAimVector()
    local f = d + e * (a or 60)

    local g = {
        start = d,
        endpos = f,
        mask = self.Melee.Mask,
        filter = c
    }

    local h = util.TraceLine(g)
    local i = h.Fraction == 1

    if i then
        g.endpos = f - e * b.HullRadius
        g.mins = -b.TestHull
        g.maxs = b.TestHull
        g.output = h
        util.TraceHull(g)
        i = h.Fraction == 1 or h.Entity == NULL

        if not i then
            local j = h.Entity:GetPos() - d
            j:Normalize()

            if j:Dot(e) < b.DotRange then
                h.Fraction = 1
                h.Entity = NULL
                i = true
            else
                util.FindHullIntersection(g, h)
                i = h.Fraction == 1 or h.Entity == NULL
            end
        end
    else
        i = h.Entity == NULL
    end

    c:LagCompensation(false)

    return h
end