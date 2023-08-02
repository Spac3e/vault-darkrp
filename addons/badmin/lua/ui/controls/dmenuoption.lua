timer.Simple(0, function()
    local a = vgui.GetControlTable'DMenuOption'
    a._PerformLayout = a._PerformLayout or a.PerformLayout

    a.PerformLayout = function(self, b, c)
        self._PerformLayout(self, b, c)

        if self:GetSkin() and self:GetSkin().Name == 'SUP' then
            self:SetTall(25)
            self:SetContentAlignment(5)
        end
    end
end)