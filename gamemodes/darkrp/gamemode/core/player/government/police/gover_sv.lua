util.AddNetworkString('rp.GovernmentRequare_vec')
util.AddNetworkString('rp.GovernmentRequare')

net.Receive('rp.GovernmentRequare',function(len,ply)
	local rsn = net.ReadString()
	if rsn == '' then rp.Notify(ply,1,'Не указана причина!') return end
	if ply:IsCP() then rp.Notify(ply,1,'Нельзя полиции') return end
	if ply.cdcp == nil then ply.cdcp = CurTime() end
	if ply.cdcp > CurTime() then rp.Notify(ply,1,'Попробуйте через '..math.Round(ply.cdcp - CurTime())..' сек.') return end
	rp.Notify(ply,3,'Вы вызвали полицию')
	ply.cdcp = 300 + CurTime()
	for k,v in pairs(player.GetAll()) do
		if !v:IsCP() then continue end
		net.Start('rp.GovernmentRequare')
		net.WriteEntity(ply)
		net.WriteString(rsn)
		net.Send(v)
	end
end)

function CP_Call(vec,str)
	for k,v in pairs(player.GetAll()) do
		if !v:IsCP() then continue end
		net.Start('rp.GovernmentRequare_vec')
		net.WriteVector(vec)
		net.WriteString(str)
		net.Send(v)
	end
end
