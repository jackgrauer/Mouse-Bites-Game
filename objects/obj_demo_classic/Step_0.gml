/// @description Perform VNgen script

//Petform on-screen button actions
switch (vngen_get_button()) {
   case "restart": game_restart(); break;
   case "close": game_end(); break;
}

//Begin VNgen script
vngen_event_set_target();

//Perform events and actions
if (vngen_event(0, true)) {
   //Create scene elements
   vngen_scene_create_ext("bg", spr_scene_classic, orig_center, orig_center, camera_get_view_width(view_camera[0])*0.5, camera_get_view_height(view_camera[0])*0.5, 0, scale_x_y, false, false, trans_fade, 0.5, ease_sin);
   vngen_char_create_ext("Robo Joe", spr_robot_body, spr_robot_idle, spr_robot_talk, orig_left, orig_bottom, 0, camera_get_view_height(view_camera[0]), -2, 222, 100, scale_prop_y, false, 3, trans_slide_right, 0.5, ease_sin);
   vngen_textbox_create("tb", spr_textbox, 0, camera_get_view_height(view_camera[0]), 0, trans_wipe_up, 0.75);
   vngen_text_create("txt", "Robo Joe", "[pause=0.33]Hello,[pause=0.5] and welcome to XGASOFT VNgen,[pause=0.5] the next-gen visual novel engine![pause=0.66] Are you ready to--", camera_get_view_width(view_camera[0])*0.15, camera_get_view_height(view_camera[0]) - 160, 0, camera_get_view_width(view_camera[0])*0.7, fnt_open, c_white, trans_wipe_up, 0.75);
   vngen_label_create("names", auto, camera_get_view_width(view_camera[0])*0.13, camera_get_view_height(view_camera[0]) - 210, 0, camera_get_view_width(view_camera[0])*0.5, fnt_open_bold, c_orange, trans_wipe_up, 0.8);
   vngen_prompt_create("prompt", spr_prompt_wip, none, spr_prompt_auto, auto, auto, 0, trans_fade, 1);
   
   //Apply style modifications
   vngen_char_deform_start("Robo Joe", def_breathe, 3.35, true, false);
   vngen_text_modify_style("txt", c_white, c_white, c_ltgray, c_ltgray, c_black, c_black, 1, 0);
   vngen_label_modify_style("names", c_yellow, c_yellow, c_orange, c_orange, c_black, c_black, 1, 0);

   //Apply text speed
   vngen_script_execute_ext(vngen_set_speed, 25);
         
   //Play audio
   vngen_event_pause(0.15);
   vngen_audio_play_voice("Robo Joe", va_classic1, 1, 0, false, "en-US");
   vngen_audio_play_voice("Robo Joe", va_classic1_jp, 1, 0, false, "ja");
}

if (vngen_event()) {
   //Create/replace scene elements
   vngen_char_create_ext("Robo Schmo", spr_robot_body, spr_robot_idle, spr_robot_talk, orig_left, orig_bottom, camera_get_view_width(view_camera[0]), camera_get_view_height(view_camera[0]), -1, 222, 100, scale_prop_y, true, 3.25, trans_slide_left, 0.5, ease_sin);
   vngen_text_replace("txt", "Robo Schmo", "[speed=1.5]Woah, woah, woah, woah![pause=0.25] Hold up![pause=0.75][/speed] 'VNgen'?[pause=0.75] 'Visual novel'?[pause=0.75] What's [font=fnt_open_italic]that[/font]?", previous, previous, 0.5);
   
   //Apply style modifications
   vngen_char_deform_start("Robo Schmo", def_breathe, 3.53, true, false);
   vngen_label_modify_style("names", c_aqua, c_aqua, c_blue, c_blue, c_black, c_black, 1, 0);
   
   //Play audio
   vngen_audio_play_voice("Robo Schmo", va_classic2, 1, 0, false, "en-US");
   vngen_audio_play_voice("Robo Schmo", va_classic2_jp, 1, 0, false, "ja");
}

