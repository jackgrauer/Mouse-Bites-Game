/// @function	effect();
/// @author		Lucas Chasteen <lucas.chasteen@xgasoft.com>
/// @copyright	XGASOFT 2020, All Rights Reserved
function effect() {

	/*
	Begins a new VNgen effect code block, inside which effect code can be executed. 

	For use in effect scripts parallel to keyframes.

	No parameters

	Example usage:
	   if (effect()) {
	      draw_sprite(my_sprite, 1, ef_var0, ef_var1);
	   }
	*/

	//Do not perform effect code unless keyframes are inactive
	if (keyframe_current == -1) {
	   return true;
	} else {
	   return false;
	}


}
