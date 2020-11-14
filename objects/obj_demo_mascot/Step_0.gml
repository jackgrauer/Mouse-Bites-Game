/// @description Perform VNgen script

/*
SETUP
*/

//Get view dimensions
var view_width = camera_get_view_width(view_camera[0]);
var view_height = camera_get_view_height(view_camera[0]);

//Perform on-screen button actions
switch (vngen_get_button()) {
   case "btn-log":  vngen_do_log_display(); break;
   case "btn-save": vngen_file_save("miki.sav"); break;
   case "btn-load": vngen_file_load("miki.sav"); break;
   case "btn-restart": game_restart(); break;
   case "btn-close": game_end(); break;
}

//Perform on-screen option actions
switch (vngen_get_option()) {
   case "opt_start": vngen_goto("GETTING_STARTED", self, false); break;
   case "opt_event": vngen_goto("EVENTS_ACTIONS", self, false); break;
   case "opt_anim":  vngen_goto("ANIMATIONS", self, false); break;
   case "opt_ease":  vngen_goto("EASING", self, false); break;
   case "opt_end":   vngen_goto("FINISH", self, false); break;
}

//Map mouse to perspective movement during Animations example
if (vngen_event_get_label() == "event_perspective") {
   var px = window_mouse_get_x() - (window_get_width()*0.5);
   var py = window_mouse_get_y() - (window_get_height()*0.5);
   
   vngen_perspective_modify_direct(0, -150, px, py, 1.2, 0, 0.5);
}


/*
SCRIPT
*/

//Begin VNgen script
vngen_event_set_target();

//Perform events and actions
if (vngen_event()) {
   vngen_perspective_modify_pos(0, 0, 0, 0, 0.8, 0, 1, 0);
   vngen_perspective_shader_start(sh_bloom, 0);
   
   vngen_text_create(0, "???", "[speed=0.075]...", view_width*0.5, view_height*0.5, 0, 2560, fnt_open_large, c_white, trans_fade, 0.25, true);
   vngen_set_halign(0, vngen_type_text, fa_center);
}

if (vngen_event()) {
   vngen_text_destroy(0, trans_none, 0);
   
   vngen_event_pause(2);
   
   vngen_scene_create("stage", spr_scene_stage, view_width*0.5, view_height*0.5, 0, false, false, trans_none, 0, ease_none);
   vngen_scene_modify_pos("stage", view_width*0.5, view_height*0.5, 0, 1.25, 0, 0);
   
   vngen_scene_create("curtain", spr_scene_curtain, view_width*0.5, view_height*0.5, -25, false, false, trans_none, 0, ease_none);
   vngen_scene_modify_pos("curtain", view_width*0.5, view_height*0.5, -25, 1.25, 0, 0);
   
   vngen_scene_create("curtain-fg", spr_scene_curtain, view_width*0.5, view_height*0.66, 1, false, true, trans_none, 0, ease_none);
   vngen_scene_modify_pos("curtain-fg", view_width*0.5, view_height*0.66, 1, 1.25, 0, 0);
   
   vngen_scene_create_ext("overlay", spr_scene_overlay_spot, orig_center, orig_center, view_width*0.5, view_height*0.5, 0, scale_stretch_x_y, true, true, trans_none, 0, false);
   vngen_scene_modify_pos("overlay", view_width*0.5, view_height*0.5, 0, 1.25, 0, 0);
   
   vngen_event_pause(0.33);
   
   vngen_audio_play_sound("light", snd_light, 1, 0);
}

if (vngen_event()) {
   vngen_audio_play_music(0, snd_music_jazz, 0.75, 0, false, 16, 234.95, true);
}

if (vngen_event()) {
   vngen_char_create_ext("Miki", spr_miki_body, spr_miki_face_happy, spr_miki_face_happy_talk, orig_left, orig_top, 480, 128, -2, 804, 620, scale_y, false, 2.83, trans_none, 0, ease_none);
   vngen_attach_create("Miki", "hair-back", spr_miki_hair_back, 368, 120, 1, trans_none, 0);
   vngen_attach_create("Miki", "hair-front", spr_miki_hair_front, 486, 215, -1, trans_none, 0);
   vngen_char_deform_start("Miki", def_breathe, 3.12, true, false);
   vngen_attach_deform_start("Miki", "hair-back", def_sweep, 2.94, true, true);
   vngen_attach_deform_start("Miki", "hair-front", def_sweep, 3.57, true, false);
   
   vngen_char_create_ext("Mei", spr_mei_body, spr_mei_face, spr_mei_face_talk, orig_left, orig_top, view_width - 480, 128, -1, 996, 620, scale_y, true, 2.97, trans_none, 0, ease_none);
   vngen_attach_create("Mei", "hair-back", spr_mei_hair_back, 532, 92, 1, trans_none, 0);
   vngen_attach_create("Mei", "hair-front", spr_mei_hair_front, 681, 209, -1, trans_none, 0);
   vngen_attach_create("Mei", "arm", spr_mei_arm, 298, 1146, -2, trans_none, 0);
   vngen_char_deform_start("Mei", def_breathe, 2.97, true, false);
   vngen_attach_deform_start("Mei", "hair-back", def_sweep, 3.31, true, false);
   vngen_attach_deform_start("Mei", "hair-front", def_sweep, 2.63, true, false);
   vngen_attach_anim_start("Mei", "arm", anim_bob, 5, true, false);
   
}

if (vngen_event(2)) {
   vngen_perspective_modify_pos(0, -150, 0, 0, 1.2, 0, 1, 2, ease_quad);
   
   vngen_scene_destroy("curtain-fg", trans_slide_down, 3, ease_elastic);
   vngen_scene_destroy("overlay", trans_zoom_out, 3, ease_quad_out);
}

if (vngen_event()) {
   vngen_textbox_create(0, spr_textbox_main, view_width*0.5, view_height - 50, 0, trans_wipe_right, 1, ease_quad);
      
   vngen_text_create(0, "Miki", "G[speed=0.5]oooooo[/speed]d morning, everyone!", (view_width*0.5) - 1152, view_height - 540, 0, 2300, fnt_open_large, c_white, trans_fade, 0.25, true);
   vngen_text_modify_style(0, c_aqua, c_aqua, c_white, c_white, c_black, c_black, 1, 0);
   
   vngen_label_create(0, auto, (view_width*0.5) - 1152, view_height - 705, 0, 512, fnt_open_large_bold, c_white, trans_wipe_right, 0.5, ease_quad);
   vngen_label_modify_style(0, c_aqua, c_aqua, c_white, c_white, c_black, c_black, 1, 0);
   
   vngen_prompt_create("inline", spr_prompt_inline, none, none, auto, auto, 0, trans_none, 0);
   
   vngen_prompt_create("main", spr_prompt_main, spr_prompt_main_idle, spr_prompt_main, (view_width*0.5) + 1360, view_height - 150, 0, trans_fade, 1, ease_circ_in);
   
   vngen_button_create("btn-log", "BACKLOG", spr_btn_textbox, spr_btn_textbox_hover, spr_btn_textbox_select, (view_width*0.5) - 1390, view_height - 180, 0, fnt_open_bold, c_white, trans_wipe_right, 0.5, ease_quad);
   vngen_button_create("btn-save", "Q-SAVE", spr_btn_textbox, spr_btn_textbox_hover, spr_btn_textbox_select, (view_width*0.5) - 1180, view_height - 180, 0, fnt_open_bold, c_white, trans_wipe_right, 0.5, ease_quad);
   vngen_button_create("btn-load", "Q-LOAD", spr_btn_textbox, spr_btn_textbox_hover, spr_btn_textbox_select, (view_width*0.5) - 970,  view_height - 180, 0, fnt_open_bold, c_white, trans_wipe_right, 0.5, ease_quad);
   
   vngen_audio_play_voice("Miki", MIK_001, 1, 0);
}

if (vngen_event()) {
   vngen_char_anim_start("Miki", anim_bounce, 0.33, false, false);
   
   vngen_text_replace(0, previous, "I'm Miki!", previous, previous, 0.25, true);
   
   vngen_audio_play_voice("Miki", MIK_002, 1, 0);
}

if (vngen_event()) {
   vngen_char_replace("Mei", spr_mei_body, spr_mei_face_happy, spr_mei_face_happy_talk, previous, previous, false, 0);
   vngen_char_anim_start("Mei", anim_bounce, 0.33, false, false);
   
   vngen_text_replace(0, "Mei", "I'm Mei!", previous, previous, 0.25, true);
   vngen_text_modify_style(0, c_fuchsia, c_fuchsia, c_white, c_white, c_black, c_black, 1, 0);
   
   vngen_label_modify_style(0, c_fuchsia, c_fuchsia, c_white, c_white, c_black, c_black, 1, 0);
   
   vngen_audio_play_voice("Mei", MEI_001, 1, 0);
}

if (vngen_event()) {
   vngen_text_replace(0, "Miki", "We're the VNgen twins!", inherit, inherit, 0.25, true);
   vngen_text_create(1, "Mei", "We're the VNgen twins!", (view_width*0.5) - 1118, view_height - 425, 0, 2300, inherit, inherit, trans_fade, 0.25, true);
   
   vngen_label_modify_style(0, c_ltgray, c_ltgray, c_white, c_white, c_black, c_black, 1, 0);
   
   vngen_audio_play_voice("Miki", MIK_003, 1, 0);
   vngen_audio_play_voice("Mei", MEI_002, 1, 0);
}

