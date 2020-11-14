/// @function	sys_shader_exists(shader);
/// @param		{shader}	shader
/// @author		Lucas Chasteen <lucas.chasteen@xgasoft.com>
/// @copyright	XGASOFT 2020, All Rights Reserved
function sys_shader_exists(argument0) {

	/*
	==========================================================================
	SYSTEM FUNCTION: MODIFY AT YOUR OWN RISK!
	--------------------------------------------------------------------------
	  System functions are executed automatically by the engine and typically
	  should not be run manually by the user
	==========================================================================

	Checks to see whether the given shader exists and returns true or false.
	If the shader **asset** exists, but was not successfully compiled due to
	errors or incompatibility with the current platform, false will also be
	returned.

	argument0 = shader to check (shader)

	Example usage:
	   if (sys_shader_exists(my_shader)) {
	      shader_set(my_shader);
	   }
	*/

	//If shaders are enabled...
	if (global.vg_renderlevel == 0) {
	   //If shader index is valid...
	   if (argument0 >= 0) {
	      //If shader was compiled successfully...
	      if (shaders_are_supported()) {
	         if (shader_is_compiled(argument0)) {
	            //Return shader exists
	            return true;
	         }
	      }
	   }
	}

	//Otherwise return shader does not exist
	return false;


}
