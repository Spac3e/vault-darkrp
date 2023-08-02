rp.skins = rp.skins or {
	List = {}
}

AllSkins = AllSkins or {}


function rp.skins.Draw(ent, skinPath)
	for k, v in ipairs(ent:GetMaterials()) do

		local matSplit = v:Split('/')
		local matName = matSplit[#matSplit]

		if (not rp.cfg.SkinMaterialBlacklist[matName]) then
			ent:SetSubMaterial(k - 1, skinPath)
		else
			ent:SetSubMaterial(k - 1)
		end
	end
end

function GetSkinById(uid)
	return rp.skins.List[uid].Texture
end

-- hook('PreDrawViewModel', 'rp.wepskins.PreDrawViewModel', function(vm, pl, wep)
-- 	if IsValid(vm) and IsValid(wep) and (wep == pl:GetActiveWeapon()) and (string.sub(wep:GetClass(), 0, 3) ~= 'swb' or string.sub(wep:GetClass(), 0, 3) ~= 'weapon_base') then
-- 		local mat = LocalPlayer():GetMaterials()[1]
--         wep.CosmeticsViewModelIndex = vm:ViewModelIndex()
-- 		for k, v in pairs(vm:GetMaterials()) do
-- 			if mat and (not string.find(v, 'hands')) then
-- 				vm:SetSubMaterial(k - 1, mat)
-- 			else
-- 				vm:SetSubMaterial(k - 1)
-- 			end
-- 		end
-- 	end
-- end)

-- hook('PreDrawViewModel', 'rp.wepskins.PreDrawViewModel', function(vm, pl, wep)
-- 	if IsValid(vm) and IsValid(wep) and (wep == pl:GetActiveWeapon()) then
-- 		if !LocalPlayer():GetActiveWeaponSkin() then return end  
-- 		local uid = pl:GetActiveWeaponSkin()[pl:GetActiveWeapon():GetClass()]
-- 		for k, v in pairs(vm:GetMaterials()) do 
-- 			if !uid then vm:SetSubMaterial(k-1,  nil ) continue end
-- 			if v:find("hands") then 
-- 				vm:SetSubMaterial(k-1,  nil )
-- 				continue
-- 			end
-- 			vm:SetSubMaterial(k-1, rp.skins.List[uid].Texture or nil )
-- 		end
-- 	end
-- end)

hook('PreDrawViewModel', 'rp.wepskins.PreDrawViewModel', function(vm)
    for i=1, #player.GetAll() do 
        local pl = player.GetAll()[i]
        local wep = pl:GetActiveWeapon()
        if !IsValid(pl) or !pl:Alive() or !pl:GetActiveWeaponSkin() or !IsValid(pl:GetActiveWeapon()) then continue end
        local b = pl:GetActiveWeaponSkin()[pl:GetActiveWeapon():GetClass()]
        
        for k = 1, #wep:GetMaterials() do 
            local v = wep:GetMaterials()[k]
            if !b then 
                if pl:SteamID() == LocalPlayer():SteamID() then 
                    vm:SetSubMaterial(k-1,nil)
                    continue 
                else
                    wep:SetSubMaterial(k-1,nil)
                    continue
                end
            end
            if v:find('hands') then 
                if pl:SteamID() == LocalPlayer():SteamID() then 
                    vm:SetSubMaterial(k-1,nil)
                    continue 
                else
                    wep:SetSubMaterial(k-1,nil)
                    continue 
                end
            end
            if pl:SteamID() == LocalPlayer():SteamID() then 
                vm:SetSubMaterial(k-1,rp.skins.List[b].Texture)
            else
                wep:SetSubMaterial(k-1,rp.skins.List[b].Texture)
            end
        end
       
    end
end)

local function resetViewModel(wep)
	if (not IsValid(LocalPlayer())) then return end

	local vm = LocalPlayer():GetViewModel(wep.SkinViewModelIndex)

	if (not IsValid(vm)) then return end

	rp.skins.Reset(vm)

	wep.SkinViewModelIndex = nil
end

hook('PlayerSwitchWeapon', 'rp.wepskins.PlayerSwitchWeapon', function(pl, oldWep, newWep)
	if IsValid(oldWep) and oldWep.SkinViewModelIndex then
		resetViewModel(oldWep)
	end
end)

local whiteList = {}

local function drawSkin(ent, skinPath)
	for k, v in ipairs(ent:GetMaterials()) do
		if whiteList[v] then
			ent:SetSubMaterial(k - 1, skinPath)
		else
			ent:SetSubMaterial(k - 1)
		end
	end
end

local testMat = 'z_easyskins/camo/greenscreen.vmt'
local function wepSkinEditor()
	local weps = table.Copy(weapons.GetList())

	table.Filter(weps, function(v)
		return v.Base == 'swb_base' or v.Base == 'bobs_gun_base'
	end)

	local fr = ui.Create('ui_frame', function(self)
		self:SetTitle('Skin edit')
		self:SetSize(ScrW() * 0.5, ScrH() * 0.5)
		self:Center()
		self:MakePopup()
	end)

	local model
	local pnl
	local function makeMatEditor(mats)
		if IsValid(pnl) then
			pnl:Remove()
		end

		pnl = ui.Create('ui_panel', function(self)
			self:SetPos(model.x + model:GetWide(), model.y)
			self:SetSize(fr:GetWide() - self.x - 5, model:GetTall())
		end, fr)

		for k, v in pairs(mats) do
			local chk = ui.Create('ui_checkbox', function(self, p)
				self:SetText(v)
				self:SizeToContents()
				self:Dock(TOP)
				self:DockMargin(5, 5, 5, 5)
				self:SetChecked(whiteList[v] )
				self.OnChange = function(self, bool)
					whiteList[v] = bool and true or nil
				end
			end, pnl)
		end

	end

	model = ui.Create('DModelPanel', function(self)
		local x, y = fr:GetDockPos()
		self:SetPos(x, y)
		local s = fr:GetTall() - y - 5
		self:SetSize(s, s)
		self:SetFOV(100)
		self:SetCamPos(Vector(0, 25, 10))
		self:SetLookAt(Vector(5, -5, 0))
		self.PreDrawModel = function(s, ent)
			drawSkin(ent, testMat)
		end
	end, fr)

	local pickwep = ui.Create('ui_button', function(self)
		self:SetText('Pick Gun')
		self:SizeToContentsX()
		self:SetSize(self:GetWide() + 10, fr.btnClose:GetTall())
		self:SetPos(fr.btnClose.x - self:GetWide(), 0)
		self.DoClick = function()
			local m = ui.DermaMenu()
			for k, v in pairs(weps) do
				m:AddOption(v.ClassName, function()
					model:SetModel(v.WorldModel)

					makeMatEditor(model:GetEntity():GetMaterials())
				end)
			end
			m:Open()
		end
	end, fr)
end

concommand.Add('wep_skin_editor', wepSkinEditor)