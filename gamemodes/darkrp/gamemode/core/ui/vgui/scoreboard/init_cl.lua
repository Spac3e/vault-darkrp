if IsValid(rp.Scoreboard) then rp.Scoreboard:Remove() end

hook('InitPostEntity', 'rp.scoreboard.InitPostEntity', function()
	http.Fetch('http://ip-api.com/json/', function(bodyj)
		tablej = util.JSONToTable(bodyj)
		for k, v in pairs(tablej) do
			countryCode = tablej['countryCode']
	    	net.Start 'rp::ScoreboardStats'
				net.WriteString(countryCode)
			net.SendToServer()
	    	break
	    end
	end)
end)

function GM:ScoreboardShow()
	if (not IsValid(rp.Scoreboard)) then
		rp.Scoreboard = ui.Create 'rp_scoreboard'
	end

	rp.Scoreboard:Open()
	rp.Scoreboard:MakePopup()
end

function GM:ScoreboardHide()
	if IsValid(rp.Scoreboard) then
		rp.Scoreboard:Close()
	end
end
