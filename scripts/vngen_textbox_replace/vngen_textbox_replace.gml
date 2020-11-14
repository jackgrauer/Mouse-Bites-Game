/// @function	vngen_textbox_replace(id, sprite, duration, [ease]);
/// @param		{real|string}	id
/// @param		{sprite}		sprite
/// @param		{real}			duration
/// @param		{integer|macro}	[ease]
/// @author		Lucas Chasteen <lucas.chasteen@xgasoft.com>
/// @copyright	XGASOFT 2020, All Rights Reserved
function vngen_textbox_replace() {

	/*
	Applies a new sprite with to the specified textbox. As with other modifications, 
	changes to active sprites will persist until the textbox is removed 
	or another replacement is performed.

	argument0 = identifier of the textbox to be modified (real or string)
	argument1 = the new sprite to apply to the textbox (sprite)
	argument2 = sets the length of the replacement transition, in seconds (real)
	argument3 = sets the animation easing method (see interp for available modes) (integer) (can also use true/false) (optional, use no argument for none)

	Example usage:
	   vngen_event() {
	      vngen_textbox_replace("textbox", spr_new, 5);
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
	      var ds_target = vngen_get_index(argument[0], vngen_type_textbox);
         
	      //If the target textbox exists...
	      if (!is_undefined(ds_target)) {    
	         //Clear deform surface to be redrawn, if any
	         if (surface_exists(ds_textbox[# prop._def_surf, ds_target])) {
	            surface_free(ds_textbox[# prop._def_surf, ds_target]);
	         }             
                
	         //Backup original values to temp value slots
	         ds_textbox[# prop._tmp_xorig, ds_target] = ds_textbox[# prop._xorig, ds_target]; //Sprite X origin
	         ds_textbox[# prop._tmp_yorig, ds_target] = ds_textbox[# prop._yorig, ds_target]; //Sprite Y origin     
            
	         //Set sprite values
	         ds_textbox[# prop._fade_src, ds_target] = ds_textbox[# prop._sprite, ds_target]; //Fade sprite
	         ds_textbox[# prop._fade_alpha, ds_target] = 0;                                   //Fade alpha
	         ds_textbox[# prop._sprite, ds_target] = argument[1];                             //Sprite               
	         ds_textbox[# prop._width, ds_target] = sprite_get_width(argument[1]);            //Crop width
	         ds_textbox[# prop._height, ds_target] = sprite_get_height(argument[1]);          //Crop height   
		     ds_textbox[# prop._img_index, ds_target] = 0;                                    //Image index
		     ds_textbox[# prop._img_num, ds_target] = sprite_get_number(argument[1]);         //Image total
         
	         //Set transition time
	         if (argument[2] > 0) {
	            ds_textbox[# prop._fade_time, ds_target] = 0;  //Transition time
	         } else {
	            ds_textbox[# prop._fade_time, ds_target] = -1; //Transition time
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
	var ds_target = vngen_get_index(argument[0], vngen_type_textbox);

	//Skip action if target textbox does not exist
	if (is_undefined(ds_target)) {
	   exit;
	}


	/*
	PERFORM REPLACEMENT
	*/

	if (ds_textbox[# prop._fade_time, ds_target] < argument[2]) {
	   //Get sprites to check dimensions
	   var action_sprite = ds_textbox[# prop._sprite, ds_target];
	   var fade_sprite = ds_textbox[# prop._fade_src, ds_target];

	   //Get sprite origins
	   var action_xorig = sprite_get_xoffset(action_sprite);
	   var action_yorig = sprite_get_yoffset(action_sprite);

	   //Increment transition time
	   if (!sys_action_skip()) {
	      ds_textbox[# prop._fade_time, ds_target] += time_frame;
	   } else {
	      //Otherwise skip transition if vngen_do_continue is run
	      ds_textbox[# prop._fade_time, ds_target] = argument[2];
	   }
   
	   //Mark this action as complete
	   if (ds_textbox[# prop._fade_time, ds_target] < 0) or (ds_textbox[# prop._fade_time, ds_target] >= argument[2]) {
	      //Disallow exceeding target values
	      ds_textbox[# prop._xorig, ds_target] = action_xorig;    //Sprite X origin
	      ds_textbox[# prop._yorig, ds_target] = action_yorig;    //Sprite Y origin      
	      ds_textbox[# prop._fade_src, ds_target] = -1;           //Fade sprite
	      ds_textbox[# prop._fade_alpha, ds_target] = 1;          //Fade alpha
	      ds_textbox[# prop._fade_time, ds_target] = argument[2]; //Fade time   
      
	      //Clear fade surface from memory, if any
	      if (!sys_event_skip()) {
	         if (surface_exists(ds_textbox[# prop._def_fade_surf, ds_target])) {
	            surface_free(ds_textbox[# prop._def_fade_surf, ds_target]);
	         }
	      }  
      
	      //End action
	      sys_action_term();
	      exit;
	   }
	} else {
	   //Do not process when transitions are complete
	   exit;
	}

	//If duration is greater than 0...
	if (argument[2] > 0) {
	   //Get ease mode
	   if (argument_count > 3) {
	      var action_ease = argument[3];
	   } else {
	      var action_ease = true;
	   }
   
	   //Get transition time
	   var action_time = interp(0, 1, ds_textbox[# prop._fade_time, ds_target]/argument[2], action_ease);

	   //Perform textbox replacement
	   ds_textbox[# prop._xorig, ds_target] = lerp(ds_textbox[# prop._tmp_xorig, ds_target], action_xorig, action_time); //Sprite X origin
	   ds_textbox[# prop._yorig, ds_target] = lerp(ds_textbox[# prop._tmp_yorig, ds_target], action_yorig, action_time); //Sprite Y origin
	   ds_textbox[# prop._fade_alpha, ds_target] = lerp(0, 1, action_time);                                              //Fade alpha
	}


}
