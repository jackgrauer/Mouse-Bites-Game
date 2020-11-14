/// @function	vngen_attach_shader_stop(name, id, fade, [ease]);
/// @param		{string|macro}	name
/// @param		{real|string}	id
/// @param		{real}			fade
/// @param		{integer|macro}	[ease]
/// @author		Lucas Chasteen <lucas.chasteen@xgasoft.com>
/// @copyright	XGASOFT 2020, All Rights Reserved
function vngen_attach_shader_stop() {

	/*
	Stops a shader being applied to the specified attachment, if any.

	Note that this script does NOT need to be run in order to change shaders, as shaders
	do not stack. Should shader stacking be needed, create a single shader containing all 
	desired modifications.

	argument0 = identifier of the character to be modified (string)
	argument1 = identifier of the attachment to be modified (real or string) (or keyword 'all' for all)
	argument2 = sets the the length of time to fade shader out, in seconds (real)
	argument3 = sets the fade easing method (see interp for available modes) (integer) (can also use true/false) (optional, use no argument for none)

	Example usage:
	   vngen_event() {
	      vngen_attach_shader_stop("John Doe", "attach", 0.5);
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
	      //Get character target
	      var ds_char_target = vngen_get_index(argument[0], vngen_type_char);
      
	      //If the target character exists...
	      if (!is_undefined(ds_char_target)) {  
	         //Get attachment data from target character
	         var ds_attach = ds_character[# prop._attach_data, ds_char_target];    
          
	         //Get attachment slot
	         if (argument[1] == all) {
	            //Modify all attachments, if enabled
	            var ds_attach_target = sys_grid_last(ds_attach);
	            var ds_xindex = 0;
	         } else {
	            //Otherwise get single attachment to modify
	            var ds_attach_target = vngen_get_index(argument[1], vngen_type_attach, argument[0]);
	            var ds_xindex = ds_attach_target;
	         }
      
	         //If the target attachment exists...
	         if (!is_undefined(ds_attach_target)) {
	            //If shader exists...
	            if (sys_shader_exists(ds_attach[# prop._shader, ds_attach_target])) {
	               while (ds_attach_target >= ds_xindex) {  
	                  //Set transition time
	                  if (argument[2] > 0) {
	                     ds_attach[# prop._sh_time, ds_attach_target] = 0;  //Transition time
	                  } else {
	                     ds_attach[# prop._sh_time, ds_attach_target] = -1; //Transition time
	                  }   
               
	                  //Continue to next attachment, if any
	                  ds_attach_target -= 1;
	               }
	            } else {
	               //Skip action if shader does not exist
	               sys_action_term();
	               exit;
	            }
	         } else {
	            //Skip action if attachment does not exist
	            sys_action_term();
	            exit;
	         }
	      } else {
	         //Skip action if character does not exist
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

	//Get character slot to modify
	var ds_char_target = vngen_get_index(argument[0], vngen_type_char);

	//Skip action if target character does not exist
	if (is_undefined(ds_char_target)) {
	   exit;
	}

	//Get attachment data from target character
	var ds_attach = ds_character[# prop._attach_data, ds_char_target];

	//Get attachment slot
	if (argument[1] == all) {
	   //Modify all attachments, if enabled
	   var ds_attach_target = sys_grid_last(ds_attach);
	   var ds_xindex = 0;
	} else {
	   //Otherwise get single attachment to modify
	   var ds_attach_target = vngen_get_index(argument[1], vngen_type_attach, argument[0]);
	   var ds_xindex = ds_attach_target;
	}

	//Skip action if target attachment does not exist
	if (is_undefined(ds_attach_target)) {
	   exit;
	}

	//Skip action if shader does not exist
	if (!sys_shader_exists(ds_attach[# prop._shader, ds_attach_target])) {
	   exit;
	}


	/*
	PERFORM MODIFICATIONS
	*/

	while (ds_attach_target >= ds_xindex) { 
	   //Increment transition time
	   if (ds_attach[# prop._sh_time, ds_attach_target] < argument[2]) {
	      if (!sys_action_skip()) {
	         ds_attach[# prop._sh_time, ds_attach_target] += time_frame;
	      } else {
	         //Otherwise skip transition if vngen_do_continue is run
	         ds_attach[# prop._sh_time, ds_attach_target] = argument[2];
	      }
      
	      //Mark this action as complete
	      if (ds_attach[# prop._sh_time, ds_attach_target] < 0) or (ds_attach[# prop._sh_time, ds_attach_target] >= argument[2]) { 
	         //Disable shader
	         ds_attach[# prop._shader, ds_attach_target] = -1;
      
	         //Clear shader uniforms from memory, if any
	         if (ds_exists(ds_attach[# prop._sh_float_data, ds_attach_target], ds_type_grid)) {
	            ds_grid_destroy(ds_attach[# prop._sh_float_data, ds_attach_target]);
	            ds_attach[# prop._sh_float_data, ds_attach_target] = -1;
	         }
	         if (ds_exists(ds_attach[# prop._sh_mat_data, ds_attach_target], ds_type_grid)) {
	            ds_grid_destroy(ds_attach[# prop._sh_mat_data, ds_attach_target]);
	            ds_attach[# prop._sh_mat_data, ds_attach_target] = -1;
	         }
	         if (ds_exists(ds_attach[# prop._sh_samp_data, ds_attach_target], ds_type_grid)) {
	            ds_grid_destroy(ds_attach[# prop._sh_samp_data, ds_attach_target]);
	            ds_attach[# prop._sh_samp_data, ds_attach_target] = -1;
	         }
         
	         //End action
	         if (ds_attach_target == ds_xindex) {
	            sys_action_term();
            
	            //Continue to next attachment, if any
	            ds_attach_target -= 1;
	            continue;
	         }
	      }
	   } else {
	      //Do not process when transitions are complete
	      ds_attach_target -= 1;
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
	      var action_time = interp(0, 1, ds_attach[# prop._sh_time, ds_attach_target]/argument[2], action_ease);
   
	      //Perform shader fade
	      ds_attach[# prop._sh_amt, ds_attach_target] = lerp(1, 0, action_time); //Amount, or fade percentage
	   }
            
	   //Continue to next attachment, if any
	   ds_attach_target -= 1;
	}


}
