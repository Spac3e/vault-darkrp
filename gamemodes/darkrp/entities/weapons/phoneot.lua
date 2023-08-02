if SERVER then
    AddCSLuaFile()
end

if CLIENT then
    SWEP.PrintName = "Телефон отладки"
    SWEP.Slot = 2
    SWEP.SlotPos = 5
    SWEP.DrawAmmo = false
    SWEP.DrawCrosshair = false
end

SWEP.Author = ""
SWEP.Instructions = "ЛКМ чтобы откыть меню"
SWEP.Contact = ""
SWEP.Purpose = ""
SWEP.ViewModel = "models/jessev92/weapons/buddyfinder_c.mdl"
SWEP.WorldModel = "models/jessev92/weapons/buddyfinder_w.mdl"
SWEP.ViewModelFOV = 72
SWEP.ViewModelFlip = false
SWEP.AnimPrefix = "rpg"
SWEP.Spawnable = true
SWEP.AdminSpawnable = true
SWEP.Category = "Телефон"
SWEP.Primary.ClipSize = -1
SWEP.Primary.DefaultClip = 0
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = ""
SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = 0
SWEP.Secondary.Automatic = false
SWEP.Secondary.Ammo = ""
SWEP.UseHands = true

function SWEP:Initialize()
    self:SetWeaponHoldType("slam")
end

function SWEP:Deploy()
    if SERVER then
        self.Owner:DrawWorldModel(true)
    end
end

function SWEP:Menu()

	if IsValid(frphone) then return end
	
	frphone = ui.Create('ui_frame', function(self)
		self:SetTitle('Телефон отладки')
		self:SetSize(300, 325)
		self:Center()
		self:MakePopup()
	end)

    for k,v in ipairs(player.GetAll()) do
	ui.Create('ui_playerrequest', function(self, p) 
		local p = self:GetParent()
		local x, y = p:GetDockPos()
		self:SetPos(x, y)
		self:SetSize(p:GetWide() - 10, p:GetTall() - (y + 5))
		self:SetPlayers(player.GetAll())
		self.OnSelection = function(self, row, pl)
            local m = DermaMenu()
            m:AddOption( "Кикнуть", function() LocalPlayer():ConCommand("ba", "kick "..v:SteamID(), "Телефон отладки (Kick)") end ):SetIcon('icon16/delete.png')
            m:Open()
		end
	end, frphone)
	end
end

function SWEP:Menus()

if IsValid(frphone) then return end

	if IsValid(frphone) then return end
	
	frphone = ui.Create('ui_frame', function(self)
		self:SetTitle('Yandex такси')
		self:SetSize(300, 325)
		self:Center()
		self:MakePopup()
	end)

	frmm = ui.Create('ui_button', function(self, p) 
		self:SetPos(x, y)
		self:Dock(TOP)
		self:DockMargin(0, 5, 0, 0)
		self:SetText("Переехать в другой город")
		self.DoClick = function()
		ui.BoolRequest("Yandex такси", "Вы желаете переехать в другой город?", function(yesandno)
		if yesandno then
        rp.Notify(NOTIFY_WAIT, "Переходим на другой сервер...")
        timer.Create("Connect", 3, 1, function()
		--RunConsoleCommand('connect', '')
		end)

		--RunConsoleCommand('connect', '')

		--chat.AddText(Color(255,0,0), "| ", Color(255,255,255), "Пока нет другого сервера")

		--rp.Notify(NOTIFY_ERROR, "Пока нет другого сервера!")

		else
		print('')
		end
		end)
		end
	end, frphone)
end

function SWEP:PrimaryAttack()
    if CLIENT then
        self:Menu()
    end
end

function SWEP:SecondaryAttack()
    if CLIENT then
        self:Menus()
    end
end