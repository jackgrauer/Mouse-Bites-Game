/// @function	sys_log_perform(entity, index, font, color);
/// @param		{integer}	entity
/// @param		{integer}	index
/// @param		{font}		font
/// @param		{color}		color
/// @author		Lucas Chasteen <lucas.chasteen@xgasoft.com>
/// @copyright	XGASOFT 2020, All Rights Reserved
function sys_log_perform(argument0, argument1, argument2, argument3) {

	/*
	==========================================================================
	SYSTEM FUNCTION: MODIFY AT YOUR OWN RISK!
	--------------------------------------------------------------------------
	  System functions are executed automatically by the engine and typically
	  should not be run manually by the user
	==========================================================================

	Renders text which has been pre-processed with sys_log_init.

	VNgen's handling of this functionality is highly tailored for its particular
	use-cases and is not intended for general use.

	argument0 = the data structure of the entity for which to perform text (integer)
	argument1 = the index of the row containing the target entity ID (integer)
	argument2 = override font to draw backlog text in (font) (optional, use 'inherit' for inherit)
	argument3 = override color to draw backlog text in (color) (optional, use 'inherit' for inherit)

	Example usage:
	   sys_log_perform(ds_log_text, ds_xindex);
	*/

	/*
	INITIALIZATION
	*/

	//Get the target data structure
	var ds_data = argument0;
	var ds_target = argument1;

	//Get the target drawing font
	var log_font = argument2;

	//Use stored font, if enabled
	if (argument2 == -2) {
	   log_font = ds_data[# prop._txt_fnt, ds_target];
	}

	//Set font
	draw_set_font(log_font);

	//Get pre-processed string
	var text = ds_data[# prop._txt, ds_target];

	//Intialize temp variables for drawing text
	var char, height, height_previous, markup, markup_index, markup_col1, markup_col2, markup_col3, markup_col4, markup_fnt, space, value, value_index, word;
	var char_height = (string_height("W")*ds_data[# prop._txt_line_height, ds_target]);
	var char_count = string_length(text);
	var char_index = 0;
	var char_x = 0;
	var char_y = ds_data[# prop._y, ds_target];
	var char_cat = "";

	//Initialize text colors
	if (argument3 != -2) {
	   //Use override colors, if enabled
	   var col1 = argument3;
	   var col2 = argument3;
	   var col3 = argument3;
	   var col4 = argument3;
	   var shadow = -4;
	   var outline = -4;
	} else {
	   //Otherwise use stored colors
	   var col1 = ds_data[# prop._col1, ds_target];
	   var col2 = ds_data[# prop._col2, ds_target];
	   var col3 = ds_data[# prop._col3, ds_target];
	   var col4 = ds_data[# prop._col4, ds_target];
	   var shadow = ds_data[# prop._txt_shadow, ds_target];
	   var outline = ds_data[# prop._txt_outline, ds_target];
	}


	/*
	DRAW TEXT
	*/

	//Get line starting position based on paragraph alignment
	char_x = sys_log_get_xoffset(ds_data, ds_target, 0);

	//Draw surface contents
	if (global.vg_renderlevel < 2) {
	   surface_set_target(ds_data[# prop._surf, ds_target]);

	   //Clear surface before drawing
	   draw_clear_alpha(c_black, 0);  
	}
              
	//Draw text to surface
	while (char_index < char_count) {
	   //Increment character index
	   char_index += 1;    

	   //Get character to draw
	   char = string_char_at(text, char_index);
   
	   //Process markup
	   if (char == "[") {
	      //Interpret text literally if escape character is used
	      if (string_char_at(text, char_index - 1) != "^") {
	         //Otherwise begin checking for markup at the current location
	         markup_index = char_index;

	         //Get markup start
	         markup = string_delete(text, 1, markup_index);

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
	         if (argument2 == -2) {
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
                  
	                  //Offset vertical position to align to bottom
	                  char_y += (height_previous - height)*0.8;
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
                  
	         //If markup type is "color"...
	         if (argument3 == -2) {
	            if (markup == "color") {
	               //Remove spaces between values, if any
	               value = string_replace_all(value, " ", "");
            
	               //Get the input color(s)
	               value_index = string_count(",", value);
                  
	               //Set color gradient based on the number of input colors
	               if (value_index > 0) {
	                  //Two-color gradient
	                  if (value_index == 1) {
	                     //Get first color
	                     value_index = string_pos(",", value);
                        
	                     //Set first color
	                     markup_col1 = make_color_hex_to_rgb(string_copy(value, 1, value_index));
	                     markup_col2 = markup_col1;
                        
	                     //Set second color
	                     markup_col3 = make_color_hex_to_rgb(string_delete(value, 1, value_index + 1));
	                     markup_col4 = markup_col3;
	                  } else {
	                     //Three-color gradient
	                     if (value_index == 2) {
	                        //Get first color
	                        value_index = string_pos(",", value);
                        
	                        //Set first color
	                        markup_col1 = make_color_hex_to_rgb(string_copy(value, 1, value_index));
                        
	                        //Get second color
	                        value = string_delete(value, 1, value_index + 1);
	                        value_index = string_pos(",", value);
                           
	                        //Set second color
	                        markup_col2 = make_color_hex_to_rgb(string_copy(value, 1, value_index));
                           
	                        //Set third color
	                        markup_col3 = make_color_hex_to_rgb(string_delete(value, 1, value_index + 1));
	                        markup_col4 = markup_col3;
	                     } else {
	                        //Four-color gradient
	                        if (value_index == 3) {
	                           //Get first color
	                           value_index = string_pos(",", value);
                        
	                           //Set first color
	                           markup_col1 = make_color_hex_to_rgb(string_copy(value, 1, value_index));
                        
	                           //Get second color
	                           value = string_delete(value, 1, value_index + 1);
	                           value_index = string_pos(",", value);
                           
	                           //Set second color
	                           markup_col2 = make_color_hex_to_rgb(string_copy(value, 1, value_index));
                           
	                           //Get third color
	                           value = string_delete(value, 1, value_index + 1);
	                           value_index = string_pos(",", value);
                              
	                           //Set third color
	                           markup_col3 = make_color_hex_to_rgb(string_copy(value, 1, value_index));
                              
	                           //Set fourth color
	                           markup_col4 = make_color_hex_to_rgb(string_delete(value, 1, value_index + 1));
	                        }
	                     }
	                  }
	               } else {
	                  //Otherwise use single color
	                  markup_col1 = make_color_hex_to_rgb(value);
	                  markup_col2 = markup_col1;
	                  markup_col3 = markup_col1;
	                  markup_col4 = markup_col1;
	               }
                  
	               //Set colors
	               col1 = markup_col1;
	               col2 = markup_col2;
	               col3 = markup_col3;
	               col4 = markup_col4;
	            }
            
	            //If markup is "end color..."
	            if (markup == "/color") {
	               //Reset colors    
	               col1 = ds_data[# prop._col1, ds_target];
	               col2 = ds_data[# prop._col2, ds_target];
	               col3 = ds_data[# prop._col3, ds_target];
	               col4 = ds_data[# prop._col4, ds_target];
	            }
            
	            //If markup is "shadow"
	            if (markup == "shadow") {
	               //Set shadow color
	               shadow = make_color_hex_to_rgb(value);
	            }
            
	            //If markup is "end shadow"
	            if (markup == "/shadow") {
	               //Reset shadow color
	               shadow = ds_data[# prop._txt_shadow, ds_target];
	            }
            
	            //If markup is "outline"
	            if (markup == "outline") {
	               //Set outline color
	               outline = make_color_hex_to_rgb(value);
	            }
            
	            //If markup is "end outline"
	            if (markup == "/outline") {
	               //Reset outline color
	               outline = ds_data[# prop._txt_outline, ds_target];
	            }
	         }

	         //Continue processing after markup
	         continue;
	      }    
	   }

	   //Primary escape character
	   if (char == "\\") {
	      //Word wrap on newline
	      if (string_char_at(text, char_index + 1) == "n") {
	         //Reset horizontal text position
	         char_x = sys_log_get_xoffset(ds_data, ds_target, char_index);
   
	         //Increment vertical text position
	         char_y += char_height;
   
	         //Skip next character
	         char_index += 1;
         
	         //Add linebreak to surfaceless string if renderlevel does not support surfaces
	         if (global.vg_renderlevel > 1) {
	            char_cat = char_cat + "\\n";
	         }
         
	         //Skip drawing newline characters
	         continue;
	      }
	   }      
   
	   //Secondary escape character
	   if (char == "^") {
	      //Interpret markup literally if escaped
	      if (string_char_at(text, char_index + 1) == "[") {                     
	         //Skip drawing escape character
	         continue;
	      }
	   }

	   //Draw logged text to surface, if supported
	   if (global.vg_renderlevel < 2) {
	      //Draw text shadow, if any
	      if (shadow >= 0) {
	         draw_set_color(shadow);
	         draw_text(char_x + (font_get_size(log_font)*0.125), char_y + (font_get_size(log_font)*0.125), char);                        
	         draw_set_color(c_white);
	      }
      
	      //Draw text outline, if any
	      if (outline >= 0) {
	         draw_set_color(outline);
	         draw_text(char_x - 1, char_y - 1, char); 
	         draw_text(char_x + 1, char_y - 1, char); 
	         draw_text(char_x - 1, char_y + 1, char); 
	         draw_text(char_x + 1, char_y + 1, char); 
	         draw_set_color(c_white);
	      }
   
	      //Draw text
	      draw_text_color(char_x, char_y, char, col1, col2, col3, col4, 1);
	   }
 
	   //Increment horizontal text position
	   char_x += string_width(char);  
   
	   //Get parsed string if renderlevel does not support surfaces
	   if (global.vg_renderlevel > 1) {
	      char_cat = char_cat + char;
      
	      //Get final string when processing is complete
	      if (char_index >= char_count) {
	         ds_data[# prop._txt, ds_target] = string_replace_all(char_cat, "\\n", "\n");
	      }
	   }
	}    

	//Reset drawing font
	draw_set_font(fnt_default);

	//End drawing to surface
	if (global.vg_renderlevel < 2) {
	   surface_reset_target();
	}



}
