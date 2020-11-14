/// @function	vngen_audio_resume(id);
/// @param		{real|string|macro}	id
/// @author		Lucas Chasteen <lucas.chasteen@xgasoft.com>
/// @copyright	XGASOFT 2020, All Rights Reserved
function vngen_audio_resume(argument0) {

	/*
	Unpauses the given sound of any type (sfx, voice, or music, except vox).

	This script should only be used to resume sounds paused with
	vngen_audio_pause and not the built-in audio_pause_sound
	function.

	argument0 = identifier or character name associated with the target sound (real or string) (or keyword 'all' for all)

	Example usage:
	   vngen_event() {
	      vngen_audio_resume("explode");
	      vngen_audio_resume("John Doe");
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
	      //Get audio slot
	      if (argument0 == all) {
	         //Unpause all audio, if enabled
	         var ds_target = sys_grid_last(ds_audio);
	         var ds_yindex = 0;
	      } else {
	         //Otherwise get single sound to unpause
	         var ds_target = vngen_get_index(argument0, vngen_type_audio);
	         var ds_yindex = ds_target;
	      }     
   
	      //If the target sound exists...
	      if (!is_undefined(ds_target)) {
	         while (ds_target >= ds_yindex) { 
	            //If the sound is paused...
	            if (ds_audio[# prop._type, ds_target] > 3) {
	               //Resume the sound
	               audio_resume_sound(ds_audio[# prop._snd, ds_target]);
               
	               //Set audio type to playing
	               switch (ds_audio[# prop._type, ds_target]) {
	                  case 4: ds_audio[# prop._type, ds_target] = 0; break;
	                  case 5: ds_audio[# prop._type, ds_target] = 1; break;
	                  case 6: ds_audio[# prop._type, ds_target] = 2; break;
	                  case 7: ds_audio[# prop._type, ds_target] = 3; break; 
	               }
	            }      
            
	            //Continue to next sound, if any
	            ds_target -= 1;
	         }     
	      }
         
	      //Continue to next action once initialized
	      sys_action_term(); 
	   }
	}


}
