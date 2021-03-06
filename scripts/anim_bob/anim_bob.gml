/// @function	anim_bob();
/// @author		Lucas Chasteen <lucas.chasteen@xgasoft.com>
/// @copyright	XGASOFT 2020, All Rights Reserved
function anim_bob() {

	/*
	An animation for use with vngen_*_anim_start scripts.

	Animations following this template are universal and can be applied 
	to scenes, characters, attachments, textboxes, text, labels, prompts, 
	and the global perspective.

	All animation values (with the exception of color) are relative to 
	the base values of the entity being modified.

	Setting a value for each variable in each keyframe is optional,
	however any unused variables will be treated as default. Values
	will be transitioned smoothly between keyframes.

	Some values are also passed in from the entity being animated,
	such as dimensions and scale, and can be used to create animations
	that scale to any size entity.

	Animatable properties: 
	   anim_x, anim_y, anim_xscale, anim_yscale, anim_rot, anim_col1, 
	   anim_col2, anim_col3, anim_col4, anim_alpha, anim_ease

	   Perspective only:
	   anim_xoffset, anim_yoffset, anim_zoom, anim_strength
   
	   Note: anim_zoom and anim_strength map to anim_xscale and
	   anim_yscale, respectively, and can be used interchangeably
   
	Available constants:
	   input_width, input_height, input_x, input_y, input_xscale, 
	   input_yscale, input_rot   
   
	   Perspective only:
	   input_zoom, input_strength
   
	   Note: input_zoom and input_strength map to input_xscale and
	   input_yscale, respectively, and can be used interchangeably
	*/

	/*
	KEYFRAMES
	*/

	if (keyframe()) {
	   anim_rot = 2;
	   anim_ease = ease_quad;
	}

	if (keyframe()) {
	   anim_rot = -2;
	   anim_ease = ease_quad;
	}


}
