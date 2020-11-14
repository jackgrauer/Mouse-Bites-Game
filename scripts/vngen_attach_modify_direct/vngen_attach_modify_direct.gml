/// @function	vngen_attach_modify_direct(name, id, x, y, z, xscale, yscale, rot);
/// @param		{string|macro}	name
/// @param		{real|string}	id
/// @param		{real}			x
/// @param		{real}			y
/// @param		{real}			z
/// @param		{real}			xscale
/// @param		{real}			yscale
/// @param		{real}			rot
/// @author		Lucas Chasteen <lucas.chasteen@xgasoft.com>
/// @copyright	XGASOFT 2020, All Rights Reserved
function vngen_attach_modify_direct(argument0, argument1, argument2, argument3, argument4, argument5, argument6, argument7) {

	/*
	Applies a number of customizations to the specified attachment directly, outside
	the context of VNgen events. As some attachment values are linear and would not 
	benefit from direct access, only non-linear values are included in this script.

	Note that depending on how this script is used, direct modifications may block 
	other modifications from being applied or vice-versa.

	As with other actions, direct modifications will persist until the attachment or
	its parent character is removed or another modification is performed.

	Unlike animations, mods are permanent changes performed once using absolute values. 

	argument0 = identifier of the character to be modified (string)
	argument1 = identifier of the attachment to be modified (real or string) (or keyword 'all' for all)
	argument2 = the new horizontal position to display the character (real)
	argument3 = the new vertical position to display the character (real)
	argument4 = the new drawing depth to display the character, relative to other characters only (real)
	argument5 = the new horizontal scale multiplier to display the character (real)
	argument6 = the new vertical scale multiplier to display the character (real)
	argument7 = the new rotation value to apply to the character, in degrees (real)

	Example usage:
	   vngen_attach_modify_direct("John Doe", "attach", 50, 100, -1, 1.5, 1.5, 180);
	*/

	/*
	INITIALIZATION
	*/

	//Skip action if target data structure doesn't exist
	if (!ds_exists(ds_character, ds_type_grid)) { 
	   exit;
	}

	//Get character target
	var ds_char_target = vngen_get_index(argument0, vngen_type_char);

	//If the target character exists...
	if (!is_undefined(ds_char_target)) {  
	   //Get attachment data from target character
	   var ds_attach = ds_character[# prop._attach_data, ds_char_target]; 

	   //Get attachment slot
	   if (argument1 == all) {
	      //Modify all attachments, if enabled
	      var ds_attach_target = sys_grid_last(ds_attach);
	      var ds_xindex = 0;
	   } else {
	      //Otherwise get single attachment to modify
	      var ds_attach_target = vngen_get_index(argument1, vngen_type_attach, argument0);
	      var ds_xindex = ds_attach_target;
	   }   

	   //If the target attachment exists...
	   if (!is_undefined(ds_attach_target)) {     
	      while (ds_attach_target >= ds_xindex) {               
	         //Backup original values to temp value slots
	         ds_attach[# prop._tmp_x, ds_attach_target] = ds_attach[# prop._x, ds_attach_target];           //X
	         ds_attach[# prop._tmp_y, ds_attach_target] = ds_attach[# prop._y, ds_attach_target];           //Y
	         ds_attach[# prop._tmp_xscale, ds_attach_target] = ds_attach[# prop._xscale, ds_attach_target]; //X scale
	         ds_attach[# prop._tmp_yscale, ds_attach_target] = ds_attach[# prop._yscale, ds_attach_target]; //Y scale
	         ds_attach[# prop._tmp_rot, ds_attach_target] = ds_attach[# prop._rot, ds_attach_target];       //Rotation
      
	         //Apply direct values
	         ds_attach[# prop._x, ds_attach_target]  = argument2;     //X
	         ds_attach[# prop._y, ds_attach_target]  = argument3;     //Y
	         ds_attach[# prop._xscale, ds_attach_target] = argument5; //X scale
	         ds_attach[# prop._yscale, ds_attach_target] = argument6; //Y scale
	         ds_attach[# prop._rot, ds_attach_target] = argument7;    //Rotation
         
	         //Sort data structure by Z depth
	         if (ds_attach[# prop._z, ds_attach_target] != argument4) {
	            ds_attach[# prop._z, ds_attach_target] = argument4;   //Z
	            ds_grid_sort(ds_attach, prop._z, false);         
	         }
         
	         //Continue to next attachment, if any
	         ds_attach_target -= 1;
	      } 
	   }       
	}


}
