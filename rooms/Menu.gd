extends Node2D

#
# Named indexes of various menu items.
#
enum MenuItems {
	Continue = 0,
	NewGame,
	Credits,
	Website,
}

#
# Preloaded scenes for fast transitions.
#
onready var _overworld_scene = load("res://rooms/Overworld.tscn")
onready var _credits_scene = load("res://rooms/Credits.tscn")

#
# Ordered array of references to each label representing each menu item.
#
onready var menu_nodes = [
	$CanvasLayer/Continue,
	$CanvasLayer/NewGame,
	$CanvasLayer/Credits,
	$CanvasLayer/Website
]

#
# The index of the currently-highlighted menu item.
#
var menu_index = 0

func _ready():
	#
	# Toss out a warning to the console if, for some reason, we know that saving will be
	# unsuccessful. This can happen, for example, if the user has cookies disabled and we are able
	# to detect it while running in a browser.
	#
	if !OS.is_userfs_persistent():
		print("Warning: The user filesystem is not a persistent storage location. Saved games will not persist cross-session.")

	#
	# Highlight the initially-highlighted menu item.
	#
	highlight_menu_item()

	#
	# Show/hide any platform-sepcific messages.
	#
	if OS.has_feature("HTML5"):
		$CanvasLayer/Warning.set_visible(true)
	else:
		$CanvasLayer/Warning.set_visible(false)

func _input(event):
	#
	# If a relevant button was pressed, detect it and perform the necessary action.
	#
	if event.is_action_pressed("move_down"):
		menu_index += 1
	elif event.is_action_pressed("move_up"):
		menu_index -= 1
	elif event.is_action_pressed("interact"):
		match menu_index:
			MenuItems.Continue:
				G.load_game()
				G.handle_error(get_tree().change_scene_to(_overworld_scene))
			MenuItems.NewGame:
				G.handle_error(get_tree().change_scene_to(_overworld_scene))
			MenuItems.Credits:
				G.handle_error(get_tree().change_scene_to(_credits_scene))
			MenuItems.Website:
				G.handle_error(OS.shell_open("https://lukehollenback.itch.io/"))
	elif event.is_action_pressed("screenshot"):
		var capture = get_viewport().get_texture().get_data()

		capture.flip_y()
		capture.resize(capture.get_width() * 4, capture.get_height() * 4, false)
		capture.save_png("user://screenshot.png")

		print("Screenshot taken and saved to %s." % (OS.get_user_data_dir() + "/screenshot.png"))
	elif event.is_action_pressed("exit"):
		get_tree().quit()

	#
	# Box the highlighted menu index into the appropriate range.
	#
	if menu_index >= menu_nodes.size():
		menu_index = 0
	elif menu_index < 0:
		menu_index = (menu_nodes.size() - 1)

	#
	# Highlight the appropriate menu item.
	#
	highlight_menu_item()

#
# Highlights whatever menu item is currently supposed to be.
#
func highlight_menu_item():
	for node in menu_nodes:
		node.set("custom_colors/font_color", Colors.WHITE)

	menu_nodes[menu_index].set("custom_colors/font_color", Colors.YELLOW)
