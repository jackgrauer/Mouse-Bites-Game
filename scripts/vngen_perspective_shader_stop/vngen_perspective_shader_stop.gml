/// @function	vngen_perspective_shader_stop(fade, [ease]);
/// @param		{real}			fade
/// @param		{integer|macro}	[ease]
/// @author		Lucas Chasteen <lucas.chasteen@xgasoft.com>
/// @copyright	XGASOFT 2020, All Rights Reserved
function vngen_perspective_shader_stop() {

	/*
	Stops a shader being applied to the global perspective, if any.

	Note that this script does NOT need to be run in order to change shaders, as shaders
	do not stack. Should shader stacking be needed, create a single shader containing all 
	desired modifications.

	argument0 = sets the the length of time to fade shader out, in seconds (real)
	argument1 = sets the fade easing method (see interp for available modes) (integer) (can also use true/false) (optional, use no argument for none)

	Example usage:
	   vngen_event() {
	      vngen_perspective_shader_stop(0.5);
	   }
	*/

	/*
	INITIALIZATION
	*/

	//Enable action, if active
	switch (sys_action_init()) {
	   //Exit if event is inactive
	   case false: {
	      exit;
	   }
      
	   //Initialize action if active
	   case true: {
	      //If shader exists...
	      if (sys_shader_exists(ds_perspective[# prop._shader, 0])) {
	         //Set transition time
	         if (argument[0] > 0) {
	            ds_perspective[# prop._sh_time, 0] = 0;  //Transition time
	         } else {
	            ds_perspective[# prop._sh_time, 0] = -1; //Transition time
	         }   
	      } else {
	         //Skip action if shader does not exist
	         sys_action_term();
	         exit;
	      }
	   }
	}


	/*
	DATA MANAGEMENT
	*/

	//Skip action if engine is paused
	if (global.vg_pause == true) {
	   exit;
	}

	//Skip action if shader does not exist
	if (!sys_shader_exists(ds_perspective[# prop._shader, 0])) {
	   exit;
	}


	/*
	PERFORM MODIFICATIONS
	*/

	//Increment transition time
	if (ds_perspective[# prop._sh_time, 0] < argument[0]) {
	   if (!sys_action_skip()) {
	      ds_perspective[# prop._sh_time, 0] += time_frame;
	   } else {
	      //Otherwise skip transition if vngen_do_continue is run
	      ds_perspective[# prop._sh_time, 0] = argument[0];
	   }
   
	   //Mark this action as complete
	   if (ds_perspective[# prop._sh_time, 0] < 0) or (ds_perspective[# prop._sh_time, 0] >= argument[0]) { 
	      //Disable shader
	      ds_perspective[# prop._shader, 0] = -1;
      
	      //Clear shader uniforms from memory, if any
	      if (ds_exists(ds_perspective[# prop._sh_float_data, 0], ds_type_grid)) {
	         ds_grid_destroy(ds_perspective[# prop._sh_float_data, 0]);
	         ds_perspective[# prop._sh_float_data, 0] = -1;
	      }
	      if (ds_exists(ds_perspective[# prop._sh_mat_data, 0], ds_type_grid)) {
	         ds_grid_destroy(ds_perspective[# prop._sh_mat_data, 0]);
	         ds_perspective[# prop._sh_mat_data, 0] = -1;
	      }
	      if (ds_exists(ds_perspective[# prop._sh_samp_data, 0], ds_type_grid)) {
	         ds_grid_destroy(ds_perspective[# prop._sh_samp_data, 0]);
	         ds_perspective[# prop._sh_samp_data, 0] = -1;
	      }
      
	      //End action
	      sys_action_term();
	      exit;
	   }
	} else {
	   //Do not process when transitions are complete
	   exit;
	}      

	//If duration is greater than 0...
	if (argument[0] > 0) {
	   //Get ease mode
	   if (argument_count > 1) {
	      var action_ease = argument[1];
	   } else {
	      var action_ease = false;
	   }
   
	   //Get transition time
	   var action_time = interp(0, 1, ds_perspective[# prop._sh_time, 0]/argument[0], action_ease);

	   //Perform shader fade
	   ds_perspective[# prop._sh_amt, 0] = lerp(1, 0, action_time); //Amount, or fade percentage
	}


}
