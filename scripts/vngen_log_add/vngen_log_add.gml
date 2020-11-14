/// @function	vngen_log_add(index, data, [name], [font, col1, col2, col3, col4, shadow, outline, halign, lineheight]);
/// @param		{integer|macro}	index
/// @param		{string|sound}	data
/// @param		{string}		[name]
/// @param		{font}			[font
/// @param		{color}			col1
/// @param		{color}			col2
/// @param		{color}			col3
/// @param		{color}			col4
/// @param		{color}			shadow
/// @param		{color}			outline
/// @param		{constant}		halign
/// @param		{real}			lineheight]
/// @author		Lucas Chasteen <lucas.chasteen@xgasoft.com>
/// @copyright	XGASOFT 2020, All Rights Reserved
function vngen_log_add() {

	/*
	Adds a new string or audio entry to the backlog. If the new entry causes 
	the log to exceed the maximum size set in vngen_log_init, the oldest event's 
	data will be deleted.

	This script will automatically be run by loggable audio, text, and option 
	functions.

	argument0  = the log index, or list order for the new entry (integer/macro) (or 'auto' to queue for latest entry)
	argument1  = string or audio data to add to the log (string/sound)
	argument2  = the character name to associate with text (string) (optional, use no argument for none)
	argument3  = the default text font, subject to be overridden in vngen_log_draw (font) (optional, use no argument for none)
	argument4  = the color blending value for the top left text corner (color) (optional, use no argument for none)
	argument5  = the color blending value for the top right text corner (color) (optional, use no argument for none)
	argument6  = the color blending value for the bottom right text corner (color) (optional, use no argument for none)
	argument7  = the color blending value for the bottom left text corner (color) (optional, use no argument for none)
	argument8  = the color value for text shadow (color) (optional, use no argument for none)
	argument9  = the color value for text outline (color) (optional, use no argument for none)
	argument10 = sets font alignment to either fa_left (default), fa_center, or fa_right (constant)
	argument11 = sets the vertical space between lines of text, as a multiplier of font size (real) (optional, use no argument for global)

	Example usage: 
	   vngen_log_add(5, "John Doe: Hello, world!");
	   vngen_log_add(5, snd_hello);
	   vngen_log_add(auto, "Hello, world!", "John Doe", fnt_Arial, c_white, c_white, c_gray, c_gray, c_black, c_black, fa_left, 1);
	*/

	/* 
	INITIALIZATION 
	*/

	//Skip if log is disabled
	if (global.vg_log_max < 1) {
	   exit;
	}

	//Skip if log does not exist
	if (!ds_exists(global.ds_log, ds_type_grid)) {
	   exit;
	}


	/*
	ADD TO QUEUE
	*/

	//Use queue if auto index is specified
	if (argument[0] == auto) {
	   //Initialize default values to queue
	   var qindex = vngen_log_get_index(previous) + 1;
	   var qdata = argument[1];
	   var qname = "";
	   var qfont = fnt_default;
	   var qcol1 = c_white;
	   var qcol2 = c_white;
	   var qcol3 = c_white;
	   var qcol4 = c_white;
	   var qshadow = none;
	   var qoutline = none;
	   var qalign = fa_left;
	   var qheight = global.vg_lineheight_text;
   
	   //Get extra data, if supplied
	   if (argument_count > 2) {
		  //Name
		  qname = argument[2]; 
	  
		  //Text style
		  if (argument_count > 3) {
	         qfont = argument[3];
	         qcol1 = argument[4];
	         qcol2 = argument[5];
	         qcol3 = argument[6];
	         qcol4 = argument[7];
	         qshadow = argument[8];
	         qoutline = argument[9];
	         qalign = argument[10];
	         qheight = argument[11];
		  }
	   }
   
	   //Enqueue data
	   sys_queue_enqueue("log", qindex, qdata, qname, qfont, qcol1, qcol2, qcol3, qcol4, qshadow, qoutline, qalign, qheight);
	   exit;
	}


	/*
	INITIALIZE ADD TO LOG
	*/

	//Initialize temporary variables for adding backlog data
	var ds_log_text, ds_width, ds_xindex, ds_yindex;
	var ds_target = -1;

	//Get data structure dimensions
	var ds_width = ds_grid_width(global.ds_log);
	var ds_height = ds_grid_height(global.ds_log);

	//Get logged event to add data to
	for (ds_yindex = ds_grid_height(global.ds_log) - 1; ds_yindex >= 0; ds_yindex -= 1) {
	   if (global.ds_log[# prop._data_event, ds_yindex] == argument[0]) {
	      ds_target = ds_yindex;
	      break;
	   }
	}

	//If logged event does not exist, add it
	if (ds_target == -1) {
	   //Get the current number of log entries
	   ds_target = ds_height;

	   //Create new slot in data structure
	   ds_height += 1;
	   ds_grid_resize(global.ds_log, ds_width, ds_height);
   
	   //Initialize new slot data
	   global.ds_log[# prop._data_event, ds_target] = argument[0];
	   global.ds_log[# prop._data_text, ds_target] = ds_grid_create(140, 0); //ds_log_text
	   global.ds_log[# prop._data_audio, ds_target] = "";

	   //Sort the log by Event ID
	   ds_grid_sort(global.ds_log, prop._data_event, true);
	}


	/* 
	ADD TO LOG 
	*/

	//Add text to backlog
	if (is_string(argument[1])) {
	   //Get text data
	   ds_log_text = global.ds_log[# prop._data_text, ds_target];

	   //Get data sub-structure dimensions
	   ds_width = ds_grid_width(ds_log_text);

	   //Get the current number of log entries
	   ds_target = ds_grid_height(ds_log_text);

	   //Create new slot in data structure
	   ds_grid_resize(ds_log_text, ds_width, ds_target + 1);
   
	   //Set basic text properties
	   ds_log_text[# prop._name, ds_target] = "";                                  //Name
	   ds_log_text[# prop._col1, ds_target] = c_white;                             //Color 1
	   ds_log_text[# prop._col2, ds_target] = c_white;                             //Color 2
	   ds_log_text[# prop._col3, ds_target] = c_white;                             //Color 3
	   ds_log_text[# prop._col4, ds_target] = c_white;                             //Color 4
	   ds_log_text[# prop._surf, ds_target] = -1;                                  //Text surface
	   ds_log_text[# prop._txt_fnt, ds_target] = fnt_default;                      //Font
	   ds_log_text[# prop._txt_shadow, ds_target] = -4;                            //Shadow
	   ds_log_text[# prop._txt_outline, ds_target] = -4;                           //Outline
	   ds_log_text[# prop._txt_orig, ds_target] = argument[1];                     //Text
	   ds_log_text[# prop._txt_line_height, ds_target] = global.vg_lineheight_text; //Text lineheight
	   ds_log_text[# prop._txt_line_data, ds_target] = -1;                         //Linebreak data
	   ds_log_text[# prop._alpha, ds_target] = 1;                                  //Alpha
   
	   //Set extended text properties
	   if (argument_count > 2) {
	      //Set input speaker name, if any
	      ds_log_text[# prop._name, ds_target] = argument[2];                //Name
      
	      //Add name to string
	      ds_log_text[# prop._txt_orig, ds_target] = sys_log_get_style(argument[2]) + "\n" + argument[1];
   
	      //Set input text style properties, if any
	      if (argument_count > 3) {
	         ds_log_text[# prop._col1, ds_target] = argument[4];             //Color 1
	         ds_log_text[# prop._col2, ds_target] = argument[5];             //Color 2
	         ds_log_text[# prop._col3, ds_target] = argument[6];             //Color 3
	         ds_log_text[# prop._col4, ds_target] = argument[7];             //Color 4
	         ds_log_text[# prop._txt_fnt, ds_target] = argument[3];          //Font
	         ds_log_text[# prop._txt_shadow, ds_target] = argument[8];       //Shadow
	         ds_log_text[# prop._txt_outline, ds_target] = argument[9];      //Outline
	         ds_log_text[# prop._txt_halign, ds_target] = argument[10];      //Alignment
			 ds_log_text[# prop._txt_line_height, ds_target] = argument[11]; //Lineheight
	      }
	   }
   
	//Add audio to backlog
	} else {
	   if (audio_exists(argument[1])) {
	      global.ds_log[# prop._data_audio, ds_target] += audio_get_name(argument[1]) + "|";
	   }
	}


	/*
	PURGE OLD ENTRIES
	*/

	if (ds_height > global.vg_log_max) {
	   //Clear old text data
	   if (ds_exists(global.ds_log[# prop._data_text, 0], ds_type_grid)) {
	      //Get text data from main data structure
	      ds_log_text = global.ds_log[# prop._data_text, 0];
         
	      //Remove text data from memory
	      for (ds_xindex = 0; ds_xindex < ds_grid_height(ds_log_text); ds_xindex += 1) {
	         //Remove surfaces
	         if (surface_exists(ds_log_text[# prop._surf, ds_xindex])) {
	            surface_free(ds_log_text[# prop._surf, ds_xindex]);
	         }
         
	         //Remove linebreak data
	         if (ds_exists(ds_log_text[# prop._txt_line_data, ds_xindex], ds_type_list)) {
	            ds_list_destroy(ds_log_text[# prop._txt_line_data, ds_xindex]);
	         }
	      }
         
	      //Remove text data from memory
	      ds_grid_destroy(ds_log_text);
	   }
   
	   //Get data structure dimensions
	   ds_height = ds_grid_height(global.ds_log) - 1; 
	   ds_width = ds_grid_width(global.ds_log) - 1; 

	   //Remove event from data structure
	   if (ds_height > 0) {
	      //If not the last, preserve other data
	      ds_grid_set_grid_region(global.ds_log, global.ds_log, 0, 1, ds_width, ds_height, 0, 0);
	      ds_grid_resize(global.ds_log, ds_width + 1, max(1, ds_height));
	   } else {
	      //Otherwise clear data structure if last slot
	      ds_grid_destroy(global.ds_log);
	      global.ds_log = ds_grid_create(ds_width + 1, 0);     
	   }   
	}


}
