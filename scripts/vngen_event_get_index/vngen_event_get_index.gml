/// @function	vngen_event_get_index([label]);
/// @param		{string}	[label]
/// @author		Lucas Chasteen <lucas.chasteen@xgasoft.com>
/// @copyright	XGASOFT 2020, All Rights Reserved
function vngen_event_get_index() {

	/*
	Returns the ID of the currently active event, or the event assigned to
	the specified label, if any. If the label cannot be found, the current
	event index will be returned instead. 

	Intended for use in debug statistics and to identify targets for functions 
	such as vngen_goto.

	argument0 = the label of the event to get index of (string) (optional, use no argument for current)

	Example usage: 
	   draw_text(x, y, string(vngen_event_get_index()));
	   draw_text(x, y, string(vngen_event_get_index("my_event")));
	*/

	//If a label is supplied...
	if (argument_count > 0) {
	   var yindex;
   
	   //Check for matching event label
	   if (is_array(event_label)) {
	      for (yindex = 0; yindex < array_length_1d(event_label); yindex += 1) {
	         //Return the matching event index
	         if (event_label[yindex] == argument[0]) {
	            return yindex;
	         }
	      }
	   }
	}

	//Otherwise return the currently active event
	return event_current;


}
