/// @function	vngen_log_get_index(entry);
/// @param		{integer}	entry
/// @author		Lucas Chasteen <lucas.chasteen@xgasoft.com>
/// @copyright	XGASOFT 2020, All Rights Reserved
function vngen_log_get_index(argument0) {

	/*
	VNgen uses two indices to store backlog entries: one is the order in which the backlog
	entry appears on the screen, and the other is the order in which it was recorded
	historically.

	Since logs have a max size at which point older entries are purged, it is likely these 
	two indices will get out of sync quickly, and then it becomes difficult to manually add
	new data at the appropriate position in the backlog.

	This script solves this issue by accepting the entry number as it appears on the screen
	and returning the entry's historical index. The 'previous' keyword can also be supplied
	to retrieve the historical index of the most recent on-screen entry.

	If the specified entry does not exist, -1 will be returned instead.

	argument0 = the entry number to check, starting at 0 (integer) (or -1 for previous)

	Example usage:
	   var index = vngen_log_get_index(previous);
   
	   vngen_log_add(index + 1, "Hello, world!");
	*/

	//Skip if backlog does not exist
	if (!ds_exists(global.ds_log, ds_type_grid)) {
	   return -1;
	}

	//Get on-screen index to check
	if (argument0 >= 0) {
	   var index = min(argument0, ds_grid_height(global.ds_log) - 1);
	} else {
	   //If keyword 'previous' is used, get the most recent index
	   var index = ds_grid_height(global.ds_log) - 1;
	}

	//Get historical index value from on-screen entry
	if (index >= 0) {
	   index = global.ds_log[# prop._data_event, index];
	} else {
	   //If entry does not exist, mark index as undefined
	   index = undefined;
	}

	//Return historical index, if any
	if (index != undefined) {
	   return index;
	} else {
	   //Otherwise, if entry does not exist, return -1
	   return -1;
	}


}
