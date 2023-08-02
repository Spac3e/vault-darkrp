local pi 						= math.pi
local cos 						= math.cos
local sin 						= math.sin
local floor 					= math.floor
local ceil 						= math.ceil
local sqrt 						= math.sqrt
local clamp 					= math.Clamp
local rad 						= math.rad
local round 					= math.Round
local Color 					= Color
local draw 						= draw
local render 					= render
local mesh_Begin 				= mesh.Begin
local mesh_End 					= mesh.End
local mesh_Color 				= mesh.Color
local mesh_Position 			= mesh.Position
local mesh_Normal 				= mesh.Normal
local mesh_AdvanceVertex 		= mesh.AdvanceVertex

local blur 						= Material("pp/blurscreen")
rp.util = rp.util or {}
rp.util.top_bar 				= ScrH() * .02314815 -- garbage
rp.util.top_bar_c 				= rp.util.top_bar * 0.5

rp.util.meshMaterial = CreateMaterial("rp_mesh_material", "UnlitGeneric", {
    ["$basetexture"] = "color/white",
    ["$vertexalpha"] = 1,
    ["$vertexcolor"] = 1,
    ["$nocull"] = 1,
    ["$ignorez"] = 1
})

rp.util.cin = (sin(CurTime() * 6) + 1) * .5

function rp.util.ScreenScale( size )
	return size * ( ScrH() / 480.0 )
end

function rp.util.DrawOutline(x, y, w, h, col)
	col = col or Color(0,0,0)
	surface.SetDrawColor(col)
	surface.DrawOutlinedRect(x,y,w,h)
end

function rp.util.DrawShadowText(text, font, x, y, color, x_a, y_a, color_shadow)
	color_shadow = color_shadow or Color(0, 0, 0,255)
	draw.SimpleText(text, font, x + 1, y + 1, color_shadow, x_a, y_a)
	local w,h = draw.SimpleText(text, font, x, y, color, x_a, y_a)
	return w,h
end

function rp.util.DrawBText(text, font, shadow_font, x, y, color, x_a, y_a, color_shadow)
	color_shadow = color_shadow or Color(0, 0, 0)
	draw.SimpleText(text, shadow_font, x + 1, y + 1, color_shadow, x_a, y_a)
	local w,h = draw.SimpleText(text, font, x, y, color, x_a, y_a)
	return w,h
end

function rp.util.DrawRect(x,y,w,h,col)
	surface.SetDrawColor(col)
	surface.DrawRect(x,y,w,h)
end

function rp.util.DrawBox(x,y,w,h,col,col_o)
	col_o = col_o or rp.col.Outline
	col = col or rp.col.Background

	surface.SetDrawColor(col)
	surface.DrawRect(x,y,w,h)

	rp.util.DrawOutline(x, y, w, h, col_o)
end

function rp.util.DrawBlur(panel, amount)
	local x, y = panel:LocalToScreen(0, 0)
	local scrW, scrH = ScrW(), ScrH()

	surface.SetDrawColor(255, 255, 255)
	surface.SetMaterial(blur)
	for i = 1, 3 do
		blur:SetFloat("$blur", (i / 3) * (amount or 6))
		blur:Recompute()
		render.UpdateScreenEffectTexture()
		surface.DrawTexturedRect(x * -1, y * -1, scrW, scrH)
	end
end

local cache = {}
function rp.util.GetFont(size)
	local new_size = cache[size] and cache[size] or floor(clamp(rp.util.ScreenScale(size), 1, 128))

	if not cache[size] then 
		cache[size] = new_size 
	end

	return "ui." .. new_size
end

function rp.util.DrawCircle(x, y, radius, seg)
	local cir = {}

	table.insert(cir, {
		x = x,
		y = y
	})

	for i = 0, seg do
		local a = rad((i / seg) * -360)

		table.insert(cir, {
			x = x + sin(a) * radius,
			y = y + cos(a) * radius
		})
	end

	local a = rad(0)

	table.insert(cir, {
		x = x + sin(a) * radius,
		y = y + cos(a) * radius
	})

	surface.DrawPoly(cir)
