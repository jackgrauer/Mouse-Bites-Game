/// @function	sys_log_init(entity, index, linebreak, font);
/// @param		{integer}	entity
/// @param		{integer}	index
/// @param		{real}		linebreak
/// @param		{font}		font
/// @author		Lucas Chasteen <lucas.chasteen@xgasoft.com>
/// @copyright	XGASOFT 2020, All Rights Reserved
function sys_log_init(argument0, argument1, argument2, argument3) {

	/*
	==========================================================================
	SYSTEM FUNCTION: MODIFY AT YOUR OWN RISK!
	--------------------------------------------------------------------------
	  System functions are executed automatically by the engine and typically
	  should not be run manually by the user
	==========================================================================

	Pre-processes log text for rendering with sys_log_perform, calculating texture
	dimensions and creating a surface where text can be drawn. Also returns the
	final surface when complete, which can be referenced for size.

	VNgen's handling of this functionality is highly tailored for its particular
	use-cases and is not intended for general use.

	argument0 = the data structure for the entity to apply transition to (integer)
	argument1 = the index of the row containing the target entity ID (integer)
	argument2 = the width in pixels before text is wrapped into a new line (real)
	argument3 = the override text font (font) (optional, use 'inherit' for inherit)

	Example usage:
	   sys_log_init(ds_log_text, ds_xindex, 1200, inherit);
	*/

	/*
	INITIALIZATION
	*/

	//Get the target data structure
	var ds_data = argument0;
	var ds_target = argument1;

	//Skip processing if text has already been processed
	if (surface_exists(ds_data[# prop._surf, ds_target])) {
	   return -1;
	}

	//Get the original string for processing
	var text_init = ds_data[# prop._txt_orig, ds_target];

	//Convert escape characters to VNgen markup
	text_init = string_replace_all(text_init, "\n", "\\n");

	//Disallow empty input string
	if (string_length(text_init) == 0) {
	   text_init = " ";
	}

	//Get the original string for processing, adjusted for speaker name
	var text = text_init;


	/*
	PROCESS TEXT
	*/

	//Get the target drawing font
	var log_font = argument3;
   
	//Use stored font, if enabled
	if (argument3 == -2) {
	   log_font = ds_data[# prop._txt_fnt, ds_target];
	}

	//Set font
	draw_set_font(log_font);
   
	//Initialize temporary variables for calculating texture dimensions
	var char, height, height_previous, markup, markup_index, markup_fnt, surf_height, value, value_index, word;
	var char_count = string_length(text_init);
	var char_height = (string_height("W")*ds_data[# prop._txt_line_height, ds_target]);
	var char_index = 0;
	var char_x = 0;
	var char_y = 0;
	var char_yoffset = 0;
	var char_offset = 0;
	var surf_width = argument2;
	var width = 0;

	//Initialize recording linebreaks for each line
	if (!ds_exists(ds_data[# prop._txt_line_data, ds_target], ds_type_list)) {
	   ds_data[# prop._txt_line_data, ds_target] = ds_list_create();
	}

	//Get linebreak data structure
	var ds_line = ds_data[# prop._txt_line_data, ds_target];
	var line_count = 0;
   
	//Process text to get linebreaks and texture dimesions
	while (char_index < char_count) {
	   //Increment character index
	   char_index += 1;
      
	   //Get the current character of the string
	   char = string_char_at(text_init, char_index);
      
	   //Process markup
	   if (char == "[") {
	      //Interpret text literally if escape character is used
	      if (string_char_at(text_init, char_index - 1) != "^") {
	         //Otherwise begin checking for markup at the current location
	         markup_index = char_index;
            
	         //Get markup start
	         markup = string_delete(text_init, 1, markup_index);
            
	         //Get markup end
	         value_index = string_pos("]", markup);
            
	         //Get the setting defined in markup
	         markup = string_copy(markup, 1, value_index - 1);
	         markup_index = string_pos("=", markup);
            
	         //Get the value defined in markup
	         value = string_copy(markup, markup_index + 1, value_index - markup_index - 1);
            
	         //Finish parsing markup
	         if (markup_index > 1) {
	            markup = string_copy(markup, 1, markup_index - 1);
	         }
         
	         //Skip drawing markup
	         char_index += value_index;
            
	         /* MARKUP TYPES */
            
	         //If markup is "font"...
	         if (argument3 == -2) {
	            if (markup == "font") {
	               //Get the font to draw
	               markup_fnt = asset_get_index(value);
			   
				   //Get font from variable if font asset does not exist
				   if (markup_fnt == -1) {
					  //Get global variable
					  if (string_count("global.", value) > 0) {
						 if (variable_global_exists(string_replace(value, "global.", ""))) {
						    markup_fnt = variable_global_get(string_replace(value, "global.", ""));
						 }
					  } else {
						 //Otherwise get local variable
						 if (variable_instance_exists(id, value)) {
							markup_fnt = variable_instance_get(id, value);
						 }
					  }
				   }
                  
	               //If font exists, set it
	               if (font_exists(markup_fnt)) {
	                  //Get current font height to compare before setting new font
	                  height_previous = string_height("W");
                     
	                  //Set new font
	                  draw_set_font(markup_fnt);
                     
	                  //Get new font height
	                  height = string_height("W");
                     
	                  //Offset vertical position to align to bottom of text
	                  char_y += (height_previous - height)*0.8;
                     
	                  //Disallow large fonts exceeding texture dimensions
	                  if (char_y < 0) {
	                     //Set initial drawing offset
	                     char_yoffset = abs(char_y);
                        
	                     //Clamp drawing coordinates
	                     char_y = 0;
	                  }
                     
	                  //Use largest font for lineheight
	                  if (height > char_height) {
	                     char_height = (height*ds_data[# prop._txt_line_height, ds_target]);
	                  }
	               }
	            }
                           
	            //If markup is "end font..."
	            if (markup == "/font") {
	               //Get current font height to compare before setting new font
	               height_previous = string_height("W");
                                 
	               //Reset font
	               draw_set_font(log_font);
                                 
	               //Get new font height
	               height = string_height("W");
                                 
	               //Offset vertical position to align to bottom
	               char_y += (height_previous - height)*0.8;
	            }
	         }
         
	         //Continue processing after markup
	         continue;
	      }
	   }
      
	   //Primary escape character
	   if (char == "\\") {
	      //Word wrap on newline
	      if (string_char_at(text_init, char_index + 1) == "n") {
	         //Record line width
	         ds_line[| line_count] = char_x;
         
	         //Increase line count
	         line_count += 1;
         
	         //Reset horizontal text position
	         char_x = 0;
                  
	         //Increment vertical text position
	         char_y += char_height;
                  
	         //Skip next character
	         char_index += 1;
                     
	         //Skip drawing newline characters
	         continue;
	      }
	   }
         
	   //Secondary escape character
	   if (char == "^") {
	      //Interpret markup literally
	      if (string_char_at(text_init, char_index + 1) == "[") {
	         //Skip drawing escape character
	         continue;
	      }
	   }
      
	   //Increment horizontal text position
	   char_x += string_width(char);
   
	   //Get the width of the longest line
	   if (char_x > width) {
	      width = char_x;
	   }
         
	   //If linebreak is impossible in the given space, expand text surface
	   if (char_x > surf_width) {
	      surf_width = char_x + string_width(char);
	   }
      
	   //Check for linebreak on space
	   if (char == " ") {
	      //Get the next word to check if linebreak is required
	      word = string_delete(text_init, 1, char_index);
	      space = string_pos(" ", word);
	      if (space > 0) {
	         word = string_delete(word, space, string_length(word) - space);
	      }
      
	      //Remove markup from word, if any
	      while (string_count("[", word) > string_count("^[", word)) {
	         markup_index = string_pos("[", word);
	         value_index = string_pos("]", word);

	         if (value_index > 0) {
	            if (string_char_at(word, markup_index - 1) != "^") {
	               word = string_delete(word, markup_index, value_index - markup_index + 1);
	            }
	         } else {
	            //Skip removal if markup is malformed or incomplete
	            break;
	         }
	      }
               
	      //Insert linebreak, if necessary
	      if (char_x + string_width(word) > argument2) {
	         //Record line width
	         ds_line[| line_count] = char_x;
         
	         //Increase line count
	         line_count += 1;
         
	         //Insert linebreak in string
	         text = string_insert("\\n", text, char_index + char_offset + 1);
            
	         //Increase the number of linebreak characters added
	         char_offset += 2;
            
	         //Reset horizontal text position
	         char_x = 0;
                  
	         //Increment vertical text position
	         char_y += char_height;
	      }
	   }
	}

	//Record final line width
	ds_line[| line_count] = char_x;
   
	//Get final texture size
	surf_width = min(width + string_width(char), surf_width);
	surf_height = char_y + string_height("W");
   
	//Reset font, we're done processing!
	draw_set_font(fnt_default);


	/*
	PROPERTIES
	*/
  
	//Set final log entry properties
	ds_data[# prop._height, ds_target] = surf_height;                              //Entry height
	ds_data[# prop._txt, ds_target] = text;                                        //Text

	//Return the final surface
	if (global.vg_renderlevel < 2) {
	   ds_data[# prop._surf, ds_target] = surface_create(surf_width, surf_height); //Surface   
	   return ds_data[# prop._surf, ds_target];
	} else {
	   //Do not create surface, if unsupported
	   return -1;
	}


}
