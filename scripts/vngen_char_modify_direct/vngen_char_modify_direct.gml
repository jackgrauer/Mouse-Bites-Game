/// @function	vngen_char_modify_direct(name, x, y, z, xscale, yscale, rot);
/// @param		{string|macro}	name
/// @param		{real}			x
/// @param		{real}			y
/// @param		{real}			z
/// @param		{real}			xscale
/// @param		{real}			yscale
/// @param		{real}			rot
/// @author		Lucas Chasteen <lucas.chasteen@xgasoft.com>
/// @copyright	XGASOFT 2020, All Rights Reserved
function vngen_char_modify_direct(argument0, argument1, argument2, argument3, argument4, argument5, argument6) {

	/*
	Applies a number of customizations to the specified character directly, outside
	the context of VNgen events. As some character values are linear and would not 
	benefit from direct access, only non-linear values are included in this script.

	Note that depending on how this script is used, direct modifications may block 
	other modifications from being applied or vice-versa.

	As with other actions, direct modifications will persist until the character is 
	removed or another modification is performed.

	Unlike animations, mods are permanent changes performed once using absolute values. 

	argument0 = identifier of the character to be modified (string) (or keyword 'all' for all)
	argument1 = the new horizontal position to display the character (real)
	argument2 = the new vertical position to display the character (real)
	argument3 = the new drawing depth to display the character, relative to other characters only (real)
	argument4 = the new horizontal scale multiplier to display the character (real)
	argument5 = the new vertical scale multiplier to display the character (real)
	argument6 = the new rotation value to apply to the character, in degrees (real)

	Example usage:
	   vngen_char_modify_direct("John Doe", 50, 100, -1, 1.5, 1.5, 180);
	*/

	/*
	INITIALIZATION
	*/

	//Ensure the target data structure exists
	if (!ds_exists(ds_character, ds_type_grid)) { 
	   exit;
	}

	//Get character slot
	if (argument0 == all) {
	   //Modify all characters, if enabled
	   var ds_target = sys_grid_last(ds_character);
	   var ds_yindex = 0;
	} else {
	   //Otherwise get single character to modify
	   var ds_target = vngen_get_index(argument0, vngen_type_char);
	   var ds_yindex = ds_target;
	}
   
	//If the target character exists...
	if (!is_undefined(ds_target)) { 
	   while (ds_target >= ds_yindex) {                         
	      //Backup original values to temp value slots
	      ds_character[# prop._tmp_x, ds_target] = ds_character[# prop._x, ds_target];           //X
	      ds_character[# prop._tmp_y, ds_target] = ds_character[# prop._y, ds_target];           //Y
	      ds_character[# prop._tmp_xscale, ds_target] = ds_character[# prop._xscale, ds_target]; //X scale
	      ds_character[# prop._tmp_yscale, ds_target] = ds_character[# prop._yscale, ds_target]; //Y scale
	      ds_character[# prop._tmp_rot, ds_target] = ds_character[# prop._rot, ds_target];       //Rotation
      
	      //Apply direct values
	      ds_character[# prop._x, ds_target]  = argument1;     //X
	      ds_character[# prop._y, ds_target]  = argument2;     //Y
	      ds_character[# prop._xscale, ds_target] = argument4; //X scale
	      ds_character[# prop._yscale, ds_target] = argument5; //Y scale
	      ds_character[# prop._rot, ds_target] = argument6;    //Rotation
         
	      //Sort data structure by Z depth
	      if (ds_character[# prop._z, ds_target] != argument3) {
	         ds_character[# prop._z, ds_target] = argument3;   //Z
	         ds_grid_sort(ds_character, prop._z, false);         
	      }
      
	      //Continue to next character, if any
	      ds_target -= 1;
	   }       
	}


}
