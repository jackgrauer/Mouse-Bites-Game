/// @function	sys_layer_draw_prompt_legacy();
/// @author		Lucas Chasteen <lucas.chasteen@xgasoft.com>
/// @copyright	XGASOFT 2020, All Rights Reserved
function sys_layer_draw_prompt_legacy() {

	/*
	==========================================================================
	SYSTEM FUNCTION: MODIFY AT YOUR OWN RISK!
	--------------------------------------------------------------------------
	  System functions are executed automatically by the engine and typically
	  should not be run manually by the user
	==========================================================================

	Draws prompts with reduced rendering features for performance and compatibility 
	with low-end platforms. 

	No parameters
            
	Example usage:
	   sys_layer_draw_prompt_legacy();
	*/

	/*
	PROMPTS
	*/

	//Skip processing if vngen_object_clear has been run
	if (event_current < 0) {
	   exit;
	}

	//Draw prompts
	var ds_xindex, ds_yindex;
	for (ds_yindex = 0; ds_yindex < ds_grid_height(ds_prompt); ds_yindex += 1) {
	   //If prompt exists...
	   if (ds_prompt[# prop._id, ds_yindex] != -1) {
	      //If auto mode is enabled, enable drawing multiple prompts for each speaker
	      if (ds_prompt[# prop._x, ds_yindex] == auto) or (ds_prompt[# prop._y, ds_yindex] == auto) {
	         var action_trigger_count = ds_grid_height(ds_text);
	      } else {
	         //Otherwise draw just one prompt
	         var action_trigger_count = min(1, ds_grid_height(ds_text));
	      }
      
	      //Draw prompts
	      for (ds_xindex = 0; ds_xindex < action_trigger_count; ds_xindex += 1) {       
      
	         /* BASE PROPERTIES */
         
	         //Get base prompt properties
	         var action_char = true;
	         var action_sprite_wait = ds_prompt[# prop._sprite2, ds_yindex];
	         var action_left = ds_prompt[# prop._left, ds_yindex] + ds_prompt[# prop._trans_left, ds_yindex];
	         var action_top = ds_prompt[# prop._top, ds_yindex] + ds_prompt[# prop._trans_top, ds_yindex];       
	         var action_width = ds_prompt[# prop._width, ds_yindex] + ds_prompt[# prop._trans_width, ds_yindex];
	         var action_height = ds_prompt[# prop._height, ds_yindex] + ds_prompt[# prop._trans_height, ds_yindex];
	         var action_xorig = ds_prompt[# prop._xorig, ds_yindex];
	         var action_yorig = ds_prompt[# prop._yorig, ds_yindex];
	         var action_x = ds_prompt[# prop._x, ds_yindex] + ds_prompt[# prop._trans_x, ds_yindex];
	         var action_y = ds_prompt[# prop._y, ds_yindex] + ds_prompt[# prop._trans_y, ds_yindex];
	         var action_xscale = ds_prompt[# prop._xscale, ds_yindex]*ds_prompt[# prop._trans_xscale, ds_yindex];
	         var action_yscale = ds_prompt[# prop._yscale, ds_yindex]*ds_prompt[# prop._trans_yscale, ds_yindex];
	         var action_rot = ds_prompt[# prop._rot, ds_yindex] + ds_prompt[# prop._trans_rot, ds_yindex];
	         var action_col1 = ds_prompt[# prop._col1, ds_yindex];
	         var action_col2 = ds_prompt[# prop._col2, ds_yindex];
	         var action_col3 = ds_prompt[# prop._col3, ds_yindex];
	         var action_col4 = ds_prompt[# prop._col4, ds_yindex];
	         var action_alpha = ds_prompt[# prop._alpha, ds_yindex]*ds_prompt[# prop._trans_alpha, ds_yindex];
	         var action_sprite_active = ds_prompt[# prop._sprite3, ds_yindex];
	         var action_sprite_auto = ds_prompt[# prop._sprite, ds_yindex];
			 var action_state = ds_prompt[# prop._index, ds_yindex];
	         var action_trigger = ds_prompt[# prop._trigger, ds_yindex];
      
	         //Set default sprite
	         var action_sprite = action_sprite_wait;

	         //Get scale offset
	         var action_offset_xscale = ds_prompt[# prop._oxscale, ds_yindex];
	         var action_offset_yscale = ds_prompt[# prop._oyscale, ds_yindex]; 
      
	         //Get sprite fade properties
	         var action_fade_sprite = ds_prompt[# prop._fade_src, ds_yindex];
	         var action_fade_alpha = ds_prompt[# prop._fade_alpha, ds_yindex];   
      
	         /* ANIMATIONS */
            
	         //Perform animation, if any
	         if (ds_xindex == 0) {
	            if (sys_anim_perform(ds_prompt, ds_yindex)) {
	               //Get animation values to apply to prompt
	               var action_anim_x = ds_prompt[# prop._anim_x, ds_yindex];      
	               var action_anim_y = ds_prompt[# prop._anim_y, ds_yindex];  
	               var action_anim_xscale = ds_prompt[# prop._anim_xscale, ds_yindex];  
	               var action_anim_yscale = ds_prompt[# prop._anim_yscale, ds_yindex];
	               var action_anim_rot = ds_prompt[# prop._anim_rot, ds_yindex];  
	               var action_anim_alpha = ds_prompt[# prop._anim_alpha, ds_yindex];           
	            } else {
	               //Otherwise if no animation is playing, get defaults
	               var action_anim_x = 0;      
	               var action_anim_y = 0;  
	               var action_anim_xscale = 1;  
	               var action_anim_yscale = 1;
	               var action_anim_rot = 0;  
	               var action_anim_alpha = 1;  
	            }   
	         }
      
	         /* DRAWING */
     
	         //Get the prompt state
	         if (action_trigger != any) {
	            //Disable drawing when associated character is inactive
	            action_char = false;
            
	            //Check speaking character and enable drawing if active
	            if (ds_text[# prop._name, ds_xindex] == action_trigger) {
	               action_char = true;
	            }
	         } else {
	            //Otherwise enable drawing for all speakers
	            action_char = true;
	         }

	         //Draw prompt, if active
	         if (action_char == true) { 
	            //Automatically position after text, if enabled
	            if (action_x == auto) or (action_y == auto) {
	               //Get text properties for drawing relative to text
	               var text_xorig = ds_text[# prop._xorig, ds_xindex];
	               var text_yorig = ds_text[# prop._yorig, ds_xindex];
	               var text_xscale = ds_text[# prop._xscale, ds_xindex];
	               var text_yscale = ds_text[# prop._yscale, ds_xindex];
	               var text_rot = ds_text[# prop._rot, ds_xindex];
	               var text_x = ds_text[# prop._x, ds_xindex];
	               var text_y = ds_text[# prop._y, ds_xindex];
	               var text_offset_xscale = ds_text[# prop._oxscale, ds_xindex];
	               var text_offset_yscale = ds_text[# prop._oyscale, ds_xindex];
	               var text_anim_x = ds_text[# prop._anim_x, ds_xindex];
	               var text_anim_y = ds_text[# prop._anim_y, ds_xindex];
	               var text_char_x = ds_text[# prop._char_x, ds_xindex]*text_xscale;
	               var text_char_y = ds_text[# prop._char_y, ds_xindex]*text_yscale;
 
	               //Get text rotation
	               point_rot_prefetch(text_rot);
               
	               //Get text scale      
	               text_xscale = (text_xscale*text_offset_xscale);
	               text_yscale = (text_yscale*text_offset_yscale);
			   
				   //Match current text scale
				   action_xscale *= text_xscale;
				   action_yscale *= text_yscale;
			   
				   //Match current text rotation
				   action_rot += text_rot;
               
	               //Match current text character position
	               action_x = -point_rot_x(text_xorig, text_yorig) + text_x + point_rot_x(text_char_x, text_char_y) + text_anim_x;
	               action_y = -point_rot_y(text_xorig, text_yorig) + text_y + point_rot_y(text_char_x, text_char_y) + text_anim_y;
	            } 
            
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
	            ds_prompt[# prop._final_width, ds_yindex] = action_width;
	            ds_prompt[# prop._final_height, ds_yindex] = action_height;
	            ds_prompt[# prop._final_x, ds_yindex] = action_x + point_rot_x(action_left*action_xscale, action_top*action_yscale);
	            ds_prompt[# prop._final_y, ds_yindex] = action_y + point_rot_y(action_left*action_xscale, action_top*action_yscale);
	            ds_prompt[# prop._final_xscale, ds_yindex] = action_xscale;
	            ds_prompt[# prop._final_yscale, ds_yindex] = action_yscale;
	            ds_prompt[# prop._final_rot, ds_yindex] = action_rot;
            
	            //Set sprite mode
	            if (global.vg_text_auto == false) {
	               if (ds_text[# prop._index, ds_xindex] < ds_text[# prop._number, ds_xindex]) and (text_pause == false) {
	                  //Draw active sprite if text is incomplete
	                  action_sprite = action_sprite_active;
				  
	                  //Set prompt state
					  if (action_state != 3) {
						 ds_prompt[# prop._index, ds_yindex] = 3;
					  }
	               } else {
	                  //Draw waiting sprite if text is complete
	                  action_sprite = action_sprite_wait;
				  
	                  //Set prompt state
					  if (action_state != 2) {
						 ds_prompt[# prop._index, ds_yindex] = 2;
					  }
	               }
	            } else {
	               //Draw auto mode sprite if auto mode is enabled
	               action_sprite = action_sprite_auto;
			   
				   //Set prompt state
				   if (action_state != 1) {
				      ds_prompt[# prop._index, ds_yindex] = 1;
				   }	   
	            }
            
	            //Get scaled dimensions
	            action_x = ds_prompt[# prop._final_x, ds_yindex];
	            action_y = ds_prompt[# prop._final_y, ds_yindex];
   
	            //Draw as sprite if no deform is active
	            if (sprite_exists(action_sprite)) {
	               draw_sprite_general(action_sprite, sprite_get_index(action_sprite), action_left, action_top, action_width, action_height, action_x, action_y, action_xscale, action_yscale, action_rot, action_col1, action_col2, action_col3, action_col4, ((action_alpha*action_anim_alpha)*action_fade_alpha)*global.vg_ui_alpha);
	            }
            
	            //Draw fade sprite, if any
	            if (sprite_exists(action_fade_sprite)) {
	               //Reverse alpha transition to fade out
	               action_fade_alpha = min(1 - action_fade_alpha, action_alpha);
                  
	               draw_sprite_general(action_fade_sprite, sprite_get_index(action_fade_sprite), 0, 0, sprite_get_width(action_fade_sprite), sprite_get_height(action_fade_sprite), action_x, action_y, action_xscale, action_yscale, action_rot, action_col1, action_col2, action_col3, action_col4, (action_anim_alpha*action_fade_alpha)*global.vg_ui_alpha);
	            }
	         }         
	      }
	   }
	}


}
