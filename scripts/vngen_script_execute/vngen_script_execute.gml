/// @function	vngen_script_execute(script, [argument0], [argument1] ... [argument31]);
/// @param		{script}	script
/// @param		{value}		[argument0]
/// @param		{value}		[argument1]
/// @param		{value}		[argument31]
/// @author		Lucas Chasteen <lucas.chasteen@xgasoft.com>
/// @copyright	XGASOFT 2020, All Rights Reserved
function vngen_script_execute() {

	/*
	Executes arbitrary script code as a VNgen action. Code is only executed once, and will not be
	executed while skipping events with vngen_goto to reconstruct the target event. This protects
	code from being executed multiple times. To execute code critical to the reconstruction of
	skipped events, use vngen_script_execute_ext instead.

	Note that executed code is limited to the object event where VNgen actions are run (usually Step).

	Example usage:
	   vngen_event() {
	      vngen_script_execute(my_script, 1, 2, 3, true, false);
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
	      //Skip action if event skip is active
	      if (sys_event_skip()) {
	         sys_action_term();  
	         exit;
	      }
      
	      //Perform script
	      switch (argument_count) {
	         case 1:  script_execute(argument[0]); break;
         
	         case 2:  script_execute(argument[0], argument[1]); break;
         
	         case 3:  script_execute(argument[0], argument[1], argument[2]); break;
         
	         case 4:  script_execute(argument[0], argument[1], argument[2], argument[3]); break;
         
	         case 5:  script_execute(argument[0], argument[1], argument[2], argument[3], argument[4]); break;
         
	         case 6:  script_execute(argument[0], argument[1], argument[2], argument[3], argument[4], argument[5]); break;
         
	         case 7:  script_execute(argument[0], argument[1], argument[2], argument[3], argument[4], argument[5], argument[6]); break;
         
	         case 8:  script_execute(argument[0], argument[1], argument[2], argument[3], argument[4], argument[5], argument[6], argument[7]); break;
         
	         case 9:  script_execute(argument[0], argument[1], argument[2], argument[3], argument[4], argument[5], argument[6], argument[7], argument[8]); break;
         
	         case 10: script_execute(argument[0], argument[1], argument[2], argument[3], argument[4], argument[5], argument[6], argument[7], argument[8], argument[9]); break;
         
	         case 11: script_execute(argument[0], argument[1], argument[2], argument[3], argument[4], argument[5], argument[6], argument[7], argument[8], argument[9], argument[10]);  break;
         
	         case 12: script_execute(argument[0], argument[1], argument[2], argument[3], argument[4], argument[5], argument[6], argument[7], argument[8], argument[9], argument[10], 
	                                 argument[11]);  break;
                                 
	         case 13: script_execute(argument[0], argument[1], argument[2], argument[3], argument[4], argument[5], argument[6], argument[7], argument[8], argument[9], argument[10], 
	                                 argument[11], argument[12]); break;
                                 
	         case 14: script_execute(argument[0], argument[1], argument[2], argument[3], argument[4], argument[5], argument[6], argument[7], argument[8], argument[9], argument[10], 
	                                 argument[11], argument[12], argument[13]);  break;
                                 
	         case 15: script_execute(argument[0], argument[1], argument[2], argument[3], argument[4], argument[5], argument[6], argument[7], argument[8], argument[9], argument[10], 
	                                 argument[11], argument[12], argument[13], argument[14]); break;
                                 
	         case 16: script_execute(argument[0], argument[1], argument[2], argument[3], argument[4], argument[5], argument[6], argument[7], argument[8], argument[9], argument[10], 
	                                 argument[11], argument[12], argument[13], argument[14], argument[15]); break;
                                 
	         case 17: script_execute(argument[0], argument[1], argument[2], argument[3], argument[4], argument[5], argument[6], argument[7], argument[8], argument[9], argument[10], 
	                                 argument[11], argument[12], argument[13], argument[14], argument[15], argument[16]); break;
                                 
	         case 18: script_execute(argument[0], argument[1], argument[2], argument[3], argument[4], argument[5], argument[6], argument[7], argument[8], argument[9], argument[10], 
	                                 argument[11], argument[12], argument[13], argument[14], argument[15], argument[16], argument[17]); break;
                                 
	         case 19: script_execute(argument[0], argument[1], argument[2], argument[3], argument[4], argument[5], argument[6], argument[7], argument[8], argument[9], argument[10], 
	                                 argument[11], argument[12], argument[13], argument[14], argument[15], argument[16], argument[17], argument[18]); break;
                                 
	         case 20: script_execute(argument[0], argument[1], argument[2], argument[3], argument[4], argument[5], argument[6], argument[7], argument[8], argument[9], argument[10], 
	                                 argument[11], argument[12], argument[13], argument[14], argument[15], argument[16], argument[17], argument[18], argument[19]); break;
                                 
	         case 21: script_execute(argument[0], argument[1], argument[2], argument[3], argument[4], argument[5], argument[6], argument[7], argument[8], argument[9], argument[10], 
	                                 argument[11], argument[12], argument[13], argument[14], argument[15], argument[16], argument[17], argument[18], argument[19], argument[20]); break;
                                 
	         case 22: script_execute(argument[0], argument[1], argument[2], argument[3], argument[4], argument[5], argument[6], argument[7], argument[8], argument[9], argument[10], 
	                                 argument[11], argument[12], argument[13], argument[14], argument[15], argument[16], argument[17], argument[18], argument[19], argument[20],
	                                 argument[21]); break;
                                 
	         case 23: script_execute(argument[0], argument[1], argument[2], argument[3], argument[4], argument[5], argument[6], argument[7], argument[8], argument[9], argument[10], 
	                                 argument[11], argument[12], argument[13], argument[14], argument[15], argument[16], argument[17], argument[18], argument[19], argument[20],
	                                 argument[21], argument[22]); break;
                                 
	         case 24: script_execute(argument[0], argument[1], argument[2], argument[3], argument[4], argument[5], argument[6], argument[7], argument[8], argument[9], argument[10], 
	                                 argument[11], argument[12], argument[13], argument[14], argument[15], argument[16], argument[17], argument[18], argument[19], argument[20],
	                                 argument[21], argument[22], argument[23]); break;
                                 
	         case 25: script_execute(argument[0], argument[1], argument[2], argument[3], argument[4], argument[5], argument[6], argument[7], argument[8], argument[9], argument[10], 
	                                 argument[11], argument[12], argument[13], argument[14], argument[15], argument[16], argument[17], argument[18], argument[19], argument[20],
	                                 argument[21], argument[22], argument[23], argument[24]); break;
                                 
	         case 26: script_execute(argument[0], argument[1], argument[2], argument[3], argument[4], argument[5], argument[6], argument[7], argument[8], argument[9], argument[10], 
	                                 argument[11], argument[12], argument[13], argument[14], argument[15], argument[16], argument[17], argument[18], argument[19], argument[20],
	                                 argument[21], argument[22], argument[23], argument[24], argument[25]); break;
                                 
	         case 27: script_execute(argument[0], argument[1], argument[2], argument[3], argument[4], argument[5], argument[6], argument[7], argument[8], argument[9], argument[10], 
	                                 argument[11], argument[12], argument[13], argument[14], argument[15], argument[16], argument[17], argument[18], argument[19], argument[20],
	                                 argument[21], argument[22], argument[23], argument[24], argument[25], argument[26]); break;
                                 
	         case 28: script_execute(argument[0], argument[1], argument[2], argument[3], argument[4], argument[5], argument[6], argument[7], argument[8], argument[9], argument[10], 
	                                 argument[11], argument[12], argument[13], argument[14], argument[15], argument[16], argument[17], argument[18], argument[19], argument[20],
	                                 argument[21], argument[22], argument[23], argument[24], argument[25], argument[26], argument[27]); break;
                                 
	         case 29: script_execute(argument[0], argument[1], argument[2], argument[3], argument[4], argument[5], argument[6], argument[7], argument[8], argument[9], argument[10], 
	                                 argument[11], argument[12], argument[13], argument[14], argument[15], argument[16], argument[17], argument[18], argument[19], argument[20],
	                                 argument[21], argument[22], argument[23], argument[24], argument[25], argument[26], argument[27], argument[28]); break;
                                 
	         case 30: script_execute(argument[0], argument[1], argument[2], argument[3], argument[4], argument[5], argument[6], argument[7], argument[8], argument[9], argument[10], 
	                                 argument[11], argument[12], argument[13], argument[14], argument[15], argument[16], argument[17], argument[18], argument[19], argument[20],
	                                 argument[21], argument[22], argument[23], argument[24], argument[25], argument[26], argument[27], argument[28], argument[29]); break;
                                 
	         case 31: script_execute(argument[0], argument[1], argument[2], argument[3], argument[4], argument[5], argument[6], argument[7], argument[8], argument[9], argument[10], 
	                                 argument[11], argument[12], argument[13], argument[14], argument[15], argument[16], argument[17], argument[18], argument[19], argument[20],
	                                 argument[21], argument[22], argument[23], argument[24], argument[25], argument[26], argument[27], argument[28], argument[29], argument[30]); break;
                                 
	         case 32: script_execute(argument[0], argument[1], argument[2], argument[3], argument[4], argument[5], argument[6], argument[7], argument[8], argument[9], argument[10], 
	                                 argument[11], argument[12], argument[13], argument[14], argument[15], argument[16], argument[17], argument[18], argument[19], argument[20],
	                                 argument[21], argument[22], argument[23], argument[24], argument[25], argument[26], argument[27], argument[28], argument[29], argument[30],
	                                 argument[31]); break;
                                 
	         case 33: script_execute(argument[0], argument[1], argument[2], argument[3], argument[4], argument[5], argument[6], argument[7], argument[8], argument[9], argument[10], 
	                                 argument[11], argument[12], argument[13], argument[14], argument[15], argument[16], argument[17], argument[18], argument[19], argument[20],
	                                 argument[21], argument[22], argument[23], argument[24], argument[25], argument[26], argument[27], argument[28], argument[29], argument[30],
	                                 argument[31], argument[32]); break;
	      }
      
	      //Continue to next action once complete
	      sys_action_term(); 
	   }
	}



}
