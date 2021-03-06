/// @function	vngen_char_shader_stop(name, fade, [ease]);
/// @param		{string|macro}	name
/// @param		{real}			fade
/// @param		{integer|macro}	[ease]
/// @author		Lucas Chasteen <lucas.chasteen@xgasoft.com>
/// @copyright	XGASOFT 2020, All Rights Reserved
function vngen_char_shader_stop() {

	/*
	Stops a shader being applied to the specified character, if any.

	Note that this script does NOT need to be run in order to change shaders, as shaders
	do not stack. Should shader stacking be needed, create a single shader containing all 
	desired modifications.

	argument0 = identifier of the character on which to perform shader (string) (or keyword 'all' for all)
	argument1 = sets the the length of time to fade shader out, in seconds (real)
	argument2 = sets the fade easing method (see interp for available modes) (integer) (can also use true/false) (optional, use no argument for none)

	Example usage:
	   vngen_event() {
	      vngen_char_shader_stop("John Doe", 0.5);
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
	      //Get character slot
	      if (argument[0] == all) {
	         //Animate all characters, if enabled
	         var ds_target = sys_grid_last(ds_character);
	         var ds_yindex = 0;
	      } else {
	         //Otherwise get single character to animate
	         var ds_target = vngen_get_index(argument[0], vngen_type_char);
	         var ds_yindex = ds_target;
	      }
   
	      //If the target character exists...
	      if (!is_undefined(ds_target)) { 
	         //If shader exists...
	         if (sys_shader_exists(ds_character[# prop._shader, ds_target])) {
	            while (ds_target >= ds_yindex) {  
	               //Set transition time
	               if (argument[1] > 0) {
	                  ds_character[# prop._sh_time, ds_target] = 0;  //Transition time
	               } else {
	                  ds_character[# prop._sh_time, ds_target] = -1; //Transition time
	               }   
            
	               //Continue to next character, if any
	               ds_target -= 1;
	            }
	         } else {
	            //Skip action if shader does not exist
	            sys_action_term();
	            exit;
	         }
	      } else {
	         //Skip action if character does not exist
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

	//Get character slot
	if (argument[0] == all) {
	   //Modify all characters, if enabled
	   var ds_target = sys_grid_last(ds_character);
	   var ds_yindex = 0;
	} else {
	   //Otherwise get single character to modify
	   var ds_target = vngen_get_index(argument[0], vngen_type_char);
	   var ds_yindex = ds_target;
	}

	//Skip action if target character does not exist
	if (is_undefined(ds_target)) {
	   exit;
	}

	//Skip action if shader does not exist
	if (!sys_shader_exists(ds_character[# prop._shader, ds_target])) {
	   exit;
	}


	/*
	PERFORM MODIFICATIONS
	*/

	while (ds_target >= ds_yindex) { 
	   //Increment transition time
	   if (ds_character[# prop._sh_time, ds_target] < argument[1]) {
	      if (!sys_action_skip()) {
	         ds_character[# prop._sh_time, ds_target] += time_frame;
	      } else {
	         //Otherwise skip transition if vngen_do_continue is run
	         ds_character[# prop._sh_time, ds_target] = argument[1];
	      }
      
	      //Mark this action as complete
	      if (ds_character[# prop._sh_time, ds_target] < 0) or (ds_character[# prop._sh_time, ds_target] >= argument[1]) { 
	         //Disable shader
	         ds_character[# prop._shader, ds_target] = -1;
      
	         //Clear shader uniforms from memory, if any
	         if (ds_exists(ds_character[# prop._sh_float_data, ds_target], ds_type_grid)) {
	            ds_grid_destroy(ds_character[# prop._sh_float_data, ds_target]);
	            ds_character[# prop._sh_float_data, ds_target] = -1;
	         }
	         if (ds_exists(ds_character[# prop._sh_mat_data, ds_target], ds_type_grid)) {
	            ds_grid_destroy(ds_character[# prop._sh_mat_data, ds_target]);
	            ds_character[# prop._sh_mat_data, ds_target] = -1;
	         }
	         if (ds_exists(ds_character[# prop._sh_samp_data, ds_target], ds_type_grid)) {
	            ds_grid_destroy(ds_character[# prop._sh_samp_data, ds_target]);
	            ds_character[# prop._sh_samp_data, ds_target] = -1;
	         }
         
	         //End action
	         if (ds_target == ds_yindex) {
	            sys_action_term();
            
	            //Continue to next character, if any
	            ds_target -= 1;
	            continue;
	         }
	      }
	   } else {
	      //Do not process when transitions are complete
	      ds_target -= 1;
	      continue;
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
	      var action_time = interp(0, 1, ds_character[# prop._sh_time, ds_target]/argument[1], action_ease);
   
	      //Perform shader fade
	      ds_character[# prop._sh_amt, ds_target] = lerp(1, 0, action_time); //Amount, or fade percentage
	   }
            
	   //Continue to next character, if any
	   ds_target -= 1;
	}


}
