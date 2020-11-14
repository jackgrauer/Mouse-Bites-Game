/// @function	vngen_log_count();
/// @author		Lucas Chasteen <lucas.chasteen@xgasoft.com>
/// @copyright	XGASOFT 2020, All Rights Reserved
function vngen_log_count() {

	/*
	Returns the current total number of events in the backlog as an integer, or 0 if
	the log does not exist.

	No parameters

	Example usage:
	   show_message("The backlog currently contains data for " + string(vngen_log_count()) + " events.");
	*/

	//Get the number of log entries, if any
	if (ds_exists(global.ds_log, ds_type_grid)) {
	   var ds_height = ds_grid_height(global.ds_log);
	} else {
	   //Otherwise return 0 for empty
	   var ds_height = 0;
	}
   
	//Return logged entry count
	return ds_height;


}
