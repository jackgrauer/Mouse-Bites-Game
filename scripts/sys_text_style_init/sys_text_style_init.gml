/// @function	sys_text_style_init(entity, index, name, font, col1, col2, col3, col4, shadow, outline);
/// @param		{integer}	entity
/// @param		{integer}	index
/// @param		{string}	name
/// @param		{font}		font
/// @param		{color}		col1
/// @param		{color}		col2
/// @param		{color}		col3
/// @param		{color}		col4
/// @param		{color}		shadow
/// @param		{color}		outline
/// @author		Lucas Chasteen <lucas.chasteen@xgasoft.com>
/// @copyright	XGASOFT 2020, All Rights Reserved9
function sys_text_style_init(argument0, argument1, argument2, argument3, argument4, argument5, argument6, argument7, argument8, argument9) {

	/*
	==========================================================================
	SYSTEM FUNCTION: MODIFY AT YOUR OWN RISK!
	--------------------------------------------------------------------------
	  System functions are executed automatically by the engine and typically
	  should not be run manually by the user
	==========================================================================

	Processes text stylization, including support for style inheritance, and
	returns the results as a ds_map.

	IMPORTANT: The resulting ds_map is temporary and must be destroyed when
	finished to prevent memory leaks!

	VNgen's handling of this functionality is highly tailored for its particular
	use-cases and is not intended for general use.

	argument0 = the data structure for the entity to apply transition to (integer)
	argument1 = the index of the row containing the target entity ID (integer)
	argument2 = the name under which inheritance data is stored (string)
	argument3 = the default text font, subject to be overridden in markup (font) (optional, use 'previous' for no change or 'inherit' for inherit)
	argument4 = the color blending value for the text top-left corner (color) (optional, use 'previous' for no change or 'inherit' for inherit)
	argument5 = the color blending value for the text top-right corner (color) (optional, use 'previous' for no change or 'inherit' for inherit)
	argument6 = the color blending value for the text bottom-right corner (color) (optional, use 'previous' for no change or 'inherit' for inherit)
	argument7 = the color blending value for the text bottom_left corner (color) (optional, use 'previous' for no change or 'inherit' for inherit)
	argument8 = the color value for the text shadow (color) (optional, use 'previous' for no change, 'inherit' for inherit, or 'none' for none)
	argument9 = the color value for the text outline (color) (optional, use 'previous' for no change, 'inherit' for inherit, or 'none' for none)

	Example usage:
	   var style = sys_text_style_init(ds_data, ds_target, "John Doe", previous, c_white, c_white, c_gray, c_gray, inherit, inherit);
	   ds_map_destroy(style);
	*/

	/*
	INITIALIZATION
	*/

	//Get the target data structure
	var ds_data = argument0;
	var ds_target = argument1;

	//Initialize temporary variables for checking style data
	var ds_type, text_fnt, text_c1, text_c2, text_c3, text_c4, text_shadow, text_outline;


	/*
	STYLIZATION
	*/

	//Ensure style data structure exists
	if (!ds_exists(global.ds_style, ds_type_map)) {
	   global.ds_style = ds_map_create();
	}

	//Get style prefix
	switch (ds_data) {
	   case ds_text: ds_type = "ds_text_" + argument2; break;
	   case ds_label: ds_type = "ds_label_" + argument2; break;
	}
      
	//Set text font
	switch (argument3) {
	   //Use previous font, if disabled
	   case previous: {
	      text_fnt = ds_data[# prop._txt_fnt, ds_target];
	      break;
	   }
   
	   //Inherit saved font, if any
	   case inherit: {
	      if (ds_map_exists(global.ds_style, ds_type + "_font")) {
	         text_fnt = global.ds_style[? ds_type + "_font"];
	      } else {
	         //Otherwise use previous font
	         text_fnt = ds_data[# prop._txt_fnt, ds_target];
	      }
	      break;
	   }
   
	   //Save input font, if specified
	   default: {
	      text_fnt = argument3;
	   }
	}

	//Set top-left color
	switch (argument4) {
	   //Use previous color, if disabled
	   case previous: {
	      text_c1 = ds_data[# prop._col1, ds_target];
	      break;
	   }
   
	   //Inherit saved color, if any
	   case inherit: {
	      if (ds_map_exists(global.ds_style, ds_type + "_c1")) {
	         text_c1 = global.ds_style[? ds_type + "_c1"];
	      } else {
	         //Otherwise use previous color
	         text_c1 = ds_data[# prop._col1, ds_target];
	      }
	      break;
	   }
   
	   //Save input color, if specified
	   default: {
	      text_c1 = argument4;
	   }
	}

	//Set top-right color
	switch (argument5) {
	   //Use previous color, if disabled
	   case previous: {
	      text_c2 = ds_data[# prop._col2, ds_target];
	      break;
	   }
   
	   //Inherit saved color, if any
	   case inherit: {
	      if (ds_map_exists(global.ds_style, ds_type + "_c2")) {
	         text_c2 = global.ds_style[? ds_type + "_c2"];
	      } else {
	         //Otherwise use previous color
	         text_c2 = ds_data[# prop._col2, ds_target];
	      }
	      break;
	   }
   
	   //Save input color, if specified
	   default: {
	      text_c2 = argument5;
	   }
	}

	//Set bottom-right color
	switch (argument6) {
	   //Use previous color, if disabled
	   case previous: {
	      text_c3 = ds_data[# prop._col3, ds_target];
	      break;
	   }
   
	   //Inherit saved color, if any
	   case inherit: {
	      if (ds_map_exists(global.ds_style, ds_type + "_c3")) {
	         text_c3 = global.ds_style[? ds_type + "_c3"];
	      } else {
	         //Otherwise use previous color
	         text_c3 = ds_data[# prop._col3, ds_target];
	      }
	      break;
	   }
   
	   //Save input color, if specified
	   default: {
	      text_c3 = argument6;
	   }
	}

	//Set bottom-left color
	switch (argument7) {
	   //Use previous color, if disabled
	   case previous: {
	      text_c4 = ds_data[# prop._col4, ds_target];
	      break;
	   }
   
	   //Inherit saved color, if any
	   case inherit: {
	      if (ds_map_exists(global.ds_style, ds_type + "_c4")) {
	         text_c4 = global.ds_style[? ds_type + "_c4"];
	      } else {
	         //Otherwise use previous color
	         text_c4 = ds_data[# prop._col4, ds_target];
	      }
	      break;
	   }
   
	   //Save input color, if specified
	   default: {
	      text_c4 = argument7;
	   }
	}

	//Set shadow color
	switch (argument8) {
	   //Use previous color, if disabled
	   case previous: {
	      text_shadow = ds_data[# prop._txt_shadow, ds_target];
	      break;
	   }
   
	   //Inherit saved color, if any
	   case inherit: {
	      if (ds_map_exists(global.ds_style, ds_type + "_shadow")) {
	         text_shadow = global.ds_style[? ds_type + "_shadow"];
	      } else {
	         //Otherwise use previous color
	         text_shadow = ds_data[# prop._txt_shadow, ds_target];
	      }
	      break;
	   }
   
	   //Save input color, if specified
	   default: {
	      text_shadow = argument8;
	   }
	}

	//Set outline color
	switch (argument9) {
	   //Use previous color, if disabled
	   case previous: {
	      text_outline = ds_data[# prop._txt_outline, ds_target];
	      break;
	   }
   
	   //Inherit saved color, if any
	   case inherit: {
	      if (ds_map_exists(global.ds_style, ds_type + "_outline")) {
	         text_outline = global.ds_style[? ds_type + "_outline"];
	      } else {
	         //Otherwise use previous color
	         text_outline = ds_data[# prop._txt_outline, ds_target];
	      }
	      break;
	   }
   
	   //Save input color, if specified
	   default: {
	      text_outline = argument9;
	   }
	}


	/*
	FINALIZATION
	*/

	//Update style data
	global.ds_style[? ds_type + "_font"] = text_fnt;
	global.ds_style[? ds_type + "_c1"] = text_c1;
	global.ds_style[? ds_type + "_c2"] = text_c2;
	global.ds_style[? ds_type + "_c3"] = text_c3;
	global.ds_style[? ds_type + "_c4"] = text_c4;
	global.ds_style[? ds_type + "_shadow"] = text_shadow;
	global.ds_style[? ds_type + "_outline"] = text_outline;

	//Create style map
	var map = ds_map_create();
	map[? "fnt"] = text_fnt;
	map[? "col1"] = text_c1;
	map[? "col2"] = text_c2;
	map[? "col3"] = text_c3;
	map[? "col4"] = text_c4;
	map[? "shadow"] = text_shadow;
	map[? "outline"] = text_outline;

	//Return style results
	return map;


}
