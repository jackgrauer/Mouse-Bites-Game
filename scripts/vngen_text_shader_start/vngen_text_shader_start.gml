/// @function	vngen_text_shader_start(id, shader, fade, [ease]);
/// @param		{real|string|macro}	id
/// @param		{shader}			shader
/// @param		{real}				fade
/// @param		{integer|macro}		[ease]
/// @author		Lucas Chasteen <lucas.chasteen@xgasoft.com>
/// @copyright	XGASOFT 2020, All Rights Reserved
function vngen_text_shader_start() {

	/*
	Applies a shader to the specified text with optional fade in transition. 
	Shaders are written externally and can be used to modify the color and position 
	of vertices and/or pixels.

	Important! Some shaders require extra input values to function properly. These
	values must be set externally with vngen_set_shader_* scripts.

	Note that running this script multiple times does NOT start multiple shaders, as
	shaders do not stack. Should shader stacking be needed, create a single shader
	containing all desired modifications.

	argument0 = identifier of the text on which to perform shader (real or string) (or keyword 'all' for all)
	argument1 = sets the shader to perform (shader)
	argument2 = sets the the length of time to fade shader in, in seconds (real)
	argument3 = sets the fade easing method (see interp for available modes) (integer) (can also use true/false) (optional, use no argument for none)

	Example usage:
	   vngen_event() {
	      vngen_text_shader_start("text", shade_invert, 0.5);
	   }
	*/

	/*
	INITIALIZATION
	*/

	//Enable action, if active
	switch (sys_action_init()) {
	   //Exit if event is inactive
	   case false: {
	      exit;
	   }
      
	   //Initialize action if active
	   case true: {
	      //Get text slot
	      if (argument[0] == all) {
	         //Animate all text, if enabled
	         var ds_target = sys_grid_last(ds_text);
	         var ds_yindex = 0;
	      } else {
	         //Otherwise get single text
	         var ds_target = vngen_get_index(argument[0], vngen_type_text);
	         var ds_yindex = ds_target;
	      }
   
	      //If the target text exists...
	      if (!is_undefined(ds_target)) { 
	         //If shader exists...
	         if (sys_shader_exists(argument[1])) {
	            while (ds_target >= ds_yindex) {  
	               //Initialize shader
	               sys_shader_init(ds_text, ds_target, argument[1]);
            
	               //Set transition time
	               if (argument[2] > 0) {
	                  ds_text[# prop._sh_time, ds_target] = 0;  //Transition time
	               } else {
	                  ds_text[# prop._sh_time, ds_target] = -1; //Transition time
	               }   
            
	               //Continue to next text, if any
	               ds_target -= 1;
	            }
	         } else {
	            //Skip action if shader does not exist
	            sys_action_term();
	            exit;
	         }
	      } else {
	         //Skip action if text does not exist
	         sys_action_term();
	         exit;
	      }
	   }
	}


	/*
	DATA MANAGEMENT
	*/

	//Skip action if engine is paused
	if (global.vg_pause == true) {
	   exit;
	}

	//Get text slot
	if (argument[0] == all) {
	   //Modify all text, if enabled
	   var ds_target = sys_grid_last(ds_text);
	   var ds_yindex = 0;
	} else {
	   //Otherwise get single text to modify
	   var ds_target = vngen_get_index(argument[0], vngen_type_text);
	   var ds_yindex = ds_target;
	}

	//Skip action if target text does not exist
	if (is_undefined(ds_target)) {
	   exit;
	}

	//Skip action if shader does not exist
	if (!sys_shader_exists(ds_text[# prop._shader, ds_target])) {
	   exit;
	}


	/*
	PERFORM MODIFICATIONS
	*/

	while (ds_target >= ds_yindex) { 
	   //Increment transition time
	   if (ds_text[# prop._sh_time, ds_target] < argument[2]) {
	      if (!sys_action_skip()) {
	         ds_text[# prop._sh_time, ds_target] += time_frame;
	      } else {
	         //Otherwise skip transition if vngen_do_continue is run
	         ds_text[# prop._sh_time, ds_target] = argument[2];
	      }
      
	      //Mark this action as complete
	      if (ds_text[# prop._sh_time, ds_target] < 0) or (ds_text[# prop._sh_time, ds_target] >= argument[2]) { 
	         //Disallow exceeding target values    
	         ds_text[# prop._sh_time, ds_target] = argument[2]; //Time
	         ds_text[# prop._sh_amt, ds_target] = 1;            //Amount, or fade percentage
         
	         //End action
	         if (ds_target == ds_yindex) {
	            sys_action_term();
            
	            //Continue to next text, if any
	            ds_target -= 1;
	            continue;
	         }
	      }
	   } else {
	      //Do not process when transitions are complete
	      ds_target -= 1;
	      continue;
	   }     
   
	   //If duration is greater than 0...
	   if (argument[2] > 0) {
	      //Get ease mode
	      if (argument_count > 3) {
	         var action_ease = argument[3];
	      } else {
	         var action_ease = false;
	      }
      
	      //Get transition time
	      var action_time = interp(0, 1, ds_text[# prop._sh_time, ds_target]/argument[2], action_ease);
   
	      //Perform shader fade
	      ds_text[# prop._sh_amt, ds_target] = lerp(0, 1, action_time); //Amount, or fade percentage
	   }
            
	   //Continue to next text, if any
	   ds_target -= 1;
	}


}