end

function rp.util.Draw3DCircle_filled(r2, segCount, col)
    local normal_up = Vector(0, 0, 2)
    local r = col.r
    local g = col.g
    local b = col.b
    local a = col.a
    local wedge_radians = pi * 2 / segCount
    local a0sin = sin(0)
    local a0cos = cos(0)
    local ang
    local a1cos, a1sin
    local p00x, p00y, p11x, p11y, p10x, p10y
    mesh_Begin(MATERIAL_TRIANGLES, segCount * 2 + 2)

    for i = 1, segCount do
        ang = i * wedge_radians
        a1cos = cos(ang)
        a1sin = sin(ang)
        p00x = 0
        p00y = 0
        local p01x = a0cos * r2
        local p01y = a0sin * r2
        p11x = 0
        p11y = 0
        p10x = a1cos * r2
        p10y = a1sin * r2
        mesh_Color(r, g, b, a)
        mesh_Normal(normal_up)
        mesh_Position(Vector(p10x, p10y, 0))
        mesh_AdvanceVertex()
        mesh_Color(r, g, b, a)
        mesh_Normal(normal_up)
        mesh_Position(Vector(p01x, p01y, 0))
        mesh_AdvanceVertex()
        mesh_Color(r, g, b, a)
        mesh_Normal(normal_up)
        mesh_Position(Vector(p00x, p00y, 0))
        mesh_AdvanceVertex()
        mesh_Color(r, g, b, a)
        mesh_Normal(normal_up)
        mesh_Position(Vector(p00x, p00y, 0))
        mesh_AdvanceVertex()
        mesh_Color(r, g, b, a)
        mesh_Normal(normal_up)
        mesh_Position(Vector(p11x, p11y, 0))
        mesh_AdvanceVertex()
        mesh_Color(r, g, b, a)
        mesh_Normal(normal_up)
        mesh_Position(Vector(p10x, p10y, 0))
        mesh_AdvanceVertex()
        a0sin = a1sin
        a0cos = a1cos
    end

    return mesh_End()
end

function rp.util.Draw3DCircle(r1, r2, segCount, gap_modNo, col)
	local normal_up = Vector(0, 0, 2)
    local r = col.r
    local g = col.g
    local b = col.b
    local a = col.a
    local wedge_radians = pi * 2 / segCount
    local a0sin = sin(0)
    local a0cos = cos(0)
    local ang
    local a1cos, a1sin
    local p00x, p00y, p11x, p11y, p10x, p10y
    mesh_Begin(MATERIAL_TRIANGLES, (segCount - floor(segCount / gap_modNo) + 1) * 2)

    for i = 1, segCount + 1 do
        ang = i * wedge_radians
        a1cos = cos(ang)
        a1sin = sin(ang)

        if i % gap_modNo ~= 0 then
            p00x = a0cos * r1
            p00y = a0sin * r1
            local p01x = a0cos * r2
            local p01y = a0sin * r2
            p11x = a1cos * r1
            p11y = a1sin * r1
            p10x = a1cos * r2
            p10y = a1sin * r2
            mesh_Color(r, g, b, a)
            mesh_Normal(normal_up)
            mesh_Position(Vector(p10x, p10y, 0))
            mesh_AdvanceVertex()
            mesh_Color(r, g, b, a)
            mesh_Normal(normal_up)
            mesh_Position(Vector(p01x, p01y, 0))
            mesh_AdvanceVertex()
            mesh_Color(r, g, b, a)
            mesh_Normal(normal_up)
            mesh_Position(Vector(p00x, p00y, 0))
            mesh_AdvanceVertex()
            mesh_Color(r, g, b, a)
            mesh_Normal(normal_up)
            mesh_Position(Vector(p00x, p00y, 0))
            mesh_AdvanceVertex()
            mesh_Color(r, g, b, a)
            mesh_Normal(normal_up)
            mesh_Position(Vector(p11x, p11y, 0))
            mesh_AdvanceVertex()
            mesh_Color(r, g, b, a)
            mesh_Normal(normal_up)
            mesh_Position(Vector(p10x, p10y, 0))
            mesh_AdvanceVertex()
        end

        a0sin = a1sin
        a0cos = a1cos
    end

    return mesh_End()
