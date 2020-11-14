/// @function	sys_toggle_cmd([sound]);
/// @param		{sound}	[sound]
/// @author		Lucas Chasteen <lucas.chasteen@xgasoft.com>
/// @copyright	XGASOFT 2020, All Rights Reserved
function sys_toggle_cmd() {

	/*
	==========================================================================
	SYSTEM FUNCTION: MODIFY AT YOUR OWN RISK!
	--------------------------------------------------------------------------
	  System functions are executed automatically by the engine and typically
	  should not be run manually by the user
	==========================================================================

	Shows the command console if it is hidden or hides it if it is visible. 
	Optionally also plays a sound on action.

	argument0 = sound to play on toggle (sound) (optional, use no argument for none)

	Example usage:
	   sys_toggle_cmd(snd_input);
	*/

	//Skip action if backlog is open
	if (global.vg_log_visible == true) {
	   exit;
	}

	//If command console is closed...
	if (global.cmd_visible == false) {
	   //Show console
	   global.cmd_visible = true;
   
	   //Clear console input
	   global.cmd_input = "";
	   global.cmd_input_index = 1;
	   global.cmd_input_result = "";
	   keyboard_lastchar = "";
   
	   //Reset input history navigation
	   global.cmd_current = 0;
      
	   //Play audio, if any
	   if (argument_count > 0) {
	      if (audio_exists(argument[0])) {
	         if (!audio_is_playing(argument[0])) {
	            audio_play_sound(argument[0], 1, false);
	         }
	      }      
	   }
   
	   //Initialize default commands
	   sys_cmd_add("!!", cmd_firework);
	   sys_cmd_add("exit", cmd_exit);
	   sys_cmd_add("game_end", cmd_game_end);
	   sys_cmd_add("game_restart", cmd_game_restart);
	   sys_cmd_add("help", cmd_help);
	   sys_cmd_add("localhelp", cmd_localhelp);
	   sys_cmd_add("room_goto", cmd_vngen_room_goto);
	   sys_cmd_add("show_debug_helpers", cmd_show_debug_helpers);
	   sys_cmd_add("show_debug_overlay", cmd_show_debug_overlay);
	   sys_cmd_add("show_debug_stats", cmd_show_debug_stats);
	   sys_cmd_add("vngen_file_save", cmd_vngen_file_save);
	   sys_cmd_add("vngen_file_load", cmd_vngen_file_load);
	   sys_cmd_add("vngen_file_delete", cmd_vngen_file_delete);
	   sys_cmd_add("vngen_goto", cmd_vngen_goto);
	   sys_cmd_add("vngen_goto_unread", cmd_vngen_goto_unread);
	   sys_cmd_add("vngen_log_clear", cmd_vngen_log_clear);
	   sys_cmd_add("vngen_room_goto", cmd_vngen_room_goto);
	   sys_cmd_add("vngen_set_lang", cmd_vngen_set_lang);
	   sys_cmd_add("vngen_get_lang", cmd_vngen_get_lang);
	   sys_cmd_add("vngen_set_renderlevel", cmd_vngen_set_renderlevel);
	   sys_cmd_add("vngen_set_scale", cmd_vngen_set_scale);
	   sys_cmd_add("vngen_set_speed", cmd_vngen_set_speed);
	   sys_cmd_add("vngen_set_vol", cmd_vngen_set_vol);
	   sys_cmd_add("vngen_version", cmd_vngen_version);
	   sys_cmd_add("window_set_fullscreen", cmd_window_set_fullscreen);   
	   exit;
	}

	//If the command console is opened...
	if (global.cmd_visible == true) {
	   //Hide console
	   global.cmd_visible = false;
   
	   //Clear console input
	   global.cmd_input = "";
	   global.cmd_input_index = 1;
	   global.cmd_input_result = "";
	   keyboard_lastchar = "";
   
	   //Reset input history navigation
	   global.cmd_current = 0;
      
	   //Play audio, if any
	   if (argument_count > 0) {
	      if (audio_exists(argument[0])) {
	         if (!audio_is_playing(argument[0])) {
	            audio_play_sound(argument[0], 1, false);
	         }
	      }        
	   }
	}


}
