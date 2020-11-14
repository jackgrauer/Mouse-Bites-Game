/// @function	sys_scale_init(entity, index, width, height, width_init, height_init, scaling);
/// @param		{integer}	x
/// @param		{integer}	y
/// @param		{real}		width
/// @param		{real}		height
/// @param		{real}		width_init
/// @param		{real}		height_init
/// @param		{integer}	scaling
/// @author		Lucas Chasteen <lucas.chasteen@xgasoft.com>
/// @copyright	XGASOFT 2020, All Rights Reserved
function sys_scale_init(argument0, argument1, argument2, argument3, argument4, argument5, argument6) {

	/*
	==========================================================================
	SYSTEM FUNCTION: MODIFY AT YOUR OWN RISK!
	--------------------------------------------------------------------------
	  System functions are executed automatically by the engine and typically
	  should not be run manually by the user
	==========================================================================

	Initializes relative scaling for the specified entity. Scaling only needs 
	to be initialized when the entity is created and will persist despite further
	modifications to scale thereafter.

	VNgen's handling of this functionality is highly tailored for its particular
	use-cases and is not intended for general use.

	Note that this script is unrelated to vngen_set_scale.

	argument0 = the data structure for the entity to apply scaling to (integer)
	argument1 = the index of the row containing the target entity ID (integer)
	argument2 = the current width of the reference area being scaled against (real)
	argument3 = the current height of the reference area being scaled against (real)
	argument2 = the initial width of the reference area being scaled against (real)
	argument3 = the initial height of the reference area being scaled against (real)
	argument6 = sets the scaling mode to perform: scale_none, scale_x_y, scale_x, scale_y, 
	            scale_stretch_x_y, scale_stretch_x, scale_stretch_y, scale_prop_x_y, 
	            scale_prop_x, or scale_prop_y (integer or macro)
            
	Example usage:
	   sys_scale_init(ds_textbox, ds_target, global.dp_width, global.dp_height, global.dp_width_inital, global.dp_height_init, 4);
	*/

	/*
	INITIALIZATION
	*/

	//Get the target data structure
	var ds_data = argument0;
	var ds_target = argument1;
	var ds_type = 0;

	//Set entity type to text, if scaling text
	if (variable_instance_exists(id, "ds_text")) {
	   if (ds_data == variable_instance_get(id, "ds_text")) {
	      ds_type = 1;
	   }
	}
	if (variable_instance_exists(id, "ds_label")) {
	   if (ds_data == variable_instance_get(id, "ds_label")) {
	      ds_type = 1;
	   }
	}

	//Get entity dimensions
	if (ds_type == 1) {
	   //Surface dimensions
	   if (surface_exists(ds_data[# prop._surf, ds_target])) {
	      var action_width = surface_get_width(ds_data[# prop._surf, ds_target]);
	      var action_height = surface_get_height(ds_data[# prop._surf, ds_target]);
	   } else {
	      //Use neutral multiplier if surface does not exist
	      var action_width = 1;
	      var action_height = 1;
	   }
	} else {
	   //Sprite dimensions
	   var action_width = sprite_get_width(ds_data[# prop._sprite, ds_target]);
	   var action_height = sprite_get_height(ds_data[# prop._sprite, ds_target]);
	}


	/*
	SCALING
	*/

	/* NONE */
	if (argument6 < 1) {  
	   ds_data[# prop._oxscale, ds_target] = 1; //X scale offset
	   ds_data[# prop._oyscale, ds_target] = 1; //Y scale offset
	   exit;
	}
   
	/* X-Y SCALING (FIT) */
	if (argument6 == 1) {
	   //Get scale for each axis
	   var scale_width = argument2/action_width;
	   var scale_height = argument3/action_height;
   
	   //Prioritize the greater scale
	   var scale_max = max(scale_width, scale_height);
   
	   //Scale to fit
	   ds_data[# prop._oxscale, ds_target] = scale_max; //X scale offset
	   ds_data[# prop._oyscale, ds_target] = scale_max; //Y scale offset
	   exit;
	}   
   
	/* X-ONLY SCALING */
	if (argument6 == 2) { 
	   ds_data[# prop._oxscale, ds_target] = argument2/action_width;              //X scale offset
	   ds_data[# prop._oyscale, ds_target] = ds_data[# prop._oxscale, ds_target]; //Y scale offset
	   exit;
	}
   
	/* Y-ONLY SCALING */
	if (argument6 == 3) { 
	   ds_data[# prop._oyscale, ds_target] = argument3/action_height;             //Y scale offset
	   ds_data[# prop._oxscale, ds_target] = ds_data[# prop._oyscale, ds_target]; //X scale offset
	   exit;
	}   
   
	/* X-Y STRETCH (FULL) */
	if (argument6 == 4) {  
	   ds_data[# prop._oxscale, ds_target] = argument2/action_width;  //X scale offset
	   ds_data[# prop._oyscale, ds_target] = argument3/action_height; //Y scale offset
	   exit;
	}
   
	/* X-ONLY STRETCH */
	if (argument6 == 5) { 
	   ds_data[# prop._oxscale, ds_target] = argument2/action_width; //X scale offset
	   ds_data[# prop._oyscale, ds_target] = 1;                      //Y scale offset
	   exit;
	}
   
	/* Y-ONLY STRETCH */
	if (argument6 == 6) {
	   ds_data[# prop._oxscale, ds_target] = 1;                       //X scale offset
	   ds_data[# prop._oyscale, ds_target] = argument3/action_height; //Y scale offset
	   exit;
	}

	/* X-Y PROPORTION */
	if (argument6 == 7) {
	   //Get scale for each axis
	   var scale_width = argument2/argument4;
	   var scale_height = argument3/argument5;
   
	   //Prioritize the greater scale
	   var scale_max = max(scale_width, scale_height);

	   //Scale by proportion
	   ds_data[# prop._oxscale, ds_target] = scale_max; //X scale offset
	   ds_data[# prop._oyscale, ds_target] = scale_max; //Y scale offset
	   exit;
	}

	/* X-ONLY PROPORTION */
	if (argument6 == 8) {
	   //Get scale for width only
	   var scale_width = argument2/argument4;
   
	   //Scale by proportion
	   ds_data[# prop._oxscale, ds_target] = scale_width; //X scale offset
	   ds_data[# prop._oyscale, ds_target] = scale_width; //Y scale offset
	   exit;
	}

	/* Y-ONLY PROPORTION */
	if (argument6 > 8) {
	   //Get scale for height only
	   var scale_height = argument3/argument5;
   
	   //Scale by proportion
	   ds_data[# prop._oxscale, ds_target] = scale_height; //X scale offset
	   ds_data[# prop._oyscale, ds_target] = scale_height; //Y scale offset
	   exit;
	}



}
