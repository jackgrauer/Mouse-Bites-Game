/// @function	vngen_textbox_replace_ext(id, sprite, xorig, yorig, scaling, duration, ease);
/// @param		{real|string}	id
/// @param		{sprite}		sprite
/// @param		{real|macro}	xorig
/// @param		{real|macro}	yorig
/// @param		{integer|macro}	scaling
/// @param		{real}			duration
/// @param		{integer|macro}	ease
/// @author		Lucas Chasteen <lucas.chasteen@xgasoft.com>
/// @copyright	XGASOFT 2020, All Rights Reserved
function vngen_textbox_replace_ext(argument0, argument1, argument2, argument3, argument4, argument5, argument6) {

	/*
	Applies a new sprite with offset support to the specified textbox. As with other 
	modifications, changes to active sprites will persist until the textbox is removed 
	or another replacement is performed.

	argument0 = identifier of the textbox to be modified (real or string)
	argument1 = the new sprite to apply to the textbox (sprite)
	argument2 = the sprite horizontal offset, or center point (real)
	argument3 = the sprite vertical offset, or center point (real)
	argument4 = sets the scaling mode to perform: scale_none, scale_x_y, scale_x, scale_y, 
	            scale_stretch_x_y, scale_stretch_x, scale_stretch_y, scale_prop_x_y, 
	            scale_prop_x, or scale_prop_y (integer or macro)
	argument5 = sets the length of the replacement transition, in seconds (real)
	argument6 = sets the animation easing method (see interp for available modes) (integer) (can also use true/false)

	Example usage:
	   vngen_event() {
	      vngen_textbox_replace_ext("textbox", spr_new, 0, 0, 5, 1, true);
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
	      //Get textbox slot
	      var ds_target = vngen_get_index(argument0, vngen_type_textbox);
         
	      //If the target textbox exists...
	      if (!is_undefined(ds_target)) {    
	         //Clear deform surface to be redrawn, if any
	         if (surface_exists(ds_textbox[# prop._def_surf, ds_target])) {
	            surface_free(ds_textbox[# prop._def_surf, ds_target]);
	         }                      
                  
	         //Backup original values to temp value slots
	         ds_textbox[# prop._tmp_xorig, ds_target] = ds_textbox[# prop._xorig, ds_target];     //Sprite X origin
	         ds_textbox[# prop._tmp_yorig, ds_target] = ds_textbox[# prop._yorig, ds_target];     //Sprite Y origin
	         ds_textbox[# prop._tmp_oxscale, ds_target] = ds_textbox[# prop._oxscale, ds_target]; //X scale offset
	         ds_textbox[# prop._tmp_oyscale, ds_target] = ds_textbox[# prop._oyscale, ds_target]; //Y scale offset       
            
	         //Set sprite values
	         ds_textbox[# prop._fade_src, ds_target] = ds_textbox[# prop._sprite, ds_target];     //Fade sprite
	         ds_textbox[# prop._fade_alpha, ds_target] = 0;                                       //Fade alpha
	         ds_textbox[# prop._sprite, ds_target] = argument1;                                   //Sprite                 
	         ds_textbox[# prop._width, ds_target] = sprite_get_width(argument1);                  //Crop width
	         ds_textbox[# prop._height, ds_target] = sprite_get_height(argument1);                //Crop height  
		     ds_textbox[# prop._img_index, ds_target] = 0;										  //Image index
		     ds_textbox[# prop._img_num, ds_target] = sprite_get_number(argument1);		          //Image total
         
	         //Set transition time
	         if (argument5 > 0) {
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
	var ds_target = vngen_get_index(argument0, vngen_type_textbox);

	//Skip action if target textbox does not exist
	if (is_undefined(ds_target)) {
	   exit;
	}


	/*
	PERFORM REPLACEMENT
	*/

	if (ds_textbox[# prop._fade_time, ds_target] < argument5) {
	   //Get sprites to check dimensions
	   var action_sprite = ds_textbox[# prop._sprite, ds_target];
	   var fade_sprite = ds_textbox[# prop._fade_src, ds_target];
   
	   /* SPRITE ORIGINS */
   
	   //Backup current origin values to temp variables
	   var temp_xorig = ds_textbox[# prop._xorig, ds_target];
	   var temp_yorig = ds_textbox[# prop._yorig, ds_target];
   
	   //Calculate new origin
	   sys_orig_init(ds_textbox, ds_target, argument2, argument3);
   
	   //Get new origin
	   var action_xorig = ds_textbox[# prop._xorig, ds_target];
	   var action_yorig = ds_textbox[# prop._yorig, ds_target];
   
	   //Restore temp origin values
	   ds_textbox[# prop._xorig, ds_target] = temp_xorig;
	   ds_textbox[# prop._yorig, ds_target] = temp_yorig;

	   /* SCALING */   
   
	   //Backup current scale values to temp variables
	   var temp_xscale = ds_textbox[# prop._oxscale, ds_target];
	   var temp_yscale = ds_textbox[# prop._oyscale, ds_target];
   
	   //Calculate new scale
	   sys_scale_init(ds_textbox, ds_target, global.dp_width, global.dp_height, global.dp_width_init, global.dp_height_init, argument4);
   
	   //Get new scale
	   var action_xscale = ds_textbox[# prop._oxscale, ds_target];
	   var action_yscale = ds_textbox[# prop._oyscale, ds_target];
   
	   //Restore temp scale values
	   ds_textbox[# prop._oxscale, ds_target] = temp_xscale;
	   ds_textbox[# prop._oyscale, ds_target] = temp_yscale;
   
	   /* TRANSITIONS */

	   //Increment transition time
	   if (!sys_action_skip()) {
	      ds_textbox[# prop._fade_time, ds_target] += time_frame;
	   } else {
	      //Otherwise skip transition if vngen_do_continue is run
	      ds_textbox[# prop._fade_time, ds_target] = argument5;
	   }
   
	   //Mark this action as complete
	   if (ds_textbox[# prop._fade_time, ds_target] < 0) or (ds_textbox[# prop._fade_time, ds_target] >= argument5) {
	      //Disallow exceeding target values
	      ds_textbox[# prop._xorig, ds_target] = action_xorig;    //Sprite X origin
	      ds_textbox[# prop._yorig, ds_target] = action_yorig;    //Sprite Y origin      
	      ds_textbox[# prop._fade_src, ds_target] = -1;           //Fade sprite
	      ds_textbox[# prop._fade_alpha, ds_target] = 1;          //Fade alpha
	      ds_textbox[# prop._fade_time, ds_target] = argument5;   //Fade time
	      ds_textbox[# prop._oxscale, ds_target] = action_xscale; //X scale offset
	      ds_textbox[# prop._oyscale, ds_target] = action_yscale; //Y scale offset   
      
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
	if (argument5 > 0) {
	   //Get transition time
	   var action_time = interp(0, 1, ds_textbox[# prop._fade_time, ds_target]/argument5, argument6);

	   //Perform textbox replacement
	   ds_textbox[# prop._xorig, ds_target] = lerp(ds_textbox[# prop._tmp_xorig, ds_target], action_xorig, action_time);      //Sprite X origin
	   ds_textbox[# prop._yorig, ds_target] = lerp(ds_textbox[# prop._tmp_yorig, ds_target], action_yorig, action_time);      //Sprite Y origin
	   ds_textbox[# prop._fade_alpha, ds_target] = lerp(0, 1, action_time);                                                   //Fade alpha
	   ds_textbox[# prop._oxscale, ds_target] = lerp(ds_textbox[# prop._tmp_oxscale, ds_target], action_xscale, action_time); //X scale offset
	   ds_textbox[# prop._oyscale, ds_target] = lerp(ds_textbox[# prop._tmp_oyscale, ds_target], action_yscale, action_time); //Y scale offset
	}



}
