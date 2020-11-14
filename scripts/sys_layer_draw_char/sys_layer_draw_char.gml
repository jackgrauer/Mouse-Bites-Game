/// @function	sys_layer_draw_char(highlight);
/// @param		{boolean} highlight
/// @author		Lucas Chasteen <lucas.chasteen@xgasoft.com>
/// @copyright	XGASOFT 2020, All Rights Reserved
function sys_layer_draw_char(argument0) {

	/*
	==========================================================================
	SYSTEM FUNCTION: MODIFY AT YOUR OWN RISK!
	--------------------------------------------------------------------------
	  System functions are executed automatically by the engine and typically
	  should not be run manually by the user
	==========================================================================

	Draws characters and character attachments with an optional highlighting effect
	to indicate the current speaker, if any.

	argument0 = enables or disables highlighting the current speaking character(s) (boolean) (true/false)
            
	Example usage:
	   sys_layer_draw_char(true);
	*/

	/*
	CHARACTERS
	*/

	//Skip processing if vngen_object_clear has been run
	if (event_current < 0) {
	   exit;
	}

	//Ensure character highlight surface exists
	if (!surface_exists(surf_highlight)) {
	   surf_highlight = surface_create(32, 32);
	   surface_set_target(surf_highlight);
	   draw_set_alpha(0.66);
	   draw_rectangle_color(0, 0, 32, 32, c_black, c_black, c_black, c_black, false);
	   draw_set_alpha(1);
	   surface_reset_target();
	}

	//Initialize checking attachment stats
	attach_count = 0;

	//Draw characters
	var ds_xindex, ds_yindex;
	for (ds_yindex = 0; ds_yindex < ds_grid_height(ds_character); ds_yindex += 1) {
	   //If character exists...
	   if (ds_character[# prop._id, ds_yindex] != -1) {
      
	      /* BASE PROPERTIES */
         
	      //Get base character properties
	      var action_sprite = ds_character[# prop._sprite, ds_yindex];
	      var action_left = ds_character[# prop._left, ds_yindex] + ds_character[# prop._trans_left, ds_yindex];
	      var action_top = ds_character[# prop._top, ds_yindex] + ds_character[# prop._trans_top, ds_yindex];      
	      var action_width = ds_character[# prop._width, ds_yindex] + ds_character[# prop._trans_width, ds_yindex];
	      var action_height = ds_character[# prop._height, ds_yindex] + ds_character[# prop._trans_height, ds_yindex];
	      var action_xorig = ds_character[# prop._xorig, ds_yindex];
	      var action_yorig = ds_character[# prop._yorig, ds_yindex];      
	      var action_x = ds_character[# prop._x, ds_yindex] + ds_character[# prop._trans_x, ds_yindex];
	      var action_y = ds_character[# prop._y, ds_yindex] + ds_character[# prop._trans_y, ds_yindex];
	      var action_z = ds_character[# prop._z, ds_yindex];
	      var action_xscale = ds_character[# prop._xscale, ds_yindex]*ds_character[# prop._trans_xscale, ds_yindex];
	      var action_yscale = ds_character[# prop._yscale, ds_yindex]*ds_character[# prop._trans_yscale, ds_yindex];
	      var action_rot = ds_character[# prop._rot, ds_yindex] + ds_character[# prop._trans_rot, ds_yindex];
	      var action_col1 = ds_character[# prop._col1, ds_yindex];
	      var action_col2 = ds_character[# prop._col2, ds_yindex];
	      var action_col3 = ds_character[# prop._col3, ds_yindex];
	      var action_col4 = ds_character[# prop._col4, ds_yindex];
	      var action_alpha = ds_character[# prop._alpha, ds_yindex]*ds_character[# prop._trans_alpha, ds_yindex];
	      var action_face_idle = ds_character[# prop._sprite2, ds_yindex];
	      var action_face_talk = ds_character[# prop._sprite3, ds_yindex];      
	      var action_face_x = ds_character[# prop._face_x, ds_yindex];
	      var action_face_y = ds_character[# prop._face_y, ds_yindex];        
	      var action_face_pause = ds_character[# prop._pause, ds_yindex];      
	      var action_face_time = ds_character[# prop._face_time, ds_yindex];
		  var action_face_number = ds_character[# prop._number, ds_yindex];
	      var action_highlight = ds_character[# prop._hlight_alpha, ds_yindex];
	      var active_text = ds_character[# prop._txt_active, ds_yindex];
	      var active_audio = ds_character[# prop._snd_active, ds_yindex];
	  
		  /* SPRITE PROPERTIES */
	  
		  //Get sprite index
		  var action_index = ds_character[# prop._img_index, ds_yindex];
	  
		  //Animate sprite
		  if (global.vg_pause == false) {
		     ds_character[# prop._img_index, ds_yindex] += sprite_get_speed_real(action_sprite)*time_offset;
		  }
	  
		  //Loop sprite
		  if (ds_character[# prop._img_index, ds_yindex] > ds_character[# prop._img_num, ds_yindex]) {
	         ds_character[# prop._img_index, ds_yindex] -= ds_character[# prop._img_num, ds_yindex];
		  }
	  
		  //Get face sprite index
	      var action_face_index = ds_character[# prop._index, ds_yindex];
	  
		  //Animate face sprite
		  if (sprite_exists(action_face_idle)) {
			 if (global.vg_pause == false) {
		        ds_character[# prop._index, ds_yindex] = min(action_face_number, action_face_index + (sprite_get_speed_real(action_face_idle)*time_offset));
			 }
		  }
	  
		  //Pause before looping
		  if (action_face_index >= action_face_number) {
			 //Countdown pause
			 ds_character[# prop._face_time, ds_yindex] += time_frame;
		  
			 //Loop face sprite when complete
			 if (action_face_time >= action_face_pause) {
	            ds_character[# prop._face_time, ds_yindex] = 0;
	            ds_character[# prop._index, ds_yindex] = 0;
			 }
		  }

	      //Get scale offset
	      var action_offset_xscale = ds_character[# prop._oxscale, ds_yindex];
	      var action_offset_yscale = ds_character[# prop._oyscale, ds_yindex]; 
      
	      //Get sprite fade properties
	      var action_fade_surf = ds_character[# prop._fade_src, ds_yindex];
	      var action_fade_alpha = ds_character[# prop._fade_alpha, ds_yindex]; 
      
	      //Get deform surfaces
	      var action_def_surf = ds_character[# prop._def_surf, ds_yindex];
	      var action_def_fade_surf = ds_character[# prop._def_fade_surf, ds_yindex];
      
	      /* SURFACE */
      
	      //Recreate character surface, if broken
	      if (!surface_exists(ds_character[# prop._surf, ds_yindex])) {
	         ds_character[# prop._surf, ds_yindex] = surface_create(sprite_get_width(action_sprite), sprite_get_height(action_sprite));
		 
			 //Clear deform surface to be regenerated
			 if (surface_exists(ds_character[# prop._def_surf, ds_yindex])) {
			    surface_free(ds_character[# prop._def_surf, ds_yindex]);
				ds_character[# prop._def_surf, ds_yindex] = -1;
			 }
	      }
      
	      //Get character surface
	      var action_surf = ds_character[# prop._surf, ds_yindex];
      
	      //Draw surface contents
	      surface_set_target(action_surf);
	      draw_clear_alpha(c_black, 0);        
      
	      /* ATTACHMENTS */
      
	      //Get the data structure for attachments assigned to the current character
	      var ds_attach = ds_character[# prop._attach_data, ds_yindex];
      
	      //Ensure attachments data structure exists
	      if (!ds_exists(ds_attach, ds_type_grid)) {
	         ds_character[# prop._attach_data, ds_yindex] = ds_grid_create(attach_length, 0);
         
	         //Get the newly-created data structure
	         ds_attach = ds_character[# prop._attach_data, ds_yindex];
	      }
      
	      //Draw attachments, if any
	      if (ds_grid_height(ds_attach) > 0) {
	         //Get the number of attachments for dev stats, if enabled
	         if (global.vg_debug == true) {
	            attach_count += ds_grid_height(ds_attach);
	         }
         
	         //Initialize drawing the body in attachment mode
	         var attach_body = true;
      
	         //Draw attachments
	         for (ds_xindex = 0; ds_xindex < ds_grid_height(ds_attach); ds_xindex += 1) {
	            //Get basic attachment properties
	            var attach_sprite = ds_attach[# prop._sprite, ds_xindex];
	            var attach_left = ds_attach[# prop._left, ds_xindex] + ds_attach[# prop._trans_left, ds_xindex];
	            var attach_top = ds_attach[# prop._top, ds_xindex] + ds_attach[# prop._trans_top, ds_xindex];      
	            var attach_width = ds_attach[# prop._width, ds_xindex] + ds_attach[# prop._trans_width, ds_xindex];
	            var attach_height = ds_attach[# prop._height, ds_xindex] + ds_attach[# prop._trans_height, ds_xindex];
	            var attach_xorig = ds_attach[# prop._xorig, ds_xindex];
	            var attach_yorig = ds_attach[# prop._yorig, ds_xindex];  
	            var attach_x = ds_attach[# prop._x, ds_xindex] + ds_attach[# prop._trans_x, ds_xindex];
	            var attach_y = ds_attach[# prop._y, ds_xindex] + ds_attach[# prop._trans_y, ds_xindex]; 
	            var attach_z = ds_attach[# prop._z, ds_xindex];
	            var attach_xscale = ds_attach[# prop._xscale, ds_xindex]*ds_attach[# prop._trans_xscale, ds_xindex];
	            var attach_yscale = ds_attach[# prop._yscale, ds_xindex]*ds_attach[# prop._trans_xscale, ds_xindex];                                 
	            var attach_rot = ds_attach[# prop._rot, ds_xindex] + ds_attach[# prop._trans_rot, ds_xindex]; 
	            var attach_col1 = ds_attach[# prop._col1, ds_xindex];
	            var attach_col2 = ds_attach[# prop._col2, ds_xindex];
	            var attach_col3 = ds_attach[# prop._col3, ds_xindex];
	            var attach_col4 = ds_attach[# prop._col4, ds_xindex];
	            var attach_alpha = ds_attach[# prop._alpha, ds_xindex]*ds_attach[# prop._trans_alpha, ds_xindex];
	  
				/* SPRITE PROPERTIES */
	  
				//Get sprite index
				var attach_index = ds_attach[# prop._img_index, ds_xindex];
	  
				//Animate sprite
				if (global.vg_pause == false) {
				   ds_attach[# prop._img_index, ds_xindex] += sprite_get_speed_real(attach_sprite)*time_offset;
				}
			
				//Loop sprite
				if (ds_attach[# prop._img_index, ds_xindex] > ds_attach[# prop._img_num, ds_xindex]) {
			       ds_attach[# prop._img_index, ds_xindex] -= ds_attach[# prop._img_num, ds_xindex];
				}
            
	            //Get scale offset
	            var attach_offset_xscale = ds_attach[# prop._oxscale, ds_xindex];
	            var attach_offset_yscale = ds_attach[# prop._oyscale, ds_xindex];  
            
	            //Get sprite fade properties
	            var attach_fade_sprite = ds_attach[# prop._fade_src, ds_xindex];
	            var attach_fade_alpha = ds_attach[# prop._fade_alpha, ds_xindex];          
      
	            //Get deform surfaces
	            var attach_def_surf = ds_attach[# prop._def_surf, ds_xindex];
	            var attach_def_fade_surf = ds_attach[# prop._def_fade_surf, ds_xindex];       
            
	            /* BODY */
            
	            //Draw body and face at attachment z-index 0
	            if (attach_body == true) {
	               if (attach_z <= 0) {
	                  //Draw body
	                  draw_sprite(action_sprite, action_index, sprite_get_xoffset(action_sprite), sprite_get_yoffset(action_sprite));
         
	                  //If typewriter effect or voice audio for this character is active...
	                  if (active_text == true) or (active_audio == true) {
	                     //Draw talking face, if any
	                     if (sprite_exists(action_face_talk)) and (global.vg_pause == false) {
	                        draw_sprite(action_face_talk, sprite_get_index(action_face_talk), action_face_x, action_face_y); 
	                     } else {
	                        //Otherwise draw idle face instead, if any
	                        if (sprite_exists(action_face_idle)) {
	                           draw_sprite(action_face_idle, action_face_index, action_face_x, action_face_y);         
	                        }               
	                     }
	                  } else {
	                     //Draw idle face, if any, when no text or audio is active
	                     if (sprite_exists(action_face_idle)) {
	                        draw_sprite(action_face_idle, action_face_index, action_face_x, action_face_y);
	                     }
	                  }   
                  
	                  //Flag body and face as drawn--all further attachments will be drawn on top
	                  attach_body = false;                 
	               }
	            }
            
	            /* ANIMATIONS */
            
	            //Perform animation, if any
	            if (sys_anim_perform(ds_attach, ds_xindex)) {
	               //Get animation values to apply to attachment
	               var attach_anim_x = ds_attach[# prop._anim_x, ds_xindex];      
	               var attach_anim_y = ds_attach[# prop._anim_y, ds_xindex];  
	               var attach_anim_xscale = ds_attach[# prop._anim_xscale, ds_xindex];  
	               var attach_anim_yscale = ds_attach[# prop._anim_yscale, ds_xindex];
	               var attach_anim_rot = ds_attach[# prop._anim_rot, ds_xindex];  
	               var attach_anim_alpha = ds_attach[# prop._anim_alpha, ds_xindex];           
	            } else {
	               //Otherwise if no animation is playing, get defaults
	               var attach_anim_x = 0;      
	               var attach_anim_y = 0;  
	               var attach_anim_xscale = 1;  
	               var attach_anim_yscale = 1;
	               var attach_anim_rot = 0;  
	               var attach_anim_alpha = 1;  
	            }                  
            
	            /* DEFORMATIONS */
            
	            //Perform deformation, if any
	            sys_deform_perform(ds_attach, ds_xindex);
      
	            /* SHADERS */
            
	            //Perform shader, if any
	            sys_shader_perform(ds_attach, ds_xindex);  
            
	            /* DRAWING */
          
	            //Get final scale
	            attach_xscale = (attach_xscale*attach_offset_xscale)*attach_anim_xscale;
	            attach_yscale = (attach_yscale*attach_offset_yscale)*attach_anim_yscale; 
            
	            //Get final rotation
	            attach_rot = attach_rot + attach_anim_rot;      
	            point_rot_prefetch(attach_rot);
               
	            //Get scaled sprite origin
	            attach_xorig = attach_xorig*attach_xscale;
	            attach_yorig = attach_yorig*attach_yscale;    
               
	            //Get final position  
	            attach_x = attach_x - point_rot_x(attach_xorig, attach_yorig) + attach_anim_x;
	            attach_y = attach_y - point_rot_y(attach_xorig, attach_yorig) + attach_anim_y;    
      
	            //Record final properties
	            ds_attach[# prop._final_width, ds_xindex] = attach_width;
	            ds_attach[# prop._final_height, ds_xindex] = attach_height;
	            ds_attach[# prop._final_x, ds_xindex] = attach_x + point_rot_x(attach_left*attach_xscale, attach_top*attach_yscale);
	            ds_attach[# prop._final_y, ds_xindex] = attach_y + point_rot_y(attach_left*attach_xscale, attach_top*attach_yscale);
	            ds_attach[# prop._final_xscale, ds_xindex] = attach_xscale;
	            ds_attach[# prop._final_yscale, ds_xindex] = attach_yscale;
	            ds_attach[# prop._final_rot, ds_xindex] = attach_rot;
      
	            /* STANDARD */
			
	            //Draw attachment to character
	            if (ds_attach[# prop._def, ds_xindex] == -1) {
	               //Get scaled dimensions
	               attach_x = ds_attach[# prop._final_x, ds_xindex];
	               attach_y = ds_attach[# prop._final_y, ds_xindex]; 
               
	               //Draw attachment 
	               draw_sprite_general(attach_sprite, attach_index, attach_left, attach_top, attach_width, attach_height, attach_x, attach_y, attach_xscale, attach_yscale, attach_rot, attach_col1, attach_col2, attach_col3, attach_col4, (attach_alpha*attach_anim_alpha)*attach_fade_alpha);
            
	               //Draw fade sprite, if any
	               if (sprite_exists(attach_fade_sprite)) {
	                  //Reverse alpha transition to fade out
	                  attach_fade_alpha = min(1 - attach_fade_alpha, attach_alpha); 
                     
	                  draw_sprite_general(attach_fade_sprite, attach_index, 0, 0, sprite_get_width(attach_fade_sprite), sprite_get_height(attach_fade_sprite), attach_x, attach_y, attach_xscale, attach_yscale, attach_rot, attach_col1, attach_col2, attach_col3, attach_col4, attach_fade_alpha*attach_anim_alpha);
	               }
         
	            /* PRIMITIVE */
            
	            } else {                     
	               //Initialize temporary variables for drawing deformation
	               var tex_u, tex_v, tex_width, tex_height, tex_xcount, tex_ycount, tex_xindex, tex_yindex;
               
	               //Get deform surface dimensions
	               var attach_surf_width = sprite_get_width(attach_sprite);
	               var attach_surf_height = sprite_get_height(attach_sprite);
               
	               //Get texel count
	               tex_xcount = def_width - 1;
	               tex_ycount = def_height - 1;
               
	               //Get texel UV dimensions
	               tex_u = attach_surf_width/tex_xcount;
	               tex_v = attach_surf_height/tex_ycount;
                          
	               //Ensure deform surface exists
	               if (!surface_exists(attach_def_surf)) {
	                  ds_attach[# prop._def_surf, ds_xindex] = surface_create(attach_surf_width, attach_surf_height);
	                  attach_def_surf = ds_attach[# prop._def_surf, ds_xindex];
	               }
               
	               //Draw to surface for deformation
	               surface_set_target(attach_def_surf);
	               draw_clear_alpha(c_black, 0);
	               draw_sprite_general(attach_sprite, attach_index, attach_left, attach_top, attach_width, attach_height, attach_left, attach_top, 1, 1, 0, attach_col1, attach_col2, attach_col3, attach_col4, 1);

	               //Temporarily disable shader, if any
	               if (sys_shader_exists(ds_attach[# prop._shader, ds_xindex])) {
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
	               sys_deform_draw(ds_attach, ds_xindex, surface_get_texture(attach_def_surf), attach_surf_width, attach_surf_height, attach_x, attach_y, attach_xscale, attach_yscale, attach_rot, (attach_alpha*attach_anim_alpha)*attach_fade_alpha);
            
	               //Re-enable shader, if any
	               if (sys_shader_exists(ds_attach[# prop._shader, ds_xindex])) {
	                  shader_set(ds_attach[# prop._shader, ds_xindex]);
	               }
               
	               //Draw fade primitive, if any
	               if (sprite_exists(attach_fade_sprite)) {
	                  //Get fade deform surface dimensions
	                  attach_surf_width = sprite_get_width(attach_fade_sprite);
	                  attach_surf_height = sprite_get_height(attach_fade_sprite);
                  
	                  //Get texel UV dimensions
	                  tex_u = attach_surf_width/tex_xcount;
	                  tex_v = attach_surf_height/tex_ycount;
                  
	                  //Ensure fade deform surface exists
	                  if (!surface_exists(attach_def_fade_surf)) {
	                     ds_attach[# prop._def_fade_surf, ds_xindex] = surface_create(attach_surf_width, attach_surf_height);
	                     attach_def_fade_surf = ds_attach[# prop._def_fade_surf, ds_xindex];
	                  }     
            
	                  //Draw to surface for deformation
	                  surface_set_target(attach_def_fade_surf);
	                  draw_clear_alpha(c_black, 0);
	                  draw_sprite_general(attach_fade_sprite, attach_index, 0, 0, attach_surf_width, attach_surf_height, 0, 0, 1, 1, 0, attach_col1, attach_col2, attach_col3, attach_col4, 1);
            
	                  //Temporarily disable shader, if any
	                  if (sys_shader_exists(ds_attach[# prop._shader, ds_xindex])) {
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
	                  attach_fade_alpha = min(1 - attach_fade_alpha, attach_alpha); 
                     
	                  //Draw fade primitive
	                  sys_deform_draw(ds_attach, ds_xindex, surface_get_texture(attach_def_fade_surf), attach_surf_width, attach_surf_height, attach_x, attach_y, attach_xscale, attach_yscale, attach_rot, attach_fade_alpha*attach_anim_alpha);      
	               }
	            }  
			
	            //Reset shader, if any
	            if (sys_shader_exists(ds_attach[# prop._shader, ds_xindex])) {
	               shader_reset();
	            }          
	         }
         
	         //Draw body and face on top if no attachment is on top of body and face
	         if (attach_body == true) {
	            //Draw body
	            draw_sprite(action_sprite, action_index, sprite_get_xoffset(action_sprite), sprite_get_yoffset(action_sprite));
         
	            //If typewriter effect or voice audio for this character is active...
	            if (active_text == true) or (active_audio == true) {
	               //Draw talking face, if any
	               if (sprite_exists(action_face_talk)) and (global.vg_pause == false) {
	                  draw_sprite(action_face_talk, sprite_get_index(action_face_talk), action_face_x, action_face_y); 
	               } else {
	                  //Otherwise draw idle face instead, if any
	                  if (sprite_exists(action_face_idle)) {
	                     draw_sprite(action_face_idle, action_face_index, action_face_x, action_face_y);         
	                  }               
	               }
	            } else {
	               //Draw idle face, if any, when no text or audio is active
	               if (sprite_exists(action_face_idle)) {
	                  draw_sprite(action_face_idle, action_face_index, action_face_x, action_face_y);
	               }
	            } 
                  
	            //Flag body and face as drawn
	            attach_body = false;                 
	         }         
	      } else {
	         //Draw body directly, if no attachments are present
	         draw_sprite(action_sprite, action_index, sprite_get_xoffset(action_sprite), sprite_get_yoffset(action_sprite));
         
	         //If typewriter effect or voice audio for this character is active...
	         if (active_text == true) or (active_audio == true) {
	            //Draw talking face, if any
	            if (sprite_exists(action_face_talk)) and (global.vg_pause == false) {
	               draw_sprite(action_face_talk, sprite_get_index(action_face_talk), action_face_x, action_face_y); 
	            } else {
	               //Otherwise draw idle face instead, if any
	               if (sprite_exists(action_face_idle)) {
	                  draw_sprite(action_face_idle, action_face_index, action_face_x, action_face_y);         
	               }               
	            }
	         } else {
	            //Draw idle face, if any, when no text or audio is active
	            if (sprite_exists(action_face_idle)) {
	               draw_sprite(action_face_idle, action_face_index, action_face_x, action_face_y);
	            }
	         }     
	      }    
      
	      //Fade character when unhighlighted, if enabled
	      if (argument0 == true) {
	         if (surface_exists(surf_highlight)) {
	            gpu_set_blendmode_ext(bm_dest_color, bm_inv_src_alpha);
	            draw_set_alpha(action_highlight);
	            draw_surface_stretched(surf_highlight, 0, 0, sprite_get_width(action_sprite), sprite_get_height(action_sprite));
	            draw_set_alpha(1);
	            gpu_set_blendmode(bm_normal);
	         }
	      }
      
	      //End drawing to surface
	      surface_reset_target();      
      
	      /* END SURFACE */
      
	      /* ANIMATIONS */         
            
	      //Perform animation, if any
	      if (sys_anim_perform(ds_character, ds_yindex)) {
	         //Get animation values to apply to character
	         var action_anim_x = ds_character[# prop._anim_x, ds_yindex];      
	         var action_anim_y = ds_character[# prop._anim_y, ds_yindex];  
	         var action_anim_xscale = ds_character[# prop._anim_xscale, ds_yindex];  
	         var action_anim_yscale = ds_character[# prop._anim_yscale, ds_yindex];
	         var action_anim_rot = ds_character[# prop._anim_rot, ds_yindex];  
	         var action_anim_alpha = ds_character[# prop._anim_alpha, ds_yindex];           
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
	      sys_deform_perform(ds_character, ds_yindex);
      
	      /* SHADERS */
      
	      //Perform shader, if any
	      sys_shader_perform(ds_character, ds_yindex);    
            
	      /* HIGHLIGHTING */
      
	      //If highlighting is enabled...
	      if (argument0 == true) and (ds_character[# prop._hlight, ds_yindex] == false) {
	         //Fade character out when unhighlighted
	         if (action_highlight < 1) {
	            ds_character[# prop._hlight_alpha, ds_yindex] += (1 - action_highlight)*((6/time_speed)*time_offset);
	         }   
	      } else {
	         //Otherwise fade character in
	         if (action_highlight > 0) {
	            ds_character[# prop._hlight_alpha, ds_yindex] += (0 - action_highlight)*((6/time_speed)*time_offset);
	         }
	      }  
      
	      /* DRAWING */  
            
	      //Get final scale
	      action_xscale = ((action_xscale*action_offset_xscale)*action_anim_xscale)*per_zoom_char;
	      action_yscale = ((action_yscale*action_offset_yscale)*action_anim_yscale)*per_zoom_char;      
      
	      //Get final perspective
	      action_x = ((per_width - (action_x*per_zoom_char)) + ((per_width*per_zoom_char) - per_width));
	      action_y = ((per_height - (action_y*per_zoom_char)) + ((per_height*per_zoom_char) - per_height));
	      action_z = (per_strength_char*(per_zoom_char + ((action_z*-0.01)*per_zoom_char)));
	      var per_xcenter = per_x + point_rot_x(action_x, action_y, per_rot);
	      var per_ycenter = per_y + point_rot_y(action_x, action_y);        
      
	      //Get final rotation
	      action_rot = per_rot + action_rot + action_anim_rot;  
      
	      //Get scaled sprite origin
	      action_xorig = action_xorig*action_xscale;
	      action_yorig = action_yorig*action_yscale;
      
	      //Get scaled animation offset
	      action_anim_x = action_anim_x*per_zoom_char;
	      action_anim_y = action_anim_y*per_zoom_char;      
      
	      //Get final position
	      action_x = room_xoffset - point_rot_x(action_xorig, action_yorig, action_rot) - per_xcenter - (action_z*per_xoffset) + per_width + point_rot_x(action_anim_x, action_anim_y, per_rot);
	      action_y = room_yoffset - point_rot_y(action_xorig, action_yorig, action_rot) - per_ycenter - (action_z*per_yoffset) + per_height + point_rot_y(action_anim_x, action_anim_y, per_rot);
      
	      //Record final properties
	      ds_character[# prop._final_width, ds_yindex] = action_width;
	      ds_character[# prop._final_height, ds_yindex] = action_height;
	      ds_character[# prop._final_x, ds_yindex] = action_x + point_rot_x(action_left*action_xscale, action_top*action_yscale, action_rot);
	      ds_character[# prop._final_y, ds_yindex] = action_y + point_rot_y(action_left*action_xscale, action_top*action_yscale);
	      ds_character[# prop._final_xscale, ds_yindex] = action_xscale;
	      ds_character[# prop._final_yscale, ds_yindex] = action_yscale;
	      ds_character[# prop._final_rot, ds_yindex] = action_rot;
      
	      /* STANDARD */

	      //Draw character as surface if no deform is active
	      if (ds_character[# prop._def, ds_yindex] == -1) {                  
	         //Get scaled dimensions
	         action_x = ds_character[# prop._final_x, ds_yindex];
	         action_y = ds_character[# prop._final_y, ds_yindex];
                         
	         //Draw character surface
	         draw_surface_general(action_surf, action_left, action_top, action_width, action_height, action_x, action_y, action_xscale, action_yscale, action_rot, action_col1, action_col2, action_col3, action_col4, (action_alpha*action_anim_alpha)*action_fade_alpha);
            
	         //Draw fade surface, if any
	         if (surface_exists(action_fade_surf)) {
	            //Reverse alpha transition to fade out
	            action_fade_alpha = min(1 - action_fade_alpha, action_alpha); 
            
	            //Draw fade surface
	            draw_surface_general(action_fade_surf, 0, 0, surface_get_width(action_fade_surf), surface_get_height(action_fade_surf), action_x, action_y, action_xscale, action_yscale, action_rot, action_col1, action_col2, action_col3, action_col4, action_anim_alpha*action_fade_alpha);
	         }
         
	      /* PRIMITIVE */
      
	      } else {              
	         //Initialize temporary variables for drawing deformation
	         var tex_u, tex_v, tex_width, tex_height, tex_xcount, tex_ycount, tex_xindex, tex_yindex;
         
	         //Get deform surface dimensions
	         var action_surf_width = surface_get_width(action_surf);
	         var action_surf_height = surface_get_height(action_surf);
         
	         //Get texel count
	         tex_xcount = def_width - 1;
	         tex_ycount = def_height - 1;
         
	         //Get texel UV dimensions
	         tex_u = action_surf_width/tex_xcount;
	         tex_v = action_surf_height/tex_ycount;
                    
	         //Ensure deform surface exists
	         if (!surface_exists(action_def_surf)) {
	            ds_character[# prop._def_surf, ds_yindex] = surface_create(action_surf_width, action_surf_height);
	            action_def_surf = ds_character[# prop._def_surf, ds_yindex];
	         }
         
	         //Draw to surface for deformation
	         surface_set_target(action_def_surf);
	         draw_clear_alpha(c_black, 0);
	         draw_surface_general(action_surf, action_left, action_top, action_width, action_height, action_left, action_top, 1, 1, 0, action_col1, action_col2, action_col3, action_col4, 1);
         
	         //Temporarily disable shader, if any
	         if (sys_shader_exists(ds_character[# prop._shader, ds_yindex])) {
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
	         sys_deform_draw(ds_character, ds_yindex, surface_get_texture(action_def_surf), action_surf_width, action_surf_height, action_x, action_y, action_xscale, action_yscale, action_rot, (action_alpha*action_anim_alpha)*action_fade_alpha);      
         
	         //Re-enable shader, if any
	         if (sys_shader_exists(ds_character[# prop._shader, ds_yindex])) {
	            shader_set(ds_character[# prop._shader, ds_yindex]);
	         }
         
	         //Draw fade primitive, if any
	         if (surface_exists(action_fade_surf)) {
	            //Get fade deform surface dimensions
	            action_surf_width = surface_get_width(action_fade_surf);
	            action_surf_height = surface_get_height(action_fade_surf);
            
	            //Get texel UV dimensions
	            tex_u = action_surf_width/tex_xcount;
	            tex_v = action_surf_height/tex_ycount;
            
	            //Ensure fade deform surface exists
	            if (!surface_exists(action_def_fade_surf)) {
	               ds_character[# prop._def_fade_surf, ds_yindex] = surface_create(action_surf_width, action_surf_height);
	               action_def_fade_surf = ds_character[# prop._def_fade_surf, ds_yindex];
	            }     
      
	            //Draw to surface for deformation
	            surface_set_target(action_def_fade_surf);
	            draw_clear_alpha(c_black, 0);
	            draw_surface_general(action_fade_surf, 0, 0, action_surf_width, action_surf_height, 0, 0, 1, 1, 0, action_col1, action_col2, action_col3, action_col4, 1);
            
	            //Temporarily disable shader, if any
	            if (sys_shader_exists(ds_character[# prop._shader, ds_yindex])) {
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
            
	            //Draw as primitive
	            sys_deform_draw(ds_character, ds_yindex, surface_get_texture(action_def_fade_surf), action_surf_width, action_surf_height, action_x, action_y, action_xscale, action_yscale, action_rot, action_anim_alpha*action_fade_alpha);            
	         }
	      } 
         
	      //Reset shader, if any
	      if (sys_shader_exists(ds_character[# prop._shader, ds_yindex])) {
	         shader_reset();
	      } 
	   }
	}


}
