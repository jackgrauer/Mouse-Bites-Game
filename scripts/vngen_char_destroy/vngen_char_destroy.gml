/// @function	vngen_char_destroy(name, transition, duration, [ease]);
/// @param		{string|macro}	name
/// @param		{script}		transition
/// @param		{real}			duration
/// @param		{integer|macro}	[ease]
/// @author		Lucas Chasteen <lucas.chasteen@xgasoft.com>
/// @copyright	XGASOFT 2020, All Rights Reserved
function vngen_char_destroy() {

	/*
	Removes a character previously created with vngen_char_create, optionally
	transitioning out with the given transition style and duration.

	argument0 = identifier of the character to be removed (string) (or keyword 'all' for all)
	argument1 = sets the transition script to perform (script) (optional, use 'trans_none' for none)
	argument2 = sets the length of the transition, in seconds (real)
	argument3 = sets the transition easing override (see interp for available modes) (integer) (can also use true/false) (optional, use no argument for none)

	Example usage:
	   vngen_event() {
	      vngen_char_destroy("John Doe", trans_fade, 2, true);
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
	      //Get character slot
	      if (argument[0] == all) {
	         //Destroy all characters, if enabled
	         var ds_target = sys_grid_last(ds_character);
	         var ds_yindex = 0;
	      } else {
	         //Otherwise get single character to destroy
	         var ds_target = vngen_get_index(argument[0], vngen_type_char);
	         var ds_yindex = ds_target;
	      }      
         
	      //If the target character exists...
	      if (!is_undefined(ds_target)) {     
	         while (ds_target >= ds_yindex) {
	            //Initialize transitions
	            sys_trans_init(ds_character, ds_target, argument[1], argument[2], true);   
            
	            //Continue to next character, if any
	            ds_target -= 1;
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

	//Get character slot
	if (argument[0] == all) {
	   //Destroy all characters, if enabled
	   var ds_target = sys_grid_last(ds_character);
	   var ds_yindex = 0;
	} else {
	   //Otherwise get single character to destroy
	   var ds_target = vngen_get_index(argument[0], vngen_type_char);
	   var ds_yindex = ds_target;
	} 

	//Skip action if target character does not exist
	if (is_undefined(ds_target)) {
	   exit;
	}


	/*
	PERFORM TRANSITIONS
	*/

	while (ds_target >= ds_yindex) { 
	   //Get ease mode
	   if (argument_count > 3) {
	      var action_ease = argument[3];
	   } else {
	      var action_ease = false;
	   }
   
	   //Perform transitions
	   if (ds_character[# prop._trans_time, ds_target] < ds_character[# prop._trans_dur, ds_target]) {
	      sys_trans_perform(ds_character, ds_target, action_ease);
   
   
	      /*
	      FINALIZATION
	      */

	      if (ds_character[# prop._trans_time, ds_target] >= ds_character[# prop._trans_dur, ds_target]) {            
	         //Clear character surfaces from memory
	         if (surface_exists(ds_character[# prop._surf, ds_target])) {
	            surface_free(ds_character[# prop._surf, ds_target]);
	         }
	         if (surface_exists(ds_character[# prop._fade_src, ds_target])) {
	            surface_free(ds_character[# prop._surf, ds_target]);
	         }
         
	         //Clear deform surfaces from memory, if any
	         if (surface_exists(ds_character[# prop._def_surf, ds_target])) {
	            surface_free(ds_character[# prop._def_surf, ds_target]);
	         }
	         if (surface_exists(ds_character[# prop._def_fade_surf, ds_target])) {
	            surface_free(ds_character[# prop._def_fade_surf, ds_target]);
	         }                  
                     
	         //Clear deform point data from memory, if any
	         if (ds_exists(ds_character[# prop._def_point_data, ds_target], ds_type_grid)) {
	            ds_grid_destroy(ds_character[# prop._def_point_data, ds_target]);
	            ds_character[# prop._def_point_data, ds_target] = -1;
	         }
      
	         //Clear shader uniforms from memory, if any
	         if (ds_exists(ds_character[# prop._sh_float_data, ds_target], ds_type_grid)) {
	            ds_grid_destroy(ds_character[# prop._sh_float_data, ds_target]);
	            ds_character[# prop._sh_float_data, ds_target] = -1;
	         }
	         if (ds_exists(ds_character[# prop._sh_mat_data, ds_target], ds_type_grid)) {
	            ds_grid_destroy(ds_character[# prop._sh_mat_data, ds_target]);
	            ds_character[# prop._sh_mat_data, ds_target] = -1;
	         }
	         if (ds_exists(ds_character[# prop._sh_samp_data, ds_target], ds_type_grid)) {
	            ds_grid_destroy(ds_character[# prop._sh_samp_data, ds_target]);
	            ds_character[# prop._sh_samp_data, ds_target] = -1;
	         }
         
	         //Remove associated attachments, if any
	         if (ds_exists(ds_character[# prop._attach_data, ds_target], ds_type_grid)) {
	            //Get attachment data structure
	            var ds_attach = ds_character[# prop._attach_data, ds_target];
            
	            //Clear attachment data
	            var ds_xindex;
	            for (ds_xindex = 0; ds_xindex < ds_grid_height(ds_attach); ds_xindex += 1) {
	               //Clear deform surfaces from memory
	               if (surface_exists(ds_attach[# prop._def_surf, ds_xindex])) {
	                  surface_free(ds_attach[# prop._def_surf, ds_xindex]);
	               }      
	               if (surface_exists(ds_attach[# prop._def_fade_surf, ds_xindex])) {
	                  surface_free(ds_attach[# prop._def_fade_surf, ds_xindex]);
	               }
      
	               //Clear shader uniforms from memory, if any
	               if (ds_exists(ds_attach[# prop._sh_float_data, ds_xindex], ds_type_grid)) {
	                  ds_grid_destroy(ds_attach[# prop._sh_float_data, ds_xindex]);
	                  ds_attach[# prop._sh_float_data, ds_xindex] = -1;
	               }
	               if (ds_exists(ds_attach[# prop._sh_mat_data, ds_xindex], ds_type_grid)) {
	                  ds_grid_destroy(ds_attach[# prop._sh_mat_data, ds_xindex]);
	                  ds_attach[# prop._sh_mat_data, ds_xindex] = -1;
	               }
	               if (ds_exists(ds_attach[# prop._sh_samp_data, ds_xindex], ds_type_grid)) {
	                  ds_grid_destroy(ds_attach[# prop._sh_samp_data, ds_xindex]);
	                  ds_attach[# prop._sh_samp_data, ds_xindex] = -1;
	               }
	            }
               
	            //Remove attachments from parent data structure   
	            ds_grid_destroy(ds_character[# prop._attach_data, ds_target]);
	         }   
      
	         //Remove character from data structure
	         ds_character = sys_grid_delete(ds_character, ds_target);  
         
	         //End action when transitions are complete
	         if (ds_target == ds_yindex) {
	            sys_action_term();
	         }
	      }
	   }
            
	   //Continue to next character, if any
	   ds_target -= 1;
	}



}
