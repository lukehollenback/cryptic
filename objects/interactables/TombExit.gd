extends Interactable

const TeleLocation = Vector2(120, 804)

#
# Implementation of Interactable.interact().
#
func interact(_interface: Node, player: Node):
	player.set_position(TeleLocation)
