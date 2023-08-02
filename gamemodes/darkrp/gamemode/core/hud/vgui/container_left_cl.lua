local PANEL = {}

function PANEL:Init()
	-- Arrest Warrants

	-- Hitlist
	function DrawHitList()
	    if LocalPlayer():IsHitman() then
	        local w = (ScrW() * .175)
	        local x = 15
	        local hits = table.Filter(player.GetAll(), function(pl) return pl:HasHit() and (pl ~= LocalPlayer()) end)
	
	        if (#hits >= 1) then
	            draw.Box(10, 40, w, 27, Color(24, 24, 24, 255))
	            local c = 1
	
	            for k, v in ipairs(hits) do
	                if (k == 6) and (not vgui.CursorVisible()) then
	                    draw.Box(10, 16 + (c * 25), w, 25, Color(20, 20, 20, 245))
	                    draw.SimpleText('И еще ' ..  #hits - 5 .. ' (F3)', 'ui.22', x, 27 + (c * 25), color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
	                    break
	                end
	                if IsValid(v) then
	                    draw.OutlinedBox(10, 42 + (c * 25), w, 25, v:GetJobColor(), Color(55, 55, 55))
	                    draw.SimpleText(v:Name(), 'ui.22', x, 53 + (c * 25), color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
	                    local cost = rp.FormatMoney(v:GetHitPrice())
	                    draw.SimpleText(cost, 'ui.22', (w - 5 - surface.GetTextSize(cost)), 53 + (c * 25), color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
	                    c = c + 1
	                end
	            end
	        else
	            draw.Box(10, 45, w, 27, Color(24, 24, 24, 255))
	            draw.Box(10, 27 + 44, w, (#hits * 18) + 23, Color(35, 35, 35, 245))
	            draw.SimpleText('Заказы не найдены.', 'ui.22', x, 79, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
	        end
	
	        draw.SimpleText('Заказы ', 'ui.22', x, 57, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
	        if LastHitDistance then
	            surface.DrawText( '   (' .. 'До ближайшего ' .. math.floor( LastHitDistance/2 ) .. ' м)' )
	        end
	    end
	end
end


function PANEL:PerformLayout(w, h)
	local y = 0
	for k, v in ipairs(self:GetChildren()) do
		if v:IsVisible() then
			v:SetPos(0, y)
			y = y + v:GetTall() + 5
		end
	end
end

vgui.Register('rp_hud_container_left', PANEL, 'Panel')