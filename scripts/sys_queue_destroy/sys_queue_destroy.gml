/// @function	sys_queue_destroy(id);
/// @param		{string}	id
/// @author		Lucas Chasteen <lucas.chasteen@xgasoft.com>
/// @copyright	XGASOFT 2020, All Rights Reserved
function sys_queue_destroy() {

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

	This script will remove all current queued data from memory, particularly so
	that it will not be submitted later.

	VNgen's handling of this functionality is highly tailored for its particular
	use-cases and is not intended for general use.

	argument0 = the ID of the queue to destroy (string)

	Example usage:
	   sys_queue_destroy("log");
	*/

	//Get the target queue ID string
	var ds_queue = "sys_queue_" + argument[0];

	//If the target queue ID doesn't exist, skip deletion
	if (!variable_global_exists(ds_queue)) {
	   exit;
	}

	//If the target queue data structure doesn't exist, skip deletion
	if (!ds_exists(variable_global_get(ds_queue), ds_type_grid)) {
	   exit;
	}

	//Get the target queue data structure
	ds_queue = variable_global_get(ds_queue);

	//Dequeue data from grid
	ds_grid_destroy(ds_queue);
	variable_global_set("sys_queue_" + argument[0], -1);


}
