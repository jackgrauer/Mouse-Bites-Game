/// @function	sys_layer_set_target(x, y);
/// @param		{real}	x
/// @param		{real}	y
/// @author		Lucas Chasteen <lucas.chasteen@xgasoft.com>
/// @copyright	XGASOFT 2020, All Rights Reserved
function sys_layer_set_target(argument0, argument1) {

	/*
	==========================================================================
	SYSTEM FUNCTION: MODIFY AT YOUR OWN RISK!
	--------------------------------------------------------------------------
	  System functions are executed automatically by the engine and typically
	  should not be run manually by the user
	==========================================================================

	Initializes perspective and other functions necessary for drawing VNgen layers

	argument0 = horizontal offset for all elements (real)
	argument1 = vertical offset for all elements (real)
          
	Example usage:
	   sys_layer_set_target(view_xview[0], view_yview[0]);
	*/

	/*
	INITIALIZATION
	*/

	//Get global offset
	room_xoffset = argument0;
	room_yoffset = argument1;
			
	//Reset mouse hover state
	mouse_hover = false;

	//Skip processing if vngen_object_clear has been run
	if (event_current < 0) {
	   exit;
	}


	/*
	VISIBILITY
	*/

	if (global.vg_ui_visible == false) {
	   //Fade text elements out, if hidden
	   if (global.vg_ui_alpha > 0) {
	      global.vg_ui_alpha -= 0.1*time_offset;
      
	      //Disallow exceeding minimum value
	      if (global.vg_ui_alpha < 0) {
	         global.vg_ui_alpha = 0;
	      }
	   }
	} else {
	   //Fade text elements in, if shown
	   if (global.vg_ui_alpha < 1) {
	      global.vg_ui_alpha += 0.1*time_offset;
      
	      //Disallow exceeding maximum value
	      if (global.vg_ui_alpha > 1) {
	         global.vg_ui_alpha = 1;
	      }      
	   }
	}


	/*
	PERSPECTIVE
	*/
            
	/* ANIMATIONS */

	//Perform animation, if any
	if (sys_anim_perform(ds_perspective, 0)) {         
	   //Get animation values to apply to scene
	   var per_anim_x = ds_perspective[# prop._anim_x, 0];
	   var per_anim_y = ds_perspective[# prop._anim_y, 0];     
	   var per_anim_xoffset = ds_perspective[# prop._anim_xoffset, 0];
	   var per_anim_yoffset = ds_perspective[# prop._anim_yoffset, 0];          
	   var per_anim_rot = ds_perspective[# prop._anim_rot, 0];     
	   var per_anim_zoom = ds_perspective[# prop._anim_zoom, 0];
	   var per_anim_strength = ds_perspective[# prop._anim_str, 0];
	} else {
	   //Otherwise if no animation is playing, get defaults
	   var per_anim_x = 0;      
	   var per_anim_y = 0;  
	   var per_anim_xoffset = 0;  
	   var per_anim_yoffset = 0;
	   var per_anim_rot = 0;  
	   var per_anim_zoom = 1;  
	   var per_anim_strength = 1;
	}

	//Get perspective values
	per_x = ds_perspective[# prop._x, 0] + per_anim_x;                           //X
	per_y = ds_perspective[# prop._y, 0] + per_anim_y;                           //Y
	per_xoffset = ds_perspective[# prop._xorig, 0] + per_anim_xoffset;           //X offset
	per_yoffset = ds_perspective[# prop._yorig, 0] + per_anim_yoffset;           //Y offset

	per_width = per_x + (ds_perspective[# prop._width, 0]*0.5);                  //Display X center
	per_height = per_y + (ds_perspective[# prop._height, 0]*0.5);                //Display Y center

	per_rot = ds_perspective[# prop._rot, 0] + per_anim_rot;                     //Rotation

	per_strength_fg = ds_perspective[# prop._per_str, 0]*per_anim_strength;      //Strength (foregrounds)
	per_strength_emote = per_strength_fg*0.75;                                   //Strength (emotes)
	per_strength_char = per_strength_fg*0.5;                                     //Strength (characters)
	per_strength_bg = per_strength_fg*0.25;                                      //Strength (backgrounds)

	//Get base zoom
	var per_zoom = (ds_perspective[# prop._per_zoom, 0]*per_anim_zoom) - 1;

	//Clamp zoom to acceptable range
	if (per_zoom < 0) {
	   per_zoom = 0.005;
	}

	//Get layer zoom
	per_zoom_bg = (ds_perspective[# prop._per_zoom, 0]*per_anim_zoom);           //Zoom (backgrounds)
	per_zoom_char = per_zoom_bg + ((per_zoom*1.25)*per_strength_char);           //Zoom (characters)
	per_zoom_emote = per_zoom_bg + ((per_zoom*1.5)*per_strength_emote);          //Zoom (emotes)
	per_zoom_fg = per_zoom_bg + ((per_zoom*1.75)*per_strength_fg);               //Zoom (foregrounds)

	//Record final properties
	ds_perspective[# prop._final_width, 0] = ds_perspective[# prop._width, 0];   //Final Width
	ds_perspective[# prop._final_height, 0] = ds_perspective[# prop._height, 0]; //Final Height
	ds_perspective[# prop._final_x, 0] = argument0 + per_x;                      //Final X
	ds_perspective[# prop._final_y, 0] = argument1 + per_y;                      //Final Y
	ds_perspective[# prop._final_xscale, 0] = 1/per_zoom_bg;                     //Final X scale
	ds_perspective[# prop._final_yscale, 0] = 1/per_zoom_bg;                     //Final Y scale
	ds_perspective[# prop._final_rot, 0] = per_rot;                              //Final Rotation


}
