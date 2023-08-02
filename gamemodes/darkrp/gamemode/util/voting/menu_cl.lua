local PANEL = {}

function PANEL:Think()
    local b, c = chat.GetChatBoxPos()
    local d, e = chat.GetChatBoxSize()
    local f, g = ScrW() * 0.25, math.max(e, 210)
    local h, i = b + d + 5, ScrH() - g - 5

    if self.X ~= h or self.Y ~= i then
        self:SetPos(h, i)
    end

    local j, k = self:GetSize()

    if j ~= f or k ~= g then
        self:SetSize(f, g)
    end

    local l
    local m = math.huge

    for n, o in pairs(rp.question.Queue) do
        if o.Expire <= CurTime() then
            rp.question.Destroy(o.Uid)
        elseif IsValid(o.Panel) then
            o.Panel.IsFirstInQueue = nil

            if o.Expire < m then
                l = o.Panel
                m = o.Expire
            end
        end
    end

    if IsValid(l) then
        l.IsFirstInQueue = true
    end
end

vgui.Register('rp_question_container', PANEL, 'EditablePanel')

PANEL = {}

local function p(self, f, g, q)
    local r = g - 4
    draw.RoundedBox(4, 2, 2, r, r, ui.col.OffWhite)

    if self:IsHovered() then
        draw.RoundedBox(4, 2, 2, r, r, ui.col.Hover)
    end

    r = g * 0.5
    draw.SimpleText(q, 'ui.16', g * 0.5, r, ui.col.Black, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
end

local s = ui.col.SUP:Copy()
s.a = 25
local t = ui.col.DarkRed:Copy()
t.a = 25

function PANEL:Init()
    self:DockPadding(5, 5, 5, 5)
    self.BtnCont = ui.Create('Panel', self)
    self.BtnCont:DockPadding(ui.ButtonHeight + 5, 0, 0, 0)
    self.BtnCont:Dock(BOTTOM)

    self.BtnCont.Paint = function(r, f, g)
        draw.RoundedBox(5, 0, 0, g, g, ui.col.Background)
        local u = self.Question.Expire - CurTime()

        if u < 5 then
            t.a = math.sin(SysTime() * math.pi * 2) * 125
           draw.RoundedBox(5, 0, 0, g, g, t)
        else
            draw.RoundedBox(5, 0, 0, g * u / self.Question.Time, g, s)
        end

        draw.SimpleText(math.ceil(self.Question.Expire - CurTime()), 'ui.18', g * 0.5, g * 0.5, ui.col.White, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
    end

    self.BtnYes = ui.Create('ui_button', self.BtnCont)
    self.BtnYes:SetText('Да')
    self.BtnYes:DockMargin(0, 0, 2.5, 0)
    self.BtnYes:Dock(LEFT)
    self.BtnYes.HasConfirmed = true

    self.BtnYes.DoConfirm = function()
        self:Answer(true)
    end

    self.BtnYes.PaintOver = function(r, f, g)
        p(r, f, g, 'F1')
    end

    self.BtnNo = ui.Create('ui_button', self.BtnCont)
    self.BtnNo:SetText('Нет')
    self.BtnNo:DockMargin(2.5, 0, 0, 0)
    self.BtnNo:Dock(RIGHT)
    self.BtnNo.HasConfirmed = true
    self.BtnNo.DoConfirm = function()
        self:Answer(false)
    end

    self.BtnNo.PaintOver = function(r, f, g)
        p(r, f, g, 'F2')
    end

    LocalPlayer():EmitSound('Town.d1_town_02_elevbell1', 100, 100)
end

function PANEL:PerformLayout(f, g)
    self.BtnCont:SetTall(ui.ButtonHeight)
    self.BtnYes:SetWide(self.BtnCont:GetWide() * 0.5 - ui.ButtonHeight * 0.5 - 5)
    self.BtnNo:SetWide(self.BtnYes:GetWide())
end

local v = false

function PANEL:Think()
    if self.DefaultAnswer then
        local u = self.Question.Expire - CurTime()

        if u <= 0 then
            self:Answer(self.DefaultAnswer)

            return
        end
    end

    if self.IsFirstInQueue then
        if input.IsKeyDown(KEY_F1) then
            if v then
                self.BtnYes:DoClick()
            end

            v = false
        elseif input.IsKeyDown(KEY_F2) then
            local w = LocalPlayer():GetEyeTrace().Entity

            if v and (not IsValid(w) or not w:IsDoor()) then
                self.BtnNo:DoClick()
            end

            v = false
        else
            v = true
        end
    end
end

function PANEL:Paint(f, g)
    draw.Blur(self)
    derma.SkinHook('Paint', 'Panel', self, f, g)

    if self.Text then
        local x = string.Wrap('ui.18', self.Text, self:GetWide() - 10)
        self.BubbleHeight = #x * 17 + 10
        local y = self.BubbleHeight + ui.ButtonHeight + 15

        if self:GetTall() ~= y then
            self:SetTall(y)
        end

        draw.RoundedBox(5, 5, 5, f - 10, self.BubbleHeight, ui.col.Background)
        local i = 10

        for n, o in ipairs(x) do
            draw.SimpleText(o, 'ui.18', 10, i, ui.col.White, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
            i = i + 17
        end
    end
end

function PANEL:SetQuestion(z)
    self.Question = z
end

function PANEL:SetText(A)
    self.Text = A
end

function PANEL:Answer(B)
    net.Start 'rp.question.Answer'
    net.WriteString(self.Question.Uid)
    net.WriteBool(B)
    net.SendToServer()
    rp.question.Destroy(self.Question.Uid)
end

vgui.Register('rp_question_panel', PANEL, 'Panel')