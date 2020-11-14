/// @function	vngen_event_reset_target();
/// @author		Lucas Chasteen <lucas.chasteen@xgasoft.com>
/// @copyright	XGASOFT 2020, All Rights Reserved
function vngen_event_reset_target() {

	/*
	Finalizes a segment of code containing VNgen events. After the final 
	instance of vngen_event, vngen_event_reset_target must be run to
	properly end the sequence.

	Intended to be run in the Step event.

	No parameters

	Example usage:
	   vngen_event_set_target();

	   if vngen_event() {
	      //Actions
	   }

	   vngen_event_reset_target();
	*/

	/*
	INITIALIZATION
	*/

	//Initialize temp variables
	var ds_type, ds_yindex;


	/*
	PERFORM AUDIO
	*/

	if (ds_exists(ds_audio, ds_type_grid)) {
	   for (ds_yindex = 0; ds_yindex < ds_grid_height(ds_audio); ds_yindex += 1) {
	      //Get audio type
	      ds_type = ds_audio[# prop._type, ds_yindex];
        
	      //Pause voice and sound effects if engine is paused
	      if (global.vg_pause == true) {  
	         if (ds_type < 3) {
	            if (!audio_is_paused(ds_audio[# prop._snd, ds_yindex])) {
	               audio_pause_sound(ds_audio[# prop._snd, ds_yindex]);
	            }
	         }
	      } else {
	         //Unpause voice and sound effects if engine is unpaused   
	         if (ds_type < 3) {
	            if (audio_is_paused(ds_audio[# prop._snd, ds_yindex])) {
	               audio_resume_sound(ds_audio[# prop._snd, ds_yindex]);
	            }
	         }
	      }

	      //Skip processing if sound is paused
	      if (!audio_is_paused(ds_audio[# prop._snd, ds_yindex])) {
	         //Increment track position
	         if (ds_audio[# prop._snd_pos, ds_yindex] < ds_audio[# prop._snd_end, ds_yindex]) {
	            //Get time passed since last frame
	            if (global.vg_event_skip_reset == 0) and (ds_audio[# prop._event, ds_yindex] == event_current) {
	               //Do not increment new audio if created at skip target
	               var audio_delta = 0;
	            } else {
	               //Otherwise increment by delta time
	               var audio_delta = time_frame*ds_audio[# prop._snd_pitch, ds_yindex];
	            }
            
	            //Increment track position
	            ds_audio[# prop._snd_pos, ds_yindex] += audio_delta;
            
	            //Disallow exceeding target values
	            if (ds_audio[# prop._snd_pos, ds_yindex] >= ds_audio[# prop._snd_end, ds_yindex]) {
	               ds_audio[# prop._snd_pos, ds_yindex] = ds_audio[# prop._snd_end, ds_yindex];
            
	               //If sound is looped...
	               if (is_odd(ds_type)) {
	                  //Reset track to start position
	                  audio_sound_set_track_position(ds_audio[# prop._snd, ds_yindex], ds_audio[# prop._snd_start, ds_yindex]);
               
	                  //Reset sound position
	                  ds_audio[# prop._snd_pos, ds_yindex] = ds_audio[# prop._snd_start, ds_yindex];
	               }
	            }
	         }
	      }
	   }
	}


	/*
	PERFORM EVENTS
	*/

	//Get the total number of events in the code segment
	if (event_count == 0) {
	   event_count = event_id + 1;
	}

	//Get the total number of actions in the current event
	if (action_count == 0) {
	   action_count = action_id + 1;
	}

	//Test for changes in current event
	if (event_previous != event_current) {
	   event_previous = event_current;
	}


	/*
	FINALIZATION
	*/

	//Continue to next event when all actions are complete
	if (global.vg_ui_visible == true) or (global.vg_ui_lock == false) {
	   if (global.vg_pause == false) {  
	      if (option_count == 0) {
	         if (action_complete == action_count) {
	            //Delay continuing to the next event if auto mode is enabled
	            if (global.vg_text_auto == true) {
	               if (global.vg_text_auto_current < global.vg_text_auto_pause) {
	                  //Countdown delay
	                  global.vg_text_auto_current += time_frame;
	                  exit;
	               }
	            }
      
	            //Continue to next event
	            if (event_current < event_count) {
	               //Submit text and audio data to backlog
	               sys_queue_submit("log");
               
	               //Enable next event in timeline
	               event_current += 1;
      
	               //Reset action status
	               action_complete = 0;
	               action_count = 0;
	               action_current = 0;
	               action_previous = -1;
	            }
	         }
	      }
	   }
	}



}
