plib.IncludeSH 'shared.lua'

local color_white = ui.col.White:Copy()
local color_black = ui.col.Black:Copy()

local complex_off = Vector(0, 0, 9)

local mat = Material("sup/entities/npcs/george.png")

local ang = Angle(0, 90, 90)
function ENT:Draw()
	self:DrawModel()

	local bone = self:LookupBone('ValveBiped.Bip01_Head1')
	pos = self:GetBonePosition(bone) + complex_off

	ang.y = (LocalPlayer():EyeAngles().y - 90)

	local inView, dist = self:InDistance(150000)

	if (not inView) then return end

	local alpha = 255 - (dist/590)
	color_white.a = alpha
	color_black.a = alpha

	local x = math.sin(CurTime() * math.pi) * 30

	cam.Start3D2D(pos, ang, 0.03)
		draw.SimpleTextOutlined('Отец Георгий', '3d2d', 0, 0, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_BOTTOM, 1, color_black)
		surface.SetDrawColor(255, 255, 255)
		surface.SetMaterial(mat)
		surface.DrawTexturedRect(-64, -260, 128, 128)	
	cam.End3D2D()
end

local entryVoice = {
	"bucket_thereyouare",
	"engage01",
	"engage04",
	"engage05",
	"engage07",
	"engage08",
	"engage09",
	"grave_follow",
	"monk_givehealth01",
	"monk_kill01",
	"monk_kill02",
	"monk_kill11",
	"pyre_anotherlife",
	"wrongside_mendways",
	"yard_greetings"
}

local exitVoice = {
	"exit_darkroad",
	"exit_salvation",
	"firetrap_welldone",
	"madlaugh01",
	"madlaugh02",
	"madlaugh03",
	"madlaugh04",
	"monk_kill03",
	"monk_kill04",
	"monk_kill05",
	"monk_kill07",
	"monk_kill08",
	"monk_kill09",
	"monk_kill10",
	"monk_mourn07"
}

function EmitEntryVoice()
	local rand = math.random(1, #entryVoice)
	LocalPlayer():EmitSound(string.format("vo/ravenholm/%s.wav", entryVoice[rand]), 65)
end

function EmitExitVoice()
	local rand = math.random(1, #exitVoice)
	LocalPlayer():EmitSound(string.format("vo/ravenholm/%s.wav", exitVoice[rand]), 65)
end

local fr
net('rp::KarmaBuy', function(len, pl)
	local ent = self

	if IsValid(fr) then fr:Close() end

	fr = ui.Create('ui_frame', function(self)
		self:SetTitle('Отец Геогрий')
		self:SetSize(315, 272)
		self:Center()
		self:MakePopup()
	end)

	local lbl = ui.Create('DLabel', function(self, p)
		self:SetPos(5, 30)
		self:SetText('Очистись от нечести.\nПокайся денежно, грешник\nСделайте пожертвование чтобы\nповысить свою карму.')
		self:SizeToContents()
	end, fr)

	local karmaLbl = ui.Create('DLabel', function(self, p)
		self:SetPos(5, lbl.y + lbl:GetTall() + 5)
		self:SetText('Карма:')
		self:SetFont('ui.18')
		self:SizeToContents()
	end, fr)

	local money
	local karma = ui.Create('DNumberWang', function(self, p)
		self:SetPos(5, karmaLbl.y + karmaLbl:GetTall() + 5)
		self:SetSize(p:GetWide() - 10, 30)

		self:SetMinMax(0, math.floor(LocalPlayer():GetMoney()/rp.cfg.MoneyPerKarma))
		self:SetValue(100)
		self:SetInterval(100)

		self.OnChange = function(self, num)
			local num = self:GetValue()
			money:SetValue(math.floor(num * rp.cfg.MoneyPerKarma))
		end
	end, fr)

	local moneyLbl = ui.Create('DLabel', function(self, p)
		self:SetPos(5, karma.y + karma:GetTall() + 5)
		self:SetText('Деньги:')
		self:SetFont('ui.18')
		self:SizeToContents()
	end, fr)

	money = ui.Create('DNumberWang', function(self, p)
		self:SetPos(5, moneyLbl.y + moneyLbl:GetTall() + 5)
		self:SetSize(p:GetWide() - 10, 30)

		self:SetMinMax(0, math.floor(LocalPlayer():GetMoney() * rp.cfg.MoneyPerKarma))
		self:SetValue(math.floor(karma:GetValue()*rp.cfg.MoneyPerKarma))
		self:SetInterval(1000)

		self.OnChange = function(self, num)
			local num = self:GetValue()
			karma:SetValue(math.floor(num/rp.cfg.MoneyPerKarma))
		end
	end, fr)

	ui.Create('ui_button', function(self, p)
		self:SetPos(5, money.y + money:GetTall() + 5)
		self:SetSize(p:GetWide() - 10, 30)
		self:SetText('Купить Карму')
		self.Think = function(s)
			local value = tonumber(money:GetValue())
			if (value == nil) or (value < 0) then
				self:SetDisabled(true)
				self:SetText('Неверная сумма!')
			elseif (value < rp.cfg.MoneyPerKarma) then
				self:SetDisabled(true)
				self:SetText('Сумма слишком низкая!')
			elseif (value > LocalPlayer():GetMoney()) then
				self:SetDisabled(true)
				self:SetText('Недостаточно Средств!')
			else
				self:SetDisabled(false)
				self:SetText('Купить ' .. string.Comma(math.floor(value/rp.cfg.MoneyPerKarma)) .. ' Кармы')
			end
		end
		self.DoClick = function()
			cmd.Run("buykarma", money:GetValue())
			EmitExitVoice()
		end
	end, fr)

	fr:SizeToContents()
	EmitEntryVoice()
end)