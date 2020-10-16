extends Interactable

var _finished_func = funcref(self, "finished")

#
# Implementation of Interactable.interact().
#
func interact(interface: Node, _player: Node):
	if !G.get_prop(G.Keys.INV_BROKEN_VILE, false):
		interface.create_dialog("apothecary_1")
	elif !G.get_prop(G.Keys.STORY_APOTHECARY_COMPLETE, false):
		interface.create_dialog("apothecary_2", _finished_func)
	else:
		interface.create_dialog("apothecary_3")
	

#
# Function to be executed once the dialog is completed.
#
func finished():
	G.set_prop(G.Keys.INV_GHOSTSPEAK_AMULET, true)
	G.set_prop(G.Keys.STORY_APOTHECARY_COMPLETE, true)
