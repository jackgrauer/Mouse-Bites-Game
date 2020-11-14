/// @function	vngen_do_log_play();
/// @author		Lucas Chasteen <lucas.chasteen@xgasoft.com>
/// @copyright	XGASOFT 2020, All Rights Reserved
function vngen_do_log_play() {

	/*
	Plays all audio associated with the highlighted log entry, if any.
	By default, only audio played with vngen_audio_play_voice will be 
	included in the backlog.

	Intended to be run in global mouse, keyboard, and gamepad input events.

	No parameters

	Example usage:
	   vngen_do_log_play();
	*/

	//If the log is open and visible...
	if (global.vg_log_visible == true) {
	   if (global.vg_log_alpha >= 1) {
	      //If new audio exists...
	      if (log_event >= 0) {
	         if (!is_undefined(global.ds_log[# prop._data_audio, log_event])) {
	            if (global.ds_log[# prop._data_audio, log_event] != "") {
	               //Ensure the main audio queue exists
	               if (ds_exists(global.ds_log_queue, ds_type_grid)) {
	                  if (!ds_exists(global.ds_log_queue[# prop._data_queue, 0], ds_type_queue)) {
	                     global.ds_log_queue[# prop._data_queue, 0] = ds_queue_create();
	                  }
      
	                  //Stop previous audio, if any
	                  if (!ds_queue_empty(global.ds_log_queue[# prop._data_queue, 0])) {
	                     audio_sound_set_track_position(ds_queue_head(global.ds_log_queue[# prop._data_queue, 0]), 0);
	                     audio_stop_sound(ds_queue_head(global.ds_log_queue[# prop._data_queue, 0]));
      
	                     //Clear the queue
	                     ds_queue_clear(global.ds_log_queue[# prop._data_queue, 0]);
	                  }
     
	                  //Enqueue audio from logged event to main audio queue
	                  var audio_queue = global.ds_log[# prop._data_audio, log_event];
	                  while (string_count("|", audio_queue) > 0) {
	                     ds_queue_enqueue(global.ds_log_queue[# prop._data_queue, 0], asset_get_index(string_copy(audio_queue, 1, string_pos("|", audio_queue) - 1)));
	                     audio_queue = string_delete(audio_queue, 1, string_pos("|", audio_queue));
	                  }
            
	                  //Mark the current logged event as playing audio
	                  global.ds_log_queue[# prop._data_event, 0] = log_event;
	               }
	            }
	         }
	      }
	   }
	}


}
