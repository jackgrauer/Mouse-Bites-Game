/// @function	sys_text_init(entity, index, text, name, halign, linebreak, lineheight, font, col1, col2, col3, col4, shadow, outline, speed);
/// @param		{integer}	entity
/// @param		{integer}	index
/// @param		{string}	text
/// @param		{string}	name
/// @param		{constant}	halign
/// @param		{real}		linebreak
/// @param		{real}		lineheight
/// @param		{font}		font
/// @param		{color}		col1
/// @param		{color}		col2
/// @param		{color}		col3
/// @param		{color}		col4
/// @param		{color}		shadow
/// @param		{color}		outline
/// @param		{real}		speed
/// @author		Lucas Chasteen <lucas.chasteen@xgasoft.com>
/// @copyright	XGASOFT 2020, All Rights Reserved
function sys_text_init(argument0, argument1, argument2, argument3, argument4, argument5, argument6, argument7, argument8, argument9, argument10, argument11, argument12, argument13, argument14) {

	/*
	==========================================================================
	SYSTEM FUNCTION: MODIFY AT YOUR OWN RISK!
	--------------------------------------------------------------------------
	  System functions are executed automatically by the engine and typically
	  should not be run manually by the user
	==========================================================================

	Pre-processes text for rendering with sys_text_perform, calculating texture
	dimensions and creating a surface where text can be drawn. Also returns the
	final surface when complete, which can be referenced for size.

	VNgen's handling of this functionality is highly tailored for its particular
	use-cases and is not intended for general use.

	argument0  = the data structure for the entity to apply transition to (integer)
	argument1  = the index of the row containing the target entity ID (integer)
	argument2  = the text string to process (string)
	argument3  = the speaker name associated with the text, used to check for style inheritance (string)
	argument4  = the horizontal alignment setting, as a constant (constant)
	argument5  = the width in pixels before text is wrapped into a new line (real)
	argument6  = the distance between lines as a multiplier of the height of a single line (real)
	argument7  = the default text font, subject to be overridden in markup (font) (optional, use 'previous' for no change or 'inherit' for inherit)
	argument8  = the color blending value for the text top-left corner (color) (optional, use 'previous' for no change or 'inherit' for inherit)
	argument9  = the color blending value for the text top-right corner (color) (optional, use 'previous' for no change or 'inherit' for inherit)
	argument10 = the color blending value for the text bottom-right corner (color) (optional, use 'previous' for no change or 'inherit' for inherit)
	argument11 = the color blending value for the text bottom_left corner (color) (optional, use 'previous' for no change or 'inherit' for inherit)
	argument12 = the color value for the text shadow (color) (optional, use 'previous' for no change, 'inherit' for inherit, or 'none' for none)
	argument13 = the color value for the text outline (color) (optional, use 'previous' for no change, 'inherit' for inherit, or 'none' for none)
	argument14 = the speed at which text appears on-screen, as a value in characters per-second (real)

	Example usage:
	   sys_text_init(ds_data, ds_target, str_text, str_name, fa_left, 1200, 1.5, text_fnt, text_c1, text_c2, text_c3, text_c4, text_shadow, text_outline, 25);
	*/

	/*
	INITIALIZATION
	*/

	//Get the target data structure
	var ds_data = argument0;
	var ds_target = argument1;

	//Remove speaker name from text, if any
	if (string_count("||", argument2) > 0) {
	   var text_init = string_delete(argument2, 1, string_pos("||", argument2) + 1);
	} else {
	   //Otherwise use default text
	   var text_init = argument2;
	}

	//Replace linebreaks with literals
	text_init = string_replace_all(text_init, "\n", "\\n");

	//Disallow empty input string
	if (string_length(text_init) == 0) {
	   text_init = " ";
	}


	/*
	PROCESS TEXT
	*/

	//Get text style
	var style = sys_text_style_init(ds_data, ds_target, argument3, argument7, argument8, argument9, argument10, argument11, argument12, argument13);
   
	//Get the original string for processing, minus speaker markup
	var text = text_init;
   
	//Initialize temporary variables for calculating texture dimensions
	draw_set_font(style[? "fnt"]);
	var char, height, height_previous, markup, markup_index, markup_fnt, surf_height, value, value_index, word;
	var char_count = string_length(text_init);
	var char_height = (string_height("W")*argument6);
	var char_index = 0;
	var char_x = 0;
	var char_y = 0;
	var char_yoffset = 0;
	var char_offset = 0;
	var markup_exit = false;
	var surf_width = argument5;
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
            
	         if (ds_data == ds_text) {
	            //If markup is "font"...
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
	                     char_height = (height*argument6);
	                  }
	               }
	            }
                           
	            //If markup is "end font..."
	            if (markup == "/font") {
	               //Get current font height to compare before setting new font
	               height_previous = string_height("W");
                                 
	               //Reset font
	               draw_set_font(style[? "fnt"]);
                                 
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
	            markup_exit = true;
	            break;
	         }
	      }
      
	      //Skip inserting linebreak if space is inside markup
	      if (markup_exit == true) {
	         markup_exit = false;
	         continue;
	      }
               
	      //Insert linebreak, if necessary
	      if (char_x + string_width(word) > argument5) {
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


	/*
	PROPERTIES
	*/
  
	//Set final text properties
	ds_data[# prop._txt, ds_target] = text;                                     //Text string
	ds_data[# prop._txt_orig, ds_target] = text_init;                           //Unmodified string
	ds_data[# prop._surf, ds_target] = surface_create(surf_width, surf_height); //Surface   
	ds_data[# prop._txt_halign, ds_target] = argument4;                         //Horizontal alignment
	ds_data[# prop._txt_line_break, ds_target] = argument5;                     //Linebreak
	ds_data[# prop._txt_line_height, ds_target] = argument6;                    //Lineheight
	ds_data[# prop._char_height, ds_target] = string_height("W");               //Character height
	ds_data[# prop._char_x, ds_target] = 0;                                     //Character X
	ds_data[# prop._char_y, ds_target] = char_yoffset;                          //Character Y
	ds_data[# prop._index, ds_target] = 0;                                      //Character index 
	ds_data[# prop._number, ds_target] = string_length(text);                   //Character number
	ds_data[# prop._pause, ds_target] = 0;                                      //Character tracker  
	ds_data[# prop._txt_complete, ds_target] = false;                           //Text complete state
	ds_data[# prop._redraw, ds_target] = 0;                                     //Redraw index
	ds_data[# prop._txt_fnt, ds_target] = style[? "fnt"];                       //Font
	ds_data[# prop._col1, ds_target] = style[? "col1"];                         //Text color1
	ds_data[# prop._col2, ds_target] = style[? "col2"];                         //Text color2
	ds_data[# prop._col3, ds_target] = style[? "col3"];                         //Text color3
	ds_data[# prop._col4, ds_target] = style[? "col4"];                         //Text color4
	ds_data[# prop._txt_shadow, ds_target] = style[? "shadow"];                 //Shadow
	ds_data[# prop._txt_outline, ds_target] = style[? "outline"];               //Outline
	ds_data[# prop._speed, ds_target] = argument14;                             //Typewriter effect speed

	//Set markup default values
	if (ds_data == ds_text) {
	   ds_data[# prop._mark_fnt, ds_target] = -1;               //Markup font
	   ds_data[# prop._mark_yoffset, ds_target] = char_yoffset; //Markup font vertical offset
	   ds_data[# prop._mark_shadow, ds_target] = -4;            //Markup shadow
	   ds_data[# prop._mark_outline, ds_target] = -4;           //Markup outline
	   ds_data[# prop._mark_col1, ds_target] = -1;              //Markup color1
	   ds_data[# prop._mark_col2, ds_target] = -1;              //Markup color2
	   ds_data[# prop._mark_col3, ds_target] = -1;              //Markup color3
	   ds_data[# prop._mark_col4, ds_target] = -1;              //Markup color4
	   ds_data[# prop._mark_spd, ds_target] = -1;               //Markup speed multiplier
	   ds_data[# prop._mark_time, ds_target] = 0;               //Markup pause time
	   ds_data[# prop._mark_pause, ds_target] = 0;              //Markup pause total
	}

	//Clear temporary style data
	ds_map_destroy(style);
   
	//Reset font, we're done processing!
	draw_set_font(fnt_default);

	//Return the final surface
	return ds_data[# prop._surf, ds_target];


}
