/// @function	vngen_event([pause], [noskip], [label]);
/// @param		{real}		[pause]
/// @param		{boolean}	[noskip]
/// @param		{string}	[label]
/// @author		Lucas Chasteen <lucas.chasteen@xgasoft.com>
/// @copyright	XGASOFT 2020, All Rights Reserved
function vngen_event() {

	/*
	Begins a new VNgen event code block, inside which VNgen actions
	can be run. 

	Events are essentially a means of determining whether actions occur 
	simultaneously or consecutively. The contents of each event are performed 
	together, with an optional delay occurring between events themselves. In 
	this way, events can be thought of similarly to key frames in a timeline 
	animation. 

	Events can be delayed indefinitely until vngen_do_continue is run by 
	supplying a negative pause value. If auto mode is enabled, this negative
	value will be treated as a regular delay.

	Events automatically continue from one to the next when all actions are 
	complete. Text actions are not considered complete until vngen_do_continue 
	is run, unless auto mode is enabled.

	Normally, event actions can be skipped by running vngen_do_continue prematurely,
	however this behavior can be disabled by setting "noskip" to true. In this
	case, vngen_do_continue will be ignored for the duration of the event, and text 
	actions will be continued automatically.

	While all events are given an internal numeric ID, it is also possible to
	assign string labels to events to make navigating to them with vngen_goto 
	easier. Labels can be set in any argument, however bear in mind that if
	further arguments are specified they will be interpreted as pause first,
	then noskip.

	This script must be initialized with vngen_event_set_target and closed
	with vngen_event_reset_target. 

	Intended to be run in the Step event.

	argument0 = delay in seconds before event is activated (real) (use -1 for indefinite) (optional, use no argument for none)
	argument1 = enables or disables disallowing actions within the event from being skipped (boolean) (true/false) (optional, use no argument for none)
	argument2 = string label to identify the event for vngen_goto (string) (optional, use no argument for none)

	Example usage:
	   vngen_event_set_target();

	   if vngen_event() {
	      //Actions
	   }
   
	   if vngen_event(3) {
	      //Actions
	   }   
   
	   if vngen_event(0, true) {
	      //Actions
	   }  
   
	   if vngen_event("my_event") {
	      //Actions
	   }  
   
	   if vngen_event("my_event", 3) {
	      //Actions
	   }     
   
	   if vngen_event("my_event", 0, true) {
	      //Actions
	   }  
   
	   if vngen_event(0, true, "my_event") {
	      //Actions
	   }

	   vngen_event_reset_target();
	*/

	/*
	EVENT LABELS
	*/

	//Get event ID
	event_id += 1;
      
	//Get event label, if any
	if (event_count == 0) {
	   //Set default label
	   event_label[event_id] = "";
   
	   //Get input label, if any
	   if (argument_count > 0) {
	      var arg_index;
	      for (arg_index = 0; arg_index < argument_count; arg_index += 1) {
	         if (is_string(argument[arg_index])) {
	            //Set label, if label input is found
	            event_label[event_id] = argument[arg_index];
	            break;
	         }
	      }
	   } 
	}


	/*
	EVENT SKIPPING
	*/

	//Increment active event during skip operations
	if (sys_event_skip()) {
	   //Skip read events, if enabled
	   if (sys_read_skip()) {
	      //Ensure read log exists
	      if (!ds_exists(global.ds_read, ds_type_map)) {
	         global.ds_read = ds_map_create();
	      }
      
	      //End skip when unread event is reached
	      if (!ds_map_exists(global.ds_read, object_get_name(object_index) + "_" + string(event_id))) {
	         //End skip when unread event is reached
	         sys_event_skip(event_id);
	         sys_read_skip(false);
	         event_current = event_id - 1;
	         action_skip_active = false;
         
	         //Mark destination event as read
	         global.ds_read[? object_get_name(object_index) + "_" + string(event_id)] = true;
	      }
	   }
   
	   //Skip actions in the current event
	   if (event_current == event_id) {
	      sys_action_skip(true);
	      text_continue = true;
         
	      //Reset event state
	      event_noskip = false;
	      event_pause = 0;
	      event_previous = event_current;
	      event_exit = false;
	      return true;
	   }
   
	   //Skip actions in future events until target event is reached
	   if (event_current + 1 == event_id) {
	      event_current += 1;
      
	      //Reset action state
	      action_id = -1;
	      action_count = 0;
	      action_current = 0;
	      action_previous = -1;
	      action_complete = 0;
      
	      //Skip ongoing actions
	      if (event_id < event_skip) {
	         sys_action_skip(true);
	         text_continue = true;
         
	         //Reset event state
	         event_noskip = false;
	         event_pause = 0;
	         event_previous = event_current;
	         event_exit = false;
	         return true;
	      } else {
	         //End skip process when the target event has been reached
	         event_current = event_id;
	         sys_event_skip(-1);
         
	         //Do not log skipped events
	         sys_queue_destroy("log");
         
	         //Enable drawing once target event has been reached
	         draw_enable_drawevent(true);
         
	         //Skip actions in final event if target event exceeds event total
	         if (action_skip_active == true) {
	            sys_action_skip(true);
         
	            //End action skip
	            event_previous = event_current;
	            event_noskip = false;
	            event_pause = 0;
	            action_skip_active = false;
	         }
            
	         //Preserve pause state after skip is complete
	         global.vg_pause = global.vg_event_skip_pause;
			 global.vg_event_skip_pause = false;
	      }      
	   }
	}


	/*
	INITIALIZATION
	*/

	//If event is active, initialize event
	if (event_current == event_id) {
	   if (event_previous != event_current) {
	      //Set default properties
	      event_noskip = false;
	      event_pause = 0;
	      sys_action_skip(false);
	      text_continue = false;
      
	      //Ensure read log exists
	      if (!ds_exists(global.ds_read, ds_type_map)) {
	         global.ds_read = ds_map_create();
	      }
      
	      //Mark event as read
	      global.ds_read[? object_get_name(object_index) + "_" + string(event_id)] = true;
      
	      //Set input properties
	      if (argument_count > 0) {
	         //Initialize temporary variables for setting event properties
	         var arg_index;
	         var arg_count = 0;
         
	         //Set event properties in any order
	         for (arg_index = 0; arg_index < argument_count; arg_index += 1) {
	            //Set event delay, if any
	            if (is_real(argument[arg_index])) {
	               if (arg_count == 0) {
	                  event_pause = argument[arg_index];
	                  arg_count = 1;
	                  continue;
	               } else {
	                  //Set skip mode, if any
	                  event_noskip = argument[arg_index];
	                  continue;
	               }
	            }
	         }
	      }    
	   }
   
	   //Enable the event
	   event_exit = false;
   
	   //Disallow skipping the event, if noskip is enabled
	   if (event_noskip == true) {
	      //Force text events to continue
	      global.vg_text_auto_current = global.vg_text_auto_pause;
	      text_continue = true;
	      text_pause = false;
      
	      //Disable skipping the event
	      sys_action_skip(false);
	   }
	} else {
	   //Disable the event when inactive
	   event_exit = true;
	   return false;
	}


	/*
	EVENT PAUSE
	*/

	//Countdown event delay, if any
	if (event_pause != 0) {
	   //Convert indefinite delay to time if auto mode is enabled
	   if (global.vg_text_auto_pause_indefinite == false) {
		  if (global.vg_text_auto == true) {
		     if (event_pause < 0) {
		        event_pause = abs(event_pause); 
			 }
	      }
	   }
   
	   //If event delay is not skipped...
	   if (!sys_action_skip()) {
	      //If event delay is used...
	      if (event_pause > 0) {
	         //And if the engine is unpaused...
	         if (global.vg_pause == false) {
	            //...countdown delay
	            event_pause -= time_frame;
            
	            //Disallow exceeding target values
	            if (event_pause < 0) {
	               event_pause = 0;
	            }
	         }
	      }
	   } else {
	      //Skip delay if vngen_do_continue is run
	      event_pause = 0;
      
	      //Reset action skip state
	      sys_action_skip(false);
	   }
   
	   //Disable the event until delay is complete
	   event_exit = true;
	}

	//Enable the event when active
	return true;


}
