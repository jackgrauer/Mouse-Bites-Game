/// @function	sys_cmd_draw(x, y, width, height, font, col1, col2);
/// @param		{real}	x
/// @param		{real}	y
/// @param		{real}	width
/// @param		{real}	height
/// @param		{font}	font
/// @param		{color}	col1
/// @param		{color}	col2
/// @author		Lucas Chasteen <lucas.chasteen@xgasoft.com>
/// @copyright	XGASOFT 2020, All Rights Reserved
function sys_cmd_draw(argument0, argument1, argument2, argument3, argument4, argument5, argument6) {

	/*
	Draws the command console with the specified dimensions, if visible.

	argument0 = the horizontal position to draw the console (real)
	argument1 = the vertical position to draw the console (real)
	argument2 = sets the console width in pixels (real)
	argument3 = sets the console height in pixels (real)
	argument4 = sets the font to draw console output in (font)
	argument5 = sets the color to draw console background in (color)
	argument6 = sets the color to draw console foreground in (color)

	Example usage:
	   sys_cmd_draw(view_xview[0], view_yview[0] + view_hview[0] - 32, view_wview[0], 32, fnt_console, c_black, c_lime);
	*/

	/*
	VISIBILITY
	*/

	if (global.cmd_visible == false) {  
	   //Fade command console out, if hidden
	   if (global.cmd_alpha > 0) {
	      global.cmd_alpha -= 0.1*time_offset;
      
	      //Slide console down
	      global.cmd_y = argument3 - min(argument3, argument3*global.cmd_alpha);
      
	      //Disallow exceeding minimum value
	      if (global.cmd_alpha < 0) {
	         global.cmd_alpha = 0;
	      }
	   }
	} else {
	   //fade command console in, if shown
	   if (global.cmd_alpha < 1) {
	      global.cmd_alpha += 0.1*time_offset;
      
	      //Slide console up
	      global.cmd_y = argument3 - min(argument3, argument3*global.cmd_alpha);
      
	      //Disallow exceeding maximum value
	      if (global.cmd_alpha > 1) {
	         global.cmd_alpha = 1;
	      }
	   }
	}


	/*
	COMMAND CONSOLE
	*/

	//Draw developer console, if visible
	if (global.cmd_alpha > 0) {
	   //Ensure console surface exists
	   if (!surface_exists(global.cmd_surf)) {
	      global.cmd_surf = surface_create(argument2, argument3);
	      global.cmd_refresh = true;
	   } else {
	      //Resize surface if resolution has changed
	      if (surface_get_width(global.cmd_surf) != argument2) or (surface_get_height(global.cmd_surf) != argument3) {
	         surface_resize(global.cmd_surf, argument2, argument3);
	         global.cmd_refresh = true;
	      }
	   }
   
	   //Draw console contents to surface
	   if (global.cmd_refresh == true) {
	      //Set drawing properties
	      draw_set_font(argument4);
   
	      //Get font size for calculating margins
	      var fnt_size = font_get_size(argument4);
   
	      //Set console text content
	      if (string_length(global.cmd_input_result) > 0) {
	         //Display result text after command has been made
	         var input = global.cmd_input_result;
	      } else {
	         //Display default text if no other input exists
	         if (string_length(global.cmd_input) == 0) {
	            var input = global.cmd_input_default;
	         } else {
	            //Otherwise display input text
	            var input = global.cmd_input;
	         }
	      }
   
	      //Draw console contents to surface
	      surface_set_target(global.cmd_surf);
   
	      //Draw console background
	      draw_clear(argument5);
   
	      //Draw console decorations
	      draw_set_color(argument6);
	      draw_line(0, 0, argument2, 0);
   
	      //Get cursor position in pixels
	      global.cmd_x = string_width("> " + string_copy(input, 1, global.cmd_input_index - 1));

	      //Draw console text
	      draw_text((fnt_size*1.5) + min(0, argument2 - global.cmd_x - (fnt_size*5)), (argument3*0.25), "> " + input);
	      draw_text((fnt_size*1.5) + min(0, argument2 - global.cmd_x - (fnt_size*5)) + global.cmd_x, (argument3*0.25) + 1, "_");
   
	      //Reset surface target
	      surface_reset_target();
   
	      //Reset drawing properties, we're done!
	      draw_set_font(fnt_default);
	      draw_set_color(c_white);
   
	      //End console refresh
	      global.cmd_refresh = false;
	   }
   
	   //Draw console
	   draw_set_alpha(global.cmd_alpha);
	   draw_surface(global.cmd_surf, argument0, argument1 + global.cmd_y);
	   draw_set_alpha(1);
	}


}
