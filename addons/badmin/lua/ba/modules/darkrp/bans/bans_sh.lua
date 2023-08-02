nw.Register('IsBanned', {
	Read     = net.ReadBool,
	Write    = net.WriteBool,
	LocalVar = true
 })
 
nw.Register 'BanData'
	:Write(function(data)
		net.WriteUInt(data.ID, 32)
 
		net.WriteString(data.AdminName)
		net.WriteString(tostring(data.AdminSteamID))
		net.WriteString(data.Reason)
		net.WriteString(data.Time)
		net.WriteString(data.Length)
		 --net.WriteString(data.BanTime)
		 --net.WriteString(data.Reason)
		 --net.WriteString(data.BanAdmin)
	end)
	:Read(function(len)
		return {
			ID = net.ReadUInt(32),
 
			AdminName = net.ReadString(),
			AdminSteamID = net.ReadString(),
			Reason = net.ReadString(),
			Time = net.ReadString(),
			Length = net.ReadString(),
 
			--BanTime = net.ReadString(),
			--Reason = net.ReadString(),
			--BanAdmin = net.ReadString()
		}
	end)
	:SetLocalPlayer()
	:SetHook("OnBanDataChanged")
	 
function PLAYER:GetBannedInfo()
	return self:GetNetVar('BanData')
end
 
function PLAYER:IsBanned()
	return (self:GetNetVar('IsBanned') == true)
end 