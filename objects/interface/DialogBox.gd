extends ColorRect

var dialog
var msgs
var finished_func

var _msg_index = 0

func _ready():
	$Dialog.set_bbcode(msgs[_msg_index]._to_string())
	$Continue.set_text("Press " + C.INTERACT_KEY + "...")

	print("Created dialog box for %s dialog (with %d messages)." % [dialog, msgs.size()])

func _input(event):
	#
	# If necessary, move on to the next message or destroy this DialogBox modal if the dialog is
	# now over. Prior to destroying, execute the finished function if one was provided.
	#
	if event.is_action_pressed("interact"):
		_msg_index += 1

		if _msg_index >= msgs.size():
			if finished_func != null:
				finished_func.call_func()

			queue_free()
		else:
			$Dialog.set_bbcode(msgs[_msg_index]._to_string())
