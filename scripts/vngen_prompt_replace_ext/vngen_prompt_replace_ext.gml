/// @function	vngen_prompt_replace_ext(id, trigger, sprite_idle, sprite_active, sprite_auto, xorig, yorig, scaling, duration, ease);
/// @param		{real|string}	id
/// @param		{string|macro}	trigger
/// @param		{sprite}		sprite_idle
/// @param		{sprite}		sprite_active
/// @param		{sprite}		sprite_auto
/// @param		{real|macro}	xorig
/// @param		{real|macro}	yorig
/// @param		{integer|macro}	scaling
/// @param		{real}			duration
/// @param		{integer|macro}	ease
/// @author		Lucas Chasteen <lucas.chasteen@xgasoft.com>
/// @copyright	XGASOFT 2020, All Rights Reserved
function vngen_prompt_replace_ext(argument0, argument1, argument2, argument3, argument4, argument5, argument6, argument7, argument8, argument9) {

	/*
	Applies a new sprite with offset support to the specified prompt. As with other 
	modifications, changes to active sprites will persist until the prompt is removed 
	or another replacement is performed.

	argument0 = identifier of the prompt to be modified (real or string)
	argument1 = new speaker name to use as trigger for drawing the prompt (string) (optional, use 'previous' for no change or 'any' for all characters)
	argument2 = the new waiting sprite to apply to the prompt (sprite) (required)
	argument3 = the new active sprite to apply to the prompt (sprite) (optional, use 'none' for none)
	argument4 = the new auto mode sprite to apply to the prompt (sprite) (optional, use 'none' for none)
	argument5 = the sprite horizontal offset, or center point (real)
	argument6 = the sprite vertical offset, or center point (real)
	argument7 = sets the scaling mode to perform: scale_none, scale_x_y, scale_x, scale_y, 
	            scale_stretch_x_y, scale_stretch_x, scale_stretch_y, scale_prop_x_y, 
	            scale_prop_x, or scale_prop_y (integer or macro)
	argument8 = sets the length of the replacement transition, in seconds (real)
	argument9 = sets the animation easing method (see interp for available modes) (integer) (can also use true/false)

	Example usage:
	   vngen_event() {
	      vngen_prompt_replace_ext("prompt", -1, spr_wait_new, spr_active_new, spr_auto_new, 0, 0, 5, 1, true);
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
	      var ds_target = vngen_get_index(argument0, vngen_type_prompt);
         
	      //If the target prompt exists...
	      if (!is_undefined(ds_target)) {    
	         //Clear deform surface to be redrawn, if any
	         if (surface_exists(ds_prompt[# prop._def_surf, ds_target])) {
	            surface_free(ds_prompt[# prop._def_surf, ds_target]);
	         }   
             
	         //Backup original values to temp value slots
	         ds_prompt[# prop._tmp_xorig, ds_target] = ds_prompt[# prop._xorig, ds_target];     //Sprite X origin
	         ds_prompt[# prop._tmp_yorig, ds_target] = ds_prompt[# prop._yorig, ds_target];     //Sprite Y origin
	         ds_prompt[# prop._tmp_oxscale, ds_target] = ds_prompt[# prop._oxscale, ds_target]; //X scale offset
	         ds_prompt[# prop._tmp_oyscale, ds_target] = ds_prompt[# prop._oyscale, ds_target]; //Y scale offset       
            
	         //Set sprite values
	         switch (ds_prompt[# prop._index, ds_target]) {
	            case 1: ds_prompt[# prop._fade_src, ds_target] = ds_prompt[# prop._sprite, ds_target]; break;  //Fade auto sprite
	            case 3: ds_prompt[# prop._fade_src, ds_target] = ds_prompt[# prop._sprite3, ds_target]; break; //Fade active sprite
	            default: ds_prompt[# prop._fade_src, ds_target] = ds_prompt[# prop._sprite2, ds_target];       //Fade waiting sprite
	         }
	         ds_prompt[# prop._fade_alpha, ds_target] = 0;								 //Fade alpha   
		     ds_prompt[# prop._img_index, ds_target] = 0;                                //Image index
		     ds_prompt[# prop._img_num, ds_target] = sprite_get_number(argument2);       //Image total
	         ds_prompt[# prop._sprite, ds_target] = argument4;							 //Auto sprite  
	         ds_prompt[# prop._sprite2, ds_target] = argument2;							 //Waiting sprite      
	         ds_prompt[# prop._sprite3, ds_target] = argument3;							 //Active sprite                      
			 ds_prompt[# prop._index, ds_target] = 2;                              	     //Prompt state
	         ds_prompt[# prop._width, ds_target] = sprite_get_width(argument2);			 //Crop width
	         ds_prompt[# prop._height, ds_target] = sprite_get_height(argument2);		 //Crop height
         
	         //Set new trigger, if enabled
	         if (argument1 != -1) {
	            ds_prompt[# prop._trigger, ds_target] = argument1; //Trigger      
	         }   
         
	         //Set transition time
	         if (argument8 > 0) {
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
	var ds_target = vngen_get_index(argument0, vngen_type_prompt);

	//Skip action if target prompt does not exist
	if (is_undefined(ds_target)) {
	   exit;
	}


	/*
	PERFORM REPLACEMENT
	*/

	if (ds_prompt[# prop._fade_time, ds_target] < argument8) {
	   //Get sprites to check dimensions
	   var action_sprite = ds_prompt[# prop._sprite2, ds_target];
	   var fade_sprite = ds_prompt[# prop._fade_src, ds_target];
   
	   /* SPRITE ORIGINS */
   
	   //Backup current origin values to temp variables
	   var temp_xorig = ds_prompt[# prop._xorig, ds_target];
	   var temp_yorig = ds_prompt[# prop._yorig, ds_target];
   
	   //Calculate new origin
	   sys_orig_init(ds_prompt, ds_target, argument5, argument6);
   
	   //Get new origin
	   var action_xorig = ds_prompt[# prop._xorig, ds_target];
	   var action_yorig = ds_prompt[# prop._yorig, ds_target];
   
	   //Restore temp origin values
	   ds_prompt[# prop._xorig, ds_target] = temp_xorig;
	   ds_prompt[# prop._yorig, ds_target] = temp_yorig;   
   
	   /* SCALING */   
   
	   //Backup current scale values to temp variables
	   var temp_xscale = ds_prompt[# prop._oxscale, ds_target];
	   var temp_yscale = ds_prompt[# prop._oyscale, ds_target];
   
	   //Calculate new scale
	   sys_scale_init(ds_prompt, ds_target, global.dp_width, global.dp_height, global.dp_width_init, global.dp_height_init, argument7);
   
	   //Get new scale
	   var action_xscale = ds_prompt[# prop._oxscale, ds_target];
	   var action_yscale = ds_prompt[# prop._oyscale, ds_target];
   
	   //Restore temp scale values
	   ds_prompt[# prop._oxscale, ds_target] = temp_xscale;
	   ds_prompt[# prop._oyscale, ds_target] = temp_yscale;
   
	   /* TRANSITIONS */

	   //Increment transition time
	   if (!sys_action_skip()) {
	      ds_prompt[# prop._fade_time, ds_target] += time_frame;
	   } else {
	      //Otherwise skip transition if vngen_do_continue is run
	      ds_prompt[# prop._fade_time, ds_target] = argument8;
	   }
   
	   //Mark this action as complete
	   if (ds_prompt[# prop._fade_time, ds_target] < 0) or (ds_prompt[# prop._fade_time, ds_target] >= argument8) {
	      //Disallow exceeding target values
	      ds_prompt[# prop._xorig, ds_target] = action_xorig;    //Sprite X origin
	      ds_prompt[# prop._yorig, ds_target] = action_yorig;    //Sprite Y origin      
	      ds_prompt[# prop._fade_src, ds_target] = -1;           //Fade sprite
	      ds_prompt[# prop._fade_alpha, ds_target] = 1;          //Fade alpha
	      ds_prompt[# prop._fade_time, ds_target] = argument8;   //Fade time
	      ds_prompt[# prop._oxscale, ds_target] = action_xscale; //X scale offset
	      ds_prompt[# prop._oyscale, ds_target] = action_yscale; //Y scale offset      
      
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
	if (argument8 > 0) {
	   //Get transition time
	   var action_time = interp(0, 1, ds_prompt[# prop._fade_time, ds_target]/argument8, argument9);

	   //Perform prompt replacement
	   ds_prompt[# prop._xorig, ds_target] = lerp(ds_prompt[# prop._tmp_xorig, ds_target], action_xorig, action_time);      //Sprite X origin
	   ds_prompt[# prop._yorig, ds_target] = lerp(ds_prompt[# prop._tmp_yorig, ds_target], action_yorig, action_time);      //Sprite Y origin
	   ds_prompt[# prop._fade_alpha, ds_target] = lerp(0, 1, action_time);                                                  //Fade alpha
	   ds_prompt[# prop._oxscale, ds_target] = lerp(ds_prompt[# prop._tmp_oxscale, ds_target], action_xscale, action_time); //X scale offset
	   ds_prompt[# prop._oyscale, ds_target] = lerp(ds_prompt[# prop._tmp_oyscale, ds_target], action_yscale, action_time); //Y scale offset
	}



}