if (vngen_event()) {
   //Create vox in place of voices
   vngen_vox_play("Robo Joe", snd_vox, 0.75, 1.75, 1);
   vngen_vox_play("Robo Schmo", snd_vox, 0.75, 1.75, 1);
   
   //Replace text
   vngen_text_replace("txt", "Robo Joe", "You should know![pause=0.25] You're in it!", previous, previous, 0.5);
}

if (vngen_event()) {
   vngen_text_replace("txt", "Robo Schmo", "...", previous, previous, 0.5);
}

if (vngen_event()) {
   vngen_text_replace("txt", previous, "... I don't get it.", previous, previous, 0.5);
}

if (vngen_event()) {
   vngen_char_replace("Robo Joe", spr_robot_body, spr_robot_annoyed, spr_robot_annoyed_talk, 222, 100, false, 0);
   vngen_text_replace("txt", "Robo Joe", "[font=fnt_open_italic]* sigh *", previous, previous, 0.5);
}

if (vngen_event()) {
   vngen_char_replace("Robo Joe", spr_robot_body, spr_robot_idle, spr_robot_talk, 222, 100, false, 0);
   vngen_text_replace_ext("txt", previous, "Alright. A [color=#F00]visual novel[/color] is like a regular novel--[pause=0.25]a story,[pause=0.25] usually a long one, told primarily through writing. " + 
                                           "Unlike regular novels, though, visual novels are[speed=0.25]...[/speed][pause=0.25] well,[pause=0.25] visual.[pause=0.25] They have textboxes, backgrounds, and character graphics " +
                                           "like you and me to keep things interesting.", orig_left, orig_top, scale_none, camera_get_view_width(view_camera[0])*0.7, previous, previous, 0.5, true);
}

if (vngen_event()) {
   vngen_text_replace("txt", "Robo Schmo", "And this 'VNgen' is one of those things?", previous, previous, 0.5);
}

if (vngen_event()) {
   vngen_text_replace("txt", "Robo Joe", "Sort of.[pause=0.25] [color=#F00]VNgen[/color] is a tool for creating visual novels of your own.[pause=0.25] It's fast,[pause=0.25] powerful,[pause=0.25] attractive,[pause=0.25] and easy-to-learn.", previous, previous, 0.5);
}

if (vngen_event()) {
   vngen_text_replace("txt", "Robo Schmo", "How easy are we talking here?[pause=0.25] Can my grandma do it?", previous, previous, 0.5);
}

if (vngen_event()) {
   vngen_char_replace("Robo Joe", spr_robot_body, spr_robot_annoyed, spr_robot_annoyed_talk, 222, 100, false, 0);
   vngen_text_replace("txt", "Robo Joe", "Ok, first of all, you're a robot.[pause=0.25] You don't even [font=fnt_open_italic]have[/font] a grandma.", previous, previous, 0.5);
}

if (vngen_event()) {
   vngen_text_replace("txt", previous, "Second, well...", previous, previous, 0.5);
}

if (vngen_event()) {
   vngen_char_replace("Robo Schmo", spr_robot_body, spr_robot_scared, spr_robot_scared, 222, 100, false, 0);
   vngen_char_replace("Robo Joe", spr_robot_body, spr_robot_idle, spr_robot_talk, 222, 100, false, 0);
   vngen_text_replace("txt", previous, "Of [font=fnt_open_italic]course[/font] she can!", previous, previous, 0.5);
   
   //Perform animations
   vngen_effect_start("flash", ef_scrn_flash, 0.33, false, false);
   vngen_perspective_anim_start(anim_impact, 0.33, false, false);
   vngen_event_pause(0.33);
   vngen_char_anim_start("Robo Joe", anim_quake, 0.25, false, false);
}

if (vngen_event()) {
   vngen_text_replace("txt", previous, "VNgen only requires two objects to work.[pause=0.25] How easy is that?", previous, previous, 0.5);
}

