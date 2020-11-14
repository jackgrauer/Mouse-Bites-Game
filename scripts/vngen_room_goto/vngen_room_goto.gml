/// @function	vngen_room_goto(room, [event, object], [perform]);
/// @param		{room}				room
/// @param		{integer|string}	[event
/// @param		{object}			object]
/// @param		{boolean}			[perform]
/// @author		Lucas Chasteen <lucas.chasteen@xgasoft.com>
/// @copyright	XGASOFT 2020, All Rights Reserved
function vngen_room_goto() {

	/*
	Ends the current room and activates the specified room index in its place,
	safely clearing VNgen data in the process to prevent errors and memory leaks.

	argument0 = the room to jump to (room)
	argument1 = the VNgen event ID or label to jump to (integer or string) (optional)
	argument2 = the object containing the desired event (object) (optional, but required if event is set)
	argument3 = enables or disables performing skipped events (boolean) (true/false) (optional, use no argument for enabled)

	Example usage: 
	   vngen_room_goto(room_first);
	*/
   
	//Submit current log data
	sys_queue_submit("log");

	//Clear VNgen object data in the current room
	var inst_index;
	for (inst_index = 0; inst_index < instance_count; inst_index += 1) {
	   if (variable_instance_exists(instance_id[inst_index], "ds_text")) {
	      with (instance_id[inst_index]) {
	         vngen_object_clear(true); 
	      }
	   }
	}

	//Go to object in room, if specified
	if (argument_count > 1) {
	   //Set object and event to go to
	   global.vg_room_object = argument[2];
	   global.vg_room_event = argument[1];
   
	   //Set whether to perform skipped events, if specified
	   if (argument_count > 3) {
		   global.vg_room_event_perform = argument[3];
	   }
   
	   //Create proxy object to go to target event
	   room_instance_add(argument[0], 0, 0, obj_vngen_room_goto_proxy);
	}
   
	//Go to target room
	room_goto(argument[0]);


}
