/// @function	sys_vngen_config();
/// @author		Lucas Chasteen <lucas.chasteen@xgasoft.com>
/// @copyright	XGASOFT 2020, All Rights Reserved
function sys_vngen_config() {

	/*
	==========================================================================
	SYSTEM FUNCTION: MODIFY AT YOUR OWN RISK!
	--------------------------------------------------------------------------
	  System functions are executed automatically by the engine and typically
	  should not be run manually by the user
	==========================================================================

	Automatically runs when the application starts to initialize all necessary
	global VNgen system functions and parameters.

	No parameters

	Example usage:
	   None; self-executing script.
	*/

	//Set script to autorun at launch
	gml_pragma("global", "sys_vngen_config();");

	//Set VNgen version info
	global.vg_version = "VNgen version 1.0.8, build 020620";

	//Disable repeating textures
	gpu_set_texrepeat(false);

	//Initialize cursor properties
	global.vg_cur_default = cr_arrow;
	global.vg_cur_pointer = cr_handpoint;
      
	//Initialize debug mode functions
	global.vg_debug = false;
	global.vg_debug_helpers = true;
	global.vg_debug_stats = false;

	//Initialize display properties
	global.dp_width = window_get_width();
	global.dp_height = window_get_height();
	global.dp_width_init = global.dp_width;
	global.dp_height_init = global.dp_height;
	global.dp_width_previous = global.dp_width;
	global.dp_height_previous = global.dp_height;
	global.dp_fullscreen = false;
	global.dp_scale_view = none;

	//Initialize recording most recent previously-accessed data structure
	global.ds_pdata = none;
	global.ds_ptype = none;
	global.ds_pxindex = 0;
	global.ds_pyindex = 0;

	//Initialize backlog properties
	global.ds_log = -1;
	global.ds_log_button = -1;
	global.ds_log_queue = -1;
	global.vg_log_alpha = 0;
	global.vg_log_max = 0;
	global.vg_log_visible = false;

	//Initialize option result log
	global.ds_option_result = -1;

	//Initialize skipping and read logs
	global.ds_read = -1;
	global.vg_event_skip_pause = false;
	global.vg_event_skip_read = false;
	global.vg_event_skip_reset = -1;

	//Initialize room event skip proxy
	global.vg_room_object = -1;
	global.vg_room_event = -1;
	global.vg_room_event_perform = true;

	//Initialize style inheritance
	global.ds_style = -1;

	//Initialize automatic text progression
	global.vg_text_auto = false;
	global.vg_text_auto_pause = 0;
	global.vg_text_auto_current = 0;
	global.vg_text_auto_pause_indefinite = false;
      
	//Initialize text lineheight
	global.vg_lineheight_text = 1.5;
	global.vg_lineheight_label = 1.5;

	//Initialize text alignment
	global.vg_halign_text = fa_left;
	global.vg_halign_label = fa_left;

	//Initialize text typewriter effect speed
	global.vg_speed_text = 25;
	global.vg_speed_label = 0;
            
	//Initialize text and audio language
	global.vg_lang_text = -1;
	global.vg_lang_audio = -1;

	//Initialize UI properties
	global.vg_ui_alpha = 1;
	global.vg_ui_lock = true;
	global.vg_ui_visible = true;

	//Initialize global audio volumes
	global.vg_vol_music = 1;
	global.vg_vol_sound = 1;
	global.vg_vol_ui    = 1;
	global.vg_vol_voice = 1;
	global.vg_vol_vox   = 1;
            
	//Initialize pausing the engine
	global.vg_pause = false;

	//Initialize rendering mode functions
	global.vg_renderlevel = 0;

	//Use legacy rendering by default on HTML5
	if (os_browser != browser_not_a_browser) {
	   vngen_set_renderlevel(2);
	} else {
	   //Use reduced rendering by default on mobile devices
	   if (os_type == os_android) or (os_type == os_ios) {
	      vngen_set_renderlevel(1);
	   }
	}

	//Initialize engine constants
	enum prop {
	  _id = 0,
	  _var = 0,
	  _xpoint = 0,
	  _data_event = 0,
	  _data_queue = 1,
	  _data_text = 1,
	  _name = 1,
	  _snd = 1,
	  _sprite = 1,
	  _state = 1,
	  _src = 1,
	  _uniform = 1,
	  _tmp_var = 1,
	  _ypoint = 1,
	  _data_audio = 2,
	  _left = 2,
	  _type = 2,
	  _val = 2,
	  _tmp_xpoint = 2,
	  _event = 3,
	  _top = 3,
	  _tmp_ypoint = 3,
	  _snd_dur = 4,
	  _width = 4,
	  _height = 5,
	  _snd_start = 6,
	  _xorig = 6,
	  _snd_end = 7,
	  _yorig = 7,
	  _snd_pos = 8,
	  _x = 8,
	  _snd_vol = 9,
	  _y = 9,
	  _z = 10,
	  _per_zoom = 11,
	  _snd_pitch_min = 11,
	  _xscale = 11,
	  _per_str = 12,
	  _snd_pitch = 12,
	  _snd_pitch_max = 12,
	  _yscale = 12,
	  _rot = 13,
	  _col1 = 14,
	  _col2 = 15,
	  _col3 = 16,
	  _col4 = 17,
	  _alpha = 18,
	  _time = 19,
	  _fade_src = 20,
	  _fade_alpha = 21,
	  _fade_vol = 21,
	  _fade_draw = 22,
	  _fade_time = 22,
	  _oxscale = 23,
	  _oyscale = 24,
	  _tmp_xorig = 25,
	  _tmp_yorig = 26,
	  _tmp_x = 27,
	  _tmp_vol = 28,
	  _tmp_y = 28,
	  _tmp_pitch_min = 29,
	  _tmp_xscale = 29,
	  _tmp_zoom = 29,
	  _tmp_pitch = 30,
	  _tmp_pitch_max = 30,
	  _tmp_str = 30,
	  _tmp_yscale = 30,
	  _tmp_rot = 31,
	  _anim_xoffset = 32,
	  _tmp_col1 = 32,
	  _anim_yoffset = 33,
	  _tmp_col2 = 33,
	  _anim_tmp_xoffset = 34,
	  _tmp_col3 = 34,
	  _anim_tmp_yoffset = 35,
	  _tmp_col4 = 35,
	  _tmp_alpha = 36,
	  _tmp_time = 36,
	  _tmp_oxscale = 37,
	  _tmp_oyscale = 38,
	  _final_width = 39,
	  _final_height = 40,
	  _final_x = 41,
	  _final_y = 42,
	  _final_xscale = 43,
	  _final_yscale = 44,
	  _final_rot = 45,
	  _trans = 46,
	  _trans_key = 47,
	  _trans_dur = 48,
	  _trans_rev = 49,
	  _trans_left = 50,
	  _trans_top = 51,
	  _trans_width = 52,
	  _trans_height = 53,
	  _trans_x = 54,
	  _trans_y = 55,
	  _trans_xscale = 56,
	  _trans_yscale = 57,
	  _trans_rot = 58,
	  _trans_alpha = 59,
	  _trans_time = 60,
	  _trans_tmp_left = 61,
	  _trans_tmp_top = 62,
	  _trans_tmp_width = 63,
	  _trans_tmp_height = 64,
	  _trans_tmp_x = 65,
	  _trans_tmp_y = 66,
	  _trans_tmp_xscale = 67,
	  _trans_tmp_yscale = 68,
	  _trans_tmp_rot = 69,
	  _trans_tmp_alpha = 70,  
	  _shader = 71,
	  _sh_frame = 72,
	  _sh_amt = 73,
	  _sh_float_data = 74,
	  _sh_mat_data = 75,
	  _sh_samp_data = 76,
	  _sh_time = 77,
	  _anim = 78,
	  _anim_key = 79,
	  _anim_dur = 80,
	  _anim_loop = 81,
	  _anim_rev = 82,
	  _anim_ease = 83,
	  _anim_x = 84,
	  _anim_y = 85,
	  _anim_xscale = 86,
	  _anim_zoom = 86,
	  _anim_yscale = 87,
	  _anim_str = 87,
	  _anim_rot = 88,
	  _anim_col1 = 89,
	  _anim_col2 = 90,
	  _anim_col3 = 91,
	  _anim_col4 = 92,
	  _anim_alpha = 93,
	  _anim_time = 94,
	  _anim_tmp_x = 95,
	  _anim_tmp_y = 96,
	  _anim_tmp_xscale = 97,
	  _anim_tmp_zoom = 97,
	  _anim_tmp_str = 98,
	  _anim_tmp_yscale = 98,
	  _anim_tmp_rot = 99,
	  _anim_tmp_col1 = 100,
	  _anim_tmp_col2 = 101,
	  _anim_tmp_col3 = 102,
	  _anim_tmp_col4 = 103,
	  _anim_tmp_alpha = 104,
	  _def = 105,
	  _ef = 105,
	  _def_key = 106,
	  _ef_key = 106,
	  _def_dur = 107,
	  _ef_dur = 107,
	  _def_loop = 108,
	  _ef_loop = 108,
	  _def_rev = 109,
	  _ef_rev = 109,
	  _def_ease = 110,
	  _ef_ease = 110,
	  _def_point_data = 111,
	  _ef_var_data = 111,
	  _def_time = 112,
	  _ef_time = 112,
	  _def_surf = 113,
	  _def_fade_surf = 114,
	  _img_index = 116,
	  _img_num = 117,
	  _scn_foreground = 118,
	  _sprite2 = 118,
	  _char_height = 119,
	  _scn_repeat = 119,
	  _sprite3 = 119,
	  _char_x = 120,
	  _face_x = 120,
	  _txt_x = 120,
	  _char_y = 121,
	  _face_y = 121,
	  _txt_y = 121,
	  _pause = 122,
	  _trigger = 122,
	  _speed = 123,
	  _face_time = 123,
	  _index = 124,
	  _number = 125,
	  _surf = 126,
	  _attach_data = 127,
	  _lab_auto = 127,
	  _snd_hover = 127,
	  _txt_complete = 127,
	  _hlight = 128,
	  _redraw = 128,
	  _snd_select = 128,
	  _hlight_alpha = 129,
	  _txt_fnt = 129,
	  _txt_active = 130,
	  _txt_shadow = 130,
	  _snd_active = 131,
	  _txt_outline = 131,
	  _tmp_shadow = 132,
	  _tmp_outline = 133,
	  _txt = 134,
	  _txt_orig = 135,
	  _txt_halign = 136,
	  _txt_line_break = 137,
	  _txt_line_height = 138,
	  _txt_line_data = 139,
	  _init_width = 140,
	  _mark_fnt = 140,
	  _lab_event = 140,
	  _init_height = 141,
	  _mark_yoffset = 141,
	  _init_x = 142,
	  _mark_shadow = 142,
	  _init_y = 143,
	  _mark_outline = 143,
	  _init_xscale = 144,
	  _mark_col1 = 144,
	  _init_yscale = 145,
	  _mark_col2 = 145,
	  _mark_col3 = 146,
	  _mark_col4 = 147,
	  _mark_spd = 148,
	  _mark_time = 149,
	  _mark_pause = 150,
	  _mark_link_data = 151
	}

	//Initialize scripting constants
#macro audio_type_sound 0
#macro audio_type_voice 1
#macro audio_type_music 2
#macro audio_type_vox 3
#macro audio_type_ui 4
#macro anim_zoom anim_xscale
#macro anim_strength anim_yscale
#macro input_zoom input_xscale
#macro input_strength input_yscale
#macro any -3
#macro auto -1
#macro inherit -2
#macro previous -1
#macro none -4
#macro toggle -2
#macro orig_top 0
#macro orig_left 0
#macro orig_center -1
#macro orig_bottom -2
#macro orig_right -2
#macro scale_none -4
#macro scale_x_y 1
#macro scale_x 2
#macro scale_y 3
#macro scale_stretch_x_y 4
#macro scale_stretch_x 5
#macro scale_stretch_y 6
#macro scale_prop_x_y 7
#macro scale_prop_x 8
#macro scale_prop_y 9
#macro trans_none -4
#macro vngen_type_perspective 0
#macro vngen_type_scene 1
#macro vngen_type_char 2
#macro vngen_type_attach 3
#macro vngen_type_emote 4
#macro vngen_type_textbox 5
#macro vngen_type_text 6
#macro vngen_type_label 7
#macro vngen_type_prompt 8
#macro vngen_type_option 9
#macro vngen_type_audio 10
#macro vngen_type_vox 11
#macro vngen_type_effect 12
#macro vngen_type_button 13
#macro vngen_type_speaker 14


}
