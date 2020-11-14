/// @description Initialize VNgen
vngen_object_init();

//Set viewport scaling
vngen_set_scale(0);

//Set custom cursors
vngen_set_cursor(spr_cr_default, spr_cr_pointer);

//Set button prompt based on platform
str_log_btn = "L key";

//Set mobile log button string
if (os_type == os_android) or (os_type == os_ios) {
   str_log_btn = "back button";
}

//Set text and audio language to English
vngen_set_lang("en-US");

//Set audio language to Japanese
//vngen_set_lang("ja", vngen_type_audio);