/// @function	vngen_attach_modify_pos(name, id, x, y, z, scale, rot, duration, [ease]);
/// @param		{string|macro}	name
/// @param		{real|string}	id
/// @param		{real}			x
/// @param		{real}			y
/// @param		{real}			z
/// @param		{real}			scale
/// @param		{real}			rot
/// @param		{real}			duration
/// @param		{integer|macro}	[ease]
/// @author		Lucas Chasteen <lucas.chasteen@xgasoft.com>
/// @copyright	XGASOFT 2020, All Rights Reserved
function vngen_attach_modify_pos() {

	/*
	Applies a number of customizations to the specified attachment. As with other
	actions, modifications will persist until the attachment is removed, the target
	character is destroyed, or another modification is performed.

	Unlike animations, mods are permanent changes performed once using absolute values. 

	argument0 = identifier of the character to be modified (string)
	argument1 = identifier of the attachment to be modified (real or string) (or keyword 'all' for all)
	argument2 = the new horizontal position to display the attachment (real)
	argument3 = the new vertical position to display the attachment (real)
	argument4 = the new drawing depth to display the attachment, relative to other attachments only (real)
	argument5 = the new scale multiplier to display the attachment (real)
	argument6 = the new rotation value to apply to the attachment, in degrees (real)
	argument7 = sets the length of the modification transition, in seconds (real)
	argument8 = sets the animation easing method (see interp for available modes) (integer) (can also use true/false) (optional, use no argument for none)

	Example usage:
	   vngen_event() {
	      vngen_attach_modify_pos("John Doe", "attach", 50, 100, -1, 1.5, 45, 2);
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
	               ds_attach[# prop._tmp_x, ds_attach_target] = ds_attach[# prop._x, ds_attach_target];           //X
	               ds_attach[# prop._tmp_y, ds_attach_target] = ds_attach[# prop._y, ds_attach_target];           //Y
	               ds_attach[# prop._tmp_xscale, ds_attach_target] = ds_attach[# prop._xscale, ds_attach_target]; //X scale
	               ds_attach[# prop._tmp_yscale, ds_attach_target] = ds_attach[# prop._yscale, ds_attach_target]; //Y scale
	               ds_attach[# prop._tmp_rot, ds_attach_target] = ds_attach[# prop._rot, ds_attach_target];       //Rotation
         
	               //Set transition time
	               if (argument[7] > 0) {
	                  ds_attach[# prop._time, ds_attach_target] = 0;     //Transition time
	               } else {
	                  ds_attach[# prop._time, ds_attach_target] = -1;    //Transition time
	               }
            
	               //Sort data structure by Z depth
	               ds_attach[# prop._z, ds_attach_target] = argument[4]; //Z
	               if (argument[1] != all) {
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
	         ds_attach[# prop._x, ds_attach_target] = argument[2];      //X
	         ds_attach[# prop._y, ds_attach_target] = argument[3];      //Y
	         ds_attach[# prop._xscale, ds_attach_target] = argument[5]; //X scale
	         ds_attach[# prop._yscale, ds_attach_target] = argument[5]; //Y scale
	         ds_attach[# prop._rot, ds_attach_target] = argument[6];    //Rotation
	         ds_attach[# prop._time, ds_attach_target] = argument[7];   //Time    
         
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
   
	      //Perform attachment modifications
	      ds_attach[# prop._x, ds_attach_target] = lerp(ds_attach[# prop._tmp_x, ds_attach_target], argument[2], action_time);           //X
	      ds_attach[# prop._y, ds_attach_target] = lerp(ds_attach[# prop._tmp_y, ds_attach_target], argument[3], action_time);           //Y
	      ds_attach[# prop._xscale, ds_attach_target] = lerp(ds_attach[# prop._tmp_xscale, ds_attach_target], argument[5], action_time); //X scale
	      ds_attach[# prop._yscale, ds_attach_target] = lerp(ds_attach[# prop._tmp_yscale, ds_attach_target], argument[5], action_time); //Y scale
	      ds_attach[# prop._rot, ds_attach_target] = lerp(ds_attach[# prop._tmp_rot, ds_attach_target], argument[6], action_time);       //Rotation
	   }
      
	   //Continue to next attachment, if any
	   ds_attach_target -= 1;
	}   



}
