/// @function	sys_log_get_xoffset(entity, index, char_index);
/// @param		{integer}	entity
/// @param		{integer}	index
/// @param		{integer}	char_index
/// @author		Lucas Chasteen <lucas.chasteen@xgasoft.com>
/// @copyright	XGASOFT 2020, All Rights Reserved
function sys_log_get_xoffset(argument0, argument1, argument2) {

	/*
	==========================================================================
	SYSTEM FUNCTION: MODIFY AT YOUR OWN RISK!
	--------------------------------------------------------------------------
	  System functions are executed automatically by the engine and typically
	  should not be run manually by the user
	==========================================================================

	Returns the horizontal offset of the logged line of text based on the
	stored paragraph alignment, originally set by vngen_set_halign.

	argument0 = the data structure for the entity to check (integer)
	argument1 = the index of the row containing the target entity ID (integer)
	argument2 = the character index of the string, used to check line count (integer)

	Example usage:
	   var line_x = sys_log_get_xoffset(ds_log_text, ds_xindex, char_index);
	*/

	//Get the target data structure
	var ds_data = argument0;
	var ds_target = argument1;

	//Initialize temporary variables for calculating line offset
	var line_align = ds_data[# prop._txt_halign, ds_target];
	var line_x = 0;
	var surf_width = surface_get_width(ds_data[# prop._surf, ds_target]);

	//Ensure linebreak data exists
	if (!ds_exists(ds_data[# prop._txt_line_data, ds_target], ds_type_list)) {
	   ds_data[# prop._txt_line_data, ds_target] = ds_list_create();
	}

	//Get linebreak data
	var ds_line = ds_data[# prop._txt_line_data, ds_target];

	//Get line starting position based on paragraph alignment
	if (line_align != fa_left) {
	   //Get the line index to check for linebreak data
	   var line_count = string_count("\\n", string_copy(ds_data[# prop._txt, ds_target], 1, argument2 + 1));
   
	   //If linebreak data exists, get offset
	   if (ds_line[| line_count] != undefined) {
	      //Center-aligned
	      if (line_align == fa_center) {
	         line_x = (surf_width - ds_line[| line_count])*0.5;
	      }
      
	      //Right-aligned         
	      if (line_align == fa_right) {
	         line_x = (surf_width - ds_line[| line_count]);
	      }
	   }
	}   

	//Return final offset
	return line_x;


}
