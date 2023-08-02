local a = {}
AccessorFunc(a, "m_fAnimSpeed", "AnimSpeed")
AccessorFunc(a, "Entity", "Entity")
AccessorFunc(a, "vCamPos", "CamPos")
AccessorFunc(a, "fFOV", "FOV")
AccessorFunc(a, "vLookatPos", "LookAt")
AccessorFunc(a, "aLookAngle", "LookAng")
AccessorFunc(a, "colAmbientLight", "AmbientLight")
AccessorFunc(a, "colColor", "Color")
AccessorFunc(a, "bAnimated", "Animated")

function a:Init()
    self.Entity = nil
    self.LastPaint = 0
    self.DirectionalLight = {}
    self.FarZ = 4096
    self:SetCamPos(Vector(50, 50, 50))
    self:SetLookAt(Vector(0, 0, 40))
    self:SetFOV(70)
    self:SetText("")
    self:SetAnimSpeed(0.5)
    self:SetAnimated(false)
    self:SetAmbientLight(Color(50, 50, 50))
    self:SetDirectionalLight(BOX_TOP, Color(255, 255, 255))
    self:SetDirectionalLight(BOX_FRONT, Color(255, 255, 255))
    self:SetColor(color_white)
end

function a:SetDirectionalLight(b, c)
    self.DirectionalLight[b] = c
end

function a:SetModel(d)
    if IsValid(self.Entity) then
        self.Entity:Remove()
        self.Entity = nil
    end

    if not ClientsideModel then return end
    self.Entity = ClientsideModel(d, RENDERGROUP_OTHER)
    if not IsValid(self.Entity) then return end
    self.Entity:SetNoDraw(true)
    self.Entity:SetIK(false)
    local e = self.Entity:LookupSequence("walk_all")

    if e <= 0 then
        e = self.Entity:LookupSequence("WalkUnarmed_all")
    end

    if e <= 0 then
        e = self.Entity:LookupSequence("walk_all_moderate")
    end

    if e > 0 then
        self.Entity:ResetSequence(e)
    end
end

function a:GetModel()
    if not IsValid(self.Entity) then return end

    return self.Entity:GetModel()
end

function a:DrawModel()
    local f = self
    local g, h = self:LocalToScreen(0, 0)
    local i, j = self:LocalToScreen(self:GetWide(), self:GetTall())

    while f:GetParent() ~= nil do
        f = f:GetParent()
        local k, l = f:LocalToScreen(0, 0)
        local m, n = f:LocalToScreen(f:GetWide(), f:GetTall())
        g = math.max(g, k)
        h = math.max(h, l)
        i = math.min(i, m)
        j = math.min(j, n)
        previous = f
    end

    render.SetScissorRect(g, h, i, j, true)
    local o = self:PreDrawModel(self.Entity)

    if o ~= false then
        self.Entity:DrawModel()
        self:PostDrawModel(self.Entity)
    end

    render.SetScissorRect(0, 0, 0, 0, false)
end

function a:PreDrawModel(p)
    return true
end

function a:PostDrawModel(p)
end

function a:Paint(q, r)
    if not IsValid(self.Entity) then return end
    local s, t = self:LocalToScreen(0, 0)
    self:LayoutEntity(self.Entity)
    local u = self.aLookAngle

    if not u then
        u = (self.vLookatPos - self.vCamPos):Angle()
    end

    cam.Start3D(self.vCamPos, u, self.fFOV, s, t, q, r, 5, self.FarZ)
    render.SuppressEngineLighting(true)
    render.SetLightingOrigin(self.Entity:GetPos())
    render.ResetModelLighting(self.colAmbientLight.r / 255, self.colAmbientLight.g / 255, self.colAmbientLight.b / 255)
    render.SetColorModulation(self.colColor.r / 255, self.colColor.g / 255, self.colColor.b / 255)
    render.SetBlend(self:GetAlpha() / 255 * self.colColor.a / 255)

    for v = 0, 6 do
        local w = self.DirectionalLight[v]

        if w then
            render.SetModelLighting(v, w.r / 255, w.g / 255, w.b / 255)
        end
    end

    self:DrawModel()
    render.SuppressEngineLighting(false)
    cam.End3D()
    self.LastPaint = RealTime()
end

