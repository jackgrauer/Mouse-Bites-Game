/// @function	vngen_do_log_nav_touch();
/// @author		Lucas Chasteen <lucas.chasteen@xgasoft.com>
/// @copyright	XGASOFT 2020, All Rights Reserved
function vngen_do_log_nav_touch() {

	/*
	Handles touch-based scrolling for the backlog, when open.

	Intended to be run in the Step event of a dedicated backlog object.

	No parameters

	Example usage:
	   vngen_do_log_nav_touch();
	*/

	//If the backlog is open...
	if (global.vg_log_visible == true) {
	   if (global.vg_log_alpha >= 1) {
	      //Skip if button navigation is active
	      if (button_active != -1) {
	         exit;
	      }
      
	      //Get initial touch point
	      if (device_mouse_check_button_pressed(0, mb_left)) {
	         log_touch[0] = device_mouse_y_to_gui(0);
	         log_touch[1] = log_touch[0];
   
	         //Apply high friction while touch is held down
	         log_touch_friction = 0.5;
	         log_touch_yoffset = 0;
	      } 
   
	      //Get second touch point while touch is held
	      if (device_mouse_check_button(0, mb_left)) {
	         log_touch[1] = log_touch[0] + ((device_mouse_y_to_gui(0) - log_touch[0]));
	      }

	      //Reduce friction when touch is removed
	      if (device_mouse_check_button_released(0, mb_left)) {
	         log_touch_friction = 0.125*time_offset;
	      }

	      //Get the difference between touch points, reduced over time
	      if ((log_touch[1] - log_touch[0]) != 0) {
	         log_touch[0] += (log_touch[1] - log_touch[0])*log_touch_friction;
   
	         //Set touch scroll offset
	         log_touch_yoffset = log_touch[0] - log_touch[1];
   
	         //Mark touch scrolling as active
	         log_touch_active = true;   
	      }
	   }
	}


}
