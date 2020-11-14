/// @function	vngen_attach_modify_style(name, id, col1, col2, col3, col4, alpha, duration, [ease]);
/// @param		{string|macro}	name
/// @param		{real|string}	id
/// @param		{color}			col1
/// @param		{color}			col2
/// @param		{color}			col3
/// @param		{color}			col4
/// @param		{real}			alpha
/// @param		{real}			duration
/// @param		{integer|macro}	[ease]
/// @author		Lucas Chasteen <lucas.chasteen@xgasoft.com>
/// @copyright	XGASOFT 2020, All Rights Reserved
function vngen_attach_modify_style() {

	/*
	Applies a number of customizations to the specified attachment. As with other
	actions, modifications will persist until the attachment is removed, the target
	character is destroyed, or another modification is performed.

	Unlike animations, mods are permanent changes performed once using absolute values. 

	argument0 = identifier of the character to be modified (string)
	argument1 = identifier of the attachment to be modified (real or string) (or keyword 'all' for all)
	argument2 = the new color blending value for the top left corner (color)
	argument3 = the new color blending value for the top right corner (color)
	argument4 = the new color blending value for the bottom right corner (color)
	argument5 = the new color blending value for the bottom left corner (color)
	argument6 = the new alpha transparency value to display the attachment in (real) (0-1)
	argument7 = sets the length of the modification transition, in seconds (real)
	argument8 = sets the animation easing method (see interp for available modes) (integer) (can also use true/false) (optional, use no argument for none)

	Example usage:
	   vngen_event() {
	      vngen_attach_modify_style("John Doe", "attach", c_red, c_blue, c_green, c_yellow, 1, 2);
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
	      //Get character target
	      var ds_char_target = vngen_get_index(argument[0], vngen_type_char);
      
	      //If the target character exists...
	      if (!is_undefined(ds_char_target)) {  
	         //Get attachment data from target character
	         var ds_attach = ds_character[# prop._attach_data, ds_char_target];    
          
	         //Get attachment slot
	         if (argument[1] == all) {
	            //Modify all attachments, if enabled
	            var ds_attach_target = sys_grid_last(ds_attach);
	            var ds_xindex = 0;
	         } else {
	            //Otherwise get single attachment to modify
	            var ds_attach_target = vngen_get_index(argument[1], vngen_type_attach, argument[0]);
	            var ds_xindex = ds_attach_target;
	         }
      
	         //If the target attachment exists...
	         if (!is_undefined(ds_attach_target)) {
	            while (ds_attach_target >= ds_xindex) {  
	               //Backup original values to temp value slots
	               ds_attach[# prop._tmp_col1, ds_attach_target] = ds_attach[# prop._col1, ds_attach_target];   //Color1
	               ds_attach[# prop._tmp_col2, ds_attach_target] = ds_attach[# prop._col2, ds_attach_target];   //Color2
	               ds_attach[# prop._tmp_col3, ds_attach_target] = ds_attach[# prop._col3, ds_attach_target];   //Color3
	               ds_attach[# prop._tmp_col4, ds_attach_target] = ds_attach[# prop._col4, ds_attach_target];   //Color4         
	               ds_attach[# prop._tmp_alpha, ds_attach_target] = ds_attach[# prop._alpha, ds_attach_target]; //Alpha
         
	               //Set transition time
	               if (argument[7] > 0) {
	                  ds_attach[# prop._time, ds_attach_target] = 0;  //Transition time
	               } else {
	                  ds_attach[# prop._time, ds_attach_target] = -1; //Transition time
	               }
               
	               //Continue to next attachment, if any
	               ds_attach_target -= 1;
	            }            
	         } else {
	            //Skip action if attachment does not exist
	            sys_action_term();
	            exit;
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

	//Get character slot to modify
	var ds_char_target = vngen_get_index(argument[0], vngen_type_char);

	//Skip action if target character does not exist
	if (is_undefined(ds_char_target)) {
	   exit;
	}

	//Get attachment data from target character
	var ds_attach = ds_character[# prop._attach_data, ds_char_target];

	//Get attachment slot
	if (argument[1] == all) {
	   //Modify all attachments, if enabled
	   var ds_attach_target = sys_grid_last(ds_attach);
	   var ds_xindex = 0;
	} else {
	   //Otherwise get single attachment to modify
	   var ds_attach_target = vngen_get_index(argument[1], vngen_type_attach, argument[0]);
	   var ds_xindex = ds_attach_target;
	}

	//Skip action if target attachment does not exist
	if (is_undefined(ds_attach_target)) {
	   exit;
	}


	/*
	PERFORM MODIFICATIONS
	*/

	while (ds_attach_target >= ds_xindex) {  
	   //Increment transition time
	   if (ds_attach[# prop._time, ds_attach_target] < argument[7]) {
	      if (!sys_action_skip()) {
	         ds_attach[# prop._time, ds_attach_target] += time_frame;
	      } else {
	         //Otherwise skip transition if vngen_do_continue is run
	         ds_attach[# prop._time, ds_attach_target] = argument[7];
	      }
      
	      //Mark this action as complete
	      if (ds_attach[# prop._time, ds_attach_target] < 0) or (ds_attach[# prop._time, ds_attach_target] >= argument[7]) {      
	         //Disallow exceeding target values
	         ds_attach[# prop._col1, ds_attach_target] = argument[2];      //Color1
	         ds_attach[# prop._col2, ds_attach_target] = argument[3];      //Color2
	         ds_attach[# prop._col3, ds_attach_target] = argument[4];      //Color3
	         ds_attach[# prop._col4, ds_attach_target] = argument[5];      //Color4
	         ds_attach[# prop._alpha, ds_attach_target] = argument[6];     //Alpha
	         ds_attach[# prop._time, ds_attach_target] = argument[7];      //Time
         
	         ds_attach[# prop._anim_col1, ds_attach_target] = argument[2]; //Animation color1 override
	         ds_attach[# prop._anim_col2, ds_attach_target] = argument[3]; //Animation color2 override
	         ds_attach[# prop._anim_col3, ds_attach_target] = argument[4]; //Animation color3 override
	         ds_attach[# prop._anim_col4, ds_attach_target] = argument[5]; //Animation color4 override      
         
	         //End action
	         if (ds_attach_target == ds_xindex) {
	            sys_action_term();
            
	            //Continue to next attachment, if any
	            ds_attach_target -= 1;
	            continue;
	         }
	      }
	   } else {
	      //Do not process when transitions are complete
	      ds_attach_target -= 1;
	      continue;
	   }
   
	   //If duration is greater than 0...
	   if (argument[7] > 0) {
	      //Get ease mode
	      if (argument_count > 8) {
	         var action_ease = argument[8];
	      } else {
	         var action_ease = true;
	      }
      
	      //Get transition time
	      var action_time = interp(0, 1, ds_attach[# prop._time, ds_attach_target]/argument[7], action_ease);
   
	      //Clamp color interpolation
	      var color_time = clamp(action_time, 0, 1);
   
	      //Perform attachment modifications
	      ds_attach[# prop._col1, ds_attach_target] = merge_color(ds_attach[# prop._tmp_col1, ds_attach_target], argument[2], color_time); //Color1  
	      ds_attach[# prop._col2, ds_attach_target] = merge_color(ds_attach[# prop._tmp_col2, ds_attach_target], argument[3], color_time); //Color2  
	      ds_attach[# prop._col3, ds_attach_target] = merge_color(ds_attach[# prop._tmp_col3, ds_attach_target], argument[4], color_time); //Color3  
	      ds_attach[# prop._col4, ds_attach_target] = merge_color(ds_attach[# prop._tmp_col4, ds_attach_target], argument[5], color_time); //Color4  
	      ds_attach[# prop._alpha, ds_attach_target] = lerp(ds_attach[# prop._tmp_alpha, ds_attach_target], argument[6], action_time);     //Alpha
	   }
      
	   //Continue to next attachment, if any
	   ds_attach_target -= 1;
	}


}
