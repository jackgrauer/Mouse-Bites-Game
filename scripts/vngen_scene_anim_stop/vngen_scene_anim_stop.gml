/// @function	vngen_scene_anim_stop(id);
/// @param		{real|string|macro}	id
/// @author		Lucas Chasteen <lucas.chasteen@xgasoft.com>
/// @copyright	XGASOFT 2020, All Rights Reserved
function vngen_scene_anim_stop(argument0) {

	/*
	Stops a scripted animation playing on the specified scene, if any. All values modified 
	by the ongoing animation will be smoothly returned to their defaults before stopping.

	Note that this script does NOT need to be run in order to change animations, as animations
	do not stack. Should animation stacking be needed, create a single animation script 
	containing all desired modifications.

	argument0 = identifier of the entity on which to stop animation (real or string) (or keyword 'all' for all)

	Example usage:
	   vngen_event() {
	      vngen_scene_anim_stop("background");
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
	      //Get scene slot
	      if (argument0 == all) {
	         //Animate all scenes, if enabled
	         var ds_target = sys_grid_last(ds_scene);
	         var ds_yindex = 0;
	      } else {
	         //Otherwise get single scene to animate
	         var ds_target = vngen_get_index(argument0, vngen_type_scene);
	         var ds_yindex = ds_target;
	      }
   
	      //If the target scene exists...
	      if (!is_undefined(ds_target)) {     
	         while (ds_target >= ds_yindex) {         
	            //Terminate the current animation, if any
	            sys_anim_term(ds_scene, ds_target);
            
	            //Continue to next scene, if any
	            ds_target -= 1;
	         } 
	      }
   
	      //Continue to next action once initialized
	      sys_action_term();    
	   }
	}


}
