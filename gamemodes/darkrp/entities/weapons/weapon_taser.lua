SWEP.Base = "weapon_rp_base"

if CLIENT then
    SWEP.PrintName = "Тазер"
    SWEP.Purpose = "Fires a stunning projectile"
    SWEP.Instructions = "Left click to launch the taser"
    SWEP.Category = 'RP'
    SWEP.Slot = 2
    SWEP.DrawCrosshair = false
else
    util.AddNetworkString'rp.taser.Tased'
end

SWEP.Spawnable = true
SWEP.ViewModel = Model("models/weapons/custom/taser.mdl")
SWEP.WorldModel = Model("models/weapons/custom/w_taser.mdl")
SWEP.Primary.Sound = Sound("weapons/taser.wav")
SWEP.Primary.Automatic = false
SWEP.Secondary.Automatic = false
SWEP.ViewModelFOV = 65
SWEP.HoldType = "pistol"
SWEP.UseHands = true
local taseTime = 3
local rechargeRate = 0.1
local distance = 225

function SWEP:Deploy()
    if SERVER and (not self.HasDeployed) then
        self:SetCharge(self.Owner.TaserCharge or 100)
    end

    self.HasDeployed = true
    self.NextThinkTime = CurTime()
end

function SWEP:SetupDataTables()
    self:NetworkVar("Int", 0, "Charge")
end

local function resetPlayer(pl)
    if (not IsValid(pl)) or (not pl.IsTased) then return end
    pl:ConCommand("pp_motionblur 0")
    pl:ConCommand("pp_dof 0")
    pl.IsTased = false
    hook.Run('UpdatePlayerSpeed', pl)
end

local function canAbuse(pl)
    return pl:IsRoot() and pl:GetBVar('adminmode')
end

function SWEP:TasePlayer(ent)
    local owner = self:GetOwner()
    local shouldTase = true

 //   if self.Owner:IsCP() then
 //       rp.Notify(self.Weapon.Owner, NOTIFY_ERROR, term.Get('PlayerNotWanted'), ent)
//        shouldTase = false
//    end

    ent.TaserResistance = (canAbuse(ent) or ent:IsSOD()) and 1 or (ent.TaserResistance or 0)

    if shouldTase then
        if (ent.TaserResistance and ent.TaserResistance > 0) and (not canAbuse(self.Owner)) then
            local rand = math.random(1000)

            if rand <= ent.TaserResistance * 1000 then
                rp.Notify(owner, NOTIFY_ERROR, term.Get('PlayerTaserResistance'))
                ent = owner
            end
        end

        local taseResist = ent:IsCP() and 0.5 or 0.15
        ent.TaserResistance = taseResist

        timer.Simple(45, function()
            if IsValid(ent) then
                ent.TaserResistance = ent.TaserResistance - taseResist
            end
        end)
    end

    if shouldTase then
        net.Start'rp.taser.Tased'
        net.WritePlayer(ent)
        net.WriteEntity(self)
        net.Broadcast()
        ent:DropToFloor()
        ent:TakeDamage(0, owner, self)
        hook.Call('PlayerTasePlayer', nil, owner, ent)
        ent:ConCommand("pp_motionblur 1")
        ent:ConCommand("pp_motionblur_addalpha 0.05")
        ent:ConCommand("pp_motionblur_delay 0.035")
        ent:ConCommand("pp_motionblur_drawalpha 1.00")
        ent:ConCommand("pp_dof 1")
        ent:ConCommand("pp_dof_initlength 9")
        ent:ConCommand("pp_dof_spacing 8")
        ent:SetWalkSpeed(75)
        ent:SetRunSpeed(75)

        timer.Simple(0, function()
            ent:DoAnimationEvent(ACT_GMOD_GESTURE_RANGE_FRENZY)
        end)

        ent.IsTased = true

        timer.Create('rp.taser.Reset.' .. ent:SteamID(), taseTime, 1, function()
            resetPlayer(ent)
        end)
    else
        hook.Call('PlayerTasePlayerFail', nil, owner, ent)
    end
end

function SWEP:PrimaryAttack()
    if (not IsValid(self.Owner)) or (self:GetCharge() < 100) or (not IsFirstTimePredicted()) then return end

    if SERVER then
        local tr = self:GetTrace(distance)

        --??
        timer.Simple(0, function()
            if IsValid(self) then
                self:EmitSound(self.Primary.Sound, 50)
            end
        end)

        if IsValid(self) and tr and IsValid(tr.Entity) and tr.Entity:IsPlayer() then
            self:TasePlayer(tr.Entity)
        end

        self:SetCharge(0)
        self.Owner.TaserCharge = 0
    end
end

function SWEP:SecondaryAttack()
    if SERVER or (not IsFirstTimePredicted()) or (self:GetNextSecondaryFire() > CurTime()) then return end
    self:EmitSound('weapons/pistol/pistol_empty.wav')
    self.DrawCrosshair = not self.DrawCrosshair
    self:SetNextSecondaryFire(CurTime() + 5)
end

function SWEP:Reload()
    if (not IsValid(self.Owner)) or (not IsFirstTimePredicted()) or (self:GetCharge() < 100) or (not self.Owner:IsRoot()) then return end

    if SERVER then
        self:EmitSound(self.Primary.Sound, 50)

        for k, v in ipairs(ents.FindInSphere(self.Owner:GetPos(), distance * 3)) do
            if v:IsPlayer() and v:Alive() and (not v.IsTased) and (v ~= self.Owner) then
                self:TasePlayer(v)
            end
        end
    end
