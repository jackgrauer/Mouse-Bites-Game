/// @function	sys_shader_init(entity, index, shader);
/// @param		{integer}	entity
/// @param		{integer}	index
/// @param		{shader}	shader
/// @author		Lucas Chasteen <lucas.chasteen@xgasoft.com>
/// @copyright	XGASOFT 2020, All Rights Reserved
function sys_shader_init(argument0, argument1, argument2) {

	/*
	==========================================================================
	SYSTEM FUNCTION: MODIFY AT YOUR OWN RISK!
	--------------------------------------------------------------------------
	  System functions are executed automatically by the engine and typically
	  should not be run manually by the user
	==========================================================================

	Initializes a shader which can be performed with sys_shader_perform on 
	compatible entities.

	VNgen's handling of this functionality is highly tailored for its particular
	use-cases and is not intended for general use.

	argument0 = the data structure for the entity to apply shader to (integer)
	argument1 = the index of the row containing the target entity ID (integer)
	argument2 = the shader to perform (shader)

	Example usage:
	   sys_shader_init(ds_scene, ds_target, shade_sepia);
	*/

	//Get the target data structure
	var ds_data = argument0;
	var ds_target = argument1;

	//If the target shader exists...
	if (sys_shader_exists(argument2)) {
	   //Initialize shader properties
	   ds_data[# prop._shader, ds_target] = argument2; //Shader
	   ds_data[# prop._sh_frame, ds_target] = 0;       //Frame, or global time  
	   ds_data[# prop._sh_amt, ds_target] = 0;         //Amount, or fade percentage
	   ds_data[# prop._sh_time, ds_target] = 0;        //Transition time
	}


}
