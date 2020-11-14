/// @function	sys_cmd_add(command, script);
/// @param		{string} command
/// @param		{script} script
/// @author		Lucas Chasteen <lucas.chasteen@xgasoft.com>
/// @copyright	XGASOFT 2020, All Rights Reserved
function sys_cmd_add(argument0, argument1) {

	/*
	==========================================================================
	SYSTEM FUNCTION: MODIFY AT YOUR OWN RISK!
	--------------------------------------------------------------------------
	  System functions are executed automatically by the engine and typically
	  should not be run manually by the user
	==========================================================================

	Adds a command to the command console which will execute the specified script
	when input.

	Note that the command here should only be written as the command itself; any
	additional arguments will be passed into the script automatically.

	argument0 = the command to listen for as a string, minus arguments (string)
	argument1 = the script to execute when the command is input (script)

	Example usage:
	   sys_cmd_add("vngen_goto", vngen_goto);
	*/

	//Ensure the console command database exists, and recreate it if not
	if (!ds_exists(global.ds_cmd, ds_type_map)) {
	   global.ds_cmd = ds_map_create();
	}

	//Add command to the database
	global.ds_cmd[? argument0] = argument1;


}