if (vngen_event()) {
   vngen_char_replace("Miki", spr_miki_body, spr_miki_face, spr_miki_face_talk, previous, previous, false, 0);
   vngen_char_replace("Mei", spr_mei_body, spr_mei_face, spr_mei_face_talk, previous, previous, false, 0);
   
   vngen_text_destroy(1, trans_fade, 0.25);
   vngen_text_replace(0, "Mei", "[speed=1.25]If you want to learn all about VNgen,[pause=0.5] you've come to the right place!", inherit, inherit, 0.25, true);
   
   vngen_label_modify_style(0, inherit, inherit, inherit, inherit, inherit, inherit, 1, 0);
   
   vngen_audio_play_voice("Mei", MEI_003, 1, 0);
}

if (vngen_event()) {
   vngen_text_replace(0, "Miki", "That's right!", inherit, inherit, 0.25, true);
   
   vngen_audio_play_voice("Miki", MIK_004, 1, 0);
}

if (vngen_event()) {
   vngen_text_replace(0, previous, "Tonight,[pause=0.25] we're taking audience requests--[pause=0.25]so YOU can learn all about the great features VNgen has to offer!", inherit, inherit, 0.25, true);
   
   vngen_audio_play_voice("Miki", MIK_005, 1, 0);
}

if (vngen_event()) {
   vngen_char_replace("Mei", spr_mei_body, spr_mei_face_happy, spr_mei_face_happy_talk, previous, previous, false, 0);
   
   vngen_text_replace(0, "Mei", "[speed=2][font=fnt_open_large_italic]* gasp! *[/font][/speed][pause=0.5] Audience requests?[pause=0.25] I wonder what they'll pick first?", inherit, inherit, 0.25, true);
   
   vngen_audio_play_voice("Mei", MEI_004, 1, 0);
}

if (vngen_event()) {
   vngen_char_replace("Mei", spr_mei_body, spr_mei_face, spr_mei_face_talk, previous, previous, false, 0);
   
   vngen_text_replace(0, "Miki", "Only one way to find out!", inherit, inherit, 0.25, true);
   
   vngen_audio_play_voice("Miki", MIK_006, 1, 0);
}

if (vngen_event()) {
   vngen_char_replace("Miki", spr_miki_body, spr_miki_face_happy, spr_miki_face_happy_talk, previous, previous, false, 0);
   
   vngen_text_replace(0, previous, "Okay,[pause=0.5] get ready![pause=0.75] H[speed=0.5]eeeer[/speed]e it comes!", inherit, inherit, 0.25, true);
   
   vngen_audio_play_voice("Miki", MIK_007, 1, 0);
}

if (vngen_event()) {
   vngen_char_replace("Miki", spr_miki_body, spr_miki_face, spr_miki_face_talk, previous, previous, false, 0);

   vngen_text_replace(0, previous, "Choose a category to get started!", inherit, inherit, 0.25, true);
   
   vngen_audio_play_voice("Miki", MIK_008, 1, 0);
   vngen_audio_play_voice("Miki", MIK_009, 1, 0);
   
   if (vngen_option("categories", view_width*0.5, view_height*0.5, 0.5, 0.5, snd_hover, snd_select)) {
      vngen_option_create_transformed("opt_start", "Getting Started",  spr_option_main, spr_option_main_hover, spr_option_main_select, -120, -720, -1, fnt_open_large, c_white, 0, 0, 1.1, c_black, 0, 0, 1.2, c_yellow, 0.15, trans_slide_right, 0.5,  ease_elastic_out);
      vngen_option_create_transformed("opt_event", "Events & Actions", spr_option_main, spr_option_main_hover, spr_option_main_select,  -60, -510, -2, fnt_open_large, c_white, 0, 0, 1.1, c_black, 0, 0, 1.2, c_yellow, 0.15, trans_slide_right, 0.75, ease_elastic_out);
      vngen_option_create_transformed("opt_anim",  "Animations",       spr_option_main, spr_option_main_hover, spr_option_main_select,    0, -300, -3, fnt_open_large, c_white, 0, 0, 1.1, c_black, 0, 0, 1.2, c_yellow, 0.15, trans_slide_right, 1,    ease_elastic_out);
      vngen_option_create_transformed("opt_ease",  "Easing",           spr_option_main, spr_option_main_hover, spr_option_main_select,   60,  -90, -4, fnt_open_large, c_white, 0, 0, 1.1, c_black, 0, 0, 1.2, c_yellow, 0.15, trans_slide_right, 1.25, ease_elastic_out);
   }
}











/*
GETTING STARTED
*/

if (vngen_event("GETTING_STARTED")) {
   vngen_char_replace("Mei", spr_mei_body, spr_mei_face_happy, spr_mei_face_happy_talk, previous, previous, false, 0);

   vngen_text_replace(0, "Mei", "[speed=0.25]Ooo,[/speed] that one?[pause=0.5] Getting started with VNgen is easy!", inherit, inherit, 0.25, true);
   
   vngen_audio_play_voice("Mei", MEI_005, 1, 0);
}

if (vngen_event()) {   
   vngen_char_replace("Miki", spr_miki_body, spr_miki_face_happy, spr_miki_face_happy_talk, previous, previous, false, 0);
   vngen_char_replace("Mei", spr_mei_body, spr_mei_face, spr_mei_face_talk, previous, previous, false, 0);

   vngen_text_replace(0, "Miki", "Yep![pause=0.5][speed=1.5] In fact,[pause=0.25] if you're watching this right now,[pause=0.25] there's a good chance you've already done it!", inherit, inherit, 0.25, true);

   vngen_audio_play_voice("Miki", MIK_010, 1, 0);
}

if (vngen_event()) {
   vngen_scene_create("frame", spr_frame_import, view_width*0.5, -75, -30, false, false, trans_slide_down, 1.66, ease_elastic);
   vngen_audio_play_sound("woosh", snd_woosh, 1, 0);
   
   vngen_char_replace("Mei", spr_mei_body, spr_mei_face_happy, spr_mei_face_happy_talk, previous, previous, false, 0);

   vngen_text_replace(0, "Mei", "Mhmm![pause=0.5] All you have to do is find VNgen in your GameMaker Studio asset library and import everything to your project!", inherit, inherit, 0.25, true);
   
   vngen_audio_play_voice("Mei", MEI_006, 1, 0);
}

if (vngen_event(0, true)) {
   vngen_scene_destroy("frame", trans_slide_down, 1.66, ease_elastic);
   vngen_audio_play_sound("woosh", snd_woosh, 1, 0);
   
   vngen_text_replace(0, previous, "Then,[pause=0.25] all you have to do is click 'Run' and--", inherit, inherit, 0.25, true);
   
   vngen_audio_play_voice("Mei", MEI_007, 1, 0);
}

if (vngen_event()) {
   vngen_perspective_anim_start(anim_impact, 0.5, false, false);
   
   vngen_scene_create("frame", spr_frame_error, view_width*0.5, -75, -30, false, false, trans_slide_down, 0.25, ease_bounce_out);
   vngen_audio_play_sound("error", snd_error, 1, 0);
   
   vngen_char_replace("Mei", spr_mei_body, spr_mei_face_nerv, spr_mei_face_nerv_talk, previous, previous, false, 0);
   vngen_char_anim_start("Mei", anim_shake, 0.075, true, false);
   
   vngen_textbox_anim_start(0, anim_impact, 0.33, false, false);

   vngen_text_replace(0, previous, "[speed=2]WAH![/speed][pause=0.5] W-[pause=0.25]what was that?!", inherit, inherit, 0.25, true);
   vngen_text_anim_start(0, anim_wiggle, 0.25, false, false);
      
   vngen_audio_play_voice("Mei", MEI_008, 1, 0);
   
   vngen_effect_start(0, ef_scrn_flash, 0.75, false, false);
}

if (vngen_event()) {
   vngen_char_replace("Miki", spr_miki_body, spr_miki_face, spr_miki_face_talk, previous, previous, false, 0);
   vngen_char_anim_stop("Mei");
   
   vngen_text_replace(0, "Miki", "Oh![pause=0.5] Don't worry!", inherit, inherit, 0.25, true);

   vngen_audio_play_voice("Miki", MIK_011, 1, 0);
}

if (vngen_event()) {
   vngen_text_replace(0, previous, "It looks like you're using an older version of GameMaker Studio!", inherit, inherit, 0.25, true);

   vngen_audio_play_voice("Miki", MIK_012, 1, 0);
}

if (vngen_event()) {
   vngen_scene_destroy("frame", trans_slide_down, 1.66, ease_elastic);
   vngen_audio_play_sound("woosh", snd_woosh, 1, 0);
   
   vngen_text_replace(0, previous, "Macros are an important part of VNgen,[pause=0.25] but older versions don't import them automatically.", inherit, inherit, 0.25, true);

   vngen_audio_play_voice("Miki", MIK_013, 1, 0);
}

if (vngen_event()) {
   vngen_scene_create("frame", spr_frame_macros, view_width*0.5, -75, -30, false, false, trans_slide_down, 1.66, ease_elastic);
   vngen_audio_play_sound("woosh", snd_woosh, 1, 0);
   
   vngen_text_replace(0, previous, "Instead,[pause=0.25][speed=1.5] you should import the included macros file in the [color=#FF0, #F60]'Define Macros'[/color] window.[pause=0.75] Then you'll be up and running in no time!", inherit, inherit, 0.25, true);

   vngen_audio_play_voice("Miki", MIK_014, 1, 0);
}

if (vngen_event()) {
   vngen_char_replace("Mei", spr_mei_body, spr_mei_face_happy, spr_mei_face_happy_talk, previous, previous, false, 0);
   
   vngen_emote_create(0, spr_emote_sweat, view_width - 1366, 256, 0);

   vngen_text_replace(0, "Mei", "O-[pause=0.25]oh![pause=0.5] That's not so bad after all!", inherit, inherit, 0.25, true);
   
   vngen_audio_play_voice("Mei", MEI_009, 1, 0);
}

