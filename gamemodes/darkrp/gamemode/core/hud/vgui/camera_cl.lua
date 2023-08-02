local a = {}

function a:Init()
    self.BaseClass.Init(self)
    self:SetMouseInputEnabled(true)
    self.Container = self:Add'Panel'
    self.Container:Dock(TOP)
    self.Container:DockMargin(34, 0, 0, 0)
    self.Title = self.Container:Add'DLabel'
    self.Title:SetFont(rp.hud.GetFont())
    self.Title:SetTextColor(ui.col.White)
    self.Title:Dock(LEFT)
    self.Title:DockMargin(5, 5, 5, 5)
    self.Close = ui.Create('ui_button', self.Container)
    self.Close:SetText('X')
    self.Close:Dock(RIGHT)
    self.Close:DockMargin(0, 5, 5, 5)

    self.Close.DoClick = function()
        local b = rp.SecurityCameras[self.CameraIndex]

        if IsValid(b) then
            self.CameraIndex = 1
            b:ToggleSubscription()
        end
    end

    self.Close.Paint = function(c, d, e)
        draw.RoundedBox(5, 0, 0, d, e, self.ColorPrimary)
    end

    self.Forward = ui.Create('ui_button', self.Container)
    self.Forward:SetText('>')
    self.Forward:Dock(RIGHT)
    self.Forward:DockMargin(0, 5, 5, 5)

    self.Forward.DoClick = function()
        self.CameraIndex = self.CameraIndex + 1

        if not IsValid(rp.SecurityCameras[self.CameraIndex]) then
            self.CameraIndex = 1
        end
    end

    self.Forward.Paint = function(c, d, e)
        draw.RoundedBox(5, 0, 0, d, e, self.ColorPrimary)
    end

    self.Back = ui.Create('ui_button', self.Container)
    self.Back:SetText('<')
    self.Back:Dock(RIGHT)
    self.Back:DockMargin(5, 5, 5, 5)

    self.Back.DoClick = function()
        self.CameraIndex = self.CameraIndex - 1

        if not IsValid(rp.SecurityCameras[self.CameraIndex]) then
            self.CameraIndex = #rp.SecurityCameras
        end
    end

    self.Back.Paint = function(c, d, e)
        draw.RoundedBox(5, 0, 0, d, e, self.ColorPrimary)
    end

    self:SetSize(ScrW() * .175, 200)
    self.CameraIndex = 1
end

function a:PerformLayout(d, e)
    self.Container:SetTall(34)
    self.Title:SizeToContentsX()
    self.Title:SetTall(24)
    self.Close:SetSize(24, 24)
    self.Forward:SetSize(24, 24)
    self.Back:SetSize(24, 24)
end

function a:SetTitle(f)
    self.Title:SetText(f)
end

function a:Update()
    self.BaseClass.Update(self)
    self:SetTitle('Camera ' .. self.CameraIndex .. '/' .. #rp.SecurityCameras .. (rp.ScreenClickerToggled and '' or ' (F3)'))
    local g, h = ScrW() * .175, 200

    if rp.ScreenClickerToggled then
        self:SetSize(ScrW() - g * 2, ScrH() - self.y - h)
    else
        self:SetSize(g, h)
    end
end

function a:Paint(d, e)
    draw.Blur(self)
    draw.RoundedBox(5, 0, 0, d, e, ui.col.Background)
    draw.RoundedBox(5, 0, 0, 34, 34, self.ColorPrimary)
    draw.RoundedBox(5, 0, 0, d, 34, self.ColorSecondary)
    surface.SetDrawColor(255, 255, 255)
    surface.SetMaterial(self.Material)
    surface.DrawTexturedRect(5, 5, 24, 24)
    local i = rp.SecurityCameras[self.CameraIndex]

    if IsValid(i) then
        local j = self.Title:GetTall() + 15
        i:RenderScreen(5, j, d - 10, e - j - 5)
    end
end

vgui.Register('rp_hud_camera', a, 'rp_hud_base')