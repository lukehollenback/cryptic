extends Interactable

var _finished_func = funcref(self, "finished")

#
# Implementation of Interactable.interact().
#
func interact(interface: Node, _player: Node):
	interface.create_dialog("found_broken_vile", _finished_func)

#
# Function to be executed once the dialog is completed.
#
func finished():
	G.set_prop(G.Keys.INV_BROKEN_VILE, true)
	
	destroy()
