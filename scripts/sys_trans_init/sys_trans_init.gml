/// @function	sys_trans_init(entity, index, trans, duration, reverse);
/// @param		{integer}	entity
/// @param		{integer}	index
/// @param		{script}	trans
/// @param		{real}		duration
/// @param		{boolean}	reverse
/// @author		Lucas Chasteen <lucas.chasteen@xgasoft.com>
/// @copyright	XGASOFT 2020, All Rights Reserved
function sys_trans_init(argument0, argument1, argument2, argument3, argument4) {

	/*
	==========================================================================
	SYSTEM FUNCTION: MODIFY AT YOUR OWN RISK!
	--------------------------------------------------------------------------
	  System functions are executed automatically by the engine and typically
	  should not be run manually by the user
	==========================================================================

	Initializes a transition to be performed on compatible entities when created
	or destroyed.

	VNgen's handling of this functionality is highly tailored for its particular
	use-cases and is not intended for general use.

	argument0 = the data structure for the entity to apply transition to (integer)
	argument1 = the index of the row containing the target entity ID (integer)
	argument2 = sets the transition script to perform (script) (optional, use 'trans_none' for none)
	argument3 = sets the length of the **entire transition**, in seconds (real)
	argument4 = enables or disables performing the transition in reverse keyframe order (boolean) (true/false)

	Example usage:
	   sys_trans_init(ds_data, ds_target, trans_fade, 5, false);
	*/

	/*
	INITIALIZATION
	*/

	//Get the target data structure
	var ds_data = argument0;
	var ds_target = argument1;


	/*
	INITIALIZE TRANSITION
	*/

	//Clear temp transition values
	ds_data[# prop._trans_tmp_left, ds_target] = 0;
	ds_data[# prop._trans_tmp_top, ds_target] = 0;
	ds_data[# prop._trans_tmp_width, ds_target] = 0;
	ds_data[# prop._trans_tmp_height, ds_target] = 0;
	ds_data[# prop._trans_tmp_x, ds_target] = 0;
	ds_data[# prop._trans_tmp_y, ds_target] = 0;
	ds_data[# prop._trans_tmp_xscale, ds_target] = 1;
	ds_data[# prop._trans_tmp_yscale, ds_target] = 1;
	ds_data[# prop._trans_tmp_rot, ds_target] = 0;
	ds_data[# prop._trans_tmp_alpha, ds_target] = 1;   

	//Initialize transition
	ds_data[# prop._trans, ds_target] = argument2;                //Transition script
	ds_data[# prop._trans_key, ds_target] = 0;                    //Starting keyframe
	ds_data[# prop._trans_dur, ds_target] = max(0.01, argument3); //Duration
	ds_data[# prop._trans_rev, ds_target] = argument4;            //Reverse
	ds_data[# prop._trans_left, ds_target] = 0;                   //Left   
	ds_data[# prop._trans_top, ds_target] = 0;                    //Top
	ds_data[# prop._trans_width, ds_target] = 0;                  //Width
	ds_data[# prop._trans_height, ds_target] = 0;                 //Height
	ds_data[# prop._trans_x, ds_target] = 0;                      //X
	ds_data[# prop._trans_y, ds_target] = 0;                      //Y
	ds_data[# prop._trans_xscale, ds_target] = 1;                 //X scale
	ds_data[# prop._trans_yscale, ds_target] = 1;                 //Y scale
	ds_data[# prop._trans_rot, ds_target] = 0;                    //Rotation
	ds_data[# prop._trans_alpha, ds_target] = 1;                  //Alpha
	ds_data[# prop._trans_time, ds_target] = 0;                   //Time

	//If the target transition exists...
	if (script_exists(argument2)) {   
	   //Set starting keyframe values for forward transitions
	   if (ds_data[# prop._trans_rev, ds_target] == false) {
	      //Clear previous keyframe values
	      trans_left = 0;
	      trans_top = 0;
	      trans_width = 0;
	      trans_height = 0; 
	      trans_x = 0;
	      trans_y = 0;
	      trans_xscale = 1;
	      trans_yscale = 1; 
	      trans_rot = 0;
	      trans_alpha = 1;
	      trans_ease = 0;
            
	      //Get dimensions to pass into scripts
	      input_width = ds_data[# prop._width, ds_target];
	      input_height = ds_data[# prop._height, ds_target];
	      input_x = ds_data[# prop._x, ds_target];
	      input_y = ds_data[# prop._y, ds_target];
	      input_xscale = ds_data[# prop._xscale, ds_target]*ds_data[# prop._oxscale, ds_target];
	      input_yscale = ds_data[# prop._yscale, ds_target]*ds_data[# prop._oyscale, ds_target];
	      input_rot = ds_data[# prop._rot, ds_target];
      
	      //Reset keyframe ID tracking
	      keyframe_id = -1;
      
	      //Get current keyframe
	      keyframe_current = 0;
            
	      //Get transition keyframe data
	      script_execute(argument2);
      
	      //Set starting transition values
	      ds_data[# prop._trans_key, ds_target] = 1;                                            //Keyframe
	      ds_data[# prop._trans_left, ds_target] = clamp(trans_left, 0, input_width - 1);       //Left
	      ds_data[# prop._trans_top, ds_target] = clamp(trans_top, 0, input_height - 1);        //Top
	      ds_data[# prop._trans_width, ds_target] = clamp(trans_width, -input_width + 1, 0);    //Width
	      ds_data[# prop._trans_height, ds_target] = clamp(trans_height, -input_height + 1, 0); //Height
	      ds_data[# prop._trans_x, ds_target] = trans_x;                                        //X
	      ds_data[# prop._trans_y, ds_target] = trans_y;                                        //Y
	      ds_data[# prop._trans_xscale, ds_target] = trans_xscale;                              //X scale
	      ds_data[# prop._trans_yscale, ds_target] = trans_yscale;                              //Y scale
	      ds_data[# prop._trans_rot, ds_target] = trans_rot;                                    //Rotation
	      ds_data[# prop._trans_alpha, ds_target] = trans_alpha;                                //Alpha
      
	      //Update transition temp values
	      ds_data[# prop._trans_tmp_left, ds_target] = ds_data[# prop._trans_left, ds_target];     //Left
	      ds_data[# prop._trans_tmp_top, ds_target] = ds_data[# prop._trans_top, ds_target];       //Top
	      ds_data[# prop._trans_tmp_width, ds_target] = ds_data[# prop._trans_width, ds_target];   //Width
	      ds_data[# prop._trans_tmp_height, ds_target] = ds_data[# prop._trans_height, ds_target]; //Height
	      ds_data[# prop._trans_tmp_x, ds_target] = ds_data[# prop._trans_x, ds_target];           //X
	      ds_data[# prop._trans_tmp_y, ds_target] = ds_data[# prop._trans_y, ds_target];           //Y
	      ds_data[# prop._trans_tmp_xscale, ds_target] = ds_data[# prop._trans_xscale, ds_target]; //X scale
	      ds_data[# prop._trans_tmp_yscale, ds_target] = ds_data[# prop._trans_yscale, ds_target]; //Y scale
	      ds_data[# prop._trans_tmp_rot, ds_target] = ds_data[# prop._trans_rot, ds_target];       //Rotation
	      ds_data[# prop._trans_tmp_alpha, ds_target] = ds_data[# prop._trans_alpha, ds_target];   //Alpha  
      
	   //Get starting keyframe values for reverse transitions          
	   } else {
	      //Reset keyframe ID tracking
	      keyframe_id = -1;
	      keyframe_current = -2;
            
	      //Get transition keyframe data
	      script_execute(argument2);
      
	      //Set starting keyframe
	      ds_data[# prop._trans_key, ds_target] = keyframe_id; //Keyframe
	   }
	}


}
