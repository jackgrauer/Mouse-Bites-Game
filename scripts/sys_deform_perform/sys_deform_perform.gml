/// @function	sys_deform_perform(entity, index);
/// @param		{integer}	entity
/// @param		{integer}	index
/// @author		Lucas Chasteen <lucas.chasteen@xgasoft.com>
/// @copyright	XGASOFT 2020, All Rights Reserved
function sys_deform_perform(argument0, argument1) {

	/*
	==========================================================================
	SYSTEM FUNCTION: MODIFY AT YOUR OWN RISK!
	--------------------------------------------------------------------------
	  System functions are executed automatically by the engine and typically
	  should not be run manually by the user
	==========================================================================

	Performs deformations which have been initialized with sys_deform_init on compatible 
	entities. Also returns true or false depending on whether the deformation script exists.

	VNgen's handling of this functionality is highly tailored for its particular
	use-cases and is not intended for general use.

	argument0 = the data structure for the entity to apply deformation to (integer)
	argument1 = the index of the row containing the target entity ID (integer)

	Example usage:
	   sys_deform_perform(ds_scene, ds_target);
	*/

	/*
	INITIALIZATION
	*/

	//Get the target data structure
	var ds_data = argument0;
	var ds_target = argument1;
	var ds_def = ds_data[# prop._def, ds_target];
	var def_active = true;


	/*
	PERFORM DEFORMATIONS
	*/
   
	//Perform deformation, if any
	if (ds_def != -1) {
	   //Ensure point data structure exists
	   if (!ds_exists(ds_data[# prop._def_point_data, ds_target], ds_type_grid)) {
	      ds_data[# prop._def_point_data, ds_target] = ds_grid_create(4, 0);
	   }
   
	   //Get point data
	   var ds_point = ds_data[# prop._def_point_data, ds_target];
	   var ds_xindex, ds_yindex;
   
	   //Set default deformation dimensions
	   def_width = 2;
	   def_height = 4;      
   
	   //Get dimensions from deformation, if any
	   if (script_exists(ds_def)) {
	      keyframe_id = -1;
	      keyframe_current = -1;
	      script_execute(ds_def);
	   }
   
	   //Scale point data structure to match deformation dimensions
	   if (ds_grid_height(ds_point) != def_width*def_height) {
	      ds_grid_resize(ds_point, ds_grid_width(ds_point), def_width*def_height);
	   }
   
	   //Clear previous keyframe values
	   def_xpoint = -1;
	   def_ypoint = -1;
	   def_xpoint = array_create_2d(def_width, def_height);
	   def_ypoint = array_create_2d(def_width, def_height);
	   def_ease = 0;
	   keyframe_count = 0;
         
	   //Get dimensions to pass into scripts
	   input_width  = ds_data[# prop._width, ds_target];
	   input_height = ds_data[# prop._height, ds_target];
	   input_x = ds_data[# prop._x, ds_target];
	   input_y = ds_data[# prop._y, ds_target];
	   input_xscale = ds_data[# prop._xscale, ds_target]*ds_data[# prop._oxscale, ds_target];
	   input_yscale = ds_data[# prop._yscale, ds_target]*ds_data[# prop._oyscale, ds_target];         
	   input_rot = ds_data[# prop._rot, ds_target];
                  
	   //Get deformation keyframe data
	   if (script_exists(ds_def)) {         
	      //Reset keyframe ID tracking
	      keyframe_id = -1;
             
	      //Get current keyframe
	      keyframe_current = ds_data[# prop._def_key, ds_target];
            
	      //Get deformation keyframe data
	      script_execute(ds_def);
      
	      //Clamp points to window dimensions, if tiled
	      if (ds_data == ds_scene) {
	         if (global.vg_renderlevel == 0) and (ds_data[# prop._scn_repeat, ds_target] == true) {
	            for (ds_xindex = 0; ds_xindex < array_height_2d(def_ypoint); ds_xindex += 1) {
	               for (ds_yindex = 0; ds_yindex < array_length_2d(def_ypoint, ds_xindex); ds_yindex += 1) {
	                  //Clamp left edges
	                  if (ds_xindex == 0) {
	                     def_xpoint[ds_xindex, ds_yindex] = abs(def_xpoint[ds_xindex, ds_yindex])*-1;
	                  }
                  
	                  //Clamp right edges
	                  if (ds_xindex == (def_width - 1)) {
	                     def_xpoint[ds_xindex, ds_yindex] = abs(def_xpoint[ds_xindex, ds_yindex]);
	                  }
                  
	                  //Clamp top edges
	                  if (ds_yindex == 0) {
	                     def_ypoint[ds_xindex, ds_yindex] = abs(def_ypoint[ds_xindex, ds_yindex])*-1;
	                  }
                  
	                  //Clamp bottom edges
	                  if (ds_yindex == (def_height - 1)) {
	                     def_ypoint[ds_xindex, ds_yindex] = abs(def_ypoint[ds_xindex, ds_yindex]);
	                  }
	               }
	            }
	         } 
	      }
            
	      //Get total number of keyframes
	      keyframe_count = keyframe_id;
            
	      //Get deformation duration for playing
	      var action_def_duration = ds_data[# prop._def_dur, ds_target]/(keyframe_count + 1);             
	   } else {
	      //Get deformation duration for stopping
	      var action_def_duration = ds_data[# prop._def_dur, ds_target];                    
	   }

	   //Get keyframe target based on transition direction
	   if (ds_data[# prop._def_rev, ds_target] == false) {
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
         
	   //Increment deformation time/keyframes
	   if (ds_data[# prop._def_time, ds_target] <= action_def_duration) {
	      //Count up deformation time
	      if (global.vg_pause == false) {
	         ds_data[# prop._def_time, ds_target] += time_frame;
	      }
               
	      //Continue to next keyframe when complete
	      if (ds_data[# prop._def_time, ds_target] > action_def_duration) {       
	         //Update temp values
	         for (ds_yindex = 0; ds_yindex < ds_grid_height(ds_point); ds_yindex += 1) {
	            ds_point[# prop._tmp_xpoint, ds_yindex] = ds_point[# prop._xpoint, ds_yindex]; //X points
	            ds_point[# prop._tmp_ypoint, ds_yindex] = ds_point[# prop._ypoint, ds_yindex]; //Y points
	         }

	         //Reset time for next keyframe
	         ds_data[# prop._def_time, ds_target] = 0;

	         //Increment keyframes, if deformation is incomplete
	         if (ds_data[# prop._def_key, ds_target] != keyframe_target) { 
	            ds_data[# prop._def_key, ds_target] += key;
	         } else {
	            //Otherwise loop deformation, if enabled                  
	            if (ds_data[# prop._def_loop, ds_target] == true) {
	               //If loop is enabled, restart the deformation
	               ds_data[# prop._def_key, ds_target] = keyframe_loop;
	            } else {
	               //If loop is disabled, end the deformation
	               if (ds_def != -1) {
	                  if (ds_def == -2) {
	                     //If all values are reset, end the deformation
	                     ds_data[# prop._def, ds_target] = -1;
	                     ds_data[# prop._def_time, ds_target] = action_def_duration;
                     
	                     //Clear deform surface from memory, if any
	                     if (surface_exists(ds_data[# prop._def_surf, ds_target])) {
	                        surface_free(ds_data[# prop._def_surf, ds_target]);
	                     }                     
                     
	                     //Clear deform point data from memory, if any
	                     if (ds_exists(ds_data[# prop._def_point_data, ds_target], ds_type_grid)) {
	                        ds_grid_destroy(ds_data[# prop._def_point_data, ds_target]);
	                        ds_data[# prop._def_point_data, ds_target] = -1;
	                     }
            
	                     //Flag deformation as inactive
	                     def_active = false;
	                  } else {
	                     //Otherwise flag values for reset
	                     ds_data[# prop._def, ds_target] = -2;
	                     ds_data[# prop._def_key, ds_target] = 0;
                           
	                     //Set deformation reset time
	                     ds_data[# prop._def_dur, ds_target] = ds_data[# prop._def_dur, ds_target]/(keyframe_count + 1);  
	                  }
	               }
	            }
	         }               
	      }
	   }             
   
	   //Get ease mode override, if any
	   if (ds_exists(ds_point, ds_type_grid)) {
	      if (ds_data[# prop._def_ease, ds_target] > 0) {
	         def_ease = ds_data[# prop._def_ease, ds_target];
	      }       
            
	      //Get current deformation time
	      var action_def_time = interp(0, 1, ds_data[# prop._def_time, ds_target]/action_def_duration, def_ease);
      
	      //Perform deformation keyframes
	      for (ds_yindex = 0; ds_yindex < ds_grid_height(ds_point); ds_yindex += 1) {
	         //Convert point keyframes to 2D data
	         ds_target = ds_yindex;
	         ds_xindex = ds_yindex mod def_width;
	         ds_yindex = ds_yindex div def_width;
         
	         //Animate deformation points
	         ds_point[# prop._xpoint, ds_target] = lerp(ds_point[# prop._tmp_xpoint, ds_target], def_xpoint[ds_xindex, ds_yindex], action_def_time);
	         ds_point[# prop._ypoint, ds_target] = lerp(ds_point[# prop._tmp_ypoint, ds_target], def_ypoint[ds_xindex, ds_yindex], action_def_time);
         
	         //Continue to next point
	         ds_yindex = ds_target;
	      }    
	   }                  
	} else {
	   //Otherwise flag deformation as inactive
	   def_active = false;       
	}
   
	//Return deformation state
	return def_active;


}
