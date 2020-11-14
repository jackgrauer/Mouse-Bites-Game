/// @function	vngen_file_save(filename, [encrypt]);
/// @param		{string}	filename
/// @param		{boolean}	[encrypt]
/// @author		Lucas Chasteen <lucas.chasteen@xgasoft.com>
/// @copyright	XGASOFT 2020, All Rights Reserved
function vngen_file_save() {

	/*
	Saves basic VNgen progress and engine data to a file with optional encryption which 
	can later be restored with vngen_file_load. Can be run in any object coexisting an 
	object running VNgen script. Also returns true or false depending on whether the save
	operation was successful.

	Note that this script ONLY writes VNgen save data. Advanced users are recommended to
	use vngen_file_save_map and vngen_file_load_map to write and read custom data along
	with VNgen.

	argument0 = filename of the save file to be written, including path and extension (string)
	argument1 = enables or disables writing encrypted file (boolean) (true/false) (optional, use no argument for encrypted)

	Example usage:
	   vngen_file_save(working_directory + "save.dat");
	   vngen_file_save(working_directory + "save.dat", false);
	*/

	//Initialize temporary variables for checking VNgen object
	var inst_index;
	var obj_index = -1;

	//Get running object ID if VNgen exists
	if (variable_instance_exists(id, "ds_text")) {
	   obj_index = id;
	} else {
	   //Otherwise check other objects for VNgen
	   for (inst_index = 0; inst_index < instance_count; inst_index += 1) {
	      if (variable_instance_exists(instance_id[inst_index], "ds_text")) {
	         //Get VNgen object ID, if found
	         obj_index = instance_id[inst_index];
	         break;
	      }
	   }
	}

	//Skip operation if no VNgen object is found
	if (obj_index == -1) {
	   return false;
	}

	//Use encryption, if enabled
	var encrypt = true;

	//Otherwise disable encryption
	if (argument_count > 1) {
	   if (argument[1] == false) {
	      encrypt = false;
	   }
	}

	//Write data to file
	ini_open(argument[0]);
	if (encrypt == true) {
	   //Create temporary data structure for writing data
	   var ds_save = ds_map_create();

	   //Get VNgen object data
	   ds_save[? "room"] = room;
	   ds_save[? "object"] = obj_index.object_index;
	   ds_save[? "x"] = obj_index.x;
	   ds_save[? "y"] = obj_index.y;
	   ds_save[? "event"] = obj_index.event_current;
	   ds_save[? "halign_text"] = global.vg_halign_text;
	   ds_save[? "halign_label"] = global.vg_halign_label;
	   ds_save[? "lineheight_text"] = global.vg_lineheight_text;
	   ds_save[? "lineheight_label"] = global.vg_lineheight_label;
	   ds_save[? "lang_text"] = global.vg_lang_text;
	   ds_save[? "lang_audio"] = global.vg_lang_audio;
	   ds_save[? "auto_type"] = global.vg_text_auto_pause_indefinite;
   
	   //Get option log data
	   if (ds_exists(global.ds_option_result, ds_type_map)) {
		  ds_save[? "options"] = ds_map_write(global.ds_option_result);
	   } else {
	      ds_save[? "options"] = "0";
	   }
   
	   //Get read log data
	   if (ds_exists(global.ds_read, ds_type_map)) {
	      ds_save[? "read"] = ds_map_write(global.ds_read);
	   } else {
	      ds_save[? "read"] = "0";
	   }
   
	   //Get style inheritance data
	   if (ds_exists(global.ds_style, ds_type_map)) {
	      ds_save[? "style"] = ds_map_write(global.ds_style);
	   } else {
	      ds_save[? "style"] = "0";
	   }
   
	   //Clear unencrypted data, if any
	   if (ini_section_exists("engine")) {
	      ini_section_delete("engine");
	   }
   
	   //Write encrypted data
	   ini_write_string("engine", "data", ds_map_write(ds_save));

	   //Clear temp data from memory
	   ds_map_destroy(ds_save);
	} else {
	   //Write unencrypted object data
	   ini_write_real("engine", "room", room);
	   ini_write_string("engine", "object", object_get_name(obj_index.object_index));
	   ini_write_real("engine", "x", obj_index.x);
	   ini_write_real("engine", "y", obj_index.y);
	   ini_write_real("engine", "event", obj_index.event_current);
	   ini_write_real("engine", "halign_text", global.vg_halign_text);
	   ini_write_real("engine", "halign_label", global.vg_halign_label);
	   ini_write_real("engine", "lineheight_text", global.vg_lineheight_text);
	   ini_write_real("engine", "lineheight_label", global.vg_lineheight_label);
	   ini_write_string("engine", "lang_text", string(global.vg_lang_text));
	   ini_write_string("engine", "lang_audio", string(global.vg_lang_audio));
	   ini_write_real("engine", "auto_type", global.vg_text_auto_pause_indefinite);
   
	   //Write unencrypted option log data
	   if (ds_exists(global.ds_option_result, ds_type_map)) {
		  ini_write_string("engine", "options", ds_map_write(global.ds_option_result));
	   } else {
	      ini_write_string("engine", "options", "0");  
	   }
   
	   //Write unencrypted read log data
	   if (ds_exists(global.ds_read, ds_type_map)) {
	      ini_write_string("engine", "read", ds_map_write(global.ds_read));
	   } else {
	      ini_write_string("engine", "read", "0");  
	   }
   
	   //Write unencrypted style inheritance data
	   if (ds_exists(global.ds_style, ds_type_map)) {
	      ini_write_string("engine", "style", ds_map_write(global.ds_style));
	   } else {
	      ini_write_string("engine", "style", "0");  
	   }
   
	   //Clear encrypted data, if any
	   if (ini_key_exists("engine", "data")) {
	      ini_key_delete("engine", "data");
	   }
	}
	ini_close();

	//Verify file write operation completed successfully
	if (!file_exists(argument[0])) {
	   return false;
	}

	//Confirm save completed successfully
	return true;



}
