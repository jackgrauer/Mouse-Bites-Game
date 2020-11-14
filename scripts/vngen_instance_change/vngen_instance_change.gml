/// @function	vngen_instance_change(object, [perform]);
/// @param		{object}	object
/// @param		{boolean}	[perform]
/// @author		Lucas Chasteen <lucas.chasteen@xgasoft.com>
/// @copyright	XGASOFT 2020, All Rights Reserved
function vngen_instance_change() {

	/*
	Safely ends the current object, removing VNgen data from memory, while
	creating a new object in its place. While the new object isn't required 
	to contain VNgen content, it is required to run this script to exit an 
	object that does. If the new object **does** contain VNgen content,
	the 'perform' argument MUST be set to 'true' (enabled by default).

	To end a VNgen object without replacing it, see vngen_object_clear.

	argument0 = the object to be created in place of the current one (object)
	argument1 = enables or disables performing destroy and create events on replace (boolean) (true/false) (optional, use no argument for true)

	Example usage:
	   vngen_instance_change(obj_new_script);
	   vngen_instance_change(obj_new_script, false);
	*/

	//Enable performing events by default
	var perf = true;

	//Disable performing events if specified
	if (argument_count > 1) {
		perf = argument[1];
	}
   
	//Submit current log data
	sys_queue_submit("log");

	//Clear VNgen data from the running object
	vngen_object_clear(false);

	//Replace the running object with a new one
	instance_change(argument[0], perf);


}
