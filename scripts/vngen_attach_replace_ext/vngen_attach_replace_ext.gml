/// @function	vngen_attach_replace_ext(name, id, sprite, xorig, yorig, scaling, duration, ease);
/// @param		{string}		name
/// @param		{real|string}	id
/// @param		{sprite}		sprite
/// @param		{real|macro}	xorig
/// @param		{real|macro}	yorig
/// @param		{integer|macro}	scaling
/// @param		{real}			duration
/// @param		{integer|macro}	ease
/// @author		Lucas Chasteen <lucas.chasteen@xgasoft.com>
/// @copyright	XGASOFT 2020, All Rights Reserved
function vngen_attach_replace_ext(argument0, argument1, argument2, argument3, argument4, argument5, argument6, argument7) {

	/*
	Applies a new sprite with offset support to the specified attachment. As with other 
	modifications, changes to active sprites will persist until the attachment is removed 
	or another replacement is performed.

	argument0 = identifier of the character to be modified (string)
	argument1 = identifier of the attachment to be modified (real or string)
	argument2 = the new sprite to apply to the attachment (sprite)
	argument3 = the sprite horizontal offset, or center point (real)
	argument4 = the sprite vertical offset, or center point (real)
	argument5 = sets the scaling mode to perform: scale_none, scale_x_y, scale_x, scale_y, 
	            scale_stretch_x_y, scale_stretch_x, scale_stretch_y, scale_prop_x_y, 
	            scale_prop_x, or scale_prop_y (integer or macro)
	argument6 = sets the length of the replacement transition, in seconds (real)
	argument7 = sets the animation easing method (see interp for available modes) (integer) (can also use true/false)

	Example usage:
	   vngen_event() {
	      vngen_attach_replace_ext("John Doe", "attach", spr_new, 0, 0, 1, 1, true);
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
	      var ds_char_target = vngen_get_index(argument0, vngen_type_char);
      
	      //If the target character exists...
	      if (!is_undefined(ds_char_target)) {  
	         //Get attachment data from target character
	         var ds_attach = ds_character[# prop._attach_data, ds_char_target];    
         
	         //Get attachment slot
	         var ds_attach_target = vngen_get_index(argument1, vngen_type_attach, argument0);
      
	         //If the target attachment exists...
	         if (!is_undefined(ds_attach_target)) {          
	            //Clear deform surface to be redrawn, if any
	            if (surface_exists(ds_attach[# prop._def_surf, ds_attach_target])) {
	               surface_free(ds_attach[# prop._def_surf, ds_attach_target]);
	            }                   
            
	            //Backup original values to temp value slots
	            ds_attach[# prop._tmp_xorig, ds_attach_target] = ds_attach[# prop._xorig, ds_attach_target];     //Sprite X origin
	            ds_attach[# prop._tmp_yorig, ds_attach_target] = ds_attach[# prop._yorig, ds_attach_target];     //Sprite Y origin
	            ds_attach[# prop._tmp_oxscale, ds_attach_target] = ds_attach[# prop._oxscale, ds_attach_target]; //X scale offset
	            ds_attach[# prop._tmp_oyscale, ds_attach_target] = ds_attach[# prop._oyscale, ds_attach_target]; //Y scale offset  
                  
	            //Set sprite values
	            ds_attach[# prop._fade_src, ds_attach_target] = ds_attach[# prop._sprite, ds_attach_target];     //Fade sprite
	            ds_attach[# prop._fade_alpha, ds_attach_target] = 0;                                             //Fade alpha
	            ds_attach[# prop._sprite, ds_attach_target] = argument2;                                         //Sprite           
	            ds_attach[# prop._width, ds_attach_target] = sprite_get_width(argument2);                        //Crop width
	            ds_attach[# prop._height, ds_attach_target] = sprite_get_height(argument2);                      //Crop height
			    ds_attach[# prop._img_index, ds_attach_target] = 0;												 //Image index
			    ds_attach[# prop._img_num, ds_attach_target] = sprite_get_number(argument2);			    	 //Image total
      
	            //Set transition time
	            if (argument6 > 0) {
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
	var ds_char_target = vngen_get_index(argument0, vngen_type_char);

	//Skip action if target character does not exist
	if (is_undefined(ds_char_target)) {
	   exit;
	}

	//Get attachment data from target character
	var ds_attach = ds_character[# prop._attach_data, ds_char_target];

	//Get attachment slot
	var ds_attach_target = vngen_get_index(argument1, vngen_type_attach, argument0);

	//Skip action if target attachment does not exist
	if (is_undefined(ds_attach_target)) {
	   exit;
	}


	/*
	PERFORM REPLACEMENT
	*/

	if (ds_attach[# prop._fade_time, ds_attach_target] < argument6) {
	   //Get the parent sprite dimensions
	   var parent_width = sprite_get_width(ds_character[# prop._sprite, ds_char_target]);
	   var parent_height = sprite_get_height(ds_character[# prop._sprite, ds_char_target]);
   
	   //Get sprites to check dimensions
	   var action_sprite = ds_attach[# prop._sprite, ds_attach_target];
	   var fade_sprite = ds_attach[# prop._fade_src, ds_attach_target];
   
	   /* SPRITE ORIGINS */
   
	   //Backup current origin values to temp variables
	   var temp_xorig = ds_attach[# prop._xorig, ds_attach_target];
	   var temp_yorig = ds_attach[# prop._yorig, ds_attach_target];   
   
	   //Calculate new origin
	   sys_orig_init(ds_attach, ds_attach_target, argument3, argument4);
   
	   //Get new origin
	   var action_xorig = ds_attach[# prop._xorig, ds_attach_target];
	   var action_yorig = ds_attach[# prop._yorig, ds_attach_target];
   
	   //Restore temp origin values
	   ds_attach[# prop._xorig, ds_attach_target] = temp_xorig;
	   ds_attach[# prop._yorig, ds_attach_target] = temp_yorig;   
   
	   /* SCALING */
   
	   //Backup current scale values to temp variables
	   var temp_xscale = ds_attach[# prop._oxscale, ds_attach_target];
	   var temp_yscale = ds_attach[# prop._oyscale, ds_attach_target];   
   
	   //Calculate new scale
	   sys_scale_init(ds_attach, ds_attach_target, parent_width, parent_height, parent_width, parent_height, argument5);
   
	   //Get new scale
	   var action_xscale = ds_attach[# prop._oxscale, ds_attach_target];
	   var action_yscale = ds_attach[# prop._oyscale, ds_attach_target];
   
	   //Restore temp scale values
	   ds_attach[# prop._oxscale, ds_attach_target] = temp_xscale;
	   ds_attach[# prop._oyscale, ds_attach_target] = temp_yscale;
   
	   /* TRANSITIONS */

	   //Increment transition time
	   if (!sys_action_skip()) {
	      ds_attach[# prop._fade_time, ds_attach_target] += time_frame;
	   } else {
	      //Otherwise skip transition if vngen_do_continue is run
	      ds_attach[# prop._fade_time, ds_attach_target] = argument6;
	   }
   
	   //Mark this action as complete
	   if (ds_attach[# prop._fade_time, ds_attach_target] < 0) or (ds_attach[# prop._fade_time, ds_attach_target] >= argument6) {
	      //Disallow exceeding target values
	      ds_attach[# prop._xorig, ds_attach_target]  = action_xorig;   //Sprite X origin
	      ds_attach[# prop._yorig, ds_attach_target]  = action_yorig;   //Sprite Y origin      
	      ds_attach[# prop._fade_src, ds_attach_target] = -1;           //Fade sprite
	      ds_attach[# prop._fade_alpha, ds_attach_target] = 1;          //Fade alpha
	      ds_attach[# prop._fade_time, ds_attach_target] = argument6;   //Fade time
	      ds_attach[# prop._oxscale, ds_attach_target] = action_xscale; //X scale offset
	      ds_attach[# prop._oyscale, ds_attach_target] = action_yscale; //Y scale offset    
      
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
	if (argument6 > 0) {
	   //Get transition time
	   var action_time = interp(0, 1, ds_attach[# prop._fade_time, ds_attach_target]/argument6, argument7);

	   //Perform attachment replacement
	   ds_attach[# prop._xorig, ds_attach_target] = lerp(ds_attach[# prop._tmp_xorig, ds_attach_target], action_xorig, action_time);      //Sprite X origin
	   ds_attach[# prop._yorig, ds_attach_target] = lerp(ds_attach[# prop._tmp_yorig, ds_attach_target], action_yorig, action_time);      //Sprite Y origin
	   ds_attach[# prop._fade_alpha, ds_attach_target] = lerp(0, 1, action_time);                                                         //Fade alpha
	   ds_attach[# prop._oxscale, ds_attach_target] = lerp(ds_attach[# prop._tmp_oxscale, ds_attach_target], action_xscale, action_time); //X scale offset
	   ds_attach[# prop._oyscale, ds_attach_target] = lerp(ds_attach[# prop._tmp_oyscale, ds_attach_target], action_yscale, action_time); //Y scale offset
	}


}
