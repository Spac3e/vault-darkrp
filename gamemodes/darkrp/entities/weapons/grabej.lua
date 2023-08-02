-- Seconds to pass until Pickpocketing is done (default: 10)
local PPConfig_Duration = 7
-- Minimum money that can be stolen from the player (default: 400)
local PPConfig_MoneyFrom = 1500
-- Maximumum money that can be stolen from the player (default: 700)
local PPConfig_MoneyTo = 35000
-- Seconds to wait until next Pickpocketing (default: 60)
local PPConfig_Wait = 30
-- Distance able to be stolen from (default: 100)
local PPConfig_Distance = 100
-- Should stealing emit a silent sound (true or false) (default: true)
local PPConfig_Sound = false
-- Hold down to keep Pickpocketing (true or false) (default: false)
local PPConfig_Hold = false

if SERVER then
    util.AddNetworkString("pickpocket_time")
else
    SWEP.PrintName = "Воровство"
    SWEP.Slot = 3
    SWEP.SlotPos = 4
    SWEP.DrawAmmo = false
    SWEP.DrawCrosshair = true
end

SWEP.Base = "weapon_base"
SWEP.Author = "Spak"
SWEP.Instructions = "Left-click for Pickpocketing"
SWEP.IconLetter = ""
SWEP.ViewModelFOV = 62
SWEP.ViewModelFlip = false
SWEP.ViewModel = Model("models/weapons/c_crowbar.mdl")
SWEP.WorldModel = Model("models/weapons/w_crowbar.mdl")
SWEP.UseHands = true
SWEP.Spawnable = true
SWEP.AdminOnly = true
SWEP.Category = "RP"
SWEP.Primary.ClipSize = -1
SWEP.Primary.DefaultClip = 0
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = ""
SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = -1
SWEP.Secondary.Automatic = false
SWEP.Secondary.Ammo = ""

function SWEP:Initialize()
    self:SetWeaponHoldType("normal")
end

if CLIENT then
    net.Receive("pickpocket_time", function()
        local wep = net.ReadEntity()
        wep.IsPickpocketing = true
        wep.StartPick = CurTime()
        wep.EndPick = CurTime() + PPConfig_Duration
    end)
end

function SWEP:CheckValid()
    local trace = self:GetOwner():GetEyeTrace()
    local e = trace.Entity

    if not IsValid(e) or not e:IsPlayer() or trace.HitPos:DistToSqr(self:GetOwner():GetShootPos()) > (65 * 65) then
        self:GetOwner():PrintMessage(HUD_PRINTTALK, 'хуй тебе')

        return false
    end
end

function SWEP:Protect()
    if SERVER then
        local check = false
        local check2 = false
        local trace = self:GetOwner():GetEyeTrace()
        local pos1 = Vector(-128, -2383, 64)
        local pos2 = Vector(642, -3007, 307)
        local apos1 = Vector(-448, 2688, 59)
        local apos2 = Vector(-1742, 447, 782)

        if trace.Entity:GetPos():WithinAABox(pos1, pos2) then
            check = true
        end

        if trace.Entity:GetPos():WithinAABox(apos1, apos2) then
            check2 = true
        end

        if check then
            self:GetOwner():ChatPrint("Вы не можете воровать на спавне")

            return false
        end

        if check2 then
            self:GetOwner():ChatPrint("Не воруй в зоне админов балбес")

            return false
        end

        return true
    end
end

