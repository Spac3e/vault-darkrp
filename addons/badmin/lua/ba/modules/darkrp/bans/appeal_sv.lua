util.AddNetworkString("badmin::sendAppeal")
net.Receive("badmin::sendAppeal", function(len, p)
  --$Кд на отправку аппеляци
  if p.NextAppealSend and p.NextAppealSend > CurTime() then
	  rp.Notify(p, NOTIFY_ERROR, term.Get('PleaseWaitX'), math.ceil(p.NextAppealSend - CurTime()))
	  return ""
	end
  if not p:IsBanned() then
    rp.Notify(p, NOTIFY_ERROR, "Вы не в бане")
    return ""
  end

  local pl_nick = net.ReadString()
  local pl_sid = net.ReadString()
  local discordik = net.ReadString()
  local adm_nick = net.ReadString()
  local adm_sid = net.ReadString()
  local ban_reason = net.ReadString()
  local reason = net.ReadString()
  local dokva = net.ReadString()

  --$Система поиска пидорасов активирована
  if #pl_nick <= 0 or --$Если не были отправлены стринги мне по почте или там пустота
  #pl_sid <= 0 or
  #discordik <= 0 or
  #adm_nick <= 0 or
  #adm_sid <= 0 or
  #ban_reason <= 0 or
  #reason <= 0 or 
  #dokva <= 0 then
    return rp.Notify(p, NOTIFY_ERROR, "Все поля должны быть заполнены!")
  end

  if #pl_nick > ba.Appeal.MaxSymbols or --$Крашеры через string.rep, пока-пока
  #pl_sid > ba.Appeal.MaxSymbols or
  #discordik > ba.Appeal.MaxSymbols or
  #adm_nick > ba.Appeal.MaxSymbols or
  #adm_sid > ba.Appeal.MaxSymbols or
  #ban_reason > ba.Appeal.MaxSymbols or
  #reason > ba.Appeal.MaxSymbols then 
    for k,v in ipairs(player.GetStaff()) do
      ba.notify(v, p:Name() .. " был заподозрен в попытке эксплоатировать систему апелляций банов, следите за ним!")
    end
    return rp.Notify(p, NOTIFY_ERROR, "пошёл нахуй, пидарас")
  end

  local data = {
		username = "Mecrury Helper",
        content = [[
---------------------------------------------------------------------------
||:exclamation:Новая заявка от **]] .. pl_nick .. [[** к **]] .. adm_nick .. [[**:exclamation:||

1) Ник забаненного: **]] .. pl_nick .. [[**
2) SteamID забаненного: **]] .. pl_sid .. [[**
3) Discord забаненного: **]] .. discordik .. [[**
4) Ник администратора: **]] .. adm_nick .. [[**
5) SteamID администратора: **]] .. adm_sid .. [[**
6) Причина бана: **]] .. ban_reason .. [[**
7) Нарушение администратора по мнению забаненного: **]] .. reason .. [[**
8) Доказательство нарушения: **]] .. dokva .. [[**
:loudspeaker:
---------------------------------------------------------------------------
]],
		avatar_url = "https://i.imgur.com/i.png",
	}

	local gayhook = ""
	http.Post("https://vastrp.ru/discord/send.php", {
		content = util.TableToJSON(data), webhook = gayhook
	})
  rp.Notify(p, NOTIFY_GENERIC, "Апелляция была успешно отправлена!")
    p.NextAppealSend = CurTime() + 60
end)