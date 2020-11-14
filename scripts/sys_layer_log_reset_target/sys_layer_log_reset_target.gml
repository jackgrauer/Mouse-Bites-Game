/// @function	sys_layer_log_reset_target();
/// @author		Lucas Chasteen <lucas.chasteen@xgasoft.com>
/// @copyright	XGASOFT 2020, All Rights Reserved
function sys_layer_log_reset_target() {

	/*
	==========================================================================
	SYSTEM FUNCTION: MODIFY AT YOUR OWN RISK!
	--------------------------------------------------------------------------
	  System functions are executed automatically by the engine and typically
	  should not be run manually by the user
	==========================================================================

	Finalizes drawing VNgen backlog layers

	No parameters
            
	Example usage:
	   sys_layer_log_reset_target();
	*/

	/*
	FINALIZATION
	*/

	//Skip if log is hidden
	if (global.vg_log_alpha <= 0) {
	   exit;
	}

	//Get log height in pixels
	var log_height = -log_yoffset;

	//Reset drawing alpha
	if (global.vg_log_alpha < 1) {
	   draw_set_alpha(1);
	}

	//Reset drawing properties
	draw_set_font(fnt_default);   
	draw_set_color(c_white);


	/*
	SCROLLING
	*/

	//If touch scroll is active...
	if (log_touch_active == true) {
	   //Calculate momentum for touch scrolling
	   log_touch_momentum = log_touch_yoffset;
   
	   //Scroll log with touch scroll
	   log_y += log_touch_momentum;
	}

	//Smoothly scroll between entries
	if (log_ycurrent != log_y) {
	   log_ycurrent += (log_y - log_ycurrent)*((15/time_speed)*time_offset);
	}  

	//Clamp scroll to log dimensions
	log_y = clamp(log_y, min(0, gui_height - log_height), 0);


	/*
	MOUSE
	*/

	//If the mouse has moved...
	if (device_mouse_x_to_gui(0) != mouse_xprevious) or (device_mouse_y_to_gui(0) != mouse_yprevious) {
	   //Reset mouse cursor if nothing is hovered
	   if (mouse_hover == false) {
	      sys_mouse_hover(false);
	   } else {
	      //Otherwise set mouse to pointer, if enabled
	      sys_mouse_hover(true);
	   }
	}

	//Update mouse previous coordinates
	mouse_xprevious = device_mouse_x_to_gui(0);
	mouse_yprevious = device_mouse_y_to_gui(0); 


}