if (vngen_event()) {
   vngen_scene_destroy("frame", trans_slide_down, 1.66, ease_elastic);
   vngen_audio_play_sound("woosh", snd_woosh, 1, 0);

   vngen_char_replace("Miki", spr_miki_body, spr_miki_face_happy, spr_miki_face_happy_talk, previous, previous, false, 0);
   vngen_char_replace("Mei", spr_mei_body, spr_mei_face, spr_mei_face_talk, previous, previous, false, 0);

   vngen_text_replace(0, "Miki", "Not at all![pause=0.5] But remember:[pause=0.25] this only applies to [font=fnt_open_large_italic][speed=0.5]older[/speed][/font] versions of GameMaker Studio.[pause=0.5] Newer versions--[pause0.25]like GameMaker Studio 2--[pause=0.25]have macros built-in[pause=0.25] so you don't have to do anything!", inherit, inherit, 0.25, true);

   vngen_audio_play_voice("Miki", MIK_015, 1, 0);
}

if (vngen_event()) {
   vngen_char_replace("Miki", spr_miki_body, spr_miki_face, spr_miki_face_talk, previous, previous, false, 0);
   vngen_char_replace("Mei", spr_mei_body, spr_mei_face_happy, spr_mei_face_happy_talk, previous, previous, false, 0);

   vngen_text_replace(0, "Mei", "That's really easy!", inherit, inherit, 0.25, true);
   
   vngen_audio_play_voice("Mei", MEI_010, 1, 0);
}

if (vngen_event()) {
   vngen_char_replace("Mei", spr_mei_body, spr_mei_face_nerv, spr_mei_face_nerv_talk, previous, previous, false, 0);
   vngen_char_anim_start("Mei", anim_bounce, 0.33, false, false);
   
   vngen_text_replace(0, "Mei", "Oh![pause=0.5] B-[pause=0.25]but[speed=1.5] what if I don't have VNgen in my asset library?[pause=0.5] Can I still use it?", inherit, inherit, 0.25, true);
   
   vngen_audio_play_voice("Mei", MEI_011, 1, 0);
}

if (vngen_event()) {
   vngen_char_replace("Miki", spr_miki_body, spr_miki_face_happy, spr_miki_face_happy_talk, previous, previous, false, 0);

   vngen_text_replace(0, "Miki", "Of course!", inherit, inherit, 0.25, true);

   vngen_audio_play_voice("Miki", MIK_016, 1, 0);
}

if (vngen_event()) {
   vngen_char_replace("Miki", spr_miki_body, spr_miki_face, spr_miki_face_talk, previous, previous, false, 0);
 
   vngen_text_replace(0, previous, "[speed=1.5]If you purchased VNgen through another store,[pause=0.25] like [color=#FF0, #F60]Itch.io[/color],[pause=0.25][speed=1.25] you can import it as an extension or project file instead.", inherit, inherit, 0.25, true);

   vngen_audio_play_voice("Miki", MIK_017, 1, 0);
}

if (vngen_event()) {
   vngen_char_replace("Mei", spr_mei_body, spr_mei_face_happy, spr_mei_face_happy_talk, previous, previous, false, 0);

   vngen_text_replace(0, "Mei", "Oh?[pause=0.5] [speed=0.5]Whew![/speed][pause=0.5] That's a relief!", inherit, inherit, 0.25, true);
   
   vngen_audio_play_voice("Mei", MEI_012, 1, 0);
}

if (vngen_event()) {
   vngen_char_replace("Miki", spr_miki_body, spr_miki_face_happy, spr_miki_face_happy_talk, previous, previous, false, 0);
   vngen_char_replace("Mei", spr_mei_body, spr_mei_face, spr_mei_face_talk, previous, previous, false, 0);
   
   vngen_text_replace(0, "Miki", "And that's not all!", inherit, inherit, 0.25, true);

   vngen_audio_play_voice("Miki", MIK_018, 1, 0);
}

if (vngen_event()) {
   vngen_char_replace("Miki", spr_miki_body, spr_miki_face, spr_miki_face_talk, previous, previous, false, 0);
   
   vngen_text_replace(0, previous, "Whatever version you're using,[pause=0.25][speed=1.5] you should always make sure to check out the included PDF manual if you have any questions.", inherit, inherit, 0.25, true);

   vngen_audio_play_voice("Miki", MIK_019, 1, 0);
}

if (vngen_event()) {
   vngen_text_replace(0, previous, "You can also find the same documentation online anytime at [link=ev_other, ev_user0][color=#B262C2, #AB22C2]https://xga[pause=0.25].one[pause=0.25]/[pause=0.25]vngen[/color][/link].[pause=1] Go ahead:[pause=0.5][speed=1.5] click the link to head over there right now!", inherit, inherit, 0.25, true);

   vngen_audio_play_voice("Miki", MIK_020, 1, 0);
}

if (vngen_event()) {
   vngen_char_replace("Mei", spr_mei_body, spr_mei_face_happy, spr_mei_face_happy_talk, previous, previous, false, 0);

   vngen_text_replace(0, "Mei", "That sounds really useful![pause=0.5] Thanks, Miki!", inherit, inherit, 0.25, true);
   
   vngen_audio_play_voice("Mei", MEI_013, 1, 0);
}

if (vngen_event()) {
   vngen_char_replace("Miki", spr_miki_body, spr_miki_face_happy, spr_miki_face_happy_talk, previous, previous, false, 0);

   vngen_text_replace(0, "Miki", "[speed=0.25]Aw,[/speed] you're welcome, Mei![pause=0.5] What are VNgen twins for?", inherit, inherit, 0.25, true);

   vngen_audio_play_voice("Miki", MIK_021, 1, 0);
}

if (vngen_event()) {
   vngen_char_replace("Miki", spr_miki_body, spr_miki_face, spr_miki_face_talk, previous, previous, false, 0);
   vngen_char_replace("Mei", spr_mei_body, spr_mei_face, spr_mei_face_talk, previous, previous, false, 0);

   vngen_text_replace(0, "Mei", "Ok,[pause=0.5] what does the audience want to learn about next?", inherit, inherit, 0.25, true);
   
   vngen_audio_play_voice("Mei", MEI_014, 1, 0);
}

if (vngen_event()) {
   if (vngen_option("categories", view_width*0.5, view_height*0.5, 0.5, 0.5, snd_hover, snd_select)) {
      vngen_option_create_transformed("opt_start", "Getting Started",  spr_option_main, spr_option_main_hover, spr_option_main_select, -120, -720, -1, fnt_open_large, c_white, 0, 0, 1.1, c_black, 0, 0, 1.2, c_yellow, 0.15, trans_slide_right, 0.5,  ease_elastic_out);
      vngen_option_create_transformed("opt_event", "Events & Actions", spr_option_main, spr_option_main_hover, spr_option_main_select,  -60, -510, -2, fnt_open_large, c_white, 0, 0, 1.1, c_black, 0, 0, 1.2, c_yellow, 0.15, trans_slide_right, 0.75, ease_elastic_out);
      vngen_option_create_transformed("opt_anim",  "Animations",       spr_option_main, spr_option_main_hover, spr_option_main_select,    0, -300, -3, fnt_open_large, c_white, 0, 0, 1.1, c_black, 0, 0, 1.2, c_yellow, 0.15, trans_slide_right, 1,    ease_elastic_out);
      vngen_option_create_transformed("opt_ease",  "Easing",           spr_option_main, spr_option_main_hover, spr_option_main_select,   60,  -90, -4, fnt_open_large, c_white, 0, 0, 1.1, c_black, 0, 0, 1.2, c_yellow, 0.15, trans_slide_right, 1.25, ease_elastic_out);
      vngen_option_create_transformed("opt_end",   "Finish",           spr_option_main, spr_option_main_hover, spr_option_main_select,  120,  120, -5, fnt_open_large, c_white, 0, 0, 1.1, c_black, 0, 0, 1.2, c_yellow, 0.15, trans_slide_right, 1.5,  ease_elastic_out);
   }
}











/*
EVENTS & ACTIONS
*/

if (vngen_event("EVENTS_ACTIONS")) {
   vngen_char_replace("Mei", spr_mei_body, spr_mei_face_nerv, spr_mei_face_nerv_talk, previous, previous, false, 0);
   
   vngen_emote_create(0, spr_emote_sweat, view_width - 1366, 256, 0);
   
   vngen_text_replace(0, "Mei", "[speed=0.5]Umm...[/speed][pause=0.25] wait.[pause=0.75] What are events and actions?", inherit, inherit, 0.25, true);
   
   vngen_audio_play_voice("Mei", MEI_015, 1, 0);
}

if (vngen_event()) {
   vngen_char_replace("Miki", spr_miki_body, spr_miki_face_happy, spr_miki_face_happy_talk, previous, previous, false, 0);

   vngen_text_replace(0, "Miki", "That's easy![pause=0.5] Events and actions are how you make things happen in VNgen!", inherit, inherit, 0.25, true);

   vngen_audio_play_voice("Miki", MIK_022, 1, 0);
}

if (vngen_event()) {
   vngen_text_replace(0, "Mei", "But...[pause=0.5] doesn't GameMaker Studio already have those?", inherit, inherit, 0.25, true);
   
   vngen_audio_play_voice("Mei", MEI_016, 1, 0);
}

if (vngen_event()) {
   vngen_char_replace("Miki", spr_miki_body, spr_miki_face, spr_miki_face_talk, previous, previous, false, 0);
   
   vngen_text_replace(0, "Miki", "Well,[pause=0.25] yes,[pause=0.5] kind of.[pause=0.75] GameMaker events are a way of organizing game behaviors into different categories.[pause=0.5] Usually you'll only need actions to go with them if you're using drag-and-drop.", inherit, inherit, 0.25, true);

   vngen_audio_play_voice("Miki", MIK_023, 1, 0);
}

