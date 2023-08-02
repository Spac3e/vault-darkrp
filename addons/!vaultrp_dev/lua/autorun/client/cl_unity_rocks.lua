local posy = 0
local opacity = 100
local text = ""
local ActiveInterpolation = true
local isdimond = false

function LootLog(str,isdimondz)
	text =    str 
	opacity = 100
	posy =    0
	ActiveInterpolation = false
	isdimond = isdimondz
	timer.Simple(1,function() ActiveInterpolation = true end)
end

net.Receive("LootLog",function(l,p)
	if p~=nil then return end
	LootLog( unpack(net.ReadTable()) )
end)

hook.Add("HUDPaint","LootHint",function() 
	if ActiveInterpolation then posy = Lerp(0.02,posy,ScrH()/2 + 10)
	opacity = Lerp(0.03,opacity,0) end
	if not isdimond then 
		draw.SimpleText(text,"DermaLarge",ScrW()/2,(ScrH()/2)+posy,Color(255,255,255,opacity),1,1)
	else
		draw.SimpleText(text,"DermaLarge",ScrW()/2 + math.random()*12,(ScrH()/2)+math.random()*12+posy,HSVToColor( (CurTime()*100)%360,1,1 ),1,1)
	end
end)