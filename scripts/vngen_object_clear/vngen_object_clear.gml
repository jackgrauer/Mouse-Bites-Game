/// @function	vngen_object_clear([destroy]);
/// @param		{boolean}	[destroy]
/// @author		Lucas Chasteen <lucas.chasteen@xgasoft.com>
/// @copyright	XGASOFT 2020, All Rights Reserved
function vngen_object_clear() {

	/*
	Clears the running object of all VNgen data, optionally also destroying the object 
	when complete (recommended).

	To end a VNgen object while creating a new one in its place, see vngen_instance_change.

	argument0 = enables or disables destroying the object when cleared (boolean) (true/false) (optional, use no argument for false)

	Example usage: 
	   vngen_object_clear(true);
	   vngen_object_clear();
	*/

	/*
	INITIALIZATION
	*/

	//Skip if instance is not a VNgen object
	if (!variable_instance_exists(id, "ds_text")) {
	   exit;
	}

	//Initialize temporary variables for checking data
	var ds_xindex, ds_yindex;


	/*
	PERSPECTIVE
	*/

	if (ds_exists(ds_perspective, ds_type_grid)) { 
	   for (ds_yindex = 0; ds_yindex < ds_grid_height(ds_perspective); ds_yindex += 1) {
	      //Clear perspective data from memory
	      if (surface_exists(ds_perspective[# prop._src, ds_yindex])) {
	         surface_free(ds_perspective[# prop._src, ds_yindex]);
	      }
	      if (surface_exists(ds_perspective[# prop._fade_src, ds_yindex])) {
	         surface_free(ds_perspective[# prop._fade_src, ds_yindex]);
	         ds_perspective[# prop._fade_src, ds_yindex] = -1;
	      }

	      //Clear shader uniforms from memory
	      if (ds_exists(ds_perspective[# prop._sh_float_data, ds_yindex], ds_type_grid)) {
	         ds_grid_destroy(ds_perspective[# prop._sh_float_data, ds_yindex]);
	         ds_perspective[# prop._sh_float_data, ds_yindex] = -1;
	      }
	      if (ds_exists(ds_perspective[# prop._sh_mat_data, ds_yindex], ds_type_grid)) {
	         ds_grid_destroy(ds_perspective[# prop._sh_mat_data, ds_yindex]);
	         ds_perspective[# prop._sh_mat_data, ds_yindex] = -1;
	      }
	      if (ds_exists(ds_perspective[# prop._sh_samp_data, ds_yindex], ds_type_grid)) {
	         ds_grid_destroy(ds_perspective[# prop._sh_samp_data, ds_yindex]);
	         ds_perspective[# prop._sh_samp_data, ds_yindex] = -1;
	      }
	   }

	   //Clear data structure
	   ds_grid_destroy(ds_perspective);
	   ds_perspective = -1;
	}


	/*
	SCENES
	*/

	//Clear scene data from memory
	if (ds_exists(ds_scene, ds_type_grid)) { 
	   for (ds_yindex = 0; ds_yindex < ds_grid_height(ds_scene); ds_yindex += 1) {
	      //Clear scene surfaces from memory
	      if (surface_exists(ds_scene[# prop._surf, ds_yindex])) {
	         surface_free(ds_scene[# prop._surf, ds_yindex]);
	      } 
	      if (surface_exists(ds_scene[# prop._fade_src, ds_yindex])) {
	         surface_free(ds_scene[# prop._fade_src, ds_yindex]);
	      }
      
	      //Clear deform surfaces from memory
	      if (surface_exists(ds_scene[# prop._def_surf, ds_yindex])) {
	         surface_free(ds_scene[# prop._def_surf, ds_yindex]);
	      }      
	      if (surface_exists(ds_scene[# prop._def_fade_surf, ds_yindex])) {
	         surface_free(ds_scene[# prop._def_fade_surf, ds_yindex]);
	      }       
                     
	      //Clear deform point data from memory, if any
	      if (ds_exists(ds_scene[# prop._def_point_data, ds_yindex], ds_type_grid)) {
	         ds_grid_destroy(ds_scene[# prop._def_point_data, ds_yindex]);
	         ds_scene[# prop._def_point_data, ds_yindex] = -1;
	      }
      
	      //Clear shader uniforms from memory, if any
	      if (ds_exists(ds_scene[# prop._sh_float_data, ds_yindex], ds_type_grid)) {
	         ds_grid_destroy(ds_scene[# prop._sh_float_data, ds_yindex]);
	         ds_scene[# prop._sh_float_data, ds_yindex] = -1;
	      }
	      if (ds_exists(ds_scene[# prop._sh_mat_data, ds_yindex], ds_type_grid)) {
	         ds_grid_destroy(ds_scene[# prop._sh_mat_data, ds_yindex]);
	         ds_scene[# prop._sh_mat_data, ds_yindex] = -1;
	      }
	      if (ds_exists(ds_scene[# prop._sh_samp_data, ds_yindex], ds_type_grid)) {
	         ds_grid_destroy(ds_scene[# prop._sh_samp_data, ds_yindex]);
	         ds_scene[# prop._sh_samp_data, ds_yindex] = -1;
	      }
	   }
   
	   //Clear data structure
	   ds_grid_destroy(ds_scene); 
	   ds_scene = -1;
	}


	/*
	CHARACTERS/ATTACHMENTS
	*/

	//Clear character data from memory
	if (ds_exists(ds_character, ds_type_grid)) {   
	   for (ds_yindex = 0; ds_yindex < ds_grid_height(ds_character); ds_yindex += 1) {
	      //Clear character surfaces from memory   
	      if (surface_exists(ds_character[# prop._surf, ds_yindex])) {
	         surface_free(ds_character[# prop._surf, ds_yindex]);
	      }
	      if (surface_exists(ds_character[# prop._fade_src, ds_yindex])) {
	         surface_free(ds_character[# prop._fade_src, ds_yindex]);
	      }   
      
	      //Clear deform surfaces from memory
	      if (surface_exists(ds_character[# prop._def_surf, ds_yindex])) {
	         surface_free(ds_character[# prop._def_surf, ds_yindex]);
	      }      
	      if (surface_exists(ds_character[# prop._def_fade_surf, ds_yindex])) {
	         surface_free(ds_character[# prop._def_fade_surf, ds_yindex]);
	      }     
                     
	      //Clear deform point data from memory, if any
	      if (ds_exists(ds_character[# prop._def_point_data, ds_yindex], ds_type_grid)) {
	         ds_grid_destroy(ds_character[# prop._def_point_data, ds_yindex]);
	         ds_character[# prop._def_point_data, ds_yindex] = -1;
	      }
      
	      //Clear shader uniforms from memory, if any
	      if (ds_exists(ds_character[# prop._sh_float_data, ds_yindex], ds_type_grid)) {
	         ds_grid_destroy(ds_character[# prop._sh_float_data, ds_yindex]);
	         ds_character[# prop._sh_float_data, ds_yindex] = -1;
	      }
	      if (ds_exists(ds_character[# prop._sh_mat_data, ds_yindex], ds_type_grid)) {
	         ds_grid_destroy(ds_character[# prop._sh_mat_data, ds_yindex]);
	         ds_character[# prop._sh_mat_data, ds_yindex] = -1;
	      }
	      if (ds_exists(ds_character[# prop._sh_samp_data, ds_yindex], ds_type_grid)) {
	         ds_grid_destroy(ds_character[# prop._sh_samp_data, ds_yindex]);
	         ds_character[# prop._sh_samp_data, ds_yindex] = -1;
	      }
      
	      //Clear attachments from memory
	      if (ds_exists(ds_character[# prop._attach_data, ds_yindex], ds_type_grid)) {
	         //Get attachment data structure
	         var ds_attach = ds_character[# prop._attach_data, ds_yindex];
         
	         //Clear attachment data
	         for (ds_xindex = 0; ds_xindex < ds_grid_height(ds_attach); ds_xindex += 1) {
	            //Clear deform surfaces from memory
	            if (surface_exists(ds_attach[# prop._def_surf, ds_xindex])) {
	               surface_free(ds_attach[# prop._def_surf, ds_xindex]);
	            }      
	            if (surface_exists(ds_attach[# prop._def_fade_surf, ds_xindex])) {
	               surface_free(ds_attach[# prop._def_fade_surf, ds_xindex]);
	            }  
                     
	            //Clear deform point data from memory, if any
	            if (ds_exists(ds_attach[# prop._def_point_data, ds_xindex], ds_type_grid)) {
	               ds_grid_destroy(ds_attach[# prop._def_point_data, ds_xindex]);
	               ds_attach[# prop._def_point_data, ds_xindex] = -1;
	            }
      
	            //Clear shader uniforms from memory
	            if (ds_exists(ds_attach[# prop._sh_float_data, ds_xindex], ds_type_grid)) {
	               ds_grid_destroy(ds_attach[# prop._sh_float_data, ds_xindex]);
	               ds_attach[# prop._sh_float_data, ds_xindex] = -1;
	            }
	            if (ds_exists(ds_attach[# prop._sh_mat_data, ds_xindex], ds_type_grid)) {
	               ds_grid_destroy(ds_attach[# prop._sh_mat_data, ds_xindex]);
	               ds_attach[# prop._sh_mat_data, ds_xindex] = -1;
	            }
	            if (ds_exists(ds_attach[# prop._sh_samp_data, ds_xindex], ds_type_grid)) {
	               ds_grid_destroy(ds_attach[# prop._sh_samp_data, ds_xindex]);
	               ds_attach[# prop._sh_samp_data, ds_xindex] = -1;
	            }
	         }
         
	         //Clear attachment data structure
	         ds_grid_destroy(ds_character[# prop._attach_data, ds_yindex]);
	      }
	   }
   
	   //Clear character data structure
	   ds_grid_destroy(ds_character);
	   ds_character = -1;
	}


	/*
	EMOTES
	*/

	//Clear emote data from memory
	if (ds_exists(ds_emote, ds_type_grid)) { 
	   //Clear data structure
	   ds_grid_destroy(ds_emote); 
	   ds_emote = -1;
	}


	/*
	EFFECTS
	*/

	//Clear effect data from memory
	if (ds_exists(ds_effect, ds_type_grid)) {
	   for (ds_yindex = 0; ds_yindex < ds_grid_height(ds_effect); ds_yindex += 1) {
	      //Clear effect variable data from memory
	      if (ds_exists(ds_effect[# prop._ef_var_data, ds_yindex], ds_type_grid)) {
	         ds_grid_destroy(ds_effect[# prop._ef_var_data, ds_yindex]);
	         ds_effect[# prop._ef_var_data, ds_yindex] = -1;
	      }
	   }
   
	   //Clear data structure
	   ds_grid_destroy(ds_effect);
	   ds_effect = -1;
	}


	/*
	TEXTBOXES
	*/

	//Clear textbox data from memory
	if (ds_exists(ds_textbox, ds_type_grid)) { 
	   for (ds_yindex = 0; ds_yindex < ds_grid_height(ds_textbox); ds_yindex += 1) {
	      //Clear deform surfaces from memory
	      if (surface_exists(ds_textbox[# prop._def_surf, ds_yindex])) {
	         surface_free(ds_textbox[# prop._def_surf, ds_yindex]);
	      }      
	      if (surface_exists(ds_textbox[# prop._def_fade_surf, ds_yindex])) {
	         surface_free(ds_textbox[# prop._def_fade_surf, ds_yindex]);
	      }
                     
	      //Clear deform point data from memory, if any
	      if (ds_exists(ds_textbox[# prop._def_point_data, ds_yindex], ds_type_grid)) {
	         ds_grid_destroy(ds_textbox[# prop._def_point_data, ds_yindex]);
	         ds_textbox[# prop._def_point_data, ds_yindex] = -1;
	      }
      
	      //Clear shader uniforms from memory, if any
	      if (ds_exists(ds_textbox[# prop._sh_float_data, ds_yindex], ds_type_grid)) {
	         ds_grid_destroy(ds_textbox[# prop._sh_float_data, ds_yindex]);
	         ds_textbox[# prop._sh_float_data, ds_yindex] = -1;
	      }
	      if (ds_exists(ds_textbox[# prop._sh_mat_data, ds_yindex], ds_type_grid)) {
	         ds_grid_destroy(ds_textbox[# prop._sh_mat_data, ds_yindex]);
	         ds_textbox[# prop._sh_mat_data, ds_yindex] = -1;
	      }
	      if (ds_exists(ds_textbox[# prop._sh_samp_data, ds_yindex], ds_type_grid)) {
	         ds_grid_destroy(ds_textbox[# prop._sh_samp_data, ds_yindex]);
	         ds_textbox[# prop._sh_samp_data, ds_yindex] = -1;
	      }
	   }
   
	   //Clear data structure
	   ds_grid_destroy(ds_textbox); 
	   ds_textbox = -1;
	}


	/*
	TEXT
	*/

	//Clear text data from memory
	if (ds_exists(ds_text, ds_type_grid)) {   
	   for (ds_yindex = 0; ds_yindex < ds_grid_height(ds_text); ds_yindex += 1) {
	      //Clear text surfaces from memory
	      if (surface_exists(ds_text[# prop._surf, ds_yindex])) {
	         surface_free(ds_text[# prop._surf, ds_yindex]);
	      }
	      if (surface_exists(ds_text[# prop._fade_src, ds_yindex])) {
	         surface_free(ds_text[# prop._fade_src, ds_yindex]);
	      }
      
	      //Clear deform surfaces from memory
	      if (surface_exists(ds_text[# prop._def_surf, ds_yindex])) {
	         surface_free(ds_text[# prop._def_surf, ds_yindex]);
	      }      
	      if (surface_exists(ds_text[# prop._def_fade_surf, ds_yindex])) {
	         surface_free(ds_text[# prop._def_fade_surf, ds_yindex]);
	      }
                     
	      //Clear deform point data from memory, if any
	      if (ds_exists(ds_text[# prop._def_point_data, ds_yindex], ds_type_grid)) {
	         ds_grid_destroy(ds_text[# prop._def_point_data, ds_yindex]);
	         ds_text[# prop._def_point_data, ds_yindex] = -1;
	      }
      
	      //Clear shader uniforms from memory, if any
	      if (ds_exists(ds_text[# prop._sh_float_data, ds_yindex], ds_type_grid)) {
	         ds_grid_destroy(ds_text[# prop._sh_float_data, ds_yindex]);
	         ds_text[# prop._sh_float_data, ds_yindex] = -1;
	      }
	      if (ds_exists(ds_text[# prop._sh_mat_data, ds_yindex], ds_type_grid)) {
	         ds_grid_destroy(ds_text[# prop._sh_mat_data, ds_yindex]);
	         ds_text[# prop._sh_mat_data, ds_yindex] = -1;
	      }
	      if (ds_exists(ds_text[# prop._sh_samp_data, ds_yindex], ds_type_grid)) {
	         ds_grid_destroy(ds_text[# prop._sh_samp_data, ds_yindex]);
	         ds_text[# prop._sh_samp_data, ds_yindex] = -1;
	      }
      
	      //Clear markup link data from memory
	      if (ds_exists(ds_text[# prop._mark_link_data, ds_yindex], ds_type_grid)) {
	         ds_grid_destroy(ds_text[# prop._mark_link_data, ds_yindex]);
	      }
      
	      //Clear linebreak data from memory
	      if (ds_exists(ds_text[# prop._txt_line_data, ds_yindex], ds_type_list)) {
	         ds_list_destroy(ds_text[# prop._txt_line_data, ds_yindex]);
	      }
	   }
   
	   //Clear data structure
	   ds_grid_destroy(ds_text);
	   ds_text = -1;
	}


	/*
	LABELS
	*/

	//Clear label data from memory
	if (ds_exists(ds_label, ds_type_grid)) {   
	   for (ds_yindex = 0; ds_yindex < ds_grid_height(ds_label); ds_yindex += 1) {
	      //Clear label surfaces from memory
	      if (surface_exists(ds_label[# prop._surf, ds_yindex])) {
	         surface_free(ds_label[# prop._surf, ds_yindex]);
	      }     
	      if (surface_exists(ds_label[# prop._fade_src, ds_yindex])) {
	         surface_free(ds_label[# prop._fade_src, ds_yindex]);
	      }
      
	      //Clear deform surfaces from memory
	      if (surface_exists(ds_label[# prop._def_surf, ds_yindex])) {
	         surface_free(ds_label[# prop._def_surf, ds_yindex]);
	      }      
	      if (surface_exists(ds_label[# prop._def_fade_surf, ds_yindex])) {
	         surface_free(ds_label[# prop._def_fade_surf, ds_yindex]);
	      }
                     
	      //Clear deform point data from memory, if any
	      if (ds_exists(ds_label[# prop._def_point_data, ds_yindex], ds_type_grid)) {
	         ds_grid_destroy(ds_label[# prop._def_point_data, ds_yindex]);
	         ds_label[# prop._def_point_data, ds_yindex] = -1;
	      }
      
	      //Clear shader uniforms from memory, if any
	      if (ds_exists(ds_label[# prop._sh_float_data, ds_yindex], ds_type_grid)) {
	         ds_grid_destroy(ds_label[# prop._sh_float_data, ds_yindex]);
	         ds_label[# prop._sh_float_data, ds_yindex] = -1;
	      }
	      if (ds_exists(ds_label[# prop._sh_mat_data, ds_yindex], ds_type_grid)) {
	         ds_grid_destroy(ds_label[# prop._sh_mat_data, ds_yindex]);
	         ds_label[# prop._sh_mat_data, ds_yindex] = -1;
	      }
	      if (ds_exists(ds_label[# prop._sh_samp_data, ds_yindex], ds_type_grid)) {
	         ds_grid_destroy(ds_label[# prop._sh_samp_data, ds_yindex]);
	         ds_label[# prop._sh_samp_data, ds_yindex] = -1;
	      }
            
	      //Clear linebreak data from memory
	      if (ds_exists(ds_label[# prop._txt_line_data, ds_yindex], ds_type_list)) {
	         ds_list_destroy(ds_label[# prop._txt_line_data, ds_yindex]);
	      }
	   }
   
	   //Clear data structure
	   ds_grid_destroy(ds_label);
	   ds_label = -1;
	}


	/*
	PROMPTS
	*/

	//Clear prompt data from memory
	if (ds_exists(ds_prompt, ds_type_grid)) { 
	   for (ds_yindex = 0; ds_yindex < ds_grid_height(ds_prompt); ds_yindex += 1) {
	      //Clear deform surfaces from memory
	      if (surface_exists(ds_prompt[# prop._def_surf, ds_yindex])) {
	         surface_free(ds_prompt[# prop._def_surf, ds_yindex]);
	      }      
	      if (surface_exists(ds_prompt[# prop._def_fade_surf, ds_yindex])) {
	         surface_free(ds_prompt[# prop._def_fade_surf, ds_yindex]);
	      }
                     
	      //Clear deform point data from memory, if any
	      if (ds_exists(ds_prompt[# prop._def_point_data, ds_yindex], ds_type_grid)) {
	         ds_grid_destroy(ds_prompt[# prop._def_point_data, ds_yindex]);
	         ds_prompt[# prop._def_point_data, ds_yindex] = -1;
	      }
      
	      //Clear shader uniforms from memory, if any
	      if (ds_exists(ds_prompt[# prop._sh_float_data, ds_yindex], ds_type_grid)) {
	         ds_grid_destroy(ds_prompt[# prop._sh_float_data, ds_yindex]);
	         ds_prompt[# prop._sh_float_data, ds_yindex] = -1;
	      }
	      if (ds_exists(ds_prompt[# prop._sh_mat_data, ds_yindex], ds_type_grid)) {
	         ds_grid_destroy(ds_prompt[# prop._sh_mat_data, ds_yindex]);
	         ds_prompt[# prop._sh_mat_data, ds_yindex] = -1;
	      }
	      if (ds_exists(ds_prompt[# prop._sh_samp_data, ds_yindex], ds_type_grid)) {
	         ds_grid_destroy(ds_prompt[# prop._sh_samp_data, ds_yindex]);
	         ds_prompt[# prop._sh_samp_data, ds_yindex] = -1;
	      }
	   }
   
	   //Clear data structure
	   ds_grid_destroy(ds_prompt); 
	   ds_prompt = -1;
	}


	/*
	BUTTONS
	*/

	//Clear button data from memory
	if (ds_exists(ds_button, ds_type_grid)) { 
	   for (ds_yindex = 0; ds_yindex < ds_grid_height(ds_button); ds_yindex += 1) {
	      //Clear button surfaces from memory
	      if (surface_exists(ds_button[# prop._surf, ds_yindex])) {
	         surface_free(ds_button[# prop._surf, ds_yindex]);
	      } 
	   }
   
	   //Clear data structure
	   ds_grid_destroy(ds_button); 
	   ds_button = -1;
	}


	/*
	OPTIONS
	*/

	//Clear option data from memory
	if (ds_exists(ds_option, ds_type_grid)) { 
	   for (ds_yindex = 0; ds_yindex < ds_grid_height(ds_option); ds_yindex += 1) {
	      //Clear option surfaces from memory
	      if (surface_exists(ds_option[# prop._surf, ds_yindex])) {
	         surface_free(ds_option[# prop._surf, ds_yindex]);
	      } 
	   }
   
	   //Clear data structure
	   ds_grid_destroy(ds_option); 
	   ds_option = -1;
	}


	/*
	AUDIO
	*/

	//Clear audio data from memory
	if (ds_exists(ds_audio, ds_type_grid)) { 
	   for (ds_yindex = 0; ds_yindex < ds_grid_height(ds_audio); ds_yindex += 1) {
	      //Stop all sounds and music
	      if (audio_exists(ds_audio[# prop._snd, ds_yindex])) {
	         audio_stop_sound(ds_audio[# prop._snd, ds_yindex]);
	      }
      
	      //Stop all fade sounds and music
	      if (audio_exists(ds_audio[# prop._fade_src, ds_yindex])) {
	         audio_stop_sound(ds_audio[# prop._fade_src, ds_yindex]);
	      }
	   }
   
	   //Clear data structure
	   ds_grid_destroy(ds_audio);
	   ds_audio = -1;
	}


	/*
	VOX
	*/

	//Clear vox data from memory
	if (ds_exists(ds_vox, ds_type_grid)) { 
	   for (ds_yindex = 0; ds_yindex < ds_grid_height(ds_vox); ds_yindex += 1) {
	      //Clear vox data from memory
	      if (ds_exists(ds_vox[# prop._snd, ds_yindex], ds_type_list)) {
	         ds_list_destroy(ds_vox[# prop._snd, ds_yindex]);
	      }
      
	      //Clear fade vox data from memory
	      if (ds_exists(ds_vox[# prop._fade_src, ds_yindex], ds_type_list)) {
	         ds_list_destroy(ds_vox[# prop._fade_src, ds_yindex]);
	      }      
	   }
   
	   //Clear data structure
	   ds_grid_destroy(ds_vox);
	   ds_vox = -1;
	}


	/*
	FINALIZATION
	*/

	//Remove event label array from memory
	event_label = -1;
	event_skip_label = -1;

	//Stop current actions
	event_current = -1;

	//Destroy the running object, if enabled
	if (argument_count > 0) {
	   if (argument[0] == true) {
	      instance_destroy();
	   }
	}


}
