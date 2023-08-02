pdash.IncludeCL 'cl_init.lua'
pdash.IncludeSH 'shared.lua'

function ENT:Initialize()
	self.BaseClass.Initialize(self)

	self:SetSubMaterial(2, 'sup/entities/spinwheel/light')
	self:SetSubMaterial(6, 'sup/entities/spinwheel/ad_top')
	self:SetSubMaterial(7, 'sup/entities/spinwheel/background')
	self:SetSubMaterial(16, 'sup/entities/spinwheel/ad_bottom')
end

local tablerandom = {
	[0] = 5,
	[8] = 5,
	[16] = 5,
	[24] = 5,
	[32] = 5,
	[40] = 5,
	[7] = -5,
	[15] = -5,
	[23] = -5,
	[31] = -5,
	[39] = -5,
	[47] = -5,
	[6] = 4,
	[14] = 4,
	[22] = 4,
	[38] = 4,
	[46] = 4,
	[54] = 4,
	[5] = -4,
	[13] = -4,
	[21] = -4,
	[37] = -4,
	[45] = -4,
	[53] = -4,
	[4] = 3,
	[12] = 3,
	[20] = 3,
	[36] = 3,
	[44] = 3,
	[52] = 3,
	[3] = -3,
	[11] = -3,
	[19] = -3,
	[35] = -3,
	[43] = -3,
	[51] = -3,
	[27] = -3,
	[2] = 2,
	[10] = 2,
	[18] = 2,
	[34] = 2,
	[42] = 2,
	[50] = 2,
	[26] = 2,
	[1] = -2,
	[9] = -2,
	[17] = -2,
	[33] = -2,
	[41] = -2,
	[49] = -2,
	[25] = -2
}

function ENT:Use(activator, caller)
	if self.ItemOwner == activator then
		self:PlayerUse(activator)
	else
		if !self:GetInService() or self:GetIsPayingOut() then return end
		if !activator:CanAfford(self:Getprice()) then rp.Notify(activator, NOTIFY_ERROR, term.Get('GamblingMachinePlayerCannotAfford'), 'Spin Wheel') return end
		if !self.ItemOwner:CanAfford(self:Getprice() * 5) then
			rp.Notify(activator, NOTIFY_ERROR, term.Get('GamblingMachineOwnerCannotAfford'), 'Spin Wheel')
			rp.Notify(self.ItemOwner, NOTIFY_ERROR, term.Get('GamblingMachineHouseCannotAfford'), 'Spin Wheel')
			self:SetInService(false)
			return
		end
		self:SetIsPayingOut(true)
		activator:TakeMoney(self:Getprice())
		self.ItemOwner:AddMoney(self:Getprice())
		local rand = math.random(30, 72)
		timer.Create('spell' .. self:EntIndex(), .1, 30, function()
			rand = rand - 1
			self:SetRoll(rand)
		end)
		timer.Simple(3.1, function()
			local roll = tablerandom[self:GetRoll()]
			local win1, win2, win3, win4 = roll < 0 and 'SpinWheelPlayerLose' or 'SpinWheelPlayerWin', roll < 0 and NOTIFY_ERROR or NOTIFY_SUCCESS, roll < 0 and 'Profit' or 'Loss', roll < 0 and roll * -1 or roll
			activator:AddMoney(self:Getprice())
			self.ItemOwner:TakeMoney(self:Getprice())
			self.ItemOwner:AddMoney(-self:Getprice() * (tablerandom[self:GetRoll()]))
			activator:AddMoney(self:Getprice() * (tablerandom[self:GetRoll()]))
			if win2 == NOTIFY_ERROR then
				rp.Notify(activator, win2, term.Get(win1), rp.FormatMoney((self:Getprice() * (tablerandom[self:GetRoll()])) * -1))
				activator:SetPData('losscasinocount', activator:GetPData('losscasinocount', 0) + self:Getprice())
			else
				rp.Notify(activator, win2, term.Get(win1), rp.FormatMoney(self:Getprice() * win4))
			end
			net.Start('rp.gambling.' .. win3)
			net.WriteUInt(self:Getprice() * win4, 32)
			net.Send(self.ItemOwner)
			self:SetIsPayingOut(false)
		end)
	end
end