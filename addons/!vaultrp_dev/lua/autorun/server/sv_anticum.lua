hook.Add("PlayerShouldTakeDamage","szaoHah",function(pl,att) 
	att.Team = att.Team or (function() end)
	if att~=nil and pl~=nil then 
		if att ~= Entity(0) then 
		if att:Team() == TEAM_ADMIN then 
			att:ChatPrint("Вы не можете нанести урон, так-как вы в профессии: Администратор")
			return false 
		elseif pl:Team() == TEAM_ADMIN then  
			att:ChatPrint("Вы не можете нанести урон по профессии: Администратор")
			return false
		elseif pl:GetNWInt("graceOn") == 1 then 
			return false 
		end
		else
			return true
		end
	end
end)