function SWEP:PrimaryAttack()
    if self.IsPickpocketing then return end
    local trace = self.Owner:GetEyeTrace()
    local e = trace.Entity
    if self:CheckValid() == false or self:Protect() == false then return end

    if SERVER then
        if CurTime() >= self.Owner:GetNWInt("VorEblan", CurTime()) then
            self.IsPickpocketing = true
            self.StartPick = CurTime()
            net.Start("pickpocket_time")
            net.WriteEntity(self)
            net.Send(self.Owner)
            self.EndPick = CurTime() + PPConfig_Duration
            self.Owner:SetNWInt("VorEblan", CurTime() + 30)
        else
            self.Owner:ChatPrint("Вы не можете воровать ещё " .. math.Round(self.Owner:GetNWInt("VorEblan", CurTime()) - CurTime()) .. " сек.")
        end
    end

    self:SetWeaponHoldType("pistol")

    if SERVER then
        if PPConfig_Sound then
            self.Owner:EmitSound(Sound("pickpocket/pick.wav"))
        end

        timer.Create("PickpocketSounds", 1, PPConfig_Duration, function()
            if not self:IsValid() then return end

            if PPConfig_Sound then
                self.Owner:EmitSound(Sound("pickpocket/pick.wav"))
            end
        end)
    end

    if CLIENT then
        self.Dots = self.Dots or ""

        timer.Create("PickpocketDots", 0.5, 0, function()
            if not self:IsValid() then
                timer.Destroy("PickpocketDots")

                return
            end

            local len = string.len(self.Dots)

            local dots = {
                [0] = ".",
                [1] = "..",
                [2] = "...",
                [3] = ""
            }

            self.Dots = dots[len]
        end)
    end
end

function SWEP:Holster()
    self.IsPickpocketing = false

    if SERVER then
        timer.Destroy("PickpocketSounds")
    end

    if CLIENT then
        timer.Destroy("PickpocketDots")
    end

    return true
end

function SWEP:OnRemove()
    self:Holster()
end

function SWEP:Succeed()
    self.IsPickpocketing = false
    self:SetWeaponHoldType("normal")
    local trace = self.Owner:GetEyeTrace()

    if SERVER then
        timer.Destroy("PickpocketSounds")
    end

    if CLIENT then
        timer.Destroy("PickpocketDots")
    end

    local money = math.random(PPConfig_MoneyFrom, PPConfig_MoneyTo)

    if trace.Entity:GetMoney() < money then
        money = trace.Entity:GetMoney()
    end

    if SERVER then
        self.Owner:AddMoney(money)
        trace.Entity:AddMoney(-money)
        local Timestamp = os.time()
        local TimeString = os.date("%H:%M:%S - %d/%m/%Y", Timestamp)
    --    file.Append("moneyChecker.txt", "[" .. TimeString .. "] " .. self.Owner:SteamID() .. " Pick " .. money .. "\n")
    end

    if SERVER then
        if money > 1500 then
            self.Owner:ChatPrint("Вы украли " .. money .. "$ из кошелька")
            local ent = self.Owner:GetEyeTrace().Entity
            self.Owner:Wanted(nil, 'Воровство')
            rp.achievements.AddProgress(self.Owner, ACHIEVEMENT_PAYCHECK_ROBBER, 1)
        else
            self.Owner:ChatPrint("У него нет денег! Дай ему на хлеб хотя бы")
        end
    end
end

function SWEP:Fail()
    self.IsPickpocketing = false
    self:SetWeaponHoldType("normal")

    if SERVER then
        timer.Destroy("PickpocketSounds")
    end

    if CLIENT then
        timer.Destroy("PickpocketDots")
    end

    if CLIENT then
        chat.AddText(Color(251, 69, 73), "Не удалось украсть деньгу!")
    end
end

function SWEP:Think()
    local ended = false

    if self.IsPickpocketing and self.EndPick then
        local trace = self.Owner:GetEyeTrace()

        if not IsValid(trace.Entity) and not ended then
            ended = true
            self:Fail()
        end

        if trace.HitPos:Distance(self.Owner:GetShootPos()) > PPConfig_Distance and not ended then
            ended = true
            self:Fail()
        end

        if PPConfig_Hold and not self.Owner:KeyDown(IN_ATTACK) and not ended then
            ended = true
            self:Fail()
        end

        if self.EndPick <= CurTime() and not ended then
            ended = true
            self:Succeed()
        end
    end
end

function SWEP:DrawHUD()
    if self.IsPickpocketing then
        self.Dots = self.Dots or ""
        local x, y = (ScrW() / 2) - 150, (ScrH() / 2) - 25
        local w, h = 300, 50
        local time = self.EndPick - self.StartPick
        local status = (CurTime() - self.StartPick) / time
        rp.ui.DrawProgress(x, y, w, h, status)
        draw.SimpleTextOutlined("Шмонаем жепку" .. self.Dots, "ui.26", ScrW() / 2, ScrH() / 2, ui.col.White, 1, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, Color(69, 14, 14, 155))
    end
end

function SWEP:SecondaryAttack()
end