/// @function	sys_layer_draw_scene(foreground);
/// @param		{boolean} foreground
/// @author		Lucas Chasteen <lucas.chasteen@xgasoft.com>
/// @copyright	XGASOFT 2020, All Rights Reserved
function sys_layer_draw_scene(argument0) {

	/*
	==========================================================================
	SYSTEM FUNCTION: MODIFY AT YOUR OWN RISK!
	--------------------------------------------------------------------------
	  System functions are executed automatically by the engine and typically
	  should not be run manually by the user
	==========================================================================

	Draws scenes as either backgrounds or foregrounds

	argument0 = enables or disables drawing scene as foreground (boolean) (true/false)
            
	Example usage:
	   sys_layer_draw_scene(false);
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
      
	      //Get deform surfaces
	      var action_def_surf = ds_scene[# prop._def_surf, ds_yindex];
	      var action_def_fade_surf = ds_scene[# prop._def_fade_surf, ds_yindex];
      
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
      
	      //Get scene surface
	      var action_surf = ds_scene[# prop._surf, ds_yindex];
      
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
      
	      /* DEFORMATIONS */
      
	      //Perform deformation, if any
	      sys_deform_perform(ds_scene, ds_yindex);
      
	      /* SHADERS */
      
	      //Perform shader, if any
	      sys_shader_perform(ds_scene, ds_yindex);
      
	      /* DRAWING */       
              
	      //Enable repeating scene texture
	      gpu_set_texrepeat(true);
      
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
      
	      /* TILED */
      
	      //Initialize temporary variables for calculating tiled properties
	      var temp_left, temp_top, temp_width, temp_height, temp_x, temp_y, temp_scale, temp_rot;
      
	      //Get tiled scene properties, if enabled
	      if (ds_scene[# prop._scn_repeat, ds_yindex] == true) {
	         if (global.vg_renderlevel == 0) {
	            //Get tile properties
	            temp_rot = 0;
	            temp_scale = 1;
	            temp_width = global.dp_width*0.5;
	            temp_height = global.dp_height*0.5;
	            temp_left = 0;
	            temp_top = 0;
	            temp_x = room_xoffset;
	            temp_y = room_yoffset;
            
	            //Get tile expansion based on rotation, if any
	            if (action_rot != 0) {
	               temp_scale = abs(dist_rot_x(1)) + abs(dist_rot_y(max(global.dp_width/global.dp_height, global.dp_height/global.dp_width)));
               
	               //Get tile properties based on rotation
	               temp_left = temp_width*temp_scale;
	               temp_top = temp_height*temp_scale;
	               temp_x -= (point_rot_x(temp_left, temp_top) - temp_width);
	               temp_y -= (point_rot_y(temp_left, temp_top) - temp_height);
	               temp_left = ((temp_left - temp_width)/action_xscale);
	               temp_top = ((temp_top - temp_height)/action_yscale);
	            }

	            //Get tiled properties
	            action_left = point_rot_x(temp_x - action_x, (temp_y - action_y)*-1)/action_xscale;
	            action_top = point_rot_y((temp_x - action_x)*-1, temp_y - action_y)/action_yscale;
	            action_width = (global.dp_width/action_xscale) + (temp_left*2);
	            action_height = (global.dp_height/action_yscale) + (temp_top*2);
	            action_x = temp_x;
	            action_y = temp_y;  
	         }
	      }
      
	      /* STANDARD */

	      //Draw scene
	      if (ds_scene[# prop._def, ds_yindex] == -1) or (global.vg_renderlevel > 0) {  
	         if (global.vg_renderlevel == 0) or (ds_scene[# prop._scn_repeat, ds_yindex] == false) {
	            //Get scaled dimensions if scene is not tiled
	            if (ds_scene[# prop._scn_repeat, ds_yindex] == false) { 
	               action_x = ds_scene[# prop._final_x, ds_yindex];
	               action_y = ds_scene[# prop._final_y, ds_yindex];
	            }
            
	            //Draw as surface if no deform is active
	            draw_surface_general(action_surf, action_left, action_top, action_width, action_height, action_x, action_y, action_xscale, action_yscale, action_rot, action_col1, action_col2, action_col3, action_col4, (action_alpha*action_anim_alpha)*action_fade_alpha);
      
	            //Draw fade surface, if any
	            if (surface_exists(action_fade_surf)) {
	               //Reverse alpha transition to fade out
	               action_fade_alpha = min(1 - action_fade_alpha, action_alpha); 
                           
	               draw_surface_general(action_fade_surf, 0, 0, surface_get_width(action_fade_surf), surface_get_height(action_fade_surf), action_x, action_y, action_xscale, action_yscale, action_rot, action_col1, action_col2, action_col3, action_col4, action_anim_alpha*action_fade_alpha);
	            }
	         } else {
	            //Draw legacy scene, if tiled and enabled
	            if (abs(action_width*action_xscale) > 4) and (abs(action_height*action_yscale) > 4) {   
	               draw_surface_tiled_ext(action_surf, action_x, action_y, action_xscale, action_yscale, action_col1, (action_alpha*action_anim_alpha)*action_fade_alpha);
               
	               //Draw legacy fade scene, if any
	               if (surface_exists(action_fade_surf)) {
	                  //Reverse alpha transition to fade out
	                  action_fade_alpha = min(1 - action_fade_alpha, action_alpha); 
                  
	                  draw_surface_tiled_ext(action_fade_surf, action_x, action_y, action_xscale, action_yscale, action_col1, action_anim_alpha*action_fade_alpha);
	               }
	            }
	         }
         
	      /* PRIMITIVE */
      
	      } else {
	         //Initialize temporary variables for drawing deformation
	         var tex_u, tex_v, tex_width, tex_height, tex_xcount, tex_ycount, tex_xindex, tex_yindex;
         
	         //Get tiled surface properties, if enabled
	         if (global.vg_renderlevel == 0) and (ds_scene[# prop._scn_repeat, ds_yindex] == true) { 
	            action_surf_width = global.dp_width;
	            action_surf_height = global.dp_height;
	            temp_x -= room_xoffset;
	            temp_y -= room_yoffset;
	            temp_width = action_width;
	            temp_height = action_height;
	            temp_xscale = action_xscale;
	            temp_yscale = action_yscale;
	            temp_rot = action_rot;
	            action_x = room_xoffset;
	            action_y = room_yoffset;
	            action_xscale = 1;
	            action_yscale = 1;
	            action_rot = 0;
	         } else {
	            //Otherwise get default surface properties
	            temp_x = action_left;
	            temp_y = action_top;
	            temp_width = action_width;
	            temp_height = action_height;
	            temp_xscale = 1;
	            temp_yscale = 1;
	            temp_rot = 0;
	         }
         
	         //Get texel count
	         tex_xcount = def_width - 1;
	         tex_ycount = def_height - 1;
         
	         //Get texel UV dimensions
	         tex_u = action_surf_width/tex_xcount;
	         tex_v = action_surf_height/tex_ycount;
         
	         //Ensure deform surface exists
	         if (!surface_exists(action_def_surf)) {
	            ds_scene[# prop._def_surf, ds_yindex] = surface_create(action_surf_width, action_surf_height);
	            action_def_surf = ds_scene[# prop._def_surf, ds_yindex];
	         }        
         
	         //Draw to surface for deformation
	         surface_set_target(action_def_surf);
	         draw_clear_alpha(c_black, 0);
	         draw_surface_general(action_surf, action_left, action_top, temp_width, temp_height, temp_x, temp_y, temp_xscale, temp_yscale, temp_rot, action_col1, action_col2, action_col3, action_col4, 1);
         
	         //Temporarily disable shader, if any
	         if (sys_shader_exists(ds_scene[# prop._shader, ds_yindex])) {
	            shader_reset();
	         }
         
	         //Draw wireframe if debug mode is enabled
	         if (global.vg_debug == true) {
	            if (global.vg_debug_helpers == true) {         
	               for (tex_xindex = 0; tex_xindex < tex_xcount; tex_xindex += 1) {
	                  for (tex_yindex = 0; tex_yindex < tex_ycount; tex_yindex += 1) {
	                     draw_set_color(c_lime);
	                     draw_rectangle(tex_u*tex_xindex, tex_v*tex_yindex, (tex_u*tex_xindex) + tex_u - 1, (tex_v*tex_yindex) + tex_v - 1, true);
	                     draw_line(tex_u*tex_xindex, (tex_v*tex_yindex) + tex_v - 1, (tex_u*tex_xindex) + tex_u - 1, tex_v*tex_yindex);
	                     draw_set_color(c_white);
	                  }
	               }
	            }
	         }
	         surface_reset_target();            

	         //Draw as primitive
	         sys_deform_draw(ds_scene, ds_yindex, surface_get_texture(action_def_surf), action_surf_width, action_surf_height, action_x, action_y, action_xscale, action_yscale, action_rot, (action_alpha*action_anim_alpha)*action_fade_alpha);              
         
	         //Re-enable shader, if any
	         if (sys_shader_exists(ds_scene[# prop._shader, ds_yindex])) {
	            shader_set(ds_scene[# prop._shader, ds_yindex]);
	         }
         
	         //Draw fade primitive, if any
	         if (surface_exists(action_fade_surf)) {            
	            //Get fade deform surface properties, if tiling is disabled
	            if (ds_scene[# prop._scn_repeat, ds_yindex] == false) { 
	               //Get fade deform surface dimensions
	               action_surf_width = surface_get_width(action_fade_surf);
	               action_surf_height = surface_get_height(action_fade_surf);
	               action_left = 0;
	               action_top = 0;
	               temp_width = action_surf_width;
	               temp_height = action_surf_height;
	               temp_x = 0;
	               temp_y = 0;
	               temp_xscale = 1;
	               temp_yscale = 1;
	               temp_rot = 0;
            
	               //Get texel UV dimensions
	               tex_u = action_surf_width/tex_xcount;
	               tex_v = action_surf_height/tex_ycount;
	            }
            
	            //Ensure fade deform surface exists
	            if (!surface_exists(action_def_fade_surf)) {
	               ds_scene[# prop._def_fade_surf, ds_yindex] = surface_create(action_surf_width, action_surf_height);
	               action_def_fade_surf = ds_scene[# prop._def_fade_surf, ds_yindex];
	            }   
                    
	            //Draw to surface for deformation
	            surface_set_target(action_def_fade_surf);
	            draw_clear_alpha(c_black, 0);
	            draw_surface_general(action_fade_surf, action_left, action_top, temp_width, temp_height, temp_x, temp_y, temp_xscale, temp_yscale, temp_rot, action_col1, action_col2, action_col3, action_col4, 1);
            
	            //Temporarily disable shader, if any
	            if (sys_shader_exists(ds_scene[# prop._shader, ds_yindex])) {
	               shader_reset();
	            }
         
	            //Draw wireframe if debug mode is enabled
	            if (global.vg_debug == true) {
	               if (global.vg_debug_helpers == true) {         
	                  for (tex_xindex = 0; tex_xindex < tex_xcount; tex_xindex += 1) {
	                     for (tex_yindex = 0; tex_yindex < tex_ycount; tex_yindex += 1) {
	                        draw_set_color(c_lime);
	                        draw_rectangle(tex_u*tex_xindex, tex_v*tex_yindex, (tex_u*tex_xindex) + tex_u - 1, (tex_v*tex_yindex) + tex_v - 1, true);
	                        draw_line(tex_u*tex_xindex, (tex_v*tex_yindex) + tex_v - 1, (tex_u*tex_xindex) + tex_u - 1, tex_v*tex_yindex);
	                        draw_set_color(c_white);
	                     }
	                  }
	               }
	            }            
	            surface_reset_target();        
            
	            //Reverse alpha transition to fade out
	            action_fade_alpha = min(1 - action_fade_alpha, action_alpha);        
            
	            //Draw fade primitive
	            sys_deform_draw(ds_scene, ds_yindex, surface_get_texture(action_def_fade_surf), action_surf_width, action_surf_height, action_x, action_y, action_xscale, action_yscale, action_rot, action_anim_alpha*action_fade_alpha);           
	         }
	      } 
         
	      //Reset shader, if any
	      if (sys_shader_exists(ds_scene[# prop._shader, ds_yindex])) {
	         shader_reset();
	      }
         
	      //Disable repeating textures
	      gpu_set_texrepeat(false);       
	   }
	}


}
