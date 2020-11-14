/// @function	vngen_log_init(size);
/// @param		{integer}	size
/// @author		Lucas Chasteen <lucas.chasteen@xgasoft.com>
/// @copyright	XGASOFT 2020, All Rights Reserved
function vngen_log_init(argument0) {

	/*
	Initializes all the necessary functions for running the VNgen backlog in the 
	current object and sets the maximum number of events to record. Must be run 
	in the Create event.

	It is recommended to run log functions in a separate object from main
	VNgen functions. A backlog is not required for VNgen to function.

	Note that the max log size is a value of **events**. If a single event has
	multiple logged actions, additional actions will not be counted towards the
	max value.

	argument0 = the maximum number of events to record (integer)

	Example usage: 
	   vngen_log_init(25);
	*/

	//Set the maximum number of logged events
	global.vg_log_max = argument0;

	//Initialize button functions
	button_count = 0; //Tracks the number of existing buttons
	button_hover = -1; //Tracks which button is currently highlighted, if any
	button_active = -1; //Tracks which button is currently selected, if any
	button_result = -1; //The ID of the most recent button to be selected

	//Initialize mouse properties
	mouse_hover = false; //Tracks whether the mouse is currently hovering text links or options
	mouse_hover_enable = true; //Enables or disables changing cursor states for certain actions
	mouse_hover_check = false; //Tracks the current hover state for cursor changes
	mouse_xprevious = device_mouse_x_to_gui(0); //Tracks the previous mouse horizontal coordinate
	mouse_yprevious = device_mouse_y_to_gui(0); //Tracks the previous mouse vertical coordinate

	//Initialize time properties
	time_frame = delta_time/1000000;
	time_speed = game_get_speed(gamespeed_fps);
	time_target = 1/time_speed;
	time_offset = time_frame/time_target;

	//Initialize log navigation
	log_current = -1; //Tracks which log entry is currently highlighted
	log_count = 0; //Tracks the number of logged events
	log_event = -1; //The ID of the current logged event
	log_y = 0; //Sets the vertical log position to scroll to
	log_ycurrent = 0; //Smoothly transitions to the log scroll position

	//Initialize optional touch scrolling
	log_touch[0] = 0; 
	log_touch[1] = 0;
	log_touch_active = false;
	log_touch_friction = 0.5*time_offset;
	log_touch_momentum = 0;
	log_touch_yoffset = 0;

	//Create primary data structures               // Memory map:
	//------------------------------               // [ 0         | 1      | 2     | 3      | 4       | 5      | 6     | 7       | 8    | 9 | 10   | 11        | 12         | 13        | 14   | 15   | 16   | 17   | 18    | 19   | 20   | 21   | 22   | 23            | 24            | 25   | 26   | 27     | 28     | 29          | 30          | 31       | 32   | 33   | 34   | 35   | 36         | 37   | 38   | 39          | 40           | 41      | 42      | 43           | 44           | 45        | 46         | 47             | 48             | 49            | 50         | 51        | 52          | 53           | 54      | 55      | 56           | 57           | 58        | 59          | 60         | 61              | 62             | 63               | 64                | 65           | 66           | 67                | 68                | 69             | 70               | 71   | 72   | 73   | 74   | 75   | 76   | 77   | 78   | 79   | 80            | 81   | 82   | 83        | 84     | 85     | 86          | 87          | 88   | 89        | 90   | 91   | 92   | 93   | 94        | 95          | 96          | 97               | 98               | 99   | 100            | 101  | 102  | 103  | 104  | 105  | 106  | 107  | 108  | 109  | 110  | 111  | 112  | 113  | 114  | 115       | 116       | 117     | 118       | 119        | 120    | 121    | 122     | 123  | 124  | 125  | 126       | 127       | 128        | 129  | 130    | 131     | 132  | 133  | 134  | 135       | 136         | 137  | 138              | 139            | 140        | 141         | 142    | 143    | 144         | 145         ]
	global.ds_log = ds_grid_create(3, 0);          // [ event     | text   | audio ]
	global.ds_log_button = ds_grid_create(146, 0); // [ id        | sprite | left  | top    | width   | height | xorig | yorig   | x    | y | z    | xscale    | yscale     | rot       | col1 | col2 | col3 | null | alpha | time | null | null | null | offset_xscale | offset_yscale | null | null | temp_x | temp_y | temp_xscale | temp_yscale | temp_rot | null | null | null | null | temp_alpha | null | null | final_width | final_height | final_x | final_y | final_xscale | final_yscale | final_rot | transition | trans_keyframe | trans_duration | trans_reverse | trans_left | trans_top | trans_width | trans_height | trans_x | trans_y | trans_xscale | trans_yscale | trans_rot | trans_alpha | trans_time | trans_temp_left | trans_temp_top | trans_temp_width | trans_temp_height | trans_temp_x | trans_temp_y | trans_temp_xscale | trans_temp_yscale | trans_temp_rot | trans_temp_alpha | null | null | null | null | null | null | null | null | null | anim_duration | null | null | anim_ease | anim_x | anim_y | anim_xscale | anim_yscale | null | anim_col1 | null | null | null | null | anim_time | anim_temp_x | anim_temp_y | anim_temp_xscale | anim_temp_yscale | null | anim_temp_col1 | null | null | null | null | null | null | null | null | null | null | null | null | null | null | img_speed | img_index | img_num | spr_hover | spr_select | text_x | text_y | trigger | null | null | null | text_surf | snd_hover | snd_select | font | null   | null    | null | null | text | null      | null        | null | text_line_height | null           | init_width | init_height | init_x | init_y | init_xscale | init_yscale ]
	global.ds_log_queue = ds_grid_create(2, 1);    // [ event     | queue  ]

	//Secondary data structures
	//ds_log_text = ds_grid_create(140, 0);        // [ null      | name   | null  | null   | null    | height | null  | null    | null | y | null | null      | null       | null      | col1 | col2 | col3 | col4 | alpha | null | null | null | null | null          | null          | null | null | null   | null   | null        | null        | null     | null | null | null | null | null       | null | null | null        | null         | null    | null    | null         | null         | null      | null       | null           | null           | null          |  null      | null      | null        | null         | null    | null    | null         | null         | null      | null        | null       | null            | null           | null             | null              | null         | null         | null              | null              | null           | null             | null | null | null | null | null | null | null | null | null | null          | null | null | null      | null   | null   | null        | null        | null | null      | null | null | null | null | null      | null        | null        | null             | null             | null | null           | null | null | null | null | null | null | null | null | null | null | null | null | null | null | null      | null      | null    | null      | null       | null   | null   | null    | null | null | null | text_surf | null      | null       | font | shadow | outline | null | null | text | text_orig | text_halign | null | text_line_height | text_line_data ]
	//ds_log_audio = ds_queue_create();            

	//Initialize audio queue
	global.ds_log_queue[# prop._data_event, 0] = -1;
	global.ds_log_queue[# prop._data_queue, 0] = -1;


}
