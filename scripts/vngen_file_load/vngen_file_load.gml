/// @function	vngen_file_load(filename);
/// @param		{string}	filename
/// @author		Lucas Chasteen <lucas.chasteen@xgasoft.com>
/// @copyright	XGASOFT 2020, All Rights Reserved
function vngen_file_load(argument0) {

	/*
	Loads basic VNgen object data from a file which has been created with vngen_file_save.

	Bear in mind that this script will change rooms when run! However, the current Step
	will finish before the room change is actually applied, so any code run after this
	script will have a chance to complete.

	Note that this script ONLY loads VNgen save data. Advanced users are recommended to
	use vngen_file_save_map and vngen_file_load_map to write and read custom data along
	with VNgen.

	argument0 = filename of the save file to be read, including path and extension (string)

	Example usage:
	   vngen_file_load(working_directory + "save.dat");
	*/

	/*
	INITIALIZATION
	*/

	//Skip operation if file does not exist
	if (!file_exists(argument0)) {
	   return false;
	}

	//Create temporary data structure for reading data
	var ds_save = ds_map_create();

	//Read save data into temp data structure
	ini_open(argument0);
	if (ini_key_exists("engine", "data")) {
	   //Read encrypted data, if file is encrypted
	   ds_map_read(ds_save, ini_read_string("engine", "data", "0"));
   
	   //Ensure map data exists
	   if (is_undefined(ds_save[? "options"])) {
	      ds_save[? "options"] = "0"; 
	   }
	   if (is_undefined(ds_save[? "read"])) {
	      ds_save[? "read"] = "0"; 
	   }
	   if (is_undefined(ds_save[? "style"])) {
	      ds_save[? "style"] = "0"; 
	   }
	} else {
	   //Otherwise, read unencrypted data
	   ds_save[? "room"] = ini_read_real("engine", "room", room);
	   ds_save[? "object"] = asset_get_index(ini_read_string("engine", "object", object_get_name(object_index)));
	   ds_save[? "x"] = ini_read_real("engine", "x", x);
	   ds_save[? "y"] = ini_read_real("engine", "y", y);
	   ds_save[? "event"] = ini_read_real("engine", "event", 0);  
	   ds_save[? "halign_text"] = ini_read_real("engine", "halign_text", fa_left);
	   ds_save[? "halign_label"] = ini_read_real("engine", "halign_label", fa_left);
	   ds_save[? "lineheight_text"] = ini_read_real("engine", "lineheight_text", 1.5);
	   ds_save[? "lineheight_label"] = ini_read_real("engine", "lineheight_label", 1.5);
	   ds_save[? "lang_text"] = ini_read_string("engine", "lang_text", "-1");
	   ds_save[? "lang_audio"] = ini_read_string("engine", "lang_audio", "-1");
	   ds_save[? "options"] = ini_read_string("engine", "options", "0");
	   ds_save[? "read"] = ini_read_string("engine", "read", "0");  
	   ds_save[? "style"] = ini_read_string("engine", "style", "0");  
	   ds_save[? "auto_type"] = ini_read_real("engine", "auto_type", 0);
	}
	ini_close();


	/*
	GLOBAL PROPERTIES
	*/
   
	//Restore global text settings
	global.vg_halign_text = ds_save[? "halign_text"];
	global.vg_halign_label = ds_save[? "halign_label"];
	global.vg_lineheight_text = ds_save[? "lineheight_text"];
	global.vg_lineheight_label = ds_save[? "lineheight_label"];
	global.vg_text_auto_pause_indefinite = ds_save[? "auto_type"];

	//Restore option log data, if any
	if (ds_save[? "options"] != "0") {
		if (!ds_exists(global.ds_option_result, ds_type_map)) {
			//Create data structure, if none exists
			global.ds_option_result = ds_map_create();
		} else {
			//Otherwise clear existing data
			ds_map_clear(global.ds_option_result);
		}
	
		//Read option log into fresh data structure
		ds_map_read(global.ds_option_result, ds_save[? "options"]);
	}
   
	//Restore text style inheritance data, if any
	if (ds_save[? "style"] != "0") {
	   if (!ds_exists(global.ds_style, ds_type_map)) {
	      //Create data structure, if none exists
	      global.ds_style = ds_map_create();
	   } else {
	      //Otherwise clear existing data
	      ds_map_clear(global.ds_style);
	   }
      
	   //Read style data into fresh data structure
	   ds_map_read(global.ds_style, ds_save[? "style"]);
	}
   
	//Restore global text language setting
	if (string_letters(ds_save[? "lang_text"]) == "") {
	   //Real flag
	   global.vg_lang_text = real(ds_save[? "lang_text"]);
	} else {
	   //String flag
	   global.vg_lang_text = ds_save[? "lang_text"];
	}
   
	//Restore global audio language setting
	if (string_letters(ds_save[? "lang_audio"]) == "") {
	   //Real flag
	   global.vg_lang_audio = real(ds_save[? "lang_audio"]);
	} else {
	   //String flag
	   global.vg_lang_audio = ds_save[? "lang_audio"];
	}

	//Restore read log data, if any
	if (ds_save[? "read"] != "0") {
	   if (!ds_exists(global.ds_read, ds_type_map)) {
	      //Create data structure, if none exists
	      global.ds_read = ds_map_create();
	   } else {
	      //Otherwise clear existing data
	      ds_map_clear(global.ds_read);
	   }
      
	   //Read read log data into fresh data structure
	   ds_map_read(global.ds_read, ds_save[? "read"]);
	}


	/*
	LOCAL PROPERTIES
	*/

	//Restore saved room, object, and event
	vngen_room_goto(ds_save[? "room"], ds_save[? "event"], ds_save[? "object"]);

	//Clear temp data from memory
	ds_map_destroy(ds_save);
	vngen_object_clear(true);
	return true;


}
