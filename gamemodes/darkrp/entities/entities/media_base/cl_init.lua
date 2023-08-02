include'shared.lua'
cvar.Register'media_enable':SetDefault(true):AddMetadata('State', 'RPMenu'):AddMetadata('Menu', 'Медиа-Плеер')
cvar.Register'media_mute_when_unfocused':SetDefault(true):AddMetadata('State', 'RPMenu'):AddMetadata('Menu', 'Заглушить Медиа-Плеер при сворачивании игры')
cvar.Register'media_volume':SetDefault(0.37):AddMetadata('State', 'RPMenu'):AddMetadata('Menu', 'Медиа-Плеер звук'):AddMetadata('Type', 'number')
cvar.Register'media_quality':SetDefault('low')
cvar.Register'media_favs':SetDefault({})

radio1 = {
['https://ru.hitmotop.com/get/music/20210710/The_Weeknd_-_Blinding_Lights_73039568.mp3'] = {"The Weeknd - Blinding Lights"},

['https://ru.hitmotop.com/get/music/20210710/The_Weeknd_-_Save_Your_Tears_73039052.mp3'] = {"The Weeknd - Save Your Tears"},

['https://ru.hitmotop.com/get/music/20210710/Masked_Wolf_-_Astronaut_In_The_Ocean_73039050.mp3'] = {"Astronaut In The Ocean - Masked Wolf"},

['https://ru.hitmotop.com/get/music/20210910/INSTASAMKA_-_LIPSI_HA_73156409.mp3'] = {"LIPSI HA - INSTASAMKA"},

['https://ru.hitmotop.com/get/music/20171104/YUrijj_SHatunov_-_Sedaya_noch_50310007.mp3'] = {"Седая ночь - Юрий Шатунов"},

['https://ru.hitmotop.com/get/music/20221224/KINO_-_Kukushka_75344243.mp3'] = {"Кукушка - КИНО"},

['https://ru.hitmotop.com/get/music/20190305/Korol_i_SHut_-_Kukla_kolduna_62570545.mp3'] = {"Кукла колдуна - Король и Шут"},

['https://ru.hitmotop.com/get/music/20170830/Miyagi_Rem_Digga_-_I_Got_Love_47828425.mp3'] = {"I Got Love - Miyagi, Рем Дигга"},

['https://ru.hitmotop.com/get/music/20190305/Korol_i_SHut_-_Lesnik_62571704.mp3'] = {"Лесник - Король и Шут"},

['https://ru.hitmotop.com/get/music/20170904/Korol_i_SHut_-_Durak_i_molniya_48182429.mp3'] = {"Дурак и молния - Король и Шут"},

['https://ru.hitmotop.com/get/music/20170905/Sektor_Gaza_-_Lirika_48202412.mp3'] = {"Лирика - Сектор Газа"},

['https://ru.hitmotop.com/get/music/20220810/Milana_Star_Milana_KHametova_-_LP_74646248.mp3'] = {"ЛП - Milana Star, Милана Хаметова"},

['https://ru.hitmotop.com/get/music/20220816/KSLV_Noh_-_Chase_74654367.mp3'] = {"Chase - KSLV Noh"},

['https://ru.hitmotop.com/get/music/20220821/Ghostface_Playa_-_Why_Not_74661028.mp3'] = {"Why Not - Ghostface Playa"},

['https://ru.hitmotop.com/get/music/20220826/DVRST_-_Tell_me_what_74667077.mp3'] = {"Tell me what - DVRST"},

['https://ru.hitmotop.com/get/music/20180718/Imagine_Dragons_-_Natural_57429538.mp3'] = {"Natural - Imagine Dragons"},

['https://ru.hitmotop.com/get/music/20200216/MORGENSHTERNVitya_AK_-_RATATATA_-_Morgenshtern_-_RATATATATA_68409957.mp3'] = {"РАТАТАТАТА - MORGENSHTERN"},

['https://ru.hitmotop.com/get/music/20170920/Stromae_-_Alors_On_Danse_48744026.mp3'] = {"Alors On Danse - Stromae"},

['https://ru.hitmotop.com/get/music/20190129/Mr_Kitty_-_After_Dark_61741935.mp3'] = {"After Dark - Mr. Kitty"},

['https://ru.hitmotop.com/get/music/20170831/The_Prodigy_-_Breathe_47896844.mp3'] = {"Breathe - The Prodigy"},

['https://ru.hitmotop.com/get/music/20190330/Billie_Eilish_-_bad_guy_63154737.mp3'] = {"bad guy - Billie Eilish"},

['https://ru.hitmotop.com/get/music/20170830/Twenty_One_Pilots_-_Heathens_47842856.mp3'] = {"Heathens - Twenty One Pilots"},

['https://ru.hitmotop.com/get/music/20170902/Slipknot_-_Psychosocial_47954346.mp3'] = {"Psychosocial - Slipknot"},

['https://ru.hitmotop.com/get/music/20180911/Molchat_Doma_-_Sudno_Boris_Ryzhijj_58595715.mp3'] = {"Судно (Борис Рыжий) - Молчат Дома"},

['https://ru.hitmotop.com/get/music/20170830/Gorillaz_Jamie_Hewlett_-_Clint_Eastwood_47843086.mp3'] = {"Clint Eastwood - Gorillaz, Jamie Hewlett"},

['https://ru.hitmotop.com/get/music/20171019/MGMT_-_Little_Dark_Age_49717933.mp3'] = {"Little Dark Age - MGMT"},

['https://ru.hitmotop.com/get/music/20170830/Pixies_-_Where_Is_My_Mind_47844330.mp3'] = {"Where Is My Mind? - Pixies"},

['https://ru.hitmotop.com/get/music/20220406/KSLV_Noh_-_Override_74032117.mp3'] = {"Override - KSLV Noh"},

['https://ru.hitmotop.com/get/music/20170830/Twenty_One_Pilots_-_Ride_47828700.mp3'] = {"Ride - Twenty One Pilots"},

['https://ru.hitmotop.com/get/music/20190202/Billie_Eilish_-_bury_a_friend_61822134.mp3'] = {"bury a friend - Billie Eilish"},

['https://ru.hitmotop.com/get/music/20170902/Radiohead_-_Creep_48022418.mp3'] = {"Creep - Radiohead"},

['https://ru.hitmotop.com/get/music/20170830/Twenty_One_Pilots_-_Heavydirtysoul_47828698.mp3'] = {"Heavydirtysoul - Twenty One Pilots"},

['https://ru.hitmotop.com/get/music/20170905/Syava_-_Dzhekpot_48245375.mp3'] = {"Джекпот - Сява"},

['https://ru.hitmotop.com/get/music/20210710/Dabro_-_YUnost_73038987.mp3'] = {"Юность - Dabro"},

['https://ru.hitmotop.com/get/music/20170831/Grimes_-_Kill_V_Maim_47896798.mp3'] = {"Kill V. Maim - Grimes"},

['https://ru.hitmotop.com/get/music/20201211/PT_Adamczyk_Cyberpunk_2077_2020_-_The_Rebel_Path_71931828.mp3'] = {"The Rebel Path - P.T. Adamczyk"},

['https://ru.hitmotop.com/get/music/20170905/Skrillex_-_Kill_EVERYBODY_48242424.mp3'] = {"Kill EVERYBODY - Skrillex"},

['https://ru.hitmotop.com/get/music/20210710/Lil_Nas_X_-_Montero_73039048.mp3'] = {"Montero - Lil Nas X"},

['https://ru.hitmotop.com/get/music/20210716/Dabro_-_Na_chasakh_nol-nol_73051677.mp3'] = {"На часах ноль-ноль - Dabro"},

['https://ru.hitmotop.com/get/music/20210710/Foushee_-_Deep_End_73039082.mp3'] = {"Deep End - Foushee"},

['https://ru.hitmotop.com/get/music/20211009/FinikFinya_ALEKS_ATAMAN_-_Dialogi_tet-a-tet_73193667.mp3'] = {"Диалоги тет-а-тет - Finik.Finya, ALEKS ATAMAN"},

['https://ru.hitmotop.com/get/music/20200207/Artik_Asti_-_Devochka_tancujj_68289048.mp3'] = {"Девочка, танцуй - Artik & Asti"},

['https://ru.hitmotop.com/get/music/20211024/GAYAZOV_BROTHER_-_MALINOVAYA_LADA_73214200.mp3'] = {"МАЛИНОВАЯ ЛАДА - GAYAZOV$ BROTHER$"},

['https://ru.hitmotop.com/get/music/20211031/Tanir_Tyomcha_-_Poteryali_pacana_73251527.mp3'] = {"Потеряли пацана - Tanir & Tyomcha"},

['https://ru.hitmotop.com/get/music/20210710/Dj_Smash_feat_Pojot_-_Begi_73038985.mp3'] = {"Беги - Dj Smash feat Poёt"},

['https://ru.hitmotop.com/get/music/20210710/Doja_Cat_-_Say_So_73039095.mp3'] = {"Say So - Doja Cat"},

['https://ru.hitmotop.com/get/music/20220309/shadowraze_-_showdown_73909739.mp3'] = {"showdown - shadowraze"},

['https://ru.hitmotop.com/get/music/20220624/EGOR_KRID_-_DEVOCHKA_NE_PLACH_74517159.mp3'] = {"ДЕВОЧКА НЕ ПЛАЧЬ - ЕГОР КРИД"},

['https://ru.hitmotop.com/get/music/20220705/BUSHIDO_ZHO_-_vodila_74549801.mp3'] = {"vodila - BUSHIDO ZHO"},

['https://ru.hitmotop.com/get/music/20220520/The_Limba_-_Sekret_74293318.mp3'] = {"Секрет - The Limba"},

['https://ru.hitmotop.com/get/music/20190306/HammAli_Navai_-_Devochka-vojjna_62592480.mp3'] = {"Девочка-война - HammAli & Navai"},

['https://ru.hitmotop.com/get/music/20210416/femlove_-_otografiruyu_zakat_72911325.mp3'] = {"Фотографирую закат - fem.love"},

['https://ru.hitmotop.com/get/music/20210129/Konfuz_-_Ratata_72487823.mp3'] = {"Ратата - Konfuz"},

['https://ru.hitmotop.com/get/music/20220208/Dzharo_KHanza_-_Slysh_Malaya_73780423.mp3'] = {"Слышь, Малая - Джаро & Ханза"},

['https://ru.hitmotop.com/get/music/20190503/NILETTO_-_Lyubimka_63911927.mp3'] = {"Любимка - NILETTO"},

['https://ru.hitmotop.com/get/music/20190308/Artur_Pirozhkov_-_Zacepila_62633997.mp3'] = {"Зацепила - Артур Пирожков"},

['https://ru.hitmotop.com/get/music/20190710/RASA_-_Pchelovod_65347747.mp3'] = {"Пчеловод - RASA"},

['https://ru.hitmotop.com/get/music/20190116/Basta_Skriptonit_Diana_Arbenina_SunSay_Sergejj_Bobunec_Aleksandr_Sklyar_-_Sansara_61448210.mp3'] = {"Сансара - Баста"},

['https://ru.hitmotop.com/get/music/20180609/Dynoro_-_In_My_Mind_56567595.mp3'] = {"In My Mind - Dynoro"},

['https://ru.hitmotop.com/get/music/20180526/Aaron_Smith_-_Dancin_56233203.mp3'] = {"Dancin - Aaron Smith"},

['https://ru.hitmotop.com/get/music/20180526/Monetochka_-_Kazhdyjj_raz_56229288.mp3'] = {"Каждый раз - Монеточка"},

['https://ru.hitmotop.com/get/music/20180510/Grandson_-_Blood_Water_55883550.mp3'] = {"Blood // Water - Grandson"},

['https://ru.hitmotop.com/get/music/20181029/Ariya_-_Bespechnyjj_angel_59996943.mp3'] = {"Беспечный ангел - Ария"},

['https://ru.hitmotop.com/get/music/20181026/Tima_Belorusskikh_-_Nezabudka_59932823.mp3'] = {"Незабудка - Тима Белорусских"},

['https://ru.hitmotop.com/get/music/20220805/Imagine_Dragons_-_Believer_74640917.mp3'] = {"Believer - Imagine Dragons"},

['https://ru.hitmotop.com/get/music/20210220/SLAVA_MARLOW_-_TY_GORISH_KAK_OGON_72724219.mp3'] = {"ТЫ ГОРИШЬ КАК ОГОНЬ - SLAVA MARLOW"},

['https://ru.hitmotop.com/get/music/20200410/Cream_Soda_KHleb_-_Plachu_na_tekhno_69139877.mp3'] = {"Плачу на техно - Cream Soda, Хлеб"},

['https://ru.hitmotop.com/get/music/20170831/The_White_Stripes_-_Seven_Nation_Army_47894307.mp3'] = {"Seven Nation Army - The White Stripes"},

['https://ru.hitmotop.com/get/music/20170831/Evanescence_-_Bring_Me_To_Life_47885099.mp3'] = {"Bring Me To Life - Evanescence"},

['https://ru.hitmotop.com/get/music/20170830/Red_Hot_Chili_Peppers_-_Cant_Stop_47829176.mp3'] = {"Can't Stop - Red Hot Chili Peppers"},

['https://ru.hitmotop.com/get/music/20170830/Imagine_Dragons_-_Thunder_47828258.mp3'] = {"Thunder - Imagine Dragons"},

['https://ru.hitmotop.com/get/music/20170903/Daft_Punk_-_Get_Lucky_48069574.mp3'] = {"Get Lucky - Daft Punk"},

['https://ru.hitmotop.com/get/music/20170903/Coolio_-_Gangstas_Paradise_48050761.mp3'] = {"Gangsta's Paradise - Coolio"},

['https://ru.hitmotop.com/get/music/20170831/Muse_-_Time_Is_Running_Out_47894357.mp3'] = {"Time Is Running Out - Muse"},

['https://ru.hitmotop.com/get/music/20210710/Galibri_feat_Mavik_-_ederiko_ellini_73039147.mp3'] = {"Федерико Феллини - Galibri feat Mavik"},

['https://ru.hitmotop.com/get/music/20210710/Phao_-_2_Phut_Hon_73039168.mp3'] = {"2 Phut Hon - Phao"},

['https://ru.hitmotop.com/get/music/20210710/Dora_-_Vtyurilas_73039187.mp3'] = {"Втюрилась - Дора"},

['https://ru.hitmotop.com/get/music/20191106/dora_-_Dora_dura_67181158.mp3'] = {"Дора дура - дора"},

['https://ru.hitmotop.com/get/music/20190213/FACE_-_YUmorist_62083353.mp3'] = {"Юморист - FACE"},

['https://ru.hitmotop.com/get/music/20190129/FACE_-_MOJJ_KALASHNIKOV_61744829.mp3'] = {"МОЙ КАЛАШНИКОВ - FACE"},

['https://ru.hitmotop.com/get/music/20170830/Maks_Korzh_-_ZHit_v_kajjf_47828991.mp3'] = {"Жить в кайф - Макс Корж"},

['https://ru.hitmotop.com/get/music/20190918/Nurminskijj_-_Valim_66621751.mp3'] = {"Валим - Нурминский"},

['https://ru.hitmotop.com/get/music/20180904/Tima_Belorusskikh_-_Mokrye_krossy_58394454.mp3'] = {"Мокрые кроссы - Тима Белорусских"},

['https://ru.hitmotop.com/get/music/20210528/MORGENSHTERN_-_ARISTOCRAT_72984961.mp3'] = {"ARISTOCRAT - MORGENSHTERN"},

['https://ru.hitmotop.com/get/music/20170901/Maks_Korzh_-_Malyjj_povzroslel_47921854.mp3'] = {"Малый повзрослел - Макс Корж"},

['https://ru.hitmotop.com/get/music/20181117/Big_Baby_Tape_-_Gimme_The_Loot_60366687.mp3'] = {"Gimme The Loot - Big Baby Tape"},

['https://ru.hitmotop.com/get/music/20191129/Neizvesten_-_chto_takoe_dobrota_67454829.mp3'] = {"Что такое доброта - Барбарики"},

['https://ru.hitmotop.com/get/music/20190419/LIZER_-_Ne_Angel_63590454.mp3'] = {"Не Ангел - LIZER"},

['https://ru.hitmotop.com/get/music/20190522/PHARAOH_-_Black_Siemens_64407440.mp3'] = {"Black Siemens - PHARAOH"},

['https://ru.hitmotop.com/get/music/20220812/LXST_CXNTURY_-_LIBERTY_74648661.mp3'] = {"LIBERTY - LXST CXNTURY"},

['https://ru.hitmotop.com/get/music/20200331/KAITO_SHOMA_beat_-_SCARY_GARY_68995011.mp3'] = {"SCARY GARY - KAITO SHOMA beat."},

['https://ru.hitmotop.com/get/music/20220604/PHOROMANE_-_DEVIL_EYES_74384331.mp3'] = {"DEVIL EYES - PHOROMANE"},

['https://ru.hitmotop.com/get/music/20220909/JONY_-_Nikak_74703967.mp3'] = {"Никак - JONY"},

['https://ru.hitmotop.com/get/music/20170905/BASTA_-_Vypusknojj_Medlyachok_48206841.mp3'] = {"Выпускной (Медлячок) - БАСТА"},

['https://ru.hitmotop.com/get/music/20170830/Valentin_Strykalo_-_Nashe_leto_47843119.mp3'] = {"Наше лето - Валентин Стрыкало"},

['https://ru.hitmotop.com/get/music/20170830/Valentin_Strykalo_-_YA_byu_zhenshhin_i_detejj_47843124.mp3'] = {"Я бью женщин и детей - Валентин Стрыкало"},

['https://ru.hitmotop.com/get/music/20170903/Mikhail_SHufutinskijj_-_3-e_sentyabrya_48105361.mp3'] = {"3-е сентября - Михаил Шуфутинский"},

['https://ru.hitmotop.com/get/music/20171025/Stigmata_-_Sentyabr_49941016.mp3'] = {"Сентябрь - Stigmata"},

['https://ru.hitmotop.com/get/music/20221205/INSTASAMKA_-_ZA_DENGI_DA_75227740.mp3'] = {'Instasamka - ЗА ДЕНЬГИ ДА'},

['https://ru.hitmotop.com/get/music/20221217/INSTASAMKA_-_KAK_MOMMY_75305573.mp3'] = {'Instasamka - КАК MOMMY'},

['https://ru.hitmotop.com/get/music/20220923/INSTASAMKA_-_POPSTAR_74722740.mp3'] = {'Instasamka - POPSTAR'}


}
function ENT:Think()
	local link = self:GetURL()
	local shouldplay = cvar.GetValue('media_enable') and (LocalPlayer():EyePos():Distance(self:GetPos()) < 400)
	if IsValid(self.Media) and (not link or not shouldplay) then
		self.Media:stop()
		self.Media = nil
	elseif shouldplay and (not IsValid(self.Media) or self.Media:getUrl() ~= link) then
		if IsValid(self.Media) then
			self.Media:stop()
			self.Media = nil
		end
		if (link ~= '') then
			local service = medialib.load('media').guessService(link)

			if service then
				local mediaclip = service:load(link, {
					use3D = true,
					ent3D = self
				})

				mediaclip:setVolume((system.HasFocus() and cvar.GetValue('media_volume') or ((not cvar.GetValue('media_mute_when_unfocused')) and cvar.GetValue('media_volume') or 0)))
				mediaclip:setQuality(cvar.GetValue('media_quality'))

				if (self:GetTime() ~= 0) then
					mediaclip:seek(CurTime() - self:GetStart())
				end

				mediaclip:play()
				self.Media = mediaclip
			end
		end
	end
