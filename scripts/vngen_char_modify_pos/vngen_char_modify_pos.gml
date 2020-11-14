/// @function	vngen_char_modify_pos(name, x, y, z, scale, rot, duration, [ease]);
/// @param		{string|macro}	name
/// @param		{real}			x
/// @param		{real}			y
/// @param		{real}			z
/// @param		{real}			scale
/// @param		{real}			rot
/// @param		{real}			duration
/// @param		{integer|macro}	[ease]
/// @author		Lucas Chasteen <lucas.chasteen@xgasoft.com>
/// @copyright	XGASOFT 2020, All Rights Reserved
function vngen_char_modify_pos() {

	/*
	Applies a number of advanced customizations to the specified character. As with other
	actions, modifications will persist until the character is removed or another
	modification is performed.

	Unlike animations, mods are permanent changes performed once using absolute values. 

	argument0 = identifier of the character to be modified (string) (or keyword 'all' for all)
	argument1 = the new horizontal position to display the character (real)
	argument2 = the new vertical position to display the character (real)
	argument3 = the new drawing depth to display the character, relative to other characters only (real)
	argument4 = the new scale multiplier to display the character (real)
	argument5 = the new rotation value to apply to the character, in degrees (real)
	argument6 = sets the length of the modification transition, in seconds (real)
	argument7 = sets the animation easing method (see interp for available modes) (integer) (can also use true/false) (optional, use no argument for none)

	Example usage:
	   vngen_event() {
	      vngen_char_modify_pos("John Doe", 0, view_hview[0] - 900, -1, 1.5, 45, 2);
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
	      if (argument[0] == all) {
	         //Modify all characters, if enabled
	         var ds_target = sys_grid_last(ds_character);
	         var ds_yindex = 0;
	      } else {
	         //Otherwise get single character to modify
	         var ds_target = vngen_get_index(argument[0], vngen_type_char);
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
                     
	            //Set transition time
	            if (argument[6] > 0) {
	               ds_character[# prop._time, ds_target] = 0;     //Transition time
	            } else {
	               ds_character[# prop._time, ds_target] = -1;    //Transition time
	            }
         
	            //Sort data structure by Z depth
	            ds_character[# prop._z, ds_target] = argument[3]; //Z
	            if (argument[0] != all) {
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
	if (argument[0] == all) {
	   //Modify all characters, if enabled
	   var ds_target = sys_grid_last(ds_character);
	   var ds_yindex = 0;
	} else {
	   //Otherwise get single character to modify
	   var ds_target = vngen_get_index(argument[0], vngen_type_char);
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
	   if (ds_character[# prop._time, ds_target] < argument[6]) {
	      if (!sys_action_skip()) {
	         ds_character[# prop._time, ds_target] += time_frame;
	      } else {
	         //Otherwise skip transition if vngen_do_continue is run
	         ds_character[# prop._time, ds_target] = argument[6];
	      }
      
	      //Mark this action as complete
	      if (ds_character[# prop._time, ds_target] < 0) or (ds_character[# prop._time, ds_target] >= argument[6]) {      
	         //Disallow exceeding target values
	         ds_character[# prop._x, ds_target] = argument[1];        //X
	         ds_character[# prop._y, ds_target] = argument[2];        //Y
	         ds_character[# prop._xscale, ds_target] = argument[4];   //X scale
	         ds_character[# prop._yscale, ds_target] = argument[4];   //Y scale
	         ds_character[# prop._rot, ds_target] = argument[5];      //Rotation
	         ds_character[# prop._time, ds_target] = argument[6];     //Time
         
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
	   if (argument[6] > 0) {
	      //Get ease mode
	      if (argument_count > 7) {
	         var action_ease = argument[7];
	      } else {
	         var action_ease = true;
	      }
      
	      //Get transition time
	      var action_time = interp(0, 1, ds_character[# prop._time, ds_target]/argument[6], action_ease);
   
	      //Perform character modifications
	      ds_character[# prop._x, ds_target] = lerp(ds_character[# prop._tmp_x, ds_target], argument[1], action_time);           //X
	      ds_character[# prop._y, ds_target] = lerp(ds_character[# prop._tmp_y, ds_target], argument[2], action_time);           //Y
	      ds_character[# prop._xscale, ds_target] = lerp(ds_character[# prop._tmp_xscale, ds_target], argument[4], action_time); //X scale
	      ds_character[# prop._yscale, ds_target] = lerp(ds_character[# prop._tmp_yscale, ds_target], argument[4], action_time); //Y scale
	      ds_character[# prop._rot, ds_target] = lerp(ds_character[# prop._tmp_rot, ds_target], argument[5], action_time);       //Rotation
	   }
            
	   //Continue to next character, if any
	   ds_target -= 1;
	}



}
