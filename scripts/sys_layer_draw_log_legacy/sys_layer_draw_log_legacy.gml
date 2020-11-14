/// @function	sys_layer_draw_log_legacy(spr_background, spr_divider, spr_paused, spr_playing, sep, linebreak, font, color);
/// @param		{sprite}	spr_background
/// @param		{sprite}	spr_divider
/// @param		{sprite}	spr_paused
/// @param		{sprite}	spr_playing
/// @paramm		{real}		sep
/// @param		{real}		linebreak
/// @param		{font}		font
/// @param		{color}		color
/// @author		Lucas Chasteen <lucas.chasteen@xgasoft.com>
/// @copyright	XGASOFT 2020, All Rights Reserved
function sys_layer_draw_log_legacy(argument0, argument1, argument2, argument3, argument4, argument5, argument6, argument7) {

	/*
	==========================================================================
	SYSTEM FUNCTION: MODIFY AT YOUR OWN RISK!
	--------------------------------------------------------------------------
	  System functions are executed automatically by the engine and typically
	  should not be run manually by the user
	==========================================================================

	Draws the backlog with reduced rendering features for performance and 
	compatibility with low-end platforms. 

	argument0 = sprite to draw as a background for the entire backlog (sprite) (optional, use 'none' for none)
	argument1 = sprite to draw as a divider between log entries (sprite) (optional, use 'none' for none)
	argument2 = sprite to draw as audio icon when stopped (sprite) (optional, use 'none' for none)
	argument3 = sprite to draw as audio icon when playing (sprite) (optional, use 'none' for none)
	argument4 = distance in pixels between log entries and dividers (real)
	argument5 = the width in pixels before text is wrapped into a new line (real)
	argument6 = override font to draw backlog text in (font) (optional, use 'inherit' for inherit)
	argument7 = override color to draw backlog text in (color) (optional, use 'inherit' for inherit)
            
	Example usage:
	   sys_layer_draw_log_legacy(spr_backlog, spr_divider, spr_audio_off, spr_audio_on, 1200, fnt_Arial, c_white);
	*/

	/*
	INITIALIZATION
	*/

	//Skip if log is hidden
	if (global.vg_log_alpha <= 0) {
	   exit;
	}

	//Initialize temporary variables for drawing logged data
	var ds_log_text, ds_xindex, ds_yindex, log_yorig;

	//Initialize log entry IDs
	var log_id = -1;

	//Get divider sprite dimensions, if any
	if (sprite_exists(argument1)) {
	   var div_height = sprite_get_height(argument1);
	   var div_width = min(sprite_get_width(argument1), gui_width);
	} else {
	   var div_height = 0;
	   var div_width = 0;
	}

	//Set draw starting point and bottom margin
	log_yoffset = -argument4 - div_height;

	//Set drawing alpha
	if (global.vg_log_alpha < 1) {
	   draw_set_alpha(global.vg_log_alpha);
	}


	/*
	BACKGROUND
	*/

	//Draw log background, if any
	if (sprite_exists(argument0)) {
	   draw_sprite_stretched(argument0, sprite_get_index(argument0), -1, -1, gui_width + 1, gui_height + 1);
	}


	/*
	TEXT
	*/

	//Draw logged event contents
	for (ds_yindex = ds_grid_height(global.ds_log) - 1; ds_yindex >= 0; ds_yindex -= 1) {  
	   //Get log entry origin point
	   log_yorig = gui_height - log_ycurrent + log_yoffset;
    
	   //Get text data from event
	   ds_log_text = global.ds_log[# prop._data_text, ds_yindex];
   
	   //If text data does not exist, use slot for audio only
	   if (ds_grid_height(ds_log_text) == 0) {
	      //Get log event ID
	      log_id += 1;
      
	      //Get the current event
	      if (log_current == log_id) {
	         log_event = ds_yindex;
	      }
         
	      //Scroll to text, if current
	      if (log_touch_active == false) {
	         if (log_current == log_id) {
	            if (log_yorig - argument4 - div_height < 0) {
	               log_y += log_yorig - argument4 - div_height;
	            }
	            if (log_yorig + argument4 + div_height > gui_height) {
	               log_y += -log_ycurrent + log_yoffset + argument4 + div_height;
	            }
	         }
	      }
	   }
   
	   //Process text
	   for (ds_xindex = ds_grid_height(ds_log_text) - 1; ds_xindex >= 0; ds_xindex -= 1) {
	      //Get log entry origin point
	      log_yorig = gui_height - log_ycurrent + log_yoffset;
      
	      //Get log event ID
	      log_id += 1;
      
	      //Get the current event
	      if (log_current == log_id) {
	         log_event = ds_yindex;
	      }
         
	      //Scroll to text, if current
	      if (log_touch_active == false) {
	         if (log_current == log_id) {
	            if (log_yorig - ds_log_text[# prop._height, ds_xindex] - argument4 - div_height < 0) {
	               log_y += log_yorig - ds_log_text[# prop._height, ds_xindex] - argument4 - div_height;
	            }
	            if (log_yorig + argument4 + div_height > gui_height) {
	               log_y += -log_ycurrent + log_yoffset + argument4 + div_height;
	            }
	         }
	      }
      
	      //Skip if text is off-screen
	      if (log_yorig < 0) or (log_yorig - ds_log_text[# prop._height, ds_xindex] > gui_height) {
	         if (surface_exists(ds_log_text[# prop._surf, ds_xindex])) {
	            surface_free(ds_log_text[# prop._surf, ds_xindex]);
	         }
         
	         //Set position for next log entry
	         log_yoffset -= ds_log_text[# prop._height, ds_xindex];
	         continue;
	      } else {
	         //Set the first visible entry as current while touch scrolling
	         if (log_touch_active == true) {
	            log_current = log_id;
	         }
	      }
      
	      //Process text for drawing
	      var text_surf = sys_log_init(ds_log_text, ds_xindex, argument5, argument6);

	      //Reset drawing alpha for processing text
	      draw_set_alpha(1);

	      //Process text
	      sys_log_perform(ds_log_text, ds_xindex, argument6, argument7);
      
	      //Restore log drawing alpha
	      draw_set_alpha(global.vg_log_alpha);
         
	      //Fade out entry, if not current
	      if (log_current != log_id) {
	         ds_log_text[# prop._alpha, ds_xindex] += (0.5 - ds_log_text[# prop._alpha, ds_xindex])*((15/time_speed)*time_offset);
	      }
      
	      //Otherwise highlight the entry, if current
	      if (log_current == log_id) or (log_touch_active == true) {
	         ds_log_text[# prop._alpha, ds_xindex] += (1 - ds_log_text[# prop._alpha, ds_xindex])*((15/time_speed)*time_offset);
	      }
      
	      //Draw text
	      if (log_yorig > 0) and (log_yorig - ds_log_text[# prop._height, ds_xindex] < gui_height) {
	         //Get the target drawing font and color
	         var log_font = argument6;
	         var log_col1 = argument7;
	         var log_col2 = argument7;
	         var log_col3 = argument7;
	         var log_col4 = argument7;
         
	         //Use stored font and color, if enabled
	         if (argument6 == -2) {
	            log_font = ds_log_text[# prop._txt_fnt, ds_xindex];
	         }
	         if (argument7 == -2) {
	            log_col1 = ds_log_text[# prop._col1, ds_xindex];
	            log_col2 = ds_log_text[# prop._col2, ds_xindex];
	            log_col3 = ds_log_text[# prop._col3, ds_xindex];
	            log_col4 = ds_log_text[# prop._col4, ds_xindex];
	         }
         
	         //Draw text
	         draw_set_font(log_font);
	         draw_text_ext_colour((gui_width - argument5)*0.5, log_yorig - ds_log_text[# prop._height, ds_xindex], ds_log_text[# prop._txt, ds_xindex], string_height("W")*ds_log_text[# prop._txt_line_height, ds_xindex], argument5, log_col1, log_col2, log_col3, log_col4, ds_log_text[# prop._alpha, ds_xindex]);
	         draw_set_font(fnt_default);
	      }
         
	      //Set position for next log entry
	      log_yoffset -= ds_log_text[# prop._height, ds_xindex];
	   }
   
   
	   /*
	   AUDIO ICON
	   */
   
	   //Draw audio icon, if any
	   if (sprite_exists(argument2)) {
	      //Get log entry audio icon origin point
	      log_yorig = gui_height - log_ycurrent + log_yoffset;
      
	      //Draw audio icon
	      if (log_yorig + sprite_get_height(argument2) > 0) and (log_yorig < gui_height) {
	         if (global.ds_log[# prop._data_audio, ds_yindex] != "") {
	            //Get base icon properties
	            var action_sprite = argument2;
	            var action_x = ((gui_width - argument5)*0.5) - sprite_get_width(argument2);
	            var action_y = log_yorig;
         
	            /* STATES */
         
	            //If audio is playing...
	            if (global.ds_log_queue[# prop._data_event, 0] == ds_yindex) {
	               //Set playing sprite
	               if (sprite_exists(argument3)) {
	                  action_sprite = argument3;     
	               }            
	            }
         
	            /* DRAWING */
         
	            //Draw icon
	            draw_sprite(action_sprite, sprite_get_index(action_sprite), action_x, action_y);
            
	            /* MOUSE INPUT */
         
	            //Get bounding box position and dimensions
				var bbox_x = sprite_get_bbox_left(action_sprite);
				var bbox_y = sprite_get_bbox_top(action_sprite);
				var bbox_width = (sprite_get_bbox_right(action_sprite) - sprite_get_bbox_left(action_sprite));
				var bbox_height = (sprite_get_bbox_bottom(action_sprite) - sprite_get_bbox_top(action_sprite));
         
			    //Get mouse position
	            if (mouse_check_region_gui(action_x - sprite_get_xoffset(action_sprite) + bbox_x, action_y - sprite_get_yoffset(action_sprite) + bbox_y, bbox_width, bbox_height)) {
	               //Enable mouse hover state
	               mouse_hover = true;
      
	               //Select audio icon if mouse is clicked
	               if (device_mouse_check_button_released(0, mb_left)) {
	                  //Play associated audio
	                  log_event = ds_yindex;
	                  vngen_do_log_play();
	               }
	            }
	         }
	      }
	   }
      
	   //Draw divider between event contents, if any
	   if (div_height > 0) {
	      //Set margin between divider and events
	      log_yoffset -= (argument4 + div_height);
      
	      //Get log entry divider origin point
	      log_yorig = gui_height - log_ycurrent + log_yoffset;
      
	      //Draw divider, if on-screen
	      if (log_yorig + argument4 + div_height > 0) and (log_yorig < gui_height) {
	         draw_sprite_stretched(argument1, sprite_get_index(argument1), (gui_width*0.5) - (div_width*0.5), log_yorig + (argument4*0.5), div_width, div_height);
	      }
	   } else {
	      //Otherwise only set margin between events
	      log_yoffset -= argument4;
	   }
	} 


	/*
	FINALIZATION
	*/

	//Get log height in entries
	if (log_count == 0) {
	   log_count = log_id;
	}


}
