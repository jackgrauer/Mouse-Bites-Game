/// @function	cmd_localhelp();
/// @author		Lucas Chasteen <lucas.chasteen@xgasoft.com>
/// @copyright	XGASOFT 2020, All Rights Reserved
function cmd_localhelp() {

	/*
	==========================================================================
	SYSTEM FUNCTION: MODIFY AT YOUR OWN RISK!
	--------------------------------------------------------------------------
	  System functions are executed automatically by the engine and typically
	  should not be run manually by the user
	==========================================================================

	A command script for use with the VNgen command console.

	Note that all arguments passed from the command console are passed as strings
	and must be converted to reals manually, if necessary.

	See sys_cmd_add to add commands to the console.
	*/

	//Display console commands using internal dialog system
	show_message(
	   "VNGEN CONSOLE COMMANDS" +
	   "\n(Commands are case sensitive)" +
	   "\n\nexit - Close the console" +
	   "\nhelp - Display this dialog" + 
	   "\ngame_end() - Exit the game" + 
	   "\ngame_restart() - Restart the game" + 
	   "\nshow_debug_helpers(true/false) - Enable or disable wireframe overlays (affects performance)" +
	   "\nshow_debug_overlay(true/false) - Enable or disable live performance info" + 
	   "\nshow_debug_stats(true/false) - Enable or disable live engine info (affects performance)" +
	   "\nvngen_file_save(filename) - Save VNgen data to a file" +
	   "\nvngen_file_load(filename) - Load previously saved VNgen data" +
	   "\nvngen_file_delete(filename) - Delete previously saved VNgen data" +
	   "\nvngen_goto(event, [object, perform]) - Jump to a specific engine event" +
	   "\nvngen_goto_unread([perform]) - Jump to the nearest option or unread event" +
	   "\nvngen_log_clear([destroy]) - Clear the backlog and optionally destroy the log object" +
	   "\nvngen_room_goto(room, [event, object], [perform]) - Jump to a specific room and optional event" +
	   "\nvngen_set_lang(lang, [type]) - Set the active language flag for text, audio, or both" +
	   "\nvngen_get_lang(type) - Display the active language flag for text or audio" +
	   "\nvngen_set_renderlevel(level) - Set renderlevel, where 0 is default" +
	   "\nvngen_set_scale(view) - Set a viewport to scale to window dimensions" +
	   "\nvngen_set_speed(speed) - Set the text typewriter effect speed" +
	   "\nvngen_set_vol(type, vol, [fade]) - Set the global volume offset for a particular type of sound" +
	   "\nvngen_version() - Display the current VNgen version and build date" +
	   "\nwindow_set_fullscreen(true/false) - Set window display mode" +
	   "\n\nADDITIONAL CONTROLS" +
	   "\nup arrow - Previous command (max 32 stored commands)" +
	   "\ndown arrow - Next command (max 32 stored commands)" +
	   "\nenter - Execute command" +
	   "\nescape - Close console"
	);

	//Return result dialog
	return "Opened internal help dialog";


}
