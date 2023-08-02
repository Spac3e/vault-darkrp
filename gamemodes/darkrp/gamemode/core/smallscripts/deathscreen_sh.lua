local function respawntime(pl)
	local prem
	if pl then
		prem = pl:IsVIP()
	else
		prem = LocalPlayer():IsVIP()
	end
	return prem and 25 / 2 or 30
end

if SERVER then
	util.AddNetworkString('RespawnTimer')
	hook.Add('PlayerDeath', 'RespawnTimer', function(ply)
		ply.deadtime = RealTime()

		net.Start('RespawnTimer')
			net.WriteBool(true)
		net.Send(ply)

		if ply:IsRoot() then
			timer.Simple(0, function()
				if ply:IsValid() then
					ply.NextSpawnTime = CurTime()
				end
			end)
		end
	end)
	hook.Add('PlayerDeathThink', 'RespawnTimer', function(ply)
		if ply.deadtime and not ply:IsRoot() and RealTime() - ply.deadtime < respawntime(ply) then
			return false
		end
	end)
	hook.Add('PlayerSpawn', 'HideRespawnTimer', function(ply)
		net.Start('RespawnTimer')
			net.WriteBool(false)
		net.Send(ply)
	end)
end

if CLIENT then
	cvar.Register 'deathscreen_sound'
		:SetDefault(true, true)
		:AddMetadata('Menu', 'Звуковое сопровождение при смерти')

	local aprg, aprg2 = 0, 0
    local songrs = {'music/ravenholm_1.mp3', 'music/hl2_song28.mp3', 'music/hl2_song32.mp3', 'music/hl2_song23_suitsong3.mp3'}

	local music
	net.Receive('RespawnTimer', function()
		if net.ReadBool() then
			local dead = RealTime()
            hook.Add('HUDPaint', 'RespawnTimer', function()
                surface.SetDrawColor(0, 0, 0, math.ceil((aprg ^ .5) * 255))
                surface.DrawRect(-1, -1, ScrW() + 2, ScrH() + 2)
                local time = math.Round(respawntime() - RealTime() + dead)
				if time > 0 then
                	draw.SimpleText('До возрождения осталось ' .. time .. ' секунд', 'DermaLarge', ScrW() / 2, ScrH() / 2, ColorAlpha(color_white, aprg2 * 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, aprg2 * 255)
            	end
            end)

            hook.Add('RenderScreenspaceEffects', 'RespawnTimer', function()
                if LocalPlayer():Alive() and (not dead or RealTime() - dead > 1) then
                    if (aprg ~= 0) then
                        aprg2 = math.Clamp(aprg2 - FrameTime() * 1.3, 0, 1)

                        if (aprg2 == 0) then
                            aprg = math.Clamp(aprg - FrameTime() * .7, 0, 1)
                        end
                    end
                else
                    if (aprg2 ~= 1) then
                        aprg = math.Clamp(aprg + FrameTime() * .5, 0, 1)

                        if (aprg == 1) then
                            aprg2 = math.Clamp(aprg2 + FrameTime() * .4, 0, 1)
                        end
                    end
                end
            end)

			hook.Add('Think', 'RespawnTimerMusic', function()
				if (RealTime() - dead) < 1 then return end
				
				hook.Remove('Think', 'RespawnTimerMusic')

				if music then
					music:Stop()
					music = nil
				end

				if cvar.GetValue('deathscreen_sound') then
					sound.PlayFile('sound/'..table.Random(songrs), '', function(chan, err, msg)
						if err then return print(err,msg) end

						music = chan
					end)
				end
			end)
			system.FlashWindow()
		else
			if music then
				music:Stop()
				music = nil
			end
			hook.Remove('HUDPaint', 'RespawnTimer')
			hook.Remove('Think', 'RespawnTimerMusic')
		end
	end)
end
