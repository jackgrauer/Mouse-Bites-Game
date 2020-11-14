/// @function	vngen_textbox_modify_direct(id, x, y, z, xscale, yscale, rot);
/// @param		{real|string|macro}	id
/// @param		{real}				x
/// @param		{real}				y
/// @param		{real}				z
/// @param		{real}				xscale
/// @param		{real}				yscale
/// @param		{real}				rot
/// @author		Lucas Chasteen <lucas.chasteen@xgasoft.com>
/// @copyright	XGASOFT 2020, All Rights Reserved
function vngen_textbox_modify_direct(argument0, argument1, argument2, argument3, argument4, argument5, argument6) {

	/*
	Applies a number of customizations to the specified textbox directly, outside
	the context of VNgen events. As some textbox values are linear and would not 
	benefit from direct access, only non-linear values are included in this script.

	Note that depending on how this script is used, direct modifications may block 
	other modifications from being applied or vice-versa.

	As with other actions, direct modifications will persist until the textbox is 
	removed or another modification is performed.

	Unlike animations, mods are permanent changes performed once using absolute values. 

	argument0 = identifier of the textbox to be modified (real or string) (or keyword 'all' for all)
	argument1 = the new horizontal position to display the textbox (real)
	argument2 = the new vertical position to display the textbox (real)
	argument3 = the new drawing depth to display the textbox, relative to other textboxes only (real)
	argument4 = the new horizontal scale multiplier to display the textbox (real)
	argument5 = the new vertical scale multiplier to display the textbox (real)
	argument6 = the new rotation value to apply to the textbox, in degrees (real)

	Example usage:
	   vngen_textbox_modify_direct("textbox", 50, 100, -1, 1.5, 1.5, 180);
	*/

	/*
	INITIALIZATION
	*/

	//Ensure the target data structure exists
	if (!ds_exists(ds_textbox, ds_type_grid)) { 
	   exit;
	}

	//Get textbox slot
	if (argument0 == all) {
	   //Modify all textboxes, if enabled
	   var ds_target = sys_grid_last(ds_textbox);
	   var ds_yindex = 0;
	} else {
	   //Otherwise get single textbox to modify
	   var ds_target = vngen_get_index(argument0, vngen_type_textbox);
	   var ds_yindex = ds_target;
	}
   
	//If the target textbox exists...
	if (!is_undefined(ds_target)) {           
	   while (ds_target >= ds_yindex) {           
	      //Backup original values to temp value slots
	      ds_textbox[# prop._tmp_x, ds_target] = ds_textbox[# prop._x, ds_target];           //X
	      ds_textbox[# prop._tmp_y, ds_target] = ds_textbox[# prop._y, ds_target];           //Y
	      ds_textbox[# prop._tmp_xscale, ds_target] = ds_textbox[# prop._xscale, ds_target]; //X scale
	      ds_textbox[# prop._tmp_yscale, ds_target] = ds_textbox[# prop._yscale, ds_target]; //Y scale
	      ds_textbox[# prop._tmp_rot, ds_target] = ds_textbox[# prop._rot, ds_target];       //Rotation
      
	      //Apply direct values
	      ds_textbox[# prop._x, ds_target] = argument1;      //X
	      ds_textbox[# prop._y, ds_target] = argument2;      //Y
	      ds_textbox[# prop._xscale, ds_target] = argument4; //X scale
	      ds_textbox[# prop._yscale, ds_target] = argument5; //Y scale
	      ds_textbox[# prop._rot, ds_target] = argument6;    //Rotation
         
	      //Sort data structure by Z depth
	      if (ds_textbox[# prop._z, ds_target] != argument3) {
	         ds_textbox[# prop._z, ds_target] = argument3;   //Z
	         ds_grid_sort(ds_textbox, prop._z, false);         
	      }
      
	      //Continue to next textbox, if any
	      ds_target -= 1;
	   }  
	}


}
