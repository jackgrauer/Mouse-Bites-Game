/// @function	vngen_emote_create_ext(id, sprite, xorig, yorig, x, y, z, xscale, yscale, rot, col1, col2, col3, col4, alpha, [loop]);
/// @param		{real|string}	id
/// @param		{sprite}		sprite
/// @param		{real|macro}	xorig
/// @param		{real|macro}	yorig
/// @param		{real}			x
/// @param		{real}			y
/// @param		{real}			z
/// @param		{real}			xscale
/// @param		{real}			yscale
/// @param		{real}			rot
/// @param		{color}			col1
/// @param		{color}			col2
/// @param		{color}			col3
/// @param		{color}			col4
/// @param		{real}			alpha
/// @param		{boolean}		[loop]
/// @author		Lucas Chasteen <lucas.chasteen@xgasoft.com>
/// @copyright	XGASOFT 2020, All Rights Reserved
function vngen_emote_create_ext() {

	/*
	Creates a new emote, or sprite which will be displayed until the sprite animation has 
	completed, at which point the emote will self-destruct. If looped, the emote action will 
	be considered complete instantly and will continue to exist until destroyed manually.

	Emotes are purely decorative and do not affect other entities in any way.

	argument0  = identifier to use for the emote (real or string)
	argument1  = the sprite to use as a new emote (sprite)
	argument2  = the sprite horizontal offset, or center point (real)
	argument3  = the sprite vertical offset, or center point (real)
	argument4  = the horizontal position to display the emote (real)
	argument5  = the vertical position to display the emote (real)
	argument6  = the drawing depth to display the emote, relative to other emotes only (real)
	argument7  = the horizontal scale multiplier to display the emote (real)
	argument8  = the vertical scale multiplier to display the emote (real)
	argument9  = the rotation value to apply to the emote, in degrees (real)
	argument10 = the color blending value for the top left corner (color)
	argument11 = the color blending value for the top right corner (color)
	argument12 = the color blending value for the bottom right corner (color)
	argument13 = the color blending value for the bottom left corner (color)
	argument14 = the alpha transparency value to display the emote in (real) (0-1)
	argument15 = enables or disables looping the emote animation (boolean) (true/false) (optional, use no argument for false)

	Example usage:
	   vngen_event() {
	      vngen_emote_create_ext("emote1", spr_emote, 0, 0, 50, 50, -1, 1, 1, 0, c_white, c_white, c_white, c_white, 1);
	      vngen_emote_create_ext("emote2", spr_emote, 0, 0, 50, 50, -1, 1, 1, 0, c_white, c_white, c_white, c_white, 1, true);
	   }
	*/

	/*
	INITIALIZATION
	*/

	//Get loop mode
	if (argument_count > 15) {
	   var action_loop = argument[15];
	} else {
	   var action_loop = false;
	}

	//Enable action, if active
	switch (sys_action_init()) {
	   //Exit if event is inactive
	   case false: {
	      exit;
	   }
      
	   //Initialize action if active
	   case true: {
	      //Get the current number of emote entries
	      var ds_target = ds_grid_height(ds_emote);
      
	      //Create new emote slot in data structure
	      ds_grid_resize(ds_emote, ds_grid_width(ds_emote), ds_grid_height(ds_emote) + 1);
   
	      //Set basic emote properties
	      ds_emote[# prop._id, ds_target] = argument[0];                                            //ID
	      ds_emote[# prop._sprite, ds_target] = argument[1];                                        //Sprite
	      ds_emote[# prop._width, ds_target] = sprite_get_width(argument[1]);                       //Width
	      ds_emote[# prop._height, ds_target] = sprite_get_height(argument[1]);                     //Height 
	      ds_emote[# prop._x, ds_target] = argument[4];                                             //X
	      ds_emote[# prop._y, ds_target] = argument[5];                                             //Y
	      ds_emote[# prop._z, ds_target] = argument[6];                                             //Z
	      ds_emote[# prop._xscale, ds_target] = argument[7];                                        //X scale
	      ds_emote[# prop._yscale, ds_target] = argument[8];                                        //Y scale
	      ds_emote[# prop._rot, ds_target] = argument[9];                                           //Rotation
	      ds_emote[# prop._col1, ds_target] = argument[10];                                         //Color1
	      ds_emote[# prop._col2, ds_target] = argument[11];                                         //Color2
	      ds_emote[# prop._col3, ds_target] = argument[12];                                         //Color3
	      ds_emote[# prop._col4, ds_target] = argument[13];                                         //Color4
	      ds_emote[# prop._alpha, ds_target] = argument[14];                                        //Alpha
	      ds_emote[# prop._img_index, ds_target] = 0;                                               //Image index
	      ds_emote[# prop._img_num, ds_target] = sprite_get_number(argument[1]);                    //Image total
		  ds_emote[# prop._time, ds_target] = 0;                                                    //Loop count
      
	      //Set sprite origins
	      sys_orig_init(ds_emote, ds_target, argument[2], argument[3]); 
         
	      //Sort data structure by Z depth
	      ds_grid_sort(ds_emote, prop._z, false);  
	  
		  //Get calculated properties
		  ds_emote[# prop._final_xscale, ds_target] = ds_emote[# prop._xscale, ds_target]*ds_emote[# prop._oxscale, ds_target];
		  ds_emote[# prop._final_yscale, ds_target] = ds_emote[# prop._yscale, ds_target]*ds_emote[# prop._oyscale, ds_target];
		  ds_emote[# prop._final_width, ds_target] = ds_emote[# prop._width, ds_target];
		  ds_emote[# prop._final_height, ds_target] = ds_emote[# prop._height, ds_target];
		  ds_emote[# prop._final_x, ds_target] = ds_emote[# prop._x, ds_target] - (ds_emote[# prop._xorig, ds_target]*ds_emote[# prop._final_xscale, ds_target]);
		  ds_emote[# prop._final_y, ds_target] = ds_emote[# prop._y, ds_target] - (ds_emote[# prop._yorig, ds_target]*ds_emote[# prop._final_yscale, ds_target]);
	  
		  //Mark action as complete immediately, if looped
		  if (action_loop == true) {
			 sys_action_term();
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

	//Get emote slot
	var ds_target = vngen_get_index(argument[0], vngen_type_emote);

	//Skip action if target emote does not exist
	if (is_undefined(ds_target)) {
	   exit;
	}


	/*
	DESTROY EMOTE
	*/

	//If emote is not looped...
	if (action_loop == false) {
	   //Skip animation if vngen_do_continue is run
	   if (sys_action_skip()) {
	      ds_emote[# prop._time, ds_target] = 1;
	   }
   
	   //End action when animation is complete
	   if (ds_emote[# prop._time, ds_target] >= 1) { 
	      //Remove emote from data structure, if not looped
	      ds_emote = sys_grid_delete(ds_emote, ds_target);
      
	      //End action
	      sys_action_term();
	   }
	}


}
