/// @function	vngen_event_get_read([index]);
/// @param		{integer}	[index]
/// @author		Lucas Chasteen <lucas.chasteen@xgasoft.com>
/// @copyright	XGASOFT 2020, All Rights Reserved
function vngen_event_get_read() {

	/*
	Returns the read state of the currently active event, or the event assigned 
	to the specified index, if any. If the index does not exist, the current
	event state will be returned instead.

	argument0 = the index of the event to get state of (integer) (optional, use no argument for current)

	Example usage:
		if (vngen_event_get_read(vngen_event_get_index() + 1)) {
			vngen_do_continue();
		}
	*/

	//Skip if event read log does not exist
	if (!ds_exists(global.ds_read, ds_type_map)) {
	   return false;
	}

	//Use input index, if any
	if (argument_count > 0) {
		var event_target = argument[0];
	} else {
		//Otherwise use current event
		var event_target = event_current;
	}

	//Get read state
	var event_read = global.ds_read[? object_get_name(object_index) + "_" + string(event_target)];

	//Treat undefined as false
	if (is_undefined(event_read)) {
		event_read = false;
	}

	//Return read state
	return event_read;


}
