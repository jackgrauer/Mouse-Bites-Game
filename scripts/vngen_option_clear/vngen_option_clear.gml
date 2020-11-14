/// @function	vngen_option_clear([id]);
/// @param		{real|string}	[id]
/// @author		Lucas Chasteen <lucas.chasteen@xgasoft.com>
/// @copyright	XGASOFT 2020, All Rights Reserved
function vngen_option_clear() {

	/*
	Manually clears option **results** (not data) to prevent repeated execution of 
	option-based triggers. 

	This script behaves differently depending on whether or not a specific option
	ID is supplied:

	If no ID is supplied, the most recent option result will be cleared from
	**memory**, but not the option **history**, which can still be recalled with
	vngen_get_option. (Running the script this way is not necessary if automatic
	clearing is enabled in vngen_get_option.)

	If an ID is supplied, the option result will be cleared from **history**, and
	it will be as if the choice was never made. However, the most recent option
	result in **memory** will not be cleared.

	argument0 = the ID of the option block to clear result from (real or string) (optional, use no argument for most recent)

	Example usage:
	   if (vngen_get_option(false) == "option1") {
	      my_var += 1;
	      vngen_option_clear();
	   }
   
	   var result = vngen_get_option("my_option");
	   vngen_option_clear("my_option");
	*/

	//Skip action if options are still active
	if (option_count > 0) or (option_exit == true) or (option_pause > 0) {
	   exit;
	}

	//Clear option results
	if (argument_count == 0) {
	   //Clear options from memory
	   option_result = -1;
	} else {
	   //Clear options from history
	   if (ds_exists(global.ds_option_result, ds_type_map)) {
	      if (ds_map_exists(global.ds_option_result, argument[0])) {
	         ds_map_delete(global.ds_option_result, argument[0]);
	      }
	   }
	}


}
