/// @function	vngen_get_vol(type);
/// @param		{integer|macro}	type
/// @author		Lucas Chasteen <lucas.chasteen@xgasoft.com>
/// @copyright	XGASOFT 2020, All Rights Reserved
function vngen_get_vol() {

	/*
	Returns the global volume offset for VNgen sounds, music, or other audio, where a value 
	of 1 equals 100%.

	Audio types include: 
	audio_type_sound, audio_type_voice, audio_type_music, audio_type_vox, audio_type_ui

	Note that many sounds also support individual volume modifications. Those volumes are
	**relative** to the global volume, not an override, and cannot be returned by this script.

	argument0 = the audio type to get volume (integer/macro)

	Example usage:
		var vol_sfx = vngen_get_vol(audio_type_sound);
	*/

	//Get input sound type
	switch (argument[0]) {
		//Return global sound volume
		case audio_type_sound: 
			return global.vg_vol_sound;
		
		//Return global voice volume
		case audio_type_voice:
			return global.vg_vol_voice;
		
		//Return global music volume
		case audio_type_music:
			return global.vg_vol_music;
		
		//Return global vox volume	
		case audio_type_vox:
			return global.vg_vol_vox;
		
		//Return global UI sound volume
		case audio_type_ui:
			return global.vg_vol_ui;
	}


}
