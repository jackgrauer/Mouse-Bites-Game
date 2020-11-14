/// @function	vngen_set_scale(view);
/// @param		{integer}	view
/// @author		Lucas Chasteen <lucas.chasteen@xgasoft.com>
/// @copyright	XGASOFT 2020, All Rights Reserved
function vngen_set_scale(argument0) {

	/*
	Enables automatically adjusting the specified viewport to scale proportionately
	to changes in window dimensions. Internal game width will be maintained, while
	height will be expanded or reduced to match aspect ratio.

	The current VNgen event will be restarted once scaling is complete.

	How each element responds to changes in display scale depends on the scaling modes 
	and coordinates set in creation scripts.

	Note that this script provides only basic scaling support. Advanced users
	are recommended to replace this script with scaling functions tailored to 
	their specific projects.

	argument0 = sets the view to scale (view) (0-7) (use 'none' to disable scaling)

	Example usage:
	   vngen_set_scale(0);
	*/

	//Set display properties
	global.dp_scale_view = min(argument0, 7);
	global.dp_width = camera_get_view_width(view_camera[global.dp_scale_view]);
	global.dp_height = camera_get_view_height(view_camera[global.dp_scale_view]);
	global.dp_width_init = global.dp_width;
	global.dp_height_init = global.dp_height;
	global.dp_width_previous = global.dp_width;
	global.dp_height_previous = global.dp_height;

	//Set GUI properties
	display_set_gui_size(global.dp_width, global.dp_height);


}
