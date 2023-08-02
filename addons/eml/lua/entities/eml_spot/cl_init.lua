include("shared.lua");



function ENT:Initialize()	

end;

function ENT:Draw()
	self:DrawModel();
	
	local pos = self:GetPos()
	local ang = self:GetAngles()
	local redpColor = Color(175, 0, 0, 255);
	local ciodineColor = Color(220, 134, 159, 255);
	
	local potTime = "Time: "..self:GetNWInt("time").."s";
	
	if (self:GetNWInt("status") == "inprogress") then
		potTime = "Время: "..self:GetNWInt("time").."сек";
	elseif (self:GetNWInt("status") == "ready") then	
		potTime = "Мет Готов!";
	end;
	ang:RotateAroundAxis(ang:Up(), 90);
	ang:RotateAroundAxis(ang:Forward(), 90);	
	if LocalPlayer():GetPos():Distance(self:GetPos()) < self:GetNWInt("distance") then
		cam.Start3D2D(pos + ang:Up()*8, ang, 0.10)
			surface.SetDrawColor(Color(0, 0, 0, 200));
			surface.DrawRect(-64, -38, 128, 96);		
		cam.End3D2D();
		cam.Start3D2D(pos + ang:Up()*8, ang, 0.055)
			draw.ShadowText("Кристаллический Мет", "Roboto_31", 0, -56, Color(1, 241, 249, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color(25, 25, 25, 100));
			draw.ShadowText("______________", "Roboto_31", 0, -54, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color(25, 25, 25, 100));

			surface.SetDrawColor(Color(0, 0, 0, 200));
			surface.DrawRect(-104, -32, 204, 24);			
			surface.SetDrawColor(Color(1, 201, 209, 255));
			surface.DrawRect(-101.5, -30, math.Round((self:GetNWInt("time")*198)/self:GetNWInt("maxTime")), 20);		
			
			draw.ShadowText("Ингредиенты", "Roboto_31", -101, 8, Color(1, 241, 249, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER, 1, Color(25, 25, 25, 100));
			draw.ShadowText("______________", "Roboto_31", 0, 10, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color(25, 25, 25, 100));

			if (self:GetNWInt("redp")==0) then
				redpColor = Color(100, 100, 100, 255);
			else
				redpColor = Color(175, 0, 0, 255);
			end;
			
			if (self:GetNWInt("ciodine")==0) then
				ciodineColor = Color(100, 100, 100, 255);
			else
				ciodineColor = Color(220, 134, 159, 255);
			end;							
		cam.End3D2D();	
		cam.Start3D2D(pos + ang:Up()*8, ang, 0.040)		
			draw.ShadowText("Красный Фосфор ("..self:GetNWInt("redp")..")", "Roboto_31", -138, 50, redpColor, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER, 1, Color(25, 25, 25, 100));
			draw.ShadowText("Кристаллический Йод ("..self:GetNWInt("ciodine")..")", "Roboto_31", -138, 80, ciodineColor, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER, 1, Color(25, 25, 25, 100));		
		cam.End3D2D();			
		cam.Start3D2D(pos + ang:Up()*8, ang, 0.035)		
			draw.ShadowText(potTime, "Roboto_31", -152, -32, Color(255, 255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER, 1, Color(25, 25, 25, 100));		
		cam.End3D2D();		
		
	end;
end;

