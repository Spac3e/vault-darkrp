
if SERVER then
	util.AddNetworkString("ba::ViewRating")
	util.AddNetworkString("ba::ViewRatingLogs")
end

ba.AddCommand('toprating', function(pl)
	local db = ba.data.GetDB()
	db:query('SELECT * FROM ba_rating ORDER BY rate DESC', function(data)
		db:query('SELECT a_steamid, avg(rate) as avgr from ba_ratinglogs group by a_steamid', function(data1)
			net.Start('ba::ViewRating')
				net.WriteTable(data)
				net.WriteTable(data1)
			net.Send(pl)
		end)
	end)
end)
:SetHelp 'Посмотреть рейтинг администраторов'
:AddAlias 'top'

ba.AddCommand('View Rating Logs', function(pl)
	local db = ba.data.GetDB()
	db:query('SELECT * FROM ba_ratinglogs ORDER BY data', function(data)
		net.Start('ba::ViewRatingLogs')
			net.WriteTable(data)
		net.Send(pl)
	end)
end)
:SetFlag('w')
:SetHelp 'Посмотреть логи рейтинга администраторов'
:AddAlias 'raitlogs'

if SERVER then return end

local fr
net.Receive('ba::ViewRatingLogs', function(len)
	local tbl = net.ReadTable()

	if (IsValid(fr)) then fr:Remove() end

	fr = ui.Create('ui_frame', function(self)
		self:SetSize(800, 600)
		self:SetTitle("Логи рейтинга")
		self:Center()
		self:MakePopup()
	end)

	local list = ui.Create('DListView', function(self, p)
		self:Dock(FILL)
		self:SetSize(p:GetWide(), p:GetTall() - 35)
		self:SetMultiSelect(false)
		self:AddColumn('№'):SetFixedWidth(30)
		self:AddColumn('SteamID Админа'):SetFixedWidth(200)
		self:AddColumn('Рейтинг')
		self:AddColumn("Дата"):SetFixedWidth(200)
		self:AddColumn("SteamID Игрока"):SetFixedWidth(200)
		self:SetHeaderHeight(25)
		self:SortByColumn( 1 )
		self:SetSortable(false)
	end, fr)

	for k, v in pairs(tbl) do
		list:AddLine(k, util.SteamIDFrom64(v.a_steamid), v.rate, os.date( "%x - %X", v.data ), util.SteamIDFrom64(v.p_steamid)).Copy = v.a_steamid
	end
end)

local fr
net.Receive('ba::ViewRating', function(len)
	local tbl = net.ReadTable()
	local tblavg = net.ReadTable()

	if (IsValid(fr)) then fr:Remove() end

	fr = ui.Create('ui_frame', function(self)
		self:SetSize(800, 600)
		self:SetTitle("Таблица рейтинга")
		self:Center()
		self:MakePopup()
	end)

	local list = ui.Create('DListView', function(self, p)
		self:Dock(FILL)
		self:SetSize(p:GetWide(), p:GetTall() - 35)
		self:SetMultiSelect(false)
		self:AddColumn('Имя'):SetFixedWidth(300)
		self:AddColumn('SteamID'):SetFixedWidth(200)
		self:AddColumn("Рейтинг")
		self:AddColumn("Всего баллов")
		self:SetHeaderHeight(25)
		self:SortByColumn(4)
		self:SetSortable(false)
	end, fr)
	for _, v in pairs(tbl) do
		v.rateavg = 0
		for _, vv in pairs(tblavg) do
			if v.steamid == vv.a_steamid then
				v.rateavg = vv.avgr
			end
		end
		list:AddLine(v.nameid, util.SteamIDFrom64(v.steamid), math.Round(v.rateavg, 1) .. "/5", v.rate).Copy = v.steamid
	end
end)