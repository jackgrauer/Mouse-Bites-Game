/// @function	vngen_set_cursor(default, pointer);
/// @param		{sprite}	default
/// @param		{sprite}	pointer
/// @author		Lucas Chasteen <lucas.chasteen@xgasoft.com>
/// @copyright	XGASOFT 2020, All Rights Reserved
function vngen_set_cursor(argument0, argument1) {

	/*
	VNgen uses two sprite states, one default and one for hovering options
	and markup links. By default these cursor states will be displayed as
	the native cursors for the target operating system, but with this
	script, sprites or other built-in cursors can be assigned instead.

	To revert from custom cursors back to defaults, -4 can be supplied
	instead of a sprite or cursor state.

	argument0 = sprite or cursor to use as default cursor (sprite) (optional, use 'none' for default)
	argument1 = sprite or cursor to use as hover cursor (sprite) (optional, use 'none' for default)

	Example usage:
	   vngen_set_cursor(spr_cur_default, spr_cur_pointer);
	   vngen_set_cursor(cr_handpoint, cr_size_all);
	*/

	//Set default cursor sprite, if any
	if (sprite_exists(argument0)) {
	   global.vg_cur_default = argument0;
   
	   //Apply default cursor sprite
	   cursor_sprite = global.vg_cur_default;
	   window_set_cursor(cr_none);
	} else {
	   //Otherwise use native cursor
	   if (argument0 >= -1) {
	      global.vg_cur_default = argument0;
	   } else {
		  //Reset to default if no cursor is set
	      global.vg_cur_default = cr_arrow;
	   }
   
	   //Apply native cursor
	   window_set_cursor(global.vg_cur_default);
	   cursor_sprite = -1;
	}

	//Set hover cursor sprite, if any
	if (sprite_exists(argument1)) {
	   global.vg_cur_pointer = argument1;
	} else {
	   //Otherwise use native cursor
	   if (argument1 >= -1) {
		  global.vg_cur_pointer = argument1; 
	   } else {
		  //Reset to default if no cursor is set
	      global.vg_cur_pointer = cr_handpoint;
	   }
	}


}
