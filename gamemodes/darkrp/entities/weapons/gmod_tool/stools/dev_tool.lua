TOOL.Category = "Staff"
TOOL.Name = "Positions"
TOOL.Command = nil
TOOL.ConfigName = ""

if(CLIENT) then
	language.Add("tool.dev_tool.name","Positions")
end

function TOOL:LeftClick( trace )

	self:GetOwner():ChatPrint("Vector("..trace.HitPos.x..", "..trace.HitPos.y..", "..trace.HitPos.z..")")
	return true
end
 
function TOOL:RightClick( trace )

	self:GetOwner():ChatPrint("Vector("..self:GetOwner():GetPos().x..", "..self:GetOwner():GetPos().y..", "..self:GetOwner():GetPos().z..")")
	return false
end