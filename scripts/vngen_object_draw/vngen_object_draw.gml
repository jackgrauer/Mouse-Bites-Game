/// @function	vngen_object_draw(x, y, [highlight]);
/// @param		{real}		x
/// @param		{real}		y
/// @param		{boolean}	[highlight]
/// @author		Lucas Chasteen <lucas.chasteen@xgasoft.com>
/// @copyright	XGASOFT 2020, All Rights Reserved
function vngen_object_draw() {

	/*
	Draws all components of the current event as set by vngen_event and any action scripts 
	with optional highlighting effects on characters and text links (enabled by default).

	This script is intended to be run in the Draw event.

	argument0 = horizontal offset for all elements (real)
	argument1 = vertical offset for all elements (real)
	argument2 = enables or disables highlighting characters and text links (boolean) (true/false) (optional, use no argument for 'true')

	Example usage: 
	   vngen_object_draw(view_xview[0], view_yview[0]);
	   vngen_object_draw(0, 0, false);
	*/

	/* 
	INITIALIZATION
	*/

	//Get highlight setting
	if (argument_count > 2) {
	   var temp_hlight = argument[2];
	} else {
	   var temp_hlight = true;	
	}

	//Get current text alignment
	var temp_halign = draw_get_halign();
	var temp_valign = draw_get_valign();

	//Force default text alignment for drawing VNgen
	draw_set_halign(fa_left);
	draw_set_valign(fa_top);


	/*
	PERSPECTIVE
	*/

	sys_layer_set_target(argument[0], argument[1]);


	/* 
	FULL/REDUCED RENDERING 
	*/

	if (global.vg_renderlevel < 2) {
	   sys_layer_draw_scene(false);
	   sys_layer_draw_char(temp_hlight);
	   sys_layer_draw_emote();
	   sys_layer_draw_scene(true);
	   sys_layer_draw_perspective();
	   sys_layer_draw_effect();
	   sys_layer_draw_textbox();
	   sys_layer_draw_text(temp_hlight);
	   sys_layer_draw_label();
	   sys_layer_draw_prompt();
	   sys_layer_draw_button();
	   sys_layer_draw_option();
   
   
	/* 
	LEGACY RENDERING 
	*/

	} else {
	   sys_layer_draw_scene_legacy(false);
	   sys_layer_draw_char_legacy();
	   sys_layer_draw_emote_legacy();
	   sys_layer_draw_scene_legacy(true);
	   sys_layer_draw_perspective();
	   sys_layer_draw_effect();
	   sys_layer_draw_textbox_legacy();
	   sys_layer_draw_text_legacy();
	   sys_layer_draw_label_legacy();
	   sys_layer_draw_prompt_legacy();
	   sys_layer_draw_button_legacy();
	   sys_layer_draw_option_legacy();
	}
   

	/* 
	FINALIZATION & DEBUG MODE 
	*/

	sys_layer_reset_target();

	//Reset text alignment
	draw_set_halign(temp_halign);
	draw_set_valign(temp_valign);


}
