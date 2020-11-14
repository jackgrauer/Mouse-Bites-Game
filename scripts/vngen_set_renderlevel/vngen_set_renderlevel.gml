/// @function	vngen_set_renderlevel(level);
/// @param		{integer}	level
/// @author		Lucas Chasteen <lucas.chasteen@xgasoft.com>
/// @copyright	XGASOFT 2020, All Rights Reserved
function vngen_set_renderlevel(argument0) {

	/*
	VNgen uses multiple levels of rendering to accommodate the capabilities of different 
	platforms. While VNgen will automatically apply the best renderlevel for most devices,
	in some cases you may wish to set renderlevel manually for better performance or
	compatibility.

	VNgen currently supports three different renderlevels to choose from:
	   0, or full rendering (default)
	   1, or reduced rendering
	   2, or legacy rendering
   
	Reduced rendering will prioritize compatibility while maintaining mostly the same
	features as full rendering, while legacy rendering is aimed at low-end devices and
	HTML5 which do not properly support some advanced effects or require additional
	performance. Note, however, that legacy rendering is not faster in all cases.

	argument0 = sets the global renderlevel (integer) (0-2)

	Example usage:
	   vngen_set_renderlevel(1);
	*/

	//Set renderlevel
	global.vg_renderlevel = clamp(argument0, 0, 2);


}
