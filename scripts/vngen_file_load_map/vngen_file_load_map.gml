/// @function	vngen_file_load_map(filename/ds_map);
/// @param		{string|ds_map}	filename/ds_map
/// @author		Lucas Chasteen <lucas.chasteen@xgasoft.com>
/// @copyright	XGASOFT 2020, All Rights Reserved
function vngen_file_load_map(argument0) {

	/*
	Loads basic VNgen object data from a file which has been created with vngen_file_save
	and returns the results as a ds_map which can be assigned to a variable for later access.

	Can also be used to apply global engine data from a ds_map generated with vngen_file_save_map.

	If the file or ds_map does not exist, 'undefined' will be returned instead. Otherwise, the 
	returned ds_map will contain the following key/value pairs which can be accessed using either 
	the built-in ds_map_find_value function or the ds_map[? "key"] accessor.

	"room" = the active room index (not name) when the save file was created
	"object" = the object index (not name) of the saved VNgen object
	"x" = the saved object x position
	"y" = the saved object y position
	"event" = the saved object VNgen event (numeric, not label)
	"halign_text" = the saved **global** VNgen text alignment setting
	"halign_label" = the saved **global** VNgen label alignment setting
	"lineheight_text" = the saved **global** VNgen text lineheight multiplier
	"lineheight_label" = the saved **global** VNgen label lineheight multiplier
	"auto_type" = the saved **global** VNgen auto mode behavior
	"lang_text" = the saved VNgen text language setting
	"lang_audio" = the saved VNgen audio language setting

	Note that this script does not restore regular game information. Advanced users are
	recommended to replace this script with restore functions tailored to their specific
	project.

	Also note that while basic data may not be restored immediately with this script, global
	option choices, style data, and read logs **are** restored immediately upon loading and
	will override any existing data. 

	argument0 = filename or ds_map of the save data to be read, including path and extension (string/ds_map)

	Example usage:
	   var save_data = vngen_file_save_map();
	   vngen_file_load_map(save_data);

	   var map_load = vngen_file_load_map(working_directory + "save.dat");
   
	   if (!is_undefined(map_load)) {
	      vngen_goto(map_load[? "event"], map_load[? "object]);
	  
	      ds_map_destroy(map_load);
	   }
	*/

	//Get save data from file, if input is string
	if (is_string(argument0)) {
	
		/*
		INITIALIZATION
		*/

		//Skip operation if file does not exist
		if (!file_exists(argument0)) {
		   return undefined;
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
		   ds_save[? "auto_type"] = ini_read_real("engine", "auto_type", 0);
		   ds_save[? "options"] = ini_read_string("engine", "options", "0");
		   ds_save[? "read"] = ini_read_string("engine", "read", "0");  
		   ds_save[? "style"] = ini_read_string("engine", "style", "0");    
		}
		ini_close();
	} else {
		//Otherwise get save data from ds_map
		var ds_save = argument0;
	
		//Skip operation if ds_map does not exist
		if (!ds_exists(ds_save, ds_type_map)) {
			return undefined;
		}
	}


	/*
	GLOBAL PROPERTIES
	*/

	//Restore option choice data, if any
	if (ds_save[? "options"] != "0") {
		if (!ds_exists(global.ds_option_result, ds_type_map)) {
			//Create data structure, if none exists
			global.ds_option_result = ds_map_create();
		} else {
			//Otherwise clear existing data
			ds_map_clear(global.ds_option_result);
		}
	
		//Read option choices into fresh data structure
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

	//Return ds_map containing local properties for later usage
	return ds_save;


}
