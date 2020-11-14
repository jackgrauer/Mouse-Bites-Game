/// @description Snap Camera
control_mode = mode_keyboard;
var _w = camera_get_view_width(view_camera[0])/2,
    _h = camera_get_view_height(view_camera[0])/2,
    _x = clamp(x-_w,0,room_width-_w*2),
    _y = clamp(y-_h,0,room_height-_h*2);

camera_set_view_pos(view_camera[0],_x,_y);