if (vngen_event()) {
   vngen_text_replace(0, previous, "On the other hand,[pause=0.25] VNgen is a script-based system with events and actions of its own.", inherit, inherit, 0.25, true);

   vngen_audio_play_voice("Miki", MIK_024, 1, 0);
}

if (vngen_event()) {
   vngen_text_replace(0, "Mei", "[speed=0.5]Umm,[/speed][pause=0.5] I'm not sure I get it.[pause=0.5] So,[pause=0.5] if VNgen doesn't use [speed=0.5][font=fnt_open_large_italic]GameMaker's[/font][/speed] events and actions,[pause=0.25] where do I put it?", inherit, inherit, 0.25, true);
   
   vngen_audio_play_voice("Mei", MEI_017, 1, 0);
}

if (vngen_event()) {
   vngen_text_replace(0, "Miki", "Well,[pause=0.5] VNgen [speed=0.5][font=fnt_open_large_italic]does[/font][speed=1.5] use a few different GameMaker events to get things up and running--[pause=0.25]like [color=#FF0, #F60]'Create'[/color][pause=0.25] and [color=#FF0, #F60]'Draw'[/color]--[pause=0.25]but other than that,[pause=0.25] all you need is the [color=#FF0, #F60]'Step'[/color] event.[pause=0.5] That's where all of VNgen's events and actions go!", inherit, inherit, 0.25, true);

   vngen_audio_play_voice("Miki", MIK_025, 1, 0);
}

if (vngen_event()) {
   vngen_text_replace(0, previous, "It's all in code,[pause=0.25] but don't worry:[pause=0.25] it's simple!", inherit, inherit, 0.25, true);

   vngen_audio_play_voice("Miki", MIK_026, 1, 0);
}

if (vngen_event()) {
   vngen_text_replace(0, previous, "Here,[pause=0.25][speed=1.25] let me show you!", inherit, inherit, 0.25, true);

   vngen_audio_play_voice("Miki", MIK_027, 1, 0);
}

if (vngen_event()) {
   vngen_scene_create("frame", spr_frame_script, view_width*0.5, -75, -30, false, false, trans_slide_down, 1.66, ease_elastic);
   vngen_audio_play_sound("woosh", snd_woosh, 1, 0);
}

if (vngen_event()) {   
   vngen_emote_create(0, spr_emote_sweat, view_width - 1366, 256, 0);
   
   vngen_text_replace(0, "Mei", "Woah![pause=0.75] Th-[pause=0.25]that's a lot of code!", inherit, inherit, 0.25, true);
   
   vngen_audio_play_voice("Mei", MEI_018, 1, 0);
}

if (vngen_event()) {
   vngen_char_replace("Miki", spr_miki_body, spr_miki_face_happy, spr_miki_face_happy_talk, previous, previous, false, 0);

   vngen_text_replace(0, "Miki", "It might look like a lot at first,[pause=0.25] but once you break it down,[pause=0.25] it's not hard at all!", inherit, inherit, 0.25, true);

   vngen_audio_play_voice("Miki", MIK_028, 1, 0);
}

if (vngen_event()) {
   vngen_scene_replace("frame", spr_frame_events, 0);
   
   vngen_char_replace("Miki", spr_miki_body, spr_miki_face, spr_miki_face_talk, previous, previous, false, 0);
   
   vngen_text_replace(0, previous, "[speed=1.5]Think of your visual novel scripts like a timeline.[/speed][pause=0.5] Events are a way of organizing actions so they play out in the right sequence.", inherit, inherit, 0.25, true);

   vngen_audio_play_voice("Miki", MIK_029, 1, 0);
}

if (vngen_event()) {
   vngen_text_replace(0, previous, "[speed=2]Only one event is active at a time,[pause=0.5][speed=1.5] and the next will only activate once all actions in the current event are complete.", inherit, inherit, 0.25, true);

   vngen_audio_play_voice("Miki", MIK_030, 1, 0);
}

if (vngen_event()) {   
   vngen_scene_replace("frame", spr_frame_actions, 0);
   
   vngen_text_replace(0, "Mei", "So[speed=0.5]...[/speed][pause=0.5] all those things inside the events[speed=0.5]...[/speed][pause=0.5] are actions?", inherit, inherit, 0.25, true);
   
   vngen_audio_play_voice("Mei", MEI_019, 1, 0);
}

if (vngen_event()) {
   vngen_char_replace("Miki", spr_miki_body, spr_miki_face_happy, spr_miki_face_happy_talk, previous, previous, false, 0);

   vngen_text_replace(0, "Miki", "You got it![pause=0.5] Oh,[pause=0.5][speed=1.5] and you can have as many actions as you want in a single event, too.[pause=0.5] Neat,[pause=0.25] huh?", inherit, inherit, 0.25, true);

   vngen_audio_play_voice("Miki", MIK_031, 1, 0);
}

if (vngen_event()) {   
   vngen_scene_replace("frame", spr_frame_script, 0);
   
   vngen_char_replace("Mei", spr_mei_body, spr_mei_face, spr_mei_face_talk, previous, previous, false, 0);
   
   vngen_text_replace(0, "Mei", "Hmm[speed=0.5]...[/speed][pause=0.5] I think I'm starting to get it.[pause=0.5] But[speed=0.5]...[/speed][pause=0.25] how do I know what actions are available to use?", inherit, inherit, 0.25, true);
   
   vngen_audio_play_voice("Mei", MEI_020, 1, 0);
}

if (vngen_event()) {
   vngen_text_replace(0, "Miki", "[speed=1.5]Just look in the [color=#FF0, #F60]'Actions'[/color] folder in your VNgen project!", inherit, inherit, 0.25, true);

   vngen_audio_play_voice("Miki", MIK_032, 1, 0);
}

if (vngen_event()) {
   vngen_char_replace("Miki", spr_miki_body, spr_miki_face, spr_miki_face_talk, previous, previous, false, 0);
   
   vngen_text_replace(0, previous, "[speed=1.5]Actions are divided into categories[pause=0.25] so you can easily find what you're looking for.[pause=0.5] There's actions for scenes,[pause=0.25] characters,[pause=0.25] text,[pause=0.5] audio--[pause=0.5]you name it!", inherit, inherit, 0.25, true);

   vngen_audio_play_voice("Miki", MIK_033, 1, 0);
}

if (vngen_event()) {
   vngen_text_replace(0, previous, "Also,[pause=0.5][speed=1.25] most actions follow a set of standard rules.[pause=0.5] There are create,[pause=0.25] destroy,[pause=0.25] modify,[pause=0.25] and replace actions for just about everything in VNgen!", inherit, inherit, 0.25, true);

   vngen_audio_play_voice("Miki", MIK_034, 1, 0);
}

if (vngen_event()) {
   vngen_char_replace("Miki", spr_miki_body, spr_miki_face_happy, spr_miki_face_happy_talk, previous, previous, false, 0);
   
   vngen_text_replace(0, previous, "Learn one set of actions,[pause=0.25][speed=1.25] and you've basically learned them all!", inherit, inherit, 0.25, true);

   vngen_audio_play_voice("Miki", MIK_035, 1, 0);
}

if (vngen_event()) {
   vngen_char_replace("Mei", spr_mei_body, spr_mei_face_happy, spr_mei_face_happy_talk, previous, previous, false, 0);

   vngen_text_replace(0, "Mei", "Oh![pause=0.5] I can handle that.", inherit, inherit, 0.25, true);
   
   vngen_audio_play_voice("Mei", MEI_021, 1, 0);
}

if (vngen_event()) {
   vngen_scene_destroy("frame", trans_slide_down, 1.66, ease_elastic);
   vngen_audio_play_sound("woosh", snd_woosh, 1, 0);
   
   vngen_char_replace("Miki", spr_miki_body, spr_miki_face, spr_miki_face_talk, previous, previous, false, 0);
   vngen_char_replace("Mei", spr_mei_body, spr_mei_face, spr_mei_face_talk, previous, previous, false, 0);
   
   vngen_text_replace(0, "Miki", "Of course,[pause=0.25] there [font=fnt_open_large_italic]are[/font] some exceptions.[pause=0.5][speed=1.5] But don't worry![/speed][pause=0.5][speed=1.5] Everything is explained in detail in the included PDF manual.", inherit, inherit, 0.25, true);

   vngen_audio_play_voice("Miki", MIK_036, 1, 0);
}

if (vngen_event()) {
   vngen_text_replace(0, previous, "You can also find the same documentation online anytime at [link=ev_other, ev_user0][color=#B262C2, #AB22C2]https://xga[pause=0.25].one[pause=0.25]/[pause=0.25]vngen[/color][/link].[pause=1] Go ahead:[pause=0.5][speed=1.5] click the link to head over there right now!", inherit, inherit, 0.25, true);

   vngen_audio_play_voice("Miki", MIK_020, 1, 0);
}

if (vngen_event()) {
   vngen_text_replace(0, previous, "Also,[pause=0.25] VNgen includes functional demo objects for you to play with and learn from.[pause=0.25][speed=2] Feel free to use them as a starting point for your own projects!", inherit, inherit, 0.25, true);

   vngen_audio_play_voice("Miki", MIK_037, 1, 0);
}

if (vngen_event()) {
   vngen_char_replace("Mei", spr_mei_body, spr_mei_face_happy, spr_mei_face_happy_talk, previous, previous, false, 0);

   vngen_text_replace(0, "Mei", "Thanks![pause=0.5] I think I'll do that.", inherit, inherit, 0.25, true);
   
   vngen_audio_play_voice("Mei", MEI_022, 1, 0);
}

