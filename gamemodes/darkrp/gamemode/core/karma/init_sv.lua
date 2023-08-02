local meta = FindMetaTable 'Player'

local function name_format(str)
    local buff = str
    buff:Replace(' ', '')

    return util.Base64Encode(buff):lower():Replace('+', '')
end

function meta:GetSkillStat(skill)
    local name = name_format(skill.Name)

    return {
        level 			= self:GetPData(name, 0),
        quantifier 		= isfunction(skill.Hooks[tonumber(self:GetPData(name, 0))]) and skill.Hooks[tonumber(self:GetPData(name, 0))]() or skill.Hooks[tonumber(self:GetPData(name, 0))],
        nextlevel_price = skill.Price[math.min(3, tonumber(self:GetPData(name, 0)) + 1)],
        name 			= name,
        other 			= skill
    }
end

function meta:SetSkillLevel(skill, level)
    local name = name_format(skill.Name)
    self:SetPData(name, level)
end

function meta:GetSkillLevel(skill)
    return tonumber(self:GetSkillStat(skill).level)
end

function meta:SkillQuantifier(skill)
    return self:GetSkillStat(skill).quantifier
end

function meta:SkillUpable(skill)
    return self:GetSkillLevel(skill) < 3
end

function meta:GetSkills()
    local buff = {}

    for k, v in next, rp.skills do
        local temp = self:GetSkillStat(v)

        for key, hk in next, temp.other.Hooks do
            temp.other.Hooks[key] = isfunction(hk) and hk() or tonumber(hk)
        end

        buff[k] = temp
    end

    return buff
end

function meta:AffectRunner()
    self:SetRunSpeed(self:GetRunSpeed() * self:SkillQuantifier(rp.skills.SKILL_RUN))
end

function meta:AffectJumper()
    self:SetJumpPower(self:GetJumpPower() * self:SkillQuantifier(rp.skills.SKILL_JUMP))
end

hook.Add('PlayerSpawn', 'Affect', function(ply)
    timer.Simple(0, function()
        ply:AffectRunner()
        ply:AffectJumper()
    end)
end)

--[[Net interface]]
--
util.AddNetworkString('skill_channel')

net.Receive('skill_channel', function(len, ply)
    local tb = net.ReadTable()

    if tb['method'] == 'receive' then
        net.Start 'skill_channel'
        net.WriteTable(ply:GetSkills())
        net.Send(ply)
    elseif tb['method'] == 'buy' then
        local destination = rp.skills[tb['key']]
        local extracted = ply:GetSkillStat(destination)

        if ply:SkillUpable(destination) then
            if ply:CanKarmaAfford(extracted.nextlevel_price) then
                ply:AddKarma(-extracted.nextlevel_price)
                ply:SetSkillLevel(destination, ply:GetSkillLevel(destination) + 1)
                net.Start 'skill_channel'
                net.WriteTable(ply:GetSkills())
                net.Send(ply)
            else
                ply:ChatPrint('[Skills] Недостаточно кармы. Карму можно получить, играя на сервере или купить в /donate')
            end
     -- else
            -- ply:ChatPrint('[Skills] Вы уже достигли максимального уровня, мастер!')
        end
    end
end)


/*
	        if ply:SkillUpable(destination) then
            if IGS.CanAfford(ply, extracted.nextlevel_price) then
                ply:AddIGSFunds(- extracted.nextlevel_price)
                ply:SetSkillLevel(destination, ply:GetSkillLevel(destination) + 1)
                net.Start'skill_channel'
                net.WriteTable(ply:GetSkills())
                net.Send(ply)
            else
                ply:ChatPrint('[Skills] Недостаточно рублей. /donate чтобы пополнить.')
            end
        else
            ply:ChatPrint('[Skills] Вы уже достигли максимального уровня, мастер!')
        end
*/

hook.Add('PlayerInitialSpawn', 'AddTimeKarma', function()
	timer.Create('AddTimeKarma', 1200, 0, function()
		for k, v in ipairs(player.GetAll()) do
			if v:IsBanned() then return end
            
            v:AddKarma(25)
			rp.Notify(v, NOTIFY_SUCCESS, 'Вы получили 25 кармы за игру на сервере. Вы получите ещё 25 через 20 минут.')
		end
	end)
end)