/// @function	vngen_label_replace_ext(id, label, xorig, yorig, scaling, linebreak, font, color, duration, ease, [lang]);
/// @param		{real|string}	id
/// @param		{string}		label
/// @param		{real|macro}	xorig
/// @param		{real|macro}	yorig
/// @param		{integer|macro}	scaling
/// @param		{real}			linebreak
/// @param		{font}			font
/// @param		{color}			color
/// @param		{real}			duration
/// @param		{integer|macro}	ease
/// @param		{real|string}	[lang]
/// @author		Lucas Chasteen <lucas.chasteen@xgasoft.com>
/// @copyright	XGASOFT 2020, All Rights Reserved
function vngen_label_replace_ext() {

	/*
	Applies a new string with offset support to the specified label. As with other
	modifications, changes to active label will persist until the label is removed or another
	replacement is performed.

	argument0  = identifier of the label to be modified (real or string)
	argument1  = the new string to apply to the label (string) (use 'auto' for auto speaker names)
	argument2  = the new horizontal offset, or center point (real)
	argument3  = the new vertical offset, or center point (real)
	argument4  = sets the scaling mode to perform: scale_none, scale_x_y, scale_x, scale_y, 
	             scale_stretch_x_y, scale_stretch_x, scale_stretch_y, scale_prop_x_y, 
	             scale_prop_x, or scale_prop_y (integer or macro)
	argument5  = the new width in pixels before label is wrapped into a new line (real)
	argument6  = the new label font (font) (optional, use 'previous' for no change or 'inherit' for inherit)
	argument7  = the new label color (color) (optional, use 'previous' for no change or 'inherit' for inherit)
	argument8  = sets the length of the replacement transition, in seconds (real)
	argument9  = sets the animation easing method (see interp for available modes) (integer) (can also use true/false)
	argument10 = the new language flag to be associated with the label (real or string) (optional, use no argument for none)

	Example usage:
	   vngen_event() {
	      vngen_label_replace_ext("label", -1, 0, 0, 0, 128, fnt_Arial, c_white, 3, true);
	      vngen_label_replace_ext("label", "Jane Doe", 0, 0, 0, 128, fnt_Arial, c_white, 3, true, "en-US");
	   }
	*/

	//Enable action, if active
	switch (sys_action_init()) {
	   //Exit if event is inactive
	   case false: {
	      exit;
	   }
      
	   //Initialize action if active
	   case true: {
	      //Skip action if not in target language, if any
	      if (argument_count > 10) {
	         if (global.vg_lang_text != argument[10]) {
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
	            if (argument[6] == previous) {
	               ds_label[# prop._txt_fnt, ds_target] = style[? "fnt"];         //Font
	            }
            
	            //Get previous colors
	            if (argument[7] == previous) {
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
	         ds_label[# prop._tmp_xorig, ds_target] = ds_label[# prop._xorig, ds_target];         //Label X origin
	         ds_label[# prop._tmp_yorig, ds_target] = ds_label[# prop._yorig, ds_target];         //Label Y origin    
	         ds_label[# prop._tmp_col1, ds_target] = ds_label[# prop._col1, ds_target];           //Color1
	         ds_label[# prop._tmp_col2, ds_target] = ds_label[# prop._col2, ds_target];           //Color2
	         ds_label[# prop._tmp_col3, ds_target] = ds_label[# prop._col3, ds_target];           //Color3
	         ds_label[# prop._tmp_col4, ds_target] = ds_label[# prop._col4, ds_target];           //Color4         
	         ds_label[# prop._tmp_oxscale, ds_target] = ds_label[# prop._oxscale, ds_target];     //X scale offset
	         ds_label[# prop._tmp_oyscale, ds_target] = ds_label[# prop._oyscale, ds_target];     //Y scale offset   
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
      
	         //Get style inheritance setting
	         if (argument[7] < 0) {
	            var style_inherit = argument[7];
	         } else {
	            var style_inherit = none;
	         }
         
	         /* PROPERTIES */
         
	         //Process text and get the final surface for rendering
	         var label_surf = sys_text_init(ds_label, ds_target, text, text, ds_label[# prop._txt_halign, ds_target], argument[5], ds_label[# prop._txt_line_height, ds_target], argument[6], argument[7], argument[7], argument[7], argument[7], style_inherit, style_inherit, ds_label[# prop._speed, ds_target]);
           
	         //Set new label properties
	         ds_label[# prop._fade_alpha, ds_target] = 0;                          //Fade alpha  
	         ds_label[# prop._width, ds_target] = surface_get_width(label_surf);   //Crop width
	         ds_label[# prop._height, ds_target] = surface_get_height(label_surf); //Crop height 
	         ds_label[# prop._lab_auto, ds_target] = label_auto;                   //Auto label mode      
	         ds_label[# prop._redraw, ds_target] = true;                           //Redraw state
         
	         //Set transition time
	         if (argument[8] > 0) {
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
	if (argument_count > 10) {
	   if (global.vg_lang_text != argument[10]) {  
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

	if (ds_label[# prop._fade_time, ds_target] < argument[8]) {
	   //Get surfaces to check dimensions
	   var action_surf = ds_label[# prop._surf, ds_target];
	   var fade_surf = ds_label[# prop._fade_src, ds_target];
   
	   /* TEXTURE ORIGINS */
   
	   //Backup current origin values to temp variables
	   var temp_xorig = ds_label[# prop._xorig, ds_target];
	   var temp_yorig = ds_label[# prop._yorig, ds_target];
   
	   //Calculate new origin
	   sys_orig_init(ds_label, ds_target, argument[2], argument[3]);
   
	   //Get new origin
	   var action_xorig = ds_label[# prop._xorig, ds_target];
	   var action_yorig = ds_label[# prop._yorig, ds_target];
   
	   //Restore temp origin values
	   ds_label[# prop._xorig, ds_target] = temp_xorig;
	   ds_label[# prop._yorig, ds_target] = temp_yorig;   
   
	   /* SCALING */   
   
	   //Backup current scale values to temp variables
	   var temp_xscale = ds_label[# prop._oxscale, ds_target];
	   var temp_yscale = ds_label[# prop._oyscale, ds_target];
   
	   //Calculate new scale
	   sys_scale_init(ds_label, ds_target, global.dp_width, global.dp_height, global.dp_width_init, global.dp_height_init, argument[4]);
   
	   //Get new scale
	   var action_xscale = ds_label[# prop._oxscale, ds_target];
	   var action_yscale = ds_label[# prop._oyscale, ds_target];
   
	   //Restore temp scale values
	   ds_label[# prop._oxscale, ds_target] = temp_xscale;
	   ds_label[# prop._oyscale, ds_target] = temp_yscale;
   
	   /* TRANSITIONS */   

	   //Increment transition time
	   if (!sys_action_skip()) {
	      ds_label[# prop._fade_time, ds_target] += time_frame;
	   } else {
	      //Otherwise skip transition if vngen_do_continue is run
	      ds_label[# prop._fade_time, ds_target] = argument[8];     
	   }
   
	   //Mark this action as complete
	   if (ds_label[# prop._fade_time, ds_target] < 0) or (ds_label[# prop._fade_time, ds_target] >= argument[8]) {
	      //Disallow exceeding target values
	      ds_label[# prop._xorig, ds_target] = action_xorig;    //Surface X origin
	      ds_label[# prop._yorig, ds_target] = action_yorig;    //Surface Y origin           
	      ds_label[# prop._fade_alpha, ds_target] = 1;          //Fade alpha
	      ds_label[# prop._fade_time, ds_target] = argument[8]; //Fade time
	      ds_label[# prop._oxscale, ds_target] = action_xscale; //X scale offset
	      ds_label[# prop._oyscale, ds_target] = action_yscale; //Y scale offset          
      
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
	if (argument[8] > 0) {
	   //Get transition time
	   var action_time = interp(0, 1, ds_label[# prop._fade_time, ds_target]/argument[8], argument[9]);

	   //Perform label replacement  
	   ds_label[# prop._xorig, ds_target] = lerp(ds_label[# prop._tmp_xorig, ds_target], action_xorig, action_time);      //Text X origin
	   ds_label[# prop._yorig, ds_target] = lerp(ds_label[# prop._tmp_yorig, ds_target], action_yorig, action_time);      //Text Y origin
	   ds_label[# prop._fade_alpha, ds_target] = lerp(0, 1, action_time);                                                 //Fade alpha
	   ds_label[# prop._oxscale, ds_target] = lerp(ds_label[# prop._tmp_oxscale, ds_target], action_xscale, action_time); //X scale offset
	   ds_label[# prop._oyscale, ds_target] = lerp(ds_label[# prop._tmp_oyscale, ds_target], action_yscale, action_time); //Y scale offset
	}



}