if (vngen_event()) {
   vngen_char_replace("Mei", spr_mei_body, spr_mei_face, spr_mei_face_talk, previous, previous, false, 0);
   
   vngen_text_replace(0, previous, "Ok,[pause=0.5] what does the audience want to learn about next?", inherit, inherit, 0.25, true);
   
   vngen_audio_play_voice("Mei", MEI_014, 1, 0);
}

if (vngen_event()) {
   if (vngen_option("categories", view_width*0.5, view_height*0.5, 0.5, 0.5, snd_hover, snd_select)) {
      vngen_option_create_transformed("opt_start", "Getting Started",  spr_option_main, spr_option_main_hover, spr_option_main_select, -120, -720, -1, fnt_open_large, c_white, 0, 0, 1.1, c_black, 0, 0, 1.2, c_yellow, 0.15, trans_slide_right, 0.5,  ease_elastic_out);
      vngen_option_create_transformed("opt_event", "Events & Actions", spr_option_main, spr_option_main_hover, spr_option_main_select,  -60, -510, -2, fnt_open_large, c_white, 0, 0, 1.1, c_black, 0, 0, 1.2, c_yellow, 0.15, trans_slide_right, 0.75, ease_elastic_out);
      vngen_option_create_transformed("opt_anim",  "Animations",       spr_option_main, spr_option_main_hover, spr_option_main_select,    0, -300, -3, fnt_open_large, c_white, 0, 0, 1.1, c_black, 0, 0, 1.2, c_yellow, 0.15, trans_slide_right, 1,    ease_elastic_out);
      vngen_option_create_transformed("opt_ease",  "Easing",           spr_option_main, spr_option_main_hover, spr_option_main_select,   60,  -90, -4, fnt_open_large, c_white, 0, 0, 1.1, c_black, 0, 0, 1.2, c_yellow, 0.15, trans_slide_right, 1.25, ease_elastic_out);
      vngen_option_create_transformed("opt_end",   "Finish",           spr_option_main, spr_option_main_hover, spr_option_main_select,  120,  120, -5, fnt_open_large, c_white, 0, 0, 1.1, c_black, 0, 0, 1.2, c_yellow, 0.15, trans_slide_right, 1.5,  ease_elastic_out);
   }
}











/*
ANIMATIONS
*/

if (vngen_event("ANIMATIONS")) {
   vngen_char_replace("Miki", spr_miki_body, spr_miki_face_happy, spr_miki_face_happy_talk, previous, previous, false, 0);
   vngen_char_replace("Mei", spr_mei_body, spr_mei_face_happy, spr_mei_face_happy_talk, previous, previous, false, 0);

   vngen_text_replace(0, "Miki", "Excellent choice!", inherit, inherit, 0.25, true);

   vngen_audio_play_voice("Miki", MIK_038, 1, 0);
}

if (vngen_event()) {
   vngen_char_replace("Miki", spr_miki_body, spr_miki_face, spr_miki_face_talk, previous, previous, false, 0);
   
   vngen_text_replace(0, previous, "VNgen may be designed for visual novels,[pause=0.25][speed=1.5] but when you really think about it,[pause=0.25] it's just a collection of fancy animation tools.[pause=0.75] You can use it however you want!", inherit, inherit, 0.25, true);

   vngen_audio_play_voice("Miki", MIK_039, 1, 0);
}

if (vngen_event()) {
   vngen_char_replace("Mei", spr_mei_body, spr_mei_face, spr_mei_face_talk, previous, previous, false, 0);
   
   vngen_text_replace(0, "Mei", "That may be true,[pause=0.5] but there's [font=fnt_open_large_italic]lots[/font] of ways to animate your visual novels too!", inherit, inherit, 0.25, true);
   
   vngen_audio_play_voice("Mei", MEI_023, 1, 0);
}

if (vngen_event("event_perspective")) {
   vngen_char_replace("Miki", spr_miki_body, spr_miki_face_happy, spr_miki_face_happy_talk, previous, previous, false, 0);

   vngen_text_replace(0, "Miki", "Absolutely![pause=0.5][speed=1.25] Try moving your mouse, for instance!", inherit, inherit, 0.25, true);

   vngen_audio_play_voice("Miki", MIK_040, 1, 0);
}

if (vngen_event("event_perspective")) {
   vngen_char_replace("Miki", spr_miki_body, spr_miki_face, spr_miki_face_talk, previous, previous, false, 0);
   
   vngen_text_replace(0, previous, "...", inherit, inherit, 0.25, true);
}

if (vngen_event("event_perspective")) {
   vngen_text_replace(0, "Mei", "...", inherit, inherit, 0.25, true);
}

if (vngen_event()) {
   vngen_perspective_modify_pos(0, -150, 0, 0, 1.2, 0, 1, 2, ease_quad); 
   
   vngen_char_replace("Miki", spr_miki_body, spr_miki_face_happy, spr_miki_face_happy_talk, previous, previous, false, 0);
   
   vngen_text_replace(0, "Miki", "Well?[pause=0.25][speed=1.25] Did you see it?", inherit, inherit, 0.25, true);

   vngen_audio_play_voice("Miki", MIK_041, 1, 0);
}

if (vngen_event()) {
   vngen_script_execute_ext(vngen_perspective_modify_direct, 0, -150, 0, 0, 1.2, 0, 1);

   vngen_char_replace("Mei", spr_mei_body, spr_mei_face_happy, spr_mei_face_happy_talk, previous, previous, false, 0);

   vngen_text_replace(0, "Mei", "Yeah![pause=0.5] Everything changes perspective almost like it's 3D!", inherit, inherit, 0.25, true);
   
   vngen_audio_play_voice("Mei", MEI_024, 1, 0);
}

if (vngen_event()) {
   vngen_text_replace(0, "Miki", "Exactly![pause=0.5][speed=1.25] VNgen uses its own camera system which you can think of almost like a real camera![pause=0.5] It can move,[pause=0.25] rotate,[pause=0.25] zoom in and out,[pause=0.25] and even change angle!", inherit, inherit, 0.25, true);

   vngen_audio_play_voice("Miki", MIK_042, 1, 0);
}

if (vngen_event()) {
   vngen_text_replace(0, "Mei", "And I can animate all that?", inherit, inherit, 0.25, true);
   
   vngen_audio_play_voice("Mei", MEI_025, 1, 0);
}

if (vngen_event()) {
   vngen_text_replace(0, "Miki", "You betcha!", inherit, inherit, 0.25, true);

   vngen_audio_play_voice("Miki", MIK_043, 1, 0);
}

if (vngen_event()) {
   vngen_char_replace("Miki", spr_miki_body, spr_miki_face, spr_miki_face_talk, previous, previous, false, 0);
   vngen_char_replace("Mei", spr_mei_body, spr_mei_face, spr_mei_face_talk, previous, previous, false, 0);
   
   vngen_text_replace(0, previous, "[speed=1.5]But here's where it gets good:[pause=0.5] did you know that you can animate other things using the [font=fnt_open_large_italic]same[/font] animations as the camera?", inherit, inherit, 0.25, true);

   vngen_audio_play_voice("Miki", MIK_044, 1, 0);
}

if (vngen_event()) {
   vngen_char_replace("Mei", spr_mei_body, spr_mei_face_happy, spr_mei_face_happy_talk, previous, previous, false, 0);
   
   vngen_text_replace(0, "Mei", "WHA?[pause=0.5] Really?![pause=0.5] But that's,[pause=0.25] like,[pause=0.25] super powerful!", inherit, inherit, 0.25, true);
   
   vngen_audio_play_voice("Mei", MEI_026, 1, 0);
   
   vngen_event_pause(3.33);
   
   vngen_char_anim_start("Mei", anim_bounce, 0.33, false, false);
}

if (vngen_event()) {
   vngen_char_replace("Miki", spr_miki_body, spr_miki_face_happy, spr_miki_face_happy_talk, previous, previous, false, 0);

   vngen_text_replace(0, "Miki", "I know, right?[pause=0.5] VNgen comes with dozens of pre-made animations ready to use right out of the box!", inherit, inherit, 0.25, true);

   vngen_audio_play_voice("Miki", MIK_045, 1, 0);
}

if (vngen_event()) {
   vngen_char_replace("Miki", spr_miki_body, spr_miki_face, spr_miki_face_talk, previous, previous, false, 0);
   
   vngen_text_replace(0, previous, "But get this:[pause=0.5] you can also write your own animations[pause=0.25] using keyframes!", inherit, inherit, 0.25, true);

   vngen_audio_play_voice("Miki", MIK_046, 1, 0);
}

if (vngen_event()) {
   vngen_char_replace("Mei", spr_mei_body, spr_mei_face_nerv, spr_mei_face_nerv_talk, previous, previous, false, 0);
   
   vngen_text_replace(0, "Mei", "W-[pause=0.5]what's a[speed=0.5]...[/speed][pause=0.25] keyframe?", inherit, inherit, 0.25, true);
   
   vngen_audio_play_voice("Mei", MEI_027, 1, 0);
}

if (vngen_event()) {
   vngen_scene_create("frame", spr_frame_anim, view_width*0.5, -75, -30, false, false, trans_slide_down, 1.66, ease_elastic);
   vngen_audio_play_sound("woosh", snd_woosh, 1, 0);
   
   vngen_text_replace(0, "Miki", "Keyframes are kind of like events,[pause=0.25] but for animations instead of actions.", inherit, inherit, 0.25, true);

   vngen_audio_play_voice("Miki", MIK_047, 1, 0);
}

