/// @function	vngen_button_clear();
/// @author		Lucas Chasteen <lucas.chasteen@xgasoft.com>
/// @copyright	XGASOFT 2020, All Rights Reserved
function vngen_button_clear() {

	/*
	Manually clears button **results** (not data) to prevent repeated execution of 
	button-based triggers. Not required if vngen_get_button's automatic clear mode
	is enabled.

	No parameters

	Example usage:
	   if (vngen_button_clear(false) == "button1") {
	      my_var += 1;
	      vngen_button_clear();
	   }
	*/

	//Clear button results
	button_result = -1;


}
