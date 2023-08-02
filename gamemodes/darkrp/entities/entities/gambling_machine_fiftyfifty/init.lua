pdash.IncludeCL 'cl_init.lua'
pdash.IncludeSH 'shared.lua'

function ENT:Initialize()
	self.BaseClass.Initialize(self)

	self:SetSubMaterial(2, 'sup/entities/fiftyfifty/light')
	self:SetSubMaterial(6, 'sup/entities/fiftyfifty/ad_top')
	self:SetSubMaterial(7, 'sup/entities/fiftyfifty/background')
	self:SetSubMaterial(16, 'sup/entities/fiftyfifty/ad_bottom')
end

function ENT:Use(activator, caller)
	if self.ItemOwner == activator then
		self:PlayerUse(activator)
	else
		if !self:GetInService() or self:GetIsPayingOut() then return end
		if !activator:CanAfford(self:Getprice()) then rp.Notify(activator, NOTIFY_ERROR, term.Get('GamblingMachinePlayerCannotAfford'), 'FiftyFifty') return end
		if !self.ItemOwner:CanAfford(self:Getprice() * 2) then
			rp.Notify(activator, NOTIFY_ERROR, term.Get('GamblingMachineOwnerCannotAfford'), 'FiftyFifty')
			rp.Notify(self.ItemOwner, NOTIFY_ERROR, term.Get('GamblingMachineHouseCannotAfford'), 'FiftyFifty')
			self:SetInService(false)
			return
		end
		self:SetIsPayingOut(true)
		activator:TakeMoney(self:Getprice())
		self.ItemOwner:AddMoney(self:Getprice())
		timer.Simple(1,function()
			self:SetPlayerRoll(math.random(1,100))
			self:SetHouseRoll(math.random(1,100))
			if self:GetPlayerRoll() > self:GetHouseRoll() then
				self.ItemOwner:TakeMoney(self:Getprice() * 2)
				activator:AddMoney(self:Getprice() * 2)
				rp.Notify(activator, NOTIFY_SUCCESS, term.Get('5050PlayerWin'), rp.FormatMoney(self:Getprice() * 2))
				net.Start('rp.gambling.Loss')
				net.WriteUInt(self:Getprice() * 2,32)
				net.Send(self.ItemOwner)
			elseif self:GetPlayerRoll() < self:GetHouseRoll() then
				rp.Notify(activator, NOTIFY_ERROR, term.Get('5050PlayerLose'), rp.FormatMoney(self:Getprice()))
				activator:SetPData('losscasinocount', activator:GetPData('losscasinocount', 0) + self:Getprice())
				net.Start('rp.gambling.Profit')
				net.WriteUInt(self:Getprice(),32)
				net.Send(self.ItemOwner)
			else
				self.ItemOwner:TakeMoney(self:Getprice())
				activator:AddMoney(self:Getprice())
				rp.Notify(activator, NOTIFY_GENERIC, term.Get('5050Tie'))
			end
			self:SetIsPayingOut(false)
		end)
	end
end