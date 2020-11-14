
// Set Camera's target to this object
cam_follow( follow.mpeek , obj_player_demo );


#region Movement 
Left	= ord("A");
Right	= ord("D");
Down	= ord("S");
Up		= ord("W");

vx		= 0;
vy		= 0;
dir		= 0;
spd		= 0;
spdMax	= 12;
accel	= 1.0;
fric	= 0.33;

isMove	= false;
isFric	= false;

r_set	= 24; //radius
r		= r_set;
#endregion

#region Tweenz
sine_val		= 0;
time_sine		= 0;
#endregion