function a:RunAnimation()
    self.Entity:FrameAdvance((RealTime() - self.LastPaint) * self.m_fAnimSpeed)
end

function a:StartScene(x)
    if IsValid(self.Scene) then
        self.Scene:Remove()
    end

    self.Scene = ClientsideScene(x, self.Entity)
end

function a:LayoutEntity(y)
    if self.bAnimated then
        self:RunAnimation()
    end

    y:SetAngles(Angle(0, RealTime() * 10 % 360, 0))
end

function a:OnRemove()
    if IsValid(self.Entity) then
        self.Entity:Remove()
    end
end

function a:GenerateExample(z, A, B, C)
    local D = vgui.Create(z)
    D:SetSize(300, 300)
    D:SetModel("models/props_junk/PlasticCrate01a.mdl")
    D:GetEntity():SetSkin(2)
    A:AddSheet(z, D, nil, true, true)
end

vgui.Register('rp_modelpanel', a, 'Panel')
local a = {}

local function E(F, q, r)
    surface.SetDrawColor(ui.col.Outline)
    surface.DrawLine(40, r * 0.5, q, r * 0.5)
end

function a:Init()
    self.FOV = 70
    self.Angle = Angle()
    self.AngleSliderP = ui.Create('ui_slider_vertical', self)
    self.AngleSliderP:SetVisible(false)
    self.AngleSliderP.OnChange = function(F, G)
        self.Angle.p = (G - 0.5) * 180,
        self.ModelPanel.Entity:SetAngles(self.Angle)
    end
    self.AngleSliderP.Paint = function(F, q, r)
    end
    self.ModelPanel = ui.Create('rp_modelpanel', self)
    self.ModelPanel:SetFOV(20)
    self.ModelPanel:SetModel(LocalPlayer():GetModel())
    self.ModelPanel.Apparel = LocalPlayer():GetApparel()
    self.ModelPanel.DrawModel = function(self)
        self.Entity:DrawModel()
        self.Entity:SetEyeTarget(gui.ScreenToVector(gui.MousePos()))
        if self.Apparel then
            for H, I in pairs(self.Apparel) do
                rp.hats.Render(self.Entity, rp.hats.List[I])
            end
        end
    end
    self.ModelPanel.LayoutEntity = function(self)
        self:RunAnimation()
    end
    self.ModelPanel.Entity.GetPlayerColor = function()
        return LocalPlayer():GetPlayerColor()
    end
    local J = 60
    if IsValid(self.ModelPanel.Entity) then
        local K = self.ModelPanel.Entity:LookupBone('ValveBiped.Bip01_Head1')
        if K then
            J = self.ModelPanel.Entity:GetBonePosition(K).z
        end
    end
    if J < 5 then
        J = 40
    end
    J = J * 0.6
    self.ModelPanel:SetCamPos(Vector(175, 0, J))
    self.ModelPanel:SetLookAt(Vector(0, 0, J))
    self.Sequences = {'pose_standing_01', 'pose_standing_02', 'pose_standing_03', 'pose_standing_04'}
    self:FindSequence()
    self.AngleSliderY = ui.Create('ui_slider', self)
    
    self.AngleSliderY.OnChange = function(F, G)
        self.Angle.y = (G - 0.5) * 360
        self.ModelPanel.Entity:SetAngles(self.Angle)
    end
    
    self.AngleSliderY.Paint = E
    self.AngLeft = ui.Create('ui_button', self)
    self.AngLeft:SetFont'ForkAwesome'
    self.AngLeft:SetText(utf8.char(0xf104))
    self.AngLeft:SetTooltip'Повернуть налево'
    
    self.AngLeft.DoClick = function()
        local L = math.Clamp(self.Angle.y - 40, -180, 180)
        self.Angle.y = L
        self.ModelPanel.Entity:SetAngles(self.Angle)
        self.AngleSliderY:SetValue(0.5 + L / 360)
    end
    
    self.AngRight = ui.Create('ui_button', self)
    self.AngRight:SetFont'ForkAwesome'
    self.AngRight:SetText(utf8.char(0xf105))
    self.AngRight:SetTooltip'Повернуть направо'
    
    self.AngRight.DoClick = function()
        local L = math.Clamp(self.Angle.y + 40, -180, 180)
        self.Angle.y = L
        self.ModelPanel.Entity:SetAngles(self.Angle)
        self.AngleSliderY:SetValue(0.5 + L / 360)
    end
    
    self.ScaleSlider = ui.Create('ui_slider', self)
    
    self.ScaleSlider.OnChange = function(F, G)
        self.ModelPanel:SetFOV((G + 0.5) * (self.BaseFOV or 70))
    end
    
    self.ScaleSlider.Paint = E
    self.ZoomIn = ui.Create('ui_button', self)
    self.ZoomIn:SetFont'ForkAwesome'
    self.ZoomIn:SetText(utf8.char(0xf00e))
    self.ZoomIn:SetTooltip'Приблизить'
    
    self.ZoomIn.DoClick = function()
        local M = math.Clamp(self.FOV - 2, (self.BaseFOV or 70) * 0.5, (self.BaseFOV or 70) * 1.5)
        local N = M / (self.BaseFOV or 70) - 0.5
        self.ScaleSlider:SetValue(N)
        self:SetFOV(M)
    end
    
    self.ZoomOut = ui.Create('ui_button', self)
    self.ZoomOut:SetFont'ForkAwesome'
    self.ZoomOut:SetText(utf8.char(0xf010))
    self.ZoomOut:SetTooltip'Отдалить'
    
    self.ZoomOut.DoClick = function()
        local M = math.Clamp(self.FOV + 2, (self.BaseFOV or 70) * 0.5, (self.BaseFOV or 70) * 1.5)
        local N = M / (self.BaseFOV or 70) - 0.5
        self.ScaleSlider:SetValue(N)
        self:SetFOV(M)
    end
