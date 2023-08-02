-- Перестань ебаться в глаза и хукать сборку, сделай сам или купи у ｓｕｇｒａａｌ. ｌｕｖ ｓｕｐ#8475
local chatfont = 'ui.23'

// surface.CreateFont(chatfont, {font = "Montserrat Regular", size = 21, weight = 400, extended = true})

local surface_SetMaterial = surface.SetMaterial
local surface_DrawTexturedRect = surface.DrawTexturedRect
local surface_DrawText = surface.DrawText
local surface_SetDrawColor = surface.SetDrawColor
local surface_DrawRect = surface.DrawRect
local surface_DrawOutlinedRect = surface.DrawOutlinedRect
local surface_SetFont = surface.SetFont
local surface_GetTextSize = surface.GetTextSize
local surface_SetAlphaMultiplier = surface.SetAlphaMultiplier
local surface_SetAlphaMultiplier = surface.SetAlphaMultiplier
local surface_SetTextColor = surface.SetTextColor
local surface_SetTextPos = surface.SetTextPos
local draw_TextShadow = draw.TextShadow
local draw_SimpleText = draw.SimpleText
local draw_SimpleTextOutlined = draw.SimpleTextOutlined
local draw_BlurBox = draw.BlurBox
local draw_Blur = draw.Blur

function ba.LoadSingleEmote(em)
	if (not istable(em)) then return end

	em.matloading = true

	texture.Create('Chat_Emote_' .. em.name)
		:EnableProxy(false)
		:Download(em.loadUrl, function(self, mat)
			em.mat = mat
			em.matloading = false
		end)
end

