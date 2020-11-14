/// @function	cmd_vngen_log_clear([destroy]);
/// @param		{boolean} [destroy]
/// @author		Lucas Chasteen <lucas.chasteen@xgasoft.com>
/// @copyright	XGASOFT 2020, All Rights Reserved
function cmd_vngen_log_clear() {

	/*
	==========================================================================
	SYSTEM FUNCTION: MODIFY AT YOUR OWN RISK!
	--------------------------------------------------------------------------
	  System functions are executed automatically by the engine and typically
	  should not be run manually by the user
	==========================================================================

	A command script for use with the VNgen command console.

	Note that all arguments passed from the command console are passed as strings
	and must be converted to reals manually, if necessary.

	See sys_cmd_add to add commands to the console.
	*/

	//Check for correct input
	if (argument_count > 1) {
	   //Return argument error if input is malformed
	   return "Error: Wrong number of arguments";
	}

	//Get log object
	var inst_index;
	var obj_index = -1;
	for (inst_index = 0; inst_index < instance_count; inst_index += 1) {
	   if (variable_instance_exists(instance_id[inst_index], "log_touch_active")) {
	      obj_index = instance_id[inst_index];
	      break;
	   }
	}

	//Skip operation if no log object is found
	if (obj_index == -1) {
	   return "Error: Log object not found";
	}

	//Get destroy setting
	var destroy = false;
	if (argument_count > 0) {
	   switch (argument[0]) {
	      //Destroy
	      case "true": destroy = true; break;
      
	      //Do not destroy
	      case "false": destroy = false; break;
      
	      //Otherwise return input error
	      default: return "Error: Value must be true or false";
	   } 
	}

	//Clear log
	with (obj_index) {
	   vngen_log_clear(destroy);
	}

	//Return result
	return "Log cleared successfully";


}