if (vngen_event()) {
   vngen_text_replace(0, previous, "[speed=1.5]If you think of your animation scripts like a timeline,[/speed][pause=0.25] keyframes are a way of changing properties so that they play out in the right sequence.", inherit, inherit, 0.25, true);

   vngen_audio_play_voice("Miki", MIK_048, 1, 0);
}

if (vngen_event()) {
   vngen_char_replace("Miki", spr_miki_body, spr_miki_face_happy, spr_miki_face_happy_talk, previous, previous, false, 0);

   vngen_text_replace(0, previous, "Of course,[pause=0.25] you don't have to animate [font=fnt_open_large_italic]every frame[/font] by hand.[pause=0.5] That'd be [font=fnt_open_large_italic]way[/font] too boring.", inherit, inherit, 0.25, true);

   vngen_audio_play_voice("Miki", MIK_049, 1, 0);
}

if (vngen_event()) {
   vngen_scene_destroy("frame", trans_slide_down, 1.66, ease_elastic);
   vngen_audio_play_sound("woosh", snd_woosh, 1, 0);
   
   vngen_char_replace("Miki", spr_miki_body, spr_miki_face, spr_miki_face_talk, previous, previous, false, 0);
   
   vngen_text_replace(0, previous, "[speed=1.5]Just make the keyframes that are interesting to you![/speed][pause=0.5] Then,[pause=0.25] tell VNgen how long the animation should be,[pause=0.25] and it'll fill in the gaps!", inherit, inherit, 0.25, true);

   vngen_audio_play_voice("Miki", MIK_050, 1, 0);
}

if (vngen_event()) {
   vngen_char_replace("Mei", spr_mei_body, spr_mei_face, spr_mei_face_talk, previous, previous, false, 0);
   
   vngen_text_replace(0, "Mei", "So[speed=0.5]...[/speed][pause=0.5] I write my own animation scripts[speed=0.5]...[/speed][pause=0.5] and then I can apply them to anything I want?", inherit, inherit, 0.25, true);
   
   vngen_audio_play_voice("Mei", MEI_028, 1, 0);
}

if (vngen_event()) {
   vngen_char_replace("Miki", spr_miki_body, spr_miki_face_happy, spr_miki_face_happy_talk, previous, previous, false, 0);

   vngen_text_replace(0, "Miki", "Anything at all!", inherit, inherit, 0.25, true);

   vngen_audio_play_voice("Miki", MIK_051, 1, 0);
}

if (vngen_event()) {
   vngen_char_replace("Mei", spr_mei_body, spr_mei_face_happy, spr_mei_face_happy_talk, previous, previous, false, 0);

   vngen_text_replace(0, "Mei", "Wow![pause=0.5] That[pause=0.25] [font=fnt_open_large_italic]IS[/font][pause=0.25] super powerful!", inherit, inherit, 0.25, true);
   
   vngen_audio_play_voice("Mei", MEI_029, 1, 0);
   
   vngen_event_pause(1.33);
   
   vngen_char_anim_start("Mei", anim_bounce, 0.33, false, false);
}

if (vngen_event()) {
   vngen_char_replace("Miki", spr_miki_body, spr_miki_face, spr_miki_face_talk, previous, previous, false, 0);
   
   vngen_text_replace(0, "Miki", "Plus,[pause=0.5] animations come in all sorts of different flavors:[pause=0.5] there's transitions,[pause=0.25] transformations,[pause=0.25] deformations,[pause=0.25] and even special effects!", inherit, inherit, 0.25, true);

   vngen_audio_play_voice("Miki", MIK_052, 1, 0);
}

if (vngen_event()) {
   vngen_char_replace("Mei", spr_mei_body, spr_mei_face, spr_mei_face_talk, previous, previous, false, 0);
   
   vngen_text_replace(0, "Miki", "Each one is separate,[pause=0.25] but they all work basically the same.[pause=0.5] That way,[pause=0.25][speed=2] you don't have to learn a bunch of new stuff each time![pause=0.5] Learn one,[pause=0.25] and you've basically learned them all!", inherit, inherit, 0.25, true);

   vngen_audio_play_voice("Miki", MIK_053, 1, 0);
}

if (vngen_event()) {
   vngen_text_replace(0, "Mei", "Hmm[speed=0.5]...[/speed][pause=0.5] I've heard of deformations.[pause=0.5] Aren't they special somehow?", inherit, inherit, 0.25, true);
   
   vngen_audio_play_voice("Mei", MEI_030, 1, 0);
}

if (vngen_event()) {
   vngen_char_replace("Miki", spr_miki_body, spr_miki_face_happy, spr_miki_face_happy_talk, previous, previous, false, 0);

   vngen_text_replace(0, "Miki", "Well,[pause=0.25] they're [font=fnt_open_large_italic]all[/font] pretty special,[pause=0.25] but you're right!", inherit, inherit, 0.25, true);

   vngen_audio_play_voice("Miki", MIK_054, 1, 0);
}

if (vngen_event()) {
   vngen_scene_create("frame", spr_frame_miki, view_width*0.5, -75, -30, false, false, trans_slide_down, 1.66, ease_elastic);
   vngen_audio_play_sound("woosh", snd_woosh, 1, 0);
   
   vngen_text_replace(0, previous, "[speed=1.5]Did you know you can create characters either as a single image[pause=0.25] or as a combination of several different ones?[pause=0.5] It's totally up to you!", inherit, inherit, 0.25, true);

   vngen_audio_play_voice("Miki", MIK_055, 1, 0);
}

if (vngen_event()) {
   vngen_char_replace("Miki", spr_miki_body, spr_miki_face, spr_miki_face_talk, previous, previous, false, 0);
   
   vngen_text_replace(0, previous, "Each part can be individually animated,[pause=0.25] and with deformations,[pause=0.25] they can bend and move in real-time.[pause=0.25][speed=1.5] It really brings your characters to life!", inherit, inherit, 0.25, true);

   vngen_audio_play_voice("Miki", MIK_056, 1, 0);
}

if (vngen_event()) {
   vngen_char_replace("Mei", spr_mei_body, spr_mei_face_happy, spr_mei_face_happy_talk, previous, previous, false, 0);

   vngen_text_replace(0, "Mei", "Yeah![pause=0.5] That looks really nice!", inherit, inherit, 0.25, true);
   
   vngen_audio_play_voice("Mei", MEI_031, 1, 0);
}

if (vngen_event()) {
   vngen_scene_destroy("frame", trans_slide_down, 1.66, ease_elastic);
   vngen_audio_play_sound("woosh", snd_woosh, 1, 0);
   
   vngen_char_replace("Mei", spr_mei_body, spr_mei_face, spr_mei_face_talk, previous, previous, false, 0);
   
   vngen_text_replace(0, previous, "Ok,[pause=0.5] what does the audience want to learn about next?", inherit, inherit, 0.25, true);
   
   vngen_audio_play_voice("Mei", MEI_014, 1, 0);
}

if (vngen_event()) {
   if (vngen_option("categories", view_width*0.5, view_height*0.5, 0.5, 0.5, snd_hover, snd_select)) {
      vngen_option_create_transformed("opt_start", "Getting Started",  spr_option_main, spr_option_main_hover, spr_option_main_select, -120, -720, -1, fnt_open_large, c_white, 0, 0, 1.1, c_black, 0, 0, 1.2, c_yellow, 0.15, trans_slide_right, 0.5,  ease_elastic_out);
      vngen_option_create_transformed("opt_event", "Events & Actions", spr_option_main, spr_option_main_hover, spr_option_main_select,  -60, -510, -2, fnt_open_large, c_white, 0, 0, 1.1, c_black, 0, 0, 1.2, c_yellow, 0.15, trans_slide_right, 0.75, ease_elastic_out);
      vngen_option_create_transformed("opt_anim",  "Animations",       spr_option_main, spr_option_main_hover, spr_option_main_select,    0, -300, -3, fnt_open_large, c_white, 0, 0, 1.1, c_black, 0, 0, 1.2, c_yellow, 0.15, trans_slide_right, 1,    ease_elastic_out);
      vngen_option_create_transformed("opt_ease",  "Easing",           spr_option_main, spr_option_main_hover, spr_option_main_select,   60,  -90, -4, fnt_open_large, c_white, 0, 0, 1.1, c_black, 0, 0, 1.2, c_yellow, 0.15, trans_slide_right, 1.25, ease_elastic_out);
      vngen_option_create_transformed("opt_end",   "Finish",           spr_option_main, spr_option_main_hover, spr_option_main_select,  120,  120, -5, fnt_open_large, c_white, 0, 0, 1.1, c_black, 0, 0, 1.2, c_yellow, 0.15, trans_slide_right, 1.5,  ease_elastic_out);
   }
}











/*
EASING
*/

if (vngen_event("EASING")) {
   vngen_char_replace("Mei", spr_mei_body, spr_mei_face_happy, spr_mei_face_happy_talk, previous, previous, false, 0);

   vngen_text_replace(0, "Mei", "Easing?[pause=0.5] [font=fnt_open_large_italic]* gasp! *[/font][pause=0.5] Does that mean VNgen gets [font=fnt_open_large_italic]even easier[/font]?!", inherit, inherit, 0.25, true);
   
   vngen_audio_play_voice("Mei", MEI_032, 1, 0);
}

if (vngen_event()) {
   vngen_char_replace("Miki", spr_miki_body, spr_miki_face_happy, spr_miki_face_happy_talk, previous, previous, false, 0);

   vngen_emote_create(0, spr_emote_sweat, 1200, 256, 0);
   
   vngen_text_replace(0, "Miki", "Well[speed=0.5]...[/speed][pause=0.25] not exactly.", inherit, inherit, 0.25, true);

   vngen_audio_play_voice("Miki", MIK_057, 1, 0);
}

