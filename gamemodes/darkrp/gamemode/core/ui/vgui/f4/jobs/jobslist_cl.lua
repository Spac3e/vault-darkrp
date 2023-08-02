cvar.Register'JobModel'
    :SetDefault({}, true)

hook('InitPostEntity', 'rp.jobmodel.InitPostEntity', function()
    local a = rp.GetJobModel(1)
    net.Start'rp.SelectModel'
        net.WriteString(a)
    net.SendToServer()
end)

function rp.GetJobModel(b)
    local c = rp.teams[b]

    if isstring(c.model) then
        return c.model
    else
        local d = cvar.GetValue('JobModel')
        local e = d[b]
        if e and c.model[e] then return string.lower(c.model[e]) end
    end

    return string.lower(c.model[1])
end

function rp.SetJobModel(b, e)
    local d = cvar.GetValue('JobModel')
    d[b] = e
    cvar.SetValue('JobModel', d)
end

local f = {}

function f:Init()
    self.JobList = ui.Create('ui_listview', self)
    self.JobList:SetSpacing(1)
    self.JobPreview = ui.Create('rp_jobinfo', self)
    self.JobPreview:SetJob(LocalPlayer():Team())
    self:AddTeams()
end

function f:AddTeams(g, h)
    local i = {}

    for j, k in ipairs(h or rp.teams) do
        if g or not k.customCheck or k.customCheck(LocalPlayer()) then
            local l = k.category or 'Граждане/Другие'

            if not i[l] then
                i[l] = {}
            end

            i[l][#i[l] + 1] = k
        end
    end

    for l, m in SortedPairs(i) do
        self.JobList:AddSpacer(l)
        local n = ui.Create('Panel', self)

        function n:PerformLayout(o, p)
            local q, r = 0, 1
            local s, t = o / 3 - 1, 100
            local u = 1

            for j, k in ipairs(self:GetChildren()) do
                if u > 3 then
                    q = 0
                    r = r + t + 1
                    u = 1
                end

                k:SetPos(q, r)
                k:SetSize(s, t)
                q = q + s + 1
                u = u + 1
            end
        end

        for v, w in ipairs(m) do
            self:AddJob(w, n)
        end

        n:SetTall(math.ceil(#m / 3) * 101)
        self.JobList:AddItem(n)
    end
end

local x = Material('sup/gui/generic/vip.png', 'smooth')
local y = Material('sup/gui/generic/clock.png', 'smooth')
local z = ui.col.Gold:Copy()
z.a = 125

function f:AddJob(w, n)
    local A = ui.Create('rp_modelbutton', n)
    A:SetDoubleClickingEnabled(false)
    A:SetModel(rp.GetJobModel(w.team))
    A:SetTopText(w.name)

    if w.team == LocalPlayer():Team() then
        A:SetBottomText('Текущая Работа')
    else
        local B = isfunction(w.max) and w.max(w) or w.max
        A:SetBottomText(B == 0 and '∞' or #team.GetPlayers(w.team) .. '/' .. B)
    end

    A:SetHoverText('Выбрать')
    local C = w.color:Copy()
    C.a = 125
    A:SetColor(C)
    local D = w.team == LocalPlayer():Team()

    if D then
        A:SetActive(D)
        self.Selected = A
    end

    A._PaintOver = A.PaintOver

    A.PaintOver = function(E, o, p)
        local F, G = LocalPlayer():IsVIP(), LocalPlayer():GetPlayTime()

        if w.vip and not LocalPlayer():IsVIP() then
            surface.SetDrawColor(z:Unpack())
            surface.SetMaterial(x)
            surface.DrawTexturedRect(5, p * 0.5 - 16, 32, 32)
        end

        if w.playtime and w.playtime > G and not F then
            surface.SetDrawColor(255, 255, 255)
            surface.SetMaterial(y)
            surface.DrawTexturedRect(5, p * 0.5 - 16, 32, 32)
        end

        E._PaintOver(E, o, p)
    end

    A.DoClick = function(E)
        if IsValid(self.Selected) then
            self.Selected:SetActive(false)
        end

        E:SetActive(true)
        self.Selected = E
        self.JobPreview:SetJob(w.team)

        if self.DoClick then
            self.JobPreview.DoClick = self.DoClick
        end

        if self.DoubleClick and self.DoubleClick > CurTime() then
            if self.JobPreview.DoClick then
                self.JobPreview.DoClick(self.JobPreview)
            else
                self.JobPreview.ChangeJob.DoClick(self.JobPreview.ChangeJob)
            end
        end

        self.DoubleClick = CurTime() + 0.5
    end

    return A
end

function f:PerformLayout(o, p)
    self.JobList:SetPos(5, 5)
    self.JobList:SetSize(o * 0.5 - 7.5, p - 10)
    self.JobPreview:SetPos(o * 0.5 + 2.5, 5)
    self.JobPreview:SetSize(o * 0.5 - 7.5, p - 10)
end

vgui.Register('rp_jobslist', f, 'Panel')