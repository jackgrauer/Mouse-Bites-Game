/// @function	vngen_scene_modify_direct(id, x, y, z, xscale, yscale, rot);
/// @param		{real|string|macro}	id
/// @param		{real}				x
/// @param		{real}				y
/// @param		{real}				z
/// @param		{real}				xscale
/// @param		{real}				yscale
/// @param		{real}				rot
/// @author		Lucas Chasteen <lucas.chasteen@xgasoft.com>
/// @copyright	XGASOFT 2020, All Rights Reserved
function vngen_scene_modify_direct(argument0, argument1, argument2, argument3, argument4, argument5, argument6) {

	/*
	Applies a number of customizations to the specified scene directly, outside
	the context of VNgen events. As some scene values are linear and would not 
	benefit from direct access, only non-linear values are included in this script.

	Note that tiled scenes cannot be rotated, and accept only one blending color as
	opposed to a four-color gradient.

	Also note that depending on how this script is used, direct modifications may 
	block other modifications from being applied or vice-versa.

	As with other actions, direct modifications will persist until the scene is 
	removed or another modification is performed.

	Unlike animations, mods are permanent changes performed once using absolute values. 

	argument0 = identifier of the scene to be modified (real or string) (or keyword 'all' for all)
	argument1 = the new horizontal position to display the scene (real)
	argument2 = the new vertical position to display the scene (real)
	argument3 = the new drawing depth to display the scene, relative to other scenes only (real)
	argument4 = the new horizontal scale multiplier to display the scene (real)
	argument5 = the new vertical scale multiplier to display the scene (real)
	argument6 = the new rotation value to apply to the scene, in degrees (real)

	Example usage:
	   vngen_scene_modify_direct("scene", 50, 100, -1, 1.5, 1.5, 180);
	*/

	/*
	INITIALIZATION
	*/

	//Skip action if target data structure doesn't exist
	if (!ds_exists(ds_scene, ds_type_grid)) { 
	   exit;
	}

	//Get scene slot
	if (argument0 == all) {
	   //Modify all scenes, if enabled
	   var ds_target = sys_grid_last(ds_scene);
	   var ds_yindex = 0;
	} else {
	   //Otherwise get single scene to modify
	   var ds_target = vngen_get_index(argument0, vngen_type_scene);
	   var ds_yindex = ds_target;
	}

	//If the target scene exists...
	if (!is_undefined(ds_target)) {     
	   while (ds_target >= ds_yindex) {        
	      //Backup original values to temp value slots
	      ds_scene[# prop._tmp_x, ds_target] = ds_scene[# prop._x, ds_target];           //X
	      ds_scene[# prop._tmp_y, ds_target] = ds_scene[# prop._y, ds_target];           //Y
	      ds_scene[# prop._tmp_xscale, ds_target] = ds_scene[# prop._xscale, ds_target]; //X scale
	      ds_scene[# prop._tmp_yscale, ds_target] = ds_scene[# prop._yscale, ds_target]; //Y scale
	      ds_scene[# prop._tmp_rot, ds_target] = ds_scene[# prop._rot, ds_target];       //Rotation
      
	      //Apply direct values
	      ds_scene[# prop._x, ds_target]  = argument1;     //X
	      ds_scene[# prop._y, ds_target]  = argument2;     //Y
	      ds_scene[# prop._xscale, ds_target] = argument4; //X scale
	      ds_scene[# prop._yscale, ds_target] = argument5; //Y scale
	      ds_scene[# prop._rot, ds_target] = argument6;    //Rotation
         
	      //Sort data structure by Z depth
	      if (ds_scene[# prop._z, ds_target] != argument3) {
	         ds_scene[# prop._z, ds_target] = argument3;   //Z
	         ds_grid_sort(ds_scene, prop._z, false);         
	      }
      
	      //Continue to next scene, if any
	      ds_target -= 1;
	   }       
	}


}