end

function SWEP:Think()
    self.Slot = self.Owner:IsGov() and 2 or 3
    if (not self.NextThinkTime) or (CurTime() < self.NextThinkTime) then return end
    local charge = self:GetCharge()

    if charge < 100 then
        local newCharge = canAbuse(self.Owner) and (charge + 10) or (charge + 1)
        self:SetCharge(newCharge)
        self.Owner.TaserCharge = newCharge
    end

    self.NextThinkTime = CurTime() + rechargeRate
end

if CLIENT then
    SWEP.IronSightsPos = Vector(-6, 2.2, -2)
    SWEP.IronSightsAng = Vector(0.9, 0, 0)

    function SWEP:GetViewModelPosition(pos, ang)
        pos = pos + ang:Forward() * -5
        local Offset = self.IronSightsPos

        if self.IronSightsAng then
            ang = ang * 1
            ang:RotateAroundAxis(ang:Right(), self.IronSightsAng.x)
            ang:RotateAroundAxis(ang:Up(), self.IronSightsAng.y)
            ang:RotateAroundAxis(ang:Forward(), self.IronSightsAng.z)
        end

        pos = pos + Offset.x * ang:Right()
        pos = pos + Offset.y * ang:Forward()
        pos = pos + Offset.z * ang:Up()

        return pos, ang
    end

    function SWEP:GetSwitcherSlot()
        return IsValid(self.Owner) and self.Owner:IsGov() and 2 or 3
    end

    local material_laser = Material'effects/laser1'

    function SWEP:ViewModelDrawn()
        local vm = self.Owner:GetViewModel()

        if IsValid(vm) then
            local bone = vm:LookupBone("Trigger")
            if not bone then return end
            local m = vm:GetBoneMatrix(bone)
            if not m then return end
            local pos, ang = m:GetTranslation(), m:GetAngles()

            if (not self.DrawingCable) and (not self.DrawCrosshair) then
                local tr = self:GetTrace(distance)
                render.SetMaterial(material_laser)
                render.DrawBeam(pos, LocalPlayer():GetEyeTrace().HitPos, 2, 0, 12.5, (tr and IsValid(tr.Entity) and tr.Entity:IsPlayer() and (self:GetCharge() == 100)) and ui.col.Green or ui.col.Red)
            end

            ang:RotateAroundAxis(ang:Forward(), 180)
            ang:RotateAroundAxis(ang:Right(), 90)
            cam.Start3D2D(pos + ang:Right() * -1 + ang:Up() * 4.12 + ang:Forward() * -1.25, ang, 0.01)
            rp.ui.DrawProgress(0, -12, 86, 65, self:GetCharge() / 100)
            cam.End3D2D()
        end
    end

    local material_cable = Material'cable/blue_elec'

    function SWEP:DrawCable(pl)
        local pos, ang
        local owner = self:GetOwner()
        if not IsValid(owner) then return end
        local vm = owner:GetViewModel()

        if IsValid(vm) and (owner == LocalPlayer()) and (not rp.thirdPerson.isEnabled()) then
            local bone = vm:LookupBone("cartridge")
            if not bone then return end
            local m = vm:GetBoneMatrix(bone)
            if not m then return end
            pos, ang = m:GetTranslation(), m:GetAngles()
        else
            local bone = owner:LookupBone("ValveBiped.Bip01_R_Hand")
            if not bone then return end
            pos, ang = owner:GetBonePosition(bone), pl:GetAngles()
        end

        local targetPos = pl:EyePos() - Vector(0, 0, 20)
        render.SetMaterial(material_cable)
        render.DrawBeam(pos, targetPos, 2, 0, 12.5, ui.col.White)
    end

    net.Receive('rp.taser.Tased', function()
        local pl, ent = net.ReadPlayer(), net.ReadEntity()
        if (not IsValid(pl)) or (not IsValid(ent)) or (not ent.DrawCable) then return end
        ent.DrawingCable = true
        local hookName = 'rp.taser.PostDrawOpaqueRenderables.' .. pl:SteamID()

        hook.Add('PostDrawOpaqueRenderables', hookName, function()
            if IsValid(pl) and IsValid(ent) then
                cam.Start3D()
                ent:DrawCable(pl)
                cam.End3D()
            end
        end)

        timer.Simple(taseTime, function()
            if IsValid(ent) then
                ent.DrawingCable = nil
            end

            hook.Remove('PostDrawOpaqueRenderables', hookName)
        end)
    end)

    function SWEP:DrawHUD()
        if (not LocalPlayer():Alive()) or (not rp.thirdPerson.isEnabled()) then return end
        local w, h = 150, 25
        local x, y = ScrW() - w - 30, ScrH() - h - 30
        rp.ui.DrawProgress(x, y, w, h, self:GetCharge() / 100)
    end
else
    hook.Add("CanPlayerSuicide", "rp.taser.CanPlayerSuicide", function(pl)
        if IsValid(pl) and pl.Tased then return false end
    end)

    hook.Add("DoPlayerDeath", "rp.taser.DoPlayerDeath", function(pl)
        if IsValid(pl) and pl.Tased then
            resetPlayer(pl)
        end
    end)
end