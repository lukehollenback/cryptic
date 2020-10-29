extends Node2D
	
func _input(event):
	#
	# If a relevant button was pressed, detect it and perform the necessary action.
	#
	if event.is_action_pressed("screenshot"):
		var capture = get_viewport().get_texture().get_data()
		
		capture.flip_y()
		capture.resize(capture.get_width() * 4, capture.get_height() * 4, false)
		capture.save_png("user://screenshot.png")
		
		print("Screenshot taken and saved to %s." % (OS.get_user_data_dir() + "/screenshot.png"))
