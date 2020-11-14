/// @function	sys_log_get_style(name);
/// @param		{string}	name
/// @author		Lucas Chasteen <lucas.chasteen@xgasoft.com>
/// @copyright	XGASOFT 2020, All Rights Reserved
function sys_log_get_style(argument0) {

	/*
	==========================================================================
	SYSTEM FUNCTION: MODIFY AT YOUR OWN RISK!
	--------------------------------------------------------------------------
	  System functions are executed automatically by the engine and typically
	  should not be run manually by the user
	==========================================================================

	Checks the input name for related label style data and returns the name enclosed 
	in color markup for style data, if found.

	VNgen's handling of this functionality is highly tailored for its particular
	use-cases and is not intended for general use.

	argument0 = the name to check for style data (string)

	Example usage:
	   var name = sys_log_get_style("John Doe");
	*/

	/*
	INITIALIZATION
	*/

	//Initialize temporary variables for checking style data
	var ds_type, mark_fnt, mark_color, mark_shadow, mark_outline, text_fnt, text_c1, text_c2, text_c3, text_c4, text_color, text_shadow, text_outline;


	/*
	STYLIZATION
	*/

	//Ensure style data structure exists
	if (!ds_exists(global.ds_style, ds_type_map)) {
	   global.ds_style = ds_map_create();
	}

	//Get style prefix
	ds_type = "ds_label_" + argument0;
      
	//Get text font
	if (ds_map_exists(global.ds_style, ds_type + "_font")) {
	   text_fnt = font_get_name(global.ds_style[? ds_type + "_font"]);
	} else {
	   //Otherwise do not use font markup
	   text_fnt = "";
	}

	//Get top-left color
	if (ds_map_exists(global.ds_style, ds_type + "_c1")) {
	   text_c1 = make_color_rgb_to_hex(global.ds_style[? ds_type + "_c1"]);
	} else {
	   //Otherwise do not use color markup
	   text_c1 = "";
	}

	//Get top-right color
	if (ds_map_exists(global.ds_style, ds_type + "_c2")) {
	   text_c2 = make_color_rgb_to_hex(global.ds_style[? ds_type + "_c2"]);
	} else {
	   //Otherwise use previous color
	   text_c2 = text_c1;
	}

	//Get bottom-right color
	if (ds_map_exists(global.ds_style, ds_type + "_c3")) {
	   text_c3 = make_color_rgb_to_hex(global.ds_style[? ds_type + "_c3"]);
	} else {
	   //Otherwise use previous color
	   text_c3 = text_c2;
	}

	//Get bottom-left color
	if (ds_map_exists(global.ds_style, ds_type + "_c4")) {
	   text_c4 = make_color_rgb_to_hex(global.ds_style[? ds_type + "_c4"]);
	} else {
	   //Otherwise use previous color
	   text_c4 = text_c3;
	}

	//Get shadow color
	if (ds_map_exists(global.ds_style, ds_type + "_shadow")) {
	   text_shadow = make_color_rgb_to_hex(global.ds_style[? ds_type + "_shadow"]);
	} else {
	   //Otherwise do not use shadow markup
	   text_shadow = "";
	}

	//Get outline color
	if (ds_map_exists(global.ds_style, ds_type + "_outline")) {
	   text_outline = make_color_rgb_to_hex(global.ds_style[? ds_type + "_outline"]);
	} else {
	   //Otherwise do not use outline markup
	   text_outline = "";
	}

	//Get text markup tags based on style data
	if (text_fnt != "") {
	   text_fnt = "[font=" + text_fnt + "]";
	   mark_fnt = "[/font]";
	} else {
	   mark_fnt = "";
	}

	//Get color markup tags based on style data
	if (text_c1 != "") {
	   text_color = "[color=" + text_c1 + "," + text_c2 + "," + text_c3 + "," + text_c4 + "]";
	   mark_color = "[/color]";
	} else {
	   text_color = "";
	   mark_color = "";
	}

	//Get shadow markup tags based on style data
	if (text_shadow != "") {
	   text_shadow = "[shadow=" + text_shadow + "]";
	   mark_shadow = "[/shadow]";
	} else {
	   mark_shadow = "";
	}

	//Get outline markup tags based on style data
	if (text_outline != "") {
	   text_outline = "[outline=" + text_outline + "]";
	   mark_outline = "[/outline]";
	} else {
	   mark_outline = "";
	}


	/*
	FINALIZATION
	*/

	//Return name string with style tags
	return text_fnt + text_color + text_shadow + text_outline + argument0 + mark_outline + mark_shadow + mark_color + mark_fnt;


}
