/// @description Initialize the backlog
vngen_log_init(50);

//Create on-screen navigation buttons
vngen_log_button_create_transformed("nav_up", "", spr_up_default, spr_up_hover, spr_up_active, display_get_gui_width(), display_get_gui_height()*0.5, 0, fnt_default, c_white, 0, 0, 1.1, c_white, 0, 0, 1.2, c_white, 0.25, ease_elastic_out);
vngen_log_button_create_transformed("nav_dn", "", spr_dn_default, spr_dn_hover, spr_dn_active, display_get_gui_width(), display_get_gui_height()*0.5, 0, fnt_default, c_white, 0, 0, 1.1, c_white, 0, 0, 1.2, c_white, 0.25, ease_elastic_out);