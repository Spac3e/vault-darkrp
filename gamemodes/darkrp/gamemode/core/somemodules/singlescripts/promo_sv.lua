local promos = {
	"vaultdarkrp"
}

rp.AddCommand("promo", function(pl, args)
	file.CreateDir("promos")
	if table.HasValue(promos, args) then
		if args == "vaultdarkrp" then
			if (pl:GetPlayTime() and pl:GetPlayTime() < 0) or pl:GetPlayTime() < 0 then
				return ba.notify_err(pl, "Вы должны отыграть на сервере 3 часа прежде чем активировать промокод!")
			end

			if file.Exists("promos/vaultdarkrp/"..pl:SteamID64()..".txt", "DATA") then
				ba.notify_err(pl, "Вы уже использовали данный промокод!")
			else
				file.CreateDir("promos/vaultdarkrp")
				file.Write("promos/vaultdarkrp/"..pl:SteamID64()..".txt", "")
				pl:AddMoney(45000)
				pl:AddIGSFunds(50, "Использование промокода 'vaultdarkrp'")
				ba.notify(pl, "Вы получили: $45000 и 50 Rub на донат счёт за использование промокода 'vaultdarkrp'!")
			end
		end
	else
		ba.notify_err(pl, "Промокод '"..args.."' не был найден!")
	end
end)
:AddParam(cmd.STRING)