ba.ranks.Create('Root', 16)
	:SetImmunity(16000)
	:SetRoot(true)

ba.ranks.Create('Sudo-root', 15)
	:SetImmunity(15000)
	:SetRoot(true)

ba.ranks.Create('HeadCurator', 14)
	:SetImmunity(14000)
	:SetFlags('uvmasoqkpwhd')
	:SetSuperAdmin(true)

ba.ranks.Create('Curator', 13)
	:SetImmunity(13000)
	:SetFlags('uvmasoqkphd')
	:SetSuperAdmin(true)

ba.ranks.Create('Global-admin', 12)
	:SetImmunity(12000)
	:SetFlags('uvmasoqkpd')
	:SetAdmin(true)

ba.ranks.Create('Head-admin', 11)
	:SetImmunity(11000)
	:SetFlags('uvmasoqkpd')
	:SetAdmin(true)

ba.ranks.Create('StAdmin', 10)
	:SetImmunity(9000)
	:SetFlags('uvmasqkph')
	:SetAdmin(true)

ba.ranks.Create('EventManager', 9)
	:SetImmunity(8000)
	:SetFlags('uvmap')
	:SetAdmin(true)
	:SetMaxBan( 7 * 86400, "7d" )

ba.ranks.Create('Owner', 8)
	:SetImmunity(7000)
	:SetFlags('uvmaqp')
	:SetAdmin(true)

ba.ranks.Create('DSuperAdmin', 7)
	:SetImmunity(6000)
	:SetFlags('uvmap')
	:SetAdmin(true)
	:SetMaxBan( 30 * 86400, "30d" )
	
ba.ranks.Create('Admin', 6)
	:SetImmunity(5000)
	:SetFlags('uvmap')
	:SetAdmin(true)
	:SetMaxBan( 7 * 86400, "7d" )

ba.ranks.Create('DAdmin', 5)
	:SetImmunity(4000)
	:SetFlags('uvmap')
	:SetAdmin(true)
	:SetMaxBan( 3 * 86400, "3d" )

ba.ranks.Create('Moderator', 4)
	:SetImmunity(3000)
	:SetFlags('uvmp')
	:SetAdmin(true)
	:SetMaxBan( 1 * 86400, "1d" )

ba.ranks.Create('DModerator', 3)
	:SetImmunity(2000)
	:SetFlags('uvmp')
	:SetAdmin(true)
	:SetMaxBan( 1 * 3600, "1h" )
	
ba.ranks.Create('VIP', 2)
	:SetImmunity(1000)
	:SetFlags('uv')
	:SetVIP(true)

ba.ranks.Create('User', 1)
	:SetImmunity(0)
	:SetFlags('u')
		

