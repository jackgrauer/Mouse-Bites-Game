/// @function	vngen_get_lang(type);
/// @param		{integer|macro}	type
/// @author		Lucas Chasteen <lucas.chasteen@xgasoft.com>
/// @copyright	XGASOFT 2020, All Rights Reserved
function vngen_get_lang() {

	/*
	Returns the current language flag for either text or audio for use in
	custom language-based actions.

	'Type' is an integer value specifying whether to return the language 
	currently set to text (0) or audio (1). If no language is set for the
	given type, the null value -1 will be returned instead.

	argument0 = sets whether to get text (0) or audio (1) language (integer)

	Example usage:
	   if (vngen_get_lang(0) == "EN") {
	      show_message("Current text language is English");
	   }
	*/

	//Get language type
	if (argument[0] > 1) {
	   //Macro type
	   var lang_type = clamp(argument[0] - vngen_type_text, 0, 1);
	} else {
	   //Integer type
	   var lang_type = argument[0];
	}

	//Return the current text or audio language
	switch (lang_type) {
	   case 0: return global.vg_lang_text; break;  //Text
	   case 1: return global.vg_lang_audio; break; //Audio
	}


}
