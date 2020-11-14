/// @function	sys_shader_perform(entity, index);
/// @param		{integer}	entity
/// @param		{integer}	index
/// @author		Lucas Chasteen <lucas.chasteen@xgasoft.com>
/// @copyright	XGASOFT 2020, All Rights Reserved
function sys_shader_perform(argument0, argument1) {

	/*
	==========================================================================
	SYSTEM FUNCTION: MODIFY AT YOUR OWN RISK!
	--------------------------------------------------------------------------
	  System functions are executed automatically by the engine and typically
	  should not be run manually by the user
	==========================================================================

	Performs shaders which have been initialized with sys_shader_init on 
	compatible entities, passing in custom uniform values.

	VNgen's handling of this functionality is highly tailored for its particular
	use-cases and is not intended for general use.
            
	Example usage:
	   sys_shader_perform(ds_scene, ds_target);
	*/

	/*
	INITIALIZATION
	*/

	//Get the target data structure
	var ds_data = argument0;
	var ds_target = argument1;
	var ds_shader = ds_data[# prop._shader, ds_target];
	var ds_yindex;


	/*
	PERFORM SHADERS
	*/

	if (sys_shader_exists(ds_shader)) {
	   //Enable the shader
	   shader_set(ds_shader);
   
	   /*
	   INPUT UNIFORMS
	   */
   
	   //Get input uniforms
	   var sh_amt = shader_get_uniform(ds_shader, "in_Amount");
	   var sh_mouse = shader_get_uniform(ds_shader, "in_Mouse");
	   var sh_offset = shader_get_uniform(ds_shader, "in_Offset");
	   var sh_size = shader_get_uniform(ds_shader, "in_Resolution");
	   var sh_time = shader_get_uniform(ds_shader, "in_Time");
   
	   //Get float data
	   var ds_float = ds_data[# prop._sh_float_data, ds_target];
   
	   //Get floats, if any
	   if (ds_exists(ds_float, ds_type_grid)) {
	      for (ds_yindex = 0; ds_yindex < ds_grid_height(ds_float); ds_yindex += 1) {
	         ds_float[# prop._uniform, ds_yindex] = shader_get_uniform(ds_shader, ds_float[# prop._id, ds_yindex]);
	      }
	   }
   
	   //Get matrix data
	   var ds_mat = ds_data[# prop._sh_mat_data, ds_target];
   
	   //Get matrices, if any
	   if (ds_exists(ds_mat, ds_type_grid)) {
	      for (ds_yindex = 0; ds_yindex < ds_grid_height(ds_mat); ds_yindex += 1) {
	         ds_mat[# prop._uniform, ds_yindex] = shader_get_uniform(ds_shader, ds_mat[# prop._id, ds_yindex]);
	      }
	   }
   
	   //Get sampler data
	   var ds_samp = ds_data[# prop._sh_samp_data, ds_target];
   
	   //Get samplers, if any
	   if (ds_exists(ds_samp, ds_type_grid)) {
	      for (ds_yindex = 0; ds_yindex < ds_grid_height(ds_samp); ds_yindex += 1) {
	         ds_samp[# prop._uniform, ds_yindex] = shader_get_sampler_index(ds_shader, ds_samp[# prop._id, ds_yindex]);
	      }
	   }
   
   
	   /*
	   ANIMATION
	   */
   
	   //Increment shader time
	   ds_data[# prop._sh_frame, ds_target] += time_frame;
   
	   //Keep shader time within safe values
	   if (ds_data[# prop._sh_frame, ds_target] > 2000000000) {
	      ds_data[# prop._sh_frame, ds_target] -= 2000000000;
	   }
   
   
	   /*
	   OUTPUT UNIFORMS
	   */
   
	   //Update shader input values
	   shader_set_uniform_f(sh_amt, ds_data[# prop._sh_amt, ds_target]);
	   shader_set_uniform_f(sh_mouse, mouse_x - room_xoffset, mouse_y - room_yoffset);
	   shader_set_uniform_f(sh_offset, room_xoffset, room_yoffset);
	   shader_set_uniform_f(sh_size, ds_data[# prop._width, ds_target], ds_data[# prop._height, ds_target]);
	   shader_set_uniform_f(sh_time, ds_data[# prop._sh_frame, ds_target]);
   
	   //Set floats, if any
	   if (ds_exists(ds_float, ds_type_grid)) {
	      for (ds_yindex = 0; ds_yindex < ds_grid_height(ds_float); ds_yindex += 1) {
	         shader_set_uniform_f(ds_float[# prop._uniform, ds_yindex], ds_float[# prop._val, ds_yindex]);
	      }
	   }
   
	   //Set matrices, if any
	   if (ds_exists(ds_mat, ds_type_grid)) {
	      for (ds_yindex = 0; ds_yindex < ds_grid_height(ds_mat); ds_yindex += 1) {
	         shader_set_uniform_matrix(ds_mat[# prop._uniform, ds_yindex]);
	      }
	   }
   
	   //Set samplers, if any
	   if (ds_exists(ds_samp, ds_type_grid)) {
	      for (ds_yindex = 0; ds_yindex < ds_grid_height(ds_samp); ds_yindex += 1) {
	         sys_shader_set_sampler(ds_samp[# prop._uniform, ds_yindex], ds_samp[# prop._val, ds_yindex], ds_data[# prop._img_index, ds_yindex]);
	      }
	   }
	}


}
