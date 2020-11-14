/// @function	keyframe();
/// @author		Lucas Chasteen <lucas.chasteen@xgasoft.com>
/// @copyright	XGASOFT 2020, All Rights Reserved
function keyframe() {

	/*
	Begins a new VNgen keyframe code block, inside which animation 
	values can be set. 

	For use in animation, deformation, and effect scripts.

	No parameters

	Example usage:
	   if (keyframe()) {
	      anim_x = 50;
	   }
	*/

	//Get keyframe ID
	keyframe_id += 1;

	//Do not perform keyframe unless it is active
	if (keyframe_current == keyframe_id) {
	   return true;
	} else {
	   return false;
	}


}
