timer.Simple(0.5, function()
	local GM = GAMEMODE
	/*памагите панять, что такое клиент*/
end)


-- Вайс чат
local Talkers = {}
hook('PlayerStartVoice', 'rp.hud.PlayerStartVoice', function(pl)
	Talkers[pl] = true
end)

hook('PlayerEndVoice', 'rp.hud.PlayerEndVoice', function(pl)
	Talkers[pl] = nil
end)


local GUIToggled = false
local mouseX, mouseY = ScrW() / 2, ScrH() / 2
function GM:ShowSpare1()
	if LocalPlayer():IsBanned() then return end
	GUIToggled = not GUIToggled

	if GUIToggled then
		gui.SetMousePos(mouseX, mouseY)
	else
		mouseX, mouseY = gui.MousePos()
	end
	gui.EnableScreenClicker(GUIToggled)
end

local FKeyBinds = {
	["gm_showhelp"] = "ShowHelp",
	["gm_showteam"] = "ShowTeam",
	["gm_showspare1"] = "ShowSpare1",
	["gm_showspare2"] = "ShowSpare2"
}

function GM:PlayerBindPress(ply, bind, pressed)
	if LocalPlayer():IsBanned() then return end

	local bnd = string.match(string.lower(bind), "gm_[a-z]+[12]?")
	if bnd and FKeyBinds[bnd] and GAMEMODE[FKeyBinds[bnd]] then
		GAMEMODE[FKeyBinds[bnd]](GAMEMODE)
	end
	return
end

local surface_CreateFont = surface.CreateFont local screenScale = ScreenScale for i = 1, 35 do 	surface_CreateFont("Roboto_"..i, { 		font = "Roboto", 		size = screenScale(i), 		extended = true, 		weight = 1000, 	}) end local sc = surface.CreateFont local Fonts = {} Fonts[ "Roboto" ] = "Roboto Light" Fonts[ "RobotoM" ] = "Roboto Medium" Fonts['RobotoR'] = 'Roboto Regular' for a,b in pairs( Fonts ) do     for k = 0, 500 do         sc( a.."_"..k, { font = b, size = k, weight = 300, antialias = true, extended = true } )     end end local Shadow = {} Shadow['RobotoRS'] = 'Roboto Regular' for a,b in pairs( Shadow ) do     for k = 0, 150 do         sc( a.."_"..k, { font = b, size = k, weight = 300, antialias = true, extended = true, blursize=5} )     end end local d_s = draw.SimpleText function draw.ShadowText(text,font,x,y,color,a,b)     rp.ShadowText(text,font,x,y,color,a,b) end function rp.ShadowText(text,font_size,x,y,color,a,b)     a = a or 0.5     b = b or 0.5     if font_size:find('DonateM_') then         font_size = string.gsub(font_size,'DonateM_','')         font_size = ScreenScale(tonumber(font_size))     elseif font_size:find('RobotoL_') then         font_size = string.gsub(font_size,'RobotoL_','')       elseif font_size:find('RobotoM_') then         font_size = string.gsub(font_size,'RobotoM_','')               elseif font_size:find('RobotoR_') then         font_size = string.gsub(font_size,'RobotoR_','')                     elseif font_size:find('Roboto_') then         font_size = string.gsub(font_size,'Roboto_','')     else         font_size = 24     end    draw.BeautyText(text,'RobotoR_' .. math.ceil(font_size),'RobotoRS_' .. math.ceil(font_size),x,y,color,a/2,b/2) end  local function charWrap(text, pxWidth, maxWidth)     local total = 0     text = text:gsub(utf8.charpattern, function(char)         total = total + surface.GetTextSize(char)         if total >= pxWidth then             total = 0             pxWidth = maxWidth             return "\n" .. char         end         return char     end)     return text, total end function surface.textWrap(text, font, pxWidth)     local total = 0     surface.SetFont(font)     local spaceSize = surface.GetTextSize(' ')     text = text:gsub("(%s?[%S]+)", function(word)             local char = string.sub(word, 1, 1)             if char == "\n" or char == "\t" then                 total = 0             end             local wordlen = surface.GetTextSize(word)             total = total + wordlen             if wordlen >= pxWidth then                 local splitWord, splitPoint = charWrap(word, pxWidth - (total - wordlen), pxWidth)                 total = splitPoint                 return splitWord             elseif total < pxWidth then                 return word             end             if char == ' ' then                 total = wordlen - spaceSize                 return '\n' .. string.sub(word, 2)             end             total = wordlen             return '\n' .. word         end)      return text end ALIGN_LEFT = 0 ALIGN_CENTER = 0.5 ALIGN_RIGHT = 1 ALIGN_TOP = 1 ALIGN_BOTTOM = 0 local shadow_x = 1 local shadow_y = 1 local col_face = Color(255,255,255,255) local col_shadow = Color(0,0,0,255) local col_half_shadow = Color(0,0,0,200) local col_money = Color(64,192,32) function draw.BeautyText( str, font, font_shadow, x, y, color, xalign, yalign )     font = font or "nx_hud"     str = str or ' '     surface.SetFont( font )     local tw, th = surface.GetTextSize( str )     x = (x or 0) - tw * (xalign or 3)     y = (y or 0) - th * (yalign or 3)     surface.SetTextPos( x, y )     if font_shadow then         surface.SetTextPos( x, y+3 )         surface.SetTextColor( col_shadow )         surface.SetFont( font_shadow )         surface.DrawText( str )         surface.SetTextPos( x, y )     end 	surface.SetTextPos( x + shadow_x , y + shadow_y )     surface.SetTextColor( col_half_shadow )     surface.SetFont( font )     surface.DrawText( str )     surface.SetTextColor( color or col_face )     surface.SetTextPos( x, y )     surface.DrawText( str )     return tw, th end