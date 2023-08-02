local test = {}
-- ето не оптимизация, ето ухудшатель рп вещей цукец
local cmdlist = {
	gmod_mcore_test 				= { 1, GetConVarNumber },
	fov_desired 					= { 90, GetConVarNumber },
	studio_queue_mode 				= { 1, GetConVarNumber },
	cl_threaded_bone_setup 			= { 1, GetConVarNumber },
	cl_timeout 						= { 600, GetConVarNumber },
	cl_detailfade           		= { 1, GetConVarNumber },
	cl_detaildist           		= { 2, GetConVarNumber },
	mat_queue_mode 					= { -1, GetConVarNumber },
	mat_disable_bloom       		= { 1, GetConVarNumber },
	mat_bloom_scalefactor_scalar 	= { 1, GetConVarNumber },
	r_drawmodeldecals 				= { 0, GetConVarNumber },
	r_WaterDrawReflection 			= { 0, GetConVarNumber },
	r_queued_ropes 					= { 1, GetConVarNumber },
    r_WaterDrawRefraction 			= { 0, GetConVarNumber },
    r_waterforceexpensive 			= { 0, GetConVarNumber },
    r_shadowrendertotexture 		= { 0, GetConVarNumber },
    r_shadowmaxrendered 			= { 0, GetConVarNumber },
    r_shadows 						= { 0, GetConVarNumber },
    r_eyemove               		= { 0, GetConVarNumber },
    r_3dsky                         = { 0, GetConVarNumber }
}

if CLIENT then
for k,v in pairs(cmdlist) do
	test[k] = v[2](k)
	RunConsoleCommand(k, v[1])
    end
end

hook.Add('ShutDown', 'rbackconvars', function()
	for k,v in pairs(test) do RunConsoleCommand(k, v) end
end)

-- 
if (SERVER) then
	RunConsoleCommand('mp_show_voice_icons', '0')
	RunConsoleCommand('sv_allowupload', '1')
	RunConsoleCommand('sv_allowcslua', '0')
	RunConsoleCommand('sv_stats', '0')
	RunConsoleCommand('sv_allowdownload', '1')
	RunConsoleCommand('sv_logbans', '1')
	RunConsoleCommand('sv_logecho', '1')
	RunConsoleCommand('sv_logfile', '1')
	RunConsoleCommand('net_maxfilesize', '500')
	RunConsoleCommand('sv_lan', '0')
	RunConsoleCommand('decalfrequency', '10')
	RunConsoleCommand('sv_alltalk', '0')
	RunConsoleCommand('sv_voiceenable', '1')
	--RunConsoleCommand('r_3dsky', '0')
end

