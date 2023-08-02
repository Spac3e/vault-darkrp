AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
include( "shared.lua" )

util.AddNetworkString( "TCF_CloseSellMenu" )
util.AddNetworkString( "TCF_SellDrugsMenu" )
util.AddNetworkString( "TCF_SellCocaine" )

function ENT:Initialize()
	self:SetModel( "models/Humans/Group03/Male_01.mdl" )
	self:SetHullType( HULL_HUMAN )
	self:SetHullSizeNormal()
	self:SetNPCState( NPC_STATE_SCRIPT )
	self:SetSolid( SOLID_BBOX )
	self:CapabilitiesAdd( CAP_ANIMATEDFACE )
	self:CapabilitiesAdd( CAP_TURN_HEAD )
	self:DropToFloor()
	self:SetMaxYawSpeed( 90 )
	self:SetCollisionGroup( 1 )
	self.RandomCocainePayout = math.random( TCF.Config.PayPerPackMin, TCF.Config.PayPerPackMax )
	
	timer.Create( "COCAINE_NPCRandomPayout", TCF.Config.RandomPayoutInterval, 0, function() -- Update random payout every 5th minute.
		self.RandomCocainePayout = math.random( TCF.Config.PayPerPackMin, TCF.Config.PayPerPackMax )
	end )
end

function ENT:AcceptInput( string, caller )
	if caller:IsPlayer() and not caller.CantUse then
		caller.CantUse = true
		
		timer.Simple( 1.5, function()  
			caller.CantUse = false 
		end )

		if caller:IsValid() then
			if team.GetName( caller:Team() ) == 'Кокаинщик' then
				for k, v in pairs( ents.FindByClass( "cocaine_box" ) ) do
					local ourcocainebox = v
					
					for k, v in pairs( ents.FindInSphere( self:GetPos(), TCF.Config.SellDistance ) ) do
						if v:GetClass() == "cocaine_box" then
							ourcocainebox = v
						end
					end
					
					local boxowner = ourcocainebox:CPPIGetOwner()
					
					if caller:GetPos():Distance( ourcocainebox:GetPos() ) <= TCF.Config.SellDistance then
						if ourcocainebox.IsClosed then
							if ourcocainebox.BoxCocaineAmount > 0 then
								if boxowner == caller then
									local bonus = boxowner:GetDonatorBonus()
		
									local cocaine_amount = ourcocainebox.BoxCocaineAmount
									
									local payperpack = self.RandomCocainePayout
									local fullpayout = math.Round( ( cocaine_amount * payperpack ) * bonus )
									
									-- Network the information to the client and save it so it cannot be abused.
									caller.DonatorSellBonus = bonus
									caller.SellBoxCocaineAmount = cocaine_amount
									caller.FullPayout = fullpayout
									
									net.Start( "TCF_SellDrugsMenu" )
										net.WriteDouble( caller.DonatorSellBonus )
										net.WriteDouble( caller.SellBoxCocaineAmount )
										net.WriteDouble( caller.FullPayout )
									net.Send( caller )
									break
								end
							else
								rp.Notify(caller, 2, "Нигга в коробке нету порошка, ты меня кинуть хочешь?", "")
								break
							end
						else
							rp.Notify(caller, 2, "Закройте коробку перед тем как продать барыге.", "")
							break
						end
					else
						rp.Notify(caller, 2, "Пожалуйста поднесите коробку ближе к барыге.", "")
						break
					end
				end
			else
				rp.Notify(caller, 2, "Нигга ты что коп? пошёл от сюда!", "")
			end
		end
	end
end

net.Receive( "TCF_SellCocaine", function( length, ply )
	for k, v in pairs( ents.FindByClass( "cocaine_box" ) ) do
		local ourcocainebox = v
					
		for k, v in pairs( ents.FindInSphere( ply:GetPos(), TCF.Config.SellDistance ) ) do
			if v:GetClass() == "cocaine_box" then
				ourcocainebox = v
			end
		end
		
		local boxowner = ourcocainebox:CPPIGetOwner()
		
		if ply:GetPos():Distance( ourcocainebox:GetPos() ) <= TCF.Config.SellDistance then
			if ourcocainebox.IsClosed then
				if boxowner == ply then
					ply:AddMoney( ply.FullPayout )
					rp.Notify(ply, 3, "Вы продали кокс за "..rp.FormatMoney(ply.FullPayout), "")
					-- Reset all information on the user
					ply.DonatorSellBonus = 0
					ply.SellBoxCocaineAmount = 0
					ply.FullPayout = 0
					
					ourcocainebox:Remove()
					
					if TCF.Config.OnSellGiveXP then
						owner:addXP( TCF.Config.OnSellXPAmount, true )
					end
					break
				end
			else
				rp.Notify(ply, 2, "Закройте коробку перед тем как продать её барыге.", "")
				break
			end
		else
			rp.Notify(ply, 2, "Пожалуйста поднесите коробку ближе к барыге.", "")
			break
		end
	end
end )

hook.Add('InitPostEntity', 'npc_rp_smug_nigga', function()
	local npc = ents.Create('cocaine_drugs_buyer')
	npc:SetPos(rp.cfg.CocaineBuyer[game.GetMap()].Pos)
	npc:SetAngles(rp.cfg.CocaineBuyer[game.GetMap()].Ang)
	npc:Spawn()
end)