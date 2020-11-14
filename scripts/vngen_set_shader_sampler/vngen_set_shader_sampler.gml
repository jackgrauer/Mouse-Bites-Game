/// @function	vngen_get_index(id, type, [name], uniform, source);
/// @param		{real|string}	id
/// @param		{integer|macro}	type
/// @param		{string}		[name]
/// @param		{string}		uniform
/// @param		{sprite|string}	source
/// @author		Lucas Chasteen <lucas.chasteen@xgasoft.com>
/// @copyright	XGASOFT 2020, All Rights Reserved
function vngen_set_shader_sampler() {

	/*
	Assigns a sprite or surface to be passed into a shader, if any is active
	on the given entity.

	Important! Sampler sources MUST have dimensions in powers of 2 and MUST exist 
	on their own separate texture pages, as the entire texture page will be passed 
	into the shader (alternatively, you may pass in the UV coordinates of the target
	sprite using vngen_set_shader_float). Surfaces used as samplers MUST be input as 
	a string containing the name of the variable, NOT the variable itself.

	Note that VNgen automatically passes in 5 default input values for handling 
	fade transitions, global time, mouse and view coordinates, and the parent 
	entity dimensions. These values are read-only and cannot be modified, but 
	are very useful for designing shaders themselves.

	They are:

	uniform float in_Amount;    //Real (0-1)
	uniform float in_Time;      //Seconds
	uniform vec2 in_Mouse;      //X/Y
	uniform vec2 in_Offset;     //X/Y
	uniform vec2 in_Resolution; //X/Y (W/H)

	Note the names of these uniform values when supplying uniform names to be
	modified.

	argument0 = ID of the entity to modify (real or string)
	argument1 = sets whether to modify perspective (0), scenes (1), characters (2), 
	            attachments (3), textboxes (5), text (6), labels (7), prompts (8), 
	            or effects (12), 
	argument2 = name of the parent character to check, if entity is an attachment (string) (optional, use no argument for none)
	argument3 = the shader uniform to modify, as a string (string)
	argument4 = the sprite or surface to assign to the shader sampler (sprite/string) (string required for surface)

	Example usage:
	   vngen_set_shader_sampler("bg", vngen_type_scene, "sampler0", my_sprite);
	   vngen_set_shader_sampler("bg", vngen_type_scene, "sampler1", "my_surf");
	*/

	//Initialize temporary variables for checking target data
	var arg, ds_uniform, ds_yindex;
	var ds_uni_target = undefined;

	//Get target character, if any
	if (argument_count > 4) {
	   var arg = 1;
	   var name = argument[2];
	} else {
	   var arg = 0;
	   var name = -1;
	}

	//Get the target entity data structure
	var ds_data = vngen_get_struct(argument[0], argument[1], name);

	//Skip if target entity type is unsupported
	if (is_undefined(ds_data)) {
	   exit;
	}

	//Get the target entity index
	var ds_target = vngen_get_index(argument[0], argument[1], name);

	//Skip if target entity does not exist
	if (is_undefined(ds_target)) {
	   exit;
	}

	//Skip if target entity shader does not exist
	if (!sys_shader_exists(ds_data[# prop._shader, ds_target])) {
	   exit;
	}

	//Get uniform data from target entity
	ds_uniform = ds_data[# prop._sh_samp_data, ds_target];

	//Create uniform data structure, if none exists
	if (!ds_exists(ds_uniform, ds_type_grid)) {
	   ds_data[# prop._sh_samp_data, ds_target] = ds_grid_create(3, 0);
	   ds_uniform = ds_data[# prop._sh_samp_data, ds_target];
	}

	//Get uniform slot
	for (ds_yindex = 0; ds_yindex < ds_grid_height(ds_uniform); ds_yindex += 1) {
	   if (ds_uniform[# prop._id, ds_yindex] == argument[2 + arg]) {
	      ds_uni_target = ds_yindex;
	      break;
	   }
	}

	//If uniform does not exist...
	if (is_undefined(ds_uni_target)) {
	   //Get the current number of uniforms
	   ds_uni_target = ds_grid_height(ds_uniform);
   
	   //Create new uniform slot in data structure
	   ds_grid_resize(ds_uniform, ds_grid_width(ds_uniform), ds_grid_height(ds_uniform) + 1);
	}

	//Assign value to target uniform
	ds_uniform[# prop._id, ds_uni_target] = argument[2 + arg];  //ID
	ds_uniform[# prop._val, ds_uni_target] = argument[3 + arg]; //Sprite/surface


}
