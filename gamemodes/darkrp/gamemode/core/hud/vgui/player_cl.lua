local a = {}

function a:Init()
    self:SetTall(34)
    self.Model = self:Add'ModelImage'
    self.Model:SetMouseInputEnabled(false)
    self.Model:SetKeyboardInputEnabled(false)
    self.Model:Dock(LEFT)
    self.Model:DockMargin(2, 2, 0, 2)

    function self.Model:Paint(b, c)
        draw.RoundedBox(5, 0, 0, b, c, ui.col.Background)
    end

    self.Name = self:Add'DLabel'
    self.Name:Dock(FILL)
    self.Name:DockMargin(5, 5, 5, 5)
    self.Name:SetFont(rp.hud.GetFont())
    self.Name:SetTextColor(ui.col.White)
    self.Info = self:Add'DLabel'
    self.Info:Dock(RIGHT)
    self.Info:DockMargin(5, 5, 5, 5)
    self.Info:SetFont(rp.hud.GetFont())
    self.Info:SetTextColor(ui.col.White)
    self.Info:SetText('')
    self.Info:SetVisible(false)
end

function a:SetPlayer(d)
    self.Player = d
    self.PlayerName = d:Name()
    self.PlayerJob = d:GetJob()
    self.PlayerSet = true
    self.Model:SetModel(d:GetModel(), d:GetSkin())
    self.Name:SetText(self.PlayerName)
    self:SetColor(d:GetJobColor())
end

function a:SetInfo(e)
    self.Info:SetVisible(e ~= '')
    self.Info:SetText(e)
end

function a:GetContentSize()
    local f, g = self.Name:GetContentSize()
    local h, i = self.Info:GetContentSize()

    return 34 + f + h + 20, self:GetTall()
end

function a:PerformLayout(b, c)
    local j = c - 4
    self.Model:SetSize(j, j)
    self.Name:SizeToContents()
    self.Info:SizeToContents()
end

function a:ShouldDraw()
    if self.PlayerSet and not IsValid(self.Player) then
        self:Remove()

        return false
    end

    return self.PlayerSet and self.Player:Alive()
end

function a:Update()
    if self.PlayerSet and not IsValid(self.Player) then
        self:Remove()

        return
    end

    if self.PlayerJob ~= self.Player:GetJob() then
        self.PlayerJob = self.Player:GetJob()
        self.Model:SetModel(self.Player:GetModel(), self.Player:GetSkin())
        self:SetColor(self.Player:GetJobColor())
    end

    if self.PlayerName ~= self.Player:Name() then
        self.PlayerName = self.Player:Name()
        self.Name:SetText(self.PlayerName)
    end
end

function a:Paint(b, c)
    draw.RoundedBox(5, 0, 0, b, c, self.ColorSecondary)
end

vgui.Register('rp_hud_player', a, 'rp_hud_base')