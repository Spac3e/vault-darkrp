local fr
local ignorechangedhook = false

local c = Color

if (!file.IsDir("vlt_drp_clr", "DATA")) then
	file.CreateDir("vlt_drp_clr")
end
local function writeColor(colData)
	file.Write('vlt_drp_clr/col.dat', util.TableToJSON(colData))
end
local function readColor()
	if file.Exists('vlt_drp_clr/col.dat', 'DATA') then
		local out = {}
		for colorName, colorData in pairs(util.JSONToTable(file.Read('vlt_drp_clr/col.dat', 'DATA'))) do
			out[colorName] = Color(colorData.r, colorData.g, colorData.b, colorData.a or 255)
		end
		return out
	else
		return {
			SUP 			= c(170,0,255,255),
			Header 			= c(15,15,15,255),
			Gradient 		= c(85,85,85,200),
			Background 		= c(10,10,10,160),
			Outline 		= c(75,75,75,255),
			Hover 			= c(160,160,160,75),

			Button 			= c(130,130,130,150),
			ButtonHover 	= c(220,220,220,150),
			ButtonRed 		= c(240,0,0),
			ButtonGreen 	= c(0,240,0),
			ButtonBlack 	= c(25,25,25, 180),
			Close 			= c(235,235,235),
			CloseBackground = c(215, 0, 50),
			CloseHovered 	= c(235, 0, 70),

			TransGrey155 	= c(100,100,100,155),
			TransWhite50 	= c(255,255,255,50),
			TransWhite100 	= c(255,255,255,100),
			OffWhite 		= c(200,200,200),
			Grey 			= c(100,100,100),
			LightGrey		= c(150,150,150),
			FlatBlack 		= c(45,45,45),
			Black 			= c(0,0,0),
			White 			= c(255,255,255),
			Blue 			= c(0, 50, 200),
			Red 			= c(235,10,10),
			DarkRed			= c(200,10,10),
			Green 			= c(10,235,10),
			DarkGreen 		= c(0, 153, 51),
			Orange 			= c(245,120,0),
			Yellow 			= c(255,255,51),
			Gold 			= c(212,175,55),
			Purple 			= c(147,112,219),
			Pink 			= c(255,105,180),
			Brown 			= c(139,69,19)
		}
	end
end
local function writePreset(presetName, presetData)
	file.Write('vlt_drp_clr/userpreset_' .. presetName .. '.dat', util.TableToJSON(presetData))
end
local function getAllPresets()
	local out = {}
	local presetsData, _ = file.Find('vlt_drp_clr/*', 'DATA')
	for _, presetName in ipairs(presetsData) do
		if presetName:StartsWith('userpreset') then
			table.insert(out, presetName)
		end
	end
	return out
end
local function readPreset(presetName)
	if file.Exists('vlt_drp_clr/' .. presetName, 'DATA') then
		local out = {}
		for colorName, colorData in pairs(util.JSONToTable(file.Read('vlt_drp_clr/' .. presetName, 'DATA'))) do
			out[colorName] = Color(colorData.r, colorData.g, colorData.b, colorData.a or 255)
		end
		return out
	else
		return {
			SUP 			= c(255,255,255,255),
			Header 			= c(15,15,15,255),
			Gradient 		= c(85,85,85,200),
			Background 		= c(10,10,10,160),
			Outline 		= c(75,75,75,255),
			Hover 			= c(160,160,160,75),

			Button 			= c(130,130,130,150),
			ButtonHover 	= c(220,220,220,150),
			ButtonRed 		= c(240,0,0),
			ButtonGreen 	= c(0,240,0),
			ButtonBlack 	= c(25,25,25, 180),
			Close 			= c(235,235,235),
			CloseBackground = c(215, 0, 50),
			CloseHovered 	= c(235, 0, 70),

			TransGrey155 	= c(100,100,100,155),
			TransWhite50 	= c(255,255,255,50),
			TransWhite100 	= c(255,255,255,100),
			OffWhite 		= c(200,200,200),
			Grey 			= c(100,100,100),
			LightGrey		= c(150,150,150),
			FlatBlack 		= c(45,45,45),
			Black 			= c(0,0,0),
			White 			= c(255,255,255),
			Blue 			= c(0, 50, 200),
			Red 			= c(235,10,10),
			DarkRed			= c(200,10,10),
			Green 			= c(10,235,10),
			DarkGreen 		= c(0, 153, 51),
			Orange 			= c(245,120,0),
			Yellow 			= c(255,255,51),
			Gold 			= c(212,175,55),
			Purple 			= c(147,112,219),
			Pink 			= c(255,105,180),
			Brown 			= c(139,69,19)
		}
	end
end

ui.col = readColor()

if CLIENT then
    include'theme.lua'
end

