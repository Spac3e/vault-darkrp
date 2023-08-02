local a = {
    [1] = {
        Name = 'Самый Большой',
        Font = 'ui.28',
        Secondary = 'ui.24'
    },
    [2] = {
        Name = 'Большой',
        Font = 'ui.22',
        Secondary = 'ui.18'
    },
    [3] = {
        Name = 'Стандартный',
        Font = 'ui.18',
        Secondary = 'ui.16'
    },
    [4] = {
        Name = 'Маленький',
        Font = 'ui.16',
        Secondary = 'ui.14'
    },
    [5] = {
        Name = 'Самый маленький',
        Font = 'ui.12',
        Secondary = 'ui.12'
    }
}

cvar.Register'hud_font'
    :SetDefault(2, true)
    :AddMetadata('Catagory', 'HUD')
    :SetCustomElement('rp_hud_font_picker')

function rp.hud.GetFont()
    return a[cvar.GetValue('hud_font')].Font or 'ui.18'
end

function rp.hud.GetSecondaryFont()
    return a[cvar.GetValue('hud_font')].Secondary or 'ui.16'
end

local PANEL = {}

function PANEL:Init()
    self.lblFilter = ui.Create('DLabel', function(c)
        c:SetText('HUD Шрифт: ')
    end, self)

    self.choices = ui.Create('DComboBox', function(d)
        d:SetSortItems(false)

        for e, f in ipairs(a) do
            d:AddChoice(f.Name, e)
        end

        d:SetValue((a[cvar.GetValue('hud_font')] or a[2]).Name)

        d.OnSelect = function(self, g, h, i)
            cvar.SetValue('hud_font', i)
            rp.hud.Create()
        end
    end, self)

    self:SetTall(35)
end

function PANEL:SetCvar(cvar)
    self.Cvar = cvar
    self:SetTall(35)
end

function PANEL:ApplySchemeSettings()
    self.lblFilter:SetFont('ui.18')
end

function PANEL:PerformLayout(j, k)
    self.lblFilter:SizeToContents()
    self.lblFilter:SetPos(5, 8.5)
    self.choices:SetSize(150, 25)
    self.choices:SetPos(self.lblFilter:GetWide() + 5, 5)
end

function PANEL:Paint(j, k)
    derma.SkinHook('Paint', 'Panel', self, j, k)

    return false
end

vgui.Register('rp_hud_font_picker', PANEL, 'Panel')