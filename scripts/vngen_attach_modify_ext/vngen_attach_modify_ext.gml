/// @function	vngen_attach_modify_ext(name, id, x, y, z, xscale, yscale, rot, col1, col2, col3, col4, alpha, duration, ease);
/// @param		{string|macro}	name
/// @param		{real|string}	id
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
function vngen_attach_modify_ext(argument0, argument1, argument2, argument3, argument4, argument5, argument6, argument7, argument8, argument9, argument10, argument11, argument12, argument13, argument14) {

	/*
	Applies a number of advanced customizations to the specified attachment. As with other
	actions, modifications will persist until the attachment is removed, the target
	character is destroyed, or another modification is performed.

	Unlike animations, mods are permanent changes performed once using absolute values. 

	argument0  = identifier of the character to be modified (string)
	argument1  = identifier of the attachment to be modified (real or string) (or keyword 'all' for all)
	argument2  = the new horizontal position to display the attachment (real)
	argument3  = the new vertical position to display the attachment (real)
	argument4  = the new drawing depth to display the attachment, relative to other attachments only (real)
	argument5  = the new horizontal scale multiplier to display the attachment (real)
	argument6  = the new vertical scale multiplier to display the attachment (real)
	argument7  = the new rotation value to apply to the attachment, in degrees (real)
	argument8  = the new color blending value for the top left corner (color)
	argument9  = the new color blending value for the top right corner (color)
	argument10 = the new color blending value for the bottom right corner (color)
	argument11 = the new color blending value for the bottom left corner (color)
	argument12 = the new alpha transparency value to display the attachment in (real) (0-1)
	argument13 = sets the length of the modification transition, in seconds (real)
	argument14 = sets the animation easing method (see interp for available modes) (integer) (can also use true/false)

	Example usage:
	   vngen_event() {
	      vngen_attach_modify_ext("John Doe", "attach", 50, 100, -1, 1, 1, 0, c_white, c_white, c_white, c_white, 1, 2, true);
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
	      var ds_char_target = vngen_get_index(argument0, vngen_type_char);
      
	      //If the target character exists...
	      if (!is_undefined(ds_char_target)) {  
	         //Get attachment data from target character
	         var ds_attach = ds_character[# prop._attach_data, ds_char_target];   
          
	         //Get attachment slot
	         if (argument1 == all) {
	            //Modify all attachments, if enabled
	            var ds_attach_target = sys_grid_last(ds_attach);
	            var ds_xindex = 0;
	         } else {
	            //Otherwise get single attachment to modify
	            var ds_attach_target = vngen_get_index(argument1, vngen_type_attach, argument0);
	            var ds_xindex = ds_attach_target;
	         }
      
	         //If the target attachment exists...
	         if (!is_undefined(ds_attach_target)) {
	            while (ds_attach_target >= ds_xindex) {  
	               //Backup original values to temp value slots
	               ds_attach[# prop._tmp_x, ds_attach_target] = ds_attach[# prop._x, ds_attach_target];           //X
	               ds_attach[# prop._tmp_y, ds_attach_target] = ds_attach[# prop._y, ds_attach_target];           //Y
	               ds_attach[# prop._tmp_xscale, ds_attach_target] = ds_attach[# prop._xscale, ds_attach_target]; //X scale
	               ds_attach[# prop._tmp_yscale, ds_attach_target] = ds_attach[# prop._yscale, ds_attach_target]; //Y scale
	               ds_attach[# prop._tmp_rot, ds_attach_target] = ds_attach[# prop._rot, ds_attach_target];       //Rotation
	               ds_attach[# prop._tmp_col1, ds_attach_target] = ds_attach[# prop._col1, ds_attach_target];     //Color1
	               ds_attach[# prop._tmp_col2, ds_attach_target] = ds_attach[# prop._col2, ds_attach_target];     //Color2
	               ds_attach[# prop._tmp_col3, ds_attach_target] = ds_attach[# prop._col3, ds_attach_target];     //Color3
	               ds_attach[# prop._tmp_col4, ds_attach_target] = ds_attach[# prop._col4, ds_attach_target];     //Color4         
	               ds_attach[# prop._tmp_alpha, ds_attach_target] = ds_attach[# prop._alpha, ds_attach_target];   //Alpha
         
	               //Set transition time
	               if (argument13 > 0) {
	                  ds_attach[# prop._time, ds_attach_target] = 0;   //Transition time
	               } else {
	                  ds_attach[# prop._time, ds_attach_target] = -1;  //Transition time
	               }
            
	               //Sort data structure by Z depth
	               ds_attach[# prop._z, ds_attach_target] = argument4; //Z
	               if (argument1 != all) {
	                  ds_grid_sort(ds_attach, prop._z, false);      
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
	var ds_char_target = vngen_get_index(argument0, vngen_type_char);

	//Skip action if target character does not exist
	if (is_undefined(ds_char_target)) {
	   exit;
	}

	//Get attachment data from target character
	var ds_attach = ds_character[# prop._attach_data, ds_char_target];
          
	//Get attachment slot
	if (argument1 == all) {
	   //Modify all attachments, if enabled
	   var ds_attach_target = sys_grid_last(ds_attach);
	   var ds_xindex = 0;
	} else {
	   //Otherwise get single attachment to modify
	   var ds_attach_target = vngen_get_index(argument1, vngen_type_attach, argument0);
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
	   if (ds_attach[# prop._time, ds_attach_target] < argument13) {
	      if (!sys_action_skip()) {
	         ds_attach[# prop._time, ds_attach_target] += time_frame;
	      } else {
	         //Otherwise skip transition if vngen_do_continue is run
	         ds_attach[# prop._time, ds_attach_target] = argument13;
	      }
      
	      //Mark this action as complete
	      if (ds_attach[# prop._time, ds_attach_target] < 0) or (ds_attach[# prop._time, ds_attach_target] >= argument13) {      
	         //Disallow exceeding target values
	         ds_attach[# prop._x, ds_attach_target] = argument2;          //X
	         ds_attach[# prop._y, ds_attach_target] = argument3;          //Y
	         ds_attach[# prop._xscale, ds_attach_target] = argument5;     //X scale
	         ds_attach[# prop._yscale, ds_attach_target] = argument6;     //Y scale
	         ds_attach[# prop._rot, ds_attach_target] = argument7;        //Rotation
	         ds_attach[# prop._col1, ds_attach_target] = argument8;       //Color1
	         ds_attach[# prop._col2, ds_attach_target] = argument9;       //Color2
	         ds_attach[# prop._col3, ds_attach_target] = argument10;      //Color3
	         ds_attach[# prop._col4, ds_attach_target] = argument11;      //Color4
	         ds_attach[# prop._alpha, ds_attach_target] = argument12;     //Alpha
	         ds_attach[# prop._time, ds_attach_target] = argument13;      //Time
         
	         ds_attach[# prop._anim_col1, ds_attach_target] = argument8;  //Animation color1 override
	         ds_attach[# prop._anim_col2, ds_attach_target] = argument9;  //Animation color2 override
	         ds_attach[# prop._anim_col3, ds_attach_target] = argument10; //Animation color3 override
	         ds_attach[# prop._anim_col4, ds_attach_target] = argument11; //Animation color4 override      
         
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
	   if (argument13 > 0) {
	      //Get transition time
	      var action_time = interp(0, 1, ds_attach[# prop._time, ds_attach_target]/argument13, argument14);
   
	      //Clamp color interpolation
	      var color_time = clamp(action_time, 0, 1);
   
	      //Perform attachment modifications
	      ds_attach[# prop._x, ds_attach_target] = lerp(ds_attach[# prop._tmp_x, ds_attach_target], argument2, action_time);              //X
	      ds_attach[# prop._y, ds_attach_target] = lerp(ds_attach[# prop._tmp_y, ds_attach_target], argument3, action_time);              //Y
	      ds_attach[# prop._xscale, ds_attach_target] = lerp(ds_attach[# prop._tmp_xscale, ds_attach_target], argument5, action_time);    //X scale
	      ds_attach[# prop._yscale, ds_attach_target] = lerp(ds_attach[# prop._tmp_yscale, ds_attach_target], argument6, action_time);    //Y scale
	      ds_attach[# prop._rot, ds_attach_target] = lerp(ds_attach[# prop._tmp_rot, ds_attach_target], argument7, action_time);          //Rotation
	      ds_attach[# prop._col1, ds_attach_target] = merge_color(ds_attach[# prop._tmp_col1, ds_attach_target], argument8, color_time);  //Color1  
	      ds_attach[# prop._col2, ds_attach_target] = merge_color(ds_attach[# prop._tmp_col2, ds_attach_target], argument9, color_time);  //Color2  
	      ds_attach[# prop._col3, ds_attach_target] = merge_color(ds_attach[# prop._tmp_col3, ds_attach_target], argument10, color_time); //Color3  
	      ds_attach[# prop._col4, ds_attach_target] = merge_color(ds_attach[# prop._tmp_col4, ds_attach_target], argument11, color_time); //Color4  
	      ds_attach[# prop._alpha, ds_attach_target] = lerp(ds_attach[# prop._tmp_alpha, ds_attach_target], argument12, action_time);     //Alpha
	   }
      
	   //Continue to next attachment, if any
	   ds_attach_target -= 1;
	}     


}
