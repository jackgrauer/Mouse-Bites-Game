
// Tween
sine_val = Tween_Sine( 0,1, time_sine );

#region Movement

var kLeft,kRight,kUp,kDown;
	kLeft	= keyboard_check( Left );
	kRight	= keyboard_check( Right );
	kUp		= keyboard_check( Up );
	kDown	= keyboard_check( Down );
var kLeftP,kRightP,kUpP,kDownP;
	kLeftP	= keyboard_check_pressed( Left );
	kRightP	= keyboard_check_pressed( Right );
	kUpP	= keyboard_check_pressed( Up );
	kDownP	= keyboard_check_pressed( Down );

var var_time	= global.TIME;

/* old
isFric		= true;
isMove		= false;
*/

if ( kLeft || kRight || kDown || kUp ){
	isMove	= true;
	isFric	= false;
	
	if ( kLeft ){
		if ( vx > 0 )
		isFric = true;
		else{
		dir = 180;
		}
	}
	if ( kRight ){
		if ( vx < 0 )
		isFric = true;
		else{
		dir	= 0;
		}
	}
	if ( kUp ){
		if ( vy > 0 )
		isFric = true;
		else{
		dir = 90;	
		}
	}
	if ( kDown ){
		if ( vy < 0 )
		isFric	= true;
		else{
		dir	= 270;	
		}
	}

}

if ( kLeft ){
	vx = Approach( vx, -spdMax, accel );
}
if ( kRight ){
	vx = Approach( vx, spdMax, accel );
}
if ( kUp ){
	vy	= Approach( vy, -spdMax, accel );
}
if ( kDown ){
	vy	= Approach( vy, spdMax, accel );
}


vx	= Approach( vx, 0, fric );
vy	= Approach( vy, 0, fric );


x+=vx* var_time;
y+=vy* var_time;

// Clamp Position
x	= clamp( x, 0, room_width );
y	= clamp( y, 0, room_height );

#endregion

#region Demonstrate Camera Scripts
if ( !global.DEBUG ){
	if ( mouse_check_button_pressed( mb_left )){
		cam_bars_toggle();
	}
	if ( mouse_check_button( mb_left )){
		cam_zoom( 0.8 );

	} else if ( mouse_check_button_released( mb_left )){
		cam_bars_toggle();
		cam_zoom( 1 );
		cam_shake( shake.jitter, 32, 6, -1 );
		//cam_flash( c_white,0.4,3,1 );
	}
}
#endregion
