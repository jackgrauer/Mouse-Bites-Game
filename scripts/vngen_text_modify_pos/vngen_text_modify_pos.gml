/// @function	vngen_text_modify_pos(id, x, y, z, scale, rot, duration, [ease]);
/// @param		{real|string|macro}	id
/// @param		{real}				x
/// @param		{real}				y
/// @param		{real}				z
/// @param		{real}				scale
/// @param		{real}				rot
/// @param		{real}				duration
/// @param		{integer|macro}		[ease]
/// @author		Lucas Chasteen <lucas.chasteen@xgasoft.com>
/// @copyright	XGASOFT 2020, All Rights Reserved
function vngen_text_modify_pos() {

	/*
	Applies a number of customizations to the specified text. As with other
	actions, modifications will persist until the text is removed or another
	modification is performed.

	Unlike animations, mods are permanent changes performed once using absolute values. 

	argument0 = identifier of the text to be modified (real or string) (or keyword 'all' for all)
	argument1 = the new horizontal position to display the text (real)
	argument2 = the new vertical position to display the text (real)
	argument3 = the new drawing depth to display the text, relative to other text only (real)
	argument4 = the new horizontal scale multiplier to display the text (real)
	argument5 = the new rotation value to apply to the text, in degrees (real)
	argument6 = sets the length of the modification transition, in seconds (real)
	argument7 = sets the animation easing method (see interp for available modes) (integer) (can also use true/false) (optional, use no argument for none)

	Example usage:
	   vngen_event() {
	      vngen_text_modify_pos("text", 0, view_hview[0] - 256, -1, 1.5, 0, 2);
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
	      if (argument[0] == all) {
	         //Modify all text, if enabled
	         var ds_target = sys_grid_last(ds_text);
	         var ds_yindex = 0;
	      } else {
	         //Otherwise get single text to modify
	         var ds_target = vngen_get_index(argument[0], vngen_type_text);
	         var ds_yindex = ds_target;
	      }
         
	      //If the target text exists...
	      if (!is_undefined(ds_target)) {  
	         while (ds_target >= ds_yindex) {          
	            //Backup original values to temp value slots
	            ds_text[# prop._tmp_x, ds_target] = ds_text[# prop._x, ds_target];           //X
	            ds_text[# prop._tmp_y, ds_target] = ds_text[# prop._y, ds_target];           //Y
	            ds_text[# prop._tmp_xscale, ds_target] = ds_text[# prop._xscale, ds_target]; //X scale
	            ds_text[# prop._tmp_yscale, ds_target] = ds_text[# prop._yscale, ds_target]; //Y scale
	            ds_text[# prop._tmp_rot, ds_target] = ds_text[# prop._rot, ds_target];       //Rotation
                     
	            //Set transition time
	            if (argument[6] > 0) {
	               ds_text[# prop._time, ds_target] = 0;  //Transition time
	            } else {
	               ds_text[# prop._time, ds_target] = -1; //Transition time
	            }     
            
	            //Sort data structure by Z depth
	            ds_text[# prop._z, ds_target] = argument[3];  //Z
	            if (argument[0] != all) {
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
	if (argument[0] == all) {
	   //Modify all text, if enabled
	   var ds_target = sys_grid_last(ds_text);
	   var ds_yindex = 0;
	} else {
	   //Otherwise get single text to modify
	   var ds_target = vngen_get_index(argument[0], vngen_type_text);
	   var ds_yindex = ds_target;
	}

	//Skip action if target text does not exist
	if (is_undefined(ds_target)) {
	   exit;
	}


	/*
	PERFORM MODIFICATIONS
	*/

	while (ds_target >= ds_yindex) {
	   //Increment transition time
	   if (ds_text[# prop._time, ds_target] < argument[6]) {
	      if (!sys_action_skip()) {
	         ds_text[# prop._time, ds_target] += time_frame;
	      } else {
	         //Otherwise skip transition if vngen_do_continue is run
	         ds_text[# prop._time, ds_target] = argument[6]; 
	      }
      
	      //Mark this action as complete
	      if (ds_text[# prop._time, ds_target] < 0) or (ds_text[# prop._time, ds_target] >= argument[6]) {      
	         //Disallow exceeding target values
	         ds_text[# prop._x, ds_target] = argument[1];        //X
	         ds_text[# prop._y, ds_target] = argument[2];        //Y
	         ds_text[# prop._xscale, ds_target] = argument[4];   //X scale
	         ds_text[# prop._yscale, ds_target] = argument[4];   //Y scale
	         ds_text[# prop._rot, ds_target] = argument[5];      //Rotation
	         ds_text[# prop._time, ds_target] = argument[6];     //Time
         
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
	   if (argument[6] > 0) {
	      //Get ease mode
	      if (argument_count > 7) {
	         var action_ease = argument[7];
	      } else {
	         var action_ease = true;
	      }
      
	      //Get transition time
	      var action_time = interp(0, 1, ds_text[# prop._time, ds_target]/argument[6], action_ease);
   
	      //Perform text modifications
	      ds_text[# prop._x, ds_target] = lerp(ds_text[# prop._tmp_x, ds_target], argument[1], action_time);           //X
	      ds_text[# prop._y, ds_target] = lerp(ds_text[# prop._tmp_y, ds_target], argument[2], action_time);           //Y
	      ds_text[# prop._xscale, ds_target] = lerp(ds_text[# prop._tmp_xscale, ds_target], argument[4], action_time); //X scale
	      ds_text[# prop._yscale, ds_target] = lerp(ds_text[# prop._tmp_yscale, ds_target], argument[4], action_time); //Y scale
	      ds_text[# prop._rot, ds_target] = lerp(ds_text[# prop._tmp_rot, ds_target], argument[5], action_time);       //Rotation
	   }
   
	   //Continue to next text, if any
	   ds_target -= 1;
	} 



}
