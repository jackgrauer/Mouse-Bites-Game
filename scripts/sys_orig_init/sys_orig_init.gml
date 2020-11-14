/// @function	sys_orig_init(entity, index, xorig, yorig);
/// @param		{integer}	entity
/// @param		{integer}	index
/// @param		{real}		xorig
/// @param		{real}		yorig
/// @author		Lucas Chasteen <lucas.chasteen@xgasoft.com>
/// @copyright	XGASOFT 2020, All Rights Reserved
function sys_orig_init(argument0, argument1, argument2, argument3) {

	/*
	==========================================================================
	SYSTEM FUNCTION: MODIFY AT YOUR OWN RISK!
	--------------------------------------------------------------------------
	  System functions are executed automatically by the engine and typically
	  should not be run manually by the user
	==========================================================================

	Initializes relative origins for the specified entity. Origin only needs 
	to be initialized when the entity is created and will persist despite further
	modifications to position thereafter.

	VNgen's handling of this functionality is highly tailored for its particular
	use-cases and is not intended for general use.

	argument0 = the data structure for the entity to apply origins to (integer)
	argument1 = the index of the row containing the target entity ID (integer)
	argument2 = the horizontal origin point, relative to the entity top-left corner (real)
	argument3 = the vertical origin point, relative to the entity top-left corner (real)
            
	Example usage:
	   sys_orig_init(ds_textbox, ds_target, orig_center, orig_center);
	*/

	//Get the target data structure
	var ds_data = argument0;
	var ds_target = argument1;

	//Set X origin
	switch (argument2) {
	   case orig_center: ds_data[# prop._xorig, ds_target] = (ds_data[# prop._width, ds_target]*0.5); break; //Auto center
	   case orig_right: ds_data[# prop._xorig, ds_target] = ds_data[# prop._width, ds_target]; break;        //Auto right
	   default: ds_data[# prop._xorig, ds_target] = argument2;
	}

	//Set Y origin
	switch (argument3) {
	   case orig_center: ds_data[# prop._yorig, ds_target] = (ds_data[# prop._height, ds_target]*0.5); break; //Auto center
	   case orig_bottom: ds_data[# prop._yorig, ds_target] = ds_data[# prop._height, ds_target]; break;       //Auto bottom
	   default: ds_data[# prop._yorig, ds_target] = argument3;
	}


}
