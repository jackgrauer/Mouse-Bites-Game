/// @function	vngen_goto(event, [object], [perform]);
/// @param		{integer|string}	event
/// @param		{object}			[object]
/// @param		{boolean}			[perform]
/// @author		Lucas Chasteen <lucas.chasteen@xgasoft.com>
/// @copyright	XGASOFT 2020, All Rights Reserved
function vngen_goto() {

	/*
	Jumps to the specified event, creating the containing object (and destroying
	the current one) if necessary. If no object is specified, the current object
	will be assumed. The 'self' keyword may also be supplied instead.

	VNgen events between the source and destination event will be performed by
	default. To disable this behavior, the 'perform' argument can be set to 
	'false'. Note that an object must be supplied in order to disable events.

	This script can be used to jump both forwards and backwards. To identify the
	desired event ID, count your events from 0 or use the vngen_event_get_index
	script to identify the event in-game. It is also possible to use 
	vngen_event_get_index with math, e.g. to add direct support for backtracking.

	If the target event has a label, this label can also be supplied in place of
	a numeric event ID.

	argument0 = the event ID or label to jump to (integer or string)
	argument1 = the object containing the desired event (object) (optional, use no argument for current object)
	argument2 = enables or disables performing skipped events (boolean) (true/false) (optional, use no argument for enabled)

	Example usage: 
	   vngen_goto(5, obj_script);
	   vngen_goto(0);
	   vngen_goto("my_event");
	   vngen_goto(vngen_event_get_index() - 1);
	*/

	//Wait for previous skip operation to finish, if any
	if (variable_instance_exists(id, "ds_text")) {
	   if (sys_event_skip()) or (sys_read_skip()) {
	      exit;
	   }
	}

	//Assume local event by default
	var event_local = true;

	//Otherwise use other object event, if specified
	if (argument_count > 1) {
	   if (argument[1] != object_index) and (argument[1] != self) {
	      event_local = false;
	   }
	}

	//If event is in current object...
	if (event_local == true) {
	   //Get event to skip from
	   event_skip_src = event_current;
   
	   //Get event to skip to
	   if (is_string(argument[0])) {
	      //Event label
	      event_skip_id = -1;
	      event_skip_label = argument[0];
	   } else {
	      //Event ID
	      event_skip_id = argument[0];
	      event_skip_label = -1;
	   }
   
	   //Enable or disable performing skipped events, if specified
	   if (argument_count > 2) {
	      event_skip_perform = argument[2];
	   }
   
	   //Submit current log data
	   sys_queue_submit("log");
         
	   //Disable drawing until skip is complete
	   draw_enable_drawevent(false);
	} else {
	   //Otherwise create object and jump to event, if it exists
	   if (object_exists(argument[1])) {
	      with (instance_create_layer(x, y, layer, argument[1])) {
	         //Get event to skip to
	         if (is_string(argument[0])) {
	            //Event label
	            event_skip_id = -1;
	            event_skip_label = argument[0];
	         } else {
	            //Event ID
	            event_skip_id = argument[0];
	            event_skip_label = -1;
	         }
   
	         //Enable or disable performing skipped events, if specified
	         if (argument_count > 2) {
	            event_skip_perform = argument[2];
	         }
   
	         //Submit current log data
	         sys_queue_submit("log");
         
	         //Disable drawing until skip is complete
	         draw_enable_drawevent(false);    
	      }
   
	      //Remove the current object
	      vngen_object_clear(true);  
	   }
	}



}
