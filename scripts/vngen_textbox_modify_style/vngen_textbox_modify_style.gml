/// @function	vngen_textbox_modify_style(id, col1, col2, col3, col4, alpha, duration, [ease]);
/// @param		{real|string|macro}	id
/// @param		{color}				col1
/// @param		{color}				col2
/// @param		{color}				col3
/// @param		{color}				col4
/// @param		{real}				alpha
/// @param		{real}				duration
/// @param		{integer|macro}		[ease]
/// @author		Lucas Chasteen <lucas.chasteen@xgasoft.com>
/// @copyright	XGASOFT 2020, All Rights Reserved
function vngen_textbox_modify_style() {

	/*
	Applies a number of customizations to the specified textbox. As with other
	actions, modifications will persist until the textbox is removed or another
	modification is performed.

	Unlike animations, mods are permanent changes performed once using absolute values. 

	argument0 = identifier of the textbox to be modified (real or string) (or keyword 'all' for all)
	argument1 = the new color blending value for the top left corner (color)
	argument2 = the new color blending value for the top right corner (color)
	argument3 = the new color blending value for the bottom right corner (color)
	argument4 = the new color blending value for the bottom left corner (color)
	argument5 = the new alpha transparency value to display the textbox in (real) (0-1)
	argument6 = sets the length of the modification transition, in seconds (real)
	argument7 = sets the animation easing method (see interp for available modes) (integer) (can also use true/false) (optional, use no argument for none)

	Example usage:
	   vngen_event() {
	      vngen_textbox_modify_style("textbox", c_red, c_blue, c_green, c_yellow, 1, 2);
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
	      //Get textbox slot
	      if (argument[0] == all) {
	         //Modify all textboxes, if enabled
	         var ds_target = sys_grid_last(ds_textbox);
	         var ds_yindex = 0;
	      } else {
	         //Otherwise get single textbox to modify
	         var ds_target = vngen_get_index(argument[0], vngen_type_textbox);
	         var ds_yindex = ds_target;
	      }
        
	      //If the target textbox exists...
	      if (!is_undefined(ds_target)) { 
	         while (ds_target >= ds_yindex) {                
	            //Backup original values to temp value slots
	            ds_textbox[# prop._tmp_col1, ds_target] = ds_textbox[# prop._col1, ds_target];   //Color1
	            ds_textbox[# prop._tmp_col2, ds_target] = ds_textbox[# prop._col2, ds_target];   //Color2
	            ds_textbox[# prop._tmp_col3, ds_target] = ds_textbox[# prop._col3, ds_target];   //Color3
	            ds_textbox[# prop._tmp_col4, ds_target] = ds_textbox[# prop._col4, ds_target];   //Color4
	            ds_textbox[# prop._tmp_alpha, ds_target] = ds_textbox[# prop._alpha, ds_target]; //Alpha
                        
	            //Set transition time
	            if (argument[6] > 0) {
	               ds_textbox[# prop._time, ds_target] = 0;  //Transition time
	            } else {
	               ds_textbox[# prop._time, ds_target] = -1; //Transition time
	            }
            
	            //Continue to next textbox, if any
	            ds_target -= 1;
	         }                  
	      } else {
	         //Skip action if textbox does not exist
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

	//Get textbox slot
	if (argument[0] == all) {
	   //Modify all textboxes, if enabled
	   var ds_target = sys_grid_last(ds_textbox);
	   var ds_yindex = 0;
	} else {
	   //Otherwise get single textbox to modify
	   var ds_target = vngen_get_index(argument[0], vngen_type_textbox);
	   var ds_yindex = ds_target;
	}

	//Skip action if target textbox does not exist
	if (is_undefined(ds_target)) {
	   exit;
	}


	/*
	PERFORM MODIFICATIONS
	*/

	while (ds_target >= ds_yindex) { 
	   //Increment transition time
	   if (ds_textbox[# prop._time, ds_target] < argument[6]) {
	      if (!sys_action_skip()) {
	         ds_textbox[# prop._time, ds_target] += time_frame;
	      } else {
	         //Otherwise skip transition if vngen_do_continue is run
	         ds_textbox[# prop._time, ds_target] = argument[6];
	      }
      
	      //Mark this action as complete
	      if (ds_textbox[# prop._time, ds_target] < 0) or (ds_textbox[# prop._time, ds_target] >= argument[6]) {      
	         //Disallow exceeding target values
	         ds_textbox[# prop._col1, ds_target] = argument[1];      //Color1
	         ds_textbox[# prop._col2, ds_target] = argument[2];      //Color2
	         ds_textbox[# prop._col3, ds_target] = argument[3];      //Color3
	         ds_textbox[# prop._col4, ds_target] = argument[4];      //Color4
	         ds_textbox[# prop._alpha, ds_target] = argument[5];     //Alpha
	         ds_textbox[# prop._time, ds_target] = argument[6];      //Time
         
	         ds_textbox[# prop._anim_col1, ds_target] = argument[1]; //Animation color1 override
	         ds_textbox[# prop._anim_col2, ds_target] = argument[2]; //Animation color2 override
	         ds_textbox[# prop._anim_col3, ds_target] = argument[3]; //Animation color3 override
	         ds_textbox[# prop._anim_col4, ds_target] = argument[4]; //Animation color4 override
         
	         //End action
	         if (ds_target == ds_yindex) {
	            sys_action_term();
            
	            //Continue to next textbox, if any
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
	   if (argument[6] > 0) {
	      //Get ease mode
	      if (argument_count > 7) {
	         var action_ease = argument[7];
	      } else {
	         var action_ease = true;
	      }
      
	      //Get transition time
	      var action_time = interp(0, 1, ds_textbox[# prop._time, ds_target]/argument[6], action_ease);
   
	      //Clamp color interpolation
	      var color_time = clamp(action_time, 0, 1);
   
	      //Perform textbox modifications
	      ds_textbox[# prop._col1, ds_target] = merge_color(ds_textbox[# prop._tmp_col1, ds_target], argument[1], color_time); //Color1  
	      ds_textbox[# prop._col2, ds_target] = merge_color(ds_textbox[# prop._tmp_col2, ds_target], argument[2], color_time); //Color2  
	      ds_textbox[# prop._col3, ds_target] = merge_color(ds_textbox[# prop._tmp_col3, ds_target], argument[3], color_time); //Color3  
	      ds_textbox[# prop._col4, ds_target] = merge_color(ds_textbox[# prop._tmp_col4, ds_target], argument[4], color_time); //Color4  
	      ds_textbox[# prop._alpha, ds_target] = lerp(ds_textbox[# prop._tmp_alpha, ds_target], argument[5], action_time);     //Alpha
	   }
            
	   //Continue to next textbox, if any
	   ds_target -= 1;
	}


}
