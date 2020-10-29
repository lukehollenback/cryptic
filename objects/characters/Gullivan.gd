extends Interactable

var _finished_func = funcref(self, "finished")

func _process(_delta):
	#
	# Destroy myself if I've already been found.
	#
	if G.get_prop(G.Keys.STORY_CRYPT_COMPLETE, false):
		destroy()

#
# Implementation of Interactable.interact().
#
func interact(interface: Node, _player: Node):
	if !G.get_prop(G.Keys.STORY_CRYPT_COMPLETE, false):
		interface.create_dialog("crypt_1", _finished_func)

#
# Function to be executed once the dialog is completed.
#
func finished():
	G.set_prop(G.Keys.STORY_CRYPT_COMPLETE, true)