end

local function charWrap(text, pxWidth)
	local total = 0

	text = text:gsub(".", function(char)
		total = total + surface.GetTextSize(char)

		-- Wrap around when the max width is reached
		if total >= pxWidth then
			total = 0
			return "\n" .. char
		end

		return char
	end)

	return text, total
end

function rp.util.textWrap(text, font, pxWidth)
	local total = 0

	surface.SetFont(font)

	local spaceSize = surface.GetTextSize(' ')
	text = text:gsub("(%s?[%S]+)", function(word)
			local char = string.sub(word, 1, 1)
			if char == "\n" or char == "\t" then
				total = 0
			end

			local wordlen = surface.GetTextSize(word)
			total = total + wordlen

			-- Wrap around when the max width is reached
			if wordlen >= pxWidth then -- Split the word if the word is too big
				local splitWord, splitPoint = charWrap(word, pxWidth - (total - wordlen))
				total = splitPoint
				return splitWord
			elseif total < pxWidth then
				return word
			end

			-- Split before the word
			if char == ' ' then
				total = wordlen - spaceSize
				return '\n' .. string.sub(word, 2)
			end

			total = wordlen
			return '\n' .. word
		end)

	return text
end

if not rp.util.fonts_initialized then
	rp.util.fonts_initialized = true
	for i = 1, 128 do
		surface.CreateFont("rp_font_" .. i, {
			font = "Montserrat Medium",
			size = i,
			extended = true
		})

		surface.CreateFont("rp_font_" .. i .. "_shadow", {
			font = "Montserrat Medium",
			extended = true,
			blursize = 7
		})
	end
end

concommand.Add("_pos", function()
	local p = LocalPlayer():GetPos()
	local t = ("Vector(%d, %d, %d)"):format(round(p.x), round(p.y), round(p.z))
	SetClipboardText(t)
	print(t)
	print("Done!")
end)

concommand.Add("_epos", function()
	local p = LocalPlayer():EyePos()
	local t = ("Vector(%d, %d, %d)"):format(round(p.x), round(p.y), round(p.z))
	SetClipboardText(t)
	print(t)
	print("Done!")
end)

concommand.Add("_ang", function()
	local p = LocalPlayer():GetAngles()
	local t = ("Angle(%d, %d, %d)"):format(round(p.p), round(p.y), round(p.r))
	SetClipboardText(t)
	print(t)
	print("Done!")
end)

local tb = {}
local s
local id = 1

concommand.Add("_ent", function()
	local p = LocalPlayer():GetEyeTrace().Entity
	local pos = p:GetPos()
	local ang = p:GetAngles()
	if not s then
		local t = ([[{mdl = "%s", class = "%s", pos = Vector(%d, %d, %d), ang = Angle(%d, %d, %d)},]]):format(p:GetModel(), p:GetClass(), round(pos.x), round(pos.y), round(pos.z), round(ang.p), round(ang.y), round(ang.r))
		tb[id] = t
		s = true
	else
		local t = ([[{mdl = "%s", class = "%s", pos = Vector(%d, %d, %d), ang = Angle(%d, %d, %d)},]]):format(p:GetModel(), p:GetClass(), round(pos.x), round(pos.y), round(pos.z), round(ang.p), round(ang.y), round(ang.r))
		tb[id] = tb[id] .. t

		id = #tb + 1
		s = false
	end
end)

concommand.Add("_ent_copy", function()
	local t = "{\n"
	for k,v in ipairs(tb) do
		t = t .. "	" .. v .. "\n"
	end
	t = t .. "}"

	tb = {}
	id = 1
	s = nil
	SetClipboardText(t)
	print(t)
	print("Done!")
end)

