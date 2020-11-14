/// @function	sys_layer_draw_log_button();
/// @author		Lucas Chasteen <lucas.chasteen@xgasoft.com>
/// @copyright	XGASOFT 2020, All Rights Reserved
function sys_layer_draw_log_button() {

	/*
	==========================================================================
	SYSTEM FUNCTION: MODIFY AT YOUR OWN RISK!
	--------------------------------------------------------------------------
	  System functions are executed automatically by the engine and typically
	  should not be run manually by the user
	==========================================================================

	Draws log buttons.

	No parameters
            
	Example usage:
	   sys_layer_draw_log_button();
	*/

	/*
	INITIALIZATION
	*/

	//Skip if log is hidden
	if (global.vg_log_alpha <= 0) {
	   exit;
	}


	/*
	BUTTONS
	*/

	var ds_yindex;
	for (ds_yindex = 0; ds_yindex < ds_grid_height(global.ds_log_button); ds_yindex += 1) {
	   //If button exists...
	   if (global.ds_log_button[# prop._id, ds_yindex] != -1) {
      
	      /* BASE PROPERTIES */
         
	      //Get base button properties
	      var action_id = global.ds_log_button[# prop._id, ds_yindex];
	      var action_sprite = global.ds_log_button[# prop._sprite, ds_yindex];
	      var action_left = global.ds_log_button[# prop._left, ds_yindex] + global.ds_log_button[# prop._trans_left, ds_yindex];
	      var action_top = global.ds_log_button[# prop._top, ds_yindex] + global.ds_log_button[# prop._trans_top, ds_yindex];      
	      var action_width = global.ds_log_button[# prop._width, ds_yindex] + global.ds_log_button[# prop._trans_width, ds_yindex];
	      var action_height = global.ds_log_button[# prop._height, ds_yindex] + global.ds_log_button[# prop._trans_height, ds_yindex];
	      var action_width_init = global.ds_log_button[# prop._init_width, ds_yindex];
	      var action_height_init = global.ds_log_button[# prop._init_height, ds_yindex];
	      var action_xorig = global.ds_log_button[# prop._xorig, ds_yindex];
	      var action_yorig = global.ds_log_button[# prop._yorig, ds_yindex];
	      var action_x = global.ds_log_button[# prop._x, ds_yindex] + global.ds_log_button[# prop._trans_x, ds_yindex];
	      var action_y = global.ds_log_button[# prop._y, ds_yindex] + global.ds_log_button[# prop._trans_y, ds_yindex];
	      var action_xscale = global.ds_log_button[# prop._xscale, ds_yindex]*global.ds_log_button[# prop._trans_xscale, ds_yindex];
	      var action_yscale = global.ds_log_button[# prop._yscale, ds_yindex]*global.ds_log_button[# prop._trans_yscale, ds_yindex];
	      var action_rot = global.ds_log_button[# prop._rot, ds_yindex] + global.ds_log_button[# prop._trans_rot, ds_yindex];
	      var action_string = global.ds_log_button[# prop._txt, ds_yindex];
	      var action_text_x = global.ds_log_button[# prop._txt_x, ds_yindex];
	      var action_text_y = global.ds_log_button[# prop._txt_y, ds_yindex];
	      var action_fnt = global.ds_log_button[# prop._txt_fnt, ds_yindex];
	      var action_col1 = global.ds_log_button[# prop._col1, ds_yindex];
	      var action_col2 = global.ds_log_button[# prop._anim_tmp_col1, ds_yindex];
	      var action_col3 = global.ds_log_button[# prop._anim_col1, ds_yindex];
	      var action_col = action_col1;
	      var action_alpha = global.ds_log_button[# prop._alpha, ds_yindex]*global.ds_log_button[# prop._trans_alpha, ds_yindex];
	      var action_snd_hover = global.ds_log_button[# prop._snd_hover, ds_yindex];
	      var action_snd_select = global.ds_log_button[# prop._snd_select, ds_yindex];
	      var action_redraw = false;
	  
		  /* SPRITE PROPERTIES */
	  
		  //Get sprite index
		  var action_index = global.ds_log_button[# prop._img_index, ds_yindex];
	  
		  //Animate sprite
		  global.ds_log_button[# prop._img_index, ds_yindex] += sprite_get_speed_real(action_sprite)*time_offset;
	  
		  //Loop sprite
		  if (global.ds_log_button[# prop._img_index, ds_yindex] > global.ds_log_button[# prop._img_num, ds_yindex]) {
	         global.ds_log_button[# prop._img_index, ds_yindex] -= global.ds_log_button[# prop._img_num, ds_yindex];
		  }

	      //Get scale offset
	      var action_offset_xscale = global.ds_log_button[# prop._oxscale, ds_yindex];
	      var action_offset_yscale = global.ds_log_button[# prop._oyscale, ds_yindex]; 
            
	      //Get final scale
	      action_xscale = (action_xscale*action_offset_xscale);
	      action_yscale = (action_yscale*action_offset_yscale);
      
	      //Get final rotation
	      point_rot_prefetch(action_rot);     
      
	      //Get scaled sprite origin
	      action_xorig = action_xorig*action_xscale;
	      action_yorig = action_yorig*action_yscale;   
      
	      //Get final position
	      action_x = (gui_width*(action_x/action_width_init)) - point_rot_x(action_xorig, action_yorig);
	      action_y = (gui_height*(action_y/action_height_init)) - point_rot_y(action_xorig, action_yorig);
      
	      //Record final properties
	      global.ds_log_button[# prop._final_width, ds_yindex] = action_width;
	      global.ds_log_button[# prop._final_height, ds_yindex] = action_height;
	      global.ds_log_button[# prop._final_x, ds_yindex] = action_x + point_rot_x(action_left*action_xscale, action_top*action_yscale);
	      global.ds_log_button[# prop._final_y, ds_yindex] = action_y + point_rot_y(action_left*action_xscale, action_top*action_yscale);
	      global.ds_log_button[# prop._final_xscale, ds_yindex] = action_xscale;
	      global.ds_log_button[# prop._final_yscale, ds_yindex] = action_yscale;
	      global.ds_log_button[# prop._final_rot, ds_yindex] = action_rot;
      
	      //Get scaled dimensions
	      action_x = global.ds_log_button[# prop._final_x, ds_yindex];
	      action_y = global.ds_log_button[# prop._final_y, ds_yindex];
      
	      /* MOUSE INPUT */
      
	      //If button is not rotated...
	      if (action_rot == 0) {
		     //Get bounding box position and dimensions
			 var bbox_x = sprite_get_bbox_left(action_sprite)*action_xscale;
			 var bbox_y = sprite_get_bbox_top(action_sprite)*action_yscale;
			 var bbox_width = (sprite_get_bbox_right(action_sprite) - sprite_get_bbox_left(action_sprite))*action_xscale;
			 var bbox_height = (sprite_get_bbox_bottom(action_sprite) - sprite_get_bbox_top(action_sprite))*action_yscale;
			
	         //Get mouse position
	         if (mouse_check_region_gui(action_x + bbox_x, action_y + bbox_y, bbox_width, bbox_height)) {
	            //If no selection exists...
	            if (button_active == -1) {    
	               //If the mouse has moved...
	               if (device_mouse_x_to_gui(0) != mouse_xprevious) or (device_mouse_y_to_gui(0) != mouse_yprevious) {                    
	                  //Enable button hover state
	                  if (button_hover != action_id) {
	                     button_hover = action_id;
                           
	                     //Play hover sound, if any
	                     if (audio_exists(action_snd_hover)) {
	                        audio_play_sound(action_snd_hover, 0, false);
	                     }
	                  }
	               }
                     
	               //Select button if mouse is clicked
	               if (device_mouse_check_button_pressed(0, mb_left)) {
	                  if (button_hover == action_id) {
	                     button_active = action_id;
	                  }
	               }
	            }
            
	            //Enable mouse hover state
	            if (button_hover == action_id) {
	               mouse_hover = true;
	            }                  
            
	            //Execute button event if mouse is released
	            if (device_mouse_check_button_released(0, mb_left)) {
	               if (button_active == action_id) {
	                  //Record button ID
	                  button_result = action_id;
                  
	                  //Play select sound, if any
	                  if (audio_exists(action_snd_select)) {
	                     audio_play_sound(action_snd_select, 0, false);
	                  }
                  
	                  //Reset button state
	                  button_active = -1;
	               }
	            }               
	         } else {
	            //If the mouse has moved...
	            if (device_mouse_x_to_gui(0) != mouse_xprevious) or (device_mouse_y_to_gui(0) != mouse_yprevious) {
	               //Unhover button if mouse leaves region
	               if (button_active != action_id) {
	                  if (button_hover == action_id) {
	                     button_hover = -1;
	                  }
	               }
	            }
	         }
	      }
            
	      //Unselect button if mouse button is released
	      if (device_mouse_check_button_released(0, mb_left)) {
	         if (button_active == action_id) {
	            button_hover = -1;
	            button_active = -1;
	         }
	      }
      
	      /* STATES */
      
	      //If button is hovered...
	      if (button_active != action_id) {
	         if (button_hover == action_id) {
	            //Set hover sprite
	            action_sprite = global.ds_log_button[# prop._sprite2, ds_yindex];
            
	            //Perform hover in animation
	            if (global.ds_log_button[# prop._trigger, ds_yindex] != 1) {
				   //Update sprite properties
				   if (sprite_exists(action_sprite)) {
					   global.ds_log_button[# prop._img_index, ds_yindex] = 0;
					   global.ds_log_button[# prop._img_num, ds_yindex] = sprite_get_number(action_sprite);
					   action_index = 0;
				   }
			   
	               //Update animation temp values
	               global.ds_log_button[# prop._tmp_x, ds_yindex] = global.ds_log_button[# prop._x, ds_yindex];
	               global.ds_log_button[# prop._tmp_y, ds_yindex] = global.ds_log_button[# prop._y, ds_yindex];
	               global.ds_log_button[# prop._tmp_xscale, ds_yindex] = global.ds_log_button[# prop._xscale, ds_yindex];
	               global.ds_log_button[# prop._tmp_yscale, ds_yindex] = global.ds_log_button[# prop._yscale, ds_yindex];
               
	               //Reset animation time
	               global.ds_log_button[# prop._anim_time, ds_yindex] = 0;
               
	               //Begin hover animation
	               global.ds_log_button[# prop._trigger, ds_yindex] = 1;
	            }
            
	            //Count up animation time
	            if (global.ds_log_button[# prop._anim_time, ds_yindex] < global.ds_log_button[# prop._anim_dur, ds_yindex]) {
	               global.ds_log_button[# prop._anim_time, ds_yindex] += time_frame;
	            }
            
	            //Get current animation time
	            var action_anim_time = interp(0, 1, global.ds_log_button[# prop._anim_time, ds_yindex]/global.ds_log_button[# prop._anim_dur, ds_yindex], global.ds_log_button[# prop._anim_ease, ds_yindex]);
            
	            //Perform hover animation
	            global.ds_log_button[# prop._x, ds_yindex] = lerp(global.ds_log_button[# prop._tmp_x, ds_yindex], global.ds_log_button[# prop._anim_tmp_x, ds_yindex], action_anim_time);                //X
	            global.ds_log_button[# prop._y, ds_yindex] = lerp(global.ds_log_button[# prop._tmp_y, ds_yindex], global.ds_log_button[# prop._anim_tmp_y, ds_yindex], action_anim_time);                //Y
	            global.ds_log_button[# prop._xscale, ds_yindex] = lerp(global.ds_log_button[# prop._tmp_xscale, ds_yindex], global.ds_log_button[# prop._anim_tmp_xscale, ds_yindex], action_anim_time); //X scale
	            global.ds_log_button[# prop._yscale, ds_yindex] = lerp(global.ds_log_button[# prop._tmp_yscale, ds_yindex], global.ds_log_button[# prop._anim_tmp_yscale, ds_yindex], action_anim_time); //Y scale       
	         } else {
	            //Perform hover out animation
	            if (global.ds_log_button[# prop._trigger, ds_yindex] != 0) {
				   //Update sprite properties
				   if (sprite_exists(action_sprite)) {
					   global.ds_log_button[# prop._img_index, ds_yindex] = 0;
					   global.ds_log_button[# prop._img_num, ds_yindex] = sprite_get_number(action_sprite);
					   action_index = 0;
				   }
			   
	               //Update animation temp values
	               global.ds_log_button[# prop._tmp_x, ds_yindex] = global.ds_log_button[# prop._x, ds_yindex];
	               global.ds_log_button[# prop._tmp_y, ds_yindex] = global.ds_log_button[# prop._y, ds_yindex];
	               global.ds_log_button[# prop._tmp_xscale, ds_yindex] = global.ds_log_button[# prop._xscale, ds_yindex];
	               global.ds_log_button[# prop._tmp_yscale, ds_yindex] = global.ds_log_button[# prop._yscale, ds_yindex];
               
	               //Reset animation time
	               global.ds_log_button[# prop._anim_time, ds_yindex] = 0;
               
	               //Begin hover animation
	               global.ds_log_button[# prop._trigger, ds_yindex] = 0;
	            }   
            
	            //Count up animation time
	            if (global.ds_log_button[# prop._anim_time, ds_yindex] < global.ds_log_button[# prop._anim_dur, ds_yindex]) {
	               global.ds_log_button[# prop._anim_time, ds_yindex] += time_frame;
	            }
            
	            //Get current animation time
	            var action_anim_time = interp(0, 1, global.ds_log_button[# prop._anim_time, ds_yindex]/global.ds_log_button[# prop._anim_dur, ds_yindex], global.ds_log_button[# prop._anim_ease, ds_yindex]);
            
	            //Perform hover animation
	            global.ds_log_button[# prop._x, ds_yindex] = lerp(global.ds_log_button[# prop._tmp_x, ds_yindex], global.ds_log_button[# prop._init_x, ds_yindex], action_anim_time);                //X
	            global.ds_log_button[# prop._y, ds_yindex] = lerp(global.ds_log_button[# prop._tmp_y, ds_yindex], global.ds_log_button[# prop._init_y, ds_yindex], action_anim_time);                //Y
	            global.ds_log_button[# prop._xscale, ds_yindex] = lerp(global.ds_log_button[# prop._tmp_xscale, ds_yindex], global.ds_log_button[# prop._init_xscale, ds_yindex], action_anim_time); //X scale
	            global.ds_log_button[# prop._yscale, ds_yindex] = lerp(global.ds_log_button[# prop._tmp_yscale, ds_yindex], global.ds_log_button[# prop._init_yscale, ds_yindex], action_anim_time); //Y scale
	         }
      
	      //If button is selected...
	      } else {
	         //Set select sprite
	         action_sprite = global.ds_log_button[# prop._sprite3, ds_yindex];
         
	         //Perform select animation
	         if (global.ds_log_button[# prop._trigger, ds_yindex] != 2) {
				//Update sprite properties
				if (sprite_exists(action_sprite)) {
					global.ds_log_button[# prop._img_index, ds_yindex] = 0;
					global.ds_log_button[# prop._img_num, ds_yindex] = sprite_get_number(action_sprite);
					action_index = 0;
				}
			   
	            //Update animation temp values
	            global.ds_log_button[# prop._tmp_x, ds_yindex] = global.ds_log_button[# prop._x, ds_yindex];
	            global.ds_log_button[# prop._tmp_y, ds_yindex] = global.ds_log_button[# prop._y, ds_yindex];
	            global.ds_log_button[# prop._tmp_xscale, ds_yindex] = global.ds_log_button[# prop._xscale, ds_yindex];
	            global.ds_log_button[# prop._tmp_yscale, ds_yindex] = global.ds_log_button[# prop._yscale, ds_yindex];
            
	            //Reset animation time
	            global.ds_log_button[# prop._anim_time, ds_yindex] = 0;
            
	            //Begin hover animation
	            global.ds_log_button[# prop._trigger, ds_yindex] = 2;
	         }
         
	         //Count up animation time
	         if (global.ds_log_button[# prop._anim_time, ds_yindex] < global.ds_log_button[# prop._anim_dur, ds_yindex]) {
	            global.ds_log_button[# prop._anim_time, ds_yindex] += time_frame;
	         }
         
	         //Get current animation time
	         var action_anim_time = interp(0, 1, global.ds_log_button[# prop._anim_time, ds_yindex]/global.ds_log_button[# prop._anim_dur, ds_yindex], global.ds_log_button[# prop._anim_ease, ds_yindex]);
         
	         //Perform select animation
	         global.ds_log_button[# prop._x, ds_yindex] = lerp(global.ds_log_button[# prop._tmp_x, ds_yindex], global.ds_log_button[# prop._anim_x, ds_yindex], action_anim_time);                //X
	         global.ds_log_button[# prop._y, ds_yindex] = lerp(global.ds_log_button[# prop._tmp_y, ds_yindex], global.ds_log_button[# prop._anim_y, ds_yindex], action_anim_time);                //Y
	         global.ds_log_button[# prop._xscale, ds_yindex] = lerp(global.ds_log_button[# prop._tmp_xscale, ds_yindex], global.ds_log_button[# prop._anim_xscale, ds_yindex], action_anim_time); //X scale
	         global.ds_log_button[# prop._yscale, ds_yindex] = lerp(global.ds_log_button[# prop._tmp_yscale, ds_yindex], global.ds_log_button[# prop._anim_yscale, ds_yindex], action_anim_time); //Y scale
         
	         //Deselect button when animation is complete, if not selected by mouse
	         if (global.ds_log_button[# prop._anim_time, ds_yindex] >= global.ds_log_button[# prop._anim_dur, ds_yindex]) {
	            if (!device_mouse_check_button(0, mb_left)) {
	               button_active = -1;
	            }
	         }
	      }
      
	      /* SURFACE */
      
	      //Recreate button text surface, if broken
	      if (!surface_exists(global.ds_log_button[# prop._surf, ds_yindex])) {
	         global.ds_log_button[# prop._surf, ds_yindex] = surface_create(sprite_get_width(global.ds_log_button[# prop._sprite, ds_yindex]), sprite_get_height(global.ds_log_button[# prop._sprite, ds_yindex]));
	         action_redraw = true;
	      }
      
	      //Get button text surface
	      var action_surf = global.ds_log_button[# prop._surf, ds_yindex];
      
	      //Draw surface contents
	      if (action_redraw == true) {
	         surface_set_target(action_surf);
	         draw_clear_alpha(c_black, 0);
	         draw_set_alpha(1);
	         draw_set_font(action_fnt);
	         draw_text(action_text_x, action_text_y, action_string);
	         draw_text(action_text_x, action_text_y, action_string);
	         draw_set_font(fnt_default);
	         draw_set_alpha(global.vg_log_alpha);
	         surface_reset_target();
	      }
      
	      /* DRAWING */

	      //Draw button background
	      if (sprite_exists(action_sprite)) {
	         draw_sprite_general(action_sprite, action_index, action_left, action_top, action_width, action_height, action_x, action_y, action_xscale, action_yscale, action_rot, c_white, c_white, c_white, c_white, action_alpha*global.vg_log_alpha);
	      }
   
	      //Get button text color
	      if (button_hover == action_id) {
	         action_col = action_col2; //Hover
	      }
	      if (button_active == action_id) {
	         action_col = action_col3; //Select
	      }
      
	      //Draw button text
	      draw_surface_general(action_surf, action_left, action_top, action_width, action_height, action_x, action_y, action_xscale, action_yscale, action_rot, action_col, action_col, action_col, action_col, action_alpha*global.vg_log_alpha);
	   }   
	}


}
