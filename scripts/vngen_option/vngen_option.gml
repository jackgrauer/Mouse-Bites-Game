/// @function	vngen_option(id, x, y, delay_in, delay_out, snd_hover, snd_select, [lang]);
/// @param		{real|string}	id
/// @param		{real}			x
/// @param		{real}			y
/// @param		{real}			delay_in
/// @param		{real}			delay_out
/// @param		{sound}			snd_hover
/// @param		{sound}			snd_select
/// @param		{real|string}	[lang]
/// @author		Lucas Chasteen <lucas.chasteen@xgasoft.com>
/// @copyright	XGASOFT 2020, All Rights Reserved
function vngen_option() {

	/*
	Begins a new VNgen option code block, inside of which VNgen options
	can be created. Delays are applied before and after options are
	transitioned in, with 0 being instant. 

	Unlike vngen_event, specifying delays here is required. Like vngen_event, 
	however, vngen_option will pause all further execution of VNgen code until 
	a selection has been made.

	Must be run inside a VNgen event code block.

	argument0 = identifier to use for the entire option block (real or string)
	argument1 = the horizontal offset to apply to all options within the block (real)
	argument2 = the vertical offset to apply to all options within the block (real)
	argument3 = delay in seconds before options are transitioned in (real)
	argument4 = delay in seconds before options are transitioned out (real)
	argument5 = the sound to be played when an option is hovered (sound) (optional, use 'none' for none)
	argument6 = the sound to be played when an option is selected (sound) (optional, use 'none' for none)
	argument7 = the language flag to be associated with option text (real or string) (optional, use no argument for none)

	Example usage:
	   if vngen_event() {
	      if vngen_option("options", view_wview[0]*0.5, view_hview[0]*0.5, 0.5, 0.5, snd_hover, snd_select) {
	         //Create options here
	      }
      
	      if vngen_get_option() == 0 {
	         //Action
	      }
	   }
	*/


	/*
	INITIALIZATION
	*/

	//Reset option ID
	option_id = -1;

	//Enable action, if active
	switch (sys_action_init()) {
	   //Exit if event is inactive
	   case false: {
	      exit;
	   }
      
	   //Initialize action if active
	   case true: {
	      //Skip action if not in target language, if any
	      if (argument_count > 7) {
	         if (global.vg_lang_text != argument[7]) {
	            sys_action_term();     
	            return false;
	         }
	      }
   
	      //Force text elements visible
	      global.vg_ui_visible = true;
      
	      //Reset option state
	      option_count = 0;
	      option_current = 0;
	      option_exit = true;
	      option_hover = -1;
	      option_active = -1;
	      option_result = -1;
      
	      //Set transition delay
	      option_pause = max(0.01, argument[3]) + argument[4];
      
	      //Set option sound effects, if any
	      option_snd_hover = argument[5];
	      option_snd_select = argument[6];   
      
	      //Disallow skipping options during read skip
	      if (sys_read_skip()) {
	         if (event_skip_src < event_current) {
	            sys_action_skip(false);
	            sys_event_skip(-1);
	            sys_read_skip(false);
	            action_skip_active = false;
	            event_current = event_id;
	            text_continue = false;
         
	            //Do not log skipped events
	            sys_queue_destroy("log");
	         }
	      }
	   }
	}

	//Skip action if engine is paused
	if (global.vg_pause == true) {
	   return false;
	}

	//Skip action if not in target language, if any
	if (argument_count > 7) {
	   if (global.vg_lang_text != argument[7]) {  
	      return false;
	   }
	}

	//Skip action if event skip is active
	if (sys_event_skip()) {
	   //Enable further actions
	   event_exit = false;
	   sys_action_skip(true);
   
	   //Skip processing
	   option_count = 0;
	   option_current = 0;
	   option_exit = true;
	   option_pause = 0;
	   option_hover = -1;
	   option_active = -1;
	   option_result = -1;
	   option_snd_hover = -1;
	   option_snd_select = -1;
	   option_x = 0;
	   option_y = 0;
   
	   //Clear option data
	   var ds_width = ds_grid_width(ds_option);
	   ds_grid_destroy(ds_option);
	   ds_option = ds_grid_create(ds_width, 0);
   
	   //Mark action as complete
	   sys_action_term();
	   return false;
	}

	//While options are active...
	if (vngen_exists(any, vngen_type_option)) or (option_pause > 0) {
	   //Reset the skip state
	   sys_action_skip(false);
   
	   //Disable all further actions
	   event_exit = true;

	   //Set option offset
	   option_x = argument[1];
	   option_y = argument[2];
	}

	//If no selection has been made...
	if (option_result == -1) {
	   //Count down transition in delay on init
	   if (option_pause > argument[4]) {
	      //Countdown delay
	      option_pause -= time_frame;
         
	      //Disallow exceeding target values
	      if (option_pause <= argument[4]) {
	         option_pause = argument[4];
            
	         //Enable displaying options when countdown is complete
	         option_exit = false;
	      }
	   }
	} else {
	   //Count down transition out delay when a selection has been made
	   if (option_pause > 0) {   
	      //Countdown delay
	      option_pause -= time_frame;
      
	      //Disallow exceeding target values
	      if (option_pause <= 0) {
	         option_pause = 0;
	      }
	   }
   
	   //When countdown is complete...
	   if (option_pause == 0) {
	      if (option_count > 0) {
	         //Get the number of remaining options
	         option_count = ds_grid_height(ds_option);
         
	         //Reset option properties when all options are destroyed
	         if (option_count == 0) {
	            option_pause = 0;
	            option_hover = -1;
	            option_active = -1;
	            option_snd_hover = -1;
	            option_snd_select = -1;
			
				//Ensure option log exists
				if (!ds_exists(global.ds_option_result, ds_type_map)) {
					global.ds_option_result = ds_map_create();
				}
			
				//Record the selected option
				global.ds_option_result[? argument[0]] = option_result;
            
	            //End action
	            sys_action_term();
	         }
	      }
	   }
	}

	//Enable processing options
	return true;



}
