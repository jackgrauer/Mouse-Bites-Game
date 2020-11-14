/// @function	sys_text_get_label();
/// @author		Lucas Chasteen <lucas.chasteen@xgasoft.com>
/// @copyright	XGASOFT 2020, All Rights Reserved
function sys_text_get_label() {

	/*
	==========================================================================
	SYSTEM FUNCTION: MODIFY AT YOUR OWN RISK!
	--------------------------------------------------------------------------
	  System functions are executed automatically by the engine and typically
	  should not be run manually by the user
	==========================================================================

	Scans text data for character names and returns the results for use with 
	auto labels. If multiple simultaneous speakers exist, names will be 
	concatenated and separated with a slash.

	No parameters

	Example usage:
	   var text = sys_text_get_label();
	*/

	//Begin with empty string
	var text = "";
	var name_count = 0;

	//If text data exists...
	if (ds_exists(ds_text, ds_type_grid)) {
	   //Get current speaker name(s)
	   var ds_yindex;
	   for (ds_yindex = 0; ds_yindex < ds_grid_height(ds_text); ds_yindex += 1) {
		  //Skip empty names
		  if (ds_text[# prop._name, ds_yindex] == "") or (ds_text[# prop._name, ds_yindex] == " ") {
		     continue;
		  }
	  
	      //Separate names, if multiple speakers are present
	      if (name_count > 0) {
	         text = text + " / ";
	      }
      
	      //Add name(s) to label
	      text = text + ds_text[# prop._name, ds_yindex];
	  
		  //Increase name count
		  name_count += 1;
	   }
	}

	//Return text label
	return text;


}
