/// @function	vngen_option_create_ext(id, text, sprite, spr_hover, spr_select, xorig, yorig, x, y, z, tx, ty, scaling, font, color, trans_in, trans_out, duration, ease);
/// @param		{real|string}	id
/// @param		{string}		text
/// @param		{sprite}		sprite
/// @param		{sprite}		spr_hover
/// @param		{sprite}		spr_select
/// @param		{real|macro}	xorig
/// @param		{real|macro}	yorig
/// @param		{real}			x
/// @param		{real}			y
/// @param		{real}			z
/// @param		{real|macro}	tx
/// @param		{real|macro}	ty
/// @param		{integer|macro}	scaling
/// @param		{font}			font
/// @param		{color}			color
/// @param		{script}		trans_in
/// @param		{script}		trans_out
/// @param		{real}			duration
/// @param		{integer|macro}	ease
/// @author		Lucas Chasteen <lucas.chasteen@xgasoft.com>
/// @copyright	XGASOFT 2020, All Rights Reserved
function vngen_option_create_ext() {

	/*
	Creates a new option which will be displayed until any option in the current code block 
	has been selected, at which point all options will self-destruct. The option ID will be
	recorded as the selected choice.

	Options can selected by mouse/touch, or by other input devices with vngen_do_option_nav
	and vngen_do_option_select. Option z-index determines navigation order, where lower z-index
	equals lower in the list of options. If z-index is equal between two or more options, 
	navigation order will automatically be set by **reverse** creation order, but this may 
	or may not be visually correct.

	Options are displayed in three states: default, hovered, and selected. While it is
	required to supply a default sprite, hover and selected sprites are optional and can
	be disabled by supplying -1 instead.

	Note that each option is displayed relative to the offset set in vngen_option, while
	option text is displayed relative to the option itself.

	Also note that the value -1 is reserved as 'null' and cannot be used as an option ID.

	argument0  = identifier to use for the option (real or string)
	argument1  = the option text to be displayed (string)
	argument2  = the sprite to use as an option background (sprite) (required)
	argument3  = the sprite to use as a hovered option background (sprite) (optional, use 'none' for none)
	argument4  = the sprite to use as a selected option background (sprite) (optional, use 'none' for none)
	argument5  = the sprite horizontal offset, or center point (real)
	argument6  = the sprite vertical offset, or center point (real)
	argument7  = the horizontal position to display the option, **relative to the global option offset** (real)
	argument8  = the vertical position to display the option, **relative to the global option offset** (real)
	argument9  = the drawing depth to display the option, relative to other options only (real)
	argument10 = the horizontal position to display option text, **relative to the option background** (real) (optional, use 'auto' for center)
	argument11 = the vertical position to display option text, **relative to the option background** (real) (optional, use 'auto' for center)
	argument12 = sets the scaling mode to perform: scale_none, scale_x_y, scale_x, scale_y, 
	             scale_stretch_x_y, scale_stretch_x, scale_stretch_y, scale_prop_x_y, 
	             scale_prop_x, or scale_prop_y (integer or macro)
	argument13 = sets the option text font family to be drawn (font)
	argument14 = sets the default option text color(color)
	argument15 = sets the transition in script to perform (script) (optional, use 'none' for none)
	argument16 = sets the transition out script to perform (script) (optional, use 'none' for none)
	argument17 = sets the length of the transition, in seconds (real)
	argument18 = sets the transition easing override (see interp for available modes) (integer) (can also use true/false)

	Example usage:
	   if vngen_event() {
	      if vngen_option("options", 0, 0, 0.5, 0.5, snd_hover, snd_select) {
	         vngen_option_create("op1", "Option 1", spr_option, spr_option_hover, spr_option_select, 0, 0, -256, 0, -1, 72, 16, 0, fnt_Arial, c_white, trans_fade, trans_fade, 1, true);
	         vngen_option_create("op2", "Option 2", spr_option, spr_option_hover, spr_option_select, 0, 0, -256, 50, -2, 72, 16, 0, fnt_Arial, c_white, trans_fade, trans_fade, 1, true);
	      }

	      switch (vngen_get_option()) {
	         case "op1": //Action; break;
	         case "op2": //Action; break;
	      }
	   }
	*/

	/*
	INITIALIZATION
	*/

	//Enable option, if active
	switch (sys_option_init()) {
	   //Exit if option is inactive
	   case false: {
	      exit;
	   }
   
	   //Initialize option if active
	   case true: {
	      //Get the current number of option entries
	      var ds_target = ds_grid_height(ds_option);
      
	      //Create new option slot in data structure
	      ds_grid_resize(ds_option, ds_grid_width(ds_option), ds_grid_height(ds_option) + 1);
	      option_count = ds_target + 1;
   
	      //Get text position
	      draw_set_font(argument[13]);
		  var text_xorig = argument[10];
		  var text_yorig = argument[11];
	  
		  //Use auto text position, if enabled
		  if (argument[10] == auto) or (argument[11] == auto) {
		     text_xorig = (sprite_get_width(argument[2])*0.5) - (string_width(argument[1])*0.5);
	         text_yorig = (sprite_get_height(argument[2])*0.5) - (string_height(argument[1])*0.5);
		  }
	      draw_set_font(fnt_default);
      
	      //Set basic option properties
	      ds_option[# prop._id, ds_target] = argument[0];								//ID
	      ds_option[# prop._sprite, ds_target] = argument[2];							//Sprite
	      ds_option[# prop._left, ds_target] = 0;										//Crop left
	      ds_option[# prop._top, ds_target] = 0;										//Crop top
	      ds_option[# prop._width, ds_target] = sprite_get_width(argument[2]);			//Crop width
	      ds_option[# prop._height, ds_target] = sprite_get_height(argument[2]);		//Crop height    
	      ds_option[# prop._x, ds_target] = argument[7];								//X
	      ds_option[# prop._y, ds_target] = argument[8];								//Y
	      ds_option[# prop._z, ds_target] = argument[9];								//Z
	      ds_option[# prop._xscale, ds_target] = 1;										//X scale
	      ds_option[# prop._yscale, ds_target] = 1;										//Y scale
	      ds_option[# prop._rot, ds_target] = 0;										//Rotation
	      ds_option[# prop._col1, ds_target] = argument[14];							//Text color
	      ds_option[# prop._alpha, ds_target] = 1;										//Alpha
	      ds_option[# prop._img_index, ds_target] = 0;                                  //Image index
	      ds_option[# prop._img_num, ds_target] = sprite_get_number(argument[2]);       //Image total
	      ds_option[# prop._sprite2, ds_target] = argument[3];							//Hover sprite
	      ds_option[# prop._sprite3, ds_target] = argument[4];							//Select sprite
	      ds_option[# prop._txt_x, ds_target] = text_xorig;								//Text x
	      ds_option[# prop._txt_y, ds_target] = text_yorig;								//Text y
	      ds_option[# prop._number, ds_target] = ds_target + 1;							//Option number
	      ds_option[# prop._surf, ds_target] = -1;										//Text surface
	      ds_option[# prop._txt_fnt, ds_target] = argument[13];							//Text font
		  ds_option[# prop._txt_line_height, ds_target] = global.vg_lineheight_text;	//Text lineheight
	      ds_option[# prop._txt, ds_target] = argument[1];								//Text string  
	      ds_option[# prop._trigger, ds_target] = -1;									//Trigger state
      
	      //Set special option properties
	      ds_option[# prop._fade_src, ds_target] = -1;                //Fade sprite   
	      ds_option[# prop._fade_alpha, ds_target] = 1;               //Fade alpha
	      ds_option[# prop._trans, ds_target] = -1;                   //Transition
	      ds_option[# prop._shader, ds_target] = -1;                  //Shader
	      ds_option[# prop._sh_float_data, ds_target] = -1;           //Shader float data
	      ds_option[# prop._sh_mat_data, ds_target] = -1;             //Shader matrix data
	      ds_option[# prop._sh_samp_data, ds_target] = -1;            //Shader sampler data
	      ds_option[# prop._anim, ds_target] = -1;                    //Animation
	      ds_option[# prop._anim_xscale, ds_target] = 1;              //Animation X scale
	      ds_option[# prop._anim_yscale, ds_target] = 1;              //Animation Y scale
	      ds_option[# prop._anim_alpha, ds_target] = 1;               //Animation alpha
	      ds_option[# prop._def, ds_target] = -1;                     //Deformation
	      ds_option[# prop._def_point_data, ds_target] = -1;          //Deform point data
	      ds_option[# prop._def_surf, ds_target] = -1;                //Deform surface
	      ds_option[# prop._def_fade_surf, ds_target] = -1;           //Deform fade surface
      
	      //Set default properties
	      ds_option[# prop._init_x, ds_target] = argument[7];         //Initial X
	      ds_option[# prop._init_y, ds_target] = argument[8];         //Initial Y
	      ds_option[# prop._init_xscale, ds_target] = 1;              //Initial X scale
	      ds_option[# prop._init_yscale, ds_target] = 1;              //Initial Y scale
      
	      //Set hover properties
	      ds_option[# prop._anim_tmp_col1, ds_target] = argument[14]; //Hover text color
	      ds_option[# prop._anim_tmp_x, ds_target] = argument[7];     //Hover X
	      ds_option[# prop._anim_tmp_y, ds_target] = argument[8];     //Hover Y
	      ds_option[# prop._anim_tmp_xscale, ds_target] = 1;          //Hover X scale
	      ds_option[# prop._anim_tmp_yscale, ds_target] = 1;          //Hover Y scale
      
	      //Set select properties
	      ds_option[# prop._anim_col1, ds_target] = argument[14];     //Select text color
	      ds_option[# prop._anim_x, ds_target] = argument[7];         //Select X
	      ds_option[# prop._anim_y, ds_target] = argument[8];         //Select Y
	      ds_option[# prop._anim_xscale, ds_target] = 1;              //Select X scale
	      ds_option[# prop._anim_yscale, ds_target] = 1;              //Select Y scale
      
	      //Get animation duration from select sprite, if any
	      var action_dur = time_target;
	      if (sprite_exists(argument[4])) {
	         action_dur *= sprite_get_number(argument[4]);
	      }
      
	      //Set timing properties
	      ds_option[# prop._anim_time, ds_target] = 0;                //Animation time
	      ds_option[# prop._anim_dur, ds_target] = action_dur;        //Animation duration
	      ds_option[# prop._anim_ease, ds_target] = argument[18];     //Animation ease
      
	      //Set texture origin points
	      sys_orig_init(ds_option, ds_target, argument[5], argument[6]);   
         
	      //Initialize scaling
	      sys_scale_init(ds_option, ds_target, global.dp_width, global.dp_height, global.dp_width_init, global.dp_height_init, argument[12]);
      
	      //Initialize transitions
	      sys_trans_init(ds_option, ds_target, argument[15], argument[17], false);
      
	      //Sort data structure by Z depth
	      ds_grid_sort(ds_option, prop._z, false);
	  
		  //Get calculated properties
		  ds_option[# prop._final_xscale, ds_target] = ds_option[# prop._xscale, ds_target]*ds_option[# prop._oxscale, ds_target];
		  ds_option[# prop._final_yscale, ds_target] = ds_option[# prop._yscale, ds_target]*ds_option[# prop._oyscale, ds_target];
		  ds_option[# prop._final_width, ds_target] = ds_option[# prop._width, ds_target];
		  ds_option[# prop._final_height, ds_target] = ds_option[# prop._height, ds_target];
		  ds_option[# prop._final_x, ds_target] = ds_option[# prop._x, ds_target] - (ds_option[# prop._xorig, ds_target]*ds_option[# prop._final_xscale, ds_target]);
		  ds_option[# prop._final_y, ds_target] = ds_option[# prop._y, ds_target] - (ds_option[# prop._yorig, ds_target]*ds_option[# prop._final_yscale, ds_target]);
	   }
	}


	/*
	DATA MANAGEMENT
	*/

	//Skip action if engine is paused
	if (global.vg_pause == true) {
	   exit;
	}

	//Get option slot
	var ds_target = vngen_get_index(argument[0], vngen_type_option);

	//Skip action if target text does not exist
	if (is_undefined(ds_target)) {
	   exit;
	}


	/*
	PERFORM TRANSITIONS IN
	*/

	if (option_result == -1) {
	   //Perform transitions
	   if (ds_option[# prop._trans_time, ds_target] < ds_option[# prop._trans_dur, ds_target]) {
	      sys_trans_perform(ds_option, ds_target, argument[18]);
	   }
	} 


	/* 
	PERFORM TRANSITIONS OUT
	*/

	if (option_result != -1) or (sys_event_skip()) {   
	   if (option_pause <= 0) {
	      //Initialize transitions out
	      if (ds_option[# prop._trans_rev, ds_target] == false) {
	         sys_trans_init(ds_option, ds_target, argument[16], argument[17], true);   
	      }
      
	      //Perform transitions
	      if (ds_option[# prop._trans_time, ds_target] < ds_option[# prop._trans_dur, ds_target]) {
	         sys_trans_perform(ds_option, ds_target, argument[18]);
         
      
	         /*
	         FINALIZATION
	         */
    
	         if (ds_option[# prop._trans_time, ds_target] >= ds_option[# prop._trans_dur, ds_target]) {
	            //Add option to the backlog for the current event, if event skip is inactive
	            if (!sys_event_skip()) {
	               //Get the option selected status
	               if (option_result == argument[0]) {
	                  var status = "(*) ";
	               } else {
	                  var status = "";
	               }
         
	               //Add option to backlog
				   if (argument[1] != "") {
					  vngen_log_add(auto, "   " + string(ds_option[# prop._number, ds_target]) + ") " + status + argument[1], "", argument[13], argument[14], argument[14], argument[14], argument[14], none, none, fa_left, ds_option[# prop._txt_line_height, ds_target]);
				   }
	            }
         
	            //Clear text surface from data structure
	            if (surface_exists(ds_option[# prop._surf, ds_target])) {
	               surface_free(ds_option[# prop._surf, ds_target]);
	            }
   
	            //Remove option from data structure
	            ds_option = sys_grid_delete(ds_option, ds_target);
	         }
	      }
	   }
	}



}
