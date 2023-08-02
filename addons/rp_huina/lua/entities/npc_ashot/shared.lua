ENT.Base = "base_ai"
ENT.Type = "ai"
ENT.AutomaticFrameAdvance = true
ENT.PrintName = rp_box.NPC_name
ENT.Author = "Mertvi"
ENT.Category = "Podrabotka"
ENT.Spawnable = true
ENT.AdminSpawnable = true
 
function ENT:SetAutomaticFrameAdvance( bUsingAnim )
	self.AutomaticFrameAdvance = bUsingAnim
end