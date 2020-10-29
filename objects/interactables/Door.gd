extends Interactable

export(G.Keys) var key_prop

func _ready():
	#
	# Destroy self immediately if we have already been unlocked in the loaded game.
	#
	if G.get_prop(key_prop, false) && is_instance_valid(_parent):
		destroy()

#
# Implementation of Interactable.interact().
#
func interact(interface: Node, _player: Node):
	if G.get_prop(key_prop, false) && is_instance_valid(_parent):
		destroy()
	else:
		interface.create_dialog("locked_door")
