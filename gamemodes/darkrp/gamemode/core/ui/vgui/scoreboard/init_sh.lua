local os_translations = {
	[1] = 'windows',
	[2]	= 'macos',
	[3] = 'linux'
}

function PLAYER:GetCountry()
	return self:GetNetVar('Country') or 'ru'
end

function PLAYER:GetPlayTimeRank()
	local setRank = self:GetNetVar('PlayTimeRank')
	if setRank then
		return rp.cfg.PlayTimeRanks[setRank][1]
	end

	local lastRank = ''
	for k, v in ipairs(rp.cfg.PlayTimeRanks) do
		if (self:GetPlayTime() > v[2]) then
			lastRank = v[1]
		else
			return lastRank
		end
	end
	return lastRank
end

nw.Register 'Country'
	:Write(net.WriteString)
	:Read(net.ReadString)
	:SetPlayer()