extends Interactable

export(String) var dialog_name

#
# Implementation of Interactable.interact().
#
func interact(interface: Node, _player: Node):
		interface.create_dialog(dialog_name)
