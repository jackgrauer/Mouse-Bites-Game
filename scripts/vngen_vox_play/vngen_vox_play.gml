/// @function	vngen_vox_play(name, sound, pitch_min, pitch_max, volume);
/// @param		{string}		name
/// @param		{sound|array}	sound
/// @param		{real}			pitch_min
/// @param		{real}			pitch_max
/// @param		{real}			volume
/// @author		Lucas Chasteen <lucas.chasteen@xgasoft.com>
/// @copyright	XGASOFT 2020, All Rights Reserved
function vngen_vox_play() {

	/*
	Assigns a sound or array of sounds to be played as speech synthesis for the specified 
	character. The sound will be repeated during text typewriter effect progression with 
	optional alterations to pitch for variation. If multiple sounds are provided in an
	array, they will be played at random (sounds can also be added or removed later with
	vngen_vox_add and vngen_vox_remove).

	Pitch will be automatically randomized between min/max values.

	Once vox has been assigned, it will continue to play in all events in the current
	object, or until stopped with vngen_vox_stop. Other audio scripts (pause, resume,
	modify) will ignore this sound type and cannot be used to modify vox.

	argument0 = character name to assign sound to (also used as vox ID) (string)
	argument1 = the sound resource to play (sound or array)
	argument2 = the minimum pitch multiplier, where a value of 1 is default (real) (0-255)
	argument3 = the maximum pitch multiplier, where a value of 1 is default (real) (0-255)
	argument4 = the sound volume, where a value of 1 = 100% (real) (0-1)

	Example usage:
	   vngen_vox_play("John Doe", snd_blip, 1, 1, 1);
	   vngen_vox_play("John Doe", snd_blip, 0.75, 1.75, 1);
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
	      //Get the current number of vox entries
	      var ds_target = ds_grid_height(ds_vox);
      
	      //Create new vox slot in data structure
	      ds_grid_resize(ds_vox, ds_grid_width(ds_vox), ds_grid_height(ds_vox) + 1);
   
	      //Set basic vox properties
	      ds_vox[# prop._id, ds_target] = argument[0];            //ID
	      ds_vox[# prop._type, ds_target] = 0;                    //Type (playing or paused)
	      ds_vox[# prop._snd, ds_target] = ds_list_create();      //Sound list
	      ds_vox[# prop._snd_pitch_min, ds_target] = argument[2]; //Pitch minimum
	      ds_vox[# prop._snd_pitch_max, ds_target] = argument[3]; //Pitch maximum
	      ds_vox[# prop._snd_vol, ds_target] = argument[4];       //Volume
      
	      //Add sound(s) to vox
	      sys_vox_add(ds_vox, ds_target, argument[1]);
      
	      //Set special vox properties
	      ds_vox[# prop._fade_src, ds_target] = -1;               //Fade sound
	      ds_vox[# prop._fade_vol, ds_target] = 1;                //Fade volume        
            
	      //Continue to next action once initialized
	      sys_action_term();
	   }
	}


}
