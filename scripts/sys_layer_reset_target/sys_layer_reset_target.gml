/// @function	sys_layer_reset_target();
/// @author		Lucas Chasteen <lucas.chasteen@xgasoft.com>
/// @copyright	XGASOFT 2020, All Rights Reserved
function sys_layer_reset_target() {

	/*
	==========================================================================
	SYSTEM FUNCTION: MODIFY AT YOUR OWN RISK!
	--------------------------------------------------------------------------
	  System functions are executed automatically by the engine and typically
	  should not be run manually by the user
	==========================================================================

	Finalizes drawing VNgen layers and draws layer debug information, if enabled

	No parameters
            
	Example usage:
	   sys_layer_reset_target();
	*/


	/*
	FINALIZATION
	*/

	//If the mouse has moved...
	if (mouse_x != mouse_xprevious) or (mouse_y != mouse_yprevious) {
	   //Reset mouse cursor if nothing is hovered
	   if (mouse_hover == false) {
	      sys_mouse_hover(false);
	   } else {
	      //Otherwise set mouse to pointer, if enabled
	      sys_mouse_hover(true);
	   }
	}

	//Update mouse previous coordinates
	mouse_xprevious = mouse_x;
	mouse_yprevious = mouse_y;


	/*
	DEBUG MODE
	*/

	//Skip processing if vngen_object_clear has been run
	if (event_current < 0) {
	   exit;
	}

	//Display developer contents, if enabled
	if (global.vg_debug == true) {
	   //Get current texture filter setting
	   var temp_texfilter = gpu_get_tex_filter();
   
	   //Set drawing properties
	   draw_set_font(fnt_console);
	   gpu_set_tex_filter(false);
   
	   //Get font size for drawing stats
	   var fnt_size = font_get_size(fnt_console);
   
	   //Draw debug helpers, if enabled
	   if (global.vg_debug_helpers == true) {      
	      //Get GUI dimensions
	      var gui_xcenter = room_xoffset + (global.dp_width*0.5);
	      var gui_ycenter = room_yoffset + (global.dp_height*0.5);
	      var gui_sin = dsin(per_rot)*(fnt_size*1.5);
	      var gui_cos = dcos(per_rot)*(fnt_size*1.5);
      
	      //Draw center crosshair
	      draw_set_color(c_lime);
	      draw_line(gui_xcenter - gui_cos, gui_ycenter + gui_sin, gui_xcenter + gui_cos, gui_ycenter - gui_sin);
	      draw_arrow(gui_xcenter + gui_sin, gui_ycenter + gui_cos, gui_xcenter - gui_sin, gui_ycenter - gui_cos, (fnt_size*0.75));
	      draw_text(gui_xcenter + (fnt_size*2), gui_ycenter - (fnt_size*3), "(" + string(per_rot) + "deg)"); //Rotation
	      draw_set_halign(fa_right);
	      draw_text(gui_xcenter - fnt_size, gui_ycenter + (fnt_size*1.5), "(" + string(per_x) + "x, " + string(per_y) + "y)"); //X/Y
      
	      //Draw crosshair vector
	      draw_set_color(c_yellow);
	      draw_line(gui_xcenter, gui_ycenter, gui_xcenter + per_xoffset, gui_ycenter + per_yoffset);
	      draw_text(gui_xcenter + (per_xoffset*0.5), gui_ycenter + (per_yoffset*0.5), "(" + string(per_strength_fg) + "st)"); //Strength
      
	      //Draw offset crosshair
	      draw_set_color(c_red);
	      draw_line(gui_xcenter + per_xoffset - (fnt_size*0.75), gui_ycenter + per_yoffset, gui_xcenter + per_xoffset + (fnt_size*0.75), gui_ycenter + per_yoffset);
	      draw_line(gui_xcenter + per_xoffset, gui_ycenter + per_yoffset - (fnt_size*0.75), gui_xcenter + per_xoffset, gui_ycenter + per_yoffset + (fnt_size*0.75));  
	      draw_text(gui_xcenter + per_xoffset - (fnt_size*2), gui_ycenter + per_yoffset - (fnt_size*3), "(" + string(per_zoom_bg) + "zm)"); //Zoom
	      draw_set_halign(fa_left);
	      draw_text(gui_xcenter + per_xoffset + fnt_size, gui_ycenter + per_yoffset + (fnt_size*1.5), "(" + string(per_xoffset) + "px, " + string(per_yoffset) + "py)"); //Perspective X/Y
	   }   
   
	   //Draw engine debug stats, if enabled
	   if (global.vg_debug_stats == true) {
	      //Get backlog button stats, if any
	      var stats_log_btn = 0;
	      if (ds_exists(global.ds_log_button, ds_type_grid)) {
	         stats_log_btn = ds_grid_height(global.ds_log_button);
	      }
      
	      //Get stats, if enabled
	      var stats_left = "\n\n\nResolution: " + string(global.dp_width) + "x" + string(global.dp_height) +
	                  "\n\n\nLog entries: " + string(vngen_log_count()) +
	                  "\n\n\nEvent Pause: " + string(event_pause) + 
	                  "\n\nAction Pause: " + string(action_pause) +
	                  "\n\nAuto Pause: " + string(global.vg_text_auto_pause - global.vg_text_auto_current) +
	                  "\n\nOption Pause: " + string(option_pause) +
	                  "\n\n\nEvent Object: " + object_get_name(object_index) +
	                  "\n\nEvent Current: " + string(event_current) + 
	                  "\n\nEvent Total: " + string(event_count) +
	                  "\n\n\nAction Current: " + string(action_complete) +
	                  "\n\nAction Total: " + string(action_count);
	      var stats_right = "\n\n\nActive Entities:" +
	                  "\n\nScenes: " + string(ds_grid_height(ds_scene)) +
	                  "\n\nChars [Atts]: " + string(ds_grid_height(ds_character)) + " [" + string(attach_count) + "]" + 
	                  "\n\nEmotes: " + string(ds_grid_height(ds_emote)) +            
	                  "\n\nEffects: " + string(ds_grid_height(ds_effect)) +  
	                  "\n\nTextboxes: " + string(ds_grid_height(ds_textbox)) +    
	                  "\n\nText: " + string(ds_grid_height(ds_text)) + 
	                  "\n\nLabels: " + string(ds_grid_height(ds_label)) + 
	                  "\n\nPrompts: " + string(ds_grid_height(ds_prompt)) + 
	                  "\n\nButtons [Log]: " + string(ds_grid_height(ds_button)) + " [" + string(stats_log_btn) + "]" + 
	                  "\n\nOptions: " + string(ds_grid_height(ds_option)) + 
	                  "\n\nAudio [Vox]: " + string(ds_grid_height(ds_audio)) + " [" + string(ds_grid_height(ds_vox)) + "]";   
	   } else {
	      //Otherwise do not draw stats
	      var stats_left = "";
	      var stats_right = "";
	   }
   
	   //Draw developer mode status and info
	   draw_set_color($EEEEEE);
	   draw_text(room_xoffset + (fnt_size*2), room_yoffset + (fnt_size*3), "DEBUG MODE" + stats_left);
	   draw_set_halign(fa_right);
	   draw_text(room_xoffset + global.dp_width - (fnt_size*2), room_yoffset + (fnt_size*3), stats_right);   
   
	   //Reset drawing properties
	   draw_set_halign(fa_left);
	   draw_set_color(c_white);
	   draw_set_font(fnt_default);
   
	   //Draw developer console, if enabled
	   sys_cmd_draw(room_xoffset, room_yoffset + global.dp_height - (fnt_size*3), global.dp_width, (fnt_size*3), fnt_console, c_black, c_lime);
   
	   //Restore previous texture filter setting
	   gpu_set_tex_filter(temp_texfilter);
	}


}