if (vngen_event()) {
   vngen_char_replace("Robo Schmo", spr_robot_body, spr_robot_idle, spr_robot_talk, 222, 100, false, 0);
   vngen_text_replace("txt", "Robo Schmo", "[font=fnt_open_italic]Two objects?[/font][pause=0.25] That's all?", previous, previous, 0.5);
}

if (vngen_event()) {
   vngen_text_replace("txt", "Robo Joe", "Well, you might want more than that if you're going to tell a very long story.[pause=0.25] But yes,[pause=0.25] everything you've seen so far " +
                                         "has been run in only two objects:[pause=0.25] a [color=#FF0]script object[/color], and a [color=#0FF]backlog[/color].", previous, previous, 0.5);
}

if (vngen_event()) {
   vngen_text_replace("txt", "Robo Schmo", "'Backlog'?[pause=0.33] What's that?", previous, previous, 0.5);
}

if (vngen_event()) {
   vngen_text_replace("txt", "Robo Joe", "Well, it's an object that keeps a running record of all the text and spoken dialog that you've seen so far.", previous, previous, 0.5);
}

if (vngen_event()) {
   vngen_text_replace("txt", "Robo Schmo", "[font=fnt_open_italic][speed=0.25]All[/speed][/font] of it?", previous, previous, 0.5);
}

if (vngen_event()) {
   vngen_text_replace("txt", "Robo Joe", "Why don't you try giving the " + str_log_btn + " a push and see for yourself?", previous, previous, 0.5);
}

if (vngen_event()) {
   vngen_text_replace("txt", previous, "By the way, it doesn't [font=fnt_open_italic]have[/font] to be the " + str_log_btn + ", you know.[pause=0.25] Anything can open or close the backlog--[pause=0.25]the keyboard,[pause=0.25] a gamepad,[pause=0.25] on-screen button,[pause=0.25] you name it![pause=0.25] " +
                                       "Just drop a script into the input event of your choice and you're good to go!", previous, previous, 0.5);
}

if (vngen_event()) {
   vngen_text_replace("txt", previous, "Pretty cool, huh?", previous, previous, 0.5);
}

if (vngen_event("choice")) {
   //Create options
   if (vngen_option(0, camera_get_view_width(view_camera[0])*0.5, camera_get_view_height(view_camera[0])*0.25, 0.5, 0.5, snd_hover, snd_select)) {
      vngen_option_create_transformed("yes", "Yeah, totally!", spr_option_default, spr_option_light_hover, spr_option_select, 0, 0, -1, fnt_open_bold, c_white, 0, 0, 1.1, c_black, 0, 0, 1.2, c_yellow, 0.25, trans_slide_right, 0.75, ease_elastic_out);
      vngen_option_create_transformed("no", "Eh, it's alright, I guess...", spr_option_default, spr_option_light_hover, spr_option_select, 50, 125, -2, fnt_open_bold, c_white, 0, 0, 1.1, c_black, 0, 0, 1.2, c_yellow, 0.25, trans_slide_right, 1.25, ease_elastic_out);      
   }
   
   //Perform option results
   switch (vngen_get_option()) {
      case "yes": vngen_goto("result_yes", self, false); break;
      case "no": vngen_goto("result_no", self, false); break;
   }
}

if (vngen_event("result_no")) {
   vngen_char_replace("Robo Joe", spr_robot_body, spr_robot_annoyed, spr_robot_annoyed_talk, 222, 100, false, 0);
   vngen_text_replace("txt", "Robo Joe", "[font=fnt_open_italic]* mumble * * mumble *", previous, previous, 0.5);   
   vngen_emote_create_ext("emote", spr_emote_annoyed, orig_left, orig_top, 450, 48, -1, 1, 1, 0, c_white, c_white, c_white, c_white, 1);
}

if (vngen_event()) {
   vngen_text_replace("txt", "Robo Schmo", "Sheesh, tough crowd!", previous, previous, 0.5);   
}

