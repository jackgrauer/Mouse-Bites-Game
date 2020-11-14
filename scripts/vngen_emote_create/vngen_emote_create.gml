/// @function	vngen_emote_create(id, sprite, x, y, z, [loop]);
/// @param		{real|string}	id
/// @param		{sprite}		sprite
/// @param		{real}			x
/// @param		{real}			y
/// @param		{real}			z
/// @param		{boolean}		[loop]
/// @author		Lucas Chasteen <lucas.chasteen@xgasoft.com>
/// @copyright	XGASOFT 2020, All Rights Reserved
function vngen_emote_create() {

	/*
	Creates a new emote, or sprite which will be displayed until the sprite animation has 
	completed, at which point the emote will self-destruct. If looped, the emote action will 
	be considered complete instantly and will continue to exist until destroyed manually.

	Emotes are purely decorative and do not affect other entities in any way.

	argument0 = identifier to use for the emote (real or string)
	argument1 = the sprite to use as a new emote (sprite)
	argument2 = the horizontal position to display the emote (real)
	argument3 = the vertical position to display the emote (real)
	argument4 = the drawing depth to display the emote, relative to other emotes only (real)
	argument5 = enables or disables looping the emote animation (boolean) (true/false) (optional, use no argument for false)

	Example usage:
	   vngen_event() {
	      vngen_emote_create("emote1", spr_emote1, 50, 50, -1);
	      vngen_emote_create("emote2", spr_emote2, 50, 50, -1, true);
	   }
	*/

	/*
	INITIALIZATION
	*/

	//Get loop mode
	if (argument_count > 5) {
	   var action_loop = argument[5];
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
	      ds_emote[# prop._id, ds_target] = argument[0];                                           //ID
	      ds_emote[# prop._sprite, ds_target] = argument[1];                                       //Sprite
	      ds_emote[# prop._width, ds_target] = sprite_get_width(argument[1]);                      //Width
	      ds_emote[# prop._height, ds_target] = sprite_get_height(argument[1]);                    //Height
	      ds_emote[# prop._xorig, ds_target] = sprite_get_xoffset(argument[1]);                    //X origin
	      ds_emote[# prop._yorig, ds_target] = sprite_get_yoffset(argument[1]);                    //Y origin  
	      ds_emote[# prop._x, ds_target] = argument[2];                                            //X
	      ds_emote[# prop._y, ds_target] = argument[3];                                            //Y
	      ds_emote[# prop._z, ds_target] = argument[4];                                            //Z
	      ds_emote[# prop._xscale, ds_target] = 1;                                                 //X scale
	      ds_emote[# prop._yscale, ds_target] = 1;                                                 //Y scale
	      ds_emote[# prop._rot, ds_target] = 0;                                                    //Rotation
	      ds_emote[# prop._col1, ds_target] = c_white;                                             //Color1
	      ds_emote[# prop._col2, ds_target] = c_white;                                             //Color2
	      ds_emote[# prop._col3, ds_target] = c_white;                                             //Color3
	      ds_emote[# prop._col4, ds_target] = c_white;                                             //Color4
	      ds_emote[# prop._alpha, ds_target] = 1;                                                  //Alpha
	      ds_emote[# prop._img_index, ds_target] = 0;                                              //Image index
	      ds_emote[# prop._img_num, ds_target] = sprite_get_number(argument[1]);                   //Image total
		  ds_emote[# prop._time, ds_target] = 0;                                                   //Loop count
         
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
