/// @function	vngen_event_set_target();
/// @author		Lucas Chasteen <lucas.chasteen@xgasoft.com>
/// @copyright	XGASOFT 2020, All Rights Reserved
function vngen_event_set_target() {

	/*
	Initializes a segment of code containing VNgen events. Once this script has been 
	run, as many instances of vngen_event as desired can be run. After the final 
	instance of vngen_event, vngen_event_reset_target must be run to properly 
	end the sequence.

	Intended to be run in the Step event.

	No parameters

	Example usage:
	   vngen_event_set_target();

	   if vngen_event() {
	      //Actions
	   }

	   vngen_event_reset_target();
	*/

	/*
	INITIALIZATION
	*/
         
	//Initialize temporary variables for processing entities
	var ds_type, ds_yindex;
	var event_refresh = false;

	//Initialize automatic event IDs
	event_id = -1;

	//Initialize automatic action IDs
	action_id = -1;

	//Update time properties for the current frame
	time_frame = delta_time/1000000;
	time_speed = game_get_speed(gamespeed_fps);
	time_target = 1/time_speed;
	time_offset = time_frame/time_target;


	/*
	INTEGRITY CHECKS
	*/

	//Ensure primary data structures exist and recreate if broken
	if (event_current >= 0) {
	   if (!ds_exists(ds_perspective, ds_type_grid)) { event_refresh = true; }
	   if (!ds_exists(ds_scene, ds_type_grid))       { event_refresh = true; }
	   if (!ds_exists(ds_character, ds_type_grid))   { event_refresh = true; }
	   if (!ds_exists(ds_emote, ds_type_grid))       { event_refresh = true; }
	   if (!ds_exists(ds_textbox, ds_type_grid))     { event_refresh = true; }
	   if (!ds_exists(ds_text, ds_type_grid))        { event_refresh = true; } 
	   if (!ds_exists(ds_label, ds_type_grid))       { event_refresh = true; }
	   if (!ds_exists(ds_prompt, ds_type_grid))      { event_refresh = true; }
	   if (!ds_exists(ds_button, ds_type_grid))      { event_refresh = true; }
	   if (!ds_exists(ds_option, ds_type_grid))      { event_refresh = true; }
	   if (!ds_exists(ds_audio, ds_type_grid))       { event_refresh = true; }
	   if (!ds_exists(ds_vox, ds_type_grid))         { event_refresh = true; }
	   if (!ds_exists(ds_effect, ds_type_grid))      { event_refresh = true; }


	   /*
	   SCALING
	   */
   
	   //Recalculate scale if screen mode is changed
	   if (window_get_fullscreen() != global.dp_fullscreen) { 
	      global.dp_fullscreen = window_get_fullscreen(); 
	      event_refresh = true; 
	   }
   
	   //If scaling is enabled...
	   if (global.dp_scale_view >= 0) {
	      if (!sys_event_skip()) {
	         //Get window dimensions based on platform
	         if (os_browser == browser_not_a_browser) {
	            var window_width = window_get_width();
	            var window_height = window_get_height();
	         } else {
	            //HTML5
	            var window_width = browser_width - 1;
	            var window_height = browser_height - 1;
	         }
         
	        //Skip scaling if minimized
	        if (window_width > 32) and (window_height > 32) {  		 
	            //If a change has been made to the game display...
	            if (window_width != global.dp_width_previous) or (window_height != global.dp_height_previous) {          
	               //Adapt height to aspect ratio
	               global.dp_height *= ((global.dp_width/global.dp_height)/(window_width/window_height)); 
               
	               //Scale viewport to new dimensions
				   camera_set_view_size(view_camera[global.dp_scale_view], global.dp_width, global.dp_height);
	               view_wport[global.dp_scale_view] = window_width;
	               view_hport[global.dp_scale_view] = window_height;
               
	               //Scale browser viewport to new dimensions
	               if (os_browser != browser_not_a_browser) {
	                  window_set_rectangle(0, 0, window_width, window_height);
	               }
               
	               //Scale perspective to new dimensions
	               ds_perspective[# prop._width, 0] = window_width;
	               ds_perspective[# prop._height, 0] = window_height;
            
	               //Get display dimensions for the next step
	               global.dp_width_previous = window_width;
	               global.dp_height_previous = window_height;      
               
	               //Enable refreshing data
	               event_refresh = true;
	            }
         
	            //Get final dimensions
	            window_width = min(global.dp_width, window_width);
	            window_height = min(global.dp_height, window_height);
               
	            //Scale application surface to window dimensions
	            if (surface_exists(application_surface)) {
	               if (surface_get_width(application_surface) != window_width) or (surface_get_height(application_surface) != window_height) {
	                  surface_resize(application_surface, window_width, window_height);

	                  //Scale GUI to window dimensions
	                  display_set_gui_size(window_width, window_height);

	                  //Set debug console font size based on window dimensions
	                  if (global.dp_width < 2500) and (global.dp_height < 1400) {
	                     fnt_console = fnt_console_small;
	                  } else {
	                     fnt_console = fnt_console_large;
	                  }
				   }
	            }
	         }
	      }
	   }

	   //Restart the current event if data reset is required
	   if (event_refresh == true) {
	      //Force text elements visible
	      global.vg_ui_visible = true;
      
	      //Clear the log queue to prevent duplicate entries
	      sys_queue_destroy("log");
      
	      //Restart the current event
	      vngen_goto(event_current);
	      exit;
	   }
	}


	/*
	SKIPPING
	*/

	//Countdown skip reset grace period
	if (global.vg_event_skip_reset > -1) {
	   global.vg_event_skip_reset -= 1;
	}

	//Skip to loaded event, if any
	if (event_skip_load != -1) {
		if (event_count > 0) {
			//Skip to target event
			vngen_goto(event_skip_load);
		
			//End load skip
			event_skip_load = -1;
		}
	}

	//Skip read events, if enabled
	if (event_skip_read == true) {
	   if (event_count > 0) {
	      //Enable skipping read events
	      sys_read_skip(true);
      
	      //Begin skip
	      event_skip_id = event_count;
      
	      //End read skip check
	      event_skip_read = false;
	   }
	}

	//Get event label skip state
	if (event_skip_label != -1) {
	   if (event_count > 0) {
	      if (array_length_1d(event_label) == event_count) {
	         //If label skip is active, force disable ID skip
	         event_skip_id = -1;
         
	         //Get event ID to skip to
	         var event_index = 0;
	         while (event_index < event_count) {
	            //If the label exists, skip to it
	            if (event_label[event_index] == event_skip_label) {
	               event_skip_id = event_index;
	               break;
	            }
            
	            //Increment label index
	            event_index += 1;
	         }

	         //If the label does not exist, cancel skip operation
	         if (event_skip_id == -1) {
	            draw_enable_drawevent(true);
	         }
	      }
	   }
	}

	//Get event ID skip state
	if (event_skip_id != -1) {
	   if (event_count > 0) {
	      //If ID skip is active, skip to it
	      sys_event_skip(clamp(event_skip_id, 0, event_count - 1));
      
	      //Reset event/action pauses
	      action_pause = 0;
	      event_pause = 0;
      
	      //If target event exceeds event total, skip actions in final event
	      if (event_skip_id >= event_count) {
	         action_skip_active = true;
	      }
	   }
	}

	//Initialize skip, if active
	if (event_skip_id != -1) or (event_skip_label != -1) {
	   if (event_count > 0) {
	      if (sys_event_skip()) {     
	         //Reset object if skip target is before the current event
	         if (event_skip <= event_current) {
	            if (event_skip_perform == true) { 
	               //Preserve looped audio, if any
	               if (ds_exists(ds_audio, ds_type_grid)) { 
	                  for (ds_yindex = 0; ds_yindex < ds_grid_height(ds_audio); ds_yindex += 1) {
	                     //Get audio type
	                     ds_type = ds_audio[# prop._type, ds_yindex];
                     
	                     //If sound is not looped...
	                     if (is_even(ds_type)) {
	                        //Ensure the sound has stopped
	                        audio_stop_sound(ds_audio[# prop._snd, ds_yindex]);
                     
	                        //Remove sound from data structure
	                        ds_audio = sys_grid_delete(ds_audio, ds_yindex);
	                        }
	                     }
                  
	                  //Backup audio data to temp data structure
	                  var temp_audio = ds_grid_create(ds_grid_width(ds_audio), ds_grid_height(ds_audio));
	                  ds_grid_copy(temp_audio, ds_audio);
	               } else {
	                  var temp_audio = -1;
	               }        
            
	               //Preserve skip target
	               var temp_event_count = event_count;
	               var temp_event_skip = event_skip;
	               var temp_action_skip = action_skip_active;
               
	               //Preserve event labels
	               var temp_event_label = event_label;
         
	               //Reset the object
	               vngen_object_clear(false);
	               vngen_object_init();
               
	               //Restore audio, if any
	               if (ds_exists(temp_audio, ds_type_grid)) {
	                  ds_grid_copy(ds_audio, temp_audio);
	                  ds_grid_destroy(temp_audio);
	               }
            
	               //Restore skip target
	               event_count = temp_event_count;
	               event_current = -1;
	               event_skip = temp_event_skip;
	               action_skip_active = temp_action_skip;
               
	               //Restore event labels
	               event_label = temp_event_label;
	               temp_event_label = -1;
	            } else {
	               //Otherwise backtrack to skip target directly
	               event_current = event_skip - 1;
			   
			       //Reset action state
			       action_id = -1;
			       action_count = 0;
			       action_complete = 0;
			       action_current = 0;
			       action_previous = -1;
				   action_pause = 0;
	            }
	         }
      
	         //Reset cursor state
	         if (mouse_hover_enable == true) {
	            mouse_hover_check = true;
	         }
	         mouse_hover = false;
	         sys_mouse_hover(false);
         
			 //Preserve pause state while skipping
			 global.vg_event_skip_pause = global.vg_pause;
	         global.vg_pause = false;
         
	         //Initialize skip reset grace period
	         global.vg_event_skip_reset = 1;
            
	         //End skip initialization
	         event_skip_id = -1;   
	         event_skip_label = -1;
	      }
	   }
	}


	/*
	DEVELOPER CONSOLE
	*/

	//Display developer console if tilde (~) key is pressed
	if (global.vg_debug == true) {
	   if (keyboard_check_pressed(192)) {
	      sys_toggle_cmd();
	   }

	   //Get command console user input
	   sys_cmd_perform();
	}



}
