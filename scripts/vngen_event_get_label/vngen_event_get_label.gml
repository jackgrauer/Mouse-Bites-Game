/// @function	vngen_event_get_label([index]);
/// @param		{integer}	[index]
/// @author		Lucas Chasteen <lucas.chasteen@xgasoft.com>
/// @copyright	XGASOFT 2020, All Rights Reserved
function vngen_event_get_label() {

	/*
	Returns the string label of the currently active event, or the event assigned 
	to the specified index, if any. If the index does not exist, the current event 
	label will be returned instead.

	Intended for use in debug statistics and to identify targets for functions 
	such as vngen_goto.

	argument0 = the index of the event to get label of (integer) (optional, use no argument for current)

	Example usage: 
	   draw_text(x, y, vngen_event_get_label());
	   draw_text(x, y, vngen_event_get_label(5));
	*/

	//Skip if event label array does not exist
	if (!is_array(event_label)) {
	   return "";
	}

	//If an index is supplied...
	if (argument_count > 0) {
	   //Return the matching event label
	   if (argument[0] >= 0) and (argument[0] < event_count) {
	      return event_label[argument[0]];
	   }
	}

	//Otherwise return the currently active event label
	return event_label[clamp(event_current, 0, max(1, event_count - 1))];


}
