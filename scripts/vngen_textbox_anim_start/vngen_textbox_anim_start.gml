/// @function	vngen_textbox_anim_start(id, anim, duration, loop, reverse, [ease]);
/// @param		{real|string|macro}	id
/// @param		{script}			anim
/// @param		{real}				duration
/// @param		{boolean}			loop
/// @param		{boolean}			reverse
/// @param		{integer|macro}		[ease]
/// @author		Lucas Chasteen <lucas.chasteen@xgasoft.com>
/// @copyright	XGASOFT 2020, All Rights Reserved
function vngen_textbox_anim_start() {

	/*
	Applies a scripted animation to the specified textbox. Animation scripts are written 
	externally and can be performed on x, y, xscale, yscale, rotation, color, and alpha.

	Unlike mods, animations are temporary changes performed over time using relative values.
	Once an animation has been stopped or completed, all values will return to default.

	Note that running this script multiple times does NOT perform multiple animations, as
	animations do not stack. Should animation stacking be needed, create a single animation
	script containing all desired modifications.

	Also note that unlike regular transitions, animation duration can NOT be set to 0.

	argument0 = identifier of the textbox on which to perform animation (real or string) (or keyword 'all' for all)
	argument1 = sets the animation script to perform (script)
	argument2 = sets the length of the **entire animation**, in seconds (real)
	argument3 = enables or disables looping the animation (boolean) (true/false)
	argument4 = enables or disables performing the animation in reverse keyframe order (boolean) (true/false)
	argument5 = sets the animation easing override (see interp for available modes) (integer) (can also use true/false) (optional, use no argument for none)

	Example usage:
	   vngen_event() {
	      vngen_textbox_anim_start("textbox", anim_wiggle, 0.5, true, false);
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
	      //Get textbox slot
	      if (argument[0] == all) {
	         //Modify all textboxes, if enabled
	         var ds_target = sys_grid_last(ds_textbox);
	         var ds_yindex = 0;
	      } else {
	         //Otherwise get single textbox to modify
	         var ds_target = vngen_get_index(argument[0], vngen_type_textbox);
	         var ds_yindex = ds_target;
	      }
         
	      //If the target textbox exists...
	      if (!is_undefined(ds_target)) {     
	         //Get ease mode
	         if (argument_count > 5) {
	            var action_ease = argument[5];
	         } else {
	            var action_ease = false;
	         }   
          
	         while (ds_target >= ds_yindex) { 
	            //Initialize animation
	            sys_anim_init(ds_textbox, ds_target, argument[1], argument[2], argument[3], argument[4], action_ease);
            
	            //Continue to next textbox, if any
	            ds_target -= 1;
	         }   
	      }
      
	      //Continue to next action once initialized
	      sys_action_term();
	   }
	}


}
