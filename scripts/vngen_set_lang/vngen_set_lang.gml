/// @function	vngen_set_lang(lang, [type]);
/// @param		{real|string}	lang
/// @param		{integer|macro}	[type]
/// @author		Lucas Chasteen <lucas.chasteen@xgasoft.com>
/// @copyright	XGASOFT 2020, All Rights Reserved
function vngen_set_lang() {

	/*
	Sets the language flags for text and audio actions so that only actions flagged 
	for the given language are performed.

	'Type' is an integer value specifying whether to apply the language to text (0) 
	or audio (1). If no type argument is supplied, both types will be modified.

	Language flags are arbitrary and can be either numbers or strings, so long as 
	they match up with the value used in text and audio actions. Note that the 
	value -1 is reserved as 'null' and cannot be used as a language flag.

	argument0 = sets the language flag for text or audio actions (real or string)
	argument1 = sets whether to apply language to text (0) or audio (1) (integer) (optional, use 'vngen_type_text' and 'vngen_type_audio' or no argument for both)

	Example usage:
	   vngen_set_lang("EN");
	   vngen_set_lang("JP", 0);
	   vngen_set_lang("ES", 1);
	*/

	//Get language type, if any
	if (argument_count > 1) {
	   if (argument[1] > 1) {
	      //Macro type
	      var lang_type = clamp(argument[1] - vngen_type_text, 0, 1);
	   } else {
	      //Integer type
	      var lang_type = argument[1];
	   }
	} else {
	   //Otherwise set all types
	   var lang_type = -1;
	}

	//Set text and/or audio language
	switch (lang_type) {
	   case 0: global.vg_lang_text = argument[0]; break;  //Text
	   case 1: global.vg_lang_audio = argument[0]; break; //Audio
	   default: global.vg_lang_text = argument[0]; global.vg_lang_audio = argument[0]; break; //Both
	}


}
