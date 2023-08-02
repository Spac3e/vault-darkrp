pdash.IncludeSH 'shared.lua'

local mat_wheel = Material 'sup/entities/roulette/wheel'
local mat_cursor = Material 'sup/entities/roulette/cursor'
function ENT:DrawScreen(x, y, w, h)
	surface.SetDrawColor(255, 255, 255)

	local roll = self:GetRoll() - 1

	surface.SetMaterial(mat_wheel)
	surface.DrawTexturedRectRotated(0, 0, w, h, 360 * (roll/32))

	surface.SetMaterial(mat_cursor)
	surface.DrawTexturedRect(x, y, w, h)

	local bet = self:GetBet()

	local textX, textY = x + 928, y + 730
	if (bet > 31) then
		draw.SimpleText((bet == 32) and 'Красный' or 'Чёрный', 'rp.GamblingMachines', textX, textY, ui.col.White, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		draw.Outline(x + 712, y + 671, 432, 120, (bet == 32) and ui.col.DarkRed or ui.col.FlatBlack)
	else
		draw.SimpleText((bet == 0) and 'Нули' or bet, 'rp.GamblingMachines', textX, textY, ui.col.White, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		draw.Outline(x + 712, y + 671, 432, 120, (bet % 2 == 0) and ((bet == 0) and ui.col.DarkGreen or ui.col.FlatBlack) or ui.col.DarkRed, 10)
	end

	draw.SimpleText(rp.FormatMoney(self:Getprice()), 'rp.GamblingMachines', x + 232, textY, ui.col.White, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
end

local function sendBet(bet)
	net.Start 'rp.roulette.SetBet'
		net.WriteUInt(bet, 6)
	net.SendToServer()
end

function ENT:ReadPlayerUse()
	return LocalPlayer() == self:CPPIGetOwner()
end

function ENT:PlayerUse(isOwner)
	local ent = self
	--isOwner = false
	if (ent:GetPos():Distance(LocalPlayer():GetPos()) >= 80) then return end

	if isOwner then
		self.BaseClass.PlayerUse(self)
	else
		local fr = ui.Create('ui_frame', function(self)
			self:SetSize(268, 264)
			self:SetTitle('Roulette')
			self:SetPos((ScrW() * 0.5) - (self:GetWide() * 0.5), ScrH() * 0.5)
			self:MakePopup()
			self.Think = function()
				if (not IsValid(ent)) or (ent:GetPos():Distance(LocalPlayer():GetPos()) >= 80) or (not ent:GetInService()) then
					self:Close()
				end
			end
		end)

		fr.Btns = {}

		local x, y = fr:GetDockPos()

		ui.Label('Числа (28x)', 'ui.18', x, y, fr)

		local c, row = 0, -1
		y = y + 20
		for i = 1, 30 do
			fr.Btns[i] = ui.Create('ui_button', function(self)
				self:SetText(i)
				self:SetSize(25, 25)

				if (c % 10 == 0) then
					c = 0
					row = row + 1
				end

				self:SetPos(x + (c * 26), y + (row * 26))
				self:SetTextColor(ui.col.White)
				self.Paint = function(self, w, h)
					local btnColor = (i % 2 == 0) and ui.col.FlatBlack or ui.col.DarkRed

					draw.OutlinedBox(0, 0, w, h, btnColor, (fr.Bet == i) and ui.col.White or btnColor)
				end
				self.DoClick = function()
					fr.Bet = (fr.Bet == i) and nil or i
					sendBet(i)
				end

				c = c + 1
			end, fr)
		end

		y = y + 80

		ui.Label('Нули (14x)', 'ui.18', x, y, fr)

		y = y + 20

		ui.Create('ui_button', function(self)
			self:SetText('Нуль')
			self:SetSize(fr:GetWide() - 10, 25)
			self:SetPos(5, y)
			self:SetTextColor(ui.col.White)
			self.DoClick = function()
				fr.Bet = 0
				sendBet(0)
			end
			self.Paint = function(self, w, h)
				draw.OutlinedBox(0, 0, w, h, ui.col.DarkGreen, (fr.Bet == 0) and ui.col.White or ui.col.DarkGreen)
			end
		end, fr)
		y = y + 26

		ui.Label('Цвета (2x)', 'ui.18', x, y, fr)

		local black = ui.Create('ui_button', function(self)
			self:SetText('Красный (Нечёт)')
			self:SetSize((fr:GetWide() * 0.5) - 5.5, 25)
			self:SetPos(5, fr:GetTall() - 64)
			self:SetTextColor(ui.col.White)
			self.DoClick = function()
				fr.Bet = 32
				sendBet(32)
			end
			self.Paint = function(self, w, h)
				draw.OutlinedBox(0, 0, w, h, ui.col.DarkRed, (fr.Bet == 32) and ui.col.White or ui.col.DarkRed)
			end
		end, fr)

		ui.Create('ui_button', function(self)
			self:SetText('Чёрный (Чёт)')
			self:SetSize((fr:GetWide() * 0.5) - 5.5, 25)
			self:SetPos(black:GetWide() + 6, fr:GetTall() - 64)
			self:SetTextColor(ui.col.White)
			self.DoClick = function()
				fr.Bet = 33
				sendBet(33)
			end
			self.Paint = function(self, w, h)
				draw.OutlinedBox(0, 0, w, h, ui.col.FlatBlack, (fr.Bet == 33) and ui.col.White or ui.col.FlatBlack)
			end
		end, fr)

		ui.Create('ui_button', function(self)
			self:SetText('Place Bet')
			self:SetSize(fr:GetWide() - 10, 30)
			self:SetPos(5, fr:GetTall() - 35)
			self.DoClick = function()
				ent:SendPlayerUse()
			end
			self.Think = function()
				self:SetDisabled(fr.Bet == nil)
				self:SetText(fr.Bet == nil and 'Выберите Ставку' or 'Поставить Ставку')
			end
		end, fr)
	end
end