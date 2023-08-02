local a = {}

function a:Init()
    local function b(self, c, d, e, f)
        self.Count = self.Count + 1

        self:AddItem(ui.Create('ui_imagerow', function(g)
            g:SetPlayer(c)
            g:SetToolTip(e)
            g:SetText('')

            g.Paint = function(g, h, i)
                if not IsValid(g:GetPlayer()) then return end
                derma.SkinHook('Paint', 'ImageRow', g, h, i)
                draw.SimpleText(c:Name(), 'ui.20', 31, i * 0.5, ui.col.White, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
                draw.SimpleText(d(c), 'ui.20', h - 5, i * 0.5, ui.col.White, TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER)
            end

            g.DoClick = f

            g.Think = function()
                if not IsValid(g:GetPlayer()) then
                    g:Remove()
                end
            end
        end))
    end

    self.HireablePlayers = ui.Create('ui_listview', self)
    local j = self.HireablePlayers:AddSpacer('Нанять сотрудника')
    j:SetTall(ui.SpacerHeight)

    j.Paint = function(g, h, i)
        draw.RoundedBoxEx(5, 0, 0, h, i, ui.col.FlatBlack, true, true, false, false)
    end

    self.HireablePlayers.Count = 0

    self.HireablePlayers.AddEmployee = function(g, k)
        b(g, k, k.GetJobName, 'Hire', function(g)
            ui.BoolRequest('Нанять сотрудника', 'Вы уверены, что хотите нанять ' .. k:Name() .. '?', function(l)
                if l then
                    rp.RunCommand('hire', k:SteamID(), k:GetHirePrice())
                    g:SetDisabled(true)
                end
            end)
        end)
    end

    self.HireablePlayers.PaintOver = function(g, h, i)
        if g.Count == 0 then
            draw.RoundedBoxEx(5, 0, ui.SpacerHeight, h, i - ui.SpacerHeight, ui.col.Background, false, false, true, true)
            draw.SimpleText('Никто не доступен для найма!', 'ui.24', h * 0.5, i * 0.5, ui.col.White, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
        end
    end

    self.Employees = ui.Create('ui_listview', self)
    local j = self.Employees:AddSpacer('Уволить сотрудника')
    j:SetTall(ui.SpacerHeight)

    j.Paint = function(g, h, i)
        draw.RoundedBoxEx(5, 0, 0, h, i, ui.col.FlatBlack, true, true, false, false)
    end

    self.Employees.Count = 0

    self.Employees.AddEmployee = function(g, k)
        b(g, k, k.GetTeamName, 'Fire', function(g)
            ui.BoolRequest('Уволить сотрудника', 'Вы уверены, что хотите уволить? ' .. k:Name() .. '?', function(l)
                if l then
                    rp.RunCommand('fire', k:SteamID())
                    g:Remove()
                    self.Employees.Count = self.Employees.Count - 1
                    self.HireablePlayers:AddEmployee(k)
                end
            end)
        end)
    end

    self.Employees.PaintOver = function(g, h, i)
        if g.Count == 0 then
            draw.RoundedBoxEx(5, 0, ui.SpacerHeight, h, i - ui.SpacerHeight, ui.col.Background, false, false, true, true)
            draw.SimpleText('У вас нет сотрудников!', 'ui.24', h * 0.5, i * 0.5, ui.col.White, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
        end
    end

    for m, k in ipairs(player.GetAll()) do
        if k:IsHirable() and not k:IsHired() then
            self.HireablePlayers:AddEmployee(k)
        elseif k:IsHired() and k:GetNetVar('Employer') == LocalPlayer() then
            self.Employees:AddEmployee(k)
        end
    end
end

function a:PerformLayout()
    local n = self:GetWide() * 0.5
    local o = self:GetTall() * 0.5
    self.HireablePlayers:SetPos(0, 0)
    self.HireablePlayers:SetSize(self:GetWide(), o - 2.5)
    self.Employees:SetPos(0, o + 2.5)
    self.Employees:SetSize(self:GetWide(), o - 2.5)
end

vgui.Register('rp_employment_manager', a, 'Panel')