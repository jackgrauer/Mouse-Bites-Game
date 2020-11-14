/// @function	vngen_text_modify_ext(id, x, y, z, xscale, yscale, rot, col1, col2, col3, col4, shadow, outline, alpha, duration, ease);
/// @param		{real|string|macro}	id
/// @param		{real}				x
/// @param		{real}				y
/// @param		{real}				z
/// @param		{real}				xscale
/// @param		{real}				yscale
/// @param		{real}				rot
/// @param		{color}				col1
/// @param		{color}				col2
/// @param		{color}				col3
/// @param		{color}				col4
/// @param		{color}				shadow
/// @param		{color}				outline
/// @param		{real}				alpha
/// @param		{real}				duration
/// @param		{integer|macro}		ease
/// @author		Lucas Chasteen <lucas.chasteen@xgasoft.com>
/// @copyright	XGASOFT 2020, All Rights Reserved
function vngen_text_modify_ext(argument0, argument1, argument2, argument3, argument4, argument5, argument6, argument7, argument8, argument9, argument10, argument11, argument12, argument13, argument14, argument15) {

	/*
	Applies a number of advanced customizations to the specified text. As with other
	actions, modifications will persist until the text is removed or another
	modification is performed.

	Unlike animations, mods are permanent changes performed once using absolute values. 

	argument0  = identifier of the text to be modified (real or string) (or keyword 'all' for all)
	argument1  = the new horizontal position to display the text (real)
	argument2  = the new vertical position to display the text (real)
	argument3  = the new drawing depth to display the text, relative to other text only (real)
	argument4  = the new horizontal scale multiplier to display the text (real)
	argument5  = the new vertical scale multiplier to display the text (real)
	argument6  = the new rotation value to apply to the text, in degrees (real)
	argument7  = the new color blending value for the top left corner (color) (optional, use 'previous' for no change or 'inherit' for inherit)
	argument8  = the new color blending value for the top right corner (color) (optional, use 'previous' for no change or 'inherit' for inherit)
	argument9  = the new color blending value for the bottom right corner (color) (optional, use 'previous' for no change or 'inherit' for inherit)
	argument10 = the new color blending value for the bottom left corner (color) (optional, use 'previous' for no change or 'inherit' for inherit)
	argument11 = the new color value for text shadow (color) (optional, use 'previous' for no change, 'inherit' for inherit, or 'none' for none)
	argument12 = the new color value for text outline (color) (optional, use 'previous' for no change, 'inherit' for inherit, or 'none' for none)
	argument13 = the new alpha transparency value to display the text in (real) (0-1)
	argument14 = sets the length of the modification transition, in seconds (real)
	argument15 = sets the animation easing method (see interp for available modes) (integer) (can also use true/false)

	Example usage:
	   vngen_event() {
	      vngen_text_modify_ext("text", 0, view_hview[0] - 256, -1, 1, 1, 0, c_white, c_white, c_white, c_white, c_black, c_black, 1, 2, true);
	   }
	*/

	/*
	INITIALIZATION
	*/

	//Enable action, if active
	switch (sys_action_init()) {
	   //Exit if event is inactive
	   case false: {
	      exit;
	   }
      
	   //Initialize action if active
	   case true: {
	      //Get text slot
	      if (argument0 == all) {
	         //Modify all text, if enabled
	         var ds_target = sys_grid_last(ds_text);
	         var ds_yindex = 0;
	      } else {
	         //Otherwise get single text to modify
	         var ds_target = vngen_get_index(argument0, vngen_type_text);
	         var ds_yindex = ds_target;
	      }
         
	      //If the target text exists...
	      if (!is_undefined(ds_target)) {     
	         while (ds_target >= ds_yindex) {          
	            //Backup original values to temp value slots
	            ds_text[# prop._tmp_x, ds_target] = ds_text[# prop._x, ds_target];                 //X
	            ds_text[# prop._tmp_y, ds_target] = ds_text[# prop._y, ds_target];                 //Y
	            ds_text[# prop._tmp_xscale, ds_target] = ds_text[# prop._xscale, ds_target];       //X scale
	            ds_text[# prop._tmp_yscale, ds_target] = ds_text[# prop._yscale, ds_target];       //Y scale
	            ds_text[# prop._tmp_rot, ds_target] = ds_text[# prop._rot, ds_target];             //Rotation
	            ds_text[# prop._tmp_col1, ds_target] = ds_text[# prop._col1, ds_target];           //Color1
	            ds_text[# prop._tmp_col2, ds_target] = ds_text[# prop._col2, ds_target];           //Color2
	            ds_text[# prop._tmp_col3, ds_target] = ds_text[# prop._col3, ds_target];           //Color3
	            ds_text[# prop._tmp_col4, ds_target] = ds_text[# prop._col4, ds_target];           //Color4
	            ds_text[# prop._tmp_alpha, ds_target] = ds_text[# prop._alpha, ds_target];         //Alpha
	            ds_text[# prop._tmp_shadow, ds_target] = ds_text[# prop._txt_shadow, ds_target];   //Shadow
	            ds_text[# prop._tmp_outline, ds_target] = ds_text[# prop._txt_outline, ds_target]; //Outline
                        
	            //Set transition time
	            if (argument14 > 0) {
	               ds_text[# prop._time, ds_target] = 0;   //Transition time
	            } else {
	               ds_text[# prop._time, ds_target] = -1;  //Transition time
	            }
            
	            //Sort data structure by Z depth
	            ds_text[# prop._z, ds_target] = argument3; //Z
	            if (argument0 != all) {
	               ds_grid_sort(ds_text, prop._z, false);      
	            }
            
	            //Continue to next text, if any
	            ds_target -= 1;
	         }   
	      } else {
	         //Skip action if text does not exist
	         sys_action_term();
	         exit;
	      }
	   }  
	}


	/*
	DATA MANAGEMENT
	*/

	//Skip action if engine is paused
	if (global.vg_pause == true) {
	   exit;
	}

	//Get text slot
	if (argument0 == all) {
	   //Modify all text, if enabled
	   var ds_target = sys_grid_last(ds_text);
	   var ds_yindex = 0;
	} else {
	   //Otherwise get single text to modify
	   var ds_target = vngen_get_index(argument0, vngen_type_text);
	   var ds_yindex = ds_target;
	}

	//Skip action if target text does not exist
	if (is_undefined(ds_target)) {
	   exit;
	}

	//Get text style
	while (ds_target >= ds_yindex) {
	   var style = sys_text_style_init(ds_text, ds_target, ds_text[# prop._name, ds_target], previous, argument7, argument8, argument9, argument10, argument11, argument12);
	   var text_c1 = style[? "col1"];
	   var text_c2 = style[? "col2"];
	   var text_c3 = style[? "col3"];
	   var text_c4 = style[? "col4"];
	   var text_shadow = style[? "shadow"];
	   var text_outline = style[? "outline"];
	   ds_map_destroy(style);
   
   
	   /*
	   PERFORM MODIFICATIONS
	   */
   
	   //Increment transition time
	   if (ds_text[# prop._time, ds_target] < argument14) {
	      if (!sys_action_skip()) {
	         ds_text[# prop._time, ds_target] += time_frame;
	      } else {
	         //Otherwise skip transition if vngen_do_continue is run
	         ds_text[# prop._time, ds_target] = argument14; 
	      }
      
	      //Mark this action as complete
	      if (ds_text[# prop._time, ds_target] < 0) or (ds_text[# prop._time, ds_target] >= argument14) {      
	         //Disallow exceeding target values
	         ds_text[# prop._x, ds_target] = argument1;                              //X
	         ds_text[# prop._y, ds_target] = argument2;                              //Y
	         ds_text[# prop._xscale, ds_target] = argument4;                         //X scale
	         ds_text[# prop._yscale, ds_target] = argument5;                         //Y scale
	         ds_text[# prop._rot, ds_target] = argument6;                            //Rotation
	         ds_text[# prop._col1, ds_target] = text_c1;                             //Color1
	         ds_text[# prop._col2, ds_target] = text_c2;                             //Color2
	         ds_text[# prop._col3, ds_target] = text_c3;                             //Color3
	         ds_text[# prop._col4, ds_target] = text_c4;                             //Color4
	         ds_text[# prop._alpha, ds_target] = argument13;                         //Alpha
	         ds_text[# prop._time, ds_target] = argument14;                          //Time
	         ds_text[# prop._redraw, ds_target] = ds_text[# prop._index, ds_target]; //Redraw index
	         ds_text[# prop._txt_shadow, ds_target] = text_shadow;                   //Shadow
	         ds_text[# prop._txt_outline, ds_target] = text_outline;                 //Outline
         
	         //Update text in backlog if created in the current event
	         if (!sys_event_skip()) {
	            vngen_log_add(auto, none, ds_text[# prop._name, ds_target], ds_text[# prop._txt_fnt, ds_target], text_c1, text_c2, text_c3, text_c4, text_shadow, text_outline, ds_text[# prop._txt_halign, ds_target], ds_text[# prop._txt_line_height, ds_target]);
	         }
         
	         //End action
	         if (ds_target == ds_yindex) {
	            sys_action_term();
            
	            //Continue to next text, if any
	            ds_target -= 1;
	            continue;
	         }
	      }
	   } else {
	      //Do not process when transitions are complete
	      ds_target -= 1;
	      continue;
	   }
   
	   //If duration is greater than 0...
	   if (argument14 > 0) {
	      //Get transition time
	      var action_time = interp(0, 1, ds_text[# prop._time, ds_target]/argument14, argument15);
   
	      //Clamp color interpolation
	      var color_time = clamp(action_time, 0, 1);
   
	      //Enable redrawing modifications during transition
	      ds_text[# prop._redraw, ds_target] = ds_text[# prop._index, ds_target]; //Redraw index
   
	      //Perform text modifications
	      ds_text[# prop._x, ds_target] = lerp(ds_text[# prop._tmp_x, ds_target], argument1, action_time);           //X
	      ds_text[# prop._y, ds_target] = lerp(ds_text[# prop._tmp_y, ds_target], argument2, action_time);           //Y
	      ds_text[# prop._xscale, ds_target] = lerp(ds_text[# prop._tmp_xscale, ds_target], argument4, action_time); //X scale
	      ds_text[# prop._yscale, ds_target] = lerp(ds_text[# prop._tmp_yscale, ds_target], argument5, action_time); //Y scale
	      ds_text[# prop._rot, ds_target] = lerp(ds_text[# prop._tmp_rot, ds_target], argument6, action_time);       //Rotation
	      ds_text[# prop._col1, ds_target] = merge_color(ds_text[# prop._tmp_col1, ds_target], text_c1, color_time); //Color1  
	      ds_text[# prop._col2, ds_target] = merge_color(ds_text[# prop._tmp_col2, ds_target], text_c2, color_time); //Color2  
	      ds_text[# prop._col3, ds_target] = merge_color(ds_text[# prop._tmp_col3, ds_target], text_c3, color_time); //Color3  
	      ds_text[# prop._col4, ds_target] = merge_color(ds_text[# prop._tmp_col4, ds_target], text_c4, color_time); //Color4  
	      ds_text[# prop._alpha, ds_target] = lerp(ds_text[# prop._tmp_alpha, ds_target], argument13, action_time);  //Alpha
   
	      //Interp shadow, if enabled
	      if (text_shadow != -4) {
	         var temp_shadow = max(0, ds_text[# prop._tmp_shadow, ds_target]);
	         ds_text[# prop._txt_shadow, ds_target] = merge_color(temp_shadow, text_shadow, color_time); //Shadow
	      } else {
	         //Otherwise disable directly
	         if (ds_text[# prop._txt_shadow, ds_target] != -4) {
	            ds_text[# prop._txt_shadow, ds_target] = -4;
	         }
	      }
   
	      //Interp outline, if enabled
	      if (text_outline != -4) {
	         var temp_outline = max(0, ds_text[# prop._tmp_outline, ds_target]);
	         ds_text[# prop._txt_outline, ds_target] = merge_color(temp_outline, text_outline, color_time); //Outline  
	      } else {
	         //Otherwise disable directly
	         if (ds_text[# prop._txt_outline, ds_target] != -4) {
	            ds_text[# prop._txt_outline, ds_target] = -4;
	         }
	      }
	   }
   
	   //Continue to next text, if any
	   ds_target -= 1;
	} 



}
