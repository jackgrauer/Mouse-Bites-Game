/// @function	vngen_perspective_anim_stop();
/// @author		Lucas Chasteen <lucas.chasteen@xgasoft.com>
/// @copyright	XGASOFT 2020, All Rights Reserved
function vngen_perspective_anim_stop() {

	/*
	Stops a scripted animation playing on the global perspective, if any. All values modified 
	by the ongoing animation will be smoothly returned to their defaults before stopping.

	Note that this script does NOT need to be run in order to change animations, as animations
	do not stack. Should animation stacking be needed, create a single animation script 
	containing all desired modifications.

	Example usage:
	   vngen_event() {
	      vngen_perspective_anim_stop();
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
	      //Terminate the current animation, if any
	      sys_anim_term(ds_perspective, 0);
   
	      //Continue to next action once initialized
	      sys_action_term(); 
	   }
	}


}
