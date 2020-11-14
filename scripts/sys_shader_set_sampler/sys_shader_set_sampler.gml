/// @function	sys_shader_set_sampler(sampler, source, [index]);
/// @param		{integer}		sampler
/// @param		{sprite|string}	source
/// @param		{integer}		[index]
/// @author		Lucas Chasteen <lucas.chasteen@xgasoft.com>
/// @copyright	XGASOFT 2020, All Rights Reserved
function sys_shader_set_sampler() {

	/*
	==========================================================================
	SYSTEM FUNCTION: MODIFY AT YOUR OWN RISK!
	--------------------------------------------------------------------------
	  System functions are executed automatically by the engine and typically
	  should not be run manually by the user
	==========================================================================

	Checks whether the source sprite or surface exists, and if so, assigns it
	as a sampler to the current shader. If the source is a sprite, it is also
	required to supply the image index for the current frame of animation.

	VNgen's handling of this functionality is highly tailored for its particular
	use-cases and is not intended for general use.

	argument0 = the sampler index to assign source to (integer)
	argument1 = the source sprite or surface to assign to sampler (sprite/string) (string required for surface)
	argument2 = the source image index, if source is a sprite (integer)

	Example usage:
	   sys_shader_set_sampler(sh_samp0, my_surf);
	   sys_shader_set_sampler(sh_samp0, my_sprite, image_index);
	*/

	//Initialize temporary variables for assigning sampler
	var src = -1;
	var tex = -1;
	var type = 0;

	//Assume sprite if source is not a string
	if (!is_string(argument[1])) {
	   src = argument[1];
	} else {
	   //Check if source is surface (instead of sprite)
	   if (variable_instance_exists(id, argument[1])) {
	      //Get surface
	      src = variable_instance_get(id, argument[1]);
      
	      //Ensure surface exists
	      if (surface_exists(src)) {
	         type = 1;
	      } else {
	         //Skip if surface does not exist
	         src = -1;
	      }
	   }
	}

	//Skip if source could not be identified
	if (src < 0) {
	   exit;
	}

	//Get texture based on source type
	if (type == 0) {
	   tex = sprite_get_texture(src, argument[2]);
	} else {
	   tex = surface_get_texture(src);
	}

	//Assign texture to shader
	texture_set_stage(argument[0], tex);


}
