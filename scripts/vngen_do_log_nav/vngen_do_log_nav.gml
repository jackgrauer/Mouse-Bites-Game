/// @function	vngen_do_log_nav(amount);
/// @param		{integer}	amount
/// @author		Lucas Chasteen <lucas.chasteen@xgasoft.com>
/// @copyright	XGASOFT 2020, All Rights Reserved
function vngen_do_log_nav() {

	/*
	Scrolls up or down through the backlog by the specified amount, when visible.
	'Amount' refers to number of entries, where negative values scroll up and positive 
	values scroll down. This value is clamped to the size of the log, therefore large 
	values can be used to jump directly to the beginning or end. 

	argument0 = number of log entries to scroll (integer)

	Example usage:
	   vngen_do_log_nav(-1); //Up
	   vngen_do_log_nav(1);  //Down  
	*/

	//If the backlog is open...
	if (global.vg_log_visible == true) {
	   //And the fade animation is complete...
	   if (global.vg_log_alpha >= 1) {
	      //Force disable touch scroll, if active
	      log_touch_active = false;
	      log_touch[0] = log_touch[1];
      
	      //Scroll the log
	      log_current = clamp(log_current - argument[0], 0, log_count);
	   }
	}


}
