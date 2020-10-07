extends Interactable

const Door = preload("res://objects/interactables/Door.tscn")

var _finished_func = funcref(self, "finished")

#
# Implementation of Interactable.interact().
#
func interact(interface: Node, _player: Node):
	if !G.get_prop(G.Keys.STORY_TRAPPED_COMPLETE, false):
		interface.create_dialog("trapped_1", _finished_func)
	else:
		interface.create_dialog("trapped_2")
	

#
# Function to be executed once the dialog is completed.
#
func finished():
	#
	# Wrap up the chapter and give the player Gullivan's Journal.
	#
	G.set_prop(G.Keys.INV_GULLIVANS_JOURNAL, true)
	G.set_prop(G.Keys.STORY_TRAPPED_COMPLETE, true)
	
	#
	# Instantiate the locked door.
	#
	var door = Door.instance()
	
	door.get_node("Interactable").key_prop = G.Keys.INV_HALL_KEY
	door.set_position(Vector2(588, 180))
	
	get_tree().get_root().add_child(door)
