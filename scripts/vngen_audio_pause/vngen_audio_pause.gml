/// @function	vngen_audio_pause(id);
/// @param		{real|string|macro}	id
/// @author		Lucas Chasteen <lucas.chasteen@xgasoft.com>
/// @copyright	XGASOFT 2020, All Rights Reserved
function vngen_audio_pause(argument0) {

	/*
	Pauses the given sound of any type (sfx, voice, or music, except vox).

	As this script is itself treated as an action, it is only practical to
	pause looped sound effects and music. However, this script can be combined 
	with vngen_event_pause to pause any sound played in the same event.

	argument0 = identifier or character name associated with the target sound (real or string) (or keyword 'all' for all)

	Example usage:
	   vngen_event() {
	      vngen_audio_pause("explode");
	      vngen_audio_pause("John Doe");
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
	         //Pause all audio, if enabled
	         var ds_target = sys_grid_last(ds_audio);
	         var ds_yindex = 0;
	      } else {
	         //Otherwise get single sound to pause
	         var ds_target = vngen_get_index(argument0, vngen_type_audio);
	         var ds_yindex = ds_target;
	      }   
   
	      //If the target sound exists...
	      if (!is_undefined(ds_target)) {
	         while (ds_target >= ds_yindex) { 
	            //If the sound is playing...
	            if (ds_audio[# prop._type, ds_target] < 4) {
	               //Pause the sound
	               audio_pause_sound(ds_audio[# prop._snd, ds_target]);
               
	               //Set audio type to paused
	               switch (ds_audio[# prop._type, ds_target]) {
	                  case 0: ds_audio[# prop._type, ds_target] = 4; break; //SFX
	                  case 1: ds_audio[# prop._type, ds_target] = 5; break; //SFX looped
	                  case 2: ds_audio[# prop._type, ds_target] = 6; break; //Voice
	                  case 3: ds_audio[# prop._type, ds_target] = 7; break; //Music
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
