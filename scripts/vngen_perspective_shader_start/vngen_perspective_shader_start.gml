/// @function	vngen_perspective_shader_start(shader, fade, [ease]);
/// @param		{shader}		shader
/// @param		{real}			fade
/// @param		{integer|macro}	[ease]
/// @author		Lucas Chasteen <lucas.chasteen@xgasoft.com>
/// @copyright	XGASOFT 2020, All Rights Reserved
function vngen_perspective_shader_start() {

	/*
	Applies a shader to the global perspective with optional fade in transition. 
	Shaders are written externally and can be used to modify the color and position 
	of vertices and/or pixels.

	Important! Some shaders require extra input values to function properly. These
	values must be set externally with vngen_set_shader_* scripts.

	Note that running this script multiple times does NOT start multiple shaders, as
	shaders do not stack. Should shader stacking be needed, create a single shader
	containing all desired modifications.

	argument0 = sets the shader to perform (shader)
	argument1 = sets the the length of time to fade shader in, in seconds (real)
	argument2 = sets the fade easing method (see interp for available modes) (integer) (can also use true/false) (optional, use no argument for none)

	Example usage:
	   vngen_event() {
	      vngen_perspective_shader_start(shade_sepia, 0.5);
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
	      if (sys_shader_exists(argument[0])) {
	         //Initialize shader
	         sys_shader_init(ds_perspective, 0, argument[0]);
      
	         //Set transition time
	         if (argument[1] > 0) {
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
	if (ds_perspective[# prop._sh_time, 0] < argument[1]) {
	   if (!sys_action_skip()) {
	      ds_perspective[# prop._sh_time, 0] += time_frame;
	   } else {
	      //Otherwise skip transition if vngen_do_continue is run
	      ds_perspective[# prop._sh_time, 0] = argument[1];
	   }
   
	   //Mark this action as complete
	   if (ds_perspective[# prop._sh_time, 0] < 0) or (ds_perspective[# prop._sh_time, 0] >= argument[1]) { 
	      //Disallow exceeding target values    
	      ds_perspective[# prop._sh_time, 0] = argument[1]; //Time
	      ds_perspective[# prop._sh_amt, 0] = 1;            //Amount, or fade percentage
      
	      //End action
	      sys_action_term();
	      exit;
	   }
	} else {
	   //Do not process when transitions are complete
	   exit;
	}      

	//If duration is greater than 0...
	if (argument[1] > 0) {
	   //Get ease mode
	   if (argument_count > 2) {
	      var action_ease = argument[2];
	   } else {
	      var action_ease = false;
	   }
   
	   //Get transition time
	   var action_time = interp(0, 1, ds_perspective[# prop._sh_time, 0]/argument[1], action_ease);

	   //Perform shader fade
	   ds_perspective[# prop._sh_amt, 0] = lerp(0, 1, action_time); //Amount, or fade percentage
	}


}
