/// @function	vngen_prompt_replace(id, sprite_idle, sprite_active, sprite_auto, duration, [ease]);
/// @param		{real|string}	id
/// @param		{sprite}		sprite_idle
/// @param		{sprite}		sprite_active
/// @param		{sprite}		sprite_auto
/// @param		{real}			duration
/// @param		{integer|macro}	[ease]
/// @author		Lucas Chasteen <lucas.chasteen@xgasoft.com>
/// @copyright	XGASOFT 2020, All Rights Reserved
function vngen_prompt_replace() {

	/*
	Applies a new sprite to the specified prompt. As with other  modifications, 
	changes to active sprites will persist until the prompt is removed 
	or another replacement is performed.

	argument0 = identifier of the prompt to be modified (real or string)
	argument1 = the new waiting sprite to apply to the prompt (sprite) (required)
	argument2 = the new active sprite to apply to the prompt (sprite) (optional, use 'none' for none)
	argument3 = the new auto mode sprite to apply to the prompt (sprite) (optional, use 'none' for none)
	argument4 = sets the length of the replacement transition, in seconds (real)
	argument5 = sets the animation easing method (see interp for available modes) (integer) (can also use true/false) (optional, use no argument for none)

	Example usage:
	   vngen_event() {
	      vngen_prompt_replace("prompt", spr_wait_new, spr_active_new, spr_auto_new, 5);
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
	      //Get prompt slot
	      var ds_target = vngen_get_index(argument[0], vngen_type_prompt);
         
	      //If the target prompt exists...
	      if (!is_undefined(ds_target)) {      
	         //Clear deform surface to be redrawn, if any
	         if (surface_exists(ds_prompt[# prop._def_surf, ds_target])) {
	            surface_free(ds_prompt[# prop._def_surf, ds_target]);
	         }   
              
	         //Backup original values to temp value slots
	         ds_prompt[# prop._tmp_xorig, ds_target] = ds_prompt[# prop._xorig, ds_target]; //Sprite X origin
	         ds_prompt[# prop._tmp_yorig, ds_target] = ds_prompt[# prop._yorig, ds_target]; //Sprite Y origin     
            
	         //Set sprite values
	         switch (ds_prompt[# prop._index, ds_target]) {
	            case 1: ds_prompt[# prop._fade_src, ds_target] = ds_prompt[# prop._sprite, ds_target]; break;  //Fade auto sprite
	            case 3: ds_prompt[# prop._fade_src, ds_target] = ds_prompt[# prop._sprite3, ds_target]; break; //Fade active sprite
	            default: ds_prompt[# prop._fade_src, ds_target] = ds_prompt[# prop._sprite2, ds_target];       //Fade waiting sprite
	         }
	         ds_prompt[# prop._fade_alpha, ds_target] = 0;								   //Fade alpha
		     ds_prompt[# prop._img_index, ds_target] = 0;                                  //Image index
		     ds_prompt[# prop._img_num, ds_target] = sprite_get_number(argument[1]);       //Image total
	         ds_prompt[# prop._sprite, ds_target] = argument[3];						   //Auto sprite  
	         ds_prompt[# prop._sprite2, ds_target] = argument[1];						   //Waiting sprite      
	         ds_prompt[# prop._sprite3, ds_target] = argument[2];						   //Active sprite             
			 ds_prompt[# prop._index, ds_target] = 2;                              	       //Prompt state
	         ds_prompt[# prop._width, ds_target] = sprite_get_width(argument[1]);		   //Crop width
	         ds_prompt[# prop._height, ds_target] = sprite_get_height(argument[1]);		   //Crop height        
         
	         //Set transition time
	         if (argument[4] > 0) {
	            ds_prompt[# prop._fade_time, ds_target] = 0;  //Transition time
	         } else {
	            ds_prompt[# prop._fade_time, ds_target] = -1; //Transition time
	         }            
	      } else {
	         //Skip action if prompt does not exist
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

	//Get prompt slot
	var ds_target = vngen_get_index(argument[0], vngen_type_prompt);

	//Skip action if target prompt does not exist
	if (is_undefined(ds_target)) {
	   exit;
	}


	/*
	PERFORM REPLACEMENT
	*/

	if (ds_prompt[# prop._fade_time, ds_target] < argument[4]) {
	   //Get sprites to check dimensions
	   var action_sprite = ds_prompt[# prop._sprite2, ds_target];
	   var fade_sprite = ds_prompt[# prop._fade_src, ds_target];

	   //Get sprite origins
	   var action_xorig = sprite_get_xoffset(action_sprite);
	   var action_yorig = sprite_get_yoffset(action_sprite);

	   //Increment transition time
	   if (!sys_action_skip()) {
	      ds_prompt[# prop._fade_time, ds_target] += time_frame;
	   } else {
	      //Otherwise skip transition if vngen_do_continue is run
	      ds_prompt[# prop._fade_time, ds_target] = argument[4];
	   }
   
	   //Mark this action as complete
	   if (ds_prompt[# prop._fade_time, ds_target] < 0) or (ds_prompt[# prop._fade_time, ds_target] >= argument[4]) {
	      //Disallow exceeding target values
	      ds_prompt[# prop._xorig, ds_target] = action_xorig;    //Sprite X origin
	      ds_prompt[# prop._yorig, ds_target] = action_yorig;    //Sprite Y origin      
	      ds_prompt[# prop._fade_src, ds_target] = -1;           //Fade sprite
	      ds_prompt[# prop._fade_alpha, ds_target] = 1;          //Fade alpha
	      ds_prompt[# prop._fade_time, ds_target] = argument[4]; //Fade time   
      
	      //Clear fade surface from memory, if any
	      if (!sys_event_skip()) {
	         if (surface_exists(ds_prompt[# prop._def_fade_surf, ds_target])) {
	            surface_free(ds_prompt[# prop._def_fade_surf, ds_target]);
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
	if (argument[4] > 0) {
	   //Get ease mode
	   if (argument_count > 5) {
	      var action_ease = argument[5];
	   } else {
	      var action_ease = true;
	   }
   
	   //Get transition time
	   var action_time = interp(0, 1, ds_prompt[# prop._fade_time, ds_target]/argument[4], action_ease);

	   //Perform prompt replacement
	   ds_prompt[# prop._xorig, ds_target] = lerp(ds_prompt[# prop._tmp_xorig, ds_target], action_xorig, action_time); //Sprite X origin
	   ds_prompt[# prop._yorig, ds_target] = lerp(ds_prompt[# prop._tmp_yorig, ds_target], action_yorig, action_time); //Sprite Y origin
	   ds_prompt[# prop._fade_alpha, ds_target] = lerp(0, 1, action_time);                                             //Fade alpha
	}



}
