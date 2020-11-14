/// @function	vngen_char_replace(name, spr_body, spr_face_idle, spr_face_talk, face_x, face_y, flip, duration, [ease]);
/// @param		{string}		name
/// @param		{sprite}		spr_body
/// @param		{sprite}		spr_face_idle
/// @param		{sprite}		spr_face_talk
/// @param		{real}			face_x
/// @param		{real}			face_y
/// @param		{boolean}		flip
/// @param		{real}			duration
/// @param		{integer|macro}	[ease]
/// @author		Lucas Chasteen <lucas.chasteen@xgasoft.com>
/// @copyright	XGASOFT 2020, All Rights Reserved
function vngen_char_replace() {

	/*
	Applies a new set of sprites to the specified character. As with other modifications, 
	changes to active sprites will persist until the character is removed or another
	replacement is performed.

	Note that unlike other entities, character IDs double as the name which they will
	be referred to as in text events. If highlighting is enabled, this name must match
	the speaker name set in vngen_text_create **exactly**.

	The value -1 is reserved as 'null' and cannot be used as a character ID.

	argument0 = identifier of the character to be modified (string)
	argument1 = the new sprite to use as the character's body (sprite) (required)
	argument2 = the new sprite to use as the character's idle expression (sprite) (optional, use 'previous' for no change or 'none' for none)
	argument3 = the new sprite to use as the character's speaking expression (sprite) (optional, use 'previous' for no change or 'none' for none)
	argument4 = the new horizontal offset to display the character face **relative to the body top-left corner** (real) (optional, use 'previous' for no change)
	argument5 = the new vertical offset to display the character face **relative to the body top-left corner** (real) (optional, use 'previous' for no change)
	argument6 = enables or disables flipping the character for display on opposite sides of the screen (boolean) (true/false)
	argument7 = sets the length of the replacement transition, in seconds (real)
	argument8 = sets the animation easing method (see interp for available modes) (integer) (can also use true/false) (optional, use no argument for none)

	Example usage:
	   vngen_event() {
	      vngen_char_replace("John Doe", spr_body, spr_default, spr_talking, 256, 128, false, 3);
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
	      var ds_target = vngen_get_index(argument[0], vngen_type_char);
         
	      //If the target character exists...
	      if (!is_undefined(ds_target)) {    
      
	         /* INITIALIZATION */
         
	         //Copy existing character to fade surface
	         if (surface_exists(ds_character[# prop._surf, ds_target])) {
	            if (!surface_exists(ds_character[# prop._fade_src, ds_target])) {
	               //Create fade surface
	               ds_character[# prop._fade_src, ds_target] = surface_create(ds_character[# prop._width, ds_target], ds_character[# prop._height, ds_target]);
	            } else {
	               surface_resize(ds_character[# prop._fade_src, ds_target], ds_character[# prop._width, ds_target], ds_character[# prop._height, ds_target]);
	            }
               
	            //Copy contents to fade surface
	            surface_copy(ds_character[# prop._fade_src, ds_target], 0, 0, ds_character[# prop._surf, ds_target]);
      
	            //Resize surface to new dimensions
	            surface_resize(ds_character[# prop._surf, ds_target], sprite_get_width(argument[1]), sprite_get_height(argument[1]));
	         }
         
	         //Clear deform surface to be redrawn, if any
	         if (surface_exists(ds_character[# prop._def_surf, ds_target])) {
	            surface_free(ds_character[# prop._def_surf, ds_target]);
	         }
         
	         //Backup original values to temp value slots
	         ds_character[# prop._tmp_xorig, ds_target] = ds_character[# prop._xorig, ds_target];     //Sprite X origin
	         ds_character[# prop._tmp_yorig, ds_target] = ds_character[# prop._yorig, ds_target];     //Sprite Y origin      
	         ds_character[# prop._tmp_oxscale, ds_target] = ds_character[# prop._oxscale, ds_target]; //X scale offset
         
	         //Get new character idle face, if any
	         if (argument[2] == previous) {
	            var face_idle = ds_character[# prop._sprite2, ds_target];
	         } else {
	            var face_idle = argument[2];
	         }          
         
	         //Get new character speaking face, if any
	         if (argument[3] == previous) {
	            var face_talk = ds_character[# prop._sprite3, ds_target];
	         } else {
	            var face_talk = argument[3];
	         }
         
	         //Get new face coordinates, if any
	         if (argument[4] == previous) {
	            var face_x = ds_character[# prop._face_x, ds_target];
	         } else {
	            var face_x = argument[4];
	         }
	         if (argument[5] == previous) {
	            var face_y = ds_character[# prop._face_y, ds_target];
	         } else {
	            var face_y = argument[5];
	         }  

	         //Set sprite values
	         ds_character[# prop._fade_alpha, ds_target] = 0;								  //Fade alpha     
	         ds_character[# prop._id, ds_target] = argument[0];								  //Name  
	         ds_character[# prop._sprite, ds_target] = argument[1];							  //Body sprite            
	         ds_character[# prop._width, ds_target] = sprite_get_width(argument[1]);		  //Crop width
	         ds_character[# prop._height, ds_target] = sprite_get_height(argument[1]);        //Crop height
		     ds_character[# prop._img_index, ds_target] = 0;                                  //Image index
		     ds_character[# prop._img_num, ds_target] = sprite_get_number(argument[1]);		  //Image total
	         ds_character[# prop._sprite2, ds_target] = face_idle;							  //Face idle sprite
	         ds_character[# prop._sprite3, ds_target] = face_talk;							  //Face talking sprite
	         ds_character[# prop._face_x, ds_target] = face_x;								  //Face x
	         ds_character[# prop._face_y, ds_target] = face_y;							      //Face y     
	         ds_character[# prop._face_time, ds_target] = 0;							      //Face idle pause time
	  
			 //Set character face properties
			 if (sprite_exists(face_idle)) {
			    ds_character[# prop._index, ds_target] = 0;                                   //Face image index   
			    ds_character[# prop._number, ds_target] = sprite_get_number(face_idle);		  //Face image number 
			 }
         
	         //Set transition time
	         if (argument[7] > 0) {
	            ds_character[# prop._fade_time, ds_target] = 0;  //Transition time
	         } else {
	            ds_character[# prop._fade_time, ds_target] = -1; //Transition time
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
	var ds_target = vngen_get_index(argument[0], vngen_type_char);

	//Skip action if target character does not exist
	if (is_undefined(ds_target)) {
	   exit;
	}


	/*
	PERFORM REPLACEMENT
	*/

	if (ds_character[# prop._fade_time, ds_target] < argument[7]) {
	   //Get sprites to check dimensions
	   var action_sprite = ds_character[# prop._sprite, ds_target];
	   var fade_surf = ds_character[# prop._fade_src, ds_target];

	   //Get sprite origins
	   var action_xorig = sprite_get_xoffset(action_sprite);
	   var action_yorig = sprite_get_yoffset(action_sprite);

	   //Get horizontal scale
	   var action_xscale = ds_character[# prop._tmp_oxscale, ds_target];

	   //Flip character, if enabled
	   if (argument[6] == true) {
	      action_xscale *= -1;
	   }

	   //Increment transition time
	   if (!sys_action_skip()) {
	      ds_character[# prop._fade_time, ds_target] += time_frame;
	   } else {
	      //Otherwise skip transition if vngen_do_continue is run
	      ds_character[# prop._fade_time, ds_target] = argument[7];
	   }
   
	   //Mark this action as complete
	   if (ds_character[# prop._fade_time, ds_target] < 0) or (ds_character[# prop._fade_time, ds_target] >= argument[7]) {
	      //Disallow exceeding target values
	      ds_character[# prop._xorig, ds_target] = action_xorig;    //Sprite X origin
	      ds_character[# prop._yorig, ds_target] = action_yorig;    //Sprite Y origin      
	      ds_character[# prop._fade_alpha, ds_target] = 1;          //Fade alpha
	      ds_character[# prop._fade_time, ds_target] = argument[7]; //Fade time
	      ds_character[# prop._oxscale, ds_target] = action_xscale; //X scale offset
      
	      //Clear the fade surface from memory
	      if (!sys_event_skip()) {
	         if (surface_exists(ds_character[# prop._fade_src, ds_target])) {
	            surface_free(ds_character[# prop._fade_src, ds_target]);
	            ds_character[# prop._fade_src, ds_target] = -1;
	         }
      
	         //Clear deform fade surface from memory, if any
	         if (surface_exists(ds_character[# prop._def_fade_surf, ds_target])) {
	            surface_free(ds_character[# prop._def_fade_surf, ds_target]);
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
	if (argument[7] > 0) {
	   //Get ease mode
	   if (argument_count > 8) {
	      var action_ease = argument[8];
	   } else {
	      var action_ease = true;
	   }
   
	   //Get transition time
	   var action_time = interp(0, 1, ds_character[# prop._fade_time, ds_target]/argument[7], action_ease);

	   //Perform character replacement
	   ds_character[# prop._xorig, ds_target] = lerp(ds_character[# prop._tmp_xorig, ds_target], action_xorig, action_time);      //Sprite X origin
	   ds_character[# prop._yorig, ds_target] = lerp(ds_character[# prop._tmp_yorig, ds_target], action_yorig, action_time);      //Sprite Y origin
	   ds_character[# prop._fade_alpha, ds_target] = lerp(0, 1, action_time);                                                     //Fade alpha
	   ds_character[# prop._oxscale, ds_target] = lerp(ds_character[# prop._tmp_oxscale, ds_target], action_xscale, action_time); //X scale offset
	}



}