local function ParseForEmotes(...)
	local data = {...}

	if (ba.chatEmotes) then
		local k = 0
		for k, v in ipairs(data) do
			if istable(v) then
				local first = true
				local shouldgoto
				for m, n in pairs(v) do
					if (shouldgoto and m < shouldgoto) then
						continue
					elseif (shouldgoto) then
						shouldgoto = nil
					end
					if (isstring(n) and (!first or n[1] == ":")) then
						first = nil

						local earliest = math.huge
						local emote
						for i, l in pairs(ba.chatEmotes) do
							local pos = string.find(n, i, 1, true)
							if (pos and pos < earliest) then
								earliest = pos
								emote = i
							end
						end

						if (emote) then
							local repwith = n:sub(1, earliest-1)
							local add = n:sub(earliest+#emote)
							local em = ba.chatEmotes[emote]

							if (!em.mat and !em.matloading) then
								ba.LoadSingleEmote(em)
							end

							data[k][m] = repwith
							table.insert(data[k], m+1,add)
							table.insert(data[k], m+1, em)

							shouldgoto = m + 2
						end
					end
				end
			end
		end
	end

	return data
end

function ba.CreateChatBox()
	if not IsValid(LocalPlayer()) then return end
	local frame = vgui.Create('ba_chatbox')

	hook.Call('baChatboxLoaded')

	return frame
end

local LABEL = {}
function LABEL:Init()
	self._Colors = {}
	self._Emotes = {}
	self._Text = ''
	self._SelStart = 0
	self._SelEnd = 0
	self._SelText = ''
	self._Bits = {}

	self.Expire = SysTime() + 15
	self.Created = SysTime()

	self:SetText('')
end

function LABEL:SizeToContents(w)
	surface_SetFont(chatfont)

	local w, h = 0, 0
	for i = 1, string.utf8len(self._Text) or string.len(self._Text) or 0 do
		if (self._Emotes[i]) then
			if (h < 16) then h = 16 end
			table.insert(self._Chars, {'', w, 16})
			w = w + 16
		else
			local char = string.utf8sub(self._Text, i, i)
			local wid, th = surface_GetTextSize(char)

			if (h < th) then h = th end

			if (self._Text[i] == '&') then wid = 12 end
			table.insert(self._Chars, {self._Text[i], w, wid})
			w = w + wid
		end
	end
	self:SetSize(w, h)
end

function LABEL:SetText(val)
	self._Text = val
	self._Bits = {}

	self._Chars = {}

	surface_SetFont(chatfont)

	self:SizeToContents()
end

function LABEL:AddColor(Pos, Col)
	self._Colors[Pos] = Col
	self._Bits = {}
end

function LABEL:AddEmote(Pos, Emote)
	self._Emotes[Pos] = Emote
	self._Bits = {}
end

function LABEL:GetSelectedText()
	return self._SelText
end

function LABEL:Think()
	self._SelText = ''

	local x1 = nil
	local x2 = nil

	if (self._SelStart != 0 or self._SelEnd != 0) then
		local endx
		for k, v in ipairs(self._Chars) do
			if (self._SelStart <= v[2] + v[3] and self._SelEnd >= v[2] + v[3]) then
				self._SelText = self._SelText .. v[1] .. ((k == #self._Chars) and '\n' or '')
				v.Sel = true

				if (!x1) then x1 = v[2] end
			else
				v.Sel = false

				if (x1 and !x2) then x2 = v[2] - x1 end
			end
			endx = v[2] + v[3]
		end
		if (x1 and !x2) then x2 = endx - x1 end
	end

	self._HighX1 = x1
	self._HighX2 = x2

	if (!self._Bits[1]) then
		local lastcol = Color(0, 0, 0)
		local lastpos = 1
		local lastx = 0
		local str = ''

		for k, v in ipairs(self._Chars) do
			if (self._Colors[k]) then
				str = string.utf8sub(self._Text, lastpos, k - 1)

				table.insert(self._Bits, {str, self._Chars[lastpos][2], lastcol})

				lastpos = k

				lastcol = self._Colors[k]
			end

			if (self._Emotes[k]) then
				str = string.utf8sub(self._Text, lastpos, k - 1)

				table.insert(self._Bits, {str, self._Chars[lastpos][2], lastcol})

				if (self._Chars[k-1]) then
					table.insert(self._Bits, {'', self._Chars[k-1][2] + self._Chars[k-1][3], lastCol, Emote = self._Emotes[k]})
				else
					table.insert(self._Bits, {'', 0, lastCol, Emote = self._Emotes[k]})
				end

				lastpos = k+1

				//lastx = lastx
			end
		end

		if (self._Text[lastpos] and self._Chars[lastpos]) then
			str = string.utf8sub(self._Text, lastpos)

			table.insert(self._Bits, {str, self._Chars[lastpos][2], lastcol})
		end
	end
end

function LABEL:GetSelText()
	return self._SelText or ''
end

local blk = Color(0, 0, 0)
function LABEL:Paint(w, h)
	if (CHATBOX and CHATBOX.ShouldDraw == false) then return true end
	if (SysTime() > self.Expire) and (CHATBOX and !CHATBOX._Open) then return true end

	local fin = math.Clamp((SysTime() - (self.Expire - 15)) / .25, 0, 1)
	if (!CHATBOX._Open and fin == 1) then
		-- calc alpha and override mul
		local a = 1 - (math.Clamp((SysTime() - self.Expire) + 2, 0, 2) / 2)
		surface_SetAlphaMultiplier(a)
	else
		surface_SetAlphaMultiplier(fin)
	end

	local h = self:GetTall()
	local outcol = Color(0, 0, 0)
	local emoteswide = 0

	if (self._HighX1 and self._HighX2) then
		surface_SetDrawColor(200, 200, 200, 100)
		surface_DrawRect(self._HighX1, 0, self._HighX2, h)
	end

	for k, v in ipairs(self._Bits) do
		if (v.Emote) then
			if (v.Emote.mat) then
				surface_SetDrawColor(255, 255, 255)
				surface_SetMaterial(v.Emote.mat)
				--surface_DrawTexturedRect(v[2], (h - 16) * 0.5, 16, 16)
				surface_DrawTexturedRect(v[2], 0, h, h)
			end
		else
			v[3].a = math.Clamp((SysTime() - self.Created) * 2, 0, 1) * 255
			draw_SimpleTextOutlined(v[1], chatfont, v[2]+1, ((self:GetTall() == 16 and 1) or 0), v[3], 0, 0, 0.5, blk)
		end
	end

	return true
end
derma.DefineControl('ba_chatlabel', 'ba Chatbox Label', LABEL, 'DLabel')

local PANEL = {}

function PANEL:OnMouseReleased(b)
	self.Selecting = nil
end

function PANEL:GetSheet(name)
	if (self.Sheets[name]) then
		self.ChatResponseCommand = nil
		return self.Sheets[name].Frame
	else
		local sheet, msgFrame = self:CreateTab(name)

		if (self.ChatResponseCommand) then
			msgFrame.ResponseCommand = self.ChatResponseCommand
			self.ChatResponseCommand = nil
		end

		if (self.ChatHistory[name]) then
			self.activeMessageTab = msgFrame
			for k, v in ipairs(self.ChatHistory[name]) do
				self:AddMessage(unpack(v))
			end
			self.activeMessageTab = nil
		end

		return msgFrame
	end
end

local numTabs = 0
local color_tab = ui.col.Background:Copy()
local color_tab_a = color_tab.a
local color_selected = ui.col.SUP:Copy()
color_selected.a = 65
function PANEL:CreateTab(name)
	numTabs = numTabs + 1
	local msgFrame = vgui.Create('ui_scrollpanel', self)
	msgFrame:SetScrollSize(2)
	msgFrame:SetSkin('SUP')
	msgFrame:SetPadding(0)
	msgFrame:SetSpacing(0)
	msgFrame._Messages = {}

	local sheet = self.propSheet:AddSheet(name .. (name == 'All' and '' or '    '), msgFrame)
	sheet.Tab:SetFont(chatfont)
	sheet.Tab:SetTextColor(Color(5, 5, 5))
	sheet.Tab.OldOnMP = sheet.Tab.OnMousePressed
	sheet.Tab.OnMousePressed = function(s, m)
		if (m == MOUSE_MIDDLE and name != "All") then
			if (self.activeMessageFrame and msgFrame == self.activeMessageFrame) then
				self.propSheet:SetActiveTab(self.Sheets["All"].Tab)
			end

			self.propSheet:CloseTab(s, true)
			self.Sheets[name] = nil
			return
		end

		s:OldOnMP(m)
	end
	sheet.Tab.Paint = function(s, w, h, x, y)
		if (numTabs == 1 or !x) then
			return true
		end

		local sel = false
		if (self.activeMessageFrame and msgFrame == self.activeMessageFrame) then
			sel = true
			msgFrame.Attention = false
		else
			if (msgFrame.Attention) then
				local diff = SysTime() - msgFrame.Attention
				if (diff >= 15) then
					msgFrame.Attention = SysTime()
				end

				local a
				if (self._OpenTime) then
					a = 0
					msgFrame.Attention = SysTime()
				else
					a = math.min(diff, 2) / 2
					if (a == 1) then return end
				end

				color_tab.r = 255 - 255 * a
				color_tab.g = 150 - 150 * a
				color_tab.b = 0
			end
		end

		draw.RoundedBox(5, x, y + 1, w - 6, 26, color_tab)

		if sel then
			draw.RoundedBox(5, x, y + 1, w - 6, 26, color_selected)
		end

		draw_SimpleText(name, chatfont, x + w * 0.5 - (name == 'All' and 2 or 12), y + 4, ui.col.White, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)

		color_tab.r = ui.col.Background.r
		color_tab.g = ui.col.Background.g
		color_tab.b = ui.col.Background.b

		return true
	end
	msgFrame:SetSize(self.propSheet:GetWide())

	self.Sheets[name] = {Tab = sheet.Tab, Frame = msgFrame}
	msgFrame.Tab = sheet.Tab

	if (name != 'All') then
		sheet.Tab.btnClose = ui.Create('ui_button', sheet.Tab)
		sheet.Tab.btnClose:SetText('X')
		sheet.Tab.btnClose.DoClick = function (button) surface.PlaySound('sup/ui/beep.ogg') sheet.Tab:OnMousePressed(MOUSE_MIDDLE) end
		sheet.Tab.btnClose.Paint = function(panel, w, h) derma.SkinHook('Paint', 'TransparentWindowCloseButton', panel, w, h) end
		sheet.Tab.btnClose:SetPos(sheet.Tab:GetWide() - 30, 1)
		sheet.Tab.btnClose:SetSize(16, 16)
	end

	msgFrame.Name = name
	return sheet, msgFrame
end

local color_teamchat = ui.col.DarkGreen:Copy()
color_teamchat.a = 200
function PANEL:Init()
	self:SetSize(chat.GetChatBoxSize(true))
	self:SetPos(chat.GetChatBoxPos())

	self.Sheets = {}

	self.ShouldDraw = true

	self._Open = false
	self._Team = false

	self.History = {}
	self.ChatHistory = {}
	self.AutoNames = {}
	self.CurrentAutoName = 0

	self.btnResize = vgui.Create('Panel', self)
	self.btnResize:SetCursor('sizenesw')
	self.btnResize.OnMousePressed = function(s, mb)
		if (mb == MOUSE_LEFT) then
			self.Resizing = true
		end
	end

	self.propSheet = vgui.Create('DPropertySheet', self)
	self.propSheet:SetFadeTime(0)
	self.propSheet.Paint = function() end
	self.propSheet.OnActiveTabChanged = function(s, o, n)
		self.activeMessageFrame = n:GetPanel()
		self.txtEntry:RequestFocus()
	end

	self.OvermsgFrame = vgui.Create('Panel', self)

	local checkVisibility = 0
	local mp = {}
	self.OvermsgFrame.Think = function(s)
		checkVisibility = checkVisibility + 1
		if (checkVisibility >= 5) then
			checkVisibility = 0
		end

		local y = 0
		local off = self.activeMessageFrame.yOffset
		mp[1] = gui.MouseX() - s.x - self.x
		mp[2] = gui.MouseY() - s.y - self.y + self.activeMessageFrame.yOffset
		local firstx, firsty, lastx, lasty

		if (self.Selecting) then
			if (self.MouseDown[2] > mp[2]) then firstx = mp[1] firsty = mp[2] lastx = self.MouseDown[1] lasty = self.MouseDown[2] else firstx = self.MouseDown[1] firsty = self.MouseDown[2] lastx = mp[1] lasty = mp[2] end
		end

		self.SelectedText = ''

		if (checkVisibility == 0 or self.Selecting) then
			for k, v in ipairs(self.activeMessageFrame._Messages) do
				if (checkVisibility == 0) then
					if (y >= off - s:GetTall() * 2 and y <= off + s:GetTall() * 2) then
						if (v.invisible) then
							v:SetVisible(true)
							v.invisible = false
						end
					elseif (!v.invisible) then
						v.invisible = true
						v:SetVisible(false)
					end
				end

				if (!v.invisible and self.Selecting) then
					if (firsty <= v.y and lasty > v.y + v:GetTall()) then
						v._SelStart = 0
						v._SelEnd = v:GetWide()
					elseif (firsty >= v.y and firsty <= v.y + v:GetTall() - 1) then
						if (lasty > v.y + v:GetTall()) then
							v._SelStart = firstx
							v._SelEnd = v:GetWide()
						else
							if (firstx < lastx) then
								v._SelStart = firstx
								v._SelEnd = lastx
							else
								v._SelStart = lastx
								v._SelEnd = firstx
							end
						end
					elseif (lasty >= v.y and lasty <= v.y + v:GetTall()) then
						if (firsty <= v.y + 10) then
							v._SelStart = 0
							v._SelEnd = lastx
						else
							if (firstx < lastx) then
								v._SelStart = firstx
								v._SelEnd = lastx
							else
								v._SelStart = lastx
								v._SelEnd = firstx
							end
						end
					else
						v._SelStart = 0
						v._SelEnd = 0
					end

					self.SelectedText = self.SelectedText .. v:GetSelText()
				end

				y = y + v:GetTall()
			end
		end
	end

	self.OvermsgFrame.OnMouseWheeled = function(s, ...)
		return self.activeMessageFrame:OnMouseWheeled(...)
	end

	self.OvermsgFrame.OnMousePressed = function(s, b)
		local sb = self.activeMessageFrame.scrollBar.scrollButton
		local sbx, sby = sb:CursorPos()

		if (sbx >= 0 and sbx <= sb:GetWide() and sby >= 0 and sby <= sb:GetTall()) then
			sb:OnMousePressed(b)
		else
			self.MouseDown = {gui.MouseX() - self.x - s.x, gui.MouseY() - self.y - s.y + self.activeMessageFrame.yOffset}
			self.Selecting = true
		end
	end

	self.OvermsgFrame.OnMouseReleased = function(s, b)
		self.Selecting = false
	end

	self.txtEntry = ui.Create('DTextEntry', self)
	self.txtEntry:SetVisible(false)
	self.txtEntry._Paint = self.txtEntry.Paint
	function self.txtEntry.Paint(s, w, h)
		self.txtEntry._Paint(s, w, h)

		if self._Team then
			draw.RoundedBox(5, 0, 0, w, h, color_teamchat)
		end
	end
	self.txtEntry.PaintOver = function(s, w, h)
		if (CHATBOX and CHATBOX.ShouldDraw == false) then return true end

		if (!s.AutoFillText) then return end

		surface_SetFont(chatfont)

		local x = surface_GetTextSize(s:GetValue())
		local w, h = surface_GetTextSize(s.AutoFillText)

		surface_SetDrawColor(s:GetHighlightColor() or ui.col.SUP)
		surface_DrawRect(x+3, 2, w, h+1)
		surface_SetTextColor(ui.col.White)
		surface_SetTextPos(x+3, 2)
		surface_DrawText(s.AutoFillText)
	end

	self.txtEntry.OnKeyCodeTyped = function(s, c)
		if (c == KEY_TAB) or ((c == KEY_RIGHT) and (s:GetCaretPos() == (string.utf8len(s:GetValue())))) then
			self:DoAutoFill()
			s:OnTextChanged()
			s:SetCaretPos(string.utf8len(s:GetValue()))
		elseif (c == KEY_UP) then
			if (#self.AutoNames > 0) then
				local auto = self:GetAutoFill(1)
				s.AutoFillText = auto and auto.CompleteString or nil
			else
                if (self.History[s.historyPos + 1]) then
                    s.historyPos = s.historyPos + 1
                    s:SetText(self.History[s.historyPos])
                    s:SetCaretPos(string.utf8len(s:GetValue()))
                end
			end
		elseif (c == KEY_DOWN) then
			if (#self.AutoNames > 0) then
				local auto = self:GetAutoFill(1)
				s.AutoFillText = auto and auto.CompleteString or nil
			else
				if (self.History[s.historyPos - 1] or s.historyPos - 1 == 0) then
					s.historyPos = s.historyPos - 1
					if (self.History[s.historyPos]) then
						s:SetText(self.History[s.historyPos])
						if isstring(Team) then
							self._Team = self.History[s.historyPos].Team
						end
					else
						s:SetText('')
						self._Team = self._OpenedWithTeam
					end
					s:SetCaretPos(string.utf8len(s:GetValue()))
				end
			end
		elseif (c == KEY_ENTER) then
			local command = self.activeMessageFrame.ResponseCommand
			local msg = string.Trim(s:GetValue())
			if (msg != "") then
            	--#RunConsoleCommand('say' .. ((self._Team and '_team') or ''), s:GetValue())

            	net.Start("sayRaw")
				if (command and msg[1] and msg[1] != '/' and msg[1] != '!' and msg[1] != '@') then
					net.WriteBool(false)
					net.WriteString(s:GetValue())
				else
					net.WriteBool(self._Team)
					net.WriteString(s:GetValue())
				end
				net.SendToServer()

            	if (string.Trim(s:GetValue()) ~= '') then
            	    table.insert(self.History, 1, s:GetValue())
            	end
            end

			self:Close()
		elseif (c == KEY_ESCAPE) then
			self:Close()

			RunConsoleCommand("cancelselect")
		end
	end

	self.txtEntry.OnLoseFocus = function(s)
		if (input.IsKeyDown(KEY_TAB)) then
			s:RequestFocus()
			s:SetCaretPos(string.utf8len(s:GetText()))
		end
	end

	self.txtEntry.OnTextChanged = function(s)
		self:CalculateAutoFill()

		local auto = self:GetAutoFill()
		s.AutoFillText = auto and auto.CompleteString or nil

		if (s:AllowInput()) then
			s:SetValue(string.utf8sub(s:GetValue(), 1, 126))
			s:SetCaretPos(126)
		end

		gamemode.Call('ChatTextChanged', s:GetValue())
	end

	self.txtEntry.AllowInput = function(s)
		if (string.len(s:GetValue()) >= 126) then
			surface.PlaySound('Resource/warning.wav')
			return true
		end
	end

	self.emotes = ui.Create('ui_button', self)
	self.emotes:SetText('')
	self.emotes:SetVisible(false)

	self.emotes.PaintOver = function(s, w, h)
		draw_SimpleText('☺', 'ui.29', 12, 9, ui.col.White, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER) -- gettextsize doesnt work here
	end
	self.emotes.DoClick = function()
		if IsValid(self.emotesList) then
			self.emotesList:AddRecents()
			self.emotesList:SetVisible(not self.emotesList:IsVisible())
		else
			self.emotesList = ui.Create('ba_emotes_list', self)
		end
	end

	self:PerformLayout(self:GetWide(), self:GetTall())
end

function PANEL:OnKeyCodePressed(k)
	if (k == KEY_C) and (input.IsKeyDown(KEY_LCONTROL)) then
		if (self.SelectedText and self.SelectedText != '') then
			SetClipboardText(self.SelectedText)
		end
	end
end

function PANEL:PerformLayout(w, h)
	self.txtEntry:SetFont(chatfont)

	local ts = 25--ui.ButtonHeight

	self.txtEntry:SetPos(5, h - ts - 5)
	self.txtEntry:SetSize(w - ts - 15, ts)

	self.emotes:SetSize(ts, ts)
	self.emotes:SetPos(w - ts - 5, h - ts - 5)

	if IsValid(self.emotesList) then
		self.emotesList:SetSize(185, 220)
		self.emotesList:SetPos(w - self.emotesList:GetWide() - 5, h - self.emotesList:GetTall() - ts - 10)
	end

	self.btnResize:SetSize(5, 5)
	self.btnResize:SetPos(w - 5, 0)
	self.propSheet:SetPos(5, 5)
	self.propSheet:SetSize(w - 10, self.txtEntry.y - 10)

	if (!self.activeMessageFrame) then
		self.activeMessageFrame = self:GetSheet("All")

		local nick = LocalPlayer():GetName()

		if LocalPlayer():GetPlayTime() and (LocalPlayer():GetPlayTime() > 900000) then
			self:AddMessage({ui.col.SUP:Copy(), '| ', ui.col.Gold, nick, Color(255, 255, 255), ' Мы рады видеть тебя на ', ui.col.SUP:Copy(), 'VAULT', Color(58, 117, 196), 'RP!'})
		else
			self:AddMessage({ui.col.SUP:Copy(), '| ', LocalPlayer():GetJobColor(), nick, Color(255, 255, 255), ' Мы рады видеть тебя на ', ui.col.SUP:Copy(), 'VAULT', Color(58, 117, 196), 'RP!'}) -- col 93, 155, 155
		end
	end --												153,50,204

	for k, v in pairs(self.Sheets) do
		v.Frame:Dock(FILL)
	end

	self.OvermsgFrame:SetPos(5 + self.activeMessageFrame.x, 5 + self.activeMessageFrame.y)
	self.OvermsgFrame:SetSize(w - (self.OvermsgFrame.x * 2), self.txtEntry.y - (self.OvermsgFrame.y * 2))
end

function PANEL:Think()
	if (self._Open and gui.IsGameUIVisible()) then
		self:Close()
		return
	end

	if (!self.Resizing) then return end
	if (!input.IsMouseDown(MOUSE_LEFT)) then
		cvar.SetValue('ChatboxSize', {self:GetWide(), self:GetTall()})
		self.Resizing = false
		return
	end

	local w = math.Clamp(gui.MouseX() - chat.GetChatBoxLeftBound(), 265, ScrW() - 23) + 3
	local h = math.Clamp(chat.GetChatBoxBottomBound() - gui.MouseY(), 155, ScrH() - 23) + 3

	if (x != self:GetWide() or h != self:GetTall()) then
		for _, msgFrame in pairs(self.Sheets) do
			local newOff = msgFrame.yOffset
			if (h < self:GetTall()) then
				newOff = newOff + (self:GetTall() - h)
			end

			msgFrame:SetOffset(newOff)
		end

		self:SetSize(w, h)
		self:SetPos(chat.GetChatBoxPos(w, h))
		self:InvalidateLayout(true)
	end
end

local color_background = ui.col.Background:Copy()
function PANEL:Paint(w, h)
	self.ShouldDraw = hook.Call('HUDShouldDraw', GAMEMODE, 'Chatbox')
	if (!self.ShouldDraw) then return true end

	local a = 0
	if (self._OpenTime) then
		a = math.Clamp((SysTime() - self._OpenTime) / .25, 0, 1)
	elseif (self._CloseTime) then
		a = 1 - math.Clamp((SysTime() - self._CloseTime) / .25, 0, 1)
	end

	self:SetAlpha(a * 255)

	for k,v in ipairs(self:GetChildren()) do
		v:SetAlpha(a * 255)
	end

	for k,v in ipairs(self.propSheet:GetChildren()) do
		v:SetAlpha(a * 255)
	end

	self.activeMessageFrame.scrollBar:SetAlpha(a * 255)
	for k, v in pairs(self.Sheets) do
		v.Tab:SetAlpha(a * 255)

		local bx, by = v.Tab:LocalToScreen(0, 0)
		bx = bx - self.x - 5
		by = by - self.y - 5

		surface.SetAlphaMultiplier(v.Frame.Attention and 1 or a)
		v.Tab:Paint(v.Tab:GetWide(), v.Tab:GetTall(), bx, by)
		surface.SetAlphaMultiplier(1)
	end

	if (a == 0) then
		return
	end

	local bx, by, bw, bh = self:GetBounds()
	local fy = self.activeMessageFrame.y
	h = h - fy

	color_background.a = 150 * a
	draw.RoundedBox(5,0, fy, w, h, color_background)
end

function PANEL:PaintOver(w, h)
end

function PANEL:AddTabbedMessage(tab, ...)
	self.activeMessageTab = self:GetSheet(tab)
	self:AddMessage(...)
	self.activeMessageTab = nil

	if (self.SkipMessageInAll) then self.SkipMessageInAll = nil return end

	if (tab != "All") then
		self:AddTabbedMessage("All", ...)

		-- Chat history per tab to repopulate if tab is closed, skip All because it can't be closed
		self.ChatHistory[tab] = self.ChatHistory[tab] or {}
		table.insert(self.ChatHistory[tab], {...})
		if (self.ChatHistory[tab][500]) then
			table.remove(self.ChatHistory[tab], 1)
		end
	end
end

function PANEL:AddMessage(...)
	if (self.PendingChatTab) then
		local tab = self.PendingChatTab
		self.PendingChatTab = nil
		if (hook.Call('ShouldCreateChatTab', nil, tab) ~= false) then
			self:AddTabbedMessage(tab, ...)
			return
		end
	end

	local strings = ''
	local colors = {}
	local emotes = {}
	local emotesww = {}

	local msgFrame = self.activeMessageTab or self:GetSheet('All')
	if (msgFrame != self.activeMessageFrame) then
		msgFrame.Attention = SysTime()
	end

	self.LastMaxOffset = math.Clamp(msgFrame:GetCanvas():GetTall() - msgFrame:GetTall(), 0, math.huge)

	table.insert(colors, {Col=Color(200, 200, 200), Pos=1})

	local data = ((not cvar.GetValue('DisableEmotes')) and self.DoEmotes) and ParseForEmotes(...) or {...}
	self.DoEmotes = false

	for k, v in ipairs(data[1]) do
		if istable(v) and v.mat != nil then
			strings = strings .. '*'
			emotesww[emotes[table.insert(emotes, {Emote = v, Pos=string.utf8len(strings)})].Pos] = true
		elseif (isstring(v) or isnumber(v)) then
			if (v[1] == '>') then
				table.insert(colors, {Col=Color(140, 200, 100), Pos=string.utf8len(strings)})
			end
			strings = strings .. v
		elseif isplayer(v) then
			if (string.utf8len(strings) == 0) then table.remove(colors, 1) end

			table.insert(colors, {Col = (IsValid(v) and v:GetJobColor() or ui.col.Grey:Copy()), Pos = string.utf8len(strings) + 1})

			strings = strings .. (IsValid(v) and v:Name() or 'Unknown')
		else
			if (string.utf8len(strings) == 0) then table.remove(colors, 1) end
			table.insert(colors, {Col=v:Copy(), Pos=string.utf8len(strings) + 1})
		end
	end

	local texts = string.Wrap(chatfont, strings, msgFrame:GetWide() - 5, emotesww)

	local shouldPopDown
	if (msgFrame:IsAtMaxOffset()) then
		shouldPopDown = true
	end

	local cursnip = 1
	for k, v in ipairs(texts) do
		if (v == '') then continue end

		if (msgFrame._Messages[1000]) then
			msgFrame._Messages[1]:Remove()
			table.remove(msgFrame._Messages, 1)

			if (!shouldPopDown) then
			end
		end

		local lbl = vgui.Create('ba_chatlabel', msgFrame:GetCanvas())
		lbl:SetFont(chatfont)
		lbl:SetCursor("beam")

		table.insert(msgFrame._Messages, lbl)

		for i, l in ipairs(colors) do
			if (l.Pos <= cursnip and (!colors[i+1] or colors[i+1].Pos > cursnip)) then
				lbl:AddColor(1, l.Col)
			elseif (l.Pos >= cursnip and l.Pos < cursnip + string.utf8len(v)) then
				lbl:AddColor(l.Pos - cursnip + 1, l.Col)
			end
		end

		for i, l in ipairs(emotes) do
			if (l.Pos >= cursnip and l.Pos < cursnip + string.utf8len(v)) then
				lbl:AddEmote(l.Pos - cursnip + 1, l.Emote)
			end
		end

		lbl:SetText(v)
		msgFrame:AddItem(lbl)

		cursnip = cursnip + string.utf8len(v)
	end

	chat.PlaySound()

	if (shouldPopDown) then
		msgFrame.yOffset = math.Clamp(msgFrame:GetCanvas():GetTall() - msgFrame:GetTall(), 0, math.huge)
	end

	self:InvalidateLayout()
end

function PANEL:CalculateAutoFill()
	local curSel = self.AutoNames[self.CurrentAutoName]

	table.Empty(self.AutoNames)

	local words = string.Explode(' ', self.txtEntry:GetValue())
	match = words[#words]

	if (!match or match == '') then
		self.CurrentAutoName = 0
		return
	end

	local isEmote = LocalPlayer():IsVIP() and string.StartWith(match, ':')

	if (not isEmote) then
		for k, v in ipairs(player.GetAll()) do
			if ((string.find(v:Name():lower(), match:lower(), 1, true) or -1) == 1) then
				if (curSel and curSel.SteamID == v:SteamID()) then
					self.CurrentAutoName = #self.AutoNames + 1
				end

				self.AutoNames[#self.AutoNames + 1] = {
					Name = v:Name(),
					SteamID = v:SteamID()
				}
			end
		end
	end

	if isEmote then
		for k, v in pairs(ba.chatEmotes) do // do the hack
			if ((string.find(k:lower(), match:lower(), 1, true) or -1) == 1)  then
				self.AutoNames[#self.AutoNames + 1] = {
					Name = k,
					SteamID = k
				}
			end
		end
	end
end

function PANEL:GetAutoFill(step)
	step = step or 0

	local words = string.Explode(' ', self.txtEntry:GetValue())
	match = words[#words]
	if (!match or match == '') then return end

	self.CurrentAutoName = self.CurrentAutoName + step
	if (!self.AutoNames[self.CurrentAutoName]) then
		self.CurrentAutoName = (self.CurrentAutoName <= 0 and #self.AutoNames) or 1
	end

	local fillData = self.AutoNames[self.CurrentAutoName]

	if (fillData) then
		fillData.CompleteString = string.utf8sub(fillData.Name, #match + 1)
	end

	return fillData
end

function PANEL:DoAutoFill()
	local pl = self:GetAutoFill()
	if (!pl) then return end

	local words = string.Explode(' ', self.txtEntry:GetValue())
	match = words[#words]
	if (!match or match == '') then return end

	local pref = string.utf8sub(self.txtEntry:GetValue(), 1, 1)
	local fillVal

	local firstarg = string.utf8sub(self.txtEntry:GetValue(), 1, (string.find(self.txtEntry:GetValue(), ' ')  or (#self.txtEntry:GetValue() + 1)) - 1)

	if (pref == '/' or pref == '!') and (firstarg != '//' and firstarg != '/ooc' and firstarg != '/ad' and firstarg != '/advert') and (!ret) then
		fillVal = pl.SteamID
	else
		fillVal = pl.Name
	end

	self.txtEntry:SetText(string.utf8sub(self.txtEntry:GetValue(), 1, -(#match + 1)) .. fillVal .. ' ')
end

function PANEL:Open(tm)
	if (CHATBOX and CHATBOX.ShouldDraw == false) then return end

	self._Open = true
	self._OpenTime = SysTime()
	self._CloseTime = nil

	self._Team = tm
	self._OpenedWithTeam = tm
	gamemode.Call('StartChat')

	self:MakePopup()
	self:MoveToFront()

	self.txtEntry:SetVisible(true)
	self.txtEntry:RequestFocus()
	self.txtEntry.historyPos = 0

	self.emotes:SetVisible(true)
end

function PANEL:Close()
	if (!self._Open) then return end

	if (self.ForceOpen) then
		gamemode.Call('FinishChat')
		gamemode.Call('ChatTextChanged', '')
		self.txtEntry:SetText('')

		return
	end

	self._Open = false
	self._OpenTime = nil
	self._CloseTime = SysTime()

	for k, v in pairs(self.Sheets) do
		v.Frame.yOffset = math.Clamp((v.Frame:GetCanvas():GetTall() - v.Frame:GetTall()), 0, math.huge)
		v.Frame:InvalidateLayout()

		v.Frame.Attention = false
	end

	gamemode.Call('FinishChat')

	self:SetMouseInputEnabled(false)
	self:SetKeyboardInputEnabled(false)

	gamemode.Call('ChatTextChanged', '')

	self.txtEntry:SetText('')
	self.txtEntry:OnTextChanged()

	if IsValid(self.emotesList) then
		self.emotesList:SetVisible(false)
	end

	self:MoveToBack()
end

derma.DefineControl('ba_chatbox', 'ba Chatbox', PANEL, 'EditablePanel')

if (CHATBOX) then CHATBOX:Remove() CHATBOX = ba.CreateChatBox() end