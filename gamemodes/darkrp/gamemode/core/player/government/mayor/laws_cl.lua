local function ChangeLaws()
	if (not LocalPlayer():IsMayor()) then return end
	local Laws = nw.GetGlobal 'TheLaws' or ''

	local fr = ui.Create('ui_frame', function(self)
		self:SetSize(ScrW() * .2, ScrH() * .3)
		self:Center()
		self:SetTitle('Законы')
		self:MakePopup()
	end)

	local x, y = fr:GetDockPos()
	local e = ui.Create('DTextEntry', function(self, p)
		self:SetPos(x, y)
		self:SetSize(p:GetWide() - 10, p:GetTall() - y - 65)
		self:SetMultiline(true)
		self:SetValue(Laws)
		self.OnTextChanged = function()
			Laws = self:GetValue()
		end
	end, fr)

	e = ui.Create('ui_button', function(self, p)
		x, y = e:GetPos()
		y = y + e:GetTall() + 5
		self:SetPos(x, y)
		self:SetSize(p:GetWide() - 10, 25)
		self:SetText('Сохранить')
		self.DoClick = function()
			if string.len(Laws) <= 3 then LocalPlayer():ChatPrint('Текст закона слишком короткий.') return end
			if #string.Wrap('DermaDefault', Laws, 325 - 10) >= 15 then LocalPlayer():ChatPrint('Доска законов переполнена.') return end
			net.Start('rp.SendLaws')
				net.WriteString(string.Trim(Laws))
			net.SendToServer()
		end
	end, fr)

	e = ui.Create('ui_button', function(self, p)
		x, y = e:GetPos()
		y = y + e:GetTall() + 5
		self:SetPos(x, y)
		self:SetSize(p:GetWide() - 10, 25)
		self:SetText('Сбросить законы')
		self.DoClick = function()
			LocalPlayer():ConCommand('say /resetlaws')
			p:Close()
		end
	end, fr)
end
concommand.Add('LawEditor', ChangeLaws)