if (vngen_event()) {
   vngen_char_replace("Miki", spr_miki_body, spr_miki_face, spr_miki_face_talk, previous, previous, false, 0);
   
   vngen_text_replace(0, previous, "Easing is an animation technique used to smooth out the way animations start and stop.", inherit, inherit, 0.25, true);

   vngen_audio_play_voice("Miki", MIK_058, 1, 0);
}

if (vngen_event()) {
   vngen_char_modify_pos("Miki", 800, 128, -2, 1, 0, 4);

   vngen_text_replace(0, previous, "Without easing,[pause=0.25] I can [speed=0.5]sloooowly[/speed] move around without ever changing my pace.", inherit, inherit, 0.25, true);

   vngen_audio_play_voice("Miki", MIK_059, 1, 0);
}

if (vngen_event()) {
   vngen_text_replace(0, previous, "Oooor[speed=0.5]...[/speed][pause=0.25] [font=fnt_open_large_italic]with[/font] easing[speed=0.5]...", inherit, inherit, 0.25, true);

   vngen_audio_play_voice("Miki", MIK_060, 1, 0);
}

if (vngen_event()) {
   vngen_char_replace("Miki", spr_miki_body, spr_miki_face_happy, spr_miki_face_happy_talk, previous, previous, false, 0);
   vngen_char_replace("Mei", spr_mei_body, spr_mei_face_nerv, spr_mei_face_nerv_talk, previous, previous, false, 0);
   vngen_char_modify_pos("Miki", 1920, 128, -2, 1.1, -2, 0.25, ease_bounce_out);

   vngen_text_replace(0, previous, "[speed=3]I can burst right into your face!", inherit, inherit, 0.25, true);

   vngen_audio_play_voice("Miki", MIK_061, 1, 0);
   
   vngen_effect_start(0, ef_scrn_flash, 0.25, false, false);
   
   vngen_event_pause(0.25);
   
   vngen_char_anim_start("Mei", anim_bounce, 0.33, false, false);
   
   vngen_text_create(1, "Mei", "[font=fnt_open_large_bold]HUWAH!", (view_width*0.5) - 1118, view_height - 425, 0, 2560, inherit, inherit, trans_fade, 0.25, true);
   
   vngen_audio_play_voice("Mei", MEI_033, 1, 0);
}

if (vngen_event()) {
   vngen_char_replace("Miki", spr_miki_body, spr_miki_face, spr_miki_face_talk, previous, previous, false, 0);
   vngen_char_modify_pos("Miki", 480, 128, -2, 1, 0, 2, ease_expo);
   
   vngen_text_replace(0, previous, "Notice how with easing, my speed changes over time?[pause=0.5] That's how easing works:[pause=0.25] it modifies [font=fnt_open_large_italic]acceleration[/font],[pause=0.25] but not[pause=0.25] [font=fnt_open_large_italic]duration[/font].", inherit, inherit, 0.25, true);
   vngen_text_destroy(1, trans_fade, 0.25, true);

   vngen_audio_play_voice("Miki", MIK_062, 1, 0);
}

if (vngen_event()) {
   vngen_text_replace(0, "Mei", "M-[pause=0.5]meaning,[pause0.5] even though easing changes your speed,[pause=0.25][speed=1.5] it doesn't change the length of the animation as a whole?", inherit, inherit, 0.25, true);
   
   vngen_audio_play_voice("Mei", MEI_034, 1, 0);
}

if (vngen_event()) {
   vngen_char_replace("Miki", spr_miki_body, spr_miki_face_happy, spr_miki_face_happy_talk, previous, previous, false, 0);

   vngen_text_replace(0, "Miki", "That's right!", inherit, inherit, 0.25, true);

   vngen_audio_play_voice("Miki", MIK_063, 1, 0);
}

if (vngen_event()) {
   vngen_char_replace("Mei", spr_mei_body, spr_mei_face, spr_mei_face_talk, previous, previous, false, 0);
   
   vngen_text_replace(0, previous, "Plus,[pause=0.25] it can really change the look of an animation too!", inherit, inherit, 0.25, true);

   vngen_audio_play_voice("Miki", MIK_064, 1, 0);
}

if (vngen_event()) {
   vngen_text_replace(0, previous, "[speed=1.5]Just change the ease mode,[pause=0.5][speed=2] and presto![speed=1.5][pause=0.5] It's like you get a whole new animation for free!", inherit, inherit, 0.25, true);

   vngen_audio_play_voice("Miki", MIK_065, 1, 0);
}

if (vngen_event()) {
   vngen_char_replace("Miki", spr_miki_body, spr_miki_face, spr_miki_face_talk, previous, previous, false, 0);
   vngen_char_replace("Mei", spr_mei_body, spr_mei_face_happy, spr_mei_face_happy_talk, previous, previous, false, 0);
   
   vngen_text_replace(0, "Mei", "Wow![pause=0.5] I guess that [font=fnt_open_large_italic]DOES[/font] make things even easier!", inherit, inherit, 0.25, true);
   
   vngen_audio_play_voice("Mei", MEI_035, 1, 0);
}

if (vngen_event()) {
   vngen_char_replace("Mei", spr_mei_body, spr_mei_face_nerv, spr_mei_face_nerv_talk, previous, previous, false, 0);

   vngen_text_replace(0, previous, "Umm[speed=0.5]...[/speed][pause=0.25] wait.[pause=0.5] So[speed=0.5]...[/speed][pause=0.25] how do I actually [font=fnt_open_large_italic]use[/font] easing?", inherit, inherit, 0.25, true);
   
   vngen_audio_play_voice("Mei", MEI_036, 1, 0);
}

if (vngen_event()) {
   vngen_text_replace(0, "Miki", "Simple![pause=0.5][speed=1.5] Just pick an ease mode whenever you start a new animation.[pause=0.75] Instructions will be right there at the bottom of your code editor window!", inherit, inherit, 0.25, true);

   vngen_audio_play_voice("Miki", MIK_066, 1, 0);
}

if (vngen_event()) {
   vngen_scene_create("frame", spr_frame_easings, view_width*0.5, -75, -30, false, false, trans_slide_down, 1.66, ease_elastic);
   vngen_audio_play_sound("woosh", snd_woosh, 1, 0);
   
   vngen_text_replace(0, previous, "There's 30 ease modes altogether,[pause=0.25] all arranged from subtle to strong.", inherit, inherit, 0.25, true);

   vngen_audio_play_voice("Miki", MIK_067, 1, 0);
}

if (vngen_event()) {
   vngen_text_replace(0, previous, "[speed=1.5]Don't worry too much about the names.[pause=0.25] Even if you aren't familiar with the crazy math terms,[pause=0.25] just remember the curve!", inherit, inherit, 0.25, true);

   vngen_audio_play_voice("Miki", MIK_068, 1, 0);
}

if (vngen_event()) {
   vngen_char_replace("Mei", spr_mei_body, spr_mei_face, spr_mei_face_talk, previous, previous, false, 0);
   vngen_char_replace("Miki", spr_miki_body, spr_miki_face_happy, spr_miki_face_happy_talk, previous, previous, false, 0);
   vngen_char_anim_start("Miki", anim_bounce, 0.33, false, false);
   
   vngen_text_replace(0, previous, "The 'bounce' mode is my personal favorite!", inherit, inherit, 0.25, true);

   vngen_audio_play_voice("Miki", MIK_069, 1, 0);
}

if (vngen_event()) {
   vngen_char_replace("Mei", spr_mei_body, spr_mei_face_happy, spr_mei_face_happy_talk, previous, previous, false, 0);
   vngen_char_anim_start("Mei", anim_bounce, 0.33, false, false);

   vngen_text_replace(0, "Mei", "Hehe![pause=0.5] I like that one too!", inherit, inherit, 0.25, true);
   
   vngen_audio_play_voice("Mei", MEI_037, 1, 0);
}

if (vngen_event()) {
   vngen_scene_destroy("frame", trans_slide_down, 1.66, ease_elastic);
   vngen_audio_play_sound("woosh", snd_woosh, 1, 0);
   
   vngen_char_replace("Miki", spr_miki_body, spr_miki_face, spr_miki_face_talk, previous, previous, false, 0);
   vngen_char_replace("Mei", spr_mei_body, spr_mei_face, spr_mei_face_talk, previous, previous, false, 0);
   
   vngen_text_replace(0, previous, "Ok,[pause=0.5] what does the audience want to learn about next?", inherit, inherit, 0.25, true);
   
   vngen_audio_play_voice("Mei", MEI_014, 1, 0);
}

if (vngen_event()) {
   if (vngen_option("categories", view_width*0.5, view_height*0.5, 0.5, 0.5, snd_hover, snd_select)) {
      vngen_option_create_transformed("opt_start", "Getting Started",  spr_option_main, spr_option_main_hover, spr_option_main_select, -120, -720, -1, fnt_open_large, c_white, 0, 0, 1.1, c_black, 0, 0, 1.2, c_yellow, 0.15, trans_slide_right, 0.5,  ease_elastic_out);
      vngen_option_create_transformed("opt_event", "Events & Actions", spr_option_main, spr_option_main_hover, spr_option_main_select,  -60, -510, -2, fnt_open_large, c_white, 0, 0, 1.1, c_black, 0, 0, 1.2, c_yellow, 0.15, trans_slide_right, 0.75, ease_elastic_out);
      vngen_option_create_transformed("opt_anim",  "Animations",       spr_option_main, spr_option_main_hover, spr_option_main_select,    0, -300, -3, fnt_open_large, c_white, 0, 0, 1.1, c_black, 0, 0, 1.2, c_yellow, 0.15, trans_slide_right, 1,    ease_elastic_out);
      vngen_option_create_transformed("opt_ease",  "Easing",           spr_option_main, spr_option_main_hover, spr_option_main_select,   60,  -90, -4, fnt_open_large, c_white, 0, 0, 1.1, c_black, 0, 0, 1.2, c_yellow, 0.15, trans_slide_right, 1.25, ease_elastic_out);
      vngen_option_create_transformed("opt_end",   "Finish",           spr_option_main, spr_option_main_hover, spr_option_main_select,  120,  120, -5, fnt_open_large, c_white, 0, 0, 1.1, c_black, 0, 0, 1.2, c_yellow, 0.15, trans_slide_right, 1.5,  ease_elastic_out);
   }
}











