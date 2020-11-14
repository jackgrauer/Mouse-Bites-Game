/// @function	vngen_goto_unread([perform]);
/// @param		{boolean}	[perform]
/// @author		Lucas Chasteen <lucas.chasteen@xgasoft.com>
/// @copyright	XGASOFT 2020, All Rights Reserved
function vngen_goto_unread() {

	/*
	Skips previously-read events until an unread event (or the end of the object)
	is reached.

	VNgen events between the source and unread event will be performed by default. 
	To disable this behavior, the 'perform' argument can be set to 'false'. 

	argument0 = enables or disables performing skipped events (boolean) (true/false) (optional, use no argument for enabled)

	Example usage: 
	   vngen_goto_unread();
	   vngen_goto_unread(false);
	*/

	//Wait for previous skip operation to finish, if any
	if (sys_event_skip()) or (sys_read_skip()) {
	   exit;
	}

	//Get event to skip from
	event_skip_src = event_current;

	//Enable skipping read events
	event_skip_read = true;

	//Enable or disable performing skipped events, if specified
	if (argument_count > 0) {
	   event_skip_perform = argument[0];
	}
   
	//Submit current log data
	sys_queue_submit("log");


}
