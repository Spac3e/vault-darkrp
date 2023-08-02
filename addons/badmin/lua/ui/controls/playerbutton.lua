local a = {}

function a:Init()
    self.ImageButton = ui.Create('ui_imagebutton', self)
    self:SetText('')
    self:SetFont('ui.22')
    self:SetTextColor(ui.col.White)
    self:SetTall(30)
end

function a:PerformLayout()
    self.ImageButton:SetPos(2, 2)
    self.ImageButton:SetSize(26, 26)
end

function a:SetPlayer(b, c)
    local d = isplayer(b) and b or player.Find(c)

    if isplayer(d) then
        self.Player = d
        self:SetColor((d.GetJobColor and d:GetJobColor() or team.GetColor(d:Team())):Copy())
        self:SetText(d:Name())
        self.ImageButton:SetPlayer(d)
    else
        self:SetText(b)
        self:SetColor(team.GetColor(1):Copy())

        if c then
            self.ImageButton:SetSteamID64(c)
        else
            self.ImageButton:SetVisible(false)
        end
    end
end

function a:SetMaterial(e)
    self.ImageButton:SetMaterial(e)
end

function a:SetColor(f)
    self.BackgroundColor = f
end

function a:GetPlayer()
    return self.Player
end

function a:DoClick()
end

function a:Paint(g, h)
    derma.SkinHook('Paint', 'ImageRow', self, g, h)
end

vgui.Register('ui_imagerow', a, 'ui_button')