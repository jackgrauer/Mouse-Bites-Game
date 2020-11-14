/// @function	sys_cmd_init();
/// @author		Lucas Chasteen <lucas.chasteen@xgasoft.com>
/// @copyright	XGASOFT 2020, All Rights Reserved
function sys_cmd_init() {

	/*
	==========================================================================
	SYSTEM FUNCTION: MODIFY AT YOUR OWN RISK!
	--------------------------------------------------------------------------
	  System functions are executed automatically by the engine and typically
	  should not be run manually by the user
	==========================================================================

	Automatically runs when the application starts to initialize all necessary
	global command console functions and parameters.

	No parameters

	Example usage:
	   None; self-executing script.
	*/

	//Set script to autorun at launch
	gml_pragma("global", "sys_cmd_init();");

	//Initialize command console
	global.cmd_current = 0; //Tracks the current entry from command history
	global.cmd_previous = 0; //Tracks changes in history navigation
	global.cmd_input = ""; //The user input string
	global.cmd_input_default = "Input a command or type 'help' to learn more"; //Default text shown when no input is present
	global.cmd_input_result = ""; //System response shown after a command has been input
	global.cmd_input_index = 1; //The cursor index in the user input string
	global.cmd_input_time = 0; //Tracks how long a key has been held down
	global.cmd_refresh = true; //Enables redrawing console content when input has been made
	global.cmd_surf = -1; //The surface to which console content is drawn
	global.cmd_x = 0; //Sets the horizontal **cursor** offset
	global.cmd_y = 0; //Sets the vertical **console** offset
	global.cmd_alpha = 0; //Sets the console transparency value
	global.cmd_visible = false; //Shows or hides the command console

	//Create console data structures   // Memory map:
	//------------------------------   // [    0    |    1   ]
	global.ds_cmd = -1;                // [ command | script ]
	global.ds_cmd_history = -1;        // [ command ]


}
