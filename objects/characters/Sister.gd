extends Interactable

var _finished_func = funcref(self, "finished")

#
# Implementation of Interactable.interact().
#
func interact(interface: Node, _player: Node):
	if !G.get_prop(G.Keys.STORY_WAKING_UP_COMPLETE, false):
		interface.create_dialog("waking_up_1", _finished_func)
	else:
		interface.create_dialog("waking_up_2")

#
# Function to be executed once the dialog is completed.
#
func finished():
	G.set_prop(G.Keys.INV_HOUSE_KEY, true)
	G.set_prop(G.Keys.STORY_WAKING_UP_COMPLETE, true)
