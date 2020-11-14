/// @function	sys_layer_log_set_target();
/// @author		Lucas Chasteen <lucas.chasteen@xgasoft.com>
/// @copyright	XGASOFT 2020, All Rights Reserved
function sys_layer_log_set_target() {

	/*
	==========================================================================
	SYSTEM FUNCTION: MODIFY AT YOUR OWN RISK!
	--------------------------------------------------------------------------
	  System functions are executed automatically by the engine and typically
	  should not be run manually by the user
	==========================================================================

	Initializes visibility, audio, and other functions necessary for drawing
	the VNgen backlog

	No arguments
            
	Example usage:
	   sys_layer_log_set_target();
	*/

	/* 
	INITIALIZATION
	*/

	//Initialize temporary variables for drawing logged data
	var ds_log_text, ds_xindex, ds_yindex;

	//Get GUI dimensions
	gui_width = display_get_gui_width();
	gui_height = display_get_gui_height();

	//Scale GUI to application surface dimensions
	if (gui_width != global.dp_width) or (gui_height != global.dp_height) {
	   display_set_gui_size(global.dp_width, global.dp_height);

	   //Get new GUI dimensions
	   gui_width = display_get_gui_width();
	   gui_height = display_get_gui_height();
	}
 
	//Reset mouse hover state
	mouse_hover = false;


	/*
	VISIBILITY
	*/

	if (global.vg_log_visible == false) {
	   //Fade log out, if hidden
	   if (global.vg_log_alpha > 0) {
	      global.vg_log_alpha -= ((12/time_speed)*time_offset);
      
	      //Disallow exceeding target values
	      if (global.vg_log_alpha <= 0) {
	         global.vg_log_alpha = 0;
         
	         //Reset button state
	         button_hover = -1;
	         button_active = -1;
         
	         //Reset touch scrolling
	         log_touch[0] = log_touch[1];
	         log_touch_momentum = 0;
	         log_touch_active = false;
         
	         //Reset log navigation
	         log_current = 0;
	         log_count = 0;
	         log_event = -1;
	         log_y = 0;
	         log_ycurrent = 0;
         
	         //Clear text surfaces from memory
	         if (ds_exists(global.ds_log, ds_type_grid)) {
	            for (ds_yindex = 0; ds_yindex < ds_grid_height(global.ds_log); ds_yindex += 1) {
	               //Clear text data
	               if (ds_exists(global.ds_log[# prop._data_text, ds_yindex], ds_type_grid)) {
	                  //Get text data from main data structure
	                  ds_log_text = global.ds_log[# prop._data_text, ds_yindex];
         
	                  //Remove text data from memory
	                  for (ds_xindex = 0; ds_xindex < ds_grid_height(ds_log_text); ds_xindex += 1) {
	                     //Remove surfaces
	                     if (surface_exists(ds_log_text[# prop._surf, ds_xindex])) {
	                        surface_free(ds_log_text[# prop._surf, ds_xindex]);
	                     }
         
	                     //Remove linebreak data
	                     if (ds_exists(ds_log_text[# prop._txt_line_data, ds_xindex], ds_type_list)) {
	                        ds_list_destroy(ds_log_text[# prop._txt_line_data, ds_xindex]);
	                     }
	                  }
	               }
	            }
	         }  
         
	         //Reset mouse cursor if nothing is hovered
	         mouse_hover = false;
	         sys_mouse_hover(false);               
	      }      
	   }   
	} else {
	   //Force log closed if debug console is open
	   if (global.cmd_visible == true) {
	      global.vg_log_visible = false;
	      global.vg_pause = false;
	   }
   
	   //Fade log in, if shown
	   if (global.vg_log_alpha < 1) {
	      //Initialize log properties
	      if (global.vg_log_alpha <= 0) {         
	         //Reset touch scrolling
	         log_touch[0] = log_touch[1];
	         log_touch_momentum = 0;
	         log_touch_active = false;
         
	         //Reset log navigation
	         log_current = 0;
	         log_count = 0;
	         log_event = -1;
	         log_y = 0;
	         log_ycurrent = 0;
	      }
      
	      //Fade log in
	      global.vg_log_alpha += ((6/time_speed)*time_offset);
      
	      //Disallow exceeding maximum value
	      if (global.vg_log_alpha > 1) {
	         global.vg_log_alpha = 1;
	      } 
	   }  
   
   
	   /*
	   ANIMATION
	   */
   
	   //Update time properties for the current frame
	   time_frame = delta_time/1000000;
	   time_speed = game_get_speed(gamespeed_fps);   
	   time_target = 1/time_speed;
	   time_offset = (time_frame/time_target);
   
	   //Get animation speed
	}

   
	/*
	INTEGRITY CHECKS
	*/

	//Ensure primary data structures exist and recreate if broken
	var log_refresh = false;
   
	if (!ds_exists(global.ds_log, ds_type_grid))        { log_refresh = true; }
	if (!ds_exists(global.ds_log_button, ds_type_grid)) { log_refresh = true; }
	if (!ds_exists(global.ds_log_queue, ds_type_grid))  { log_refresh = true; }
   
	if (log_refresh == true) {
	   vngen_log_clear(false);
	   vngen_log_init(global.vg_log_max);
	} 


	/*
	AUDIO
	*/

	//If audio queue exists...
	if (ds_exists(global.ds_log, ds_type_grid)) {
	   if (ds_exists(global.ds_log_queue[# prop._data_queue, 0], ds_type_queue)) {
	      if (!ds_queue_empty(global.ds_log_queue[# prop._data_queue, 0])) {
	         //Get the current audio to be played
	         var ds_audio = ds_queue_head(global.ds_log_queue[# prop._data_queue, 0]);
	         var ds_audio_pos = audio_sound_get_track_position(ds_audio);

	         //If audio is incomplete...
	         if (ds_audio_pos < (audio_sound_length(ds_audio) - 0.05)) {
	            //Play audio, if not yet started
	            if (!audio_is_playing(ds_audio)) {
	               audio_play_sound(ds_audio, 1, false);
				   audio_sound_gain(ds_audio, global.vg_vol_voice, 0);
	            }
   
	            //Update audio track position
	            audio_sound_set_track_position(ds_audio, ds_audio_pos + time_frame);
	         } else {
	            //If audio is complete, reset track position...
	            audio_sound_set_track_position(ds_audio, 0);
         
	            //Ensure audio is stopped...
	            audio_stop_sound(ds_audio);
         
	            //And remove it from the queue
	            ds_queue_dequeue(global.ds_log_queue[# prop._data_queue, 0]);
	         }
   
	         //Force stop playing if log is closed
	         if (global.vg_log_visible == false) {
	            //If audio is playing, reset track position...
	            audio_sound_set_track_position(ds_audio, 0);
         
	            //Ensure audio is stopped...
	            audio_stop_sound(ds_audio);
         
	            //And clear the audio queue
	            global.ds_log_queue[# prop._data_event, 0] = -1;
	            ds_queue_destroy(global.ds_log_queue[# prop._data_queue, 0]);
	         }
	      } else {
	         //Remove queue from memory when complete
	         global.ds_log_queue[# prop._data_event, 0] = -1;
	         ds_queue_destroy(global.ds_log_queue[# prop._data_queue, 0]);
	      }
	   }
	}


}