if (vngen_event()) {
   vngen_char_replace("Robo Joe", spr_robot_body, spr_robot_idle, spr_robot_talk, 222, 100, false, 0);
   vngen_text_replace("txt", "Robo Joe", "[font=fnt_open_italic]Ahem!", previous, previous, 0.5);   
   vngen_char_anim_start("Robo Joe", anim_wobble, 0.25, false, false);
}

if (vngen_event("result_yes")) {
   vngen_text_replace("txt", "Robo Joe", "Anyway, like everything else in VNgen, it's all customizable too! The [color=#06F]textbox graphics[/color], [color=#FF0]fonts[/color], [color=#0F6]typewriter effect speed[/color]--" +
                                         "it's all up to you. And yes, it's all done with just a few simple lines of code.", previous, previous, 0.5);   
}

if (vngen_event()) {
   vngen_text_replace("txt", "Robo Schmo", "And those script objects? What about them?", previous, previous, 0.5);   
}

if (vngen_event()) {
   vngen_text_replace("txt", "Robo Joe", "We've been talking in one this whole time! A [color=#F0F]script object[/color] is where all the VNgen magic happens, from fancy animations to the text you're reading right now!", previous, previous, 0.5);   
}

if (vngen_event()) {
   vngen_text_replace("txt", "Robo Schmo", "Ok, is it just me, or have you been speaking in different colors?", previous, previous, 0.5);   
}

if (vngen_event()) {
   vngen_text_replace("txt", "Robo Joe", "[color=#06F]Sure have![/color] VNgen supports inline markup for things like color and fonts, so you can customize each line of text however you like!", previous, previous, 0.5);   
}

if (vngen_event()) {
   vngen_text_replace("txt", "Robo Schmo", "Oh, I get it! So, you mean I can use [color=#F00]red[/color], [color=#0F0]green[/color], [color=#00F]blue[/color]...", previous, previous, 0.5);   
}

if (vngen_event()) {
   vngen_text_replace("txt", "Robo Joe", "I mean you can use [font=fnt_open_bold]whatever[/font] colors you like! VNgen supports a grand total of [font=fnt_open_italic]16,777,216[/font] colors, and text can be displayed in up to [color=#F00,#FF0,#0FF,#00F]four color[/color] gradients as well!", previous, previous, 0.5);   
}

if (vngen_event()) {
   vngen_char_replace("Robo Schmo", spr_robot_body, spr_robot_scared, spr_robot_scared, 222, 100, false, 0);
   vngen_text_replace("txt", "Robo Schmo", "Woah! That's pretty cool!", previous, previous, 0.5);   
}

if (vngen_event()) {
   vngen_char_replace("Robo Schmo", spr_robot_body, spr_robot_idle, spr_robot_talk, 222, 100, false, 0);
   vngen_text_replace("txt", "Robo Joe", "VNgen supports other forms of markup too! Take [color=#F00]links[/color], for example. As the name implies, you can create text links in your visual novels just like in a web browser, only VNgen links can trigger whatever action you want!", previous, previous, 0.5);   
}

if (vngen_event()) {
   vngen_text_replace("txt", "Robo Schmo", "So, could I have my own dictionary in a visual novel?", previous, previous, 0.5);   
}

if (vngen_event()) {
   vngen_text_replace("txt", "Robo Joe", "Of course. Try clicking this word, for instance: [color=#FA0][link=ev_other, ev_user0]zenzizenzizenzic[/link][/color].", previous, previous, 0.5);   
}

if (vngen_event()) {
   vngen_text_replace("txt", "Robo Schmo", "Is that seriously a word?", previous, previous, 0.5);   
}

if (vngen_event()) {
   vngen_text_replace("txt", "Robo Joe", "According to the internet.", previous, previous, 0.5);   
}

if (vngen_event()) {
   vngen_text_replace("txt", "Robo Schmo", "True. What do we know? We're just characters, like you said.", previous, previous, 0.5);   
}

if (vngen_event()) {
   vngen_text_replace("txt", "Robo Joe", "Yes, but it just so happens that [color=#F00]characters[/color] are another big part of VNgen.", previous, previous, 0.5);   
}

