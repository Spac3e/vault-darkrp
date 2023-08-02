pdash.IncludeCL 'cl_init.lua'
pdash.IncludeSH 'shared.lua'

util.AddNetworkString('rp.gambling.Profit')
util.AddNetworkString('rp.gambling.Loss')

function ENT:Initialize()
	self:SetModel('models/sup/gamblingmachine/machine.mdl')

	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
	self:SetUseType(SIMPLE_USE)

	self:Setprice(self.MinPrice)
	self:SetInService(false)

	self:PhysWake()
end

local function MachineService(pl)
	local ent = pl:GetEyeTrace().Entity
	if ent.ItemOwner == pl and ent.Base == 'gambling_machine_base' then
		if ent:GetIsPayingOut() then return end
		if ent:GetInService() then
			ent:SetInService(false)
			rp.Notify(ent.ItemOwner, NOTIFY_GENERIC, term.Get('GamblingMachineIOutService'))
		else
			ent:SetInService(true)
			rp.Notify(ent.ItemOwner, NOTIFY_GENERIC, term.Get('GamblingMachineInService'))
		end
	end
end
rp.AddCommand('setmachineservice', MachineService)