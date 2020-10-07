extends Interactable

export(G.Keys) var key_prop

#
# Implementation of Interactable.interact().
#
func interact(interface: Node, _player: Node):
	if G.get_prop(key_prop, false):
		_parent.queue_free()
	else:
		interface.create_dialog("locked_door")