concommand.Add("_cfg_cam", function()
	local p = LocalPlayer():EyePos()
	local a = LocalPlayer():GetAngles()
	if not s then
		local t = ("{pos = Vector(%d, %d, %d), ang = Angle(%d, %d, %d)}, "):format(p.x, p.y, p.z, a.x, a.y, a.z)
		tb[id] = t
		s = true
	else
		local t = ("end_pos = Vector(%d, %d, %d), end_ang = Angle(%d, %d, %d)},"):format(p.x, p.y, p.z, a.x, a.y, a.z)
		tb[id] = tb[id] .. t

		id = #tb + 1
		s = false
	end
end)

concommand.Add("_cfg_cam_copy", function()
	local t = "{\n"
	for k,v in ipairs(tb) do
		t = t .. "	" .. v .. "\n"
	end
	t = t .. "}"

	tb = {}
	id = 1
	SetClipboardText(t)
	print(t)
	print("Done!")
end)


concommand.Add("_cfg_mypos", function()
	local p = LocalPlayer():EyePos()
	local a = LocalPlayer():GetAngles()

	local t = ("Vector(%d, %d, %d),"):format(p.x, p.y, p.z)
	tb[id] = t
	id = #tb + 1
end)

concommand.Add("_cfg_mypos_copy", function()
	local t = "{\n"
	for k,v in ipairs(tb) do
		t = t .. "	" .. v .. "\n"
	end
	t = t .. "}"

	tb = {}
	id = 1
	SetClipboardText(t)
	print(t)
	print("Done!")
end)

function rp.util:OpenURL(url)
	local main = ui.Create("ui_frame")
	main:SetSize(300,160)
	main:MakePopup()
	main:Center()
	main:SetTitle("Выберите действие")
	main.lblTitle:SetTextColor(color_white)

	local btn_browser = ui.Create("ui_button",main)
	btn_browser:SetSize(290,35)
	btn_browser:SetPos(5,35)
	btn_browser:SetText("Открыть в браузере")

	local btn_def = ui.Create("ui_button",main)
	btn_def:SetSize(290,35)
	btn_def:SetPos(5,0)
	btn_def:MoveBelow(btn_browser, 5)
	btn_def:SetText("Открыть в Steam")

	local btn_copy = ui.Create("ui_button",main)
	btn_copy:SetSize(290,35)
	btn_copy:SetPos(5,0)
	btn_copy:MoveBelow(btn_def, 5)
	btn_copy:SetText("Скопировать ссылку")

	btn_def.DoClick = function() gui.OpenURL(url) main:Close() end
	btn_browser.DoClick = function() rp.util:Browser(url) main:Close() end
	btn_copy.DoClick = function(self)
		SetClipboardText(url)
		self:SetText("Ссылка скопирована")
		timer.Simple(1,function()
			if !ValidPanel(main) then return end
			main:SetTall(115)
			self:Remove()
		end)
	end
end

function rp.util:Browser(url)
	local CurrentURL = url..""

	local main = ui.Create("ui_frame")
	main:SetSize(ScrW()*.9,ScrH()*.9)
	main:SetTitle("[БРАУЗЕР] "..url)
	main:Center()
	main:MakePopup()

	local dhtml = ui.Create("DHTML",main)
	dhtml:Dock(FILL)
	dhtml:DockMargin(0,35,0,1)
	dhtml:OpenURL(url)

	local ctrls = ui.Create("DHTMLControls", main)
	ctrls:SetWide(ScrW()*.9-10)
	ctrls:SetPos(5, 25)
	ctrls:SetHTML(dhtml)
	ctrls.AddressBar:SetText(url)
	ctrls:SetButtonColor(color_white)
	ctrls.Paint = function() end

	function dhtml:OnDocumentReady(url) CurrentURL = url end

	main.Think = function() main:SetTitle("[БРАУЗЕР] " .. CurrentURL) end
end