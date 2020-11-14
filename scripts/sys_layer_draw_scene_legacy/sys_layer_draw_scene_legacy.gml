/// @function	sys_layer_draw_scene_legacy(foreground);
/// @param		{boolean} foreground
/// @author		Lucas Chasteen <lucas.chasteen@xgasoft.com>
/// @copyright	XGASOFT 2020, All Rights Reserved
function sys_layer_draw_scene_legacy(argument0) {

	/*
	==========================================================================
	SYSTEM FUNCTION: MODIFY AT YOUR OWN RISK!
	--------------------------------------------------------------------------
	  System functions are executed automatically by the engine and typically
	  should not be run manually by the user
	==========================================================================

	Draws scenes as either backgrounds or foregrounds with reduced rendering
	features for performance and compatibility with low-end platforms

	argument0 = enables or disables drawing scene as foreground (boolean) (true/false)
            
	Example usage:
	   sys_layer_draw_scene_legacy(false);
	*/

	/*
	SCENES
	*/

	//Skip processing if vngen_object_clear has been run
	if (event_current < 0) {
	   exit;
	}

	//Get perspective based on input layer
	if (argument0 == true) {
	   var per_strength_scene = per_strength_fg;
	   var per_zoom_scene = per_zoom_fg;
	} else {
	   var per_strength_scene = per_strength_bg;
	   var per_zoom_scene = per_zoom_bg;
	}

	//Draw scenes
	var ds_yindex;
	for (ds_yindex = 0; ds_yindex < ds_grid_height(ds_scene); ds_yindex += 1) {
	   //If scene exists...
	   if (ds_scene[# prop._id, ds_yindex] != -1) {
   
	      /* LAYER CHECK */
      
	      //Skip if scene is not part of the input layer
	      if (ds_scene[# prop._scn_foreground, ds_yindex] != argument0) {
	         continue;
	      }
      
	      /* BASE PROPERTIES */
         
	      //Get base scene properties
	      var action_sprite = ds_scene[# prop._sprite, ds_yindex];
	      var action_left = ds_scene[# prop._left, ds_yindex] + ds_scene[# prop._trans_left, ds_yindex];
	      var action_top = ds_scene[# prop._top, ds_yindex] + ds_scene[# prop._trans_top, ds_yindex];      
	      var action_width = ds_scene[# prop._width, ds_yindex] + ds_scene[# prop._trans_width, ds_yindex];
	      var action_height = ds_scene[# prop._height, ds_yindex] + ds_scene[# prop._trans_height, ds_yindex];
	      var action_xorig = ds_scene[# prop._xorig, ds_yindex];
	      var action_yorig = ds_scene[# prop._yorig, ds_yindex];
	      var action_x = ds_scene[# prop._x, ds_yindex] + ds_scene[# prop._trans_x, ds_yindex];
	      var action_y = ds_scene[# prop._y, ds_yindex] + ds_scene[# prop._trans_y, ds_yindex];
	      var action_z = ds_scene[# prop._z, ds_yindex];
	      var action_xscale = ds_scene[# prop._xscale, ds_yindex]*ds_scene[# prop._trans_xscale, ds_yindex];
	      var action_yscale = ds_scene[# prop._yscale, ds_yindex]*ds_scene[# prop._trans_yscale, ds_yindex];
	      var action_rot = ds_scene[# prop._rot, ds_yindex] + ds_scene[# prop._trans_rot, ds_yindex];
	      var action_col1 = ds_scene[# prop._col1, ds_yindex];
	      var action_col2 = ds_scene[# prop._col2, ds_yindex];
	      var action_col3 = ds_scene[# prop._col3, ds_yindex];
	      var action_col4 = ds_scene[# prop._col4, ds_yindex];
	      var action_alpha = ds_scene[# prop._alpha, ds_yindex]*ds_scene[# prop._trans_alpha, ds_yindex];
	  
		  /* SPRITE PROPERTIES */
	  
		  //Get sprite index
		  var action_index = ds_scene[# prop._img_index, ds_yindex];
	  
		  //Animate sprite
		  if (global.vg_pause == false) {
		     ds_scene[# prop._img_index, ds_yindex] += sprite_get_speed_real(action_sprite)*time_offset;
		  }
	  
		  //Loop sprite
		  if (ds_scene[# prop._img_index, ds_yindex] > ds_scene[# prop._img_num, ds_yindex]) {
	         ds_scene[# prop._img_index, ds_yindex] -= ds_scene[# prop._img_num, ds_yindex];
		  }

	      //Get scale offset
	      var action_offset_xscale = ds_scene[# prop._oxscale, ds_yindex];
	      var action_offset_yscale = ds_scene[# prop._oyscale, ds_yindex]; 
      
	      //Get sprite fade properties
	      var action_fade_surf = ds_scene[# prop._fade_src, ds_yindex];
	      var action_fade_alpha = ds_scene[# prop._fade_alpha, ds_yindex];       
      
	      //Get surface dimensions
	      var action_surf_width = sprite_get_width(action_sprite);
	      var action_surf_height = sprite_get_height(action_sprite);
      
	      /* SURFACE */
      
	      //Draw surface contents if surface is broken or sprite is animated
	      if (!surface_exists(ds_scene[# prop._surf, ds_yindex])) 
	      or (ds_scene[# prop._img_num, ds_yindex] > 1) 
	      or (ds_scene[# prop._width, ds_yindex] != ds_scene[# prop._final_width, ds_yindex]) 
	      or (ds_scene[# prop._height, ds_yindex] != ds_scene[# prop._final_height, ds_yindex]) {
	         //Recreate scene surface, if broken
	         if (!surface_exists(ds_scene[# prop._surf, ds_yindex])) {
	            ds_scene[# prop._surf, ds_yindex] = surface_create(action_surf_width, action_surf_height);
		 
			    //Clear deform surface to be regenerated
			    if (surface_exists(ds_scene[# prop._def_surf, ds_yindex])) {
			       surface_free(ds_scene[# prop._def_surf, ds_yindex]);
				   ds_scene[# prop._def_surf, ds_yindex] = -1;
			    }
	         }
         
	         //Get scene offset
	         var temp_x = (action_surf_width*(action_left/action_surf_width));
	         var temp_y = (action_surf_height*(action_top/action_surf_height));
         
	         //Draw surface contents
	         surface_set_target(ds_scene[# prop._surf, ds_yindex]);
			 gpu_set_blendenable(false);
	         draw_clear_alpha(c_black, 0);
	         draw_sprite_part(action_sprite, action_index, action_left, action_top, action_width, action_height, temp_x, temp_y);
			 gpu_set_blendenable(true);
	         surface_reset_target();
	      }
      
	      /* ANIMATIONS */
      
	      //Perform animation, if any
	      if (sys_anim_perform(ds_scene, ds_yindex)) {
	         //Get animation values to apply to scene
	         var action_anim_x = ds_scene[# prop._anim_x, ds_yindex];      
	         var action_anim_y = ds_scene[# prop._anim_y, ds_yindex];  
	         var action_anim_xscale = ds_scene[# prop._anim_xscale, ds_yindex];  
	         var action_anim_yscale = ds_scene[# prop._anim_yscale, ds_yindex];
	         var action_anim_rot = ds_scene[# prop._anim_rot, ds_yindex];  
	         var action_anim_alpha = ds_scene[# prop._anim_alpha, ds_yindex];       
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
      
	      //Get final perspective
	      action_x = ((per_width - (action_x*per_zoom_scene)) + ((per_width*per_zoom_scene) - per_width));
	      action_y = ((per_height - (action_y*per_zoom_scene)) + ((per_height*per_zoom_scene) - per_height));
	      action_z = (per_strength_scene*(per_zoom_scene + ((action_z*-0.01)*per_zoom_scene)));
	      var per_xcenter = per_x + point_rot_x(action_x, action_y, per_rot);
	      var per_ycenter = per_y + point_rot_y(action_x, action_y);
      
	      //Get final scale
	      action_xscale = ((action_xscale*action_offset_xscale)*action_anim_xscale)*per_zoom_scene;
	      action_yscale = ((action_yscale*action_offset_yscale)*action_anim_yscale)*per_zoom_scene;   
      
	      //Get final rotation
	      action_rot = per_rot + action_rot + action_anim_rot;
      
	      //Get scaled sprite origin
	      action_xorig = action_xorig*action_xscale;
	      action_yorig = action_yorig*action_yscale;
      
	      //Get scaled animation offset
	      action_anim_x = action_anim_x*per_zoom_scene;
	      action_anim_y = action_anim_y*per_zoom_scene;
      
	      //Get final position
	      action_x = room_xoffset - point_rot_x(action_xorig, action_yorig, action_rot) - per_xcenter - (action_z*per_xoffset) + per_width + point_rot_x(action_anim_x, action_anim_y, per_rot);
	      action_y = room_yoffset - point_rot_y(action_xorig, action_yorig, action_rot) - per_ycenter - (action_z*per_yoffset) + per_height + point_rot_y(action_anim_x, action_anim_y, per_rot);
      
	      //Record final properties
	      ds_scene[# prop._final_width, ds_yindex] = action_width;
	      ds_scene[# prop._final_height, ds_yindex] = action_height;
	      ds_scene[# prop._final_x, ds_yindex] = action_x + point_rot_x(action_left*action_xscale, action_top*action_yscale, action_rot);
	      ds_scene[# prop._final_y, ds_yindex] = action_y + point_rot_y(action_left*action_xscale, action_top*action_yscale);
	      ds_scene[# prop._final_xscale, ds_yindex] = action_xscale;
	      ds_scene[# prop._final_yscale, ds_yindex] = action_yscale;
	      ds_scene[# prop._final_rot, ds_yindex] = action_rot;
      
	      /* STANDARD */

	      //Draw standard scene
	      if (ds_scene[# prop._scn_repeat, ds_yindex] == false) {
	         //Get scaled dimensions
	         action_x = ds_scene[# prop._final_x, ds_yindex];
	         action_y = ds_scene[# prop._final_y, ds_yindex];
         
	         //Draw as surface if no deform is active
	         draw_sprite_general(action_sprite, action_index, action_left, action_top, action_width, action_height, action_x, action_y, action_xscale, action_yscale, action_rot, action_col1, action_col2, action_col3, action_col4, (action_alpha*action_anim_alpha)*action_fade_alpha);
   
	         //Draw fade surface, if any
	         if (surface_exists(action_fade_surf)) {
	            //Reverse alpha transition to fade out
	            action_fade_alpha = min(1 - action_fade_alpha, action_alpha); 
                        
	            draw_surface_general(action_fade_surf, 0, 0, surface_get_width(action_fade_surf), surface_get_height(action_fade_surf), action_x, action_y, action_xscale, action_yscale, action_rot, action_col1, action_col2, action_col3, action_col4, action_anim_alpha*action_fade_alpha);
	         }
      
	      /* TILED */
      
	      } else {
	         //Draw tiled scene
	         if (abs(action_width*action_xscale) > 4) and (abs(action_height*action_yscale) > 4) {   
	            draw_sprite_tiled_ext(action_sprite, action_index, action_x, action_y, action_xscale, action_yscale, action_col1, (action_alpha*action_anim_alpha)*action_fade_alpha);
            
	            //Draw legacy fade scene, if any
	            if (surface_exists(action_fade_surf)) {
	               //Reverse alpha transition to fade out
	               action_fade_alpha = min(1 - action_fade_alpha, action_alpha); 
               
	               draw_surface_tiled_ext(action_fade_surf, action_x, action_y, action_xscale, action_yscale, action_col1, action_anim_alpha*action_fade_alpha);
	            }
	         }
	      }   
	   }
	}


}
