/// @function	sys_anim_perform(entity, index);
/// @param		{integer}	entity
/// @param		{integer}	index
/// @author		Lucas Chasteen <lucas.chasteen@xgasoft.com>
/// @copyright	XGASOFT 2020, All Rights Reserved
function sys_anim_perform(argument0, argument1) {

	/*
	==========================================================================
	SYSTEM FUNCTION: MODIFY AT YOUR OWN RISK!
	--------------------------------------------------------------------------
	  System functions are executed automatically by the engine and typically
	  should not be run manually by the user
	==========================================================================

	Performs animations which have been initialized with sys_anim_init on compatible 
	entities. Also returns true or false depending on whether the animation script 
	exists.

	VNgen's handling of this functionality is highly tailored for its particular
	use-cases and is not intended for general use.

	argument0 = the data structure for the entity to apply animation to (integer)
	argument1 = the index of the row containing the target entity ID (integer)

	Example usage:
	   sys_anim_perform(ds_scene, ds_target);
	*/

	/*
	INITIALIZATION
	*/

	//Get the target data structure
	var ds_data = argument0;
	var ds_target = argument1;
	var ds_anim = ds_data[# prop._anim, ds_target];
	var anim_active = true;


	/*
	PERFORM ANIMATIONS
	*/
            
	//Perform animation, if any
	if (ds_anim != -1) {
	   //Clear previous keyframe values
	   anim_x = 0;
	   anim_y = 0;      
	   anim_xscale = 1;
	   anim_yscale = 1;
	   anim_rot = 0;
	   anim_col1 = ds_data[# prop._anim_col1, ds_target];
	   anim_col2 = ds_data[# prop._anim_col2, ds_target];
	   anim_col3 = ds_data[# prop._anim_col3, ds_target];
	   anim_col4 = ds_data[# prop._anim_col4, ds_target];
	   anim_alpha = 1;
	   anim_ease = 0;
	   keyframe_count = 0;
   
	   //Perspective only
	   anim_xoffset = 0;
	   anim_yoffset = 0;   
   
	   //Text only
	   if (ds_data == ds_text) or (ds_data == ds_label) {
	      anim_col1 = c_white;
	      anim_col2 = c_white;
	      anim_col3 = c_white;
	      anim_col4 = c_white;
	   }
         
	   //Get dimensions to pass into scripts
	   input_width  = ds_data[# prop._width, ds_target];
	   input_height = ds_data[# prop._height, ds_target];
	   input_x = ds_data[# prop._x, ds_target];
	   input_y = ds_data[# prop._y, ds_target];
	   input_xscale = ds_data[# prop._xscale, ds_target]*ds_data[# prop._oxscale, ds_target];
	   input_yscale = ds_data[# prop._yscale, ds_target]*ds_data[# prop._oyscale, ds_target];
	   input_rot = ds_data[# prop._rot, ds_target];
                  
	   //Get animation keyframe data
	   if (script_exists(ds_anim)) {            
	      //Reset keyframe ID tracking
	      keyframe_id = -1;
            
	      //Get current keyframe
	      keyframe_current = ds_data[# prop._anim_key, ds_target];
            
	      //Get animation keyframe data
	      script_execute(ds_anim);
            
	      //Get total number of keyframes
	      keyframe_count = keyframe_id;
            
	      //Get animation duration for playing
	      var action_anim_duration = ds_data[# prop._anim_dur, ds_target]/(keyframe_count + 1);             
	   } else {
	      //Get animation duration for stopping
	      var action_anim_duration = ds_data[# prop._anim_dur, ds_target];                    
	   }       

	   //Get keyframe target based on transition direction
	   if (ds_data[# prop._anim_rev, ds_target] == false) {
	      //Forwards
	      var keyframe_target = keyframe_count;
	      var keyframe_loop = 0;
	      var key = 1;
	   } else {
	      //Backwards
	      var keyframe_target = 0;
	      var keyframe_loop = keyframe_count;
	      var key = -1;
	   }
         
	   //Increment animation time/keyframes
	   if (ds_data[# prop._anim_time, ds_target] <= action_anim_duration) {
	      //Count up animation time
	      if (global.vg_pause == false) {
	         ds_data[# prop._anim_time, ds_target] += time_frame;
	      }
               
	      //Continue to next keyframe when complete
	      if (ds_data[# prop._anim_time, ds_target] > action_anim_duration) {               
	         //Update animation temp values
	         ds_data[# prop._anim_tmp_x, ds_target] = ds_data[# prop._anim_x, ds_target];           //X
	         ds_data[# prop._anim_tmp_y, ds_target] = ds_data[# prop._anim_y, ds_target];           //Y
	         ds_data[# prop._anim_tmp_xscale, ds_target] = ds_data[# prop._anim_xscale, ds_target]; //X scale (Perspective zoom)
	         ds_data[# prop._anim_tmp_yscale, ds_target] = ds_data[# prop._anim_yscale, ds_target]; //Y scale (Perspective strength)
	         ds_data[# prop._anim_tmp_rot, ds_target] = ds_data[# prop._anim_rot, ds_target];       //Rotation
	         ds_data[# prop._anim_tmp_col1, ds_target] = ds_data[# prop._col1, ds_target];          //Color1
	         ds_data[# prop._anim_tmp_col2, ds_target] = ds_data[# prop._col2, ds_target];          //Color2
	         ds_data[# prop._anim_tmp_col3, ds_target] = ds_data[# prop._col3, ds_target];          //Color3
	         ds_data[# prop._anim_tmp_col4, ds_target] = ds_data[# prop._col4, ds_target];          //Color4
	         ds_data[# prop._anim_tmp_alpha, ds_target] = ds_data[# prop._anim_alpha, ds_target];   //Alpha     
         
	         //Perspective only
	         if (ds_data == ds_perspective) {
	            ds_data[# prop._anim_tmp_xoffset, 0] = ds_data[# prop._anim_xoffset, 0];            //X offset
	            ds_data[# prop._anim_tmp_yoffset, 0] = ds_data[# prop._anim_yoffset, 0];            //Y offset            
	         }
         
	         //Text only
	         if (ds_data == ds_text) or (ds_data == ds_label) {
	            ds_data[# prop._anim_tmp_col1, ds_target] = ds_data[# prop._anim_col1, ds_target];  //Color1
	            ds_data[# prop._anim_tmp_col2, ds_target] = ds_data[# prop._anim_col2, ds_target];  //Color2
	            ds_data[# prop._anim_tmp_col3, ds_target] = ds_data[# prop._anim_col3, ds_target];  //Color3
	            ds_data[# prop._anim_tmp_col4, ds_target] = ds_data[# prop._anim_col4, ds_target];  //Color4            
	         }
               
	         //Reset time for next keyframe
	         ds_data[# prop._anim_time, ds_target] = 0;
                              
	         //Increment keyframes, if animation is incomplete
	         if (ds_data[# prop._anim_key, ds_target] != keyframe_target) { 
	            ds_data[# prop._anim_key, ds_target] += key;
	         } else {
	            //Otherwise loop animation, if enabled                  
	            if (ds_data[# prop._anim_loop, ds_target] == true) {
	               //If loop is enabled, restart the animation
	               ds_data[# prop._anim_key, ds_target] = keyframe_loop;
	            } else {
	               //If loop is disabled, end the animation
	               if (ds_anim != -1) {
	                  if (ds_anim == -2) {
	                     //If all values are reset, end the animation
	                     ds_data[# prop._anim, ds_target] = -1;
	                     ds_data[# prop._anim_time, ds_target] = action_anim_duration;
            
	                     //Flag animation as inactive
	                     anim_active = false;
	                  } else {
	                     //Otherwise flag values for reset
	                     ds_data[# prop._anim, ds_target] = -2;
	                     ds_data[# prop._anim_key, ds_target] = 0;
                           
	                     //Set animation reset time
	                     ds_data[# prop._anim_dur, ds_target] = ds_data[# prop._anim_dur, ds_target]/(keyframe_count + 1);  
	                  }
	               }
	            }
	         }               
	      }
	   }           
   
	   //Get ease mode override, if any
	   if (ds_data[# prop._anim_ease, ds_target] > 0) {
	      anim_ease = ds_data[# prop._anim_ease, ds_target];
	   }
         
	   //Get current animation time
	   var action_anim_time = interp(0, 1, ds_data[# prop._anim_time, ds_target]/action_anim_duration, anim_ease);
         
	   //Clamp color interpolation
	   var color_anim_time = clamp(action_anim_time, 0, 1);
            
	   //Perform animation keyframes
	   ds_data[# prop._anim_x, ds_target] = lerp(ds_data[# prop._anim_tmp_x, ds_target], anim_x, action_anim_time);                   //X
	   ds_data[# prop._anim_y, ds_target] = lerp(ds_data[# prop._anim_tmp_y, ds_target], anim_y, action_anim_time);                   //Y
	   ds_data[# prop._anim_xscale, ds_target] = lerp(ds_data[# prop._anim_tmp_xscale, ds_target], anim_xscale, action_anim_time);    //X scale
	   ds_data[# prop._anim_yscale, ds_target] = lerp(ds_data[# prop._anim_tmp_yscale, ds_target], anim_yscale, action_anim_time);    //Y scale
	   ds_data[# prop._anim_rot, ds_target] = lerp(ds_data[# prop._anim_tmp_rot, ds_target], anim_rot, action_anim_time);             //Rotation
	   ds_data[# prop._anim_alpha, ds_target] = lerp(ds_data[# prop._anim_tmp_alpha, ds_target], anim_alpha, action_anim_time);       //Alpha 
   
	   //Perspective only
	   if (ds_data == ds_perspective) {
	      ds_data[# prop._anim_xoffset, 0] = lerp(ds_data[# prop._anim_tmp_xoffset, 0], anim_xoffset, action_anim_time);              //X offset
	      ds_data[# prop._anim_yoffset, 0] = lerp(ds_data[# prop._anim_tmp_yoffset, 0], anim_yoffset, action_anim_time);              //Y offset 
	   }
   
	   //Text only
	   if (ds_data == ds_text) or (ds_data == ds_label) {  
	      ds_data[# prop._anim_col1, ds_target] = merge_color(ds_data[# prop._anim_tmp_col1, ds_target], anim_col1, color_anim_time); //Color1
	      ds_data[# prop._anim_col2, ds_target] = merge_color(ds_data[# prop._anim_tmp_col2, ds_target], anim_col2, color_anim_time); //Color2
	      ds_data[# prop._anim_col3, ds_target] = merge_color(ds_data[# prop._anim_tmp_col3, ds_target], anim_col3, color_anim_time); //Color3
	      ds_data[# prop._anim_col4, ds_target] = merge_color(ds_data[# prop._anim_tmp_col4, ds_target], anim_col4, color_anim_time); //Color4    
	   } else {
	      //Other entities
	      ds_data[# prop._col1, ds_target] = merge_color(ds_data[# prop._anim_tmp_col1, ds_target], anim_col1, color_anim_time);      //Color1
	      ds_data[# prop._col2, ds_target] = merge_color(ds_data[# prop._anim_tmp_col2, ds_target], anim_col2, color_anim_time);      //Color2
	      ds_data[# prop._col3, ds_target] = merge_color(ds_data[# prop._anim_tmp_col3, ds_target], anim_col3, color_anim_time);      //Color3
	      ds_data[# prop._col4, ds_target] = merge_color(ds_data[# prop._anim_tmp_col4, ds_target], anim_col4, color_anim_time);      //Color4
	   }    
	} else {
	   //Otherwise flag animation as inactive
	   anim_active = false;
	}
   
	//Return animation state
	return anim_active;


}
