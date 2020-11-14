/// @function	vngen_is_log_playing();
/// @author		Lucas Chasteen <lucas.chasteen@xgasoft.com>
/// @copyright	XGASOFT 2020, All Rights Reserved
function vngen_is_log_playing() {

	/*
	Checks whether or not the VNgen backlog is visible and returns 'true' or 'false'.

	Example usage:
	   if (vngen_is_log_playing()) {
	      vngen_set_vol(audio_type_music, 0.5, 0.5);
	   } else {
	      vngen_set_vol(audio_type_music, 1, 0.5);
	   }
	*/

	//Return the current log audio playback state
	return global.ds_log_queue[# prop._data_event, 0] != -1;


}
