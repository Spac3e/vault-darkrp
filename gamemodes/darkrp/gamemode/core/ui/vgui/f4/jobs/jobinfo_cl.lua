local a = {}

function a:Init()
    self:SetDisabled(true)
end

function a:CheckValue(b, c, d)
    self:SetImage(b and 'sup/ui/check.png' or 'sup/ui/x.png')
    self:SetText(b and (isstring(b) and b or c) or d)
    self:SetImageColor(b and ui.col.DarkGreen or ui.col.Red)
end

vgui.Register('rp_jobperm', a, 'ui_button')
a = {}

function a:Init()
    self.Name = ui.Create('ui_button', self)
    self.Name:SetDisabled(true)
    self.Name:SetFont('ui.20')
    self.ModelBack = ui.Create('ui_button', self)
    self.ModelBack:SetFont'ForkAwesome'
    self.ModelBack:SetText(utf8.char(0xf060))

    self.ModelBack.DoClick = function()
        local e = self.ModelIndex - 1
        self.ModelIndex = self.Job.model[e] and e or #self.Job.model
        local f = self.Job.model[self.ModelIndex]
        self.Model:SetModel(f)
        self:GetParent().Selected:SetModel(f)
        net.Start'rp.SelectModel'
            net.WriteString(f)
        net.SendToServer()
        rp.SetJobModel(self.Job.team, self.ModelIndex)
    end

    self.ModelForward = ui.Create('ui_button', self)
    self.ModelForward:SetFont'ForkAwesome'
    self.ModelForward:SetText(utf8.char(0xf061))

    self.ModelForward.DoClick = function()
        local e = self.ModelIndex + 1
        self.ModelIndex = self.Job.model[e] and e or 1
        local f = self.Job.model[self.ModelIndex]
        self.Model:SetModel(f)
        self:GetParent().Selected:SetModel(f)
        net.Start'rp.SelectModel'
            net.WriteString(f)
        net.SendToServer()
        rp.SetJobModel(self.Job.team, self.ModelIndex)
    end

    self.RelatedJobs = {}
    self.Relations = ui.Create('ui_button', self)
    self.Relations:SetDisabled(true)
    self.Relations:SetFont('ui.20')
    self.Relations:SetText('RP Отношения:')
    self.RelatedInfo = ui.Create('ui_button', self)
    self.RelatedInfo:SetDisabled(true)
    self.RelatedInfo:SetText('Нет RP Отношений')
    self.CanRaid = ui.Create('rp_jobperm', self)
    self.CanMug = ui.Create('rp_jobperm', self)
    self.CanHostage = ui.Create('rp_jobperm', self)
    self.Model = ui.Create('rp_playerpreview', self)
    self.Model:SetFOV(15)
    self.ChangeJob = ui.Create('ui_button', self)

    self.ChangeJob.Think = function(g)
        if self.Job.playtime and LocalPlayer():GetPlayTime() < self.Job.playtime and not self.DoClick then
            g:SetDisabled(true)
            g:SetText('Недостаточно времени! Отыграйте: ' .. ba.str.FormatTime(self.Job.playtime - LocalPlayer():GetPlayTime()))
        elseif self.Job.vote and not self.DoClick then
            g:SetText('Участвовать в выборах')
        else
            g:SetDisabled(false)
            g:SetText(self.SelectionText or 'Сменить Работу')
        end
    end

    self.ChangeJob.DoClick = function()
        if self.DoClick then
            self:DoClick()

            return
        end

        if self.Job.vip and not LocalPlayer():IsVIP() and not rp.EventIsRunning('VIP') then
            ui.BoolRequest('Упс', 'Это VIP работа! Не желаете приобрести VIP?', function(h)
                if h == true then
                    rp.ToggleF4Menu()
                    RunConsoleCommand("say", "/donate")
                end
            end)

            return
        end

        if self.Job.vote then
            local i = self.Job.command
            cmd.Run('vote' .. i)
        elseif self.Job.CannotOwnDoors and LocalPlayer():GetNetVar('OwnsProperty') then
            local i = self.Job.command

            ui.BoolRequest("Упс", self.Job.name .. ' не может иметь двери! Перед взятием этой профессии система продаст за вас двери. Продолжить?', function(h)
                if h == true then
                    cmd.Run(i)
                end
            end)
        else
            cmd.Run(self.Job.command, rp.GetJobModel(self.Job.team))
        end

        rp.ToggleF4Menu()
    end
