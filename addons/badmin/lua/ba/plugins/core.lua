-------------------------------------------------
-- Setid
-------------------------------------------------

Adminmode_in_rpjob = {
	"STEAM_0:0:0",
}

Adminmode_curators = {
	"root",
	"sudo-root",
	"headcurator",
	"curator",
    "head-admin",
    "owner",
}

local alloweddo = {
	["STEAM_0:0:0"] = true
}

ba.cmd.Create('Info', function(pl, args)
local cmnd = '!info'
pl:ChatPrint('Имя: ' .. args.target:Name())
pl:ChatPrint('SteamID: ' .. args.target:SteamID())
pl:ChatPrint('Ранг: ' .. args.target:GetUserGroup())
pl:ChatPrint('Отыграно: ' .. ba.str.FormatTime(args.target:GetPlayTime()))
args.target:ChatPrint('какой-то человек использовал на вас команду: ' .. cmnd)
end)
:AddParam('player_entity', 'target')
:SetFlag('v')
:SetHelp('Информация')

-------------------------------------------------
-- Set Group
-------------------------------------------------
term.Add('SetRank', '# установил #\' ранг # # #')

ba.cmd.Create('SetGroup', function(pl, args)
	if args.exp_time and (not args.exp_rank) then
		ba.notify_err(pl, term.Get('MissingArg'), 'exp_rank')
		return
	end
        
    	if pl:IsPlayer() then
		if  args.rank == "headcurator" or args.rank == "root" or args.rank == "sudo-root" or args.rank == "superior" then 
			return ba.notify(pl, "Крут челлл :/:/:/:/")
		end
	end
        
	ba.data.SetRank(args.target, args.rank, (args.exp_rank or args.rank) , (args.exp_time and os.time() + args.exp_time or 0), function(data)
		ba.notify_all(term.Get('SetRank'), pl, args.target, args.rank, (args.exp_rank and 'expiring to ' .. args.exp_rank or ''), (args.exp_time and 'in ' .. args.raw.exp_time or ''))
	end)
    args.target:ConCommand('spawnmenu_reload')
end)
:AddParam('player_steamid', 'target')
:AddParam('rank', 'rank')
:AddParam('time', 'exp_time', 'optional')
:AddParam('rank', 'exp_rank', 'optional')
:SetFlag('*')
:SetHelp('Изменяет ранг игрока. Пример: /setgroup (ник) (ранг)')
:SetIcon('icon16/group.png')

-------------------------------------------------
-- Set Model
-------------------------------------------------
ba.cmd.Create('SetModel', function(pl, args)
	args.target:SetModel(args.model)
end)
:AddParam('player_entity', 'target')
:AddParam('string', 'model')
:SetFlag('*')
:SetHelp('Меняет модельку')
:SetIcon('icon16/Heart.png')

-------------------------------------------------
-- Custom models
-------------------------------------------------

-------------------------------------------------
-- Adminmode
-------------------------------------------------

term.Add('EnterAdminmode', '# включил админ-мод.')
term.Add('ExitAdminmode', '# выключил админ-мод.')

ba.cmd.Create('AdminMode', function(pl, args)
	if pl:GetBVar('adminmode') then
		//ba.notify_staff(term.Get('ExitAdminmode'), pl)
		if not pl:IsSuperAdmin() and not table.HasValue( Adminmode_in_rpjob, pl:SteamID( ) ) and not table.HasValue( Adminmode_curators, pl:GetUserGroup()) then 
			pl:ChangeTeam(TEAM_CITIZEN)
		else
			ba.notify_staff(term.Get('ExitAdminmode'), pl)
			pl:SetBVar('adminmode',false)
            pl:SetBVar('adminmode.authorized', false)
		end
	else
		//ba.notify_staff(term.Get('EnterAdminmode'), pl)
		if not pl:IsSuperAdmin() and not table.HasValue( Adminmode_in_rpjob, pl:SteamID( ) ) and not table.HasValue( Adminmode_curators, pl:GetUserGroup()) then 
			pl:ChangeTeam(TEAM_ADMIN)
		else
			ba.notify_staff(term.Get('EnterAdminmode'), pl)
			pl:SetBVar('adminmode',true)
            pl:SetBVar('adminmode.authorized', true)
		end
	end
end)
:SetFlag('M')
:SetHelp('Включить админ мод')

