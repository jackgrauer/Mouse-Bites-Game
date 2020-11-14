/// @function	vngen_perspective_modify_pos(x, y, xoffset, yoffset, zoom, rot, strength, duration, [ease]);
/// @param		{real}			x
/// @param		{real}			y
/// @param		{real}			xoffset
/// @param		{real}			yoffset
/// @param		{real}			zoom
/// @param		{real}			rot
/// @param		{real}			strength
/// @param		{real}			duration
/// @param		{integer|macro} [ease]
/// @author		Lucas Chasteen <lucas.chasteen@xgasoft.com>
/// @copyright	XGASOFT 2020, All Rights Reserved
function vngen_perspective_modify_pos() {

	/*
	Applies a global offset to the position, rotation, and scale of active scenes, 
	characters, and emotes, using parallax to simulate depth. Parallax between elements 
	can be controlled with the 'strength' multiplier, where 0 equals no parallax and 
	greater values increase the divergence between layers when zoomed or offset. 
	Perspective 'offset' can be thought of like  a camera angle, where the perspective 
	center is the focal point.

	argument0 = the horizontal perspective center, where 0 is default (real)
	argument1 = the vertical perspective center, where 0 is default (real)
	argument2 = the horizontal perspective offset, or 'angle', where 0 is straight-on (real)
	argument3 = the vertical perspective offset, or 'angle', where 0 is straight-on (real)
	argument4 = the perspective zoom, where 1 is default (real)
	argument5 = the perspective rotation, in degrees, where 0 is default (real)
	argument6 = the parallax strength multiplier, where 1 is default and 0 is no parallax (real)
	argument7 = sets the length of the perspective transition, in seconds (real)
	argument8 = sets the animation easing method (see interp for available modes) (integer) (can also use true/false) (optional, use no argument for none)

	Example usage:
	   vngen_event() {
	      vngen_perspective_modify_pos(0, 0, -50, 50, 1, 0, 1, 0.5);
	      vngen_perspective_modify_pos(0, 0, -50, 50, 1, 0, 1, 0.5, true);
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
	      //Backup original values to temp value slots
	      ds_perspective[# prop._tmp_xorig, 0] = ds_perspective[# prop._xorig, 0];   //X offset
	      ds_perspective[# prop._tmp_yorig, 0] = ds_perspective[# prop._yorig, 0];   //Y offset
	      ds_perspective[# prop._tmp_x, 0] = ds_perspective[# prop._x, 0];           //X center
	      ds_perspective[# prop._tmp_y, 0] = ds_perspective[# prop._y, 0];           //Y center
	      ds_perspective[# prop._tmp_rot, 0] = ds_perspective[# prop._rot, 0];       //Rotation
	      ds_perspective[# prop._tmp_zoom, 0] = ds_perspective[# prop._per_zoom, 0]; //Zoom
	      ds_perspective[# prop._tmp_str, 0] = ds_perspective[# prop._per_str, 0];   //Strength
   
	      //Set transition time
	      if (argument[7] > 0) {
	         ds_perspective[# prop._time, 0] = 0;  //Transition time
	      } else {
	         ds_perspective[# prop._time, 0] = -1; //Transition time
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

	var per_zoom = max(0.005, argument[4]);
	var per_strength = max(0, argument[6]);

	/*
	PERFORM MODIFICATIONS
	*/

	//Increment transition time
	if (ds_perspective[# prop._time, 0] < argument[7]) {
	   if (!sys_action_skip()) {
	      ds_perspective[# prop._time, 0] += time_frame;
	   } else {
	      //Otherwise skip transition if vngen_do_continue is run
	      ds_perspective[# prop._time, 0] = argument[7];
	   }
   
	   //Mark this action as complete
	   if (ds_perspective[# prop._time, 0] < 0) or (ds_perspective[# prop._time, 0] >= argument[7]) { 
	      //Disallow exceeding target values          
	      ds_perspective[# prop._xorig, 0] = argument[2];    //X offset
	      ds_perspective[# prop._yorig, 0] = argument[3];    //Y offset  
	      ds_perspective[# prop._x, 0] = argument[0];        //X center
	      ds_perspective[# prop._y, 0] = argument[1];        //Y center   
	      ds_perspective[# prop._rot, 0] = argument[5];      //Rotation    
	      ds_perspective[# prop._per_zoom, 0] = per_zoom;    //Zoom
	      ds_perspective[# prop._per_str, 0] = per_strength; //Strength   
	      ds_perspective[# prop._time, 0] = argument[7];     //Time
      
	      //End action
	      sys_action_term();
	      exit;
	   }
	} else {
	   //Do not process when transitions are complete
	   exit;
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
	   var action_time = interp(0, 1, ds_perspective[# prop._time, 0]/argument[7], action_ease);

	   //Perform perspective modifications
	   ds_perspective[# prop._xorig, 0] = lerp(ds_perspective[# prop._tmp_xorig, 0], argument[2], action_time);  //X offset
	   ds_perspective[# prop._yorig, 0] = lerp(ds_perspective[# prop._tmp_yorig, 0], argument[3], action_time);  //Y offset
	   ds_perspective[# prop._x, 0] = lerp(ds_perspective[# prop._tmp_x, 0], argument[0], action_time);          //X center
	   ds_perspective[# prop._y, 0] = lerp(ds_perspective[# prop._tmp_y, 0], argument[1], action_time);          //Y center
	   ds_perspective[# prop._rot, 0] = lerp(ds_perspective[# prop._tmp_rot, 0], argument[5], action_time);      //Rotation
	   ds_perspective[# prop._per_zoom, 0] = lerp(ds_perspective[# prop._tmp_zoom, 0], per_zoom, action_time);   //Zoom
	   ds_perspective[# prop._per_str, 0] = lerp(ds_perspective[# prop._tmp_str, 0], per_strength, action_time); //Strength
	}


}
