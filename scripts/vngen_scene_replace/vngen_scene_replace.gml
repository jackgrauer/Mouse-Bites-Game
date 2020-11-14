/// @function	vngen_scene_replace(id, sprite, duration, [ease]);
/// @param		{real|string}	id
/// @param		{sprite}		sprite
/// @param		{real}			duration
/// @param		{integer|macro}	[ease]
/// @author		Lucas Chasteen <lucas.chasteen@xgasoft.com>
/// @copyright	XGASOFT 2020, All Rights Reserved
function vngen_scene_replace() {

	/*
	Applies a new sprite to the specified scene. As with other modifications, 
	changes to active sprites will persist until the scene is removed 
	or another replacement is performed.

	argument0 = identifier of the scene to be modified (real or string)
	argument1 = the new sprite to apply to the scene (sprite)
	argument2 = sets the length of the replacement transition, in seconds (real)
	argument3 = sets the animation easing method (see interp for available modes) (integer) (can also use true/false) (optional, use no argument for none)

	Example usage:
	   vngen_event() {
	      vngen_scene_replace("scene", spr_bg, 1);
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
	      //Get scene slot
	      var ds_target = vngen_get_index(argument[0], vngen_type_scene);
   
	      //If the target scene exists...
	      if (!is_undefined(ds_target)) {           
      
	         /* INITIALIZATION */
         
	         //Copy existing scene to fade surface
	         if (surface_exists(ds_scene[# prop._surf, ds_target])) {
	            if (!surface_exists(ds_scene[# prop._fade_src, ds_target])) {
	               //Create fade surface
	               ds_scene[# prop._fade_src, ds_target] = surface_create(ds_scene[# prop._width, ds_target], ds_scene[# prop._height, ds_target]);
	            } else {
	               surface_resize(ds_scene[# prop._fade_src, ds_target], ds_scene[# prop._width, ds_target], ds_scene[# prop._height, ds_target]);
	            }
               
	            //Copy contents to fade surface
	            surface_copy(ds_scene[# prop._fade_src, ds_target], 0, 0, ds_scene[# prop._surf, ds_target]);
      
	            //Clear original surface to be redrawn
	            surface_free(ds_scene[# prop._surf, ds_target]);
				ds_scene[# prop._surf, ds_target] = -1;
	         }          
         
	         //Clear deform surface to be redrawn, if any
	         if (surface_exists(ds_scene[# prop._def_surf, ds_target])) {
	            surface_free(ds_scene[# prop._def_surf, ds_target]);
	         }
          
	         //Backup original values to temp value slots
	         ds_scene[# prop._tmp_xorig, ds_target] = ds_scene[# prop._xorig, ds_target]; //Sprite X origin
	         ds_scene[# prop._tmp_yorig, ds_target] = ds_scene[# prop._yorig, ds_target]; //Sprite Y origin    
         
	         //Set sprite values
	         ds_scene[# prop._fade_alpha, ds_target] = 0;                                 //Fade alpha
	         ds_scene[# prop._sprite, ds_target] = argument[1];                           //Sprite                  
	         ds_scene[# prop._width, ds_target] = sprite_get_width(argument[1]);          //Crop width
	         ds_scene[# prop._height, ds_target] = sprite_get_height(argument[1]);        //Crop height   
			 ds_scene[# prop._img_index, ds_target] = 0;								  //Image index
		     ds_scene[# prop._img_num, ds_target] = sprite_get_number(argument[1]);		  //Image number 
      
	         //Set transition time
	         if (argument[2] > 0) {
	            ds_scene[# prop._fade_time, ds_target] = 0;  //Transition time
	         } else {
	            ds_scene[# prop._fade_time, ds_target] = -1; //Transition time
	         }          
	      } else {
	         //Skip action if scene does not exist
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

	//Get scene slot
	var ds_target = vngen_get_index(argument[0], vngen_type_scene);

	//Skip action if target scene does not exist
	if (is_undefined(ds_target)) {
	   exit;
	}


	/*
	PERFORM REPLACEMENT
	*/

	if (ds_scene[# prop._fade_time, ds_target] < argument[2]) {
	   //Get sprites to check dimensions
	   var action_sprite = ds_scene[# prop._sprite, ds_target];
	   var fade_surf = ds_scene[# prop._fade_src, ds_target];

	   //Get sprite origins
	   var action_xorig = sprite_get_xoffset(action_sprite);
	   var action_yorig = sprite_get_yoffset(action_sprite);
   
	   //Increment transition time
	   if (!sys_action_skip()) {
	      ds_scene[# prop._fade_time, ds_target] += time_frame;
	   } else {
	      //Otherwise skip transition if vngen_do_continue is run
	      ds_scene[# prop._fade_time, ds_target] = argument[2];
	   }
   
	   //Mark this action as complete
	   if (ds_scene[# prop._fade_time, ds_target] < 0) or (ds_scene[# prop._fade_time, ds_target] >= argument[2]) {
	      //Disallow exceeding target values
	      ds_scene[# prop._xorig, ds_target] = action_xorig;    //Sprite X origin
	      ds_scene[# prop._yorig, ds_target] = action_yorig;    //Sprite Y origin
	      ds_scene[# prop._fade_alpha, ds_target] = 1;          //Fade alpha
	      ds_scene[# prop._fade_time, ds_target] = argument[2]; //Fade time
      
	      //Clear fade surfaces from memory
	      if (!sys_event_skip()) {
	         if (surface_exists(ds_scene[# prop._fade_src, ds_target])) {
	            surface_free(ds_scene[# prop._fade_src, ds_target]);
	            ds_scene[# prop._fade_src, ds_target] = -1;
	         }
         
	         //Clear deform fade surface from memory, if any
	         if (surface_exists(ds_scene[# prop._def_fade_surf, ds_target])) {
	            surface_free(ds_scene[# prop._def_fade_surf, ds_target]);
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
	   var action_time = interp(0, 1, ds_scene[# prop._fade_time, ds_target]/argument[2], action_ease);

	   //Perform scene replacement
	   ds_scene[# prop._xorig, ds_target] = lerp(ds_scene[# prop._tmp_xorig, ds_target], action_xorig, action_time); //Sprite X origin
	   ds_scene[# prop._yorig, ds_target] = lerp(ds_scene[# prop._tmp_yorig, ds_target], action_yorig, action_time); //Sprite Y origin
	   ds_scene[# prop._fade_alpha, ds_target] = lerp(0, 1, action_time);                                            //Fade alpha
	}


}
