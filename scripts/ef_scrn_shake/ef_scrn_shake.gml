/// @function	ef_scrn_shake();
/// @author		Lucas Chasteen <lucas.chasteen@xgasoft.com>
/// @copyright	XGASOFT 2020, All Rights Reserved
function ef_scrn_shake() {

	/*
	An effect for use with the vngen_effect_start script.

	Effects following this template are universal and can be used to
	execute arbitrary code within the context of VNgen keyframes.
	But although code may be arbitrary, like animations, effects are 
	intended to enhance the user experience, not perform general 
	programming tasks (see vngen_script_execute for this).

	Unlike animations, all effect values are absolute with a base
	value of 0.

	Setting a value for each variable in each keyframe is optional,
	however any unused variables will be treated as default. Real
	numbered values will be transitioned smoothly between keyframes,
	while other data types (e.g. strings) will only update once when
	the keyframe is complete.

	Effect code itself must not be executed within keyframes, but within 
	a separate code block declared simply as 'effect'.

	Some values are also passed in for use in effect code, such as 
	dimensions and image rate, and can be used to create effects
	that adapt to any framerate and resolution.

	Modifiable properties: 
	   ef_var[0], ef_var[1], ef_var[2] ... ef_ease
   
	Available constants:
	   input_rate, input_width, input_height, input_x, input_y
	*/

	/*
	EFFECT
	*/

	if (effect()) {
	   if (!window_get_fullscreen()) {
	      window_set_position((display_get_width()*0.5) - (input_width*0.5) + ef_var[0], 
	                          (display_get_height()*0.5) - (input_height*0.5) + ef_var[1]);
	   }
	}


	/*
	KEYFRAMES
	*/

	if (keyframe()) {
	   ef_var[0] = (input_width*0.075);
	   ef_var[1] = (input_height*0.1);
	}

	if (keyframe()) {
	   ef_var[0] = -(input_width*0.075);
	   ef_var[1] = (input_height*0.1);
	}

	if (keyframe()) {
	   ef_var[0] = (input_width*0.05);
	   ef_var[1] = -(input_height*0.075);
	}

	if (keyframe()) {
	   ef_var[0] = -(input_width*0.05);
	   ef_var[1] = -(input_height*0.075);
	}

	if (keyframe()) {
	   ef_var[0] = (input_width*0.025);
	   ef_var[1] = (input_height*0.05);
	}

	if (keyframe()) {
	   ef_var[0] = -(input_width*0.025);
	   ef_var[1] = (input_height*0.05);
	}

	if (keyframe()) {
	   ef_var[0] = (input_width*0.01);
	   ef_var[1] = -(input_height*0.05);
	}

	if (keyframe()) {
	   ef_var[0] = -(input_width*0.01);
	   ef_var[1] = -(input_height*0.025);
	}


}
