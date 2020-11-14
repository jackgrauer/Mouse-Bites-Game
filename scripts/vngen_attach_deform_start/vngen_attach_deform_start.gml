/// @function	vngen_attach_deform_start(name, id, def, duration, loop, reverse, [ease]);
/// @param		{string|macro}	name
/// @param		{real|string}	id
/// @param		{script}		def
/// @param		{real}			duration
/// @param		{boolean}		loop
/// @param		{boolean}		reverse
/// @param		{integer|macro}	[ease]
/// @author		Lucas Chasteen <lucas.chasteen@xgasoft.com>
/// @copyright	XGASOFT 2020, All Rights Reserved
function vngen_attach_deform_start() {

	/*
	Applies a scripted deformation to the specified attachment. Deformation scripts are written 
	externally and can be performed on eight points of distortion.

	Unlike mods, deformations are temporary changes performed over time using relative values.
	Once a deformation has been stopped or completed, all values will return to default.

	Note that running this script multiple times does NOT perform multiple deformations, as
	deformations do not stack. Should deformation stacking be needed, create a single deformation
	script containing all desired modifications.

	Also note that unlike regular transitions, deformation duration can NOT be set to 0.

	argument0 = identifier of the character to be modified (string)
	argument1 = identifier of the attachment on which to perform deformation (real or string) (or keyword 'all' for all)
	argument2 = sets the deformation script to perform (script)
	argument3 = sets the length of the **entire deformation animation**, in seconds (real)
	argument4 = enables or disables looping the deformation (boolean) (true/false)
	argument5 = enables or disables performing the deformation in reverse keyframe order (boolean) (true/false)
	argument6 = sets the deformation easing override (see interp for available modes) (integer) (can also use true/false) (optional, use no argument for none)

	Example usage:
	   vngen_event() {
	      vngen_attach_deform_start("John Doe", "attach", def_wave, 3, true, false);
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
	      //Get character target
	      var ds_char_target = vngen_get_index(argument[0], vngen_type_char);
      
	      //If the target character exists...
	      if (!is_undefined(ds_char_target)) {  
	         //Get attachment data from target character
	         var ds_attach = ds_character[# prop._attach_data, ds_char_target];    
         
	         //Get attachment slot
	         if (argument[1] == all) {
	            //Modify all attachments, if enabled
	            var ds_attach_target = sys_grid_last(ds_attach);
	            var ds_xindex = 0;
	         } else {
	            //Otherwise get single attachment to modify
	            var ds_attach_target = vngen_get_index(argument[1], vngen_type_attach, argument[0]);
	            var ds_xindex = ds_attach_target;
	         }
      
	         //If the target attachment exists...
	         if (!is_undefined(ds_attach_target)) { 
	            //Get ease mode
	            if (argument_count > 6) {
	               var action_ease = argument[6];
	            } else {
	               var action_ease = false;
	            }   
              
	            while (ds_attach_target >= ds_xindex) {         
	               //Initialize deformation
	               sys_deform_init(ds_attach, ds_attach_target, argument[2], argument[3], argument[4], argument[5], action_ease);
               
	               //Continue to next attachment, if any
	               ds_attach_target -= 1;
	            }            
	         }
	      }
      
	      //Continue to next action once initialized
	      sys_action_term();
	   }
	}


}
