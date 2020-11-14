/// @function	sys_layer_draw_label_legacy();
/// @author		Lucas Chasteen <lucas.chasteen@xgasoft.com>
/// @copyright	XGASOFT 2020, All Rights Reserved
function sys_layer_draw_label_legacy() {

	/*
	==========================================================================
	SYSTEM FUNCTION: MODIFY AT YOUR OWN RISK!
	--------------------------------------------------------------------------
	  System functions are executed automatically by the engine and typically
	  should not be run manually by the user
	==========================================================================

	Draws labels with reduced rendering features for performance and compatibility 
	with low-end platforms. 

	No parameters
            
	Example usage:
	   sys_layer_draw_label_legacy();
	*/

	/*
	LABELS
	*/

	//Skip processing if vngen_object_clear has been run
	if (event_current < 0) {
	   exit;
	}

	//Draw labels
	var ds_yindex;
	for (ds_yindex = 0; ds_yindex < ds_grid_height(ds_label); ds_yindex += 1) {
	   //If text exists...
	   if (ds_label[# prop._id, ds_yindex] != -1) {
      
	      /* BASE PROPERTIES */
         
	      //Get base label properties
	      var action_string = ds_label[# prop._txt_orig, ds_yindex];
	      var action_left = ds_label[# prop._left, ds_yindex] + ds_label[# prop._trans_left, ds_yindex];
	      var action_top = ds_label[# prop._top, ds_yindex] + ds_label[# prop._trans_top, ds_yindex];        
	      var action_width = ds_label[# prop._width, ds_yindex] + ds_label[# prop._trans_width, ds_yindex];
	      var action_height = ds_label[# prop._height, ds_yindex] + ds_label[# prop._trans_height, ds_yindex];
	      var action_xorig = ds_label[# prop._xorig, ds_yindex];
	      var action_yorig = ds_label[# prop._yorig, ds_yindex];      
	      var action_x = ds_label[# prop._x, ds_yindex] + ds_label[# prop._trans_x, ds_yindex];
	      var action_y = ds_label[# prop._y, ds_yindex] + ds_label[# prop._trans_y, ds_yindex];
	      var action_xscale = ds_label[# prop._xscale, ds_yindex]*ds_label[# prop._trans_xscale, ds_yindex];
	      var action_yscale = ds_label[# prop._yscale, ds_yindex]*ds_label[# prop._trans_yscale, ds_yindex];
	      var action_rot = ds_label[# prop._rot, ds_yindex] + ds_label[# prop._trans_rot, ds_yindex];
	      var action_col1 = ds_label[# prop._col1, ds_yindex];
	      var action_col2 = ds_label[# prop._col2, ds_yindex];
	      var action_col3 = ds_label[# prop._col3, ds_yindex];
	      var action_col4 = ds_label[# prop._col4, ds_yindex];
	      var action_alpha = ds_label[# prop._alpha, ds_yindex]*ds_label[# prop._trans_alpha, ds_yindex];
	      var action_anim_col1 = ds_label[# prop._anim_col1, ds_yindex];      
	      var action_anim_col2 = ds_label[# prop._anim_col2, ds_yindex];
	      var action_anim_col3 = ds_label[# prop._anim_col3, ds_yindex];
	      var action_anim_col4 = ds_label[# prop._anim_col4, ds_yindex];
	      var action_linebreak = ds_label[# prop._txt_line_break, ds_yindex];
	      var action_fnt = ds_label[# prop._txt_fnt, ds_yindex];
	      var action_shadow = ds_label[# prop._txt_shadow, ds_yindex];
	      var action_outline = ds_label[# prop._txt_outline, ds_yindex];

	      //Get scale offset
	      var action_offset_xscale = ds_label[# prop._oxscale, ds_yindex];
	      var action_offset_yscale = ds_label[# prop._oyscale, ds_yindex]; 
      
	      //Get surface fade properties
	      var action_fade_surf = ds_label[# prop._fade_src, ds_yindex];
	      var action_fade_alpha = ds_label[# prop._fade_alpha, ds_yindex];  
      
	      /* AUTO LABEL */
      
	      //Get auto label for each new event
	      if (ds_label[# prop._lab_auto, ds_yindex] == true) {
	         if (text_label_auto != ds_label[# prop._txt_orig, ds_yindex]) or (event_current != ds_label[# prop._lab_event, ds_yindex]) {
	            //Get auto label
	            action_string = text_label_auto;
            
	            //Get auto label style
	            action_fnt = inherit;
	            action_col1 = inherit;
	            action_col2 = inherit;
	            action_col3 = inherit;
	            action_col4 = inherit;
	            action_shadow = inherit;
	            action_outline = inherit;
            
	            //Clear old surface data for redrawing
	            if (surface_exists(ds_label[# prop._surf, ds_yindex])) {
	               surface_free(ds_label[# prop._surf, ds_yindex]);
	               ds_label[# prop._surf, ds_yindex] = -1;
	            }
	            if (surface_exists(ds_label[# prop._def_surf, ds_yindex])) {
	               surface_free(ds_label[# prop._def_surf, ds_yindex]);
	               ds_label[# prop._def_surf, ds_yindex] = -1;
	            }
	            if (surface_exists(ds_label[# prop._def_fade_surf, ds_yindex])) {
	               surface_free(ds_label[# prop._def_fade_surf, ds_yindex]);
	               ds_label[# prop._def_fade_surf, ds_yindex] = -1;
	            }                     
            
	            //Update label event check
	            ds_label[# prop._lab_event, ds_yindex] = event_current;
	         }
	      }
      
	      /* SURFACE */
      
	      //Recreate label surface, if broken
	      if (!surface_exists(ds_label[# prop._surf, ds_yindex])) {
	         //Preserve label auto mode
	         var temp_auto = ds_label[# prop._lab_auto, ds_yindex];
         
	         //Regenerate label surface
	         var label_surf = sys_text_init(ds_label, ds_yindex, action_string, action_string, ds_label[# prop._txt_halign, ds_yindex], action_linebreak, ds_label[# prop._txt_line_height, ds_yindex], action_fnt, action_col1, action_col2, action_col3, action_col4, action_shadow, action_outline, ds_label[# prop._speed, ds_yindex]);
         
	         //Get new label dimensions
	         ds_label[# prop._width, ds_yindex] = surface_get_width(label_surf);
	         ds_label[# prop._height, ds_yindex] = surface_get_height(label_surf);
	         action_width = ds_label[# prop._width, ds_yindex] + ds_label[# prop._trans_width, ds_yindex];
	         action_height = ds_label[# prop._height, ds_yindex] + ds_label[# prop._trans_height, ds_yindex];
         
	         //Restore label auto mode
	         ds_label[# prop._lab_auto, ds_yindex] = temp_auto;
         
	         //Enable redrawing label
	         ds_label[# prop._redraw, ds_yindex] = true;
	      }
      
	      //Render label to surface
	      sys_text_perform(ds_label, ds_yindex);
      
	      //Get label surface
	      var action_surf = ds_label[# prop._surf, ds_yindex];
      
	      /* ANIMATIONS */         
            
	      //Perform animation, if any
	      if (sys_anim_perform(ds_label, ds_yindex)) {
	         //Get animation values to apply to character
	         var action_anim_x = ds_label[# prop._anim_x, ds_yindex];      
	         var action_anim_y = ds_label[# prop._anim_y, ds_yindex];  
	         var action_anim_xscale = ds_label[# prop._anim_xscale, ds_yindex];  
	         var action_anim_yscale = ds_label[# prop._anim_yscale, ds_yindex];
	         var action_anim_rot = ds_label[# prop._anim_rot, ds_yindex];  
	         var action_anim_alpha = ds_label[# prop._anim_alpha, ds_yindex];           
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
	      ds_label[# prop._final_width, ds_yindex] = action_width;
	      ds_label[# prop._final_height, ds_yindex] = action_height;
	      ds_label[# prop._final_x, ds_yindex] = action_x + point_rot_x(action_left*action_xscale, action_top*action_yscale);
	      ds_label[# prop._final_y, ds_yindex] = action_y + point_rot_y(action_left*action_xscale, action_top*action_yscale);
	      ds_label[# prop._final_xscale, ds_yindex] = action_xscale;
	      ds_label[# prop._final_yscale, ds_yindex] = action_yscale;
	      ds_label[# prop._final_rot, ds_yindex] = action_rot;

	      //Get scaled dimensions
	      action_x = ds_label[# prop._final_x, ds_yindex];
	      action_y = ds_label[# prop._final_y, ds_yindex];

	      //Draw as surface if no deform is active
	      draw_surface_general(action_surf, action_left, action_top, action_width, action_height, action_x, action_y, action_xscale, action_yscale, action_rot, action_anim_col1, action_anim_col2, action_anim_col3, action_anim_col4, ((action_alpha*action_anim_alpha)*action_fade_alpha)*global.vg_ui_alpha);
   
	      //Draw fade surface, if any
	      if (surface_exists(action_fade_surf)) {
	         //Reverse alpha transition to fade out
	         action_fade_alpha = min(1 - action_fade_alpha, action_alpha);
                  
	         draw_surface_general(action_fade_surf, 0, 0, surface_get_width(action_fade_surf), surface_get_height(action_fade_surf), action_x, action_y, action_xscale, action_yscale, action_rot, action_anim_col1, action_anim_col2, action_anim_col3, action_anim_col4, (action_anim_alpha*action_fade_alpha)*global.vg_ui_alpha);
	      }
	   }
	}


}
