/// @function	vngen_log_draw(spr_background, spr_divider, spr_paused, spr_playing, sep, linebreak, font, color);
/// @param		{sprite}	spr_background
/// @param		{sprite}	spr_divider
/// @param		{sprite}	spr_paused
/// @param		{sprite}	spr_playing
/// @param		{real}		sep
/// @param		{real}		linebreak
/// @param		{font}		font
/// @param		{color}		color
/// @author		Lucas Chasteen <lucas.chasteen@xgasoft.com>
/// @copyright	XGASOFT 2020, All Rights Reserved
function vngen_log_draw(argument0, argument1, argument2, argument3, argument4, argument5, argument6, argument7) {

	/*
	Draws the contents of the backlog, if visible. By default, backlog text is drawn 
	using the recorded fonts and colors, however overrides for both can be specified
	to further style the backlog. 

	The backlog is styled through sprites for the background, a divider between events,
	and a two-state audio icon next to any entry for which audio is present. Background
	sprites will be stretched to fill the screen.

	This script is intended to be run in the Draw GUI event.

	argument0 = sprite to draw as a background for the entire backlog (sprite) (optional, use 'none' for none)
	argument1 = sprite to draw as a divider between log entries (sprite) (optional, use 'none' for none)
	argument2 = sprite to draw as audio icon when stopped (sprite) (optional, use 'none' for none)
	argument3 = sprite to draw as audio icon when playing (sprite) (optional, use 'none' for none)
	argument4 = distance in pixels between log entries and dividers (real)
	argument5 = the width in pixels before text is wrapped into a new line (real)
	argument6 = override font to draw backlog text in (font) (optional, use 'inherit' for inherit)
	argument7 = override color to draw backlog text in (color) (optional, use 'inherit' for inherit)

	Example usage: 
	   vngen_log_draw(spr_backlog, spr_divider, spr_audio_off, spr_audio_on, 1200, fnt_Arial, c_white);
	   vngen_log_draw(spr_backlog, spr_divider, spr_audio_off, spr_audio_on, 1200, -2, -2);
	*/

	/* 
	INITIALIZATION, VISIBILITY, & AUDIO
	*/

	sys_layer_log_set_target();


	/* 
	FULL/REDUCED RENDERING 
	*/

	if (global.vg_renderlevel < 2) {
	   sys_layer_draw_log(argument0, argument1, argument2, argument3, argument4, argument5, argument6, argument7);
	   sys_layer_draw_log_button();
   
   
	/* 
	LEGACY RENDERING 
	*/

	} else {
	   sys_layer_draw_log_legacy(argument0, argument1, argument2, argument3, argument4, argument5, argument6, argument7);
	   sys_layer_draw_log_button_legacy();
	}
   

	/* 
	FINALIZATION & SCROLLING
	*/

	sys_layer_log_reset_target();


}