if (vngen_event()) {
   vngen_text_replace("txt", "Robo Schmo", "Nice segue.", previous, previous, 0.5);   
}

if (vngen_event()) {
   vngen_text_replace("txt", "Robo Joe", "Thanks. It's also pretty nice how animated we are, isn't it?", previous, previous, 0.5);   
}

if (vngen_event()) {
   vngen_text_replace("txt", "Robo Schmo", "Well, life as a character would be pretty boring if we weren't.", previous, previous, 0.5);   
}

if (vngen_event()) {
   vngen_text_replace("txt", "Robo Joe", "Indeed. But did you know most of our animation is automatic and happening in real-time?", previous, previous, 0.5);   
}

if (vngen_event()) {
   vngen_text_replace("txt", "Robo Schmo", "Automatic? So, like, we don't need to be told when to talk and when not to?", previous, previous, 0.5);   
}

if (vngen_event()) {
   vngen_text_replace("txt", "Robo Joe", "That's right! We always know what our lines are and only speak when it's our turn. When it isn't, we know to shut up and even fade out if we're supposed to.", previous, previous, 0.5);   
}

if (vngen_event()) {
   vngen_char_replace("Robo Schmo", spr_robot_body, spr_robot_annoyed, spr_robot_annoyed_talk, 222, 100, false, 0);
   vngen_text_replace("txt", "Robo Schmo", "One of us does, at least.", previous, previous, 0.5);   
}

if (vngen_event()) {
   vngen_char_replace("Robo Schmo", spr_robot_body, spr_robot_scared, spr_robot_scared, 222, 100, false, 0);
   vngen_text_replace("txt", "Robo Joe", "H-hey! That was uncalled for!", previous, previous, 0.5);
   vngen_emote_create_ext("emote", spr_emote_surprise, orig_left, orig_top, 450, camera_get_view_height(view_camera[0]) - vngen_get_height("Robo Joe", vngen_type_char) + 48, -1, 1, 1, 0, c_white, c_white, c_white, c_white, 1);
   vngen_char_anim_start("Robo Joe", anim_quake, 0.15, true, false);
   vngen_char_modify_ext("Robo Joe", 0, camera_get_view_height(view_camera[0]) + 32, -1, 1.1, 1.1, 0, c_red, c_red, c_white, c_white, 1, 0.5, ease_bounce);
}

if (vngen_event()) {
   vngen_text_replace("txt", "Robo Schmo", "C-come on, it was just a joke!", previous, previous, 0.5);   
}

if (vngen_event()) {
   vngen_text_replace("txt", "Robo Joe", "[speed=0.25]...", previous, previous, 0.5);   
}

if (vngen_event()) {
   vngen_emote_create_ext("emote", spr_emote_surprise, orig_left, orig_top, camera_get_view_width(view_camera[0]) - 450, camera_get_view_height(view_camera[0]) - vngen_get_height("Robo Schmo", vngen_type_char) + 48, -1, 1, 1, 0, c_white, c_white, c_white, c_white, 1);
   vngen_char_modify_ext("Robo Schmo", camera_get_view_width(view_camera[0]), camera_get_view_height(view_camera[0]) + 32, -1, 0.9, 0.9, 0, c_aqua, c_aqua, c_white, c_white, 1, 0.5, ease_bounce);
}

if (vngen_event(0.5, true)) {
   vngen_effect_start("flash", ef_scrn_flash, 0.33, false, false);
   vngen_text_replace("txt", "Robo Schmo", "[speed=2]... Gotta go!", previous, previous, 0.5);   
}

if (vngen_event(0.5, true)) {
   vngen_char_destroy("Robo Schmo", trans_slide_left, 0.5);
}

if (vngen_event()) {
   vngen_text_replace("txt", "Robo Joe", "[speed=2]Wha-![pause=0.25] Hey![pause=0.25] Get back here!", previous, previous, 0.5);   
   vngen_char_modify_ext("Robo Joe", 256, camera_get_view_height(view_camera[0]), -1, 1, 1, 0, c_white, c_white, c_white, c_white, 1, 1, ease_bounce_out);
   vngen_char_anim_stop("Robo Joe");
}

