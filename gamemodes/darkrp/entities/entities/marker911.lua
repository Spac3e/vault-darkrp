ENT.Base 			= 'base_ai'
ENT.Type 			= 'ai'
ENT.PrintName		= 'Marker 911'
ENT.Author 			= ''
ENT.Contact	 		= ''
ENT.Category 		= 'Other'
ENT.Spawnable 		= false
ENT.AdminSpawnable 	= false

if SERVER then
    AddCSLuaFile()

    function ENT:Initialize()
        self:SetModel("models/hunter/plates/plate.mdl")
        self:SetCollisionGroup(COLLISION_GROUP_DEBRIS)
        timer.Simple(60, function()
            if IsValid(self) then
                self:Remove()
            end
        end)
    end
else
    function ENT:Draw()
        self:DrawShadow(false)
        -- disable draw entity
    end
end