/// @function	sys_grid_last(ds_grid);
/// @param		{ds_grid} ds_grid
/// @author		Lucas Chasteen <lucas.chasteen@xgasoft.com>
/// @copyright	XGASOFT 2020, All Rights Reserved
function sys_grid_last(argument0) {

	/*
	==========================================================================
	SYSTEM FUNCTION: MODIFY AT YOUR OWN RISK!
	--------------------------------------------------------------------------
	  System functions are executed automatically by the engine and typically
	  should not be run manually by the user
	==========================================================================

	Returns the last available index in the input ds_grid, or 'undefined' if the
	grid does not exist or is empty

	argument0 = the data structure to retrieve index of (ds_grid)
            
	Example usage:
	   var ds_target = sys_grid_last(ds_text);
	*/

	//Get data structure
	var ds_data = argument0;

	//If data structure exists...
	if (ds_exists(ds_data, ds_type_grid)) {
	   //And data structure is not empty...
	   if (ds_grid_height(ds_data) > 0) {
	      //Return the last index
	      return ds_grid_height(ds_data) - 1;
	   }
	}

	//Otherwise, return undefined for empty data
	return undefined;


}
