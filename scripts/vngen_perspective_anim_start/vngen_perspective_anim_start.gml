/// @function	vngen_perspective_anim_start(anim, duration, loop, reverse, [ease]);
/// @param		{script}		anim
/// @param		{real}			duration
/// @param		{boolean}		loop
/// @param		{boolean}		reverse
/// @param		{integer|macro}	[ease]
/// @author		Lucas Chasteen <lucas.chasteen@xgasoft.com>
/// @copyright	XGASOFT 2020, All Rights Reserved
function vngen_perspective_anim_start() {

	/*
	Applies a scripted animation to the global perspective. Animation scripts are written 
	externally and can be performed on x, y, xoffset, yoffset, zoom, strength, and rotation.

	While perspective uses unique values compared to other entities, existing animations can
	be performed where xscale and yscale will be treated as zoom and strength, respectively. 
	The unique xoffset and yoffset values will apply to perspective animations only.

	Once an animation has been stopped or completed, all values will return to default.

	Note that running this script multiple times does NOT perform multiple animations, as
	animations do not stack. Should animation stacking be needed, create a single animation
	script containing all desired modifications.

	Also note that unlike regular transitions, animation duration can NOT be set to 0.

	argument0 = sets the animation script to perform (script)
	argument1 = sets the length of the **entire animation**, in seconds (real)
	argument2 = enables or disables looping the animation (boolean) (true/false)
	argument3 = enables or disables performing the animation in reverse keyframe order (boolean) (true/false)
	argument4 = sets the animation easing override (see interp for available modes) (integer) (can also use true/false) (optional, use no argument for none)

	Example usage:
	   vngen_event() {
	      vngen_perspective_anim_start(anim_wiggle, 0.5, false, false);
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
	      //Get ease mode
	      if (argument_count > 4) {
	         var action_ease = argument[4];
	      } else {
	         var action_ease = false;
	      }   
      
	      //Initialize animation
	      sys_anim_init(ds_perspective, 0, argument[0], argument[1], argument[2], argument[3], action_ease);
   
	      //Continue to next action once initialized
	      sys_action_term();    
	   }
	}


}
