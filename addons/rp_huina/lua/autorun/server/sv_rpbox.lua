local prefix = rp_box.NPC_name .. ": "
local function return_old_speed(ply)
	ply:SetNWBool("TakeBox", false)
	ply:SetWalkSpeed(ply.OldWalkSpeed)
	ply:SetRunSpeed(ply.OldRunSpeed)
	ply:SetMaxSpeed(ply.OldMaxSpeed)
	ply:SetCanWalk( true )
	ply:StripWeapon("rp_box_in_hands")
end
hook.Add( "KeyPress", "BreakBox", function( ply, key )
	if ply:GetNWBool("TakeBox", false) == true then
		if ( key == IN_JUMP ) then
			ply:EmitSound( "physics/wood/wood_crate_break"..math.random(1,5)..".wav" )
			return_old_speed(ply)
			ply:addMoney(-250)
			ply:SendMessageFD(Color(0,255,128), prefix, Color(255,255,255), "Ты сломал коробку! Не прыгай с ней! минус 250$")
		end
		if ( key == IN_WALK ) then
			ply:EmitSound( "physics/wood/wood_crate_break"..math.random(1,5)..".wav" )
			return_old_speed(ply)
			ply:addMoney(-250)
			ply:SendMessageFD(Color(0,255,128), prefix, Color(255,255,255), "Ты сломал коробку! Не бегай с ней больше! минус 250$")
		end
		if ( key == IN_DUCK ) then
			ply:EmitSound( "physics/wood/wood_crate_break"..math.random(1,5)..".wav" )
			return_old_speed(ply)
			ply:addMoney(-250)
			ply:SendMessageFD(Color(0,255,128), prefix, Color(255,255,255), "Ты сломал коробку! Не пытайся тащить ее на корточках! минус 250$")
		end
		if ( key == IN_SPEED ) then
			ply:EmitSound( "physics/wood/wood_crate_break"..math.random(1,5)..".wav" )
			return_old_speed(ply)
			ply:addMoney(-250)
			ply:SendMessageFD(Color(0,255,128), prefix, Color(255,255,255), "Ты сломал коробку! Не бегай с ней больше! минус 250$")
		end
	end
end )
hook.Add("PlayerUse","GiveBoxAshot",function(ply,ent)
	if ent:GetClass() == "npc_ashot" then
		if IsValid(ply) and ply:IsPlayer() and ply:Alive() and (ent:GetPos():Distance(ply:GetPos()) < 130) then
			if ply:GetNWBool("TakeBox", false) == true then
				return_old_speed(ply)
				ply:addMoney(rp_box.MoneyForBox)
				ply:SendMessageFD(Color(0,255,128), prefix, Color(255,255,255), "Спасибо, вот твои ".. rp_box.MoneyForBox .. "$")
			else
			end
		end
	end
end)