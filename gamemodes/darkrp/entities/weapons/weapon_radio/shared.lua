SWEP.PrintName = "Рация"
SWEP.Author = ""
SWEP.Purpose = "При использование на человеке объявляет его в розыск. При использовании на пропе даёт ордер на обыск его владельца."
SWEP.Category = "RP"
SWEP.Spawnable = true
SWEP.AdminSpawnable = true
SWEP.AdminOnly = true
SWEP.ViewModelFOV = 54
SWEP.ViewModel = "models/weapons/custom/rad15.mdl"
SWEP.WorldModel = "models/weapons/custom/w_rad15.mdl"
SWEP.ShowViewModel = true
SWEP.ShowWorldModel = true
SWEP.ViewModelFlip = false
SWEP.AutoSwitchTo = true
SWEP.AutoSwitchFrom = true
SWEP.Slot = 3
SWEP.SlotPos = 1
SWEP.Primary.ClipSize = -1
SWEP.Primary.DefaultClip = 0
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = ''
SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = 0
SWEP.Secondary.Automatic = false
SWEP.Secondary.Ammo = ''
SWEP.UseHands = true
SWEP.HoldType = "Pistol"
SWEP.Base = "weapon_base"

local reason = {"Убийство", "Нелегальное оружие", "Нанесение увечий", "Нелегальные предметы"}

function SWEP:Initialize()
    self:SetWeaponHoldType(self.HoldType)
end

function SWEP:PrimaryAttack()
    if SERVER then return end
    if self:GetNextFire() > CurTime() then return end
    local w = self
    self:SetNextFire(CurTime() + 1)
    local ent = self.Owner:GetEyeTrace().Entity

    if ent:IsPlayer() and not ent:Isnotuser() and not ent:IsRoot() or ent:GetClass() == "prop_physics" or (ent:IsDoor() and ent:DoorGetOwner()) then
        local m = ui.Create('ui_frame', function(self)
            self:SetTitle((ent:IsPlayer() and ent:Nick()) or (ent:IsDoor() and ent:DoorGetOwner():Nick()) or 'Выберите причину')
            self:SetSize(.2, .2)
            self:Center()
            self:MakePopup()

            function self:OnClose()
                --print(1)
                w:SetNextFire(CurTime() + 3)
            end
        end)

        local x, y = m:GetDockPos()

        local scr = ui.Create('ui_scrollpanel', function(self, p)
            self:SetPos(x, y)
            self:SetSize(p:GetWide() - 10, p:GetTall() - y - 5)

            for k, v in pairs(reason) do
                local p = ui.Create('ui_button', function(self, p)
                    self:SetTall(30)
                    self:SetText(v)

                    function self:DoClick()
						if ent:IsPlayer() then
							RunConsoleCommand('say', '/want', ent:SteamID(), reason)
						elseif ent:IsVehicle() and ent:DoorGetOwner() then
							RunConsoleCommand('say', '/want', ent:DoorGetOwner():SteamID(), reason)
						elseif IsValid(ent:CPPIGetOwner()) then
							RunConsoleCommand('say', '/warrant', ent:CPPIGetOwner():SteamID(), reason)
						elseif ent:IsDoor() and ent:DoorGetOwner() then
							RunConsoleCommand('say', '/warrant', ent:DoorGetOwner():SteamID(), reason)
						end
                        m:Close()
                        w:SetNextFire(CurTime() + 3)
                    end
                end)

                self:AddItem(p)
            end
        end, m)

        m:Focus()
    end
end

function SWEP:SecondaryAttack()
    self:PrimaryAttack()
end

if SERVER then
    --resource.AddWorkshop("356099105")
    local sounds = {Sound("npc/combine_soldier/vo/callcontacttarget1.wav"), Sound("npc/combine_soldier/vo/contactconfim.wav"), Sound("npc/combine_soldier/vo/contained.wav"), Sound("npc/combine_soldier/vo/bodypackholding.wav")}

    local f = function(ply, cmd, v, r)
        ply:EmitSound(table.Random(sounds), 100, 100, 1)

        hook.Call('PlayerRunRPCommand', nil, ply, cmd, {v, r}, nil)

        rp.commands[cmd](ply, nil, {v, r})
    end

    util.AddNetworkString("wanted_radio")

    net.Receive('wanted_radio', function(len, ply)
        local ent = net.ReadEntity()
        local reason = reaaassos[net.ReadInt(4)]
        if not (IsValid(ent) or reason) then return end

        if ent:IsPlayer() then
            RunConsoleCommand('say', '/want', ent:SteamID(), reason)
        elseif ent:IsVehicle() and ent:DoorGetOwner() then
            RunConsoleCommand('say', '/want', ent:DoorGetOwner():SteamID(), reason)
        elseif IsValid(ent:CPPIGetOwner()) then
            RunConsoleCommand('say', '/warrant', ent:CPPIGetOwner():SteamID(), reason)
        elseif ent:IsDoor() and ent:DoorGetOwner() then
            RunConsoleCommand('say', '/warrant', ent:DoorGetOwner():SteamID(), reason)
        end
    end)
else
    SWEP.nextFire = 0

    function SWEP:GetNextFire()
        return self.nextFire
    end

    function SWEP:SetNextFire(t)
        self.nextFire = t
    end

    function SWEP:ViewModelDrawn()
        local vm = self.Owner:GetViewModel()
        if not IsValid(vm) then return end
        local bone = vm:LookupBone("radio")
        if not bone then return end
        pos, ang = Vector(0, 0, 0), Angle(0, 0, 0)
        local m = vm:GetBoneMatrix(bone)

        if m then
            pos, ang = m:GetTranslation(), m:GetAngles()
        else
            return
        end

        ang:RotateAroundAxis(ang:Forward(), 90)
        ang:RotateAroundAxis(ang:Right(), 180)
        ang:RotateAroundAxis(ang:Up(), -270)
        cam.Start3D2D(pos + ang:Right() * 3.85 + ang:Forward() * -7.90 + ang:Up() * -0.28, ang, 0.03)
        self:DrawScreen(50, 50, 65, 123)
        cam.End3D2D()
    end

    local dots = 1

    function SWEP:DrawScreen(x, y, w, h)
        local text
        local tr = LocalPlayer():GetEyeTrace().Entity

        if self:GetNextFire() > CurTime() then
            text = '....'
        elseif tr:IsPlayer() or tr:IsVehicle() then
            text = 'РОЗЫСК'
        elseif tr:GetClass() == "prop_physics" or tr:IsDoor() then
            text = 'ОРДЕР'
        else
            local str = "..."

            if dots <= 100 then
                str = "."
            elseif dots <= 200 then
                str = ".."
            elseif dots >= 300 then
                dots = 1
            end

            dots = dots + 1
            text = 'Поиск' .. str
        end

        draw.SimpleText(text, "default", 240, -260, Color(5, 5, 5, 200))
    end
end