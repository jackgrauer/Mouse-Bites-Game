/// @function	sys_layer_draw_button();
/// @author		Lucas Chasteen <lucas.chasteen@xgasoft.com>
/// @copyright	XGASOFT 2020, All Rights Reserved
function sys_layer_draw_button() {

	/*
	==========================================================================
	SYSTEM FUNCTION: MODIFY AT YOUR OWN RISK!
	--------------------------------------------------------------------------
	  System functions are executed automatically by the engine and typically
	  should not be run manually by the user
	==========================================================================

	Draws buttons.

	No parameters
            
	Example usage:
	   sys_layer_draw_button();
	*/

	/*
	BUTTONS
	*/

	//Skip processing if vngen_object_clear has been run
	if (event_current < 0) {
	   exit;
	}

	//Draw buttons
	var ds_yindex;
	for (ds_yindex = 0; ds_yindex < ds_grid_height(ds_button); ds_yindex += 1) {
	   //If button exists...
	   if (ds_button[# prop._id, ds_yindex] != -1) {
      
	      /* BASE PROPERTIES */
         
	      //Get base button properties
	      var action_id = ds_button[# prop._id, ds_yindex];
	      var action_sprite = ds_button[# prop._sprite, ds_yindex];
	      var action_left = ds_button[# prop._left, ds_yindex] + ds_button[# prop._trans_left, ds_yindex];
	      var action_top = ds_button[# prop._top, ds_yindex] + ds_button[# prop._trans_top, ds_yindex];      
	      var action_width = ds_button[# prop._width, ds_yindex] + ds_button[# prop._trans_width, ds_yindex];
	      var action_height = ds_button[# prop._height, ds_yindex] + ds_button[# prop._trans_height, ds_yindex];
	      var action_xorig = ds_button[# prop._xorig, ds_yindex];
	      var action_yorig = ds_button[# prop._yorig, ds_yindex];
	      var action_x = ds_button[# prop._x, ds_yindex] + ds_button[# prop._trans_x, ds_yindex];
	      var action_y = ds_button[# prop._y, ds_yindex] + ds_button[# prop._trans_y, ds_yindex];
	      var action_xscale = ds_button[# prop._xscale, ds_yindex]*ds_button[# prop._trans_xscale, ds_yindex];
	      var action_yscale = ds_button[# prop._yscale, ds_yindex]*ds_button[# prop._trans_yscale, ds_yindex];
	      var action_rot = ds_button[# prop._rot, ds_yindex] + ds_button[# prop._trans_rot, ds_yindex];
	      var action_string = ds_button[# prop._txt, ds_yindex];
	      var action_text_x = ds_button[# prop._txt_x, ds_yindex];
	      var action_text_y = ds_button[# prop._txt_y, ds_yindex];
	      var action_fnt = ds_button[# prop._txt_fnt, ds_yindex];
	      var action_col1 = ds_button[# prop._col1, ds_yindex];
	      var action_col2 = ds_button[# prop._anim_tmp_col1, ds_yindex];
	      var action_col3 = ds_button[# prop._anim_col1, ds_yindex];
	      var action_col = action_col1;
	      var action_alpha = ds_button[# prop._alpha, ds_yindex]*ds_button[# prop._trans_alpha, ds_yindex];
	      var action_index = ds_button[# prop._img_index, ds_yindex];
	      var action_snd_hover = ds_button[# prop._snd_hover, ds_yindex];
	      var action_snd_select = ds_button[# prop._snd_select, ds_yindex];
	      var action_redraw = false;
	  
		  /* SPRITE PROPERTIES */
	  
		  //Get sprite index
		  var action_index = ds_button[# prop._img_index, ds_yindex];
	  
		  //Animate sprite
		  ds_button[# prop._img_index, ds_yindex] += sprite_get_speed_real(action_sprite)*time_offset;
	  
		  //Loop sprite
		  if (ds_button[# prop._img_index, ds_yindex] > ds_button[# prop._img_num, ds_yindex]) {
	         ds_button[# prop._img_index, ds_yindex] -= ds_button[# prop._img_num, ds_yindex];
		  }

	      //Get scale offset
	      var action_offset_xscale = ds_button[# prop._oxscale, ds_yindex];
	      var action_offset_yscale = ds_button[# prop._oyscale, ds_yindex]; 
            
	      //Get final scale
	      action_xscale = (action_xscale*action_offset_xscale);
	      action_yscale = (action_yscale*action_offset_yscale);
      
	      //Get final rotation
	      point_rot_prefetch(action_rot);     
      
	      //Get scaled sprite origin
	      action_xorig = action_xorig*action_xscale;
	      action_yorig = action_yorig*action_yscale;   
      
	      //Get final position
	      action_x = room_xoffset - point_rot_x(action_xorig, action_yorig) + action_x;
	      action_y = room_yoffset - point_rot_y(action_xorig, action_yorig) + action_y;
      
	      //Record final properties
	      ds_button[# prop._final_width, ds_yindex] = action_width;
	      ds_button[# prop._final_height, ds_yindex] = action_height;
	      ds_button[# prop._final_x, ds_yindex] = action_x + point_rot_x(action_left*action_xscale, action_top*action_yscale);
	      ds_button[# prop._final_y, ds_yindex] = action_y + point_rot_y(action_left*action_xscale, action_top*action_yscale);
	      ds_button[# prop._final_xscale, ds_yindex] = action_xscale;
	      ds_button[# prop._final_yscale, ds_yindex] = action_yscale;
	      ds_button[# prop._final_rot, ds_yindex] = action_rot;
      
	      //Get scaled dimensions
	      action_x = ds_button[# prop._final_x, ds_yindex];
	      action_y = ds_button[# prop._final_y, ds_yindex];
      
	      /* MOUSE INPUT */
      
	      //If engine is unpaused...
	      if (global.vg_log_visible == false) and (global.vg_ui_visible == true) and (option_hover == -1) {
	         if (action_rot == 0) {
				//Get bounding box position and dimensions
				var bbox_x = sprite_get_bbox_left(action_sprite)*action_xscale;
				var bbox_y = sprite_get_bbox_top(action_sprite)*action_yscale;
				var bbox_width = (sprite_get_bbox_right(action_sprite) - sprite_get_bbox_left(action_sprite))*action_xscale;
				var bbox_height = (sprite_get_bbox_bottom(action_sprite) - sprite_get_bbox_top(action_sprite))*action_yscale;
			
	            //Get mouse position
	            if (mouse_check_region(action_x + bbox_x, action_y + bbox_y, bbox_width, bbox_height)) {
	               //If no selection exists...
	               if (button_active == -1) {    
	                  //If the mouse has moved...
	                  if (mouse_x != mouse_xprevious) or (mouse_y != mouse_yprevious) {                    
	                     //Enable button hover state
	                     if (button_hover != action_id) {
	                        button_hover = action_id;
                              
	                        //Play hover sound, if any
	                        if (audio_exists(action_snd_hover)) {
	                           var snd = audio_play_sound(action_snd_hover, 0, false);
							   audio_sound_gain(snd, global.vg_vol_ui, 0);
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
	                        var snd = audio_play_sound(action_snd_select, 0, false);
							audio_sound_gain(snd, global.vg_vol_ui, 0);
	                     }
                     
	                     //Reset button state
	                     button_active = -1;
	                  }
	               }               
	            } else {
	               //If the mouse has moved...
	               if (mouse_x != mouse_xprevious) or (mouse_y != mouse_yprevious) {
	                  //Unhover button if mouse leaves region
	                  if (button_active != action_id) {
	                     if (button_hover == action_id) {
	                        button_hover = -1;
	                     }
	                  }
	               }
	            }
	         }
	      } else {
	         //Unhover button if hidden or option is hovered over same area
	         button_hover = -1;
	         button_active = -1;
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
	            action_sprite = ds_button[# prop._sprite2, ds_yindex];
            
	            //Perform hover in animation
	            if (ds_button[# prop._trigger, ds_yindex] != 1) {
				   //Update sprite properties
				   if (sprite_exists(action_sprite)) {
					   ds_button[# prop._img_index, ds_yindex] = 0;
					   ds_button[# prop._img_num, ds_yindex] = sprite_get_number(action_sprite);
					   action_index = 0;
				   }
			   
	               //Update animation temp values
	               ds_button[# prop._tmp_x, ds_yindex] = ds_button[# prop._x, ds_yindex];
	               ds_button[# prop._tmp_y, ds_yindex] = ds_button[# prop._y, ds_yindex];
	               ds_button[# prop._tmp_xscale, ds_yindex] = ds_button[# prop._xscale, ds_yindex];
	               ds_button[# prop._tmp_yscale, ds_yindex] = ds_button[# prop._yscale, ds_yindex];
               
	               //Reset animation time
	               ds_button[# prop._anim_time, ds_yindex] = 0;
               
	               //Begin hover animation
	               ds_button[# prop._trigger, ds_yindex] = 1;
	            }
            
	            //Count up animation time
	            if (ds_button[# prop._anim_time, ds_yindex] < ds_button[# prop._anim_dur, ds_yindex]) {
	               ds_button[# prop._anim_time, ds_yindex] += time_frame;
	            }
            
	            //Get current animation time
	            var action_anim_time = interp(0, 1, ds_button[# prop._anim_time, ds_yindex]/ds_button[# prop._anim_dur, ds_yindex], ds_button[# prop._anim_ease, ds_yindex]);
            
	            //Perform hover animation
	            ds_button[# prop._x, ds_yindex] = lerp(ds_button[# prop._tmp_x, ds_yindex], ds_button[# prop._anim_tmp_x, ds_yindex], action_anim_time);                //X
	            ds_button[# prop._y, ds_yindex] = lerp(ds_button[# prop._tmp_y, ds_yindex], ds_button[# prop._anim_tmp_y, ds_yindex], action_anim_time);                //Y
	            ds_button[# prop._xscale, ds_yindex] = lerp(ds_button[# prop._tmp_xscale, ds_yindex], ds_button[# prop._anim_tmp_xscale, ds_yindex], action_anim_time); //X scale
	            ds_button[# prop._yscale, ds_yindex] = lerp(ds_button[# prop._tmp_yscale, ds_yindex], ds_button[# prop._anim_tmp_yscale, ds_yindex], action_anim_time); //Y scale       
	         } else {
	            //Perform hover out animation
	            if (ds_button[# prop._trigger, ds_yindex] != 0) {
				   //Update sprite properties
				   if (sprite_exists(action_sprite)) {
					   ds_button[# prop._img_index, ds_yindex] = 0;
					   ds_button[# prop._img_num, ds_yindex] = sprite_get_number(action_sprite);
					   action_index = 0;
				   }
			   
	               //Update animation temp values
	               ds_button[# prop._tmp_x, ds_yindex] = ds_button[# prop._x, ds_yindex];
	               ds_button[# prop._tmp_y, ds_yindex] = ds_button[# prop._y, ds_yindex];
	               ds_button[# prop._tmp_xscale, ds_yindex] = ds_button[# prop._xscale, ds_yindex];
	               ds_button[# prop._tmp_yscale, ds_yindex] = ds_button[# prop._yscale, ds_yindex];
               
	               //Reset animation time
	               ds_button[# prop._anim_time, ds_yindex] = 0;
               
	               //Begin hover animation
	               ds_button[# prop._trigger, ds_yindex] = 0;
	            }   
            
	            //Count up animation time
	            if (ds_button[# prop._anim_time, ds_yindex] < ds_button[# prop._anim_dur, ds_yindex]) {
	               ds_button[# prop._anim_time, ds_yindex] += time_frame;
	            }
            
	            //Get current animation time
	            var action_anim_time = interp(0, 1, ds_button[# prop._anim_time, ds_yindex]/ds_button[# prop._anim_dur, ds_yindex], ds_button[# prop._anim_ease, ds_yindex]);
            
	            //Perform hover animation
	            ds_button[# prop._x, ds_yindex] = lerp(ds_button[# prop._tmp_x, ds_yindex], ds_button[# prop._init_x, ds_yindex], action_anim_time);                //X
	            ds_button[# prop._y, ds_yindex] = lerp(ds_button[# prop._tmp_y, ds_yindex], ds_button[# prop._init_y, ds_yindex], action_anim_time);                //Y
	            ds_button[# prop._xscale, ds_yindex] = lerp(ds_button[# prop._tmp_xscale, ds_yindex], ds_button[# prop._init_xscale, ds_yindex], action_anim_time); //X scale
	            ds_button[# prop._yscale, ds_yindex] = lerp(ds_button[# prop._tmp_yscale, ds_yindex], ds_button[# prop._init_yscale, ds_yindex], action_anim_time); //Y scale
	         }
      
	      //If button is selected...
	      } else {
	         //Set select sprite
	         action_sprite = ds_button[# prop._sprite3, ds_yindex];
         
	         //Perform select animation
	         if (ds_button[# prop._trigger, ds_yindex] != 2) {
				//Update sprite 
				if (sprite_exists(action_sprite)) {
					ds_button[# prop._img_index, ds_yindex] = 0;
					ds_button[# prop._img_num, ds_yindex] = sprite_get_number(action_sprite);
					action_index = 0;
				}
			   
	            //Update animation temp values
	            ds_button[# prop._tmp_x, ds_yindex] = ds_button[# prop._x, ds_yindex];
	            ds_button[# prop._tmp_y, ds_yindex] = ds_button[# prop._y, ds_yindex];
	            ds_button[# prop._tmp_xscale, ds_yindex] = ds_button[# prop._xscale, ds_yindex];
	            ds_button[# prop._tmp_yscale, ds_yindex] = ds_button[# prop._yscale, ds_yindex];
            
	            //Reset animation time
	            ds_button[# prop._anim_time, ds_yindex] = 0;
            
	            //Begin hover animation
	            ds_button[# prop._trigger, ds_yindex] = 2;
	         }
         
	         //Count up animation time
	         if (ds_button[# prop._anim_time, ds_yindex] < ds_button[# prop._anim_dur, ds_yindex]) {
	            ds_button[# prop._anim_time, ds_yindex] += time_frame;
	         }
         
	         //Get current animation time
	         var action_anim_time = interp(0, 1, ds_button[# prop._anim_time, ds_yindex]/ds_button[# prop._anim_dur, ds_yindex], ds_button[# prop._anim_ease, ds_yindex]);
         
	         //Perform select animation
	         ds_button[# prop._x, ds_yindex] = lerp(ds_button[# prop._tmp_x, ds_yindex], ds_button[# prop._anim_x, ds_yindex], action_anim_time);                //X
	         ds_button[# prop._y, ds_yindex] = lerp(ds_button[# prop._tmp_y, ds_yindex], ds_button[# prop._anim_y, ds_yindex], action_anim_time);                //Y
	         ds_button[# prop._xscale, ds_yindex] = lerp(ds_button[# prop._tmp_xscale, ds_yindex], ds_button[# prop._anim_xscale, ds_yindex], action_anim_time); //X scale
	         ds_button[# prop._yscale, ds_yindex] = lerp(ds_button[# prop._tmp_yscale, ds_yindex], ds_button[# prop._anim_yscale, ds_yindex], action_anim_time); //Y scale
         
	         //Deselect button when animation is complete, if not selected by mouse
	         if (ds_button[# prop._anim_time, ds_yindex] >= ds_button[# prop._anim_dur, ds_yindex]) {
	            if (!device_mouse_check_button(0, mb_left)) {
	               button_active = -1;
	            }
	         }
	      }
      
	      /* SURFACE */
      
	      //Recreate button text surface, if broken
	      if (!surface_exists(ds_button[# prop._surf, ds_yindex])) {
	         ds_button[# prop._surf, ds_yindex] = surface_create(sprite_get_width(ds_button[# prop._sprite, ds_yindex]), sprite_get_height(ds_button[# prop._sprite, ds_yindex]));
	         action_redraw = true;
	      }
      
	      //Get button text surface
	      var action_surf = ds_button[# prop._surf, ds_yindex];
      
	      //Draw surface contents
	      if (action_redraw == true) {
	         surface_set_target(action_surf);
	         draw_clear_alpha(c_black, 0);
	         draw_set_font(action_fnt);
	         draw_text(action_text_x, action_text_y, action_string);
	         draw_text(action_text_x, action_text_y, action_string);
	         draw_set_font(fnt_default);
	         surface_reset_target();
	      }
      
	      /* DRAWING */

	      //Draw button background
	      if (sprite_exists(action_sprite)) {
	         draw_sprite_general(action_sprite, action_index, action_left, action_top, action_width, action_height, action_x, action_y, action_xscale, action_yscale, action_rot, c_white, c_white, c_white, c_white, action_alpha*global.vg_ui_alpha);
	      }
   
	      //Get button text color
	      if (button_hover == action_id) {
	         action_col = action_col2; //Hover
	      }
	      if (button_active == action_id) {
	         action_col = action_col3; //Select
	      }
      
	      //Draw button text
	      draw_surface_general(action_surf, action_left, action_top, action_width, action_height, action_x, action_y, action_xscale, action_yscale, action_rot, action_col, action_col, action_col, action_col, action_alpha*global.vg_ui_alpha);
	   }   
	}


}
