/// @function	vngen_log_clear([destroy]);
/// @param		{boolean}	[destroy]
/// @author		Lucas Chasteen <lucas.chasteen@xgasoft.com>
/// @copyright	XGASOFT 2020, All Rights Reserved
function vngen_log_clear() {

	/*
	Clears the log of all entries, optionally also destroying the backlog object 
	when complete (not recommended). 

	If destroying is enabled, this script must be run within the backlog object 
	itself or applied to it via a 'with' statement. Otherwise this script can be 
	run in any object.

	argument0 = enables or disables destroying the object when cleared (boolean) (true/false) (optional, use no argument for false)

	Example usage: 
	   vngen_log_clear(true);
	   vngen_log_clear();
	*/

	//Initialize temporary variables
	var ds_log_text, ds_xindex, ds_yindex;

	//Clear data from memory
	if (ds_exists(global.ds_log, ds_type_grid)) {
	   for (ds_yindex = 0; ds_yindex < ds_grid_height(global.ds_log); ds_yindex += 1) {
   
	      /*
	      TEXT
	      */
      
	      //Clear text data
	      if (ds_exists(global.ds_log[# prop._data_text, ds_yindex], ds_type_grid)) {
	         //Get text data from main data structure
	         ds_log_text = global.ds_log[# prop._data_text, ds_yindex];
         
	         //Remove text data from memory
	         for (ds_xindex = 0; ds_xindex < ds_grid_height(ds_log_text); ds_xindex += 1) {
	            //Remove surfaces
	            if (surface_exists(ds_log_text[# prop._surf, ds_xindex])) {
	               surface_free(ds_log_text[# prop._surf, ds_xindex]);
	            }
         
	            //Remove linebreak data
	            if (ds_exists(ds_log_text[# prop._txt_line_data, ds_xindex], ds_type_list)) {
	               ds_list_destroy(ds_log_text[# prop._txt_line_data, ds_xindex]);
	            }
	         }
         
	         //Remove text data from memory
	         ds_grid_destroy(ds_log_text);
	      }
	   }
   
	   //Remove primary data structure from memory
	   ds_grid_destroy(global.ds_log);
	}

	//Stop all currently playing sounds
	if (ds_exists(global.ds_log_queue, ds_type_grid)) {
	   if (ds_exists(global.ds_log_queue[# prop._data_queue, 0], ds_type_queue)) { 
	      if (!ds_queue_empty(global.ds_log_queue[# prop._data_queue, 0])) {
	         audio_sound_set_track_position(ds_queue_head(global.ds_log_queue[# prop._data_queue, 0]), 0);
	         audio_stop_sound(ds_queue_head(global.ds_log_queue[# prop._data_queue, 0]));
	      }
      
	      //Remove audio queue from memory
	      ds_queue_destroy(global.ds_log_queue[# prop._data_queue, 0]);
	   }
   
	   //Remove queue data from memory
	   ds_grid_destroy(global.ds_log_queue);
	}


	/*
	BUTTONS
	*/

	//Clear button data from memory
	if (ds_exists(global.ds_log_button, ds_type_grid)) { 
	   for (ds_yindex = 0; ds_yindex < ds_grid_height(global.ds_log_button); ds_yindex += 1) {
	      //Clear button surfaces from memory
	      if (surface_exists(global.ds_log_button[# prop._surf, ds_yindex])) {
	         surface_free(global.ds_log_button[# prop._surf, ds_yindex]);
	      } 
	   }
   
	   //Clear data structure
	   ds_grid_destroy(global.ds_log_button); 
	}


	/*
	FINALIZATION
	*/

	//Reset log state
	if (global.vg_log_visible == true) {
	   global.vg_pause = false;
	}

	//Reset log visibility
	global.vg_log_alpha = 0;
	global.vg_log_visible = false;

	//Destroy the running object, if enabled
	if (argument_count > 0) {
	   if (argument[0] == true) {
	      instance_destroy();
	   }
	}


}
