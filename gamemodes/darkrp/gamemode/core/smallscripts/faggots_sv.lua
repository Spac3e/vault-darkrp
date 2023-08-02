-- weapontable = {
-- 	['Легкое'] = {
-- 		'swb_357',
-- 		'swb_deagle',
-- 		'swb_fiveseven',
-- 		'swb_glock18',
-- 		'swb_p228',
-- 		'swb_usp',
-- 		-- submachines
-- 		'swb_p90',
-- 		'swb_mp5',
-- 		'swb_ump',
-- 		'swb_mac10',
-- 		'swb_tmp',
-- 		-- knife
-- 		'swb_knife'
-- 	},
-- 	['Тяжелое'] = {
-- 		'swb_ak47',
-- 		'swb_famas',
-- 		'swb_galil',
-- 		'swb_m249',
-- 		'swb_m4a1',
-- 		'swb_sg550',
-- 		'swb_sg552',
-- 		'swb_aug',
-- 		-- shotgun
-- 		'swb_m3super90',
-- 		'swb_xm1014',
-- 		-- sniper
-- 		'swb_g3sg1',
-- 		'swb_scout',
-- 		'swb_awp'
-- 	},
-- 	['all'] = {},	
-- }

-- allowed = {
-- 	['TEAM_CITIZEN'] 	= {'Легкое'},
-- 	['TEAM_ADMIN'] 		= {'all'},
-- 	-- 
-- 	['TEAM_HOBOKING'] 	= {'Легкое'},
-- 	['TEAM_HOBO'] 		= {'Легкое'},
-- 	-- Gov
-- 	['TEAM_MAYOR'] 		= {'all'},
-- 	['TEAM_POLICE'] 	= {'all'},
-- 	['TEAM_CHIEF'] 		= {'all'},
-- 	['TEAM_FBR'] 		= {'all'},
-- 	['TEAM_SWAT'] 		= {'all'},
-- 	['TEAM_SWATLEADER'] = {'all'},
-- 	-- 
-- 	['TEAM_MOBBOSS'] 	= {'all'},
-- 	['TEAM_GANGSTER'] 	= {'all'},
-- 	['TEAM_VIPGANGSTER']= {'all'},
-- 	['TEAM_THUG'] 		= {'all'},
-- 	['TEAM_THIEF'] 		= {'Легкое'},
-- 	['TEAM_THIEFPRO'] 	= {'Легкое'},
-- 	['TEAM_HACKER'] 	= {'Легкое'},
-- 	['TEAM_GUN'] 		= {'all'},
-- 	['TEAM_BMIDEALER'] 	= {'all'},
-- 	['TEAM_METAVAR'] 	= {'Легкое'},
-- 	['TEAM_DRUGDEALER'] = {'Легкое'},
-- 	['TEAM_DRUGMAKER'] 	= {'Легкое'},
-- 	['TEAM_BARTENDER'] 	= {'Легкое'},
-- 	['TEAM_COOK'] 		= {'Легкое'},
-- 	['TEAM_HITMAN'] 	= {'all'},
-- 	['TEAM_SECURITY'] 	= {'all'},
-- 	['TEAM_BANK'] 		= {'Легкое'},
-- 	['TEAM_DOCTOR'] 	= {'Легкое'},
-- 	['TEAM_FREERUNNER'] = {'Легкое'},
-- 	['TEAM_WHORE'] 		= {'Легкое'},
-- 	['TEAM_PIMP'] 		= {'all'},
-- 	-- ['TEAM_BANNED'] = {}, \\ Это не трогай, я еще их не удалил
-- 	['TEAM_HOTEL']		= {'Легкое'}
-- }

for k,v in pairs(rp.cfg.weapontablez) do
	if k != 'all' then
		table.Add(rp.cfg.weapontablez.all, v)
	end
end

local function GetTeamAllowed(t)
	local a = {}
	for k,v in pairs(rp.cfg.allowedW) do
		if _G[k] != t then
			continue
		end
		if type(v) == 'string' then
			table.Add(a, rp.cfg.weapontablez[v])
		else
			for _, w in pairs(v) do
				table.Add(a, rp.cfg.weapontablez[w])
			end
		end
	end
	return a
end

local function IsTeamAllowed( t, class )
	if table.HasValue(rp.cfg.weapontablez.all, class) then
		local tbl = GetTeamAllowed(t)
		if table.HasValue(tbl, class) then
			return true
		end
		return false
	end
	return true
end

local function NoticeMe( ply, class )
	ply.noticed = ply.noticed or CurTime()
	
	if ply.noticed > CurTime() then return end
	
	ply.noticed = CurTime() + 1
	
	local a = {}
	
	for k,v in pairs(rp.cfg.allowedW) do
		if _G[k] ==  ply:Team() then
			table.Add(a, type(v)=='string' and {v} or v)
			break
		end
	end

	ply:ChatPrint('Вы не можете подобрать ' .. class .. '. Это оружие запрещено для данной профессии')
	ply:ChatPrint('Разрешенное оружие: ' .. (#a == 0 and 'нет разрешенного оружия' or string.Implode(', ', a)))
end

hook.Remove("PlayerCanPickupWeapon","nonrp_faggots")
hook.Add('PlayerCanPickupWeapon','nonrp_debil',function(ply,w) 
	if w ~= nil then 
	if not IsTeamAllowed(ply:Team(), w:GetClass()) then
        NoticeMe(ply, w:GetClass())
        return false
    end
    else
    	return  true
	end
end)

hook.Add('WeaponEquip','s_sosi',function(w,p) 
	
end)