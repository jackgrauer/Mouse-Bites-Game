/// @function	vngen_audio_modify(id, pitch, volume, duration, [ease], [start, end, full]);
/// @param		{real|string|macro}	id
/// @param		{real}				pitch
/// @param		{real}				volume
/// @param		{real}				duration
/// @param		{integer|macro}		[ease]
/// @param		{real}				[start]
/// @param		{real}				[end]
/// @param      {boolean}           [full]
/// @author		Lucas Chasteen <lucas.chasteen@xgasoft.com>
/// @copyright	XGASOFT 2020, All Rights Reserved
function vngen_audio_modify() {

	/*
	Modifies an existing sound of any type (sfx, voice, or music, except vox) with pitch and 
	volume adjustments. Can also modify the loop region of looped sound effects and music.

	As this script is itself treated as an action, it is only practical to
	modify looped sound effects and music. However, this script can be combined 
	with vngen_event_pause to modify any sound played in the same event.

	argument0 = identifier or character name associated with the target sound (real or string) (or keyword 'all' for all)
	argument1 = the pitch octave multiplier, where a value of 1 is default (real) (0-256)
	argument2 = the target sound volume, where a value of 1 equals 100% (real) (0-1)
	argument3 = sets the length of the modification transition, in seconds (real)
	argument4 = sets the transition easing method (see interp for available modes) (integer) (can also use true/false) (optional, use no argument for none)
	argument5 = the start point to clip the loop region, in seconds (real) (loops only) (optional, use no argument for none)
	argument6 = the end point to clip the loop region, in seconds (real) (loops only) (optional, use no argument for none)
	argument7 = enables or disables playing from the current position before clipping (boolean) (true/false) (optional, use no argument for none)

	Example usage:
	   vngen_event() {
	      vngen_audio_modify("explode", 1, 0.75, 1);
	      vngen_audio_modify("music", 1, 0.75, 1, true, 10, 20, true);
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
	      //Get audio slot
	      if (argument[0] == all) {
	         //Modify all audio, if enabled
	         var ds_target = sys_grid_last(ds_audio);
	         var ds_yindex = 0;
	      } else {
	         //Otherwise get single sound to modify
	         var ds_target = vngen_get_index(argument[0], vngen_type_audio);
	         var ds_yindex = ds_target;
	      }   
   
	      //If the target sound exists...
	      if (!is_undefined(ds_target)) {
	         while (ds_target >= ds_yindex) { 
			    //Get sound type
			    var action_vol = global.vg_vol_sound;        //SFX
			    switch (ds_audio[# prop._type, ds_target]) {
		           case 2: action_vol = global.vg_vol_voice; //Voice
				   case 3: action_vol = global.vg_vol_music; //Music
				   case 6: action_vol = global.vg_vol_voice; //Voice paused
				   case 7: action_vol = global.vg_vol_music; //Music paused
			    }
			
	            //Backup original values to temp value slots
	            ds_audio[# prop._tmp_vol, ds_target] = ds_audio[# prop._snd_vol, ds_target];     //Volume
	            ds_audio[# prop._tmp_pitch, ds_target] = ds_audio[# prop._snd_pitch, ds_target]; //Pitch
            
	            //Set transition time
	            if (argument[3] > 0) {
	               ds_audio[# prop._tmp_time, ds_target] = 0;  //Time
	            } else {
	               ds_audio[# prop._tmp_time, ds_target] = -1; //Time
      
	               //Set values directly if no transition
	               audio_sound_gain(ds_audio[# prop._snd, ds_target], argument[2]*action_vol, 0); //Volume
	               audio_sound_pitch(ds_audio[# prop._snd, ds_target], argument[1]);              //Pitch
	            }
            
	            //Clip sound, if enabled
	            if (argument_count > 5) {
	               //Clip loops only
	               if (is_odd(ds_audio[# prop._type, ds_target])) {
	                  ds_audio[# prop._snd_start, ds_target] = clamp(argument[argument_count - 3], 0, ds_audio[# prop._snd_dur, ds_target] - 0.05); //Start
	                  ds_audio[# prop._snd_end, ds_target] = clamp(argument[argument_count - 2], 0.05, ds_audio[# prop._snd_dur, ds_target]);       //End   
         
	                  //Clip beginning, if enabled
	                  if (argument[argument_count - 1] == false) {
	                     ds_audio[# prop._snd_pos, ds_target] = ds_audio[# prop._snd_start, ds_target]; //Playback position
                  
	                     //Set starting playback position
	                     audio_sound_set_track_position(ds_audio[# prop._snd, ds_target], ds_audio[# prop._snd_pos, ds_target]);
	                  }              
	               }
	            }     
            
	            //Continue to next sound, if any
	            ds_target -= 1;
	         }    
	      } else {
	         //Skip action if sound does not exist
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

	//Get audio slot
	if (argument[0] == all) {
	   //Modify all audio, if enabled
	   var ds_target = sys_grid_last(ds_audio);
	   var ds_yindex = 0;
	} else {
	   //Otherwise get single sound to modify
	   var ds_target = vngen_get_index(argument[0], vngen_type_audio);
	   var ds_yindex = ds_target;
	}  

	//Skip action if target audio does not exist
	if (is_undefined(ds_target)) {
	   exit;
	}


	/*
	PERFORM MODIFICATIONS
	*/

	while (ds_target >= ds_yindex) { 
	   //Increment transition time
	   if (ds_audio[# prop._tmp_time, ds_target] < argument[3]) {
	      if (!sys_action_skip()) {
	         ds_audio[# prop._tmp_time, ds_target] += time_frame;
	      } else {
	         //Otherwise skip transition if vngen_do_continue is run
	         ds_audio[# prop._tmp_time, ds_target] = argument[3];
	      }
      
	      //Mark this action as complete
	      if (ds_audio[# prop._tmp_time, ds_target] < 0) or (ds_audio[# prop._tmp_time, ds_target] >= argument[3]) { 
			 //Get sound type
			 var action_vol = global.vg_vol_sound;        //SFX
			 switch (ds_audio[# prop._type, ds_target]) {
		        case 2: action_vol = global.vg_vol_voice; //Voice
			    case 3: action_vol = global.vg_vol_music; //Music
			    case 6: action_vol = global.vg_vol_voice; //Voice paused
		        case 7: action_vol = global.vg_vol_music; //Music paused
			 }
		 
	         //Disallow exceeding target values
	         ds_audio[# prop._snd_vol, ds_target] = argument[2];   //Volume
	         ds_audio[# prop._snd_pitch, ds_target] = argument[1]; //Pitch
	         ds_audio[# prop._tmp_time, ds_target] = argument[3];  //Time 
         
	         //Set volume
	         audio_sound_gain(ds_audio[# prop._snd, ds_target], argument[2]*action_vol, 0);   
         
	         //Set pitch
	         audio_sound_pitch(ds_audio[# prop._snd, ds_target], argument[1]);
         
	         //End action
	         if (ds_target == ds_yindex) {
	            sys_action_term();
            
	            //Continue to next sound, if any
	            ds_target -= 1;
	            continue;
	         }
	      }   
	   } else {
	      //Do not process when transitions are complete
	      ds_target -= 1;
	      continue;
	   }
   
	   //If duration is greater than 0...
	   if (argument[3] > 0) {
	      //Get ease mode
	      if (argument_count == 5) or (argument_count == 7) {
	         var action_ease = argument[4];
	      } else {
	         var action_ease = true;
	      }
      
	      //Get transition time
	      var action_time = interp(0, 1, ds_audio[# prop._tmp_time, ds_target]/argument[3], action_ease);
		 
		  //Get sound type
		  var action_vol = global.vg_vol_sound;        //SFX
		  switch (ds_audio[# prop._type, ds_target]) {
		     case 2: action_vol = global.vg_vol_voice; //Voice
	         case 3: action_vol = global.vg_vol_music; //Music
		     case 6: action_vol = global.vg_vol_voice; //Voice paused
		     case 7: action_vol = global.vg_vol_music; //Music paused
	      }
   
	      //Perform audio modifications
	      ds_audio[# prop._snd_vol, ds_target] = lerp(ds_audio[# prop._tmp_vol, ds_target], argument[2], action_time);     //Volume
	      ds_audio[# prop._snd_pitch, ds_target] = lerp(ds_audio[# prop._tmp_pitch, ds_target], argument[1], action_time); //Pitch
   
	      //Apply audio modifications
	      audio_sound_gain(ds_audio[# prop._snd, ds_target], ds_audio[# prop._snd_vol, ds_target]*action_vol, 0); //Volume
	      audio_sound_pitch(ds_audio[# prop._snd, ds_target], ds_audio[# prop._snd_pitch, ds_target]);            //Pitch  
	   }
            
	   //Continue to next sound, if any
	   ds_target -= 1;
	}



}
