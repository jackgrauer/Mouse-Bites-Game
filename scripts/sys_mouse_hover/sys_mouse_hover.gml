/// @function	sys_mouse_hover(state);
/// @param		{boolean}	state
/// @author		Lucas Chasteen <lucas.chasteen@xgasoft.com>
/// @copyright	XGASOFT 2020, All Rights Reserved
function sys_mouse_hover(argument0) {

	/*
	==========================================================================
	SYSTEM FUNCTION: MODIFY AT YOUR OWN RISK!
	--------------------------------------------------------------------------
	  System functions are executed automatically by the engine and typically
	  should not be run manually by the user
	==========================================================================

	Enables or disables setting mouse cursors to the hover state

	argument0 = set mouse cursors to hover (true) or default (false) (boolean) (true/false)
            
	Example usage:
	   sys_mouse_hover(true);
	*/

	//Set mouse hover state, if enabled
	if (argument0 == true) {
	   if (mouse_hover_check == false) {
	      if (mouse_hover_enable == true) {
	         //Apply cursor sprite, if any
	         if (sprite_exists(global.vg_cur_pointer)) {
	            cursor_sprite = global.vg_cur_pointer;
	            window_set_cursor(cr_none);
	         } else {
	            //Otherwise use native cursor
	            window_set_cursor(global.vg_cur_pointer);
	            cursor_sprite = -1;
	         }
	      }
	      mouse_hover_check = true;
	   }
	   exit;
	} else {
	   //Otherwise reset mouse state
	   if (mouse_hover_check == true) {
	      if (mouse_hover_enable == true) {
	         //Apply cursor sprite, if any
	         if (sprite_exists(global.vg_cur_default)) {
	            cursor_sprite = global.vg_cur_default;
	            window_set_cursor(cr_none);
	         } else {
	            //Otherwise use native cursor
	            window_set_cursor(global.vg_cur_default);
	            cursor_sprite = -1;
	         }
	      }
	      mouse_hover_check = false;
	   }      
	}


}
