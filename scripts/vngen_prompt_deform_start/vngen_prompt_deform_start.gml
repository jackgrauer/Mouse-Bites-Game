/// @function	vngen_prompt_deform_start(id, def, duration, loop, reverse, [ease]);
/// @param		{real|string|macro}	id
/// @param		{script}			def
/// @param		{real}				duration
/// @param		{boolean}			loop
/// @param		{boolean}			reverse
/// @param		{integer|macro}		[ease]
/// @author		Lucas Chasteen <lucas.chasteen@xgasoft.com>
/// @copyright	XGASOFT 2020, All Rights Reserved
function vngen_prompt_deform_start() {

	/*
	Applies a scripted deformation to the specified prompt. Deformation scripts are written 
	externally and can be performed on eight points of distortion.

	Unlike mods, deformations are temporary changes performed over time using relative values.
	Once a deformation has been stopped or completed, all values will return to default.

	Note that running this script multiple times does NOT perform multiple deformations, as
	deformations do not stack. Should deformation stacking be needed, create a single deformation
	script containing all desired modifications.

	Also note that unlike regular transitions, deformation duration can NOT be set to 0.

	argument0 = identifier of the prompt on which to perform deformation (real or string) (or keyword 'all' for all)
	argument1 = sets the deformation script to perform (script)
	argument2 = sets the length of the **entire deformation animation**, in seconds (real)
	argument3 = enables or disables looping the deformation (boolean) (true/false)
	argument4 = enables or disables performing the deformation in reverse keyframe order (boolean) (true/false)
	argument5 = sets the deformation easing override (see interp for available modes) (integer) (can also use true/false) (optional, use no argument for none)

	Example usage:
	   vngen_event() {
	      vngen_prompt_deform_start("prompt", def_wave, 3, true, false);
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
	      //Get prompt slot
	      if (argument[0] == all) {
	         //Modify all prompts, if enabled
	         var ds_target = sys_grid_last(ds_prompt);
	         var ds_yindex = 0;
	      } else {
	         //Otherwise get single prompt to modify
	         var ds_target = vngen_get_index(argument[0], vngen_type_prompt);
	         var ds_yindex = ds_target;
	      }
         
	      //If the target prompt exists...
	      if (!is_undefined(ds_target)) {     
	         //Get ease mode
	         if (argument_count > 5) {
	            var action_ease = argument[5];
	         } else {
	            var action_ease = false;
	         }   
          
	         while (ds_target >= ds_yindex) {       
	            //Initialize deformation
	            sys_deform_init(ds_prompt, ds_target, argument[1], argument[2], argument[3], argument[4], action_ease);
            
	            //Continue to next prompt, if any
	            ds_target -= 1;
	         }   
	      }
      
	      //Continue to next action once initialized
	      sys_action_term(); 
	   }
	}


}
