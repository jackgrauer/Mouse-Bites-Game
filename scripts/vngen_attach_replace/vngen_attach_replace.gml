/// @function	vngen_attach_replace(name, id, sprite, duration, [ease]);
/// @param		{string}		name
/// @param		{real|string}	id
/// @param		{sprite}		sprite
/// @param		{real}			duration
/// @param		{integer|macro}	[ease]
/// @author		Lucas Chasteen <lucas.chasteen@xgasoft.com>
/// @copyright	XGASOFT 2020, All Rights Reserved
function vngen_attach_replace() {

	/*
	Applies a new sprite to the specified attachment. As with other modifications, 
	changes to active sprites will persist until the attachment is removed 
	or another replacement is performed.

	argument0 = identifier of the character to be modified (string)
	argument1 = identifier of the attachment to be modified (real or string)
	argument2 = the new sprite to apply to the attachment (sprite)
	argument3 = sets the length of the replacement transition, in seconds (real)
	argument4 = sets the animation easing method (see interp for available modes) (integer) (can also use true/false) (optional, use no argument for none)

	Example usage:
	   vngen_event() {
	      vngen_attach_replace("John Doe", "attach", spr_new, 1);
	   }
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
	         var ds_attach_target = vngen_get_index(argument[1], vngen_type_attach, argument[0]);
      
	         //If the target attachment exists...
	         if (!is_undefined(ds_attach_target)) {              
	            //Clear deform surface to be redrawn, if any
	            if (surface_exists(ds_attach[# prop._def_surf, ds_attach_target])) {
	               surface_free(ds_attach[# prop._def_surf, ds_attach_target]);
	            }          
         
	            //Backup original values to temp value slots
	            ds_attach[# prop._tmp_xorig, ds_attach_target] = ds_attach[# prop._xorig, ds_attach_target]; //Sprite X origin
	            ds_attach[# prop._tmp_yorig, ds_attach_target] = ds_attach[# prop._yorig, ds_attach_target]; //Sprite Y origin
                     
	            //Set sprite values
	            ds_attach[# prop._fade_src, ds_attach_target] = ds_attach[# prop._sprite, ds_attach_target]; //Fade sprite
	            ds_attach[# prop._fade_alpha, ds_attach_target] = 0;                                         //Fade alpha
	            ds_attach[# prop._sprite, ds_attach_target] = argument[2];                                   //Sprite              
	            ds_attach[# prop._width, ds_attach_target] = sprite_get_width(argument[2]);                  //Crop width
	            ds_attach[# prop._height, ds_attach_target] = sprite_get_height(argument[2]);                //Crop height  
			    ds_attach[# prop._img_index, ds_attach_target] = 0;										     //Image index
			    ds_attach[# prop._img_num, ds_attach_target] = sprite_get_number(argument[2]);			     //Image total     

	            //Set transition time
	            if (argument[3] > 0) {
	               ds_attach[# prop._fade_time, ds_attach_target] = 0;  //Transition time
	            } else {
	               ds_attach[# prop._fade_time, ds_attach_target] = -1; //Transition time
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
	var ds_attach_target = vngen_get_index(argument[1], vngen_type_attach, argument[0]);

	//Skip action if target attachment does not exist
	if (is_undefined(ds_attach_target)) {
	   exit;
	}


	/*
	PERFORM REPLACEMENT
	*/

	if (ds_attach[# prop._fade_time, ds_attach_target] < argument[3]) {
	   //Get sprites to check dimensions
	   var action_sprite = ds_attach[# prop._sprite, ds_attach_target];
	   var fade_sprite = ds_attach[# prop._fade_src, ds_attach_target];

	   //Get sprite origins
	   var action_xorig = sprite_get_xoffset(action_sprite);
	   var action_yorig = sprite_get_yoffset(action_sprite);

	   //Increment transition time
	   if (!sys_action_skip()) {
	      ds_attach[# prop._fade_time, ds_attach_target] += time_frame;
	   } else {
	      //Otherwise skip transition if vngen_do_continue is run
	      ds_attach[# prop._fade_time, ds_attach_target] = argument[3];
	   }
   
	   //Mark this action as complete
	   if (ds_attach[# prop._fade_time, ds_attach_target] < 0) or (ds_attach[# prop._fade_time, ds_attach_target] >= argument[3]) {
	      //Disallow exceeding target values
	      ds_attach[# prop._xorig, ds_attach_target] = action_xorig;    //Sprite X origin
	      ds_attach[# prop._yorig, ds_attach_target] = action_yorig;    //Sprite Y origin      
	      ds_attach[# prop._fade_src, ds_attach_target] = -1;           //Fade sprite
	      ds_attach[# prop._fade_alpha, ds_attach_target] = 1;          //Fade alpha
	      ds_attach[# prop._fade_time, ds_attach_target] = argument[3]; //Fade time  
      
	      //Clear fade surface from memory, if any
	      if (!sys_event_skip()) {
	         if (surface_exists(ds_attach[# prop._def_fade_surf, ds_attach_target])) {
	            surface_free(ds_attach[# prop._def_fade_surf, ds_attach_target]);
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
	if (argument[3] > 0) {
	   //Get ease mode
	   if (argument_count > 4) {
	      var action_ease = argument[4];
	   } else {
	      var action_ease = true;
	   }
   
	   //Get transition time
	   var action_time = interp(0, 1, ds_attach[# prop._fade_time, ds_attach_target]/argument[3], action_ease);

	   //Perform attachment replacement
	   ds_attach[# prop._xorig, ds_attach_target] = lerp(ds_attach[# prop._tmp_xorig, ds_attach_target], action_xorig, action_time); //Sprite X origin
	   ds_attach[# prop._yorig, ds_attach_target] = lerp(ds_attach[# prop._tmp_yorig, ds_attach_target], action_yorig, action_time); //Sprite Y origin
	   ds_attach[# prop._fade_alpha, ds_attach_target] = lerp(0, 1, action_time);                                                    //Fade alpha
	}


}
