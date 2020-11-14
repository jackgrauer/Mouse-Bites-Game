/// @function	sys_queue_submit(id);
/// @param		{string}	id
/// @author		Lucas Chasteen <lucas.chasteen@xgasoft.com>
/// @copyright	XGASOFT 2020, All Rights Reserved
function sys_queue_submit() {

	/*
	==========================================================================
	SYSTEM FUNCTION: MODIFY AT YOUR OWN RISK!
	--------------------------------------------------------------------------
	  System functions are executed automatically by the engine and typically
	  should not be run manually by the user
	==========================================================================

	Although it might seem strange, at times it is useful to enqueue information
	using a ds_grid instead of a ds_queue. VNgen uses this functionality to delay 
	propagation of certain information until the end of an event, such as logged
	strings and audio.

	Once a queue has been created, it can be submitted as log data, which will
	remove data from the queue and add it to the backlog instead.

	VNgen's handling of this functionality is highly tailored for its particular
	use-cases and is not intended for general use. Queues submitted as log data
	must be properly formatted for use with vngen_log_add.

	argument0 = the ID of the queue to submit (string)

	Example usage:
	   sys_queue_submit("log");
	*/

	//Get the target queue ID string
	var ds_queue = "sys_queue_" + argument[0];

	//If the target queue ID doesn't exist, skip submission
	if (!variable_global_exists(ds_queue)) {
	   exit;
	}

	//If the target queue data structure doesn't exist, skip submission
	if (!ds_exists(variable_global_get(ds_queue), ds_type_grid)) {
	   exit;
	}

	//Get the target queue data structure
	ds_queue = variable_global_get(ds_queue);

	//Initialize variables for reading queue data
	var ds_target, ds_xindex, ds_yindex;

	//Submit data to the backlog
	for (ds_target = 0; ds_target < ds_grid_height(ds_queue); ds_target += 1) {
	   //Submit text or audio data
	   if (ds_queue[# 1, ds_target] != none) {
	      vngen_log_add(ds_queue[# 0, ds_target], ds_queue[# 1, ds_target], ds_queue[# 2, ds_target], ds_queue[# 3, ds_target], ds_queue[# 4, ds_target], ds_queue[# 5, ds_target], ds_queue[# 6, ds_target], ds_queue[# 7, ds_target], ds_queue[# 8, ds_target], ds_queue[# 9, ds_target], ds_queue[# 10, ds_target], ds_queue[# 11, ds_target]);
	   } else {
	      //Submit style data
	      if (ds_exists(global.ds_log, ds_type_grid)) {
	         for (ds_yindex = ds_grid_height(global.ds_log) - 1; ds_yindex >= 0; ds_yindex -= 1) {
	            //If logged data exists for the current event...
	            if (global.ds_log[# prop._data_event, ds_yindex] == ds_queue[# 0, ds_target]) {
	               if (ds_exists(global.ds_log[# prop._data_text, ds_yindex], ds_type_grid)) {
	                  //Get text data from event
	                  var ds_log_text = global.ds_log[# prop._data_text, ds_yindex];
                     
	                  //Check text data for the text being modified
	                  for (ds_xindex = ds_grid_height(ds_log_text) - 1; ds_xindex >= 0; ds_xindex -= 1) {
	                     if (ds_log_text[# prop._name, ds_xindex] == ds_queue[# 2, ds_target]) {
	                        //Update text style, if found
	                        ds_log_text[# prop._col1, ds_xindex] = ds_queue[# 4, ds_target];             //Color 1
	                        ds_log_text[# prop._col2, ds_xindex] = ds_queue[# 5, ds_target];             //Color 2
	                        ds_log_text[# prop._col3, ds_xindex] = ds_queue[# 6, ds_target];             //Color 3
	                        ds_log_text[# prop._col4, ds_xindex] = ds_queue[# 7, ds_target];             //Color 4
	                        ds_log_text[# prop._txt_shadow, ds_xindex] = ds_queue[# 8, ds_target];       //Shadow
	                        ds_log_text[# prop._txt_outline, ds_xindex] = ds_queue[# 9, ds_target];      //Outline
	                        ds_log_text[# prop._txt_halign, ds_xindex] = ds_queue[# 10, ds_target];      //Alignment
	                        ds_log_text[# prop._txt_line_height, ds_xindex] = ds_queue[# 11, ds_target]; //Lineheight
	                        break;
	                     }
	                  }
	               }        
	            }
	         }   
	      }
	   }
	}

	//Dequeue data from grid
	ds_grid_destroy(ds_queue);
	variable_global_set("sys_queue_" + argument[0], -1);


}