end

function ENT:OnRemove()
	if IsValid(self.Media) then
		self.Media:stop()
	end 
end 

local color_bg = rp.col.Black
local color_text = rp.col.White

function ENT:DrawScreen(x, y, w, h)
	if IsValid(self.Media) then
		self.Media:draw(x, y, w, h)
	else
		draw.Box(x, y, w, h, color_bg)
		draw.SimpleText('Нет медиа. Нажмите кнопку «E» на проекторе / телевизоре.', 'DermaLarge', x + (w * .5), y + (h * .5), color_text, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
	end
end

local fr
local song
local ent
local text
local favs = cvar.GetValue('media_favs')


local function AddRow(p, l, n)
	if (not IsValid(p)) then return end -- menu got closed before the link info loaded
	local media = p:AddRow(n)

	media.DoClick = function(s)
		local m = ui.DermaMenu(self)

		m:AddOption('Play', function()
			if IsValid(ent) then
				cmd.Run('playsong', ent:EntIndex(), song.Link)
				song = nil
			end
		end)


		m:Open()
		song = s
	end

	media.Link = l
	media.Name = n

	return media
end

net.Receive('rp.MediaMenu', function()
	if IsValid(fr) then
		fr:Close()
	end

	ent = net.ReadEntity()
	local w, h = ScrW() * .45, ScrH() * .4
	local play
	local save

	fr = ui.Create('ui_frame', function(self)
		self:SetTitle('Медиа плеер')
		self:SetSize(w, h)
		self:MakePopup()
		self:Center()
	end)
	

	local function buildrow(args)
		row = ui.Create('ui_listview', function(self, p)
			self:DockToFrame()
			self:SetSize(p:GetWide() - 10, p:GetTall() - 65)

			for k, v in pairs(radio1) do
				if args and !string.find(string.lower(v[1]), string.lower(args)) then print(string.find(v[1], args)) continue end
				AddRow(self, k, v[1])
				--print(k)
			end

		end, fr)
	end

	buildrow()

--PrintTable(radio1)

	text = ui.Create('DTextEntry', function(self, p)
		self:SetSize(p:GetWide() - 120, 25)
		self:SetPos(5, p:GetTall() - 30)

		function self:OnChange()
			if IsValid(row) then row:Remove() end

			buildrow(self:GetValue())
		end

	end, fr)
	
	stop = ui.Create('DButton', function(self, p)
		self:SetText('Стоп')
		self:SetSize(100, 25)
		self:SetPos(p:GetWide() - 110, p:GetTall() - 30)

		self.DoClick = function()
			if IsValid(ent) then
				cmd.Run('playsong', ent:EntIndex(), 'test')
				song = nil
			end
		end
	end, fr)

	//play = ui.Create('DButton', function(self, p)
	//	self:SetText('Пуск')
	//	self:SetSize(110, 25)
	//	self:SetPos(p:GetWide() - 170, p:GetTall() - 30)
//
	//	self.DoClick = function()
	//		if IsValid(ent) then
	//			RunConsoleCommand('playsong', ent:EntIndex(), text:GetValue() or song.Link)
	//			song = nil
	//		end
	//	end
//
	//	self.Think = function(self)
	//		if (not medialib.load('media').guessService(text:GetValue())) then
	//			self:SetDisabled(true)
	//		else
	//			self:SetDisabled(false)
	//		end
	//	end
	//end, fr)


end)