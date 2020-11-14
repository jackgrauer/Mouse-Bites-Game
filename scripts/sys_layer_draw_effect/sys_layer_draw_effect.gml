/// @function	sys_layer_draw_effect();
/// @author		Lucas Chasteen <lucas.chasteen@xgasoft.com>
/// @copyright	XGASOFT 2020, All Rights Reserved
function sys_layer_draw_effect() {

	/*
	==========================================================================
	SYSTEM FUNCTION: MODIFY AT YOUR OWN RISK!
	--------------------------------------------------------------------------
	  System functions are executed automatically by the engine and typically
	  should not be run manually by the user
	==========================================================================

	Draws and/or performs effects. 

	No parameters
            
	Example usage:
	   sys_layer_draw_effect();
	*/

	/*
	EFFECTS
	*/

	//Skip processing if vngen_object_clear has been run
	if (event_current < 0) {
	   exit;
	}

	//Perform effects
	var ds_yindex;
	for (ds_yindex = 0; ds_yindex < ds_grid_height(ds_effect); ds_yindex += 1) {
	   sys_effect_perform(ds_yindex, room_xoffset, room_yoffset);
	}


}
