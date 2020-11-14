/// @function	vngen_button_create_ext(id, text, sprite, spr_hover, spr_select, xorig, yorig, x, y, z, tx, ty, scaling, font, color, snd_hover, snd_select, transition, duration, ease);
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
/// @param		{sound}			snd_hover
/// @param		{sound}			snd_select
/// @param		{script}		transition
/// @param		{real}			duration
/// @param		{integer|macro}	ease
/// @author		Lucas Chasteen <lucas.chasteen@xgasoft.com>
/// @copyright	XGASOFT 2020, All Rights Reserved
function vngen_button_create_ext() {

	/*
	Creates a new button which will be displayed until vngen_button_destroy is run.
	Buttons can be used to execute arbitrary code through object events in response to 
	mouse or touch input. Other input devices can activate buttons directly with 
	vngen_do_button_nav and vngen_do_button_select.

	Multiple buttons can exist simultaneously, however be aware that no two buttons
	can share the same ID. The button ID, or name, is arbitrary and can be either a
	number or a string. Note that the value -1 is reserved as 'null' and cannot be used 
	as a button ID.

	argument0  = identifier to use for the button (real or string)
	argument1  = the button text to be displayed (string)
	argument2  = the sprite to use as a button background (sprite) (required)
	argument3  = the sprite to use as a hovered button background (sprite) (optional, use 'none' for none)
	argument4  = the sprite to use as a selected button background (sprite) (optional, use 'none' for none)
	argument5  = the sprite horizontal offset, or center point (real)
	argument6  = the sprite vertical offset, or center point (real)
	argument7  = the horizontal position to display the button (real)
	argument8  = the vertical position to display the button (real)
	argument9  = the drawing depth to display the button, relative to other buttons only (real)
	argument10 = the horizontal position to display button text, **relative to the button background** (real) (optional, use 'auto' for center)
	argument11 = the vertical position to display button text, **relative to the button background** (real) (optional, use 'auto' for center)
	argument12 = sets the scaling mode to perform: scale_none, scale_x_y, scale_x, scale_y, 
	             scale_stretch_x_y, scale_stretch_x, scale_stretch_y, scale_prop_x_y, 
	             scale_prop_x, or scale_prop_y (integer or macro)
	argument13 = sets the button text font family to be drawn (font)
	argument14 = sets the default button text color (color)
	argument15 = sets the sound to be played when hovered (sound) (optional, use 'none' for none)
	argument16 = sets the sound to be played when selected (sound) (optional, use 'none' for none)
	argument17 = sets the transition script to perform (script) (optional, use 'trans_none' for none)
	argument18 = sets the length of the transition, in seconds (real)
	argument19 = sets the transition easing override (see interp for available modes) (integer) (can also use true/false) (optional, use no argument for none)

	Example usage:
	   vngen_event() {
	      vngen_button_create("btn", "Click me!", spr_btn, spr_btn_hover, spr_btn_select, 0, 0, 256, 512, 0, 72, 16, 0, fnt_Arial, c_white, snd_hover, snd_select, trans_fade, 3, true);
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
	      //Get the current number of button entries
	      var ds_target = ds_grid_height(ds_button);
      
	      //Create new button slot in data structure
	      ds_grid_resize(ds_button, ds_grid_width(ds_button), ds_grid_height(ds_button) + 1);
	      button_count = ds_target + 1;
   
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
      
	      //Set basic button properties
	      ds_button[# prop._id, ds_target] = argument[0];								//ID
	      ds_button[# prop._sprite, ds_target] = argument[2];							//Sprite
	      ds_button[# prop._left, ds_target] = 0;										//Crop left
	      ds_button[# prop._top, ds_target] = 0;										//Crop top
	      ds_button[# prop._width, ds_target] = sprite_get_width(argument[2]);			//Crop width
	      ds_button[# prop._height, ds_target] = sprite_get_height(argument[2]);		//Crop height
	      ds_button[# prop._x, ds_target] = argument[7];								//X
	      ds_button[# prop._y, ds_target] = argument[8];								//Y
	      ds_button[# prop._z, ds_target] = argument[9];								//Z
	      ds_button[# prop._xscale, ds_target] = 1;										//X scale
	      ds_button[# prop._yscale, ds_target] = 1;										//Y scale
	      ds_button[# prop._rot, ds_target] = 0;										//Rotation
	      ds_button[# prop._col1, ds_target] = argument[14];							//Text color
	      ds_button[# prop._alpha, ds_target] = 1;										//Alpha
	      ds_button[# prop._img_index, ds_target] = 0;                                  //Image index
	      ds_button[# prop._img_num, ds_target] = sprite_get_number(argument[2]);       //Image total
	      ds_button[# prop._sprite2, ds_target] = argument[3];							//Hover sprite
	      ds_button[# prop._sprite3, ds_target] = argument[4];							//Select sprite 
	      ds_button[# prop._txt_x, ds_target] = text_xorig;								//Text x
	      ds_button[# prop._txt_y, ds_target] = text_yorig;								//Text y
	      ds_button[# prop._surf, ds_target] = -1;										//Text surface
	      ds_button[# prop._txt_fnt, ds_target] = argument[13];							//Text font
		  ds_button[# prop._txt_line_height, ds_target] = global.vg_lineheight_text;	//Text lineheight
	      ds_button[# prop._txt, ds_target] = argument[1];								//Text string 
	      ds_button[# prop._trigger, ds_target] = -1;									//Trigger state
	      ds_button[# prop._snd_hover, ds_target] = argument[15];						//Hover sound
	      ds_button[# prop._snd_select, ds_target] = argument[16];						//Select sound
      
	      //Set special button properties
	      ds_button[# prop._fade_src, ds_target] = -1;                //Fade sprite   
	      ds_button[# prop._fade_alpha, ds_target] = 1;               //Fade alpha
	      ds_button[# prop._trans, ds_target] = -1;                   //Transition
	      ds_button[# prop._shader, ds_target] = -1;                  //Shader
	      ds_button[# prop._sh_float_data, ds_target] = -1;           //Shader float data
	      ds_button[# prop._sh_mat_data, ds_target] = -1;             //Shader matrix data
	      ds_button[# prop._sh_samp_data, ds_target] = -1;            //Shader sampler data
	      ds_button[# prop._anim, ds_target] = -1;                    //Animation
	      ds_button[# prop._anim_xscale, ds_target] = 1;              //Animation X scale
	      ds_button[# prop._anim_yscale, ds_target] = 1;              //Animation Y scale
	      ds_button[# prop._anim_alpha, ds_target] = 1;               //Animation alpha
	      ds_button[# prop._def, ds_target] = -1;                     //Deformation
	      ds_button[# prop._def_point_data, ds_target] = -1;          //Deform point data
	      ds_button[# prop._def_surf, ds_target] = -1;                //Deform surface
	      ds_button[# prop._def_fade_surf, ds_target] = -1;           //Deform fade surface
   
	      //Set default properties
	      ds_button[# prop._init_x, ds_target] = argument[7];         //Initial X
	      ds_button[# prop._init_y, ds_target] = argument[8];         //Initial Y
	      ds_button[# prop._init_xscale, ds_target] = 1;              //Initial X scale
	      ds_button[# prop._init_yscale, ds_target] = 1;              //Initial Y scale
      
	      //Set hover properties
	      ds_button[# prop._anim_tmp_col1, ds_target] = argument[14]; //Hover text color
	      ds_button[# prop._anim_tmp_x, ds_target] = argument[7];     //Hover X
	      ds_button[# prop._anim_tmp_y, ds_target] = argument[8];     //Hover Y
	      ds_button[# prop._anim_tmp_xscale, ds_target] = 1;          //Hover X scale
	      ds_button[# prop._anim_tmp_yscale, ds_target] = 1;          //Hover Y scale
      
	      //Set select properties
	      ds_button[# prop._anim_col1, ds_target] = argument[14];     //Select text color
	      ds_button[# prop._anim_x, ds_target] = argument[7];         //Select X
	      ds_button[# prop._anim_y, ds_target] = argument[8];         //Select Y
	      ds_button[# prop._anim_xscale, ds_target] = 1;              //Select X scale
	      ds_button[# prop._anim_yscale, ds_target] = 1;              //Select Y scale
      
	      //Get animation duration from select sprite, if any
	      var action_dur = time_target;
	      if (sprite_exists(argument[4])) {
	         action_dur *= sprite_get_number(argument[4]);
	      }
      
	      //Set timing properties
	      ds_button[# prop._anim_time, ds_target] = 0;                //Animation time
	      ds_button[# prop._anim_dur, ds_target] = action_dur;        //Animation duration
	      ds_button[# prop._anim_ease, ds_target] = argument[19];     //Animation ease
      
	      //Set texture origin points
	      sys_orig_init(ds_button, ds_target, argument[5], argument[6]);   
      
	      //Initialize scaling
	      sys_scale_init(ds_button, ds_target, global.dp_width, global.dp_height, global.dp_width_init, global.dp_height_init, argument[12]);
      
	      //Initialize transitions
	      sys_trans_init(ds_button, ds_target, argument[17], argument[18], false);
      
	      //Sort data structure by Z depth
	      ds_grid_sort(ds_button, prop._z, false);  
	  
		  //Get calculated properties
		  ds_button[# prop._final_xscale, ds_target] = ds_button[# prop._xscale, ds_target]*ds_button[# prop._oxscale, ds_target];
		  ds_button[# prop._final_yscale, ds_target] = ds_button[# prop._yscale, ds_target]*ds_button[# prop._oyscale, ds_target];
		  ds_button[# prop._final_width, ds_target] = ds_button[# prop._width, ds_target];
		  ds_button[# prop._final_height, ds_target] = ds_button[# prop._height, ds_target];
		  ds_button[# prop._final_x, ds_target] = ds_button[# prop._x, ds_target] - (ds_button[# prop._xorig, ds_target]*ds_button[# prop._final_xscale, ds_target]);
		  ds_button[# prop._final_y, ds_target] = ds_button[# prop._y, ds_target] - (ds_button[# prop._yorig, ds_target]*ds_button[# prop._final_yscale, ds_target]);
	   }
	}


	/*
	DATA MANAGEMENT
	*/

	//Get button slot
	var ds_target = vngen_get_index(argument[0], vngen_type_button);

	//Skip action if target button does not exist
	if (is_undefined(ds_target)) {
	   exit;
	}


	/*
	PERFORM TRANSITIONS
	*/

	//Perform transitions
	if (ds_button[# prop._trans_time, ds_target] < ds_button[# prop._trans_dur, ds_target]) {
	   sys_trans_perform(ds_button, ds_target, argument[19]);
   
	   //End action when transitions are complete
	   if (ds_button[# prop._trans_time, ds_target] >= ds_button[# prop._trans_dur, ds_target]) {
	      sys_action_term();
	   }
	}



}
