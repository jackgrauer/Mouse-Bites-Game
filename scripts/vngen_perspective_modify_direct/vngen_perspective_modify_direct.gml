/// @function	vngen_perspective_modify_direct(x, y, xoffset, yoffset, zoom, rot, strength);
/// @param		{real}			x
/// @param		{real}			y
/// @param		{real}			xoffset
/// @param		{real}			yoffset
/// @param		{real}			zoom
/// @param		{real}			rot
/// @param		{real}			strength
/// @author		Lucas Chasteen <lucas.chasteen@xgasoft.com>
/// @copyright	XGASOFT 2020, All Rights Reserved
function vngen_perspective_modify_direct(argument0, argument1, argument2, argument3, argument4, argument5, argument6) {

	/*
	Applies a global offset to the position, rotation, and scale of active scenes, 
	characters, and emotes directly, outside the context of VNgen events, using parallax
	to simulate depth. Parallax between elements can be controlled with the 'strength' 
	multiplier, where 0 equals no parallax and greater values increase the divergence 
	between layers when zoomed or offset. Perspective 'offset' can be thought of like 
	a camera angle, where the perspective center is the focal point.

	argument0 = the horizontal perspective origin, or center, where 0 is default (real)
	argument1 = the vertical perspective origin, or center, where 0 is default (real)
	argument2 = the horizontal perspective offset, or 'angle', where 0 is straight-on (real)
	argument3 = the vertical perspective offset, or 'angle', where 0 is straight-on (real)
	argument4 = the perspective zoom, where 1 is default (real)
	argument5 = the perspective rotation, in degrees, where 0 is default (real)
	argument6 = the parallax strength multiplier, where 1 is default and 0 is no parallax (real)

	Example usage:
	   vngen_perspective_modify_direct(0, 0, -50, 50, 1, 0, 1);
	*/

	//Skip action if target data structure doesn't exist
	if (!ds_exists(ds_perspective, ds_type_grid)) { 
	   exit;
	}

	//Backup original values to temp value slots
	ds_perspective[# prop._tmp_xorig, 0] = ds_perspective[# prop._xorig, 0];   //X offset
	ds_perspective[# prop._tmp_yorig, 0] = ds_perspective[# prop._yorig, 0];   //Y offset
	ds_perspective[# prop._tmp_x, 0] = ds_perspective[# prop._x, 0];           //X center
	ds_perspective[# prop._tmp_y, 0] = ds_perspective[# prop._y, 0];           //Y center
	ds_perspective[# prop._tmp_rot, 0] = ds_perspective[# prop._rot, 0];       //Rotation
	ds_perspective[# prop._tmp_zoom, 0] = ds_perspective[# prop._per_zoom, 0]; //Zoom
	ds_perspective[# prop._tmp_str, 0] = ds_perspective[# prop._per_str, 0];   //Strength

	//Apply direct values
	ds_perspective[# prop._xorig, 0] = argument2;                //X offset
	ds_perspective[# prop._yorig, 0] = argument3;                //Y offset
	ds_perspective[# prop._x, 0] = argument0;                    //X center
	ds_perspective[# prop._y, 0] = argument1;                    //Y center
	ds_perspective[# prop._rot, 0] = argument5;                  //Rotation
	ds_perspective[# prop._per_zoom, 0] = max(0.005, argument4); //Zoom
	ds_perspective[# prop._per_str, 0] = max(0, argument6);      //Strength


}
