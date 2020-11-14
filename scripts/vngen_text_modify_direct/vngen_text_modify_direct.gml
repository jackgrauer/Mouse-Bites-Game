/// @function	vngen_text_modify_direct(id, x, y, z, xscale, yscale, rot);
/// @param		{real|string|macro}	id
/// @param		{real}				x
/// @param		{real}				y
/// @param		{real}				z
/// @param		{real}				xscale
/// @param		{real}				yscale
/// @param		{real}				rot
/// @author		Lucas Chasteen <lucas.chasteen@xgasoft.com>
/// @copyright	XGASOFT 2020, All Rights Reserved
function vngen_text_modify_direct(argument0, argument1, argument2, argument3, argument4, argument5, argument6) {

	/*
	Applies a number of customizations to the specified string of text directly, 
	outside the context of VNgen events. As some text values are linear and 
	would not benefit from direct access, only non-linear values are included in 
	this script.

	Note that depending on how this script is used, direct modifications may block 
	other modifications from being applied or vice-versa.

	As with other actions, direct modifications will persist until the text is 
	removed or another modification is performed.

	Unlike animations, mods are permanent changes performed once using absolute values. 

	argument0 = identifier of the text to be modified (real or string) (or keyword 'all' for all)
	argument1 = the new horizontal position to display the text (real)
	argument2 = the new vertical position to display the text (real)
	argument3 = the new drawing depth to display the text, relative to other text only (real)
	argument4 = the new horizontal scale multiplier to display the text (real)
	argument5 = the new vertical scale multiplier to display the text (real)
	argument6 = the new rotation value to apply to the text, in degrees (real)

	Example usage:
	   vngen_text_modify_direct("text", 50, 100, -1, 1.5, 1.5, 180);
	*/

	/*
	INITIALIZATION
	*/

	//Ensure the target data structure exists
	if (!ds_exists(ds_text, ds_type_grid)) { 
	   exit;
	}

	//Get text slot
	if (argument0 == all) {
	   //Modify all text, if enabled
	   var ds_target = sys_grid_last(ds_text);
	   var ds_yindex = 0;
	} else {
	   //Otherwise get single text to modify
	   var ds_target = vngen_get_index(argument0, vngen_type_text);
	   var ds_yindex = ds_target;
	}
   
	//If the target text exists...
	if (!is_undefined(ds_target)) {          
	   while (ds_target >= ds_yindex) {            
	      //Backup original values to temp value slots
	      ds_text[# prop._tmp_x, ds_target] = ds_text[# prop._x, ds_target];           //X
	      ds_text[# prop._tmp_y, ds_target] = ds_text[# prop._y, ds_target];           //Y
	      ds_text[# prop._tmp_xscale, ds_target] = ds_text[# prop._xscale, ds_target]; //X scale
	      ds_text[# prop._tmp_yscale, ds_target] = ds_text[# prop._yscale, ds_target]; //Y scale
	      ds_text[# prop._tmp_rot, ds_target] = ds_text[# prop._rot, ds_target];       //Rotation
      
	      //Apply direct values
	      ds_text[# prop._x, ds_target]  = argument1;     //X
	      ds_text[# prop._y, ds_target]  = argument2;     //Y
	      ds_text[# prop._xscale, ds_target] = argument4; //X scale
	      ds_text[# prop._yscale, ds_target] = argument5; //Y scale
	      ds_text[# prop._rot, ds_target] = argument6;    //Rotation
         
	      //Sort data structure by Z depth
	      if (ds_text[# prop._z, ds_target] != argument3) {
	         ds_text[# prop._z, ds_target] = argument3;   //Z
	         ds_grid_sort(ds_text, prop._z, false);         
	      }
      
	      //Continue to next text, if any
	      ds_target -= 1;
	   }       
	}


}
