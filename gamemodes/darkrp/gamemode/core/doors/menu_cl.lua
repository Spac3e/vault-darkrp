local adminMenu
local fr
local ent
local doorOptions = {
	{
		Name 	= 'Продать',
		DoClick = function()
			cmd.Run('selldoor')
			fr:Close()
		end,
	},
	{
		Name 	= 'Добавить совладельца',
		Check 	= function()
			return (player.GetCount() > 1)
		end,
		DoClick = function()
			ui.PlayerRequest(function(pl)
				RunConsoleCommand("addcoowner",pl:SteamID())
			end)
		end,
	},
	{
		Name 	= 'Удалить совладельца',
		Check 	= function()
			return (ent:DoorGetCoOwners() ~= nil) and (#ent:DoorGetCoOwners() > 0)
		end,
		DoClick = function()
			ui.PlayerRequest(ent:DoorGetCoOwners(), function(pl)
				RunConsoleCommand('removecoowner', pl:SteamID())
			end)
		end,
	},
	{
		Name 	= 'Дать доступ к организации',
		Check 	= function()
			return (#player.GetAll() > 1) and (LocalPlayer():GetOrg() ~= nil)
		end,
		DoClick = function()
			cmd.Run('orgown')
		end,
	},
}

local hotelOwnerOptions = {
	{
		Name 	= 'Поселить',
		Check 	= function()
			return LocalPlayer():Team() == TEAM_HOTEL
		end,
		DoClick = function()
			local ent = fr.ent

			ui.PlayerRequest(table.Filter(player.GetAll(), function(v)
				return (v:GetPos():DistToSqr(ent:GetPos()) <= 40000) and (not v:GetTeamTable().CannotOwnDoors) and ( not ent:DoorCoOwnedBy(v) )
			end), function(pl)
				RunConsoleCommand("addtennant",pl:SteamID())
			end)
		end,
	},
	{
		Name 	= 'Выселить',
		Check 	= function()
			return LocalPlayer():Team() == TEAM_HOTEL
		end,
		DoClick = function()
			ui.PlayerRequest(table.Filter(player.GetAll(), function(v)
				return (true) and (not v:GetTeamTable().CannotOwnDoors) and ( ent:DoorCoOwnedBy(v) )
			end), function(pl)
				RunConsoleCommand("idi_nax",pl:SteamID())
			end)
		end,
	}
}

local hotelUserOptions = {
	{
		Name = "Съехать",
		Check = function() return ent:DoorCoOwnedBy( LocalPlayer() ) end,
		DoClick = function() RunConsoleCommand("sell_hotel") end
	}
}

local function makeFrame(ent, opts)
	fr = ui.Create('ui_frame', function(self)
		self:SetTitle('Опции')
		self:Center()
		self:MakePopup()
		self.Think = function(self)
			ent = LocalPlayer():GetEyeTrace().Entity
			if not IsValid(ent) or (ent:GetPos():DistToSqr(LocalPlayer():GetPos()) > 13225) then
				fr:Close()
			end
		end
	end)

	fr.ent = ent

	local count = -1
		local x, y = fr:GetDockPos()
		for k, v in ipairs(opts) do
			if (v.Check == nil) or (v.Check(ent) == true) then
				count = count + 1
				fr:SetSize(ScrW() * .125, (count + 2) * 35)
				fr:Center()
				ui.Create('ui_button', function(self)
					self:SetPos(x, count * 35 + y)
					self:SetSize(ScrW() * .125 - 10, 30)
					self:SetText(v.Name)
					self.DoClick = function()
						v.DoClick(v)
						fr:Close()
					end
				end, fr)
			end
		end

	return fr
end

local function keysMenu()
	if IsValid(fr) then fr:Close() end

	ent = LocalPlayer():GetEyeTrace().Entity

	if IsValid(ent) and ent:IsDoor() and (ent:GetPos():DistToSqr(LocalPlayer():GetPos()) < 13225) then
		if (ent:GetNWEntity("ownor") == LocalPlayer()) then
			makeFrame(ent, doorOptions)
		elseif ent:IsPropertyOwnable() then
			cmd.Run('buydoor')
		elseif ent:DoorCoOwnedBy( LocalPlayer() ) then  
			makeFrame(ent,hotelUserOptions)
		elseif ent:IsPropertyHotelOwned() and LocalPlayer():GetTeamTable().HotelManager then
			makeFrame(ent, hotelOwnerOptions)
		end
	end
end

net('rp.keysMenu', keysMenu)
GM.ShowTeam = keysMenu