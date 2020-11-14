/// @function	sys_queue_enqueue(id, [value0], [value1] ...);
/// @param		{string}		id
/// @param		{real|string}	[value0]
/// @param		{real|string}	[value1]
/// @author		Lucas Chasteen <lucas.chasteen@xgasoft.com>
/// @copyright	XGASOFT 2020, All Rights Reserved
function sys_queue_enqueue() {

	/*
	==========================================================================
	SYSTEM FUNCTION: MODIFY AT YOUR OWN RISK!
	--------------------------------------------------------------------------
	  System functions are executed automatically by the engine and typically
	  should not be run manually by the user
	==========================================================================

	Although it might seem strange, at times it is useful to enqueue information
	using a ds_grid instead of a ds_queue. VNgen uses this functionality to delay 
	propagation of certain information until the end of an event, such as logged
	strings and audio.

	VNgen's handling of this functionality is highly tailored for its particular
	use-cases and is not intended for general use.

	argument0 = the ID of the queue to add data to (string)
	argument1 = the value to add to column 0 of the row (real or string)
	argument2 = the value to add to column 1 of the row (real or string)
	argument3 = etc...

	Example usage:
	   sys_queue_enqueue("log", "Hello, world!", "John Doe");
	*/

	//Get the target queue ID string
	var ds_queue = "sys_queue_" + argument[0];

	//If the target queue ID doesn't exist, create it
	if (!variable_global_exists(ds_queue)) {
	   variable_global_set(ds_queue, -1);
	}

	//If the target queue data structure doesn't exist, create it
	if (!ds_exists(variable_global_get(ds_queue), ds_type_grid)) {
	   variable_global_set(ds_queue, ds_grid_create(max(1, argument_count - 1), 0));
	}

	//Get the target queue data structure
	ds_queue = variable_global_get(ds_queue);

	//Get the current number of entries in the target queue
	var ds_target = ds_grid_height(ds_queue);
	var ds_xindex;

	//Create new data slot in the queue
	ds_grid_resize(ds_queue, max(argument_count - 1, ds_grid_width(ds_queue)), ds_target + 1);

	//Add data to the queue
	for (ds_xindex = 1; ds_xindex < argument_count; ds_xindex += 1) {
	   ds_queue[# ds_xindex - 1, ds_target] = argument[ds_xindex];
	}


}
