/// @function	sys_layer_draw_emote_legacy();
/// @author		Lucas Chasteen <lucas.chasteen@xgasoft.com>
/// @copyright	XGASOFT 2020, All Rights Reserved
function sys_layer_draw_emote_legacy() {

	/*
	==========================================================================
	SYSTEM FUNCTION: MODIFY AT YOUR OWN RISK!
	--------------------------------------------------------------------------
	  System functions are executed automatically by the engine and typically
	  should not be run manually by the user
	==========================================================================

	Draws emotes with reduced rendering features for performance and compatibility 
	with low-end platforms.

	No parameters
            
	Example usage:
	   sys_layer_draw_emote_legacy();
	*/

	/*
	EMOTES
	*/

	//Skip processing if vngen_object_clear has been run
	if (event_current < 0) {
	   exit;
	}

	//Draw emotes
	var ds_yindex;
	for (ds_yindex = 0; ds_yindex < ds_grid_height(ds_emote); ds_yindex += 1) {
	   //If emote exists...
	   if (ds_emote[# prop._id, ds_yindex] != -1) {
      
	      /* BASE PROPERTIES */
         
	      //Get base emote properties
	      var action_sprite = ds_emote[# prop._sprite, ds_yindex];
	      var action_width = ds_emote[# prop._width, ds_yindex];
	      var action_height = ds_emote[# prop._height, ds_yindex];      
	      var action_xorig = ds_emote[# prop._xorig, ds_yindex];
	      var action_yorig = ds_emote[# prop._yorig, ds_yindex];
	      var action_x = ds_emote[# prop._x, ds_yindex];
	      var action_y = ds_emote[# prop._y, ds_yindex];
	      var action_z = ds_emote[# prop._z, ds_yindex];
	      var action_xscale = ds_emote[# prop._xscale, ds_yindex];
	      var action_yscale = ds_emote[# prop._yscale, ds_yindex];
	      var action_rot = ds_emote[# prop._rot, ds_yindex];
	      var action_col1 = ds_emote[# prop._col1, ds_yindex];
	      var action_col2 = ds_emote[# prop._col2, ds_yindex];
	      var action_col3 = ds_emote[# prop._col3, ds_yindex];
	      var action_col4 = ds_emote[# prop._col4, ds_yindex];
	      var action_alpha = ds_emote[# prop._alpha, ds_yindex];
	  
		  /* SPRITE PROPERTIES */
	  
		  //Get sprite index
		  var action_index = ds_emote[# prop._img_index, ds_yindex];
	  
		  //Animate sprite
		  if (global.vg_pause == false) {
		     ds_emote[# prop._img_index, ds_yindex] += sprite_get_speed_real(action_sprite)*time_offset;
		  }
	  
		  //Loop sprite
		  if (ds_emote[# prop._img_index, ds_yindex] > ds_emote[# prop._img_num, ds_yindex]) {
	         ds_emote[# prop._img_index, ds_yindex] -= ds_emote[# prop._img_num, ds_yindex];
		 
			 //Flag sprite as looped
			 ds_emote[# prop._time, ds_yindex] = 1;
		  }
      
	      /* DRAWING */
      
	      //Get final scale
	      action_xscale = action_xscale*per_zoom_emote;
	      action_yscale = action_yscale*per_zoom_emote; 
            
	      //Get final perspective
	      action_x = ((per_width - (action_x*per_zoom_emote)) + ((per_width*per_zoom_emote) - per_width));
	      action_y = ((per_height - (action_y*per_zoom_emote)) + ((per_height*per_zoom_emote) - per_height));
	      action_z = (per_strength_emote*(per_zoom_emote + ((action_z*-0.01)*per_zoom_emote)));
	      var per_xcenter = per_x + point_rot_x(action_x, action_y, per_rot);
	      var per_ycenter = per_y + point_rot_y(action_x, action_y);             
      
	      //Get final rotation
	      action_rot = per_rot + action_rot;  
	      point_rot_prefetch(action_rot);      
      
	      //Get scaled sprite origin
	      action_xorig = action_xorig*action_xscale;
	      action_yorig = action_yorig*action_yscale;      
      
	      //Get final position
	      action_x = room_xoffset - point_rot_x(action_xorig, action_yorig) - per_xcenter - (action_z*per_xoffset) + per_width;
	      action_y = room_yoffset - point_rot_y(action_xorig, action_yorig) - per_ycenter - (action_z*per_yoffset) + per_height;
      
	      //Record final properties
	      ds_emote[# prop._final_width, ds_yindex] = action_width;
	      ds_emote[# prop._final_height, ds_yindex] = action_height;
	      ds_emote[# prop._final_x, ds_yindex] = action_x;
	      ds_emote[# prop._final_y, ds_yindex] = action_y;
	      ds_emote[# prop._final_xscale, ds_yindex] = action_xscale;
	      ds_emote[# prop._final_yscale, ds_yindex] = action_yscale;
	      ds_emote[# prop._final_rot, ds_yindex] = action_rot;     

	      //Draw emote
	      draw_sprite_general(action_sprite, action_index, 0, 0, action_width, action_height, action_x, action_y, action_xscale, action_yscale, action_rot, action_col1, action_col2, action_col3, action_col4, action_alpha);
	   }
	}


}
