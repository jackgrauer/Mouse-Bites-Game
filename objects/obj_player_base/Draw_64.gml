/// @description Instructions, LOGO, and Credits
var _margin = 15;
var _gui_w = display_get_gui_width();
var _gui_h = display_get_gui_height();

draw_sprite_ext(spr_banner,0,
                _gui_w-_margin,
                _gui_h-_margin,
                1,1,0,c_white,.5);
				
var _character = ""; 
   
draw_set_halign(fa_left);
draw_set_valign(fa_bottom);
draw_text(_margin,_gui_h-_margin,_character);

var _w = string_width(mode)*2;
var _h = string_height(mode)*2;
draw_set_alpha(.5)
draw_set_color(c_black);
draw_rectangle(_gui_w/2-_w/2-_margin,
               _margin,
               _gui_w/2+_w/2+_margin,
               _margin+_h,
               false);
draw_set_alpha(1)
draw_set_color(c_white);
draw_rectangle(_gui_w/2-_w/2-_margin,
               _margin,
               _gui_w/2+_w/2+_margin,
               _margin+_h,
               true);

draw_set_halign(fa_center);
draw_set_valign(fa_top);
draw_text_transformed(_gui_w/2,_margin,mode,2,2,0);
draw_set_alpha(.5)


draw_set_alpha(1)
//draw_set_halign(fa_left);
//draw_text(5,5,movement_percent);