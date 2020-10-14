extends Interactable

var _finished_func = funcref(self, "finished")

#
# Implementation of Interactable.interact().
#
func interact(interface: Node, _player: Node):
	if !G.get_prop(G.Keys.STORY_GHOSTS_COMPLETE, false):
		if !G.get_prop(G.Keys.INV_GHOSTSPEAK_AMULET, false):
			interface.create_dialog("ghosts_1")
		else:
			interface.create_dialog("ghosts_2", _finished_func)
	else:
		interface.create_dialog("ghosts_3")

#
# Function to be executed once the dialog is completed.
#
func finished():
	G.set_prop(G.Keys.STORY_GHOSTS_COMPLETE, true)
