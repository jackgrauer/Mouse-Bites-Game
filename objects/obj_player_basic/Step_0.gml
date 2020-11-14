event_inherited();
dpad_dir = point_distance(0,0,input_h,input_v) > 0 
           ? point_direction(0,0,input_h,input_v) 
           : no_direction;
event_user(ev_set_sprite);

movement_and_collision(dpad_dir,
                       max_speed*movement_percent,
                       obj_wall);