hook.Add("OnPlayerChangedTeam","sz0",function(pl,bef,aff) 
	if aff == TEAM_ADMIN then 
		pl:SetBVar('adminmode',true)
	end
	if bef == TEAM_ADMIN then 
		pl:SetBVar('adminmode',false)
	end
end)

-------------------------------------------------
-- Help
-------------------------------------------------
if CLIENT then
    local function k(l)
        local m = ''

        for n, o in pairs(l) do
            m = m .. '(' .. (i[n] or '???') .. ')'
        end

        return m
    end

    local function p(q, r)
        local m = '\n/' .. q

        return m
    end

    local s = {}

    function s:Init()
        self.SearchBar = ui.Create('DTextEntry', self)
        self.SearchBar:RequestFocus()

        self.SearchBar.OnChange = function(t)
            self.PlayerList:AddCommands(t:GetValue())
        end

        self.PlayerList = ui.Create('ui_listview', self)

        self.PlayerList.AddCommands = function(t, u)
            u = u and u:Trim()
            t:Reset()
            local v = 0

            for n, o in pairs(ba.cmd.GetTable()) do
                if n ~= o:GetName() and not u then continue end

                if (not o:GetFlag() or LocalPlayer():HasFlag(o:GetFlag())) and (not u or u and string.find(n, u:lower(), 1, true) or u and o:GetHelp() and string.find(o:GetHelp():lower(), u:lower(), 1, true)) then
                    local w = t:AddRow((n ~= o:GetName() and '' or '') .. o:GetNiceName() .. (o:GetHelp() and '\n' .. o:GetHelp() or ''))
                    local x = 45
                    x = o:GetHelp() and x + 25 or x
                    w:SetTall(x)
                    w:SetContentAlignment(4)
                    w:SetTextInset(5, 0)
                    v = v + 1
                end
            end

            if v <= 0 then
                t:AddSpacer('Команды не найдены!')
            end
        end

        self.PlayerList:AddCommands()
    end

    function s:PerformLayout()
        self.SearchBar:SetPos(0, 0)
        self.SearchBar:SetSize(self:GetWide(), 25)
        self.PlayerList:SetPos(0, 30)
        self.PlayerList:SetSize(self:GetWide(), self:GetTall() - 30)
    end

    function s:OnSelection(w, a)
    end

    function s:DockToFrame()
        local r = self:GetParent()
        local y, z = r:GetDockPos()
        self:SetPos(y, z)
        self:SetSize(r:GetWide() - 10, r:GetTall() - (z + 5))
    end

    vgui.Register('ba_help_panel', s, 'Panel')
end

ba.cmd.Create('Help')
:RunOnClient(function()
    local A = ui.Create('ui_frame', function(self)
        self:SetSize(600, ScrH() * 0.5)
        self:SetTitle('Справка по командам')
        self:Center()
        self:MakePopup()
    end)

    ui.Create('ba_help_panel', function(self, r)
        self:SetPos(5, 32)
        self:SetSize(r:GetWide() - 10, r:GetTall() - 37)
    end, A)
end)
:SetHelp'Сообщает вам полезную информацию о командах'

-------------------------------------------------
-- Rules
-------------------------------------------------
ba.cmd.Create("rules"):RunOnClient(function(args)
	local w, h = ScrW() * .65, ScrH() * .8

	local fr = ui.Create('ui_frame', function(self)
		self:SetTitle('Правила')
		self:SetSize(w, h)
		self:MakePopup()
		self:Center()
	end)
	
	ui.Create('HTML', function(self, p)
		self:SetPos(1, 31)
		self:SetSize(w - 1, h - 31) 
		self:OpenURL('https://docs.google.com/document/d/1IjxgBoUbymItoaYB4Rf74SK5if2EcMXGtiuP_Kwth6E/edit#')
		self.Paint = function(self, w, h)
			draw.RoundedBox( 0, 0, 0, w, h, Color(255, 255, 255) )
		end
	end, fr)
end)
:SetHelp('Открыть правила сервера')
:AddAlias('rules')