/*
FINISH
*/

if (vngen_event("FINISH")) {
   vngen_char_replace("Mei", spr_mei_body, spr_mei_face_happy, spr_mei_face_happy_talk, previous, previous, false, 0);

   vngen_text_replace(0, "Mei", "Wow![pause=0.5] We sure learned a lot today.[pause=0.5] VNgen has so many cool features!", inherit, inherit, 0.25, true);
   
   vngen_audio_play_voice("Mei", MEI_038, 1, 0);
}

if (vngen_event()) {
   vngen_char_replace("Miki", spr_miki_body, spr_miki_face_happy, spr_miki_face_happy_talk, previous, previous, false, 0);

   vngen_text_replace(0, "Miki", "You betcha![pause=0.5][speed=1.5] And we've barely even scratched the surface!", inherit, inherit, 0.25, true);

   vngen_audio_play_voice("Miki", MIK_070, 1, 0);
}

if (vngen_event()) {
   vngen_char_replace("Mei", spr_mei_body, spr_mei_face_nerv, spr_mei_face_nerv_talk, previous, previous, false, 0);

   vngen_text_replace(0, "Mei", "Really?![pause=0.5] H-[pause=0.5]how much is there?[pause=0.5] I don't think my brain can take it all!", inherit, inherit, 0.25, true);
   
   vngen_audio_play_voice("Mei", MEI_039, 1, 0);
}

if (vngen_event()) {
   vngen_text_replace(0, "Miki", "Relax![pause=0.5] You'll be fine!", inherit, inherit, 0.25, true);

   vngen_audio_play_voice("Miki", MIK_071, 1, 0);
}

if (vngen_event()) {
   vngen_scene_create("frame", spr_frame_backlog, view_width*0.5, -75, -30, false, false, trans_slide_down, 1.66, ease_elastic);
   vngen_audio_play_sound("woosh", snd_woosh, 1, 0);
   
   vngen_char_replace("Miki", spr_miki_body, spr_miki_face, spr_miki_face_talk, previous, previous, false, 0);
   
   vngen_text_replace(0, previous, "[speed=2]If there's anything you want to review,[pause=0.25] just open the backlog![pause=0.75] It keeps track of everything we've said so far!", inherit, inherit, 0.25, true);

   vngen_audio_play_voice("Miki", MIK_072, 1, 0);
}

if (vngen_event()) {
   vngen_char_replace("Miki", spr_miki_body, spr_miki_face_happy, spr_miki_face_happy_talk, previous, previous, false, 0);

   vngen_text_replace(0, previous, "Go on![pause=0.5] Try it yourself!", inherit, inherit, 0.25, true);

   vngen_audio_play_voice("Miki", MIK_073, 1, 0);
}

if (vngen_event()) {
   vngen_scene_destroy("frame", trans_slide_down, 1.66, ease_elastic);
   vngen_audio_play_sound("woosh", snd_woosh, 1, 0);
   
   vngen_char_replace("Mei", spr_mei_body, spr_mei_face_happy, spr_mei_face_happy_talk, previous, previous, false, 0);

   vngen_text_replace(0, "Mei", "[speed=0.5]Aw,[/speed][pause=0.25] thanks, Miki.[pause=0.5] You're so smart!", inherit, inherit, 0.25, true);
   
   vngen_audio_play_voice("Mei", MEI_040, 1, 0);
}

if (vngen_event()) {
   vngen_char_replace("Miki", spr_miki_body, spr_miki_face, spr_miki_face_talk, previous, previous, false, 0);
   
   vngen_text_replace(0, "Miki", "Me?[pause=0.5] Nah![pause=0.75] [font=fnt_open_large_italic]Anyone[/font] can use VNgen!", inherit, inherit, 0.25, true);

   vngen_audio_play_voice("Miki", MIK_074, 1, 0);
}

if (vngen_event()) {
   vngen_char_replace("Mei", spr_mei_body, spr_mei_face, spr_mei_face_talk, previous, previous, false, 0);
   
   vngen_text_replace(0, "Mei", "Hmm[speed=0.5]...[/speed][pause=0.25] yeah![pause=0.5] You're right!", inherit, inherit, 0.25, true);
   
   vngen_audio_play_voice("Mei", MEI_041, 1, 0);
}

if (vngen_event()) {
   vngen_char_replace("Mei", spr_mei_body, spr_mei_face_happy, spr_mei_face_happy_talk, previous, previous, false, 0);

   vngen_text_replace(0, previous, "Ok, then![pause=0.5] I'm gonna do my best!", inherit, inherit, 0.25, true);
   
   vngen_audio_play_voice("Mei", MEI_042, 1, 0);
}

if (vngen_event()) {
   vngen_char_replace("Mei", spr_mei_body, spr_mei_face, spr_mei_face_talk, previous, previous, false, 0);
   
   vngen_text_replace(0, "Miki", "Well![pause=0.5] We're out of time for today!", inherit, inherit, 0.25, true);

   vngen_audio_play_voice("Miki", MIK_075, 1, 0);
}

if (vngen_event()) {
   vngen_char_replace("Mei", spr_mei_body, spr_mei_face_happy, spr_mei_face_happy_talk, previous, previous, false, 0);

   vngen_text_replace(0, "Mei", "[font=fnt_open_large_italic]Minna-san[pause=0.25] arigatou gozaimasu![/font]", inherit, inherit, 0.25, true);
   
   vngen_audio_play_voice("Mei", MEI_043, 1, 0);
}

if (vngen_event()) {
   vngen_char_replace("Miki", spr_miki_body, spr_miki_face_happy, spr_miki_face_happy_talk, previous, previous, false, 0);

   vngen_text_replace(0, "Miki", "Thanks, everyone!", inherit, inherit, 0.25, true);

   vngen_audio_play_voice("Miki", MIK_076, 1, 0);
}

if (vngen_event(0, true)) {
   vngen_perspective_modify_pos(0, 0, 0, 0, 1, 0, 1, 3, ease_quad);
   
   vngen_scene_create_ext("curtain-fg", spr_scene_curtain, orig_center, orig_top, (view_width*0.5), -view_height, 0, scale_x, false, true, trans_none, 0, ease_none);
   vngen_scene_modify_pos("curtain-fg", (view_width*0.5), 0, 0, 1.25, 0, 3);

   vngen_text_replace(0, previous, "See you next time!", inherit, inherit, 0.25, true);
   vngen_text_create(1, "Mei", "See you next time!", (view_width*0.5) - 1118, view_height - 425, 0, 2560, inherit, inherit, trans_fade, 0.25, true);

   vngen_audio_play_sound(1, snd_applause, 1, 0.5, false, true);
   vngen_audio_play_voice("Miki", MIK_077, 1, 0);
   vngen_audio_play_voice("Mei", MEI_044, 1, 0);
}

if (vngen_event(0, true)) {   
   vngen_scene_create("fade", spr_scene_fade, 0, 0, -98, true, true, trans_fade, 5);
   vngen_scene_create_ext("logo", spr_vngen_logo_light, orig_center, orig_center, view_width*0.5, view_height*0.5, -99, scale_x, false, true, trans_fade, 5, ease_quad);
   vngen_scene_modify_pos("logo", view_width*0.5, view_height*0.5, -99, 0.33, 0, 0);
   
   vngen_textbox_destroy(all, trans_wipe_right, 1, ease_quad);
   
   vngen_text_destroy(all, trans_wipe_right, 1, ease_quad);
   
   vngen_label_destroy(all, trans_wipe_right, 0.75, ease_quad);
   
   vngen_prompt_destroy(all, trans_fade, 0.75, ease_circ);
   
   vngen_button_destroy(all, trans_wipe_right, 0.5, ease_quad);
   
   vngen_audio_stop(all, 4);
}

if (vngen_event(0, true)) {
   vngen_scene_destroy("stage", trans_none, 0);
   vngen_scene_destroy("curtain", trans_none, 0);
   vngen_scene_destroy("curtain-fg", trans_none, 0);
   
   vngen_char_destroy(all, trans_none, 0);
}

if (vngen_event(2, true)) {
   vngen_scene_destroy(all, trans_fade, 2);
}

if (vngen_event(1)) {
	//Show restart and close buttons
	vngen_button_create("btn-restart", "", spr_btn_restart, spr_btn_restart_hover, spr_btn_restart_select, camera_get_view_width(view_camera[0])*0.5 - sprite_get_width(spr_btn_restart), camera_get_view_height(view_camera[0])*0.5, -1, fnt_default, c_white, trans_fade, 0.25, ease_quad);
	vngen_button_create("btn-close", "", spr_btn_close, spr_btn_close_hover, spr_btn_close_select, camera_get_view_width(view_camera[0])*0.5 + sprite_get_width(spr_btn_restart), camera_get_view_height(view_camera[0])*0.5, -1, fnt_default, c_white, trans_fade, 0.25, ease_quad);
}

//End VNgen script
vngen_event_reset_target();