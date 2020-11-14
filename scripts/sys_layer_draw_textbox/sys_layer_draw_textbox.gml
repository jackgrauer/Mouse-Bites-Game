/// @function	sys_layer_draw_textbox();
/// @author		Lucas Chasteen <lucas.chasteen@xgasoft.com>
/// @copyright	XGASOFT 2020, All Rights Reserved
function sys_layer_draw_textbox() {

	/*
	==========================================================================
	SYSTEM FUNCTION: MODIFY AT YOUR OWN RISK!
	--------------------------------------------------------------------------
	  System functions are executed automatically by the engine and typically
	  should not be run manually by the user
	==========================================================================

	Draws textboxes.

	No parameters
            
	Example usage:
	   sys_layer_draw_textbox();
	*/

	/*
	TEXTBOXES
	*/

	//Skip processing if vngen_object_clear has been run
	if (event_current < 0) {
	   exit;
	}

	//Draw textboxes
	var ds_yindex;
	for (ds_yindex = 0; ds_yindex < ds_grid_height(ds_textbox); ds_yindex += 1) {
	   //If textbox exists...
	   if (ds_textbox[# prop._id, ds_yindex] != -1) {
      
	      /* BASE PROPERTIES */
         
	      //Get base textbox properties
	      var action_sprite = ds_textbox[# prop._sprite, ds_yindex];
	      var action_left = ds_textbox[# prop._left, ds_yindex] + ds_textbox[# prop._trans_left, ds_yindex];
	      var action_top = ds_textbox[# prop._top, ds_yindex] + ds_textbox[# prop._trans_top, ds_yindex];      
	      var action_width = ds_textbox[# prop._width, ds_yindex] + ds_textbox[# prop._trans_width, ds_yindex];
	      var action_height = ds_textbox[# prop._height, ds_yindex] + ds_textbox[# prop._trans_height, ds_yindex];
	      var action_xorig = ds_textbox[# prop._xorig, ds_yindex];
	      var action_yorig = ds_textbox[# prop._yorig, ds_yindex];
	      var action_x = ds_textbox[# prop._x, ds_yindex] + ds_textbox[# prop._trans_x, ds_yindex];
	      var action_y = ds_textbox[# prop._y, ds_yindex] + ds_textbox[# prop._trans_y, ds_yindex];
	      var action_xscale = ds_textbox[# prop._xscale, ds_yindex]*ds_textbox[# prop._trans_xscale, ds_yindex];
	      var action_yscale = ds_textbox[# prop._yscale, ds_yindex]*ds_textbox[# prop._trans_yscale, ds_yindex];
	      var action_rot = ds_textbox[# prop._rot, ds_yindex] + ds_textbox[# prop._trans_rot, ds_yindex];
	      var action_col1 = ds_textbox[# prop._col1, ds_yindex];
	      var action_col2 = ds_textbox[# prop._col2, ds_yindex];
	      var action_col3 = ds_textbox[# prop._col3, ds_yindex];
	      var action_col4 = ds_textbox[# prop._col4, ds_yindex];
	      var action_alpha = ds_textbox[# prop._alpha, ds_yindex]*ds_textbox[# prop._trans_alpha, ds_yindex];
	  
		  /* SPRITE PROPERTIES */
	  
		  //Get sprite index
		  var action_index = ds_textbox[# prop._img_index, ds_yindex];
	  
		  //Animate sprite
		  if (global.vg_pause == false) {
		     ds_textbox[# prop._img_index, ds_yindex] += sprite_get_speed_real(action_sprite)*time_offset;
		  }
	  
		  //Loop sprite
		  if (ds_textbox[# prop._img_index, ds_yindex] > ds_textbox[# prop._img_num, ds_yindex]) {
	         ds_textbox[# prop._img_index, ds_yindex] -= ds_textbox[# prop._img_num, ds_yindex];
		  }

	      //Get scale offset
	      var action_offset_xscale = ds_textbox[# prop._oxscale, ds_yindex];
	      var action_offset_yscale = ds_textbox[# prop._oyscale, ds_yindex]; 
      
	      //Get sprite fade properties
	      var action_fade_sprite = ds_textbox[# prop._fade_src, ds_yindex];
	      var action_fade_alpha = ds_textbox[# prop._fade_alpha, ds_yindex];
      
	      //Get deform surfaces
	      var action_def_surf = ds_textbox[# prop._def_surf, ds_yindex];
	      var action_def_fade_surf = ds_textbox[# prop._def_fade_surf, ds_yindex];   
      
	      /* ANIMATIONS */
            
	      //Perform animation, if any
	      if (sys_anim_perform(ds_textbox, ds_yindex)) {
	         //Get animation values to apply to textbox
	         var action_anim_x = ds_textbox[# prop._anim_x, ds_yindex];      
	         var action_anim_y = ds_textbox[# prop._anim_y, ds_yindex];  
	         var action_anim_xscale = ds_textbox[# prop._anim_xscale, ds_yindex];  
	         var action_anim_yscale = ds_textbox[# prop._anim_yscale, ds_yindex];
	         var action_anim_rot = ds_textbox[# prop._anim_rot, ds_yindex];  
	         var action_anim_alpha = ds_textbox[# prop._anim_alpha, ds_yindex];           
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
	      sys_deform_perform(ds_textbox, ds_yindex);
      
	      /* SHADERS */
      
	      //Perform shader, if any
	      sys_shader_perform(ds_textbox, ds_yindex);    
      
	      /* DRAWING */
            
	      //Get final scale
	      action_xscale = (action_xscale*action_offset_xscale)*action_anim_xscale;
	      action_yscale = (action_yscale*action_offset_yscale)*action_anim_yscale;
      
	      //Get final rotation
	      action_rot = action_rot + action_anim_rot;
	      point_rot_prefetch(action_rot);     
      
	      //Get scaled sprite origin
	      action_xorig = action_xorig*action_xscale;
	      action_yorig = action_yorig*action_yscale;   
      
	      //Get final position
	      action_x = room_xoffset - point_rot_x(action_xorig, action_yorig) + action_x + action_anim_x;
	      action_y = room_yoffset - point_rot_y(action_xorig, action_yorig) + action_y + action_anim_y;
      
	      //Record final properties
	      ds_textbox[# prop._final_width, ds_yindex] = action_width;
	      ds_textbox[# prop._final_height, ds_yindex] = action_height;
	      ds_textbox[# prop._final_x, ds_yindex] = action_x + point_rot_x(action_left*action_xscale, action_top*action_yscale);
	      ds_textbox[# prop._final_y, ds_yindex] = action_y + point_rot_y(action_left*action_xscale, action_top*action_yscale);
	      ds_textbox[# prop._final_xscale, ds_yindex] = action_xscale;
	      ds_textbox[# prop._final_yscale, ds_yindex] = action_yscale;
	      ds_textbox[# prop._final_rot, ds_yindex] = action_rot;
      
	      /* STANDARD */

	      //Draw textbox
	      if (ds_textbox[# prop._def, ds_yindex] == -1) {    
	         //Get scaled dimensions
	         action_x = ds_textbox[# prop._final_x, ds_yindex];
	         action_y = ds_textbox[# prop._final_y, ds_yindex];

	         //Draw as sprite if no deform is active
	         draw_sprite_general(action_sprite, action_index, action_left, action_top, action_width, action_height, action_x, action_y, action_xscale, action_yscale, action_rot, action_col1, action_col2, action_col3, action_col4, ((action_alpha*action_anim_alpha)*action_fade_alpha)*global.vg_ui_alpha);
      
	         //Draw fade sprite, if any
	         if (sprite_exists(action_fade_sprite)) {
	            //Reverse alpha transition to fade out
	            action_fade_alpha = min(1 - action_fade_alpha, action_alpha);
                     
	            draw_sprite_general(action_fade_sprite, action_index, 0, 0, sprite_get_width(action_fade_sprite), sprite_get_height(action_fade_sprite), action_x, action_y, action_xscale, action_yscale, action_rot, action_col1, action_col2, action_col3, action_col4, (action_anim_alpha*action_fade_alpha)*global.vg_ui_alpha);
	         }
         
	      /* PRIMITIVE */
      
	      } else {       
	         //Initialize temporary variables for drawing deformation
	         var tex_u, tex_v, tex_width, tex_height, tex_xcount, tex_ycount, tex_xindex, tex_yindex;

	         //Get deform surface dimensions
	         var action_surf_width = sprite_get_width(action_sprite);
	         var action_surf_height = sprite_get_height(action_sprite);
         
	         //Get texel count
	         tex_xcount = def_width - 1;
	         tex_ycount = def_height - 1;
         
	         //Get texel UV dimensions
	         tex_u = action_surf_width/tex_xcount;
	         tex_v = action_surf_height/tex_ycount;
                    
	         //Ensure deform surface exists
	         if (!surface_exists(action_def_surf)) {
	            ds_textbox[# prop._def_surf, ds_yindex] = surface_create(action_surf_width, action_surf_height);
	            action_def_surf = ds_textbox[# prop._def_surf, ds_yindex];
	         }
         
	         //Draw to surface for deformation
	         surface_set_target(action_def_surf);
	         draw_clear_alpha(c_black, 0);
	         draw_sprite_general(action_sprite, action_index, action_left, action_top, action_width, action_height, action_left, action_top, 1, 1, 0, action_col1, action_col2, action_col3, action_col4, 1);
         
	         //Temporarily disable shader, if any
	         if (sys_shader_exists(ds_textbox[# prop._shader, ds_yindex])) {
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
	         sys_deform_draw(ds_textbox, ds_yindex, surface_get_texture(action_def_surf), action_surf_width, action_surf_height, action_x, action_y, action_xscale, action_yscale, action_rot, ((action_alpha*action_anim_alpha)*action_fade_alpha)*global.vg_ui_alpha);
         
	         //Re-enable shader, if any
	         if (sys_shader_exists(ds_textbox[# prop._shader, ds_yindex])) {
	            shader_set(ds_textbox[# prop._shader, ds_yindex]);
	         }
            
	         //Draw fade primitive, if any
	         if (sprite_exists(action_fade_sprite)) {
	            //Get fade deform surface dimensions
	            action_surf_width = sprite_get_width(action_fade_sprite);
	            action_surf_height = sprite_get_height(action_fade_sprite);
            
	            //Get texel UV dimensions
	            tex_u = action_surf_width/tex_xcount;
	            tex_v = action_surf_height/tex_ycount;
            
	            //Ensure fade deform surface exists
	            if (!surface_exists(action_def_fade_surf)) {
	               ds_textbox[# prop._def_fade_surf, ds_yindex] = surface_create(action_surf_width, action_surf_height);
	               action_def_fade_surf = ds_textbox[# prop._def_fade_surf, ds_yindex];
	            }     
      
	            //Draw to surface for deformation
	            surface_set_target(action_def_fade_surf);
	            draw_clear_alpha(c_black, 0);
	            draw_sprite_general(action_fade_sprite, action_index, 0, 0, action_surf_width, action_surf_height, 0, 0, 1, 1, 0, action_col1, action_col2, action_col3, action_col4, 1);
            
	            //Temporarily disable shader, if any
	            if (sys_shader_exists(ds_textbox[# prop._shader, ds_yindex])) {
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
	            sys_deform_draw(ds_textbox, ds_yindex, surface_get_texture(action_def_fade_surf), action_surf_width, action_surf_height, action_x, action_y, action_xscale, action_yscale, action_rot, (action_anim_alpha*action_fade_alpha)*global.vg_ui_alpha);      
	         }
	      } 
         
	      //Reset shader, if any
	      if (sys_shader_exists(ds_textbox[# prop._shader, ds_yindex])) {
	         shader_reset();
	      }        
	   }
	}


}
