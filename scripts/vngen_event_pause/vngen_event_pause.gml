/// @function	vngen_event_pause(pause);
/// @param		{real}	pause
/// @author		Lucas Chasteen <lucas.chasteen@xgasoft.com>
/// @copyright	XGASOFT 2020, All Rights Reserved
function vngen_event_pause(argument0) {

	/*
	Inserts a delay, in seconds, between actions within an event (NOT between events!).
	Unlike delays between events, delays between actions cannot be held indefinitely.

	argument0 = delay in seconds before following actions are activated (real)

	Example usage:
	   if vngen_event() {
	      //Action
	      vngen_event_pause(1);
	      //Delayed action
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
	      //Skip action if event skip is active
	      if (sys_event_skip()) {
	         action_pause = 0;
	         sys_action_term();
	         exit;
	      }
   
	      //Set action delay
	      if (action_previous != action_current) {
	         action_pause = max(0, argument0);
   
	         //End initialization
	         action_previous = action_current;
	      }

	      //Countdown action delay
	      if (action_pause > 0) {
	         //If action delay is not skipped...
	         if (!sys_action_skip()) {
	            //And if engine is not paused...
	            if (global.vg_pause == false) {
	               //...countdown delay
	               action_pause -= time_frame;
            
	               //Disallow exceeding target values
	               if (action_pause < 0) {
	                  action_pause = 0;
	               }            
	            }
	         } else {
	            //Skip delay if vngen_do_continue is run
	            action_pause = 0;
	         }
   
	         //Disable further actions until delay is complete
	         action_current = action_id;
	         event_exit = true;
	      } else {
	         //End the action when complete
	         sys_action_term();
	      }
	   }
	}


}
