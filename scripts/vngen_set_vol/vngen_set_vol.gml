/// @function	vngen_set_vol(type, vol, [fade]);
/// @param		{integer|macro}	type
/// @param		{real}			vol
/// @param		{real}			[fade]
/// @author		Lucas Chasteen <lucas.chasteen@xgasoft.com>
/// @copyright	XGASOFT 2020, All Rights Reserved
function vngen_set_vol() {

	/*
	Sets the global volume offset for VNgen sounds, music, and/or other audio, optionally
	fading from the previous volume for the specified duration, in seconds.

	Audio types include: 
	audio_type_sound, audio_type_voice, audio_type_music, audio_type_vox, audio_type_ui

	The 'all' keyword can also be used to modify volume for all types simultaneously.

	Note that many sounds also support individual volume modifications. Those volumes are
	**relative** to the global volume, not an override.

	Also note that not all sounds support fading.

	argument0 = the audio type to modify (integer/macro) (or keyword 'all' for all types)
	argument1 = the target global volume, where a value of 1 equals 100% (real) (0-1)
	argument2 = sets the duration of the volume transition, in seconds (real) (optional, use no argument for none)

	Example usage:
		vngen_set_vol(all, 0);
		vngen_set_vol(audio_type_music, 0.5, 5);
	*/

	/*
	INITIALIZATION
	*/

	//Initialize temporary variables for processing sounds
	var audio_fade = 0,
		audio_type_play = -1,
		audio_type_pause = -1,
		ds_yindex;

	//Fade existing sounds, if supported
	if (argument_count > 2) {
		audio_fade = argument[2];
	}


	/*
	VOLUMES
	*/

	//Set global sound volume
	if (argument[0] == audio_type_sound) or (argument[0] == all) {
		global.vg_vol_sound = argument[1];
	
		//Set sound types to update
		audio_type_play = 1;
		audio_type_pause = 5;
	}

	//Set global voice volume
	if (argument[0] == audio_type_voice) or (argument[0] == all) {
		global.vg_vol_voice = argument[1];
	
		//Set sound types to update
		audio_type_play = 2;
		audio_type_pause = 6;
	}

	//Set global music volume
	if (argument[0] == audio_type_music) or (argument[0] == all) {
		global.vg_vol_music = argument[1];
	
		//Set sound types to update
		audio_type_play = 3;
		audio_type_pause = 7;
	}

	//Set global vox volume
	if (argument[0] == audio_type_vox) or (argument[0] == all) {
		global.vg_vol_vox = argument[1];
	}

	//Set global UI sound volume
	if (argument[0] == audio_type_ui) or (argument[0] == all) {
		global.vg_vol_ui = argument[1];
	}


	/*
	PROPAGATION
	*/

	//Skip processing if volume is global only
	if (audio_type_play < 0) {
		exit;
	}

	//Otherwise, get VNgen object
	var inst_vngen = instance_find_var("ds_text", 0);

	//Skip processing if no VNgen object is found
	if (inst_vngen == noone) {
		exit;
	}

	//Skip processing if vngen_object_clear has been run
	if (inst_vngen.event_current < 0) {
		exit;
	}

	//Skip processing if audio data structure does not exist
	var ds_data = inst_vngen.ds_audio;
	if (!ds_exists(ds_data, ds_type_grid)) {
		exit;
	}

	//Update volume for existing audio
	while (audio_type_play > -1) {
		for (ds_yindex = 0; ds_yindex < ds_grid_height(ds_data); ds_yindex += 1) {
		   if (ds_data[# prop._type, ds_yindex] == audio_type_play) or (ds_data[# prop._type, ds_yindex] == audio_type_pause) {
		      //Set new volume with fade, if any
		      audio_sound_gain(ds_data[# prop._snd, ds_yindex], ds_data[# prop._snd_vol, ds_yindex]*argument[1], audio_fade*1000);
		   }
		}
	
		//Repeat loop to update all sounds, if specified
		if (argument[0] == all) or (audio_type_play < 2) { //Also handle looped SFX
			audio_type_play -= 1;
			audio_type_pause -= 1;
		} else {
			//End update for other types
			break;
		}
	}


}
