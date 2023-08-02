pdash.IncludeCL 'cl_init.lua'
pdash.IncludeSH 'shared.lua'

------------------------------------------------------------------------------------
-- THINGS YOU CAN EDIT
------------------------------------------------------------------------------------
local Dumpster_Items = {
	Props = { --Add/Change models of props
		'models/props_c17/FurnitureShelf001b.mdl',
		'models/props_c17/FurnitureDrawer001a_Chunk02.mdl',
		'models/props_interiors/refrigeratorDoor02a.mdl',
		'models/props_lab/lockerdoorleft.mdl',
		'models/props_wasteland/prison_lamp001c.mdl',
		'models/props_wasteland/prison_shelf002a.mdl',
		'models/props_vehicles/tire001c_car.mdl',
		'models/props_trainstation/traincar_rack001.mdl',
		'models/props_interiors/SinkKitchen01a.mdl',
		'models/props_c17/lampShade001a.mdl', 
		'models/props_junk/PlasticCrate01a.mdl',
		'models/props_c17/metalladder002b.mdl',
		'models/Gibs/HGIBS.mdl',
		'models/props_c17/metalPot001a.mdl',
		'models/props_c17/streetsign002b.mdl',
		'models/props_c17/pottery06a.mdl',
		'models/props_combine/breenbust.mdl',
		'models/props_lab/partsbin01.mdl',
		'models/props_trainstation/payphone_reciever001a.mdl',
		'models/props_vehicles/carparts_door01a.mdl',
		'models/props_vehicles/carparts_axel01a.mdl'
	},

	Weapons = { --Change these to weapons that you want
		'swb_deagle',
		'swb_famas',
		'swb_fiveseven',
		'swb_glock18',
		'swb_mp5',
		'swb_ump',
		'swb_knife',
		'swb_usp'
	}
}

------------------------------------------------------------------------------------
-- THINGS YOU CAN EDIT
------------------------------------------------------------------------------------
function ENT:Initialize()
	self:SetModel('models/props_junk/TrashDumpster01a.mdl')
	self:SetSolid(SOLID_BBOX)
	self:SetUseType(SIMPLE_USE)
	self:SetCollisionGroup( COLLISION_GROUP_PLAYER )
end

function ENT:OnTakeDamage(dmginfo) return end

function ENT:EmitItems(searcher)
	self:EmitSound('physics/metal/metal_solid_strain5.wav', 300, 100)
	local pos = self:GetPos() + ((self:GetAngles():Up() * 30) + (self:GetAngles():Forward() * 40))

	for i = 1, math.random(1,4) do
		if math.random(1, 100) <= 3 then
			local ent = ents.Create(table.Random(Dumpster_Items['Weapons']))
			ent:SetPos(pos)
			ent:Spawn()
		elseif math.random(1, 100) <= 100 then
			local prop = ents.Create('prop_physics')
			prop:SetModel(table.Random(Dumpster_Items['Props']))
			prop:SetCollisionGroup(COLLISION_GROUP_INTERACTIVE_DEBRIS)
			prop:SetPos(pos)
			prop:Spawn()

			timer.Simple(10, function()
				if prop:IsValid() then
					prop:Remove()
				end
			end)
		end
	end
end

function ENT:Use(activator)
	if not rp.teams[activator:Team()].hobo then
			rp.Notify(activator, NOTIFY_ERROR, 'Вы не можете обыскать мусорный контейнер!')
		return
	end

	if (self:GetNextUse() > CurTime()) then
		rp.Notify(activator, NOTIFY_ERROR, 'Мусорный контейнер пуст')
		return
	end

	self:SetNextUse(CurTime() + 180)
	self:EmitItems(activator)
end

hook.Add('InitPostEntity', 'SpawnDumpsters', function()
	for k, v in pairs(ents.FindByClass('prop_dynamic')) do
		if v:GetModel() == 'models/props_junk/trashdumpster01a.mdl' then
			v:Remove()
		end
	end
	for k,v in pairs(rp.cfg.Dumpsters[game.GetMap()] or {}) do
		local dump = ents.Create('ent_dumpster')
		dump:SetPos(v[1])
		dump:SetAngles(v[2])
		dump:Spawn()
	end
end)