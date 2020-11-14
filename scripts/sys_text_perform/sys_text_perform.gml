/// @function	sys_text_perform(entity, index);
/// @param		{integer}	entity
/// @param		{integer}	index
/// @author		Lucas Chasteen <lucas.chasteen@xgasoft.com>
/// @copyright	XGASOFT 2020, All Rights Reserved
function sys_text_perform(argument0, argument1) {

	/*
	==========================================================================
	SYSTEM FUNCTION: MODIFY AT YOUR OWN RISK!
	--------------------------------------------------------------------------
	  System functions are executed automatically by the engine and typically
	  should not be run manually by the user
	==========================================================================

	Renders text which has been pre-processed with sys_text_init, including
	performing special markup functions.

	VNgen's handling of this functionality is highly tailored for its particular
	use-cases and is not intended for general use.

	argument0 = the data structure of the entity for which to perform text (integer)
	argument1 = the index of the row containing the target entity ID (integer)

	Example usage:
	   sys_text_perform(ds_data, ds_target);
	*/

	/*
	INITIALIZATION
	*/

	//Get the target data structure
	var ds_data = argument0;
	var ds_target = argument1;

	//Skip processing surface when paused
	if (global.vg_pause == false) {
	   //Get text properties
	   var action_char_count = ds_data[# prop._number, ds_target];        
	   var action_char_index = ds_data[# prop._index, ds_target];        
	   var action_char_redraw = ds_data[# prop._redraw, ds_target];
	   var action_col1 = ds_data[# prop._col1, ds_target];
	   var action_col2 = ds_data[# prop._col2, ds_target];
	   var action_col3 = ds_data[# prop._col3, ds_target];
	   var action_col4 = ds_data[# prop._col4, ds_target];
	   var action_fnt = ds_data[# prop._txt_fnt, ds_target];
	   var action_frame = ds_data[# prop._pause, ds_target];
	   var action_char_height = ds_data[# prop._char_height, ds_target]*ds_data[# prop._txt_line_height, ds_target];
	   var action_name = ds_data[# prop._name, ds_target];
	   var action_outline = ds_data[# prop._txt_outline, ds_target];
	   var action_shadow = ds_data[# prop._txt_shadow, ds_target];
	   var action_string = ds_data[# prop._txt, ds_target];
	   var action_surf = ds_data[# prop._surf, ds_target]; 
	   var action_speed = ds_data[# prop._speed, ds_target];
   
	   //Intialize temp variables for drawing text
	   var char, ds_link, ds_xindex, height, height_previous, markup, markup_index, markup_col1, markup_col2, markup_col3, markup_col4, markup_event, markup_fnt, markup_type, markup_yoffset, pitch, value, value_index, vol, vol_fade;
	   var frametime = 0;
	   var vox = -1;
	   var vox_fade = -1;
         
	   //Use markup speed multiplier, if any
	   if (ds_data == ds_text) {
	      if (ds_data[# prop._mark_spd, ds_target] >= 0) {
	         action_speed *= ds_data[# prop._mark_spd, ds_target];
	      }
      
	      //Use markup line offset, if any
	      markup_yoffset = ds_data[# prop._mark_yoffset, ds_target];
	   } else {
	      //Disable markup modifiers if not text
	      action_speed = 0;
	      markup_yoffset = 0;
	   }
   
	   //If the typewriter effect is enabled...
	   if (action_char_index < action_char_count) {
	      if (action_speed > 0) {
	         //Get target typewriter effect frametime
	         frametime = 1/action_speed;
         
	         //Increment typewriter effect in characters per second                
	         if (action_frame >= frametime) {
	            ds_data[# prop._pause, ds_target] -= frametime;
	         }
	         ds_data[# prop._pause, ds_target] += time_frame;
   
	         //Get the number of characters to draw for the current frame
	         action_speed = (action_speed/time_speed)*time_offset;
      
	         /* VOX */
   
	         //Get vox audio to play, if any
	         for (ds_xindex = 0; ds_xindex < ds_grid_height(ds_vox); ds_xindex += 1) {
	            //If vox is assigned to the current character...
	            if (action_name == ds_vox[# prop._id, ds_xindex]) {
	               //If vox is not paused...
	               if (ds_vox[# prop._type, ds_xindex] == 0) {
	                  //Ensure vox data structure exists
	                  if (!ds_exists(ds_vox[# prop._snd, ds_xindex], ds_type_list)) {
	                     ds_vox[# prop._snd, ds_xindex] = ds_list_create();
	                  }
               
	                  //Get vox properties
	                  ds_vox_data = ds_vox[# prop._snd, ds_xindex];
	                  ds_vox_fade_data = ds_vox[# prop._fade_src, ds_xindex];
	                  pitch = random_range(ds_vox[# prop._snd_pitch_min, ds_xindex], ds_vox[# prop._snd_pitch_max, ds_xindex]);
	                  vol = ds_vox[# prop._snd_vol, ds_xindex];
	                  vol_fade = ds_vox[# prop._fade_vol, ds_xindex];
               
	                  //Get random vox from list
	                  if (ds_list_size(ds_vox_data) > 0) {
	                     ds_list_shuffle(ds_vox_data);
	                     vox = ds_list_find_value(ds_vox_data, 0);
	                  }

	                  //Get random fade vox from old list, if any
	                  if (ds_exists(ds_vox_fade_data, ds_type_list)) {
	                     if (ds_list_size(ds_vox_fade_data) > 0) {
	                        ds_list_shuffle(ds_vox_fade_data);
	                        vox_fade = ds_list_find_value(ds_vox_fade_data, 0);
	                     }
	                  }
	                  break;
	               }
	            }          
	         }
		  }
   
	      /* MARKUP */
         
	      //Use markup delay, if any
	      if (ds_data == ds_text) {
	         if (ds_data[# prop._mark_pause, ds_target] > 0) {
	            if (ds_data[# prop._mark_time, ds_target] < ds_data[# prop._mark_pause, ds_target]) {
	               //Countdown delay
	               ds_data[# prop._mark_time, ds_target] += time_frame;
            
	               //Disable typewriter effect until pause is complete
	               ds_data[# prop._pause, ds_target] = 0;
				  
	               //Disable character speech animations until pause is complete
			       sys_anim_speech(action_name, false, vngen_type_text);
                     
	               //Disable vox effects while typewriter is paused
	               vox = -1;
	               vox_fade = -1;
	            } else {
	               //Continue drawing when delay is complete
	               ds_data[# prop._pause, ds_target] = frametime;
			   
			       //Reset character speech animations
			       sys_anim_speech(action_name, true, vngen_type_text);
            
	               //Reset markup delay when complete
	               ds_data[# prop._mark_time, ds_target] = 0;
	               ds_data[# prop._mark_pause, ds_target] = 0;
	            }
	         } else {
	            //Wait for user input to unpause, if indefinite pause is enabled
	            if (ds_data[# prop._mark_pause, ds_target] < 0) {
	               if (text_pause == true) {
	                  //Disable typewriter effect until pause is complete
	                  ds_data[# prop._pause, ds_target] = 0;
				  
				      //Disable character speech animations until pause is complete
				      sys_anim_speech(action_name, false, vngen_type_text);
                     
	                  //Disable vox effects while typewriter is paused
	                  vox = -1;
	                  vox_fade = -1;
				  
					  //Convert indefinite delay to time if auto mode is enabled
					  if (global.vg_text_auto_pause_indefinite == false) {
					     if (global.vg_text_auto == true) {
					        ds_data[# prop._mark_pause, ds_target] *= -1;
						    text_pause = false;
					     }
					  }
	               } else {
				      //Reset character speech animations
				      sys_anim_speech(action_name, true, vngen_type_text);
				  
		              //Reset markup delay when complete
		              ds_data[# prop._mark_time, ds_target] = 0;
		              ds_data[# prop._mark_pause, ds_target] = 0;
		      		}
	            }
	         }
	      }
	   }
   
	   /* SPEED */

	   //Skip typewriter effect, if disabled
	   if (action_speed <= 0) or (sys_action_skip()) {
	      action_speed = action_char_count; //Set speed to instant
	      ds_data[# prop._pause, ds_target] = 1; //Enable drawing for the current frame
	      frametime = 0; //Disable adapting to frametime
	  
		  //Disable indefinite text pauses
		  if (ds_data == ds_text) {
		     text_pause = false; 
		  }
	   }

	   //Redraw text when modified
	   if (action_char_redraw > 0) {
	      if (ds_data[# prop._pause, ds_target] >= frametime) {
	         //Maintain typewriter effect while redrawing
	         action_speed += action_char_redraw;
	      } else {
	         //Otherwise if frame is not ready only redraw existing characters
	         action_speed = action_char_redraw;
	      }
      
	      //Reset character state
	      ds_data[# prop._char_x, ds_target] = 0;              //Reset char X
	      ds_data[# prop._char_y, ds_target] = markup_yoffset; //Reset char Y
	      ds_data[# prop._index, ds_target] = 0;               //Reset char index
	      action_char_index = 0;
      
	      //Reset markup values
	      if (ds_data == ds_text) {
	         ds_data[# prop._mark_fnt, ds_target] = -1;     //Reset markup font
	         ds_data[# prop._mark_shadow, ds_target] = -4;  //Reset markup shadow
	         ds_data[# prop._mark_outline, ds_target] = -4; //Reset markup outline
	         ds_data[# prop._mark_col1, ds_target] = -1;    //Reset markup color1
	         ds_data[# prop._mark_col2, ds_target] = -1;    //Reset markup color2
	         ds_data[# prop._mark_col3, ds_target] = -1;    //Reset markup color3
	         ds_data[# prop._mark_col4, ds_target] = -1;    //Reset markup color4
         
	         //Reset markup link data
	         if (ds_exists(ds_data[# prop._mark_link_data, ds_target], ds_type_grid)) {
	            ds_grid_destroy(ds_data[# prop._mark_link_data, ds_target]);
	            ds_data[# prop._mark_link_data, ds_target] = -1;
	         }
	      }
      
	      //Force redrawing the current frame
	      frametime = 0;
      
	      //End redrawing for this frame
	      ds_data[# prop._redraw, ds_target] = 0;
	   }
   
   
	   /* 
	   DRAWING 
	   */
   
	   //Get line starting position based on paragraph alignment
	   if (ds_data[# prop._char_x, ds_target] == 0) {
	      ds_data[# prop._char_x, ds_target] = sys_text_get_xoffset(ds_data, ds_target);
	   }

	   //Draw text with typewriter effect
	   if (ds_data[# prop._pause, ds_target] >= frametime) {
	      if (ds_data[# prop._index, ds_target] < action_char_count) {
	         //Draw surface contents
	         surface_set_target(action_surf);

	         //Clear surface on first draw
	         if (ds_data[# prop._index, ds_target] == 0) {
	            draw_clear_alpha(c_black, 0);
	         }

	         //Use markup font, if any
	         if (ds_data == ds_text) {
	            if (font_exists(ds_data[# prop._mark_fnt, ds_target])) {
	               action_fnt = ds_data[# prop._mark_fnt, ds_target];
	            }
            
	            //Use markup colors, if any
	            if (ds_data[# prop._mark_col1, ds_target] != -1) {
	               action_col1 = ds_data[# prop._mark_col1, ds_target];
	               action_col2 = ds_data[# prop._mark_col2, ds_target];
	               action_col3 = ds_data[# prop._mark_col3, ds_target];
	               action_col4 = ds_data[# prop._mark_col4, ds_target];
	            }
            
	            //Use markup shadow, if any
	            if (ds_data[# prop._mark_shadow, ds_target] != -4) {
	               action_shadow = ds_data[# prop._mark_shadow, ds_target];
	            }
            
	            //Use markup outline, if any
	            if (ds_data[# prop._mark_outline, ds_target] != -4) {
	               action_outline = ds_data[# prop._mark_outline, ds_target];
	            }
	         }
         
	         //Set the drawing font
	         draw_set_font(action_fnt);
                 
	         //Draw text to surface
	         while (ds_data[# prop._index, ds_target] < clamp(action_char_index + action_speed, 1, action_char_count)) {
	            //Increment typewriter effect
	            ds_data[# prop._index, ds_target] += 1;      
      
	            //Get character to draw
	            char = string_char_at(action_string, ds_data[# prop._index, ds_target]); 
            
	            //Process markup
	            if (char == "[") {
	               //Interpret text literally if escape character is used
	               if (string_char_at(action_string, ds_data[# prop._index, ds_target] - 1) != "^") {
	                  //Otherwise begin checking for markup at the current location
	                  markup_index = ds_data[# prop._index, ds_target];
      
	                  //Get markup start
	                  markup = string_delete(action_string, 1, markup_index);
      
	                  //Get markup end
	                  value_index = string_pos("]", markup);
                  
	                  //Get the setting defined in markup
	                  markup = string_copy(markup, 1, value_index - 1);
	                  markup_index = string_pos("=", markup);
                  
	                  //Get the value defined in markup
	                  value = string_copy(markup, markup_index + 1, value_index - markup_index - 1);
      
	                  //Finish parsing markup
	                  if (markup_index > 1) {
	                     markup = string_copy(markup, 1, markup_index - 1);
	                  }
   
	                  //Skip drawing markup
	                  ds_data[# prop._index, ds_target] += value_index;
      
	                  /* MARKUP TYPES */
                     
	                  if (ds_data == ds_text) {
	                     //If markup is "font"...
	                     if (markup == "font") {
	                        //Get the font to draw
	                        markup_fnt = asset_get_index(value);
			   
				            //Get font from variable if font asset does not exist
				            if (markup_fnt == -1) {
					           //Get global variable
					           if (string_count("global.", value) > 0) {
					         	 if (variable_global_exists(string_replace(value, "global.", ""))) {
					         	    markup_fnt = variable_global_get(string_replace(value, "global.", ""));
					         	 }
					           } else {
					         	 //Otherwise get local variable
					         	 if (variable_instance_exists(id, value)) {
					         		markup_fnt = variable_instance_get(id, value);
					         	 }
					           }
				            }
            
	                        //If font exists, set it
	                        if (font_exists(markup_fnt)) {
	                           //Get current font height to compare before setting new font
	                           height_previous = string_height("W");
                           
	                           //Set new font
	                           ds_data[# prop._mark_fnt, ds_target] = markup_fnt;
	                           draw_set_font(markup_fnt);
                           
	                           //Get new font height
	                           height = string_height("W");
                           
	                           //Offset vertical position to align to bottom
	                           ds_data[# prop._char_y, ds_target] += (height_previous - height)*0.8;
	                        }
	                     }
                     
	                     //If markup is "end font..."
	                     if (markup == "/font") {
	                        //Get current font height to compare before setting new font
	                        height_previous = string_height("W");
                           
	                        //Reset font
	                        ds_data[# prop._mark_fnt, ds_target] = -1;
	                        draw_set_font(ds_data[# prop._txt_fnt, ds_target]);
                           
	                        //Get new font height
	                        height = string_height("W");
                           
	                        //Offset vertical position to align to bottom
	                        ds_data[# prop._char_y, ds_target] += (height_previous - height)*0.8;
	                     }
                           
	                     //If markup type is "color"...
	                     if (markup == "color") {
	                        //Remove spaces between values, if any
	                        value = string_replace_all(value, " ", "");
                     
	                        //Get the input color(s)
	                        value_index = string_count(",", value);
                           
	                        //Set color gradient based on the number of input colors
	                        if (value_index > 0) {
	                           //Two-color gradient
	                           if (value_index == 1) {
	                              //Get first color
	                              value_index = string_pos(",", value);
                                 
	                              //Set first color
	                              markup_col1 = make_color_hex_to_rgb(string_copy(value, 1, value_index));
	                              markup_col2 = markup_col1;
                                 
	                              //Set second color
	                              markup_col3 = make_color_hex_to_rgb(string_delete(value, 1, value_index + 1));
	                              markup_col4 = markup_col3;
	                           } else {
	                              //Three-color gradient
	                              if (value_index == 2) {
	                                 //Get first color
	                                 value_index = string_pos(",", value);
                                 
	                                 //Set first color
	                                 markup_col1 = make_color_hex_to_rgb(string_copy(value, 1, value_index));
                                 
	                                 //Get second color
	                                 value = string_delete(value, 1, value_index + 1);
	                                 value_index = string_pos(",", value);
                                    
	                                 //Set second color
	                                 markup_col2 = make_color_hex_to_rgb(string_copy(value, 1, value_index));
                                    
	                                 //Set third color
	                                 markup_col3 = make_color_hex_to_rgb(string_delete(value, 1, value_index + 1));
	                                 markup_col4 = markup_col3;
	                              } else {
	                                 //Four-color gradient
	                                 if (value_index == 3) {
	                                    //Get first color
	                                    value_index = string_pos(",", value);
                                 
	                                    //Set first color
	                                    markup_col1 = make_color_hex_to_rgb(string_copy(value, 1, value_index));
                                 
	                                    //Get second color
	                                    value = string_delete(value, 1, value_index + 1);
	                                    value_index = string_pos(",", value);
                                    
	                                    //Set second color
	                                    markup_col2 = make_color_hex_to_rgb(string_copy(value, 1, value_index));
                                    
	                                    //Get third color
	                                    value = string_delete(value, 1, value_index + 1);
	                                    value_index = string_pos(",", value);
                                       
	                                    //Set third color
	                                    markup_col3 = make_color_hex_to_rgb(string_copy(value, 1, value_index));
                                       
	                                    //Set fourth color
	                                    markup_col4 = make_color_hex_to_rgb(string_delete(value, 1, value_index + 1));
	                                 }
	                              }
	                           }
	                        } else {
	                           //Otherwise use single color
	                           markup_col1 = make_color_hex_to_rgb(value);
	                           markup_col2 = markup_col1;
	                           markup_col3 = markup_col1;
	                           markup_col4 = markup_col1;
	                        }
                           
	                        //Set colors
	                        ds_data[# prop._mark_col1, ds_target] = markup_col1;
	                        ds_data[# prop._mark_col2, ds_target] = markup_col2;
	                        ds_data[# prop._mark_col3, ds_target] = markup_col3;
	                        ds_data[# prop._mark_col4, ds_target] = markup_col4;
	                        action_col1 = markup_col1;
	                        action_col2 = markup_col2;
	                        action_col3 = markup_col3;
	                        action_col4 = markup_col4;
	                     }
                     
	                     //If markup is "end color..."
	                     if (markup == "/color") {
	                        //Reset colors
	                        ds_data[# prop._mark_col1, ds_target] = -1;
	                        ds_data[# prop._mark_col2, ds_target] = -1;
	                        ds_data[# prop._mark_col3, ds_target] = -1;
	                        ds_data[# prop._mark_col4, ds_target] = -1;      
	                        action_col1 = ds_data[# prop._col1, ds_target];
	                        action_col2 = ds_data[# prop._col2, ds_target];
	                        action_col3 = ds_data[# prop._col3, ds_target];
	                        action_col4 = ds_data[# prop._col4, ds_target];
	                     }
                     
	                     //If markup is "shadow"
	                     if (markup == "shadow") {
	                        //Set shadow color
	                        ds_data[# prop._mark_shadow, ds_target] = make_color_hex_to_rgb(value);
	                        action_shadow = ds_data[# prop._mark_shadow, ds_target];
	                     }
                     
	                     //If markup is "end shadow"
	                     if (markup == "/shadow") {
	                        //Reset shadow color
	                        ds_data[# prop._mark_shadow, ds_target] = -4;
	                        action_shadow = ds_data[# prop._txt_shadow, ds_target];
	                     }
                     
	                     //If markup is "outline"
	                     if (markup == "outline") {
	                        //Set outline color
	                        ds_data[# prop._mark_outline, ds_target] = make_color_hex_to_rgb(value);
	                        action_outline = ds_data[# prop._mark_outline, ds_target];
	                     }
                     
	                     //If markup is "end outline"
	                     if (markup == "/outline") {
	                        //Reset outline color
	                        ds_data[# prop._mark_outline, ds_target] = -4;
	                        action_outline = ds_data[# prop._txt_outline, ds_target];
	                     }
                     
	                     //If markup is "event" or "link"
	                     if (markup == "event") or (markup == "link") {
	                        //Remove spaces between event values, if any
	                        value = string_replace_all(value, " ", "");
                        
	                        //Set event type
	                        switch (string_copy(value, 1, string_pos(",", value) - 1)) {
	                           case "ev_create": markup_event = ev_create; break;
	                           case "ev_destroy": markup_event = ev_destroy; break;
	                           case "ev_step": markup_event = ev_step; break;
	                           case "ev_alarm": markup_event = ev_alarm; break;
	                           case "ev_draw": markup_event = ev_draw; break;
	                           default: markup_event = ev_other;
	                        }
                        
	                        //Get event number
	                        value = string_delete(value, 1, string_pos(",", value));
                        
	                        //Set event number
	                        switch (value) {
	                           case "ev_step_normal": markup_type = ev_step_normal; break;
	                           case "ev_step_begin": markup_type = ev_step_begin; break;
	                           case "ev_step_end": markup_type = ev_step_end; break;
	                           case "ev_outside": markup_type = ev_outside; break;
	                           case "ev_boundary": markup_type = ev_boundary; break;
	                           case "ev_game_start": markup_type = ev_game_start; break;
	                           case "ev_game_end": markup_type = ev_game_end; break;
	                           case "ev_room_start": markup_type = ev_room_start; break;
	                           case "ev_room_end": markup_type = ev_room_end; break;
	                           case "ev_no_more_lives": markup_type = ev_no_more_lives; break;
	                           case "ev_no_more_health": markup_type = ev_no_more_health; break;
	                           case "ev_animation_end": markup_type = ev_animation_end; break;
	                           case "ev_end_of_path": markup_type = ev_end_of_path; break;
	                           case "ev_close_button": markup_type = ev_close_button; break;
	                           case "ev_user0": markup_type = ev_user0; break;
	                           case "ev_user1": markup_type = ev_user1; break;
	                           case "ev_user2": markup_type = ev_user2; break;
	                           case "ev_user3": markup_type = ev_user3; break;
	                           case "ev_user4": markup_type = ev_user4; break;
	                           case "ev_user5": markup_type = ev_user5; break;
	                           case "ev_user6": markup_type = ev_user6; break;
	                           case "ev_user7": markup_type = ev_user7; break;
	                           case "ev_user8": markup_type = ev_user8; break;
	                           case "ev_user9": markup_type = ev_user9; break;
	                           case "ev_user10": markup_type = ev_user10; break;
	                           case "ev_user11": markup_type = ev_user11; break;
	                           case "ev_user12": markup_type = ev_user12; break;
	                           case "ev_user13": markup_type = ev_user13; break;
	                           case "ev_user14": markup_type = ev_user14; break;
	                           case "ev_user15": markup_type = ev_user15; break;
	                           case "ev_draw_begin": markup_type = ev_draw_begin; break;
	                           case "ev_draw_end": markup_type = ev_draw_end; break;
	                           case "ev_draw_pre": markup_type = ev_draw_pre; break;
	                           case "ev_draw_post": markup_type = ev_draw_post; break;
	                           case "ev_gui": markup_type = ev_gui; break;
	                           case "ev_gui_begin": markup_type = ev_gui_begin; break;
	                           case "ev_gui_end": markup_type = ev_gui_end; break;
	                           default: markup_type = real(value);
	                        }
                        
	                        //Create data structure for storing link data, if none exists
	                        if (markup == "link") {
	                           if (!ds_exists(ds_data[# prop._mark_link_data, ds_target], ds_type_grid)) {
	                              ds_data[# prop._mark_link_data, ds_target] = ds_grid_create(10, 0);
	                           }
                           
	                           //Get link data structure
	                           ds_link = ds_data[# prop._mark_link_data, ds_target];
                           
	                           //Get the current number of link entries
	                           ds_xindex = ds_grid_height(ds_link);
                           
	                           //Create new link slot in data structure
	                           ds_grid_resize(ds_link, ds_grid_width(ds_link), ds_grid_height(ds_link) + 1);
               
	                           //Set link properties
	                           ds_link[# prop._x, ds_xindex] = ds_data[# prop._char_x, ds_target]; //X
	                           ds_link[# prop._y, ds_xindex] = ds_data[# prop._char_y, ds_target]; //Y
	                           ds_link[# prop._width, ds_xindex] = 0;                              //Width
	                           ds_link[# prop._height, ds_xindex] = string_height("W");            //Height
	                           ds_link[# prop._state, ds_xindex] = false;                          //Completion state
	                           ds_link[# prop._event, ds_xindex] = markup_event;                   //Event
	                           ds_link[# prop._type, ds_xindex] = markup_type;                     //Event type
	                        } else {
	                           //Otherwise execute event directly if "event" markup is used
	                           if (ds_data[# prop._index, ds_target] >= action_char_redraw) {
	                              event_perform(markup_event, markup_type);
	                           }
	                        }
	                     }
                     
	                     //If markup is "end link"
	                     if (markup == "/link") {
	                        if (ds_exists(ds_data[# prop._mark_link_data, ds_target], ds_type_grid)) {
	                           //Get link data structure
	                           ds_link = ds_data[# prop._mark_link_data, ds_target];
                        
	                           //Get the latest link entry in the data structure
	                           ds_xindex = ds_grid_height(ds_link) - 1;
               
	                           //Set horizontal link hotspot boundary, if hotspot is incomplete
	                           if (ds_link[# prop._state, ds_xindex] == false) {
	                              ds_link[# prop._width, ds_xindex] = ds_data[# prop._char_x, ds_target] - ds_link[# prop._x, ds_xindex]; //Width
                  
	                              //Mark hotspot as complete
	                              ds_link[# prop._state, ds_xindex] = true;
	                           }
	                        }
	                     }
                     
	                     //If markup is "speed"
	                     if (markup == "speed") {
	                        //If string is not being redrawn...
	                        if (ds_data[# prop._index, ds_target] >= action_char_redraw) {
	                           //Set speed multiplier
	                           if (ds_data[# prop._mark_spd, ds_target] != real(value)) {
	                              ds_data[# prop._mark_spd, ds_target] = real(value);
	                              continue;
	                           }
	                        }
	                     }
                     
	                     //If markup is "end speed"
	                     if (markup == "/speed") {  
	                        //If string is not being redrawn...
	                        if (ds_data[# prop._index, ds_target] >= action_char_redraw) {
	                           //Reset speed multiplier
	                           if (ds_data[# prop._mark_spd, ds_target] != -1) {
	                              ds_data[# prop._mark_spd, ds_target] = -1;
	                              continue;
	                           }
	                        }
	                     }
                     
	                     //If markup is "pause"
	                     if (markup == "pause") {   
	                        //If string is not being redrawn...
	                        if (ds_data[# prop._index, ds_target] > action_char_redraw) {
	                           //Set delay before continuing
	                           if (ds_data[# prop._mark_pause, ds_target] != real(value)) {
	                              ds_data[# prop._mark_pause, ds_target] = real(value);
                                 
	                              //Use indefinite delay if pause value is -1
	                              if (ds_data[# prop._mark_pause, ds_target] < 0) {
	                                 text_pause = true;
	                              }
	                              continue;
	                           }
	                        }
	                     }
	                  }
      
	                  //Continue processing after markup
	                  continue;
	               }                  
	            }
      
	            //Primary escape character
	            if (char == "\\") {
	               //Word wrap on newline
	               if (string_char_at(action_string, ds_data[# prop._index, ds_target] + 1) == "n") {
	                  //Linebreak link markup
	                  if (ds_data == ds_text) {
	                     if (ds_exists(ds_data[# prop._mark_link_data, ds_target], ds_type_grid)) {
	                        //Get link data structure
	                        ds_link = ds_data[# prop._mark_link_data, ds_target];
                        
	                        //Get the latest link entry in the data structure
	                        ds_xindex = ds_grid_height(ds_link) - 1;
               
	                        //Set horizontal link hotspot boundary, if incomplete
	                        if (ds_link[# prop._state, ds_xindex] == false) {
	                           ds_link[# prop._width, ds_xindex] = ds_data[# prop._char_x, ds_target] - ds_link[# prop._x, ds_xindex]; //Width
	                        }
	                     }
	                  }
   
	                  //Reset horizontal text position
	                  ds_data[# prop._char_x, ds_target] = sys_text_get_xoffset(ds_data, ds_target);
            
	                  //Increment vertical text position
	                  ds_data[# prop._char_y, ds_target] += action_char_height;
            
	                  //Skip next character
	                  ds_data[# prop._index, ds_target] += 1;
      
	                  //Start new link hotspot after linebreak, if link is incomplete
	                  if (ds_data == ds_text) {
	                     if (ds_exists(ds_data[# prop._mark_link_data, ds_target], ds_type_grid)) {      
	                        if (ds_link[# prop._state, ds_xindex] == false) {
	                           //Mark previous hotspot as complete
	                           ds_link[# prop._state, ds_xindex] = true;
               
	                           //Create new link slot in data structure
	                           ds_grid_resize(ds_link, ds_grid_width(ds_link), ds_grid_height(ds_link) + 1);
                        
	                           //Get the latest link entry in the data structure
	                           ds_xindex = ds_grid_height(ds_link) - 1;
            
	                           //Begin new link at new line
	                           ds_link[# prop._x, ds_xindex] = ds_data[# prop._char_x, ds_target];        //X
	                           ds_link[# prop._y, ds_xindex] = ds_data[# prop._char_y, ds_target];        //Y
	                           ds_link[# prop._width, ds_xindex] = 0;                                     //Width
	                           ds_link[# prop._height, ds_xindex] = string_height("W");                   //Height
	                           ds_link[# prop._event, ds_xindex] = ds_link[# prop._event, ds_xindex - 1]; //Event
	                           ds_link[# prop._type, ds_xindex] = ds_link[# prop._type, ds_xindex - 1];   //Event number
	                           ds_link[# prop._state, ds_xindex] = false;                                 //Completion state
	                        }
	                     }
	                  }
                  
	                  //Skip drawing newline characters
	                  continue;
	               }
	            }      
			
				//Secondary escape character
				if (char == "^") {
	               //Interpret markup literally if escaped
	               if (string_char_at(action_string, ds_data[# prop._index, ds_target] + 1) == "[") {                     
	                  //Skip drawing escape character
	                  continue;
	               }	
				}
         
	            //Draw text shadow, if any
	            if (action_shadow >= 0) {
	               draw_set_color(action_shadow);
	               draw_text(ds_data[# prop._char_x, ds_target] + (font_get_size(ds_data[# prop._txt_fnt, ds_target])*0.125), ds_data[# prop._char_y, ds_target] + (font_get_size(ds_data[# prop._txt_fnt, ds_target])*0.125), char);                  
	               draw_set_color(c_white);
	            }
         
	            //Draw text outline, if any
	            if (action_outline >= 0) {
	               draw_set_color(action_outline);
	               draw_text(ds_data[# prop._char_x, ds_target] - 1, ds_data[# prop._char_y, ds_target] - 1, char); 
	               draw_text(ds_data[# prop._char_x, ds_target] + 1, ds_data[# prop._char_y, ds_target] - 1, char); 
	               draw_text(ds_data[# prop._char_x, ds_target] - 1, ds_data[# prop._char_y, ds_target] + 1, char); 
	               draw_text(ds_data[# prop._char_x, ds_target] + 1, ds_data[# prop._char_y, ds_target] + 1, char); 
	               draw_set_color(c_white);
	            }
      
	            //Draw text
	            draw_text_color(ds_data[# prop._char_x, ds_target], ds_data[# prop._char_y, ds_target], char, action_col1, action_col2, action_col3, action_col4, 1);
          
	            //Increment horizontal text position
	            ds_data[# prop._char_x, ds_target] += string_width(char);
			
	            //Play speech synthesis, if any
	            if (ds_data == ds_text) {
				   if (ds_data[# prop._index, ds_target] > action_char_redraw) {
	                  //Skip vox on space
	                  if (char != " ") {
	                     //Play vox, if any
	                     if (audio_exists(vox)) {
	                        vox = audio_play_sound(vox, 0, false);
                  
	                        //Set vox pitch
	                        audio_sound_pitch(vox, pitch);
                     
	                        //Set vox volume
	                        audio_sound_gain(vox, (vol*vol_fade)*global.vg_vol_vox, 0);
					 
						    //End vox for the current frame
						    vox = -1;
	                     }
                     
	                     //Play fade vox, if any
	                     if (audio_exists(vox_fade)) {
	                        vox_fade = audio_play_sound(vox_fade, 0, false);
                     
	                        //Set fade vox pitch
	                        audio_sound_pitch(vox_fade, pitch);
                     
	                        //Set fade vox volume
	                        audio_sound_gain(vox_fade, (vol*(1 - vol_fade))*global.vg_vol_vox, 0);
					 
					        //End fade vox for the current frame
					        vox_fade = -1;
	                     }
	                  }
			       }
				}
	         }    
         
         
	         /* 
	         FINALIZATION 
	         */
             
	         //Play speech synthesis, if any
	         if (ds_data == ds_text) {
	            //When text typewriter effect is complete...
	            if (ds_data[# prop._index, ds_target] >= action_char_count) {
	               //End unclosed links, if any
	               if (ds_exists(ds_data[# prop._mark_link_data, ds_target], ds_type_grid)) {
	                  //Get link data structure
	                  ds_link = ds_data[# prop._mark_link_data, ds_target];
                        
	                  //Get the latest link entry in the data structure
	                  ds_xindex = ds_grid_height(ds_link) - 1;
               
	                  //Set horizontal link hotspot boundary, if hotspot is incomplete
	                  if (ds_link[# prop._state, ds_xindex] == false) {
	                     ds_link[# prop._width, ds_xindex] = ds_data[# prop._char_x, ds_target] - ds_link[# prop._x, ds_xindex]; //Width
                  
	                     //Mark hotspot as complete
	                     ds_link[# prop._state, ds_xindex] = true;
	                  }
	               }
               
	               //Disable character speech animations
	               sys_anim_speech(ds_data[# prop._name, ds_target], false, vngen_type_text);          
	            }            
	         }  

	         //Reset drawing font
	         draw_set_font(fnt_default);

	         //End drawing to surface
	         surface_reset_target();
	      }          
	   }
	}


}
