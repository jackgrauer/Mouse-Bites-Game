/// @function	sys_anim_speech(name, speech, type, [highlight]);
/// @param		{string}		name
/// @param		{boolean}		speech
/// @param		{integer|macro}	type
/// @param		{boolean}		[highlight]
/// @author		Lucas Chasteen <lucas.chasteen@xgasoft.com>
/// @copyright	XGASOFT 2020, All Rights Reserved
function sys_anim_speech() {

	/*
	==========================================================================
	SYSTEM FUNCTION: MODIFY AT YOUR OWN RISK!
	--------------------------------------------------------------------------
	  System functions are executed automatically by the engine and typically
	  should not be run manually by the user
	==========================================================================

	Enables or disables character speech animations and optional highlighting 
	features.

	VNgen's handling of this functionality is highly tailored for its particular
	use-cases and is not intended for general use.

	argument0 = identifier of the character to be modified (string)
	argument1 = enables or disables character speech animations (boolean) (true/false)
	argument2 = sets whether to base speech on text or audio (integer) (or use vngen_type_text or vngen_type_audio)
	argument2 = enables or disables character highlighting (boolean) (true/false) (optional, use no argument for no change)

	Example usage:
	   sys_anim_speech("John Doe", true, 6);
	   sys_anim_speech("John Doe", false, 10, false);
	*/

	//Initialize temporary variables for checking character slot
	var ds_yindex;

	//Check data structure for target character
	for (ds_yindex = 0; ds_yindex < ds_grid_height(ds_character); ds_yindex += 1) {
	   //If a character with a matching name exists...
	   if (ds_character[# prop._id, ds_yindex] == argument[0]) {
	      //Enable or disable text-based speech animations
		  if (argument[2] == vngen_type_text) {
			 ds_character[# prop._txt_active, ds_yindex] = argument[1];
		  } else {
			 //Enable or disable audio-based speech animations
			 ds_character[# prop._snd_active, ds_yindex] = argument[1];
		  }
      
	      //Enable or disable highlighting, if specified
	      if (argument_count > 3) {
			 if (ds_character[# prop._hlight, ds_yindex] != none) {
	            ds_character[# prop._hlight, ds_yindex] = argument[3];
			 }
	      }
	      break;
	   }
	}


}
