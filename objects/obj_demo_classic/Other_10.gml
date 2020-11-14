/// @description DEMO: Show word definition

//Get fullscreen state
var fullscreen = window_get_fullscreen();

//Temporarily exit fullscreen, if enabled
if (fullscreen == true) {
   window_set_fullscreen(false);
}

//Show message
show_message_async("zenzizenzizenzic (n): A number raised to the eighth power");

//Restore fullscreen, if enabled
if (fullscreen == true) {
   window_set_fullscreen(true);
}