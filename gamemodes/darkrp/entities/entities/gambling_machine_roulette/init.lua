pdash.IncludeCL 'cl_init.lua'
pdash.IncludeSH 'shared.lua'

util.AddNetworkString('rp.roulette.SetBet')

function ENT:Initialize()
	self.BaseClass.Initialize(self)

	self:SetRoll(1)

	self:SetSubMaterial(2, 'sup/entities/roulette/light')
	self:SetSubMaterial(6, 'sup/entities/roulette/ad_top')
	self:SetSubMaterial(7, 'sup/entities/roulette/background')
	self:SetSubMaterial(16, 'sup/entities/roulette/ad_bottom')
end

function ENT:Use(activator)
	self:PlayerUse(activator)
end

function ENT:EntityUse(activator)
	if !self:GetInService() or self:GetIsPayingOut() then return end
	if !activator:CanAfford(self:Getprice()) then rp.Notify(activator, NOTIFY_ERROR, term.Get('GamblingMachinePlayerCannotAfford'), 'Roulette') return end
	self:SetIsPayingOut(true)
	activator:TakeMoney(self:Getprice())
	self.ItemOwner:AddMoney(self:Getprice())
	self:SetBet(activator.Bet)
	local rand = math.random(10, 50)
	timer.Create('spell' .. self:EntIndex(), .1, rand, function()
		local roll = self:GetRoll()
		if roll == 32 then
			self:SetRoll(1)
		else
			self:SetRoll(roll + 1)
		end
	end)
	local function ownerCantAfford(bet)
		if !self.ItemOwner:CanAfford(self:Getprice() * bet) then
			rp.Notify(activator, NOTIFY_ERROR, term.Get('GamblingMachineOwnerCannotAfford'), 'Roulette')
			rp.Notify(self.ItemOwner, NOTIFY_ERROR, term.Get('GamblingMachineHouseCannotAfford'), 'Roulette')
			self:SetInService(false)
			self:SetIsPayingOut(false)
			return
		end
	end
	local time = (rand / 10) + .1
	timer.Simple(time, function()
		local roll = self:GetRoll()
		local num = roll < 17 and 1 or 2
		local bet = activator.Bet
		local win = bet == 0 and 14 or (bet == 32 or bet == 33) and 2 or 28
		if (bet == 32 and (roll + num) % 2 != 0) or (bet == 33 and (roll + num) % 2 == 0) or (bet == (roll - num)) or (bet == 0 and (roll == 1 or roll == 17)) then
			ownerCantAfford(win)
			self.ItemOwner:TakeMoney(self:Getprice() * win)
			activator:AddMoney(self:Getprice() * win)
			rp.Notify(activator, NOTIFY_SUCCESS, term.Get('RoulettePlayerWin'), rp.FormatMoney(self:Getprice() * win))
			net.Start('rp.gambling.Loss')
			net.WriteUInt(self:Getprice() * win,32)
			net.Send(self.ItemOwner)
		else
			rp.Notify(activator, NOTIFY_ERROR, term.Get('RoulettePlayerLose'), rp.FormatMoney(self:Getprice()))
			activator:SetPData('losscasinocount', activator:GetPData('losscasinocount', 0) + self:Getprice())
			net.Start('rp.gambling.Profit')
			net.WriteUInt(self:Getprice(),32)
			net.Send(self.ItemOwner)
		end
		self:SetIsPayingOut(false)
	end)
end

net('rp.roulette.SetBet', function(_, pl)
	pl.Bet = net.ReadUInt(6)
end)