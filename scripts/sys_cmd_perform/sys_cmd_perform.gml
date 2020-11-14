/// @function	sys_cmd_perform();
/// @author		Lucas Chasteen <lucas.chasteen@xgasoft.com>
/// @copyright	XGASOFT 2020, All Rights Reserved
function sys_cmd_perform() {

	/*
	==========================================================================
	SYSTEM FUNCTION: MODIFY AT YOUR OWN RISK!
	--------------------------------------------------------------------------
	  System functions are executed automatically by the engine and typically
	  should not be run manually by the user
	==========================================================================

	Manages and receives command console user input and executes commands,
	when visible

	No parameters

	Example usage:
	   sys_cmd_perform();
	*/

	//If console is visible...
	if (global.cmd_visible == true) {   
	   //Repeat input if held for longer than 1/3 of a second
	   if (keyboard_check(vk_anykey) == true) {
	      //Delay repeat input
	      if (global.cmd_input_time >= 0.33) {
	         global.cmd_input_time = 0.3;
	      } else {
	         //Increment input time
	         global.cmd_input_time += delta_time/1000000;
	      }
	   }
   
	   //Reset input time when key is released
	   if (keyboard_check_released(vk_anykey)) {
	      global.cmd_input_time = 0;
	   }
   
	   //Input commands to console
	   if (keyboard_check_pressed(vk_anykey) or (global.cmd_input_time >= 0.33)) {
	      //Clear previous errors and confirmations
	      global.cmd_input_result = "";
      
	      //Refresh console contents
	      global.cmd_refresh = true;
   
	      /* INPUT */
      
	      switch (keyboard_key) {
	         //Hide developer console if Escape is pressed
	         case vk_escape: {
	            sys_toggle_cmd();
	            break;
	         }
            
	         //Navigate previous input history
	         case vk_up: {
	            if (ds_exists(global.ds_cmd_history, ds_type_list)) {
	               if (global.cmd_current < ds_list_size(global.ds_cmd_history)) {
	                  global.cmd_current += 1;
	               }
	            }
	            break;
	         }
            
	         //Navigate next input history
	         case vk_down: {
	            if (ds_exists(global.ds_cmd_history, ds_type_list)) {
	               if (global.cmd_current > 0) {
	                  global.cmd_current -= 1;
               
	                  //Clear input when last entry is reached
	                  if (global.cmd_current == 0) {
	                     global.cmd_input = "";
	                  }
	               }
	            }
	            break;
	         }
            
	         //Navigate cursor left
	         case vk_left: {
	            //Decrement cursor index
	            global.cmd_input_index -= 1;
	            break;
	         }
            
	         //Navigate cursor right
	         case vk_right: {
	            //Increment cursor index
	            global.cmd_input_index += 1;
	            break;
	         }
            
	         //Navigate cursor home
	         case vk_home: {
	            //Decrement cursor index
	            global.cmd_input_index = 1;
	            break;
	         }
            
	         //Navigate cursor end
	         case vk_end: {
	            //Increment cursor index
	            global.cmd_input_index = string_length(global.cmd_input) + 1;
	            break;
	         }
            
	         //Erase previous character if backspace is pressed
	         case vk_backspace: {
	            if (string_length(global.cmd_input) > 0) {
	               global.cmd_input = string_delete(global.cmd_input, global.cmd_input_index - 1, 1);
            
	               //Decrement cursor index
	               global.cmd_input_index -= 1;
	            }
	            break;
	         }
            
	         //Erase next character if delete is pressed
	         case vk_delete: {
	            if (string_length(global.cmd_input) > 0) {
	               global.cmd_input = string_delete(global.cmd_input, global.cmd_input_index, 1);
	            }
	            break;
	         }
            
	         //Perform commands if Enter is pressed
	         case vk_enter: {
	            //Initialize temp variables for processing input
	            var arg = -1;
	            var arg_count = 0;
            
	            //Escape commas to be interpreted literally
	            var input = string_replace_all(global.cmd_input, "^,", "\\c");
            
	            //Strip spaces between arguments
	            input = string_replace_all(input, ", ", ",");
            
	            //Parse arguments, if any
	            if (string_count("(", input) > 0) {
	               if (string_count(")", input) > 0) {
	                  //Get argument(s) from input
	                  input = string_copy(input, string_pos("(", input) + 1, string_pos(")", input) - string_pos("(", input) - 1);
               
	                  //Strip quotes from string arguments
	                  input = string_replace_all(input, "'", "");
	                  input = string_replace_all(input, "\"", "");
               
	                  //If arguments are present...
	                  if (string_length(input) > 0) {
	                     //Separate multiple arguments, if present
	                     while (string_count(",", input) > 0) {
	                        //Extract argument from input
	                        arg[arg_count] = string_copy(input, 1, string_pos(",", input) - 1);
	                        input = string_delete(input, 1, string_pos(",", input));
                        
	                        //Restore escaped commas, if any
	                        arg[arg_count] = string_replace_all(arg[arg_count], "\\c", ",");
                  
	                        //Increment argument count
	                        arg_count += 1;
	                     }
                  
	                     //Get single or final argument
	                     arg[arg_count] = input;
                        
	                     //Restore escaped commas, if any
	                     arg[arg_count] = string_replace_all(arg[arg_count], "\\c", ",");
                  
	                     //Increment argument count
	                     arg_count += 1;
	                  }
               
	                  //Extract input from arguments
	                  input = string_copy(global.cmd_input, 1, string_pos("(", global.cmd_input) - 1);
	               }
	            }
            
	            //Perform command, if valid
	            if (ds_map_exists(global.ds_cmd, input)) {
	               //Get script to perform from command
	               input = global.ds_cmd[? input];
               
	               //Perform command script, if valid
	               if (script_exists(input)) {
	                  switch (arg_count) {
	                     case 1:  global.cmd_input_result = script_execute(input, arg[0]); break;
	                     case 2:  global.cmd_input_result = script_execute(input, arg[0], arg[1]); break;
	                     case 3:  global.cmd_input_result = script_execute(input, arg[0], arg[1], arg[2]); break;
	                     case 4:  global.cmd_input_result = script_execute(input, arg[0], arg[1], arg[2], arg[3]); break;
	                     case 5:  global.cmd_input_result = script_execute(input, arg[0], arg[1], arg[2], arg[3], arg[4]); break;
	                     case 6:  global.cmd_input_result = script_execute(input, arg[0], arg[1], arg[2], arg[3], arg[4], arg[5]); break;
	                     case 7:  global.cmd_input_result = script_execute(input, arg[0], arg[1], arg[2], arg[3], arg[4], arg[5], arg[6]); break;
	                     case 8:  global.cmd_input_result = script_execute(input, arg[0], arg[1], arg[2], arg[3], arg[4], arg[5], arg[6], arg[7]); break;
	                     case 9:  global.cmd_input_result = script_execute(input, arg[0], arg[1], arg[2], arg[3], arg[4], arg[5], arg[6], arg[7], arg[8]); break;
	                     case 10: global.cmd_input_result = script_execute(input, arg[0], arg[1], arg[2], arg[3], arg[4], arg[5], arg[6], arg[7], arg[8], arg[9]); break;
	                     case 11: global.cmd_input_result = script_execute(input, arg[0], arg[1], arg[2], arg[3], arg[4], arg[5], arg[6], arg[7], arg[8], arg[9], arg[10]); break;
	                     case 12: global.cmd_input_result = script_execute(input, arg[0], arg[1], arg[2], arg[3], arg[4], arg[5], arg[6], arg[7], arg[8], arg[9], arg[10], arg[11]); break;
	                     case 13: global.cmd_input_result = script_execute(input, arg[0], arg[1], arg[2], arg[3], arg[4], arg[5], arg[6], arg[7], arg[8], arg[9], arg[10], arg[11], arg[12]); break;
	                     case 14: global.cmd_input_result = script_execute(input, arg[0], arg[1], arg[2], arg[3], arg[4], arg[5], arg[6], arg[7], arg[8], arg[9], arg[10], arg[11], arg[12], arg[13]); break;
	                     case 15: global.cmd_input_result = script_execute(input, arg[0], arg[1], arg[2], arg[3], arg[4], arg[5], arg[6], arg[7], arg[8], arg[9], arg[10], arg[11], arg[12], arg[13], arg[14]); break;
	                     case 16: global.cmd_input_result = script_execute(input, arg[0], arg[1], arg[2], arg[3], arg[4], arg[5], arg[6], arg[7], arg[8], arg[9], arg[10], arg[11], arg[12], arg[13], arg[14], arg[15]); break;
	                     case 17: global.cmd_input_result = script_execute(input, arg[0], arg[1], arg[2], arg[3], arg[4], arg[5], arg[6], arg[7], arg[8], arg[9], arg[10], arg[11], arg[12], arg[13], arg[14], arg[15], arg[16]); break;
	                     case 18: global.cmd_input_result = script_execute(input, arg[0], arg[1], arg[2], arg[3], arg[4], arg[5], arg[6], arg[7], arg[8], arg[9], arg[10], arg[11], arg[12], arg[13], arg[14], arg[15], arg[16], arg[17]); break;
	                     case 19: global.cmd_input_result = script_execute(input, arg[0], arg[1], arg[2], arg[3], arg[4], arg[5], arg[6], arg[7], arg[8], arg[9], arg[10], arg[11], arg[12], arg[13], arg[14], arg[15], arg[16], arg[17], arg[18]); break;
	                     case 20: global.cmd_input_result = script_execute(input, arg[0], arg[1], arg[2], arg[3], arg[4], arg[5], arg[6], arg[7], arg[8], arg[9], arg[10], arg[11], arg[12], arg[13], arg[14], arg[15], arg[16], arg[17], arg[18], arg[19]); break;
	                     case 21: global.cmd_input_result = script_execute(input, arg[0], arg[1], arg[2], arg[3], arg[4], arg[5], arg[6], arg[7], arg[8], arg[9], arg[10], arg[11], arg[12], arg[13], arg[14], arg[15], arg[16], arg[17], arg[18], arg[19], arg[20]); break;
	                     case 22: global.cmd_input_result = script_execute(input, arg[0], arg[1], arg[2], arg[3], arg[4], arg[5], arg[6], arg[7], arg[8], arg[9], arg[10], arg[11], arg[12], arg[13], arg[14], arg[15], arg[16], arg[17], arg[18], arg[19], arg[20], arg[21]); break;
	                     case 23: global.cmd_input_result = script_execute(input, arg[0], arg[1], arg[2], arg[3], arg[4], arg[5], arg[6], arg[7], arg[8], arg[9], arg[10], arg[11], arg[12], arg[13], arg[14], arg[15], arg[16], arg[17], arg[18], arg[19], arg[20], arg[21], arg[22]); break;
	                     case 24: global.cmd_input_result = script_execute(input, arg[0], arg[1], arg[2], arg[3], arg[4], arg[5], arg[6], arg[7], arg[8], arg[9], arg[10], arg[11], arg[12], arg[13], arg[14], arg[15], arg[16], arg[17], arg[18], arg[19], arg[20], arg[21], arg[22], arg[23]); break;
	                     case 25: global.cmd_input_result = script_execute(input, arg[0], arg[1], arg[2], arg[3], arg[4], arg[5], arg[6], arg[7], arg[8], arg[9], arg[10], arg[11], arg[12], arg[13], arg[14], arg[15], arg[16], arg[17], arg[18], arg[19], arg[20], arg[21], arg[22], arg[23], arg[24]); break;
	                     case 26: global.cmd_input_result = script_execute(input, arg[0], arg[1], arg[2], arg[3], arg[4], arg[5], arg[6], arg[7], arg[8], arg[9], arg[10], arg[11], arg[12], arg[13], arg[14], arg[15], arg[16], arg[17], arg[18], arg[19], arg[20], arg[21], arg[22], arg[23], arg[24], arg[25]); break;
	                     case 27: global.cmd_input_result = script_execute(input, arg[0], arg[1], arg[2], arg[3], arg[4], arg[5], arg[6], arg[7], arg[8], arg[9], arg[10], arg[11], arg[12], arg[13], arg[14], arg[15], arg[16], arg[17], arg[18], arg[19], arg[20], arg[21], arg[22], arg[23], arg[24], arg[25], arg[26]); break;
	                     case 28: global.cmd_input_result = script_execute(input, arg[0], arg[1], arg[2], arg[3], arg[4], arg[5], arg[6], arg[7], arg[8], arg[9], arg[10], arg[11], arg[12], arg[13], arg[14], arg[15], arg[16], arg[17], arg[18], arg[19], arg[20], arg[21], arg[22], arg[23], arg[24], arg[25], arg[26], arg[27]); break;
	                     case 29: global.cmd_input_result = script_execute(input, arg[0], arg[1], arg[2], arg[3], arg[4], arg[5], arg[6], arg[7], arg[8], arg[9], arg[10], arg[11], arg[12], arg[13], arg[14], arg[15], arg[16], arg[17], arg[18], arg[19], arg[20], arg[21], arg[22], arg[23], arg[24], arg[25], arg[26], arg[27], arg[28]); break;
	                     case 30: global.cmd_input_result = script_execute(input, arg[0], arg[1], arg[2], arg[3], arg[4], arg[5], arg[6], arg[7], arg[8], arg[9], arg[10], arg[11], arg[12], arg[13], arg[14], arg[15], arg[16], arg[17], arg[18], arg[19], arg[20], arg[21], arg[22], arg[23], arg[24], arg[25], arg[26], arg[27], arg[28], arg[29]); break;
	                     case 31: global.cmd_input_result = script_execute(input, arg[0], arg[1], arg[2], arg[3], arg[4], arg[5], arg[6], arg[7], arg[8], arg[9], arg[10], arg[11], arg[12], arg[13], arg[14], arg[15], arg[16], arg[17], arg[18], arg[19], arg[20], arg[21], arg[22], arg[23], arg[24], arg[25], arg[26], arg[27], arg[28], arg[29], arg[30]); break;
	                     case 32: global.cmd_input_result = script_execute(input, arg[0], arg[1], arg[2], arg[3], arg[4], arg[5], arg[6], arg[7], arg[8], arg[9], arg[10], arg[11], arg[12], arg[13], arg[14], arg[15], arg[16], arg[17], arg[18], arg[19], arg[20], arg[21], arg[22], arg[23], arg[24], arg[25], arg[26], arg[27], arg[28], arg[29], arg[30], arg[31]); break;
	                     default: global.cmd_input_result = script_execute(input); break;
	                  }
                  
	                  //Use default result dialog if none is supplied by the command script
	                  if (is_real(global.cmd_input_result)) {
	                     global.cmd_input_result = "Command executed successfully"
	                  }
	               } else {
	                  //Otherwise, return internal command error
	                  global.cmd_input_result = "Internal command error: Unrecognized function or script";
	               }
	            } else {
	               //Otherwise, return unrecognized command
	               global.cmd_input_result = "Error: Unrecognized command";
	            }
         
	            //Ensure command history data structure exists
	            if (!ds_exists(global.ds_cmd_history, ds_type_list)) {
	               global.ds_cmd_history = ds_list_create();
	            }
         
	            //Add input to command history
	            if (string_length(global.cmd_input) > 0) {
	               ds_list_insert(global.ds_cmd_history, 0, global.cmd_input);
	            }
         
	            //If history has exceeded max size, delete oldest entry
	            if (ds_list_size(global.ds_cmd_history) > 32) {
	               ds_list_delete(global.ds_cmd_history, ds_list_size(global.ds_cmd_history) - 1);
	            }
            
	            //Reset input history navigation
	            global.cmd_current = 0;            
         
	            //Clear input, we're done!
	            global.cmd_input = "";
	            arg = -1;
	            break;
	         }
            
	         //Otherwise input text, if any
	         default: {
	            if (keyboard_lastchar != "") and (keyboard_lastchar != "#") {
	               //Reset input history navigation
	               global.cmd_current = 0;
            
	               //Insert text to input
	               global.cmd_input = string_insert(keyboard_lastchar, global.cmd_input, global.cmd_input_index);
            
	               //Increment input index
	               global.cmd_input_index += 1;
            
	               //Clear errors and confirmations
	               global.cmd_input_result = "";
               
	               //Clear input text
	               keyboard_lastchar = "";
	            }
	         }
	      }
      
	      /* HISTORY */
      
	      //Get input history, if selected
	      if (global.cmd_current > 0) and (global.cmd_current != global.cmd_previous) {
	         if (ds_exists(global.ds_cmd_history, ds_type_list)) {
	            global.cmd_input = global.ds_cmd_history[| global.cmd_current - 1];
	            global.cmd_input_index = string_length(global.cmd_input) + 1;
	         }
	      }
         
	      //Update history navigation
	      global.cmd_previous = global.cmd_current;
      
	      /* CURSOR */
      
	      //Clamp cursor to input dimensions
	      global.cmd_input_index = clamp(global.cmd_input_index, 1, string_length(global.cmd_input) + 1);
      
	      /* FINALIZATION */
      
	      //Clear inputs to prevent triggering other behavior
	      io_clear();
	   }  
	}


}
