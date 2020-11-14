/// @function	sys_layer_draw_perspective();
/// @author		Lucas Chasteen <lucas.chasteen@xgasoft.com>
/// @copyright	XGASOFT 2020, All Rights Reserved
function sys_layer_draw_perspective() {

	/*
	==========================================================================
	SYSTEM FUNCTION: MODIFY AT YOUR OWN RISK!
	--------------------------------------------------------------------------
	  System functions are executed automatically by the engine and typically
	  should not be run manually by the user
	==========================================================================

	Draws perspective replace transitions. 

	Note that this script does NOT calculate perspective values themselves, 
	as these are handled by sys_layer_draw_init.

	No parameters
            
	Example usage:
	   sys_layer_draw_perspective();
	*/

	/*
	PERSPECTIVE FADE
	*/

	//Skip processing if vngen_object_clear has been run
	if (event_current < 0) {
	   exit;
	}

	//If perspective transition is in progress...
	if (ds_perspective[# prop._fade_src, 0] != -1) {
	   if (surface_exists(ds_perspective[# prop._fade_src, 0])) {
	      //Capture current perspective
	      if (ds_perspective[# prop._fade_draw, 0] == true) {
	         surface_copy(ds_perspective[# prop._fade_src, 0], 0, 0, application_surface);
	      }
   
	      //Fade out old perspective
	      draw_surface_ext(ds_perspective[# prop._fade_src, 0], room_xoffset, room_yoffset, 1, 1, 0, c_white, ds_perspective[# prop._fade_alpha, 0]);
	   }
	}


	/*
	PERSPECTIVE SHADER
	*/

	//Perform perspective shader, if any
	if (sys_shader_exists(ds_perspective[# prop._shader, 0])) {
	   if (global.vg_renderlevel < 2) {
		  //Initialize draw skip
		  var draw_skip = false;
	  
	      //Ensure temporary shader surface exists
	      if (!surface_exists(ds_perspective[# prop._src, 0])) {
	         ds_perspective[# prop._src, 0] = surface_create(surface_get_width(application_surface), surface_get_height(application_surface));
		 
			 //Skip drawing first frame and just render to surface
			 draw_skip = true;
	      } else {
	         if (surface_get_width(ds_perspective[# prop._src, 0]) != surface_get_width(application_surface))
	         or (surface_get_height(ds_perspective[# prop._src, 0]) != surface_get_height(application_surface)) {
	            surface_resize(ds_perspective[# prop._src, 0], surface_get_width(application_surface), surface_get_height(application_surface));
	         }
	      }
      
	      //Copy application surface to shader surface
	      if (surface_exists(application_surface)) {
	         surface_copy(ds_perspective[# prop._src, 0], 0, 0, application_surface);
	      }
      
	      //Apply shader to temporary surface
		  if (draw_skip == false) {
	         sys_shader_perform(ds_perspective, 0);
	         draw_surface_stretched(ds_perspective[# prop._src, 0], room_xoffset, room_yoffset, global.dp_width, global.dp_height);
	         shader_reset();
		  }
	   }
	} else {
	   //Otherwise clear temporary shader surface from memory, if any
	   if (surface_exists(ds_perspective[# prop._src, 0])) {
	      surface_free(ds_perspective[# prop._src, 0]);
	      ds_perspective[# prop._src, 0] = -1;
	   }
	}


}
