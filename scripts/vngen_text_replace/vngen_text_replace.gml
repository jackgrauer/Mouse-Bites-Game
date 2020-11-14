/// @function	vngen_text_replace(id, name, text, font, color, duration, [ease], [lang]);
/// @param		{real|string}	id
/// @param		{string|macro}	name
/// @param		{string}		text
/// @param		{font}			font
/// @param		{color}			color
/// @param		{real}			duration
/// @param		{integer|macro}	[ease]
/// @param		{real|string}	[lang]
/// @author		Lucas Chasteen <lucas.chasteen@xgasoft.com>
/// @copyright	XGASOFT 2020, All Rights Reserved
function vngen_text_replace() {

	/*
	Applies a new string to the specified text. As with other modifications, 
	changes to active text will persist until the text is removed or another
	replacement is performed.

	argument0 = identifier of the text to be modified (real or string) 
	argument1 = the new speaker name to associate with the text (string) (optional, use 'previous' for no change)
	argument2 = the new string to apply to the text (string)
	argument3 = the default text font, subject to be overridden in markup (font) (optional, use 'previous' for no change or 'inherit' for inherit)
	argument4 = the default text color, subject to be overridden in markup (color) (optional, use 'previous' for no change or 'inherit' for inherit)
	argument5 = sets the length of the replacement transition, in seconds (real)
	argument6 = sets the animation easing method (see interp for available modes) (integer) (can also use true/false) (optional, use no argument for none)
	argument7 = the new language flag to be associated with the text (real or string) (optional, use no argument for none)

	Example usage:
	   vngen_event() {
	      vngen_text_replace("text", "Jane Doe", "Hello, world!", fnt_Arial, c_white, 3);
	      vngen_text_replace("text", "Jane Doe", "Hello, world!", fnt_Arial, c_white, 3, true);
	      vngen_text_replace("text", "Jane Doe", "Hello, world!", fnt_Arial, c_white, 3, "en-US");
	      vngen_text_replace("text", "Jane Doe", "Hello, world!", fnt_Arial, c_white, 3, true, "en-US");
	   }

	//MARKUP
	VNgen text also supports a range of markup tags for inline text stylization. Each of
	these tags is outlined in detail below. While most tags are written in opening and
	closing pairs, the closing tag is optional and can be left out to apply stylization to 
	the rest of the entire string.

	//SPEAKER
	"Name||Text"

	Assigns the string preceding || as the speaking character name for the current text action.
	Speaker names declared in this way must be written prior to any other text, and will
	override names declared via script arguments. To affect other features such as labels and
	character highlighting, this name must match the name set in vngen_char_create **exactly**.

	//NEWLINE
	\n

	Manually breaks text into a new line.

	//ESCAPE
	^[

	Draws brackets literally rather than interpreting them as markup. Only opening brackets need
	to be escaped.

	//FONT
	[font=my_font]custom text[/font]

	Draws the enclosed text with a custom font. This can include bold and/or italic variants
	or entirely different font families. While using fonts of varying size is supported, it
	is recommended to use fonts of similar size when possible.

	//COLOR
	[color=#FFFFFF]colored text[/color] 
	[color=#FFF, #000]2-color gradient text[/color]
	[color=#FFF, #FFF, #000]3-color gradient text[/color] 
	[color=#FFF, #FFF, #000, #000]4-color gradient text[/color]

	Draws the enclosed text with a custom color, specified with hex color notation. Hex color
	can be written in either six or three characters. Color tags accept anywhere from 1-4 colors 
	separated by commas for gradient support.

	//SHADOW
	[shadow=#000]shaded text[/shadow]

	Draws the enclosed text with a shadow of a custom color, specified with hex color notation.
	Hex color can be written in either six or three characters. Unlike regular text color, shadow
	color modifications do not support comma-separated gradients.

	//OUTLINE
	[outline=#FFF]outlined text[/outline]

	Draws the enclosed text with an outline of a custom color, specified with hex color notation.
	Hex color can be written in either six or three characters. Unlike regular text color, outline
	color modifications do not support comma-separated gradients.

	//EVENT
	[event=ev_other, ev_user0]

	Executes the specified event when reached. Supports Create, Destroy, Step, Alarm, Draw, and Other 
	events (see documentation on the event_perform function for details). Two values must always be 
	supplied here, separated by a comma, with the second value being 0 when no other value applies. 
	Unlike other tags, [event] has no equivalent closing tag.

	//LINK
	[link=ev_other, ev_user0]linked text[/link]

	Turns the enclosed text into a clickable hotspot which will execute the specified event when
	selected. Supports Create, Destroy, Step, Alarm, Draw, and Other events (see documentation on
	the event_perform function for details). Two values must always be supplied here, separated by 
	a comma, with the second value being 0 when no other value applies. It is recommended to combine 
	link tags with other style tags to draw attention to them as clickable.

	//SPEED
	[speed=0.5]slow text[/speed]
	[speed=2]fast text[/speed]

	Multiplies the speed at which enclosed text is printed onto the screen. Unlike the default speed,
	which is set in characters per-second, speed tags use a multiplier to achieve the same effect
	at all text speeds.

	//PAUSE
	[pause=5]
	[pause=-1]

	Halts the typewriter effect for the specified duration, in seconds. If a negative value is supplied, 
	the effect will be paused indefinitely until vngen_do_continue is run. Alternatively, if auto mode is 
	enabled, negative values will be treated as positive. Unlike other tags, [pause] has no equivalent 
	closing tag.
	*/


	/*
	INITIALIZATION
	*/

	//Get input language, if any
	var action_lang = undefined;
	if (argument_count == 7) {
	   if (is_string(argument[6])) {
	      action_lang = argument[6];
	   }
	} else {
	   if (argument_count > 7) {
	      action_lang = argument[7];
	   }
	}

	//Enable action, if active
	switch (sys_action_init()) {
	   //Exit if event is inactive
	   case false: {
	      exit;
	   }
      
	   //Initialize action if active
	   case true: {
	      //Skip action if not in target language, if any
	      if (!is_undefined(action_lang)) {
	         if (global.vg_lang_text != action_lang) {
	            sys_action_term();     
	            exit;
	         }
	      }
      
	      //Get text slot
	      var ds_target = vngen_get_index(argument[0], vngen_type_text);
         
	      //If the target text exists...
	      if (!is_undefined(ds_target)) { 
	         //Disable character speech and highlights
	         sys_anim_speech(ds_text[# prop._name, ds_target], false, vngen_type_text, false);   
      
	         /* INITIALIZATION */       
      
	         //Copy existing text to fade surface
	         if (surface_exists(ds_text[# prop._surf, ds_target])) {
	            if (!surface_exists(ds_text[# prop._fade_src, ds_target])) {
	               //Create fade surface
	               ds_text[# prop._fade_src, ds_target] = surface_create(ds_text[# prop._width, ds_target], ds_text[# prop._height, ds_target]);
	            } else {
	               surface_resize(ds_text[# prop._fade_src, ds_target], ds_text[# prop._width, ds_target], ds_text[# prop._height, ds_target]);
	            }
               
	            //Copy contents to fade surface
	            surface_copy(ds_text[# prop._fade_src, ds_target], 0, 0, ds_text[# prop._surf, ds_target]);
            
	            //Clear original surface to make room for new content
	            surface_free(ds_text[# prop._surf, ds_target]);
	         }
         
	         //Clear deform surface to be redrawn, if any
	         if (surface_exists(ds_text[# prop._def_surf, ds_target])) {
	            surface_free(ds_text[# prop._def_surf, ds_target]);
	         }   
         
	         //Clear existing link markup data, if any
	         if (ds_exists(ds_text[# prop._mark_link_data, ds_target], ds_type_grid)) {
	            ds_grid_destroy(ds_text[# prop._mark_link_data, ds_target]);
	            ds_text[# prop._mark_link_data, ds_target] = -1;
	         }     
         
	         //Clear existing linebreak data, if any
	         if (ds_exists(ds_text[# prop._txt_line_data, ds_target], ds_type_list)) {
	            ds_list_destroy(ds_text[# prop._txt_line_data, ds_target]);
	            ds_text[# prop._txt_line_data, ds_target] = -1;
	         }
         
	         //Backup original values to temp value slots        
	         ds_text[# prop._tmp_col1, ds_target] = ds_text[# prop._col1, ds_target];           //Color1
	         ds_text[# prop._tmp_col2, ds_target] = ds_text[# prop._col2, ds_target];           //Color2
	         ds_text[# prop._tmp_col3, ds_target] = ds_text[# prop._col3, ds_target];           //Color3
	         ds_text[# prop._tmp_col4, ds_target] = ds_text[# prop._col4, ds_target];           //Color4         
	         ds_text[# prop._tmp_shadow, ds_target] = ds_text[# prop._txt_shadow, ds_target];   //Shadow
	         ds_text[# prop._tmp_outline, ds_target] = ds_text[# prop._txt_outline, ds_target]; //Outline  
         
	         //Get speaker name from text, if any
	         if (string_count("||", argument[2]) > 0) {
	            var name = string_copy(argument[2], 1, string_pos("||", argument[2]) - 1);
	         } else {
	            //Otherwise get new speaker name, if any
	            if (argument[1] == -1) {
	               var name = ds_text[# prop._name, ds_target];
	            } else {
	               var name = argument[1];
	            }
	         }  
      
	         //Get style inheritance setting
	         if (argument[4] < 0) {
	            var style_inherit = argument[4];
	         } else {
	            var style_inherit = none;
	         }
         
	         /* PROPERTIES */
         
	         //Process text and get the final surface for rendering
	         var text_surf = sys_text_init(ds_text, ds_target, argument[2], name, ds_text[# prop._txt_halign, ds_target], ds_text[# prop._txt_line_break, ds_target], ds_text[# prop._txt_line_height, ds_target], argument[3], argument[4], argument[4], argument[4], argument[4], style_inherit, style_inherit, ds_text[# prop._speed, ds_target]);      
                 
	         //Set new text properties
	         ds_text[# prop._fade_alpha, ds_target] = 0;                         //Fade alpha      
	         ds_text[# prop._name, ds_target] = name;                            //Name
	         ds_text[# prop._width, ds_target] = surface_get_width(text_surf);   //Crop width
	         ds_text[# prop._height, ds_target] = surface_get_height(text_surf); //Crop height       
         
	         //Set transition time
	         if (argument[5] > 0) {
	            ds_text[# prop._fade_time, ds_target] = 0;  //Transition time
	         } else {
	            ds_text[# prop._fade_time, ds_target] = -1; //Transition time
	         }    
      
	         //Set auto label
	         text_label_auto = sys_text_get_label();
         
	         //Enable character speech and highlighting
	         sys_anim_speech(ds_text[# prop._name, ds_target], true, vngen_type_text, true);       
         
	         /* END INITIALIZTION */
      
	         //Add text to the backlog for the current event, if event skip is inactive
	         if (!sys_event_skip()) {
	            //Get unmodified text string
	            var text = ds_text[# prop._txt_orig, ds_target];
         
	            //Add text to backlog
	            vngen_log_add(auto, text, name, ds_text[# prop._txt_fnt, ds_target], ds_text[# prop._col1, ds_target], ds_text[# prop._col2, ds_target], ds_text[# prop._col3, ds_target], ds_text[# prop._col4, ds_target], ds_text[# prop._txt_shadow, ds_target], ds_text[# prop._txt_outline, ds_target], ds_text[# prop._txt_halign, ds_target], ds_text[# prop._txt_line_height, ds_target]);
	         }
            
	         //Reset auto pause
	         global.vg_text_auto_current = 0;      
	      } else {
	         //Skip action if text does not exist
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

	//Skip action if not in target language, if any
	if (!is_undefined(action_lang)) {
	   if (global.vg_lang_text != action_lang) {    
	      exit;
	   }
	}

	//Get text slot
	var ds_target = vngen_get_index(argument[0], vngen_type_text);

	//Skip action if target text does not exist
	if (is_undefined(ds_target)) {
	   exit;
	}

	//Skip action if event skip is active
	if (sys_event_skip()) {
	   if (ds_text[# prop._txt_complete, ds_target] == false) {
	      //Skip typewriter effect
	      ds_text[# prop._index, ds_target] = ds_text[# prop._number, ds_target];
	      ds_text[# prop._redraw, ds_target] = ds_text[# prop._number, ds_target];
      
	      //Disable character speech animations
	      sys_anim_speech(ds_text[# prop._name, ds_target], false, vngen_type_text);
      
	      //Skip text event   
	      ds_text[# prop._txt_complete, ds_target] = true;  
	      sys_action_term();    
	   }
	}

	//End action when vngen_do_continue is run
	if (text_continue == true) or (global.vg_text_auto == true) {
	   if (ds_text[# prop._txt_complete, ds_target] == false) {
	      //If typewriter effect is complete, end action
	      if (ds_text[# prop._index, ds_target] >= ds_text[# prop._number, ds_target]) and (ds_text[# prop._fade_time, ds_target] >= argument[5]) {
	         sys_action_term();
         
	         //Do not process when text is marked complete
	         ds_text[# prop._txt_complete, ds_target] = true;
	      } else {
	         //Otherwise, skip ending action until vngen_do_continue is run again
	         text_continue = false;
	      }
	   }
	}


	/*
	PERFORM REPLACEMENT
	*/

	if (ds_text[# prop._fade_time, ds_target] < argument[5]) {   
	   //Increment transition time
	   if (!sys_action_skip()) {
	      ds_text[# prop._fade_time, ds_target] += time_frame;
	   } else {
	      //Otherwise skip transition if vngen_do_continue is run
	      ds_text[# prop._fade_time, ds_target] = argument[5];     
	   }
   
	   //Mark this action as complete
	   if (ds_text[# prop._fade_time, ds_target] < 0) or (ds_text[# prop._fade_time, ds_target] >= argument[5]) {
	      //Disallow exceeding target values        
	      ds_text[# prop._fade_alpha, ds_target] = 1;          //Fade alpha
	      ds_text[# prop._fade_time, ds_target] = argument[5]; //Fade time 
      
	      //Clear fade surfaces from memory
	      if (!sys_event_skip()) {
	         if (surface_exists(ds_text[# prop._fade_src, ds_target])) {
	            surface_free(ds_text[# prop._fade_src, ds_target]);
	            ds_text[# prop._fade_src, ds_target] = -1;
	         }
	         if (surface_exists(ds_text[# prop._def_fade_surf, ds_target])) {
	            surface_free(ds_text[# prop._def_fade_surf, ds_target]);
	         }
	      }
	      exit;
	   }
	} else {
	   //Do not process when transitions are complete
	   exit;
	}

	//If duration is greater than 0...
	if (argument[5] > 0) {
	   //Get ease mode
	   if (argument_count > 6) {
	      if (is_real(argument[6])) {
	         var action_ease = argument[6];
	      } else {
	         var action_ease = true;
	      }
	   } else {
	      var action_ease = true;
	   }
   
	   //Get transition time
	   var action_time = interp(0, 1, ds_text[# prop._fade_time, ds_target]/argument[5], action_ease);

	   //Perform text replacement
	   ds_text[# prop._fade_alpha, ds_target] = lerp(0, 1, action_time); //Fade alpha
	}



}