-- Это типа оптимизация немного
if CLIENT then
	concommand.Add("potato_optimization", function()
	RunConsoleCommand('cl_playerspraydisable', '1')
	RunConsoleCommand('rope_smooth', '0')
	RunConsoleCommand('cl_detail_avoid_radius', '0')
	RunConsoleCommand('r_cheapwaterend', '0')
	RunConsoleCommand('cl_detail_max_sway', '0')
	RunConsoleCommand('ai_expression_optimization', '0')
	RunConsoleCommand('mat_bloom_scalefactor_scalar', '0')
	RunConsoleCommand('lod_transitiondist', '0')
	RunConsoleCommand('cl_new_impact_effects', '0')
	RunConsoleCommand('g_ragdoll_maxcount', '0')
	RunConsoleCommand('mat_disable_bloom', '1')
	RunConsoleCommand('r_propsmaxdist', '600')
	RunConsoleCommand('cl_phys_props_max', '100')
	RunConsoleCommand('datacachesize', '4096')
	RunConsoleCommand('fps_max', '1000')
	RunConsoleCommand('cl_threaded_bone_setup', '0')
	RunConsoleCommand('r_threaded_renderables', '0')
	RunConsoleCommand('M9KGasEffect', '0')
	RunConsoleCommand('gmod_mcore_test', '1')
	RunConsoleCommand('violence_hblood', '0')
	RunConsoleCommand('violence_hgibs', '0')
	RunConsoleCommand('violence_agibs', '0')
	RunConsoleCommand('violence_ablood', '0')
	RunConsoleCommand('r_bloomtintb', '0')
	RunConsoleCommand('r_bloomtintr', '0')
	RunConsoleCommand('r_bloomtintg', '0')
	RunConsoleCommand('r_teeth', '0')
	RunConsoleCommand('r_flex', '0')
	RunConsoleCommand('studio_queue_mode', '1')
	RunConsoleCommand('r_renderoverlayfragment', '0')
	RunConsoleCommand('r_shadowmaxrendered', '0')
	RunConsoleCommand('r_bloomtintexponent', '0')
	RunConsoleCommand('mat_wateroverlaysize', '1')
	RunConsoleCommand('Ragdoll_sleepaftertime', '0')
	RunConsoleCommand('r_RainSimulate', '0')
	RunConsoleCommand('R_maxnewsamples', '2')
	RunConsoleCommand('r_staticprop_lod', '3')
	RunConsoleCommand('rope_averagelight', '0')
	RunConsoleCommand('r_drawbatchdecals', '0')
	RunConsoleCommand('G_ragdoll_lvfadespeed', '1')
	RunConsoleCommand('G_ragdoll_fadespeed', '1')
	RunConsoleCommand('cl_ejectbrass', '0')
	RunConsoleCommand('mat_forceaniso', '0')
	RunConsoleCommand('mat_bufferprimitives', '1')
	RunConsoleCommand('r_DrawRain', '0')
	RunConsoleCommand('r_3dnow', '1')
	RunConsoleCommand('lfs_volume', '0.7')
	RunConsoleCommand('props_break_max_pieces', '0')
	RunConsoleCommand('props_break_max_pieces_perframe', '0')
	RunConsoleCommand('r_spray_lifetime', '0')
	RunConsoleCommand('cl_pred_optimize', '2')
	RunConsoleCommand('cl_lagcompensation', '1')
	RunConsoleCommand('mat_antialias', '0')
	RunConsoleCommand('mat_trilinear', '0')
	RunConsoleCommand('r_cheapwaterend', '0')
	RunConsoleCommand('cl_forcepreload', '1')
	RunConsoleCommand('cl_drawspawneffect', '0')
	RunConsoleCommand('r_maxmodeldecal', '0')
	RunConsoleCommand('cl_smooth', '0')
	RunConsoleCommand('mat_filterlightmaps', '1')
	RunConsoleCommand('r_lod', '2')
	RunConsoleCommand('r_drawropes', '0')
	RunConsoleCommand('r_drawmodeldecals', '0')
	RunConsoleCommand('r_mmx', '1')
	RunConsoleCommand('mat_specular', '0')
	RunConsoleCommand('mp_decals', '0')
	RunConsoleCommand('r_sse', '1')
	RunConsoleCommand('r_sse2', '1')
	RunConsoleCommand('blink_duration', '1')
	RunConsoleCommand('dsp_enhance_stereo', '0')
	RunConsoleCommand('r_dopixelvisibility', '0')
	RunConsoleCommand('mat_bumpmap', '0')
	RunConsoleCommand('mat_clipz', '0')
	RunConsoleCommand('mat_envmaptgasize', '1')
	RunConsoleCommand('r_decals', '10')
	RunConsoleCommand('r_fastzreject', '0')
	RunConsoleCommand('r_eyeglintlodpixels', '1')
	RunConsoleCommand('r_eyemove', '1')
	RunConsoleCommand('r_WaterDrawReflection', '0')
	RunConsoleCommand('mat_fastnobump', '0')
	RunConsoleCommand('cl_detaildist', '1000')
	RunConsoleCommand('r_eyesize', '1')
	RunConsoleCommand('sv_forcepreload', '1')
	RunConsoleCommand('r_threaded_particles', '1')
	RunConsoleCommand('mem_max_heapsize_dedicated', '4096')
	RunConsoleCommand('muzzleflash_light', '0')
	RunConsoleCommand('r_drawflecks', '0')
	RunConsoleCommand('r_decalstaticprops', '0')
	RunConsoleCommand('fog_enable_water_fog', '0')
	RunConsoleCommand('r_occlusion', '1')
	RunConsoleCommand('fog_enable', '0')
	RunConsoleCommand('fog_enableskybox', '0')
	RunConsoleCommand('r_eyemove', '0')
	RunConsoleCommand('r_shadows', '1')
	RunConsoleCommand('mat_max_worldmesh_vertices', '512')
	RunConsoleCommand('mat_parallaxmap', '0')
	RunConsoleCommand('mat_queue_mode', '-1')
	RunConsoleCommand('snd_mix_async', '0')
	RunConsoleCommand('cl_phys_props_enable', '0')
	RunConsoleCommand('cl_pushaway_force', '0')
	RunConsoleCommand('cl_show_splashes', '0')
      end)
  end