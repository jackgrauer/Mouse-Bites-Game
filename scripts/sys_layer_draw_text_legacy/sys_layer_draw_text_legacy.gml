/// @function	sys_layer_draw_text_legacy();
/// @author		Lucas Chasteen <lucas.chasteen@xgasoft.com>
/// @copyright	XGASOFT 2020, All Rights Reserved
function sys_layer_draw_text_legacy() {

	/*
	==========================================================================
	SYSTEM FUNCTION: MODIFY AT YOUR OWN RISK!
	--------------------------------------------------------------------------
	  System functions are executed automatically by the engine and typically
	  should not be run manually by the user
	==========================================================================

	Draws text with reduced rendering features for performance and compatibility 
	with low-end platforms. 

	No parameters
            
	Example usage:
	   sys_layer_draw_text_legacy();
	*/

	/*
	TEXT
	*/

	//Skip processing if vngen_object_clear has been run
	if (event_current < 0) {
	   exit;
	}

	//Draw text
	var ds_xindex, ds_yindex;
	for (ds_yindex = 0; ds_yindex < ds_grid_height(ds_text); ds_yindex += 1) {
	   //If text exists...
	   if (ds_text[# prop._id, ds_yindex] != -1) {
      
	      /* BASE PROPERTIES */
         
	      //Get base text properties
	      var action_name = ds_text[# prop._name, ds_yindex];
	      var action_left = ds_text[# prop._left, ds_yindex] + ds_text[# prop._trans_left, ds_yindex];
	      var action_top = ds_text[# prop._top, ds_yindex] + ds_text[# prop._trans_top, ds_yindex];       
	      var action_width = ds_text[# prop._width, ds_yindex] + ds_text[# prop._trans_width, ds_yindex];
	      var action_height = ds_text[# prop._height, ds_yindex] + ds_text[# prop._trans_height, ds_yindex];
	      var action_xorig = ds_text[# prop._xorig, ds_yindex];
	      var action_yorig = ds_text[# prop._yorig, ds_yindex];      
	      var action_x = ds_text[# prop._x, ds_yindex] + ds_text[# prop._trans_x, ds_yindex];
	      var action_y = ds_text[# prop._y, ds_yindex] + ds_text[# prop._trans_y, ds_yindex];
	      var action_xscale = ds_text[# prop._xscale, ds_yindex]*ds_text[# prop._trans_xscale, ds_yindex];
	      var action_yscale = ds_text[# prop._yscale, ds_yindex]*ds_text[# prop._trans_yscale, ds_yindex];
	      var action_rot = ds_text[# prop._rot, ds_yindex] + ds_text[# prop._trans_rot, ds_yindex];
	      var action_col1 = ds_text[# prop._col1, ds_yindex];
	      var action_col2 = ds_text[# prop._col2, ds_yindex];
	      var action_col3 = ds_text[# prop._col3, ds_yindex];
	      var action_col4 = ds_text[# prop._col4, ds_yindex];
	      var action_alpha = ds_text[# prop._alpha, ds_yindex]*ds_text[# prop._trans_alpha, ds_yindex];
	      var action_anim_col1 = ds_text[# prop._anim_col1, ds_yindex];      
	      var action_anim_col2 = ds_text[# prop._anim_col2, ds_yindex];
	      var action_anim_col3 = ds_text[# prop._anim_col3, ds_yindex];
	      var action_anim_col4 = ds_text[# prop._anim_col4, ds_yindex];
	      var action_linebreak = ds_text[# prop._txt_line_break, ds_yindex];
	      var action_fnt = ds_text[# prop._txt_fnt, ds_yindex];
	      var action_shadow = ds_text[# prop._txt_shadow, ds_yindex];
	      var action_outline = ds_text[# prop._txt_outline, ds_yindex];

	      //Get scale offset
	      var action_offset_xscale = ds_text[# prop._oxscale, ds_yindex];
	      var action_offset_yscale = ds_text[# prop._oyscale, ds_yindex]; 
      
	      //Get surface fade properties
	      var action_fade_surf = ds_text[# prop._fade_src, ds_yindex];
	      var action_fade_alpha = ds_text[# prop._fade_alpha, ds_yindex];   
      
	      /* SURFACE */
      
	      //Recreate text surface, if broken
	      if (!surface_exists(ds_text[# prop._surf, ds_yindex])) {
	         //Preserve text typewriter position
	         var temp_char_index = ds_text[# prop._index, ds_yindex];
         
	         //Regenerate text surface
	         var text_surf = sys_text_init(ds_text, ds_yindex, ds_text[# prop._txt_orig, ds_yindex], action_name, ds_text[# prop._txt_halign, ds_yindex], action_linebreak, ds_text[# prop._txt_line_height, ds_yindex], action_fnt, action_col1, action_col2, action_col3, action_col4, action_shadow, action_outline, ds_text[# prop._speed, ds_yindex]);
		 
			 //Get new text dimensions
			 ds_text[# prop._width, ds_yindex] = surface_get_width(text_surf);
			 ds_text[# prop._height, ds_yindex] = surface_get_height(text_surf);
	         action_width = ds_text[# prop._width, ds_yindex] + ds_text[# prop._trans_width, ds_yindex];
	         action_height = ds_text[# prop._height, ds_yindex] + ds_text[# prop._trans_height, ds_yindex];
         
	         //Restore text typewriter position
	         ds_text[# prop._redraw, ds_yindex] = temp_char_index;
		 
			 //Clear deform surface to be regenerated
			 if (surface_exists(ds_text[# prop._def_surf, ds_yindex])) {
			    surface_free(ds_text[# prop._def_surf, ds_yindex]);
				ds_text[# prop._def_surf, ds_yindex] = -1;
			 }
	      }
      
	      //Render text to surface
	      sys_text_perform(ds_text, ds_yindex);
      
	      //Get text surface
	      var action_surf = ds_text[# prop._surf, ds_yindex];
      
	      /* ANIMATIONS */         
            
	      //Perform animation, if any
	      if (sys_anim_perform(ds_text, ds_yindex)) {
	         //Get animation values to apply to text
	         var action_anim_x = ds_text[# prop._anim_x, ds_yindex];      
	         var action_anim_y = ds_text[# prop._anim_y, ds_yindex];  
	         var action_anim_xscale = ds_text[# prop._anim_xscale, ds_yindex];  
	         var action_anim_yscale = ds_text[# prop._anim_yscale, ds_yindex];
	         var action_anim_rot = ds_text[# prop._anim_rot, ds_yindex];  
	         var action_anim_alpha = ds_text[# prop._anim_alpha, ds_yindex];           
	      } else {
	         //Otherwise if no animation is playing, get defaults
	         var action_anim_x = 0;      
	         var action_anim_y = 0;  
	         var action_anim_xscale = 1;  
	         var action_anim_yscale = 1;
	         var action_anim_rot = 0;  
	         var action_anim_alpha = 1;  
	      }
      
	      /* DRAWING */
            
	      //Get final scale
	      action_xscale = (action_xscale*action_offset_xscale)*action_anim_xscale;
	      action_yscale = (action_yscale*action_offset_yscale)*action_anim_yscale;
      
	      //Get final rotation
	      action_rot = action_rot + action_anim_rot;
	      point_rot_prefetch(action_rot);     
      
	      //Get scaled texture offset
	      action_xorig = action_xorig*action_xscale;
	      action_yorig = action_yorig*action_yscale;   
      
	      //Get final position
	      action_x = room_xoffset - point_rot_x(action_xorig, action_yorig) + action_x + action_anim_x;
	      action_y = room_yoffset - point_rot_y(action_xorig, action_yorig) + action_y + action_anim_y;
      
	      //Record final properties
	      ds_text[# prop._final_width, ds_yindex] = action_width;
	      ds_text[# prop._final_height, ds_yindex] = action_height;
	      ds_text[# prop._final_x, ds_yindex] = action_x + point_rot_x(action_left*action_xscale, action_top*action_yscale);
	      ds_text[# prop._final_y, ds_yindex] = action_y + point_rot_y(action_left*action_xscale, action_top*action_yscale);
	      ds_text[# prop._final_xscale, ds_yindex] = action_xscale;
	      ds_text[# prop._final_yscale, ds_yindex] = action_yscale;
	      ds_text[# prop._final_rot, ds_yindex] = action_rot;

	      //Get scaled dimensions
	      action_x = ds_text[# prop._final_x, ds_yindex];
	      action_y = ds_text[# prop._final_y, ds_yindex];
      
	      //Draw as surface if no deform is active
	      draw_surface_general(action_surf, action_left, action_top, action_width, action_height, action_x, action_y, action_xscale, action_yscale, action_rot, action_anim_col1, action_anim_col2, action_anim_col3, action_anim_col4, ((action_alpha*action_anim_alpha)*action_fade_alpha)*global.vg_ui_alpha);
   
	      //Draw fade surface, if any
	      if (surface_exists(action_fade_surf)) {
	         //Reverse alpha transition to fade out
	         action_fade_alpha = min(1 - action_fade_alpha, action_alpha);
                  
	         draw_surface_general(action_fade_surf, 0, 0, surface_get_width(action_fade_surf), surface_get_height(action_fade_surf), action_x, action_y, action_xscale, action_yscale, action_rot, action_anim_col1, action_anim_col2, action_anim_col3, action_anim_col4, (action_anim_alpha*action_fade_alpha)*global.vg_ui_alpha);
	      }
      
	      //Perform mouse events for markup links
	      if (ds_exists(ds_text[# prop._mark_link_data, ds_yindex], ds_type_grid)) {
	         //Get link data structure
	         var ds_link = ds_text[# prop._mark_link_data, ds_yindex];
         
	         //Initialize temporary variables for checking link hotspots
	         var link_x, link_y, link_width, link_height;
         
	         //Check link hover state, if text is not rotated and no deform is active
	         if (action_rot == 0) {
	            if (ds_text[# prop._def, ds_yindex] == -1) {
	               for (ds_xindex = 0; ds_xindex < ds_grid_height(ds_link); ds_xindex += 1) {            
	                  //Get link properties
	                  link_x = action_x + (ds_link[# prop._x, ds_xindex]*action_xscale);
	                  link_y = action_y + (ds_link[# prop._y, ds_xindex]*action_yscale);
	                  link_width = (ds_link[# prop._width, ds_xindex]*action_xscale);
	                  link_height = (ds_link[# prop._height, ds_xindex]*action_yscale);
            
	                  //Draw markup link hotspot outline if debug mode is enabled
	                  if (global.vg_debug == true) {
	                     if (global.vg_debug_helpers == true) { 
	                        draw_set_color(c_fuchsia);
	                        draw_rectangle(link_x + 1, link_y + 1, link_x + link_width - 1, link_y + link_height - 1, true);
	                        draw_set_color(c_white);
	                     }
	                  }
                  
	                  /* MOUSE INPUT */
                     
	                  //If engine is unpaused...
	                  if (global.vg_ui_visible == true) {
	                     if (global.vg_pause == false) {
	                        //Get mouse position
	                        if (mouse_check_region(link_x, link_y, link_width, link_height)) {
	                           //Enable mouse hover state
	                           mouse_hover = true;
                           
	                           //Execute link event if mouse is clicked
	                           if (device_mouse_check_button_released(0, mb_left)) {
	                              event_perform(ds_link[# prop._event, ds_xindex], ds_link[# prop._type, ds_xindex]);
	                              break;
	                           }
	                        }
	                     }
	                  }
	               }
	            }
	         }
	      }
	   }
	}


}
