/// @function	vngen_label_replace(id, label, font, color, duration, [ease], [lang]);
/// @param		{real|string}	id
/// @param		{string}		label
/// @param		{font}			font
/// @param		{color}			color
/// @param		{real}			duration
/// @param		{integer|macro}	[ease]
/// @param		{real|string}	[lang]
/// @author		Lucas Chasteen <lucas.chasteen@xgasoft.com>
/// @copyright	XGASOFT 2020, All Rights Reserved
function vngen_label_replace() {

	/*
	Applies a new string to the specified label. As with other modifications, 
	changes to active label will persist until the label is removed or another
	replacement is performed.

	argument0 = identifier of the label to be modified (real or string)
	argument1 = the new string to apply to the label (string) (use 'auto' for auto speaker names)
	argument2 = the new label font (font) (optional, use 'previous' for no change or 'inherit' for inherit)
	argument3 = the new label color (color) (optional, use 'previous' for no change or 'inherit' for inherit)
	argument4 = sets the length of the replacement transition, in seconds (real)
	argument5 = sets the animation easing method (see interp for available modes) (integer) (can also use true/false) (optional, use no argument for none)
	argument6 = the new language flag to be associated with the label (real or string) (optional, use no argument for none)

	Example usage:
	   vngen_event() {
	      vngen_label_replace("label", -1, fnt_Arial, c_white, 3);
	      vngen_label_replace("label", "Jane Doe", -2, -2, 3, "en-US");
	   }
	*/


	/*
	INITIALIZATION
	*/

	//Get input language, if any
	var action_lang = undefined;
	if (argument_count == 6) {
	   if (is_string(argument[5])) {
	      action_lang = argument[5];
	   }
	} else {
	   if (argument_count > 6) {
	      action_lang = argument[6];
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
   
	      //Get label slot
	      var ds_target = vngen_get_index(argument[0], vngen_type_label);
         
	      //If the target label exists...
	      if (!is_undefined(ds_target)) {     
      
	         /* INITIALIZATION */           
      
	         //Copy existing label to fade surface
	         if (surface_exists(ds_label[# prop._surf, ds_target])) {
	            if (!surface_exists(ds_label[# prop._fade_src, ds_target])) {
	               //Create fade surface
	               ds_label[# prop._fade_src, ds_target] = surface_create(ds_label[# prop._width, ds_target], ds_label[# prop._height, ds_target]);        
	            } else {
	               surface_resize(ds_label[# prop._fade_src, ds_target], ds_label[# prop._width, ds_target], ds_label[# prop._height, ds_target]);
	            }
               
	            //Copy contents to fade surface
	            surface_copy(ds_label[# prop._fade_src, ds_target], 0, 0, ds_label[# prop._surf, ds_target]);
            
	            //Clear original surface to make room for new content
	            surface_free(ds_label[# prop._surf, ds_target]);
	         }
         
	         //Clear deform surface to be redrawn, if any
	         if (surface_exists(ds_label[# prop._def_surf, ds_target])) {
	            surface_free(ds_label[# prop._def_surf, ds_target]);
	         }          
         
	         //Clear existing linebreak data, if any
	         if (ds_exists(ds_label[# prop._txt_line_data, ds_target], ds_type_list)) {
	            ds_list_destroy(ds_label[# prop._txt_line_data, ds_target]);
	            ds_label[# prop._txt_line_data, ds_target] = -1;
	         }
         
	         //Get most recent label styles if inheritance is enabled
	         if (ds_label[# prop._lab_auto, ds_target] == true) {
	            //Check previous label for style data
	            var style = sys_text_style_init(ds_label, ds_target, text_label_auto, inherit, inherit, inherit, inherit, inherit, inherit, inherit);                  
            
	            //Get previous font
	            if (argument[2] == previous) {
	               ds_label[# prop._txt_fnt, ds_target] = style[? "fnt"];         //Font
	            }
            
	            //Get previous colors
	            if (argument[3] == previous) {
	               ds_label[# prop._col1, ds_target] = style[? "col1"];           //Color1
	               ds_label[# prop._col2, ds_target] = style[? "col2"];           //Color2
	               ds_label[# prop._col3, ds_target] = style[? "col3"];           //Color3
	               ds_label[# prop._col4, ds_target] = style[? "col4"];           //Color4                    
	               ds_label[# prop._txt_shadow, ds_target] = style[? "shadow"];   //Shadow
	               ds_label[# prop._txt_outline, ds_target] = style[? "outline"]; //Outline
	            }

	            //Clear temporary style data
	            ds_map_destroy(style);
	         }
         
	         //Backup original values to temp value slots           
	         ds_label[# prop._tmp_col1, ds_target] = ds_label[# prop._col1, ds_target];           //Color1
	         ds_label[# prop._tmp_col2, ds_target] = ds_label[# prop._col2, ds_target];           //Color2
	         ds_label[# prop._tmp_col3, ds_target] = ds_label[# prop._col3, ds_target];           //Color3
	         ds_label[# prop._tmp_col4, ds_target] = ds_label[# prop._col4, ds_target];           //Color4           
	         ds_label[# prop._tmp_shadow, ds_target] = ds_label[# prop._txt_shadow, ds_target];   //Shadow
	         ds_label[# prop._tmp_outline, ds_target] = ds_label[# prop._txt_outline, ds_target]; //Outline
         
	         /* AUTO LABEL */
            
	         //Get default text
	         var text = argument[1];
         
	         //Get text auto mode
	         var label_auto = is_real(argument[1]);
         
	         //If auto mode is enabled...
	         if (label_auto == true) {
	            //Get auto label
	            text = text_label_auto;
	         }
         
	         //Set label text
	         ds_label[# prop._txt, ds_target] = text;  
         
	         /* PROPERTIES */
      
	         //Get style inheritance setting
	         if (argument[3] < 0) {
	            var style_inherit = argument[3];
	         } else {
	            var style_inherit = none;
	         }
   
	         //Process text and get the final surface for rendering
	         var label_surf = sys_text_init(ds_label, ds_target, text, text, ds_label[# prop._txt_halign, ds_target], ds_label[# prop._txt_line_break, ds_target], ds_label[# prop._txt_line_height, ds_target], argument[2], argument[3], argument[3], argument[3], argument[3], style_inherit, style_inherit, ds_label[# prop._speed, ds_target]);
           
	         //Set new label properties
	         ds_label[# prop._fade_alpha, ds_target] = 0;                          //Fade alpha  
	         ds_label[# prop._width, ds_target] = surface_get_width(label_surf);   //Crop width
	         ds_label[# prop._height, ds_target] = surface_get_height(label_surf); //Crop height    
	         ds_label[# prop._lab_auto, ds_target] = label_auto;                   //Auto label mode      
	         ds_label[# prop._redraw, ds_target] = true;                           //Redraw state
         
	         //Set transition time
	         if (argument[4] > 0) {
	            ds_label[# prop._fade_time, ds_target] = 0;  //Transition time
	         } else {
	            ds_label[# prop._fade_time, ds_target] = -1; //Transition time
	         }      
	      } else {
	         //Skip action if label does not exist
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

	//Get label slot
	var ds_target = vngen_get_index(argument[0], vngen_type_label);

	//Skip action if target label does not exist
	if (is_undefined(ds_target)) {
	   exit;
	}


	/*
	PERFORM REPLACEMENT
	*/

	if (ds_label[# prop._fade_time, ds_target] < argument[4]) {
	   //Increment transition time
	   if (!sys_action_skip()) {
	      ds_label[# prop._fade_time, ds_target] += time_frame;
	   } else {
	      //Otherwise skip transition if vngen_do_continue is run
	      ds_label[# prop._fade_time, ds_target] = argument[4];     
	   }
   
	   //Mark this action as complete
	   if (ds_label[# prop._fade_time, ds_target] < 0) or (ds_label[# prop._fade_time, ds_target] >= argument[4]) {
	      //Disallow exceeding target values      
	      ds_label[# prop._fade_alpha, ds_target] = 1;          //Fade alpha
	      ds_label[# prop._fade_time, ds_target] = argument[4]; //Fade time       
      
	      //Clear fade surfaces from memory
	      if (!sys_event_skip()) {
	         if (surface_exists(ds_label[# prop._fade_src, ds_target])) {
	            surface_free(ds_label[# prop._fade_src, ds_target]);
	            ds_label[# prop._fade_src, ds_target] = -1;
	         }
	         if (surface_exists(ds_label[# prop._def_fade_surf, ds_target])) {
	            surface_free(ds_label[# prop._def_fade_surf, ds_target]);
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
	if (argument[4] > 0) {
	   //Get ease mode
	   if (argument_count > 5) {
	      if (is_real(argument[5])) {
	         var action_ease = argument[5];
	      } else {
	         var action_ease = true;
	      }
	   } else {
	      var action_ease = true;
	   }
   
	   //Get transition time
	   var action_time = interp(0, 1, ds_label[# prop._fade_time, ds_target]/argument[4], action_ease);

	   //Perform label replacement  
	   ds_label[# prop._fade_alpha, ds_target] = lerp(0, 1, action_time); //Fade alpha
	}



}
