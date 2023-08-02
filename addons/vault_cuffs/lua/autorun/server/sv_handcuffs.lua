hook.Add('PostPlayerDeath', 'ResetPlayer', function(ply)
	if ply:GetNWBool('isHandcuffed') == true then
		ply:SetNWBool('isHandcuffed', false)
		ply:SetNWBool('isLockpicking', false)
		ply:ManipulateBoneAngles(ply:LookupBone('ValveBiped.Bip01_L_UpperArm'), Angle(0, 0, 0)) -- Left UpperArm
		ply:ManipulateBoneAngles(ply:LookupBone('ValveBiped.Bip01_L_Forearm'), Angle(0, 0, 0)) -- Left ForeArm
		ply:ManipulateBoneAngles(ply:LookupBone('ValveBiped.Bip01_L_Hand'), Angle(0, 0, 0)) -- Left Hand
		ply:ManipulateBoneAngles(ply:LookupBone('ValveBiped.Bip01_R_Forearm'), Angle(0, 0, 0)) -- Right Forearm
		ply:ManipulateBoneAngles(ply:LookupBone('ValveBiped.Bip01_R_Hand'), Angle(0, 0, 0)) -- Right Hand
		ply:ManipulateBoneAngles(ply:LookupBone('ValveBiped.Bip01_R_UpperArm'), Angle(0, 0, 0)) -- Right Upperarm
	end
end)
-- за на пянгвин все сделав
hook.Add('PlayerInitialSpawn', 'ResetPlayerOnJoin', function(ply)
	if ply:GetNWBool('isHandcuffed') == true then
		ply:SetNWBool('isHandcuffed', false)
		ply:SetNWBool('isLockpicking', false)
		ply:ManipulateBoneAngles(ply:LookupBone('ValveBiped.Bip01_L_UpperArm'), Angle(0, 0, 0)) -- Left UpperArm
		ply:ManipulateBoneAngles(ply:LookupBone('ValveBiped.Bip01_L_Forearm'), Angle(0, 0, 0)) -- Left ForeArm
		ply:ManipulateBoneAngles(ply:LookupBone('ValveBiped.Bip01_L_Hand'), Angle(0, 0, 0)) -- Left Hand
		ply:ManipulateBoneAngles(ply:LookupBone('ValveBiped.Bip01_R_Forearm'), Angle(0, 0, 0)) -- Right Forearm
		ply:ManipulateBoneAngles(ply:LookupBone('ValveBiped.Bip01_R_Hand'), Angle(0, 0, 0)) -- Right Hand
		ply:ManipulateBoneAngles(ply:LookupBone('ValveBiped.Bip01_R_UpperArm'), Angle(0, 0, 0)) -- Right Upperarm
	end
end)
-- за на пянгвин все сделав
hook.Add("PlayerArrested", "ResetPlayerOnArrest", function(ply)
	if ply:GetNWBool('isHandcuffed') == true then
		ply:SetNWBool('isHandcuffed', false)
		ply:SetNWBool('isLockpicking', false)
		ply:ManipulateBoneAngles(ply:LookupBone('ValveBiped.Bip01_L_UpperArm'), Angle(0, 0, 0)) -- Left UpperArm
		ply:ManipulateBoneAngles(ply:LookupBone('ValveBiped.Bip01_L_Forearm'), Angle(0, 0, 0)) -- Left ForeArm
		ply:ManipulateBoneAngles(ply:LookupBone('ValveBiped.Bip01_L_Hand'), Angle(0, 0, 0)) -- Left Hand
		ply:ManipulateBoneAngles(ply:LookupBone('ValveBiped.Bip01_R_Forearm'), Angle(0, 0, 0)) -- Right Forearm
		ply:ManipulateBoneAngles(ply:LookupBone('ValveBiped.Bip01_R_Hand'), Angle(0, 0, 0)) -- Right Hand
		ply:ManipulateBoneAngles(ply:LookupBone('ValveBiped.Bip01_R_UpperArm'), Angle(0, 0, 0)) -- Right Upperarm
	end
end)
-- за на пянгвин все сделав
hook.Add('PlayerUnArrested', 'ResetPlayerOnUnarrest', function(ply)
	if ply:GetNWBool('isHandcuffed') == true then
		ply:SetNWBool('isHandcuffed', false)
		ply:SetNWBool('isLockpicking', false)
		ply:ManipulateBoneAngles(ply:LookupBone('ValveBiped.Bip01_L_UpperArm'), Angle(0, 0, 0)) -- Left UpperArm
		ply:ManipulateBoneAngles(ply:LookupBone('ValveBiped.Bip01_L_Forearm'), Angle(0, 0, 0)) -- Left ForeArm
		ply:ManipulateBoneAngles(ply:LookupBone('ValveBiped.Bip01_L_Hand'), Angle(0, 0, 0)) -- Left Hand
		ply:ManipulateBoneAngles(ply:LookupBone('ValveBiped.Bip01_R_Forearm'), Angle(0, 0, 0)) -- Right Forearm
		ply:ManipulateBoneAngles(ply:LookupBone('ValveBiped.Bip01_R_Hand'), Angle(0, 0, 0)) -- Right Hand
		ply:ManipulateBoneAngles(ply:LookupBone('ValveBiped.Bip01_R_UpperArm'), Angle(0, 0, 0)) -- Right Upperarm
	end
end)
-- за на пянгвин все сделав