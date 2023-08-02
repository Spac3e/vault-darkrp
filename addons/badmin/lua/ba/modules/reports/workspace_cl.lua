local ratingAdmin = "sup/gui/generic/vip.png"
surface.CreateFont( "RatingFont", {
	font = "Roboto",
	extended = true,
	size = 18,
	weight = 500,
	antialias = true
})

surface.CreateFont( "RatingFont1", {
	font = "Roboto",
	extended = true,
	size = 32,
	weight = 500,
	antialias = true
})

function ba.OpenRating(admname, admsid)
	local fr = ui.Create("ui_frame", function(self)
		self:SetTitle("Оценка администратора")
		self:SetSize(385, 140)
		self:Center()
		self:MakePopup()
		self.PaintOver = function(self)
			draw.SimpleText( "Как бы вы оценили работу " .. admname .. "?", "RatingFont", 5, 135, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_BOTTOM )
		end
		self.OnClose = function()
			net.Start("ba.closeRatingAdmin")
			net.SendToServer()
		end
	end)
	
	local cur_rate = 0
	
	for i = 1, 5 do
		ui.Create("DImageButton", function(self)
			self:SetText("")
			self:SetSize(64, 64)
			self:SetPos( -55 + 70 * i + 5, 40)
			self:SetImage( ratingAdmin )
			self.Paint = function( self, w, h )
				if cur_rate >= i then
					self:SetColor( Color( 255, 255, 255, 255 ) )
				else
					self:SetColor( Color( 110, 110, 110, 255 ) )
				end
			end
			self.OnCursorEntered = function()
				cur_rate = i
			end
			self.DoClick = function()
				net.Start("ba.closeRatingAdmin")
					net.WriteString(admsid)
					net.WriteString(admname)
					net.WriteFloat(cur_rate)
				net.SendToServer()
				notification.AddLegacy( "Вы оценили работу " .. admname .. " на " .. cur_rate .. " баллов!", NOTIFY_GENERAL, 5 )
				fr:Remove()
			end
		end, fr)
	end
end

net.Receive('ba.openRatingPlayer', function()
	ba.OpenRating(net.ReadString(), net.ReadString())
end)

net.Receive('OpenMenuUser', function()
	local targ = net.ReadEntity()
	local time1 = net.ReadFloat()
	timer.Create("MrPupirWorkspace.CheckValidPlayer_u", 1, 0, function()
		if targ:IsValid() then 
			return true
		else
			fractive11:Remove()
			return false
		end
	end)
	fractive11 = ui.Create("ui_frame", function(self)
		self:SetTitle("Активная жалоба")
		self:SetSize(410, 101)
		self:SetPos(ScrW() / 2 - 410 / 2, 0)
		self:ShowCloseButton( false )
		self.PaintOver = function(self)
			draw.SimpleText( "Вашей жалобой занимается: ", "RatingFont", 76, 50, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_BOTTOM )
			draw.SimpleText( targ:NameID(), "RatingFont", 76, 70, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_BOTTOM )
			draw.SimpleText( "Прошло: " .. ba.str.FormatTime(CurTime() - time1), "RatingFont1", 76, 100, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_BOTTOM )
		end
	end)
	
	ui.Create( "AvatarImage", function(self)
		self:SetSize( 64, 64 )
		self:SetPos( 5, 33 )
		self:SetPlayer( targ, 64 )
	end, fractive11)
end)

net.Receive('OpenMenuAdmin', function()
	local targ = net.ReadEntity()
	local time1 = net.ReadFloat()
	timer.Create("MrPupirWorkspace.CheckValidPlayer_a", 1, 0, function()
		if targ:IsValid() then 
			return true
		else
			fractive11:Remove()
			return false
		end
	end)
	fractive11 = ui.Create("ui_frame", function(self)
		self:SetTitle("Активная жалоба")
		self:SetSize(430 + 111, 151)
		self:SetPos(ScrW() / 2 - (430 + 111) / 2, 0)
		self:ShowCloseButton( false )
		self.PaintOver = function(self)
			draw.SimpleText( "Вы занимаетесь жалобой: ", "RatingFont", 76, 50, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_BOTTOM )
			draw.SimpleText( targ:NameID(), "RatingFont", 76, 70, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_BOTTOM )
			draw.SimpleText( "Прошло: " .. ba.str.FormatTime(CurTime() - time1), "RatingFont1", 76, 100, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_BOTTOM )
		end
	end)
	
	ui.Create( "AvatarImage", function(self)
		self:SetSize( 64, 64 )
		self:SetPos( 5, 33 )
		self:SetPlayer( targ, 64 )
	end, fractive11)

	ui.Create( "ui_button", function(self)
		self:SetSize( 176, 45 )
		self:SetPos( 206, 100 )
		self:SetText("Телепортироваться")
		self.DoClick = function(self)
			RunConsoleCommand("ba", "goto", targ:SteamID())
		end
	end, fractive11)

	ui.Create( "ui_button", function(self)
		self:SetSize( 196, 45 )
		self:SetPos( 5, 100 )
		self:SetText("Телепортировать к себе")
		self.DoClick = function(self)
			RunConsoleCommand("ba", "tp", targ:SteamID())
		end
	end, fractive11)
	
	ui.Create( "ui_button", function(self)
		self:SetSize( 147, 45 )
		self:SetPos( 388, 100 )
		self:SetText("Закрыть жалобу")
		self.DoClick = function(self)
			RunConsoleCommand("ba", "creq", targ:SteamID())
		end
	end, fractive11)
end)

net.Receive('CloseMenusWow', function()
	fractive11:Remove()
end)
