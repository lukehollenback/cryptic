extends Interactable

const Vile = preload("res://objects/interactables/BrokenVile.tscn")

var _finished_func = funcref(self, "finished")

#
# Implementation of Interactable.interact().
#
func interact(interface: Node, _player: Node):
	if !G.get_prop(G.Keys.STORY_TRAPPED_COMPLETE, false):
		interface.create_dialog("sorcery_1")
	elif !G.get_prop(G.Keys.STORY_SORCERY_COMPLETE, false):
		interface.create_dialog("sorcery_2", _finished_func)
	else:
		interface.create_dialog("sorcery_3")

#
# Function to be executed once the dialog is completed.
#
func finished():
	#
	# Wrap up the chapter.
	#
	G.set_prop(G.Keys.STORY_SORCERY_COMPLETE, true)
	
	#
	# Create the Broken Vile object so that it can be found in the next chapter.
	#
	var vile = Vile.instance()
	
	vile.set_position(Vector2(120, 804))
	
	get_tree().get_root().add_child(vile)
