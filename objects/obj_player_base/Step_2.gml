/// @description Camera
var _w = camera_get_view_width(view_camera[0])/2,
    _h = camera_get_view_height(view_camera[0])/2,
    _cur_x = camera_get_view_x(view_camera[0]),
    _cur_y = camera_get_view_y(view_camera[0]),
    _x = clamp(x-_w,0,room_width-_w*2),
    _y = clamp(y-_h,0,room_height-_h*2);

_x = lerp(_cur_x,_x,.2);
_y = lerp(_cur_y,_y,.2);

camera_set_view_pos(view_camera[0],_x,_y);