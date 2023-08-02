/*ba.sitsync = ba.sitsync or {}
ba.sitsync.Cache = ba.sitsync.Cache or {}
ba.sitsync.ServerNetRef = {}
ba.sitsync.ServerNetNum = {}

ba.sitsync.Servers = {
	{"Vault HALF-LIFE 2 RP",	"W"},
}

for k, v in ipairs(ba.sitsync.Servers) do
	v.ID = v[1]
	v.IP = v[2]
	v.Name = v[3] or v[1]

	ba.sitsync.ServerNetRef[k - 1] = v
	ba.sitsync.ServerNetNum[v.ID] = k - 1
end
*/
