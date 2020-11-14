/// @function	vngen_effect_start(id, effect, duration, loop, reverse, [ease]);
/// @param		{real|string}	id
/// @param		{script}		effect
/// @param		{real}			duration
/// @param		{boolean}		loop
/// @param		{boolean}		reverse
/// @param		{integer|macro}	[ease]
/// @author		Lucas Chasteen <lucas.chasteen@xgasoft.com>
/// @copyright	XGASOFT 2020, All Rights Reserved
function vngen_effect_start() {

	/*
	Performs a scripted effect. Effect scripts are written externally and can be used to 
	perform arbitrary code in the context of VNgen keyframes. Built-in scripts perform
	effects such as controller vibration, light flashes, and more.

	Unlike animations, feedback effects do not modify a particular entity. While drawing
	is optional, effects using draw functions will be displayed beneath textboxes and
	above all other entities.

	Also unlike animations, running this script multiple times DOES perform multiple
	effects, provided a different ID is given to each effect. However, just because
	multiple effects can be performed simultaneously does not mean that effects of the
	same kind will 'combine' as expected.

	Also note that unlike regular transitions, effect duration can NOT be set to 0.

	argument0 = identifier to use for the effect (real or string)
	argument1 = sets the effect script to perform (script)
	argument2 = sets the length of the **entire effect**, in seconds (real)
	argument3 = enables or disables looping the effect (boolean) (true/false)
	argument4 = enables or disables performing the effect in reverse keyframe order (boolean) (true/false)
	argument5 = sets the effect easing override (see interp for available modes) (integer) (can also use true/false) (optional, use no argument for none)

	Example usage:
	   vngen_event() {
	      vngen_effect_start("vibrate", ef_ramp_down, 0.5, false, false);
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
	      //Skip non-looped effects if event skip is active
	      if (argument[3] == false) {
	         if (sys_event_skip()) {
	            sys_action_term();
	            exit;
	         }
	      }
      
	      //Get effect slot
	      var ds_target = vngen_get_index(argument[0], vngen_type_effect);
      
	      //If effect does not exist, create it
	      if (is_undefined(ds_target)) {
	         //Get the current number of effect entries
	         ds_target = ds_grid_height(ds_effect);
         
	         //Create new effect slot in data structure
	         ds_grid_resize(ds_effect, ds_grid_width(ds_effect), ds_grid_height(ds_effect) + 1);
         
	         //Set effect ID
	         ds_effect[# prop._id, ds_target] = argument[0];
         
	         //Set special effect properties
	         ds_effect[# prop._ef_var_data, ds_target] = -1;
	      }
      
	      //Get ease mode
	      if (argument_count > 5) {
	         var action_ease = argument[5];
	      } else {
	         var action_ease = false;
	      }   
      
	      //Initialize effect
	      sys_effect_init(ds_target, argument[1], argument[2], argument[3], argument[4], action_ease);
         
	      //Continue to next action once initialized
	      sys_action_term();
	   }
	}


}