end

function a:PerformLayout(j, k)
    self.Name:SetPos(0, 0)
    self.Name:SetSize(j, ui.SpacerHeight)
    local l = ui.SpacerHeight + 5
    local m = j * 0.5 - 2.5
    self.ModelBack:SetPos(j * 0.5 + 2.5, l)
    self.ModelBack:SetSize(j * 0.25 - 5, ui.SpacerHeight)
    self.ModelForward:SetPos(j * 0.75 + 5, l)
    self.ModelForward:SetSize(j * 0.25 - 5, ui.SpacerHeight)
    self.CanRaid:SetPos(0, l)
    self.CanRaid:SetSize(m, ui.SpacerHeight)
    l = l + ui.SpacerHeight + 5
    self.CanMug:SetPos(0, l)
    self.CanMug:SetSize(m, ui.SpacerHeight)
    l = l + ui.SpacerHeight + 5
    self.CanHostage:SetPos(0, l)
    self.CanHostage:SetSize(m, ui.SpacerHeight)
    l = l + ui.SpacerHeight + 5
    self.Relations:SetPos(0, l)
    self.Relations:SetSize(m, ui.SpacerHeight)
    l = l + ui.SpacerHeight + 5

    if self.RelatedInfo:IsVisible() then
        self.RelatedInfo:SetPos(0, l)
        self.RelatedInfo:SetSize(m, ui.SpacerHeight)
        l = l + ui.SpacerHeight + 5
    end

    for n, o in ipairs(self.RelatedJobs) do
        o:SetPos(0, l)
        o:SetSize(m, ui.SpacerHeight)
        l = l + ui.SpacerHeight + 5
    end

    l = ui.SpacerHeight + 5
    self.Model:SetSize(j * 0.5 - 2.5, k - l - ui.ButtonHeight - ui.SpacerHeight - 5)
    self.Model:SetPos(j * 0.5 + 2.5, (ui.SpacerHeight + 5) * 2 - 5)
    self.ChangeJob:SetPos(0, k - ui.ButtonHeight)
    self.ChangeJob:SetSize(j, ui.ButtonHeight)
end

function a:SetJob(e)
    local p = rp.teams[e]
    if not p then return end
    self.Job = p

    for n, o in ipairs(self.RelatedJobs) do
        o:Remove()
        self.RelatedJobs[n] = nil
    end

    self.Name:SetText(p.name)
    local q = p.color:Copy()
    q.a = 125
    self.Name.BackgroundColor = q
    self.CanRaid:CheckValue(p.CanRaid, 'Рейды разрешены', 'Рейды запрещены')
    self.CanMug:CheckValue(p.CanMug, 'Разрешены грабежи', 'Запрещены грабежи')
    self.CanHostage:CheckValue(p.CanHostage, 'Разрешено брать заложников', 'Запрещено брать заложников')
    self.RelatedInfo:SetVisible(true)

    if p.GetRelationships then
        local r = p.GetRelationships()

        if isstring(r) then
            self.RelatedInfo:SetText(r)
        else
            self.RelatedInfo:SetVisible(false)

            for n, o in ipairs(r) do
                local p = rp.teams[o]
                local q = p.color:Copy()
                q.a = 125

                self.RelatedJobs[#self.RelatedJobs + 1] = ui.Create('ui_button', function(g)
                    g:SetText(p.name)
                    g.BackgroundColor = q
                end, self)
            end
        end
    else
        self.RelatedInfo:SetText('Нет RP Отношений')
    end

    self.ModelBack:SetDisabled(isstring(p.model))
    self.ModelForward:SetDisabled(isstring(p.model))
    local f = rp.GetJobModel(p.team)

    if istable(p.model) then
        for n, o in ipairs(p.model) do
            if string.lower(o) == f then
                self.ModelIndex = n
                break
            end
        end
    end

    self.Model:SetModel(f)
end

vgui.Register('rp_jobinfo', a, 'DPanel')