/// @function	trans_zoom_in();
/// @author		Lucas Chasteen <lucas.chasteen@xgasoft.com>
/// @copyright	XGASOFT 2020, All Rights Reserved
function trans_zoom_in() {

	/*
	A transition for use with vngen_*_create and destroy scripts.

	Transitions following this template are universal and can be applied 
	to scenes, characters, attachments, textboxes, text, labels, prompts, 
	and dialog options

	All transition values are relative to the base values of the entity
	being modified. Transitions in will be performed forwards, while
	transitions out will be performed in reverse.

	Setting a value for each variable in each keyframe is optional, 
	however any unused variables will be treated as default. Values will 
	be transitioned smoothly between keyframes. Note that ease modes set
	in individual keyframes may be overridden by the master ease mode,
	if any.

	Some values are also passed in from the entity being animated, such 
	as dimensions, and can be used to create transitions that scale to 
	any size entity.

	Transitionable properties: 
	   trans_left, trans_top, trans_width, trans_height, trans_x, trans_y, 
	   trans_xscale, trans_yscale, trans_rot, trans_alpha, trans_ease
   
	Available constants:
	   input_width, input_height, input_x, input_y, input_xscale, 
	   input_yscale, input_rot
	*/

	/*
	KEYFRAMES
	*/

	if (keyframe()) {
	   trans_xscale = 0;
	   trans_yscale = 0;
	   trans_alpha = 0;
	}


}