end

function a:PerformLayout(q, r)
    self.ModelPanel:SetSize(self.AngleSliderP:IsVisible() and q - 55 or q, r - 50)
    self.ModelPanel:SetPos(0, 0)
    self.AngleSliderY:SetWide(q - 40)
    self.AngleSliderY:SetPos(0, r - 20)
    self.AngLeft:SetPos(20, self.AngleSliderY.Y)
    self.AngLeft:SetSize(20, 20)
    self.AngRight:SetPos(self.AngleSliderY.X + self.AngleSliderY:GetWide(), self.AngleSliderY.Y)
    self.AngRight:SetSize(20, 20)
    self.ScaleSlider:SetWide(q - 40)
    self.ScaleSlider:SetPos(0, r - 45)
    self.ZoomIn:SetPos(20, self.ScaleSlider.Y)
    self.ZoomIn:SetSize(20, 20)
    self.ZoomOut:SetPos(self.ScaleSlider.X + self.ScaleSlider:GetWide(), self.ScaleSlider.Y)
    self.ZoomOut:SetSize(20, 20)
    self.AngleSliderP:SetTall(r - 55)
    self.AngleSliderP:SetPos(q - 30, 20)
end

function a:FindSequence()
    if IsValid(self.ModelPanel.Entity) then
        local O
        repeat
            O = self.ModelPanel.Entity:LookupSequence(self.Sequences[math.random(1, #self.Sequences)])
        until O
        self.ModelPanel.Entity:SetSequence(O)
    end
end

function a:AddSequence(P)
    self.Sequences[#self.Sequences + 1] = P
end

function a:SetApparel(Q)
    self.ModelPanel.Apparel = Q
end

function a:SetOutfit(R)
    self.Outfit = R
    self.ModelPanel.Entity:SetOutfit(R)
end

function a:SetFOV(S)
    if not self.BaseFOV then
        self.BaseFOV = S
    end

    self.FOV = S

    if ScrH() < 1200 then
        S = S * 1200 / ScrH()
    end

    return self.ModelPanel:SetFOV(S)
end

function a:SetModel(T)
    return self.ModelPanel:SetModel(T)
end

function a:GetModel()
    return self.ModelPanel:GetModel()
end

function a:ShowPitch(U)
    self.AngleSliderP:SetVisible(U)
end

function a:Paint(q, r)
    surface.SetDrawColor(ui.col.Outline)
    draw.NoTexture()

    if self.AngleSliderP:IsVisible() then
        surface.DrawLine(q - 20, 10, q - 20, r - 10)
    end
end

vgui.Register('rp_playerpreview', a, 'Panel')