rp.question = rp.question or {
    Queue = {}
}

if IsValid(rp.question.Container) then
    rp.question.Container:Remove()
    rp.question.Container = nil
end

function rp.question.RemakeContainer()
    local a = ui.Create('rp_question_container')

    if IsValid(rp.question.Container) then
        for b, c in ipairs(rp.question.Container:GetChildren()) do
            c:SetParent(a)
        end

        rp.question.Container:Remove()
    end

    rp.question.Container = a
end

function rp.question.AddPanel(d, e, f)
    local g = {
        Panel = d,
        Time = e,
        Expire = e + CurTime(),
        Uid = f
    }

    if d.SetQuestion then
        d:SetQuestion(g)
    end

    rp.question.Queue[f] = g

    if not IsValid(rp.question.Container) then
        rp.question.Container = ui.Create('rp_question_container')
    end

    d:SetParent(rp.question.Container)
    d:DockMargin(0, 5, 0, 0)
    d:Dock(BOTTOM)

    return d
end

function rp.question.Create(h, e, f)
    return rp.question.AddPanel(ui.Create('rp_question_panel', function(self)
        self:SetText(h)
    end), e, f)
end

function rp.question.Exists(f)
    return rp.question.Queue[f] ~= nil
end

function rp.question.Destroy(f)
    local g = rp.question.Queue[f]

    if IsValid(g.Panel) then
        g.Panel:Remove()
    end

    rp.question.Queue[f] = nil
end

net('rp.question.Ask', function()
    rp.question.Create(net.ReadString(), net.ReadUInt(16), net.ReadString())
end)

net('rp.question.Destroy', function()
    local f = net.ReadString()

    if rp.question.Exists(f) then
        rp.question.Destroy(f)
    end
end)

concommand.Add('question_test', function()
    rp.question.Create('This here is a question ' .. CurTime(), 20, 'qqqq' .. CurTime())
end)