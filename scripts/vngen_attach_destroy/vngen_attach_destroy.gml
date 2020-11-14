/// @function	vngen_attach_destroy(name, id, transition, duration, [ease]);
/// @param		{string|macro}	name
/// @param		{real|string}	id
/// @param		{script}		transition
/// @param		{real}			duration
/// @param		{integer|macro}	[ease]
/// @author		Lucas Chasteen <lucas.chasteen@xgasoft.com>
/// @copyright	XGASOFT 2020, All Rights Reserved
function vngen_attach_destroy() {

	/*
	Removes a character attachment previously created with vngen_attach_create, optionally
	transitioning out with the given transition style and duration.

	argument0 = identifier of the character to be modified (string)
	argument1 = identifier of the attachment to be removed (real or string) (or keyword 'all' for all)
	argument2 = sets the transition script to perform (script) (optional, use 'trans_none' for none)
	argument3 = sets the length of the transition, in seconds (real)
	argument4 = sets the transition easing override (see interp for available modes) (integer) (can also use true/false) (optional, use no argument for none)

	Example usage:
	   vngen_event() {
	      vngen_attach_destroy("John Doe", "attach", trans_fade, 2, true);
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
	            //Destroy all attachments, if enabled
	            var ds_attach_target = sys_grid_last(ds_attach);
	            var ds_yindex = 0;
	         } else {
	            //Otherwise get single scene to destroy
	            var ds_attach_target = vngen_get_index(argument[1], vngen_type_attach, argument[0]);
	            var ds_yindex = ds_attach_target;
	         }         
      
	         //If the target attachment exists...
	         if (!is_undefined(ds_attach_target)) {
	            while (ds_attach_target >= ds_yindex) { 
	               //Initialize transitions
	               sys_trans_init(ds_attach, ds_attach_target, argument[2], argument[3], true);  
            
	               //Continue to next attachment, if any
	               ds_attach_target -= 1;
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
	   //Destroy all attachments, if enabled
	   var ds_attach_target = sys_grid_last(ds_attach);
	   var ds_yindex = 0;
	} else {
	   //Otherwise get single scene to destroy
	   var ds_attach_target = vngen_get_index(argument[1], vngen_type_attach, argument[0]);
	   var ds_yindex = ds_attach_target;
	} 

	//Skip action if target attachment does not exist
	if (is_undefined(ds_attach_target)) {
	   exit;
	}


	/*
	PERFORM TRANSITIONS
	*/

	while (ds_attach_target >= ds_yindex) { 
	   //Get ease mode
	   if (argument_count > 4) {
	      var action_ease = argument[4];
	   } else {
	      var action_ease = false;
	   }
   
	   //Perform transitions
	   if (ds_attach[# prop._trans_time, ds_attach_target] < ds_attach[# prop._trans_dur, ds_attach_target]) {
	      sys_trans_perform(ds_attach, ds_attach_target, action_ease);
   
   
	      /*
	      FINALIZATION
	      */
      
	      if (ds_attach[# prop._trans_time, ds_attach_target] >= ds_attach[# prop._trans_dur, ds_attach_target]) {
	         //Clear deform surfaces from memory, if any
	         if (surface_exists(ds_attach[# prop._def_surf, ds_attach_target])) {
	            surface_free(ds_attach[# prop._def_surf, ds_attach_target]);
	         }
	         if (surface_exists(ds_attach[# prop._def_fade_surf, ds_attach_target])) {
	            surface_free(ds_attach[# prop._def_fade_surf, ds_attach_target]);
	         }                    
                     
	         //Clear deform point data from memory, if any
	         if (ds_exists(ds_attach[# prop._def_point_data, ds_attach_target], ds_type_grid)) {
	            ds_grid_destroy(ds_attach[# prop._def_point_data, ds_attach_target]);
	            ds_attach[# prop._def_point_data, ds_attach_target] = -1;
	         }
      
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
         
	         //Remove attachment from data structure
	         ds_character[# prop._attach_data, ds_char_target] = sys_grid_delete(ds_attach, ds_attach_target); 
         
	         //End action when transitions are complete
	         if (ds_attach_target == ds_yindex) {
	            sys_action_term();
	         }
	      }
	   }

	   //Continue to next attachment, if any
	   ds_attach_target -= 1;
	}   



}
