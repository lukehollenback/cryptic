extends Interactable

export(G.Keys) var key_prop

#
# Implementation of Interactable.interact().
#
func interact(interface: Node, _player: Node):
	if G.get_prop(G.Keys.INV_HALL_KEY, false):
		interface.create_dialog("found_nothing")
	else:
		var rand = (randi() % 5)
		
		if rand == 0:
			interface.create_dialog("found_hall_key")
			
			G.set_prop(G.Keys.INV_HALL_KEY, true)
		else:
			interface.create_dialog("found_nothing")