local currentColor = 'SUP'
local presets = {
	original = {
		SUP 			= c(255,255,255,255),
		Header 			= c(15,15,15,255),
		Gradient 		= c(85,85,85,200),
		Background 		= c(10,10,10,160),
		Outline 		= c(75,75,75,255),
		Hover 			= c(160,160,160,75),

		Button 			= c(130,130,130,150),
		ButtonHover 	= c(220,220,220,150),
		ButtonRed 		= c(240,0,0),
		ButtonGreen 	= c(0,240,0),
		ButtonBlack 	= c(25,25,25, 180),
		Close 			= c(235,235,235),
		CloseBackground = c(215, 0, 50),
		CloseHovered 	= c(235, 0, 70),

		TransGrey155 	= c(100,100,100,155),
		TransWhite50 	= c(255,255,255,50),
		TransWhite100 	= c(255,255,255,100),
		OffWhite 		= c(200,200,200),
		Grey 			= c(100,100,100),
		LightGrey		= c(150,150,150),
		FlatBlack 		= c(45,45,45),
		Black 			= c(0,0,0),
		White 			= c(255,255,255),
		Blue 			= c(0, 50, 200),
		Red 			= c(235,10,10),
		DarkRed			= c(200,10,10),
		Green 			= c(10,235,10),
		DarkGreen 		= c(0, 153, 51),
		Orange 			= c(245,120,0),
		Yellow 			= c(255,255,51),
		Gold 			= c(212,175,55),
		Purple 			= c(147,112,219),
		Pink 			= c(255,105,180),
		Brown 			= c(139,69,19)
	}
}
function ui.OpenColorEditor()
	if IsValid(fr) then fr:Close() end

	if not LocalPlayer().UserNoticed then
		LocalPlayer().UserNoticed = true
		chat.AddText(ui.col.Red:Copy(), '[ПРЕДУПРЕЖДЕНИЕ]', ui.col.White:Copy(), ' После того, как вы закончите создавать свои собственные цвета, вам нужно будет повторно подключиться к серверу, чтобы некоторые цвета интерфейса изменились')
	end

	fr = ui.Create('ui_frame', function(self)
		self:SetTitle('Редактор Цветов')
		self:SetSize(800, 500)
		self:Center()
		self:MakePopup()
	end)

	local w, h = (fr:GetWide() * 0.5), ((fr:GetTall() - 55))

	local cmixer = ui.Create('DColorMixer', function(self, p)
		self:SetAlphaBar(true)
		self:SetSize(w, h)
		self:SetPos(5, 40)
		self:SetVector(Vector(GetConVarString('cl_playercolor')))
		self.ValueChanged = function()
			if ignorechangedhook then return end
			ui.col[currentColor] = Color(self:GetColor().r, self:GetColor().g, self:GetColor().b, self:GetColor().a or 255)
			writeColor(ui.col)
			include 'ui/theme.lua'
		end
	end, fr)

	fr.Setting = ui.Create('DComboBox', fr)
	fr.Setting:SetValue("Выберите Цвет")
	for colorName, _ in pairs(ui.col) do
		fr.Setting:AddChoice(colorName)
	end
	fr.Setting.OnSelect = function(s, inx, type)
		currentColor = type
		ignorechangedhook = true
		cmixer:SetColor(readColor()[type])
		ignorechangedhook = false
	end
	fr.Setting:SetPos(w + 25, 35)
	fr.Setting:SetSize(fr:GetWide() * 0.45, 25)

	fr.Presets = ui.Create('DComboBox', fr)
	fr.Presets:SetValue("Пресеты")
	for presetName, _ in pairs(presets) do
		fr.Presets:AddChoice(presetName)
	end
	fr.Presets.OnSelect = function(s, inx, type)
		ui.col = table.Copy(presets[type])
		writeColor(ui.col)
		include 'ui/theme.lua'
	end
	fr.Presets:SetPos(w + 25, 70)
	fr.Presets:SetSize(fr:GetWide() * 0.45, 25)

	fr.UserPresets = ui.Create('DComboBox', fr)
	fr.UserPresets:SetValue("Пресеты Игрока")
	for _, presetName in pairs(getAllPresets()) do
		fr.UserPresets:AddChoice(presetName)
	end
	fr.UserPresets:AddChoice('Создать новый пресет...')
	fr.UserPresets.OnSelect = function(s, inx, type)
		if type == 'Создать новый пресет...' then
			ui.StringRequest('Новый пресет', 'Введите название нового пресета', 'new_preset', function(presetName)
				writePreset(presetName, ui.col)
				fr:Close()
				ui.OpenColorEditor()
			end)
		else
			ui.StringRequest('Пресет', 'LOAD - загрузить пресет\nDELETE - удалить пресет', 'LOAD', function(presetName)
				local presetName = presetName:lower()

				if presetName == 'load' then
					ui.col = readPreset(type)
					writeColor(ui.col)
					include 'ui/theme.lua'
				elseif presetName == 'delete' then
					file.Delete('vlt_drp_clr/' .. type)
					fr:Close()
					ui.OpenColorEditor()
				end
			end)
		end
	end
	fr.UserPresets:SetPos(w + 25, 105)
	fr.UserPresets:SetSize(fr:GetWide() * 0.45, 25)
end