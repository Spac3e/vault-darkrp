--[[
gamemodes/darkrp/gamemode/core/achievements/init_cl.lua
--]]
--[[
gamemodes/rp_base/gamemode/core/achievements/init_cl.lua
--]]
local PANEL = {}



function PANEL:SetAchievement(achievement)

	self.Achievement = achievement

end



local color_bar = ui.col.SUP:Copy()

color_bar.a = 25

function PANEL:Paint(w, h)

	if (not self.Achievement) then return end



	draw.RoundedBox(5, 0, 0, w, h, ui.col.Background)



	local hasAchievement = LocalPlayer():HasAchievement(self.Achievement.UID)

	local progress = self.Achievement.GetProgress and self.Achievement.GetProgress(self.Achievement, LocalPlayer()) or LocalPlayer():GetAchievementProgress(self.Achievement.UID)



	draw.RoundedBoxEx(5, 0, 0, h, h, hasAchievement and ui.col.FlatBlack or ui.col.Button, true, hasAchievement, true, hasAchievement)



	if (not hasAchievement) and progress then

		local w = (w - 74) * progress/self.Achievement.Total

		draw.RoundedBoxEx(5, 74, 0, w, h, color_bar, false, true, false, true)

	end



	if self.Achievement.Material then

		surface.SetDrawColor(255, 255, 255, 255)

		surface.SetMaterial(self.Achievement.Material)

		surface.DrawTexturedRect(5, 5, 64, 64)

	end



	local textX = (w * 0.5) + 32



	draw.SimpleText(self.Achievement.Name, 'ui.20', textX, 5, ui.col.White, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)



	draw.SimpleText(self.Achievement.Description .. (self.Achievement.Reward and (' - Награда ' .. self.Achievement.Reward) or ''), 'ui.18', textX, h * 0.5, ui.col.White, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)



	if hasAchievement then

		draw.SimpleText('Получено!', 'ui.18', textX, h - 5, ui.col.White, TEXT_ALIGN_CENTER, TEXT_ALIGN_BOTTOM)

	elseif progress then

		draw.SimpleText(self.Achievement.FormatProgress and self.Achievement.FormatProgress(self.Achievement, progress, self.Achievement.Total) or (string.Comma(math.floor(progress)) .. '/' .. string.Comma(self.Achievement.Total)), 'ui.18',textX, h - 5, ui.col.White, TEXT_ALIGN_CENTER, TEXT_ALIGN_BOTTOM)

	else

		draw.SimpleText(self.Achievement.FormatProgress and self.Achievement.FormatProgress(self.Achievement, 0, self.Achievement.Total) or ('0/' .. string.Comma(self.Achievement.Total)), 'ui.18', textX, h - 5, ui.col.White, TEXT_ALIGN_CENTER, TEXT_ALIGN_BOTTOM)

	end

end



vgui.Register('rp_achievement_button', PANEL, 'Panel')



PANEL = {}

function PANEL:Init()

	self.List = ui.Create('ui_listview', self)

	self.List.Paint = function() end

	self.List:SetSpacing(5)



	local achievements = table.FilterCopy(rp.achievements.SortedList, function(v)

		return (not LocalPlayer():HasAchievement(v.UID))

	end)



	for k, v in ipairs(rp.achievements.SortedList) do

		if LocalPlayer():HasAchievement(v.UID) then

			achievements[#achievements + 1] = v

		end

	end



	local cont

	local i = 0

	for k, v in ipairs(achievements) do

		if (i == 0) then

			cont = ui.Create('DPanel', function(s)

				s.Paint = function() end

			end)



			self.List:AddCustomRow(cont)

		end



		ui.Create('rp_achievement_button', function(s)

			s:SetAchievement(v)

			s:Dock(LEFT)

			s:DockMargin((i == 1) and 2.5 or 0, 0, (i == 0) and 2.5 or 0, 0)

		end, cont)



		i = (i == 1) and 0 or (i + 1)

	end



end



function PANEL:PerformLayout(w, h)

	self.List:SetPos(5, 5)

	self.List:SetSize(w - 10, h - 10)



	for k, v in ipairs(self.List.Rows) do

		v:SetSize(self.List:GetWide(), 74)



		for i, child in ipairs(v:GetChildren()) do

			child:SetSize(v:GetWide() * 0.5 - 5, v:GetTall())

			child:SetPos((i - 1) * (child:GetWide() + 5), 0)

		end

	end

end

vgui.Register('rp_achievements', PANEL, 'Panel')



net('rp.achievement.Finish', function()

	local uid = net.ReadUInt(32)

	local tbl = rp.achievements.List[uid]

	local function inQuad(fraction, beginning, change)
		return change * (fraction ^ 2) + beginning
	end

	local start = SysTime()

	if tbl.Sound then
		sound.PlayURL ( tbl.Sound, "mono ", function( station )
			if ( IsValid( station ) ) then
				station:Play()
				station:SetVolume(0.5)
			end
		end )
	end

	local main = vgui.Create("DFrame")
	main:SetTitle("")
	main:ShowCloseButton(false)
	main:SetSize(500, 75)
	main:SetPos(ScrW()/2-(500/2),-75)
	local ina = Derma_Anim("EaseInQuad", main, function(pnl, anim, delta, data)
		pnl:SetPos(ScrW()/2-(500/2), inQuad(delta, -75, 90))
	end)
	local out = Derma_Anim("EaseInQuad", main, function(pnl, anim, delta, data)
		pnl:SetPos(ScrW()/2-(500/2), inQuad(delta, 16, -90))
		if (anim.Finished) then
			pnl:Remove()
		end
	end)
	ina:Start(1)
	timer.Simple(3,function()
		out:Start(1)
	end)
	main.Think = function(self)
		if ina:Active() then
			ina:Run()
		end
		if out:Active() then
			out:Run()
		end
	end
	main.Paint = function(self,w,h)
		draw.RoundedBox(5, 0, 0, w, h, ui.col.Background)

		draw.RoundedBoxEx(5, 0, 0, h, h, ui.col.FlatBlack, true, false, true, false)

		if tbl.Material then

			surface.SetDrawColor(255, 255, 255, 255)

			surface.SetMaterial(tbl.Material)

			surface.DrawTexturedRect(5, 5, 64, 64)

		end

		local wa = (w - 74) * Lerp( (SysTime() - start)/30, 0, 20 )

		draw.RoundedBoxEx(5, 74, 0, wa, h, color_bar, false, true, false, true)

		local textX = (w * 0.5) + 32

		draw.SimpleText(tbl.Name, 'ui.20', textX, 5, ui.col.White, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)

		draw.SimpleText(tbl.Description, 'ui.18', textX, h * 0.5, ui.col.White, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)

		draw.SimpleText('Получено!', 'ui.18', textX, h - 5, ui.col.White, TEXT_ALIGN_CENTER, TEXT_ALIGN_BOTTOM)
	end
end)



