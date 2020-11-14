/// @function	deform();
/// @author		Lucas Chasteen <lucas.chasteen@xgasoft.com>
/// @copyright	XGASOFT 2020, All Rights Reserved
function deform() {

	/*
	Begins a new VNgen deform animation, inside which deformation width and
	height can be defined. 

	For use in deform scripts parallel to keyframes.

	No parameters

	Example usage:
	   if (deform()) {
	      def_width = 2;
	      def_height = 4;
	   }
	*/

	//Do not define deform dimensions unless keyframes are inactive
	if (keyframe_current == -1) {
	   return true;
	} else {
	   return false;
	}


}
