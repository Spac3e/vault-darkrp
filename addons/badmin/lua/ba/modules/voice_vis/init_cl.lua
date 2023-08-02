local PANEL = {}
local VoicePanels = {}
local material_mic = Material'sup/hud/istalking'

function PANEL:Init()
    self.Avatar = ui.Create('ui_imagebutton', self)
    self.Name = ui.Create('DLabel', self)
    self.Name:SetFont('ui.15')
    self.Name:SetTextColor(ui.col.White)
    self.Info = ui.Create('DLabel', self)
    self.Info:SetFont('ui.12')
    self.Info:SetTextColor(ui.col.LightGrey)
    self:SetTall(40)
    self:DockPadding(4, 4, 4, 4)
    self:DockMargin(2, 2, 2, 2)
    self:Dock(BOTTOM)
    self:SetAlpha(0)

    hook('PlayerEndVoice', self, function(self, pl)
        if (pl == self.Player) and (not self.FadeOutAnim) then
            self:FadeOut()
        end
    end)
end

function PANEL:PerformLayout(w, h)
    self.Avatar:SetPos(4, 4)
    self.Avatar:SetSize(h - 8, h - 8)
    local x, y = self.Avatar:GetPos()
    x, y = h * 0.5, y + self.Avatar:GetWide() + 4
    self.Name:SetPos(y, x - ((self.Info:GetText() == '') and (self.Name:GetTall() * 0.5) or (self.Name:GetTall() - 2)))
    self.Info:SetPos(y, x)
end

function PANEL:Setup(pl)
    local data = hook.Call('PlayerGetVoiceData', nil, pl) or {}
    self.Avatar:SetPlayer(pl)
    self.Name:SetText(data.Name or (pl:GetNetVar('rp.Mask') and 'Неизвестно') or pl:Name())
    self.Name:SizeToContents()
    self.Info:SetText(data.Info or pl:GetOrg() or '')
    self.Info:SizeToContents()
    self.OutlineColor = data.OutlineColor or (pl:GetNetVar('rp.Mask') and Color(0, 0, 0)) or pl:GetJobColor()
    self.Player = pl
    VoicePanels[self.Player] = self
    self:InvalidateLayout()
end

function PANEL:Paint(w, h)
    if (not IsValid(self.Player)) or (hook.Call('HUDShouldDraw', nil, 'VoiceBox') == false) then return end
    draw.RoundedBox(5, 1, 1, w - 2, h - 2, self.OutlineColor, 3)
    draw.RoundedBox(5, 3, 3, w - 6, h - 6, ui.col.Black)
    local s = 32
    surface.SetMaterial(material_mic)
    surface.SetDrawColor(255, 255, 255)
    material_mic:SetString('$alpha', self:GetAlpha() / 255) -- setalpha doesnt work on animated materials
    surface.DrawTexturedRect(w - 30, 3, s, s)
end

function PANEL:Think()
    if self.FadeInAnim then
        self.FadeInAnim:Run()
    end

    if self.FadeOutAnim then
        self.FadeOutAnim:Run()
    end

    if (not IsValid(self.Player)) and (not self.FadeOutAnim) then
        self:FadeOut()
    end
end

function PANEL:FadeIn()
    self.FadeInAnim = Derma_Anim('Fade Panel', self, function(panel, animation, delta, data)
        panel:SetAlpha(delta * 255)

        if animation.Finished then
            self.FadeInAnim = nil
        end
    end)

    if self.FadeInAnim then
        self.FadeInAnim:Start(0.2)
    end
end

function PANEL:FadeOut()
    self.FadeOutAnim = Derma_Anim('Fade Panel', self, function(panel, animation, delta, data)
        panel:SetAlpha(255 - (delta * 255))

        if animation.Finished then
            self:Remove()
            VoicePanels[self.Player] = nil
        end
    end)

    if self.FadeOutAnim then
        self.FadeOutAnim:Start(0.2)
    end
end

derma.DefineControl('ba_VoiceNotify', '', PANEL, 'DPanel')
GM = GM or GAMEMODE

function GM:PlayerStartVoice(pl)
    if (not IsValid(g_VoicePanelList)) or (not IsValid(pl)) then return end
    local pnl = VoicePanels[pl]

    if IsValid(pnl) then
        if pnl.FadeOutAnim then
            pnl.FadeOutAnim:Stop()
            pnl.FadeOutAnim = nil
            pnl:FadeIn()
        end
    else
        local pnl = g_VoicePanelList:Add('ba_VoiceNotify')
        pnl:Setup(pl)
        pnl:FadeIn()
    end
end

hook('InitPostEntity', 'ba.voicevis.InitPostEntity', function()
    timer.Simple(0, function()
        g_VoicePanelList:SetPos(ScrW() - 225, 10)
        g_VoicePanelList:SetSize(215, ScrH() - 110)
    end)
end)

if IsValid(g_VoicePanelList) then
    g_VoicePanelList:Clear()
end