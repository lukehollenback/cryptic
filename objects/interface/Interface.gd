extends CanvasLayer

const DialogBox = preload("res://objects/interface/DialogBox.tscn")
const DialogMessage = preload("res://classes/dialog/DialogMessage.gd")

onready var _player = get_parent().get_node("Player")

func _process(_delta):
	#
	# Hide or show each item's inventory slot depending on if it has been obtained.
	#
	$HouseKey.set_visible(G.get_prop(G.Keys.INV_HOUSE_KEY, false))
	$HallKey.set_visible(G.get_prop(G.Keys.INV_HALL_KEY, false))
	$GullivansJournal.set_visible(G.get_prop(G.Keys.INV_GULLIVANS_JOURNAL, false))
	$BrokenVile.set_visible(G.get_prop(G.Keys.INV_BROKEN_VILE, false))
	$GhostspeakAmulet.set_visible(G.get_prop(G.Keys.INV_GHOSTSPEAK_AMULET, false))
	$Gullivan.set_visible(G.get_prop(G.Keys.STORY_CRYPT_COMPLETE, false))
	
	#
	# Update the interaction message if necessary.
	#
	if _player.nearest_interactable == null:
		$Interaction.set_visible(false)
	else:
		var txt = "[" + C.INTERACT_KEY + "] " + Colors.parse_bbcode(_player.nearest_interactable.action_phrase)
		
		$Interaction.set_bbcode(txt)
		$Interaction.set_visible(true)
	
	#
	# Update the area message if necessary.
	#
	if _player.nearest_area != null:
		$Location.set_text(_player.nearest_area.object_name)
	else:
		$Location.set_text("????")

func _input(event):
	if has_modal(): return
	
	#
	# Interact with the nearest interactable to the player if they are actually standing next
	# to one.
	#
	if event.is_action_pressed("interact") && is_instance_valid(_player.nearest_interactable) && _player.nearest_interactable.has_method("interact"):
		_player.nearest_interactable.interact(self, _player)
	elif event.is_action_pressed("inv_one"):
		if G.get_prop(G.Keys.INV_GULLIVANS_JOURNAL, false):
			create_dialog("journal")
		else:
			create_dialog("tickled")
	elif event.is_action_pressed("inv_two"):
		if G.get_prop(G.Keys.STORY_CRYPT_COMPLETE, false):
			create_dialog("gullivan")
		else:
			create_dialog("tickled")
	elif event.is_action_pressed("screenshot"):
		var capture = get_viewport().get_texture().get_data()
		
		capture.flip_y()
		capture.resize(capture.get_width() * 4, capture.get_height() * 4, false)
		capture.save_png("user://screenshot.png")
		
		print("Screenshot taken and saved to %s." % (OS.get_user_data_dir() + "/screenshot.png"))
#
# Returns whether or not a modal is currently displayed and all other actions should thus be
# prevented.
#
func has_modal():
	return has_node("DialogBox")

#
# Loads the specified dialog resource and creates a new DialogBox modal to show it.
#
func create_dialog(dialog: String, finished_func: FuncRef = null):
	if has_modal(): return
	
	#
	# Actually load the dialog and create a model to display it.
	#
	var msgs = load_dialog(dialog)
	var dialog_box = DialogBox.instance()
	
	dialog_box.dialog = dialog
	dialog_box.msgs = msgs
	dialog_box.finished_func = finished_func
	
	add_child(dialog_box)

#
# Loads the dialog resource of the given name and returns an array of parsed and ordered
# DialogMessages from it.
#
static func load_dialog(dialog_name: String) -> Array:
	#
	# Read the file.
	#
	var file_name = ("res://assets/dialogs/%s.json" % dialog_name)
	var file = File.new()
	var read = ""
	
	file.open(file_name, File.READ)
	
	read = file.get_as_text()
		
	file.close()
	
	#
	# Perform necessary interpolation on the read file. We do this here so that we don't have to
	# do it per-message or per-line somewhere else...which could be a performance hit.
	#
	read = Colors.parse_bbcode(read)
	
	#
	# Parse the file from JSON into an array of DialogMessages.
	#
	var json = JSON.parse(read)
	var json_obj = json.get_result()
	var json_msgs = json_obj.get("Messages")
	var dialog_msgs = [ ]
	
	for json_msg in json_msgs:
		var msg_actor = json_msg.get("Actor")
		var msg_actor_color_raw = json_msg.get("ActorColor", "gray")
		var msg_actor_color = Colors.lookup_color(msg_actor_color_raw)
		var msg_content = json_msg.get("Message")
		var dialog_msg = DialogMessage.new(msg_actor, msg_actor_color, msg_content)
		
		dialog_msgs.append(dialog_msg)
		
	#
	# Output some debug info.
	#
	print("Loaded \"%s\" dialog." % file_name)
	
	#
	# Return the loaded DialogMessages.
	#
	return dialog_msgs
