/// @function	vngen_char_modify_ext(name, x, y, z, xscale, yscale, rot, col1, col2, col3, col4, alpha, duration, ease);
/// @param		{string|macro}	name
/// @param		{real}			x
/// @param		{real}			y
/// @param		{real}			z
/// @param		{real}			xscale
/// @param		{real}			yscale
/// @param		{real}			rot
/// @param		{color}			col1
/// @param		{color}			col2
/// @param		{color}			col3
/// @param		{color}			col4
/// @param		{real}			alpha
/// @param		{real}			duration
/// @param		{integer|macro}	ease
/// @author		Lucas Chasteen <lucas.chasteen@xgasoft.com>
/// @copyright	XGASOFT 2020, All Rights Reserved
function vngen_char_modify_ext(argument0, argument1, argument2, argument3, argument4, argument5, argument6, argument7, argument8, argument9, argument10, argument11, argument12, argument13) {

	/*
	Applies a number of advanced customizations to the specified character. As with other
	actions, modifications will persist until the character is removed or another
	modification is performed.

	Unlike animations, mods are permanent changes performed once using absolute values. 

	argument0  = identifier of the character to be modified (string) (or keyword 'all' for all)
	argument1  = the new horizontal position to display the character (real)
	argument2  = the new vertical position to display the character (real)
	argument3  = the new drawing depth to display the character, relative to other characters only (real)
	argument4  = the new horizontal scale multiplier to display the character (real)
	argument5  = the new vertical scale multiplier to display the character (real)
	argument6  = the new rotation value to apply to the character, in degrees (real)
	argument7  = the new color blending value for the top left corner (color)
	argument8  = the new color blending value for the top right corner (color)
	argument9  = the new color blending value for the bottom right corner (color)
	argument10 = the new color blending value for the bottom left corner (color)
	argument11 = the new alpha transparency value to display the character in (real) (0-1)
	argument12 = sets the length of the modification transition, in seconds (real)
	argument13 = sets the animation easing method (see interp for available modes) (integer) (can also use true/false)

	Example usage:
	   vngen_event() {
	      vngen_char_modify_ext("John Doe", 0, view_hview[0] - 900, -1, 1, 1, 0, c_white, c_white, c_white, c_white, 1, 2, true);
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
	      //Get character slot
	      if (argument0 == all) {
	         //Modify all characters, if enabled
	         var ds_target = sys_grid_last(ds_character);
	         var ds_yindex = 0;
	      } else {
	         //Otherwise get single character to modify
	         var ds_target = vngen_get_index(argument0, vngen_type_char);
	         var ds_yindex = ds_target;
	      }
         
	      //If the target character exists...
	      if (!is_undefined(ds_target)) {    
	         while (ds_target >= ds_yindex) {          
	            //Backup original values to temp value slots
	            ds_character[# prop._tmp_x, ds_target] = ds_character[# prop._x, ds_target];           //X
	            ds_character[# prop._tmp_y, ds_target] = ds_character[# prop._y, ds_target];           //Y
	            ds_character[# prop._tmp_xscale, ds_target] = ds_character[# prop._xscale, ds_target]; //X scale
	            ds_character[# prop._tmp_yscale, ds_target] = ds_character[# prop._yscale, ds_target]; //Y scale
	            ds_character[# prop._tmp_rot, ds_target] = ds_character[# prop._rot, ds_target];       //Rotation
	            ds_character[# prop._tmp_col1, ds_target] = ds_character[# prop._col1, ds_target];     //Color1
	            ds_character[# prop._tmp_col2, ds_target] = ds_character[# prop._col2, ds_target];     //Color2
	            ds_character[# prop._tmp_col3, ds_target] = ds_character[# prop._col3, ds_target];     //Color3
	            ds_character[# prop._tmp_col4, ds_target] = ds_character[# prop._col4, ds_target];     //Color4
	            ds_character[# prop._tmp_alpha, ds_target] = ds_character[# prop._alpha, ds_target];   //Alpha
                        
	            //Set transition time
	            if (argument12 > 0) {
	               ds_character[# prop._time, ds_target] = 0;   //Transition time
	            } else {
	               ds_character[# prop._time, ds_target] = -1;  //Transition time
	            }
            
	            //Sort data structure by Z depth
	            ds_character[# prop._z, ds_target] = argument3; //Z
	            if (argument0 != all) {
	               ds_grid_sort(ds_character, prop._z, false);      
	            }
            
	            //Continue to next character, if any
	            ds_target -= 1;
	         }                                
	      } else {
	         //Skip action if character does not exist
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

	//Get character slot
	if (argument0 == all) {
	   //Modify all characters, if enabled
	   var ds_target = sys_grid_last(ds_character);
	   var ds_yindex = 0;
	} else {
	   //Otherwise get single character to modify
	   var ds_target = vngen_get_index(argument0, vngen_type_char);
	   var ds_yindex = ds_target;
	}

	//Skip action if target character does not exist
	if (is_undefined(ds_target)) {
	   exit;
	}


	/*
	PERFORM MODIFICATIONS
	*/

	while (ds_target >= ds_yindex) { 
	   //Increment transition time
	   if (ds_character[# prop._time, ds_target] < argument12) {
	      if (!sys_action_skip()) {
	         ds_character[# prop._time, ds_target] += time_frame;
	      } else {
	         //Otherwise skip transition if vngen_do_continue is run
	         ds_character[# prop._time, ds_target] = argument12;
	      }
      
	      //Mark this action as complete
	      if (ds_character[# prop._time, ds_target] < 0) or (ds_character[# prop._time, ds_target] >= argument12) {      
	         //Disallow exceeding target values
	         ds_character[# prop._x, ds_target] = argument1;          //X
	         ds_character[# prop._y, ds_target] = argument2;          //Y
	         ds_character[# prop._xscale, ds_target] = argument4;     //X scale
	         ds_character[# prop._yscale, ds_target] = argument5;     //Y scale
	         ds_character[# prop._rot, ds_target] = argument6;        //Rotation
	         ds_character[# prop._col1, ds_target] = argument7;       //Color1
	         ds_character[# prop._col2, ds_target] = argument8;       //Color2
	         ds_character[# prop._col3, ds_target] = argument9;       //Color3
	         ds_character[# prop._col4, ds_target] = argument10;      //Color4
	         ds_character[# prop._alpha, ds_target] = argument11;     //Alpha
	         ds_character[# prop._time, ds_target] = argument12;      //Time
         
	         ds_character[# prop._anim_col1, ds_target] = argument7;  //Animation color1 override
	         ds_character[# prop._anim_col2, ds_target] = argument8;  //Animation color2 override
	         ds_character[# prop._anim_col3, ds_target] = argument9;  //Animation color3 override
	         ds_character[# prop._anim_col4, ds_target] = argument10; //Animation color4 override
         
	         //End action
	         if (ds_target == ds_yindex) {
	            sys_action_term();
            
	            //Continue to next character, if any
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
	   if (argument12 > 0) {
	      //Get transition time
	      var action_time = interp(0, 1, ds_character[# prop._time, ds_target]/argument12, argument13);
   
	      //Clamp color interpolation
	      var color_time = clamp(action_time, 0, 1);
   
	      //Perform character modifications
	      ds_character[# prop._x, ds_target] = lerp(ds_character[# prop._tmp_x, ds_target], argument1, action_time);              //X
	      ds_character[# prop._y, ds_target] = lerp(ds_character[# prop._tmp_y, ds_target], argument2, action_time);              //Y
	      ds_character[# prop._xscale, ds_target] = lerp(ds_character[# prop._tmp_xscale, ds_target], argument4, action_time);    //X scale
	      ds_character[# prop._yscale, ds_target] = lerp(ds_character[# prop._tmp_yscale, ds_target], argument5, action_time);    //Y scale
	      ds_character[# prop._rot, ds_target] = lerp(ds_character[# prop._tmp_rot, ds_target], argument6, action_time);          //Rotation
	      ds_character[# prop._col1, ds_target] = merge_color(ds_character[# prop._tmp_col1, ds_target], argument7, color_time);  //Color1  
	      ds_character[# prop._col2, ds_target] = merge_color(ds_character[# prop._tmp_col2, ds_target], argument8, color_time);  //Color2  
	      ds_character[# prop._col3, ds_target] = merge_color(ds_character[# prop._tmp_col3, ds_target], argument9, color_time);  //Color3  
	      ds_character[# prop._col4, ds_target] = merge_color(ds_character[# prop._tmp_col4, ds_target], argument10, color_time); //Color4  
	      ds_character[# prop._alpha, ds_target] = lerp(ds_character[# prop._tmp_alpha, ds_target], argument11, action_time);     //Alpha
	   }
            
	   //Continue to next character, if any
	   ds_target -= 1;
	}



}
