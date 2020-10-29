extends Interactable

const TeleLocation = Vector2(-372, -504)

func _process(_delta):
	#
	# Make sure that the entrance is only interactable once it has been "found".
	#
	if G.get_prop(G.Keys.STORY_GHOSTS_COMPLETE, false) and !is_in_group("interactables"):
		add_to_group("interactables")

#
# Implementation of Interactable.interact().
#
func interact(_interface: Node, player: Node):
	player.set_position(TeleLocation)
