/// @function	vngen_event_count();
/// @author		Lucas Chasteen <lucas.chasteen@xgasoft.com>
/// @copyright	XGASOFT 2020, All Rights Reserved
function vngen_event_count() {

	/*
	Returns the total number of events in the active object. Intended for use in
	debug statistics and to identify targets for functions such as vngen_goto.

	Note that there is a single frame during initialization in which the event
	count has not been calculated yet. For the duration of this frame, this script
	will return 0 even though events exist.

	No parameters

	Example usage:
	   vngen_goto(vngen_event_count() - 1);
	*/

	//Return the current total number of events
	return event_count;


}
