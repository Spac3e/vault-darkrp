AddCSLuaFile()

local BaseClass = baseclass.Get('baton_base')

if CLIENT then
	SWEP.PrintName = 'Арестовать'
	SWEP.Instructions = 'Left click to arrest\nRight click to switch to unarrest'
	SWEP.Slot = 3
    SWEP.SlotPos = 1
end

SWEP.Spawnable = true
SWEP.Category = "RP"

SWEP.Color = Color(255, 0, 0, 255)

function SWEP:PrimaryAttack()
	if not IsValid(self.Owner) then return end

	BaseClass.PrimaryAttack(self)

	if CLIENT then return end

	local ent = self:GetTrace().Entity

	if ent.WantReason and self.Owner:IsCP() then
		local owner = ent.ItemOwner

		if (IsValid(owner)) then
			if (not owner:IsWanted()) and (not owner:IsArrested()) then
				owner:Wanted(self.Owner, ent.WantReason)
			end
		end

		hook.Call('PlayerArrestedEntity', nil, self.Owner, ent, owner)

		ent:Remove()
		self.Owner:AddMoney(ent.SeizeReward)
		rp.Notify(self.Owner, NOTIFY_SUCCESS, term.Get('ArrestBatonBonus'), rp.FormatMoney(ent.SeizeReward))
		return
	end

	if (not ent:IsPlayer()) then return end
	if (not ent:GetNWBool('isHandcuffed')) then
		return rp.Notify(self.Owner, NOTIFY_ERROR, 'Игрок должен быть в наручниках, чтобы арестовать его.')
	end

	ent:Arrest(arrestor)

	rp.Notify(ent, NOTIFY_ERROR, term.Get('ArrestBatonArrested'), self.Owner)
	rp.Notify(self.Owner, NOTIFY_SUCCESS, term.Get('ArrestBatonYouArrested'), ent)
	rp.achievements.AddProgress(self.Owner, ACHIEVEMENT_COPMAIN, 1)
end