local LP = LocalPlayer()
local Servers = {
	{

		Name = "FUG GIGGERS",

		ServerIP = '228:27015',

	},	
}

local function createSitSyncFrame(context)

	local LP = LocalPlayer()

	ui.Create("ui_frame", function(self)

		FrameServers = self



		local w = 200



		self:SetSize(w, #Servers * 30 + 38)

		self:SetPos(ScrW() - self:GetWide() - 10, (ScrH() - self:GetTall()) * 0.5)

		self:ShowCloseButton(true)

		self:SetTitle("Сервера")

		self:SetMouseInputEnabled(true)

		self:SetDraggable(false)



		for k, v in ipairs(Servers) do

			local btn = ui.Create("DButton", function(btn)

				btn:Dock(FILL)

				btn:DockMargin(0,5,0,0)

				btn:SetTall(30)

				btn:SetText(v.Name)

				btn:SetFont("ui.24")


				btn.DoClick = function()

					ui.BoolRequest("Переход",' Вы точно хотите уехать с CLRP#1?', function(ans)
						if (ans == true) then
							LP:ConCommand("connect nil")
						end
					end)	
				end

			end, self)

		end

	end, context)

end


local Menu = {}
local context_menu_pos = "left"

C_LANGUAGE_MONEY = "Дать денег игроку под прицелом"
C_LANGUAGE_MONEY_DESCRIPTION = "Сколько вы хотите дать ему денег?"

C_LANGUAGE_DEMOTE = "Уволить"
C_LANGUAGE_DEMOTE_DESCRIPTION = "Почему вы хотите уволить игрока?"

C_LANGUAGE_WANTED = "Подать в розыск"
C_LANGUAGE_WANTED_DESCRIPTION = "Почему вы хотите подать этого человека в розыск?"

C_LANGUAGE_UNWANTED = "Убрать из розыска"

C_LANGUAGE_WARRANT = "Запрос на обыск"
C_LANGUAGE_WARRANT_DESCRIPTION = "По какой причине вы хотите обыскать этого человека?"

C_LANGUAGE_WARRANT_PROP = "Запрос на обыск"

C_LANGUAGE_GIVE_LICENSE = "Дать лицензию"

C_LANGUAGE_MONEY_DROP = "Выкинуть деньги"
C_LANGUAGE_MONEY_DROP_DESCRIPTION = "Сколько вы хотите выкинуть денег?"

C_LANGUAGE_MONEY_GIVE = "Дать денег игроку под прицелом"
C_LANGUAGE_MONEY_GIVE_DESCRIPTION = "Сколько вы хотите дать ему денег?"

C_LANGUAGE_DROP = "Выкинуть оружие"

C_LANGUAGE_LOTTERY = "Лотерея"


C_LANGUAGE_UNOWN_ALL = "Продать все двери"
C_LANGUAGE_UNOWN_AAA = "Донат"

C_LANGUAGE_DONATE = "Донат"

C_LANGUAGE_NAME = "Изменить имя"

C_LANGUAGE_LOCKDOWN = "Комендантский час"
C_LANGUAGE_UNLOCKDOWN = "Убрать комендантский час"

C_LANGUAGE_AGENDA = "Set agenda"
C_LANGUAGE_AGENDA_DESCRIPTION = "Enter new agenda"

C_LANGUAGE_CUSTOM_JOB = "Set custom job"
C_LANGUAGE_CUSTOM_JOB_DESCRIPTION = "Enter new custom job"

C_LANGUAGE_RPNAME = "Поменять имя"
C_LANGUAGE_RPNAME_DESCRIPTION = "Введите имя"


local function FindNearestEntity( className, pos )
    local nearest_ent,last_distance
    for _, ent in pairs( ents.FindByClass( className ) ) do
        local distance = pos:Distance(ent:GetPos())

        if not last_distance then
            last_distance = distance
            nearest_ent = ent
            continue
        end

        if distance < last_distance then
            last_distance = distance
            nearest_ent = ent
        end
    end

    return nearest_ent;
end

function DrawPosInfo(icon, pos, text)
    local d = math.floor(LocalPlayer():GetPos():Distance(pos)/100)
    local pos = pos:ToScreen()
    local x, y = math.Clamp(pos.x, 0, ScrW() - 26), math.Clamp(pos.y, 0, ScrH() - 26)

    if pos.x > 0 and pos.x < ScrW() and pos.y > 0 and pos.y < ScrH() then
        local h = select(2, draw.SimpleText(text, 'ui.22', pos.x + 30, pos.y, Color(255,255,255), 0, 0))

        draw.SimpleText("Дистанция: " .. d .. "m", 'ui.22', pos.x + 30, pos.y + h, Color(255,255,255), 0, 0)
    end

    surface.SetDrawColor(255, 255, 255, 255)
    surface.SetMaterial(Material(icon))
    surface.DrawTexturedRect(x, y, 21, 21)
end

local gpspos = {}
function AddGPSPos(pos,time,text,icon)
    local key = text
    gpspos[key] = {p = pos, i = icon}

    timer.Simple(time,function()
        if gpspos[key] ~= nil then
            gpspos[key] = nil
        end
    end)
end

hook.Add("HUDPaint", "sup.gps", function()
    for k,v in pairs(gpspos) do
        DrawPosInfo(v.i, v.p, k)

        if LocalPlayer():GetPos():DistToSqr(v.p) <= 90000 then
            if gpspos[k] ~= nil then
                gpspos[k] = nil
                chat.AddText(Color(0,255,128), "[GPS] ", Color(255,255,255), "Вы пришли к месту назначения!")
                EmitSound( Sound( "garrysmod/balloon_pop_cute.wav" ), LocalPlayer():GetPos(), 1, CHAN_AUTO, 1, 75, 0, 100 )
            end
        end
    end
end)

local gps = {
    ["Скупщик кокса"] = {Vector(-1828.022461,521.882202,64.031250), "sup/entities/druglab.png", Color(80,80,80)},
    ["Полицейский участок"] = {Vector(2270.181396,926.378174,112.031250), "sup/entities/npcs/copshop.png", Color(128,128,255)},
    ["Заправка"] = {Vector(10277.459961,581.200012,64.031250), "sup/entities/npcs/krek.png", Color(80,80,80)},
    ["Скупщик мета"] = {Vector(-1303,4116,-447), "sup/entities/npcs/meth.png", Color(115, 140, 145)},
    ["Скупщик травы"] = {Vector(-156.857513,-2741.201660,72.031250), "sup/entities/npcs/jerome.png", Color(70, 69, 55)},
    ["Банк"] = {Vector(3862.670410,-831.285400,72.031250), "sup/entities/genome.png", Color(70, 69, 55)},
    ["Автосалон"] = {Vector(737.886475,-1378.675171,72.031250), "sup/entities/druglab.png", Color(70, 69, 55)},
    ["Госпиталь"] = {Vector(7810.935059,932.075073,112.031250), "sup/entities/npcs/cigarette.png", Color(55,255,55)},
    ["Мэрия"] = {Vector(963.548279,2056.434570,112.031250), "sup/entities/npcs/mayor.png", Color(94,94,94)},
    ["Казино"] = {Vector(6413.246094,1009.707581,72.031250), "sup/entities/npcs/coffe.png", Color(94,94,94)},
}
local playersgps_points = {}
hook.Add("LocalPlayerLoad","LoadGPSPoints", function()
    net.Start("FlameRP.SendMyGpsPoint")
    net.SendToServer()
end)

net.Receive("FlameRP.SendMyGpsPoint",function(len)
    local newgps = net.ReadTable() or {}
    playersgps_points = newgps
end)

local function Option(title, icon, cmd, check)
    table.insert(Menu, {title = title, icon = icon, cmd = cmd, check = check})
end
 
local function SubMenu(title, icon, func, check)
    table.insert(Menu, {title = title, icon = icon, func = func, check = check})
end
 
local function Spacer(check)
    table.insert(Menu, {check = check})
end
 
local function Request(title, text, func)
    return function()
        ui.StringRequest(title, text, nil, function(s)
            func(s)
        end)
    end
end
 
local function isCP()
    return LocalPlayer():IsCP()
end
 
local function isMayor()
    return LocalPlayer():isMayor()
end
 
 
local function add(t)
    table.insert(Menu, t)
end
 
/* YOU CAN EDIT STUFF BELOW THIS POINT */

local paint1 = Color(36, 36, 36)

local paint2 = Color(55, 55, 55)


SubMenu("Денежные операции", "icon16/money.png", function(self)
    self:AddOption("Бросить деньги", Request("Бросить деньги", "Сколько хотите бросить денег?", function(s)
        RunConsoleCommand("rp", "dropmoney", s)
    end)):SetImage("icon16/money_delete.png")

    self:AddOption("Дать денег тому, на кого смотрите", Request("Дать денег тому, на кого смотрите", "Сколько хотите дать денег", function(s)
        RunConsoleCommand("rp", "give", s)
    end)):SetImage("icon16/money.png")
end)


Option("Купить патроны на текущее оружие", "icon16/application.png", function(s)
        RunConsoleCommand("rp", "buyammo", LocalPlayer():GetActiveWeapon().Primary.Ammo)
end)

Spacer()
 

SubMenu("GPS", "icon16/zoom.png", function(self)
    for k, v in pairs(gps) do
        self:AddOption(k, function()
            AddGPSPos(v[1],450,k,v[2])
        end, v[2], v[3])
    end

    self:AddSpacer()

    for k, v in ipairs(player.GetAll()) do
        if v:Team() == TEAM_COOK or v:Team() == TEAM_DOCTOR or v:Team() == TEAM_GUN then
            self:AddOption(v:GetJobName() .. " (" .. v:Name() .. ")", function()
                AddGPSPos(v:GetPos(),450,v:GetJobName() ,"icon16/user_red.png")
            end, "icon16/user_red.png", v:GetJobColor())
        end
    end
end)

Spacer()
 
Option(C_LANGUAGE_DROP, "icon16/gun.png", function()
    RunConsoleCommand("rp", "drop")
end)

Option("Вызвать полицию", "icon16/phone_sound.png", function(self)
    if LocalPlayer():IsCP() then chat.AddText(Color(255,125,125), "Вы не можете вызвать полицию!") return end
  ui.StringRequest("Вызов полиции", "Сообщение полиции?", "", function(text)
        net.Start("rp.GovernmentRequare")
            net.WriteString(text)
        net.SendToServer()
    end)
end)


Option("Маскировка", "icon16/arrow_out.png", function()

    rp.DisguiseMenu()

end, function() return LocalPlayer():GetTeamTable().candisguise end)
Spacer()

local randd = {
    {'dice', 'Бросить кубики'},
    {'cards', 'Вытащить карту'},
    {'roll', 'Играть в рулетку'}
}

SubMenu("Рандом", "icon16/controller.png", function(self)
    for k, v in ipairs(randd) do
            self:AddOption(v[2], function()
           
          RunConsoleCommand('rp', v[1])
            
            end)
    end
end)

SubMenu("Жесты", "icon16/thumb_up.png", function(self)
    for k, v in ipairs({'cheer', 'laugh', 'muscle', 'zombie', 'robot', 'dance', 'agree', 'becon', 'disagree', 'salute', 'wave', 'forward', 'pers'}) do
            self:AddOption(v, function()
           
		  RunConsoleCommand('act', v)
            
			end)
    end
end)

Spacer()

Option("Радио", "icon16/sound.png",
    Request("Оповещение городу", "Введите сообщение", function(s)
        RunConsoleCommand("say", "/radiobrodact " .. s)
    end),
function() return LocalPlayer():Team() == TEAM_RADIO end)

Spacer()




SubMenu(C_LANGUAGE_DEMOTE, "icon16/user_delete.png", function(self)
    for k, v in pairs(player.GetAll()) do
        if v == LocalPlayer() then continue end
        self:AddOption(v:Name(), Request(C_LANGUAGE_DEMOTE, C_LANGUAGE_DEMOTE_DESCRIPTION, function(s)
            if IsValid(v) then 
               RunConsoleCommand("rp", "demote", v:SteamID(), s)
            end
        end)):SetColor(team.GetColor(v:Team()))
    end
end)
 
Option(C_LANGUAGE_UNOWN_ALL, "icon16/door.png", function()
    RunConsoleCommand("rp", "sellall")
end)
 


 
Spacer(isCP)

SubMenu("Повесить розыск", "icon16/flag_red.png", function(self)
    for k, v in pairs(player.GetAll()) do
        if v == LocalPlayer() then continue end
        if !v:IsWanted() then
            self:AddOption(v:Name(), Request(C_LANGUAGE_WANTED, C_LANGUAGE_WANTED_DESCRIPTION, function(s)
                RunConsoleCommand("rp", "want" , v:SteamID(), s)
            end)):SetColor(team.GetColor(v:Team()))
        end
    end
end, isCP)
 
SubMenu("Снять розыск", "icon16/flag_green.png", function(self)
    for k, v in pairs(player.GetAll()) do
        if v:IsWanted() then
            self:AddOption(v:Name(), function(s)
            RunConsoleCommand("rp", "unwant" , v:SteamID(), s)
            end):SetColor(team.GetColor(v:Team()))
        end
    end
end, isCP)
 
SubMenu("Запросить ордер", "icon16/door_in.png", function(self)
    for k, v in pairs(player.GetAll()) do
        if v == LocalPlayer() then continue end
        self:AddOption(v:Name(), Request(C_LANGUAGE_WARRANT, C_LANGUAGE_WARRANT_DESCRIPTION, function(s)
            RunConsoleCommand("rp", "warrant" , v:SteamID(), s)
        end)):SetColor(team.GetColor(v:Team()))
    end
end, isCP)
 

Spacer(function() return LocalPlayer():Team() == TEAM_MAYOR end)
 
 

Option(C_LANGUAGE_LOCKDOWN, "icon16/stop.png",
    Request("Комендантский час", "Укажите причину", function(s)
        RunConsoleCommand("rp", "lockdown", s)
    end),
function() return LocalPlayer():Team() == TEAM_MAYOR && !nw.GetGlobal('lockdown') && !timer.Exists("spamlock") end) 

 
Option(C_LANGUAGE_UNLOCKDOWN, "icon16/stop.png", function(s)
    RunConsoleCommand("rp", "unlockdown")
end, function() return LocalPlayer():Team() == TEAM_MAYOR && nw.GetGlobal('lockdown') end)
 

Option("Запустить лотерею", "icon16/money_dollar.png",
    Request("Запустить лотерею", "Введите сумму вложения для запуска лотереи ($1,000 - $1,000,000)", function(s)
        cmd.Run('lottery', tostring(s))
    end),
function() return LocalPlayer():Team() == TEAM_MAYOR end)


Option("Оповещение городу", "icon16/sound.png",
    Request("Оповещение городу", "Введите сообщение", function(s)
        RunConsoleCommand("say", "/broadcast " .. s)
    end),
function() return LocalPlayer():Team() == TEAM_MAYOR end)

Option("Купить Лицензию(200$)", "icon16/application.png", function(s)
    RunConsoleCommand("say", "/buylic")
end, function() return LocalPlayer():Team() == TEAM_MAYOR end)
 
Option("Изменить Законы", "icon16/application_add.png", function(s)
    RunConsoleCommand("LawEditor")
end, function() return LocalPlayer():Team() == TEAM_MAYOR end)
 
 
Spacer()

Option("Админ-мод", "icon16/shield.png", function()
    RunConsoleCommand("ba", "adminmode")
end, function() return LocalPlayer():HasAccess('h') end)

local adminmenu = {
    {'logs', 'Логи'},
    {'menu', 'Админ-панель'},
    {'sit', 'Админ-зона'}

}

SubMenu("Админ-меню", "icon16/shield_go.png", function(self)
    for k, v in ipairs(adminmenu) do
            self:AddOption(v[2], function()
           
          RunConsoleCommand('ba', v[1])
            end) 
    end
end, function() return LocalPlayer():IsAdmin() or LocalPlayer():HasAccess('m') end)

Option("Позвать администратора", "icon16/flag_red.png", Request("Позвать администратора", "Опишите причину", function(s)
    RunConsoleCommand("say", "/report " .. s)
end))
  

Option("Выдать доступ к пропам", "icon16/plugin_add.png", function()

   rp.pp.SharePropMenu()

end)  

 
/* DO NOT EDIT STUFF BELOW THIS POINT UNLESS YOU KNOW WHAT YOU ARE DOING */
 
local menu
hook.Add("OnContextMenuOpen", "CMenuOnContextMenuOpen", function()
    if not g_ContextMenu:IsVisible() then
        local orig = g_ContextMenu.Open
        g_ContextMenu.Open = function(self, ...)
            self.Open = orig
            orig(self, ...)

            menu = vgui.Create("CMenuExtension")
            menu:SetDrawOnTop(false)
            if LocalPlayer():IsBanned() then return end

            for k, v in pairs(Menu) do
                if not v.check or v.check() then
                    if v.cmd then
                        menu:AddOption(v.title, isfunction(v.cmd) and v.cmd or function() RunConsoleCommand(v.cmd) end):SetImage(v.icon)
                    elseif v.func then
                        local m, s = menu:AddSubMenu(v.title)
                        s:SetImage(v.icon)
                        v.func(m)
                    else
                        menu:AddSpacer()
                    end
                end
            end

            menu:Open()
            if context_menu_pos == "bot" then
                menu:CenterHorizontal()
                menu.y = ScrH()
                menu:MoveTo(menu.x, ScrH() - menu:GetTall() - 8, .1, 0)
            elseif context_menu_pos == "right" then
                menu:CenterVertical()
                menu.x = ScrW()
                menu:MoveTo(ScrW() - menu:GetWide() - 8, menu.y, .1, 0)
            elseif context_menu_pos == "left" then
                menu:CenterVertical()
                menu.x = - menu:GetWide()
                menu:MoveTo(8, menu.y, .1, 0)
            else
                menu:CenterHorizontal()
                menu.y = - menu:GetTall()
                menu:MoveTo(menu.x, 30 + 8, .1, 0)
            end


            menu:MakePopup()
        end
    end
end)

hook.Add( "CloseDermaMenus", "CMenuCloseDermaMenus", function()
    if menu && menu:IsValid() then
        menu:MakePopup()
    end
end)

hook.Add("OnContextMenuClose", "CMenuOnContextMenuClose", function()
    if menu && menu:IsValid() then
    menu:Remove()
    end
end)



local f = RegisterDermaMenuForClose

local PANEL = {}

AccessorFunc( PANEL, "m_bBorder",           "DrawBorder" )
AccessorFunc( PANEL, "m_bDeleteSelf",       "DeleteSelf" )
AccessorFunc( PANEL, "m_iMinimumWidth",     "MinimumWidth" )
AccessorFunc( PANEL, "m_bDrawColumn",       "DrawColumn" )
AccessorFunc( PANEL, "m_iMaxHeight",        "MaxHeight" )

AccessorFunc( PANEL, "m_pOpenSubMenu",      "OpenSubMenu" )



function PANEL:Init()

    self:SetIsMenu( true )
    self:SetDrawBorder( true )
    self:SetDrawBackground( true )
    self:SetMinimumWidth( 100 )
    self:SetDrawOnTop( true )
    self:SetMaxHeight( ScrH() * 0.9 )
    self:SetDeleteSelf( true )
        
    self:SetPadding( 0 )
    
end


function PANEL:AddPanel( pnl )

    self:AddItem( pnl )
    pnl.ParentMenu = self
    
end

function PANEL:AddOption( strText, funcFunction )

    local pnl = vgui.Create( "CMenuOption", self )
    pnl:SetMenu( self )
    pnl:SetText( strText )
    pnl:SetTextColor( Color( 255,255,255, 255 ) )
    pnl:SetFont("ui.22")
    if ( funcFunction ) then pnl.DoClick = funcFunction end
    
    self:AddPanel( pnl )
    
    return pnl

end

function PANEL:AddCVar( strText, convar, on, off, funcFunction )

    local pnl = vgui.Create( "DMenuOptionCVar", self )
    pnl:SetMenu( self )
    pnl:SetText( strText )
    pnl:SetTextColor( Color( 255,255,255, 255 ) )
    pnl:SetFont("contextmenu")
    if ( funcFunction ) then pnl.DoClick = funcFunction end
    
    pnl:SetConVar( convar )
    pnl:SetValueOn( on )
    pnl:SetValueOff( off )
    
    self:AddPanel( pnl )
    
    return pnl

end

function PANEL:AddSpacer( strText, funcFunction )

    local pnl = vgui.Create( "DPanel", self )
    pnl.Paint = function( p, w, h )
        surface.SetDrawColor( Color( 55, 55, 55, 255 ) )
        surface.DrawRect( 0, 0, w, h )
    end
    
    pnl:SetTall( 1 )    
    self:AddPanel( pnl )
    
    return pnl

end

function PANEL:AddSubMenu( strText, funcFunction )

    local pnl = vgui.Create( "CMenuOption", self )
    local SubMenu = pnl:AddSubMenu( strText, funcFunction )

    pnl:SetText( strText )
    pnl:SetTextColor( Color( 255,255,255, 255 ) )
    pnl:SetFont("ui.22")
    if ( funcFunction ) then pnl.DoClick = funcFunction end

    self:AddPanel( pnl )

    return SubMenu, pnl

end

function PANEL:Hide()

    local openmenu = self:GetOpenSubMenu()
    if ( openmenu ) then
        openmenu:Hide()
    end
    
    self:SetVisible( false )
    self:SetOpenSubMenu( nil )
    
end

function PANEL:OpenSubMenu( item, menu )
    local openmenu = self:GetOpenSubMenu()
    if ( IsValid( openmenu ) ) then
        if ( menu && openmenu == menu ) then return end
        self:CloseSubMenu( openmenu )
    end
    if ( !IsValid( menu ) ) then return end
    local x, y = item:LocalToScreen( self:GetWide(), 0 )
    menu:Open( x-3, y, false, item )
    self:SetOpenSubMenu( menu )
end


function PANEL:CloseSubMenu( menu )

    menu:Hide()
    self:SetOpenSubMenu( nil )

end


function PANEL:Paint( w, h )

    if ( !self:GetDrawBackground() ) then return end
    
    draw.OutlinedBox(0,0,w,h,paint1,paint2)
end

function PANEL:ChildCount()
    return #self:GetCanvas():GetChildren()
end

function PANEL:GetChild( num )
    return self:GetCanvas():GetChildren()[ num ]
end

function PANEL:PerformLayout()

    local w = self:GetMinimumWidth()
    
    for k, pnl in pairs( self:GetCanvas():GetChildren() ) do
    
        pnl:PerformLayout()
        w = math.max( w, pnl:GetWide() )
    
    end

    self:SetWide( w )
    
    local y = 0
    
    for k, pnl in pairs( self:GetCanvas():GetChildren() ) do
    
        pnl:SetWide( w )
        pnl:SetPos( 0, y )
        pnl:InvalidateLayout( true )
        
        y = y + pnl:GetTall()
    
    end
    
    y = math.min( y, self:GetMaxHeight() )
    
    self:SetTall( y )

    derma.SkinHook( "Layout", "Menu", self )
    
    DScrollPanel.PerformLayout( self )

end


function PANEL:Open( x, y, skipanimation, ownerpanel )

    local maunal = x and y

    x = x or gui.MouseX()
    y = y or gui.MouseY()
    
    local OwnerHeight = 0
    local OwnerWidth = 0
    
    if ( ownerpanel ) then
        OwnerWidth, OwnerHeight = ownerpanel:GetSize()
    end
        
    self:PerformLayout()
        
    local w = self:GetWide()
    local h = self:GetTall()
    
    self:SetSize( w, h )
    
    
    if ( y + h > ScrH() ) then y = ((maunal and ScrH()) or (y + OwnerHeight)) - h end
    if ( x + w > ScrW() ) then x = ((maunal and ScrW()) or x) - w end
    if ( y < 1 ) then y = 1 end
    if ( x < 1 ) then x = 1 end
    
    self:SetPos( x, y )
    self:MakePopup()
    self:SetVisible( true )
    
    self:SetKeyboardInputEnabled( false )
    
end


function PANEL:OptionSelectedInternal( option )

    self:OptionSelected( option, option:GetText() )

end

function PANEL:OptionSelected( option, text )


end

function PANEL:ClearHighlights()

    for k, pnl in pairs( self:GetCanvas():GetChildren() ) do
        pnl.Highlight = nil
    end

end

function PANEL:HighlightItem( item )

    for k, pnl in pairs( self:GetCanvas():GetChildren() ) do
        if ( pnl == item ) then
            pnl.Highlight = true
        end
    end

end


function PANEL:GenerateExample( ClassName, PropertySheet, Width, Height )


end

derma.DefineControl( "CMenuExtension", "ContxtMenuC", PANEL, "DScrollPanel" )

local PANEL = {}

AccessorFunc( PANEL, "m_pMenu", "Menu" )
AccessorFunc( PANEL, "m_bChecked", "Checked" )
AccessorFunc( PANEL, "m_bCheckable", "IsCheckable" )

function PANEL:Init()

    self:SetContentAlignment( 4 )
    self:SetTextInset( 30, 0 )  
    self:SetTextColor( Color( 0,0,0 ) )
    self:SetChecked( false )

end

function PANEL:SetSubMenu( menu )

    self.SubMenu = menu

    if ( !self.SubMenuArrow ) then

        self.SubMenuArrow = vgui.Create( "DPanel", self )
        self.SubMenuArrow.Paint = function( panel, w, h ) 
            local rightarrow = {
                { x = 5, y = 3 },
                { x = w-5, y = h/2 },
                { x = 5, y = h-3 }
            }
            surface.SetDrawColor( 255, 255, 255, 255 )
            draw.NoTexture()
            surface.DrawPoly( rightarrow )
        end

    end

end

function PANEL:AddSubMenu()
    if ( !self ) then CloseDermaMenus() end
    local SubMenu = vgui.Create( "CMenuExtension", self )
        SubMenu:SetVisible( false )
        SubMenu:SetParent( self )
        SubMenu.Paint = function(p,w,h)
            draw.OutlinedBox(0,0,w,h,paint1, paint2)
        end

    self:SetSubMenu( SubMenu )

    return SubMenu

end

function PANEL:OnCursorEntered()

    if ( IsValid( self.ParentMenu ) ) then
        self.ParentMenu:OpenSubMenu( self, self.SubMenu )
        return
    end
    
    if !IsValid( self:GetParent() ) then return end

    self:GetParent():OpenSubMenu( self, self.SubMenu )

end

function PANEL:OnCursorExited()
end

function PANEL:Paint( w, h )

    if self:IsHovered() then
        draw.OutlinedBox(0,0,w,h,paint1, paint2)
    end
    return false

end

function PANEL:OnMousePressed( mousecode )

    self.m_MenuClicking = true

    DButton.OnMousePressed( self, mousecode )

end

function PANEL:OnMouseReleased( mousecode )

    DButton.OnMouseReleased( self, mousecode )

    if ( self.m_MenuClicking && mousecode == MOUSE_LEFT ) then

        self.m_MenuClicking = false
        CloseDermaMenus()

    end

end

function PANEL:DoRightClick()

    if ( self:GetIsCheckable() ) then
        self:ToggleCheck()
    end

end

function PANEL:DoClickInternal()

    if ( self:GetIsCheckable() ) then
        self:ToggleCheck()
    end

    if ( self.m_pMenu ) then

        self.m_pMenu:OptionSelectedInternal( self )

    end

end

function PANEL:ToggleCheck()

    self:SetChecked( !self:GetChecked() )
    self:OnChecked( self:GetChecked() )

end

function PANEL:OnChecked( b )
end

function PANEL:PerformLayout()

    self:SizeToContents()
    self:SetWide( self:GetWide() + 30 )

    local w = math.max( self:GetParent():GetWide(), self:GetWide() )

    self:SetSize( w, 22 )

    if ( self.SubMenuArrow ) then

        self.SubMenuArrow:SetSize( 15, 15 )
        self.SubMenuArrow:CenterVertical()
        self.SubMenuArrow:AlignRight( 4 )

    end

    DButton.PerformLayout( self )

end

function PANEL:GenerateExample()

end

derma.DefineControl( "CMenuOption", "ContxtMenuD", PANEL, "DButton" )


