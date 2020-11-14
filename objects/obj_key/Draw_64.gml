/// @description
draw_self();
draw_sprite_ext(sprite,0,x,y+press,image_xscale,image_yscale,image_angle,image_blend,image_alpha);
draw_sprite_solid_color(sprite,0,x,y+press,image_xscale,image_yscale,image_angle,c_yellow,(press/max_press)/4);