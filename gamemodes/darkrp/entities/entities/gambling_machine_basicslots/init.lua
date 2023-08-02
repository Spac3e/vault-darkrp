pdash.IncludeCL 'cl_init.lua'
pdash.IncludeSH 'shared.lua'

function ENT:Initialize()
	self.BaseClass.Initialize(self)

	self:SetSubMaterial(2, 'sup/entities/basicslots/light')
	self:SetSubMaterial(6, 'sup/entities/basicslots/ad_top')
	self:SetSubMaterial(7, 'sup/entities/basicslots/background')
	self:SetSubMaterial(16, 'sup/entities/basicslots/ad_bottom')
end

function ENT:Use(activator, caller)
	if self.ItemOwner == activator then
		self:PlayerUse(activator)
	else
		if !self:GetInService() or self:GetIsPayingOut() then return end
		if !activator:CanAfford(self:Getprice()) then rp.Notify(activator, NOTIFY_ERROR, term.Get('GamblingMachinePlayerCannotAfford'), 'Slots') return end
		if !self.ItemOwner:CanAfford(self:Getprice() * 10) then
			rp.Notify(activator, NOTIFY_ERROR, term.Get('GamblingMachineOwnerCannotAfford'), 'Slots')
			rp.Notify(self.ItemOwner, NOTIFY_ERROR, term.Get('GamblingMachineHouseCannotAfford'), 'Slots')
			self:SetInService(false)
			return
		end
		self:SetIsPayingOut(true)
		activator:TakeMoney(self:Getprice())
		self.ItemOwner:AddMoney(self:Getprice())
		timer.Simple(1,function()
			self:SetRoll1(math.random(0,9))
			self:SetRoll2(math.random(0,9))
			self:SetRoll3(math.random(0,9))
			local roll1 = self:GetRoll1()
			local roll2 = self:GetRoll2()
			local roll3 = self:GetRoll3()
			if roll1 == roll2 and roll1 == roll3 then
				self.ItemOwner:TakeMoney(self:Getprice() * 10)
				activator:AddMoney(self:Getprice() * 10)
				rp.Notify(activator, NOTIFY_SUCCESS, term.Get('BasicSlotsPlayerWin'), rp.FormatMoney(self:Getprice() * 10))
				net.Start('rp.gambling.Loss')
				net.WriteUInt(self:Getprice() * 10,32)
				net.Send(self.ItemOwner)
			elseif roll1 == roll2 or roll2 == roll3 then
				self.ItemOwner:TakeMoney(self:Getprice() * 4)
				activator:AddMoney(self:Getprice() * 4)
				rp.Notify(activator, NOTIFY_SUCCESS, term.Get('BasicSlotsPlayerWin'), rp.FormatMoney(self:Getprice() * 4))
				net.Start('rp.gambling.Loss')
				net.WriteUInt(self:Getprice() * 4,32)
				net.Send(self.ItemOwner)
			else
				rp.Notify(activator, NOTIFY_ERROR, term.Get('BasicSlotsPlayerLose'), rp.FormatMoney(self:Getprice()))
				activator:SetPData('losscasinocount', activator:GetPData('losscasinocount', 0) + self:Getprice())
				net.Start('rp.gambling.Profit')
				net.WriteUInt(self:Getprice(),32)
				net.Send(self.ItemOwner)
			end
			self:SetIsPayingOut(false)
		end)
	end
end