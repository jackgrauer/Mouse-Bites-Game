/// @function	sys_grid_delete(ds_grid, row);
/// @param		{ds_grid}	ds_grid
/// @param		{integer}	row
/// @author		Lucas Chasteen <lucas.chasteen@xgasoft.com>
/// @copyright	XGASOFT 2020, All Rights Reserved
function sys_grid_delete(argument0, argument1) {

	/*
	==========================================================================
	SYSTEM FUNCTION: MODIFY AT YOUR OWN RISK!
	--------------------------------------------------------------------------
	  System functions are executed automatically by the engine and typically
	  should not be run manually by the user
	==========================================================================

	Removes a row from the specified ds_grid while preserving other data and
	returns the final grid.

	Note that the final grid **must** be assigned to a variable to prevent
	memory leaks! It is recommended to use the same variable as is assigned
	to the original grid.

	argument0 = the data structure to remove row from (ds_grid)
	argument1 = the index of the row to remove (integer)
            
	Example usage:
	   ds_character = sys_grid_delete(ds_character, 1);
	*/

	//Get data structure
	var ds_data = argument0;

	//Get data structure dimensions
	var ds_height = ds_grid_height(ds_data) - 1; 
	var ds_width = ds_grid_width(ds_data) - 1; 

	//Reset invalid previous data structure records
	global.ds_pdata = none;
	global.ds_ptype = none;
	global.ds_pxindex = 0;
	global.ds_pyindex = 0;

	//Remove row from data structure
	if (ds_height > 0) {
	   //If not the last, preserve other data
	   if (argument1 < ds_height) {
	      ds_grid_set_grid_region(ds_data, ds_data, 0, argument1 + 1, ds_width, ds_height, 0, argument1);
	   }
	   ds_grid_resize(ds_data, ds_width + 1, max(1, ds_height));  
   
	   //Return the final grid
	   return ds_data; 
	} else {
	   //Otherwise clear data structure if last row
	   ds_grid_destroy(ds_data);
   
	   //Return the final grid
	   return ds_grid_create(ds_width + 1, 0);     
	}


}
