/// @function	cmd_vngen_set_vol(type, vol, [fade]);
/// @param		{integer|macro}	type
/// @param		{real}			vol
/// @param		{real}			[fade]
/// @author		Lucas Chasteen <lucas.chasteen@xgasoft.com>
/// @copyright	XGASOFT 2020, All Rights Reserved
function cmd_vngen_set_vol() {

	/*
	==========================================================================
	SYSTEM FUNCTION: MODIFY AT YOUR OWN RISK!
	--------------------------------------------------------------------------
	  System functions are executed automatically by the engine and typically
	  should not be run manually by the user
	==========================================================================

	A command script for use with the VNgen command console.

	Note that all arguments passed from the command console are passed as strings
	and must be converted to reals manually, if necessary.

	See sys_cmd_add to add commands to the console.
	*/

	//Check for correct input
	if (argument_count < 2) {
	   //Return argument error if input is malformed
	   return "Error: Wrong number of arguments";
	}

	//Get audio type
	var audio_type = all;
	switch (argument[0]) {
		case "audio_type_sound": audio_type = audio_type_sound; break;
		case "audio_type_voice": audio_type = audio_type_voice; break;
		case "audio_type_music": audio_type = audio_type_music; break;
		case "audio_type_vox":   audio_type	= audio_type_vox;	break;
		case "audio_type_ui":    audio_type	= audio_type_ui;	break;
		case "all":				 audio_type = all;				break;
		default: return "Error: Unknown audio type";
	}

	//Get audio volume
	var audio_vol = real(argument[1]);

	//Get fade, if any
	if (argument_count > 2) {
		var audio_fade = real(argument[2]);
	} else {
		var audio_fade = 0;
	}

	//Set volume
	vngen_set_vol(audio_type, audio_vol, audio_fade);

	//Return result dialog
	return "Set " + argument[0] + " volume to " + string(round(audio_vol*100)) + "%";


}
