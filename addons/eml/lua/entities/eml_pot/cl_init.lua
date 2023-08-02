include("shared.lua");



function ENT:Initialize()	

end;

function ENT:Draw()
	self:DrawModel();
	
	local pos = self:GetPos()
	local ang = self:GetAngles()
	local macidColor = Color(160, 221, 99, 255);
	local sulfurColor = Color(243, 213, 19, 255);
	
	local potTime = "Time: "..self:GetNWInt("time").."s";
	
	if (self:GetNWInt("status") == "inprogress") then
		potTime = "Время: "..self:GetNWInt("time").."сек";
	elseif (self:GetNWInt("status") == "ready") then	
		potTime = "Фосфор Готов!";
	end;
	ang:RotateAroundAxis(ang:Up(), 90);
	ang:RotateAroundAxis(ang:Forward(), 90);	
	if LocalPlayer():GetPos():Distance(self:GetPos()) < self:GetNWInt("distance") then
		cam.Start3D2D(pos + ang:Up()*8, ang, 0.10)
			surface.SetDrawColor(Color(0, 0, 0, 200));
			surface.DrawRect(-64, -38, 128, 96);		
		cam.End3D2D();
		cam.Start3D2D(pos + ang:Up()*8, ang, 0.055)
			draw.ShadowText("Красный Фосфор", "Roboto_31", 0, -56, Color(175, 0, 0, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color(25, 25, 25, 100));
			draw.ShadowText("______________", "Roboto_31", 0, -54, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color(25, 25, 25, 100));

			surface.SetDrawColor(Color(0, 0, 0, 200));
			surface.DrawRect(-104, -32, 204, 24);			
			surface.SetDrawColor(Color(175, 0, 0, 200));
			surface.DrawRect(-101.5, -30, math.Round((self:GetNWInt("time")*198)/self:GetNWInt("maxTime")), 20);		
			
			draw.ShadowText("Ингредиенты", "Roboto_31", -101, 8, Color(175, 0, 0, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER, 1, Color(25, 25, 25, 100));
			draw.ShadowText("______________", "Roboto_31", 0, 10, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color(25, 25, 25, 100));

			if (self:GetNWInt("macid")==0) then
				macidColor = Color(100, 100, 100, 255);
			else
				macidColor = Color(160, 221, 99, 255);
			end;
			
			if (self:GetNWInt("sulfur")==0) then
				sulfurColor = Color(100, 100, 100, 255);
			else
				sulfurColor = Color(243, 213, 19, 255);
			end;			
			draw.ShadowText("Соляная Кислота ("..self:GetNWInt("macid")..")", "Roboto_31", -101, 38, macidColor, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER, 1, Color(25, 25, 25, 100));
			draw.ShadowText("Жидкая Сера ("..self:GetNWInt("sulfur")..")", "Roboto_31", -101, 68, sulfurColor, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER, 1, Color(25, 25, 25, 100));				
		cam.End3D2D();	
		cam.Start3D2D(pos + ang:Up()*8, ang, 0.035)		
			draw.ShadowText(potTime, "Roboto_31", -152, -32, Color(255, 255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER, 1, Color(25, 25, 25, 100));		
		cam.End3D2D();					
	end;
end;

