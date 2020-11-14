/// @function	vngen_file_save_map();
/// @author		Lucas Chasteen <lucas.chasteen@xgasoft.com>
/// @copyright	XGASOFT 2020, All Rights Reserved
function vngen_file_save_map() {

	/*
	Returns a ds_map containing basic VNgen progress and engine data, which can then
	be written to save files along with other custom game data.

	If VNgen data could not be found in the current room, 'undefined' will be returned
	instead.

	Note that once save data is written, it is highly recommended to destroy the
	ds_map to prevent memory leaks!

	Example usage:
	   var map_save = vngen_file_save_map();
   
	   if (!is_undefined(map_save)) {
		   ds_map_secure_save(map_save, working_directory + "save.dat");
		   ds_map_destroy(map_save);
	   }
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
	   return undefined;
	}

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

	//Return ds_map containing collected save data
	return ds_save;


}