if (vngen_event()) {
   vngen_char_replace("Robo Joe", spr_robot_body, spr_robot_annoyed, spr_robot_annoyed_talk, 222, 100, false, 0);
   vngen_text_replace("txt", previous, "[font=fnt_open_italic]* sigh *", previous, previous, 0.5);
}

if (vngen_event()) {
   vngen_text_replace("txt", previous, "Oh well.", previous, previous, 0.5);
}

if (vngen_event()) {
   vngen_char_replace("Robo Joe", spr_robot_body, spr_robot_idle, spr_robot_talk, 222, 100, false, 0);
   vngen_char_modify_ext("Robo Joe", 1024, camera_get_view_height(view_camera[0]), -1, -1, 1, 0, c_white, c_white, c_white, c_white, 1, 0.5, true);
   vngen_text_replace("txt", previous, "Now, where was I?[pause=0.25] Oh, yes![pause=0.25] Hello, and welcome to XGASOFT VNgen, the next-gen visual novel engine!", previous, previous, 0.5);
}

if (vngen_event()) {
   vngen_text_replace("txt", previous, "Are you ready to tell your story without getting tangled up in code?[pause=0.25] VNgen is here to help.", previous, previous, 0.5);
}

if (vngen_event()) {
   vngen_text_replace("txt", previous, "Let's see...[pause=0.33] 'Chapter 1:[pause=0.25] Once upon a time, a budding storyteller sat down to create a visual novel unlike the world has ever seen.'", previous, previous, 0.5);
}

if (vngen_event()) {
   vngen_text_replace("txt", previous, "...[pause=0.25] There.[pause=0.25] It's a start.", previous, previous, 0.5);
}

if (vngen_event()) {
   vngen_vox_stop(all);
}

if (vngen_event(0, true)) {
   vngen_text_replace("txt", previous, "Now,[pause=0.75] [font=fnt_open_bold]you[/font] fill in the rest.", previous, previous, 0.5);
   vngen_audio_play_voice("Robo Joe", va_classic3, 1, 0, false, "en-US");
   vngen_audio_play_voice("Robo Joe", va_classic3_jp, 1, 0, false, "ja");   
}

if (vngen_event()) {
   vngen_scene_create("fade", spr_scene_classic, 0, 0, -1, true, true, trans_none, 0);
   vngen_scene_modify_style("fade", c_black, c_black, c_black, c_black, 0, 0);
}

if (vngen_event(1, true)) {
   vngen_scene_modify_style("fade", c_black, c_black, c_black, c_black, 1, 5);
   vngen_textbox_destroy("tb", trans_wipe_up, 1);
   vngen_text_destroy("txt", trans_wipe_up, 1);
   vngen_label_destroy("names", trans_wipe_up, 1);
   vngen_prompt_destroy("prompt", trans_fade, 1);
}

if (vngen_event()) {
   vngen_char_destroy(all, trans_none, 0);
   vngen_scene_destroy(all, trans_none, 0);
}

if (vngen_event(1)) {
	//Show restart and close buttons
	vngen_button_create("restart", "", spr_btn_restart, spr_btn_restart_hover, spr_btn_restart_select, camera_get_view_width(view_camera[0])*0.5 - sprite_get_width(spr_btn_restart), camera_get_view_height(view_camera[0])*0.5, -1, fnt_default, c_white, trans_fade, 0.25, ease_quad);
	vngen_button_create("close", "", spr_btn_close, spr_btn_close_hover, spr_btn_close_select, camera_get_view_width(view_camera[0])*0.5 + sprite_get_width(spr_btn_restart), camera_get_view_height(view_camera[0])*0.5, -1, fnt_default, c_white, trans_fade, 0.25, ease_quad);
}

//End VNgen script
vngen_event_reset_target();